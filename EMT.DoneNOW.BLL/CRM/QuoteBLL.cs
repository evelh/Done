using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text.RegularExpressions;
using System.Data;

namespace EMT.DoneNOW.BLL
{
    public class QuoteBLL
    {
        private readonly crm_quote_dal _dal = new crm_quote_dal();

        /// <summary>
        /// 获取报价相关字典表
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("payment_term", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TERM)));        // 
            dic.Add("payment_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_TYPE)));        // 
            dic.Add("payment_ship_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PAYMENT_SHIP_TYPE)));        // 

            dic.Add("notify_tmpl", new sys_notify_tmpl_dal().GetDictionary());        // 添加商机时的通知模板

            dic.Add("country", new DistrictBLL().GetCountryList());                          // 国家表
            dic.Add("addressdistrict", new d_district_dal().GetDictionary());                       // 地址表（省市县区）

            dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TAX_REGION)));              // 税区
            dic.Add("quote_tmpl", new sys_quote_tmpl_dal().GetQuoteTemp());




            return dic;
        }

        /// <summary>
        /// 插入报价
        /// </summary>
        /// <param name="quote"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(crm_quote quote, long user_id)
        {
            if (quote.account_id == 0 || string.IsNullOrEmpty(quote.name) || (quote.contact_id == 0 && quote.opportunity_id == 0))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;



            #region 3.保存商机
            if (quote.opportunity_id == 0)  // 代表用户未选择商机，此时自动创建商机
            {
                var opportunity = new crm_opportunity()
                {
                    id = _dal.GetNextIdCom(),
                    name = quote.name,
                    account_id = quote.account_id,
                    resource_id = user_id,
                    stage_id = (int)OPPORTUNITY_STAGE.NEW_CLUE,  // todo 取到商机阶段中的最小值
                    status_id = (int)OPPORTUNITY_STATUS.ACTIVE,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    projected_close_date = quote.projected_close_date,
                    use_quote = 1,
                    one_time_cost = 0,
                    one_time_revenue = 0,
                    monthly_cost = 0,
                    monthly_revenue = 0,
                    quarterly_cost = 0,
                    quarterly_revenue = 0,
                    semi_annual_cost = 0,
                    semi_annual_revenue = 0,
                    yearly_cost = 0,
                    yearly_revenue = 0,
                    ext1 = 0,
                    ext2 = 0,
                    ext3 = 0,
                    ext4 = 0,
                    ext5 = 0,
                    spread_value = 0,
                    // create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    create_user_id = user_id,
                    update_user_id = user_id,

                };
                new crm_opportunity_dal().Insert(opportunity);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                    oper_object_id = opportunity.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(opportunity),
                    remark = "保存商机信息"
                });
                quote.opportunity_id = opportunity.id;
            }
            quote.is_primary_quote = 1;
            #endregion
            // 验证该商机下是否有报价，如果是第一个添加的报价，则设置成为主报价
            var quoteList = new crm_quote_dal().GetQuoteByWhere($" and opportunity_id = {quote.opportunity_id} ");
            if (quoteList != null && quoteList.Count > 0)
            {
                quote.is_primary_quote = null;
            }


            #region 1.保存报价
            quote.id = _dal.GetNextIdCom();
            quote.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.create_user_id = user_id;
            quote.update_user_id = user_id;
            quote.payment_term_id = quote.payment_term_id == 0 ? null : quote.payment_term_id;
            quote.payment_type_id = quote.payment_type_id == 0 ? null : quote.payment_type_id;
            quote.shipping_type_id = quote.shipping_type_id == 0 ? null : quote.shipping_type_id;
            quote.tax_region_id = quote.tax_region_id == 0 ? null : quote.tax_region_id;
            quote.quote_tmpl_id = quote.quote_tmpl_id == 0 ? null : quote.quote_tmpl_id;
            _dal.Insert(quote);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                oper_object_id = quote.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(quote),
                remark = "保存报价信息"
            });
            #endregion

            #region 2.保存通知
            #endregion





            return ERROR_CODE.SUCCESS;
        }

        public ERROR_CODE Update(crm_quote quote, long user_id)
        {
            if (quote.account_id == 0 || string.IsNullOrEmpty(quote.name) || (quote.contact_id == 0 && quote.opportunity_id == 0))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var old_quote = _dal.GetQuote(quote.id);

            //if (quote.opportunity_id == 0)  // 代表用户未选择商机，此时自动创建商机
            //{
            //    var opportunity = new crm_opportunity()
            //    {
            //        id = _dal.GetNextIdCom(),
            //        name = quote.name,
            //        resource_id = user_id,
            //        stage_id = (int)OPPORTUNITY_STAGE.NEW_CLUE,  // todo 取到商机阶段中的最小值
            //        status_id = (int)OPPORTUNITY_STATUS.ACTIVE,
            //        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        projected_close_date = quote.projected_close_date,
            //        use_quote = 1,
            //        one_time_cost = 0,
            //        one_time_revenue = 0,
            //        monthly_cost = 0,
            //        monthly_revenue = 0,
            //        quarterly_cost = 0,
            //        quarterly_revenue = 0,
            //        semi_annual_cost = 0,
            //        semi_annual_revenue = 0,
            //        yearly_cost = 0,
            //        yearly_revenue = 0,
            //        ext1 = 0,
            //        ext2 = 0,
            //        ext3 = 0,
            //        ext4 = 0,
            //        ext5 = 0,
            //        // create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        create_user_id = user_id,
            //        update_user_id = user_id,

            //    };
            //    new crm_opportunity_dal().Insert(opportunity);
            //    new sys_oper_log_dal().Insert(new sys_oper_log()
            //    {
            //        user_cate = "用户",
            //        user_id = (int)user.id,
            //        name = user.name,
            //        phone = user.mobile == null ? "" : user.mobile,
            //        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
            //        oper_object_id = opportunity.id,// 操作对象id
            //        oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //        oper_description = _dal.AddValue(opportunity),
            //        remark = "保存商机信息"
            //    });
            //    quote.opportunity_id = opportunity.id;
            //}
            quote.account_id = old_quote.account_id;
            quote.oid = old_quote.oid;
            quote.opportunity_id = old_quote.opportunity_id;
            quote.payment_term_id = quote.payment_term_id == 0 ? null : quote.payment_term_id;
            quote.payment_type_id = quote.payment_type_id == 0 ? null : quote.payment_type_id;
            quote.shipping_type_id = quote.shipping_type_id == 0 ? null : quote.shipping_type_id;
            quote.tax_region_id = quote.tax_region_id == 0 ? null : quote.tax_region_id;
            quote.quote_tmpl_id = old_quote.quote_tmpl_id;
            quote.create_time = old_quote.create_time;
            quote.create_user_id = old_quote.create_user_id;
            quote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote.update_user_id = user_id;
            _dal.Update(quote);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                oper_object_id = quote.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_quote, quote),
                remark = "修改报价信息"
            });
            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 删除报价
        /// </summary>
        /// <param name="quote_id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteQuote(long quote_id, long user_id)
        {
            // todo 报价如果关联了销售订单，则不可删除


            var quote = _dal.GetQuote(quote_id);
            if (quote != null)
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                if (user != null)
                {
                    quote.delete_user_id = user_id;
                    quote.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    _dal.Update(quote);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                        oper_object_id = quote.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                        oper_description = _dal.AddValue(quote),
                        remark = "删除报价"
                    });

                    var quoteItemList = new crm_quote_item_dal().GetQuoteItems(" and quote_id = " + quote.id);   // 删除报价的同时，删除报价下的所有报价项
                    if (quoteItemList != null && quoteItemList.Count > 0)
                    {
                        var quoteItemBLL = new QuoteItemBLL();
                        quoteItemList.ForEach(_ =>
                        {
                            //_.delete_user_id = user_id;
                            //_.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            quoteItemBLL.DeleteQuoteItem(_.id, user.id);
                        });
                    }
                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// 获取到报价项
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_quote GetQuote(long id)
        {
            return _dal.FindSignleBySql<crm_quote>($"select * from crm_quote WHERE id = {id} and delete_time = 0 ");
        }

        /// <summary>
        /// 丢失报价
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="quoteId"></param>
        /// <param name="reasonType">丢失原因类型</param>
        /// <param name="reasonDetail">丢失原因详情</param>
        /// <returns></returns>
        public string LossQuote(long userId, long quoteId, int reasonType, string reasonDetail)
        {
            DicEnum.SYS_CLOSE_OPPORTUNITY needReasonType;
            var type = new SysSettingBLL().GetValueById(SysSettingEnum.CRM_OPPORTUNITY_LOSS_REASON);
            int value = 0;
            if (!int.TryParse(type, out value))
                needReasonType = DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE;
            else
                needReasonType = (DicEnum.SYS_CLOSE_OPPORTUNITY)value;

            // 更新商机状态为丢失
            var opporDal = new crm_opportunity_dal();
            var quote = _dal.FindById(quoteId);
            var oppor = opporDal.FindById(quote.opportunity_id);
            var oldOppor = opporDal.FindById(quote.opportunity_id);
            oppor.status_id = (int)DicEnum.OPPORTUNITY_STATUS.LOST;
            oppor.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            oppor.update_user_id = userId;
            if (needReasonType == SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL)
                oppor.loss_reason = reasonDetail;
            if (needReasonType != SYS_CLOSE_OPPORTUNITY.NEED_NONE)
                oppor.loss_reason_type_id = reasonType;
            opporDal.Update(oppor);

            // 保存操作商机日志
            var user = UserInfoBLL.GetUserInfo(userId);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = userId,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                oper_object_id = oppor.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = opporDal.CompareValue(oldOppor, oppor),
                remark = "丢失报价"
            });

            // 新增通知信息
            var notify_email_dal = new com_notify_email_dal();
            var notify_email = new com_notify_email()
            {
                id = notify_email_dal.GetNextIdCom(),
                cate_id = (int)NOTIFY_CATE.CRM,
                event_id = 1,             // TODO:
                to_email = "",                  // TODO:  
                notify_tmpl_id = 1,    // TODO:
                from_email = user.email,   // todo
                from_email_name = user.name,  // todo 
                subject = "",       // TODO:
                body_text = "",    // TODO:
                is_html_format = 0,                                // 内容是否是html格式，0纯文本 1html
                create_user_id = user.id,
                update_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

            };
            notify_email_dal.Insert(notify_email);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                oper_object_id = notify_email.id,
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = notify_email_dal.AddValue(notify_email),
                remark = "新增通知",
            });  // 插入日志

            return "";
        }

        public ERROR_CODE CloseQuote(long user_id, QuoteCloseDto param)
        {
            // 此向导将会把产品、一次性折扣、配送、成本转为计费项。可选项和费用不会被转换。如果有产品，会生成销售订单。
            // 报价中如果有服务 / 包或初始费用，将不会被转换为计费项，也不会创建定期服务合同
            // 如果商机状态已经是“关闭”或“已实施”，将会为此商机生成重复的计费项。


            // 报价项中如果有物料代码为空的，则需要设置。如果没有需要配置的，则此界面不显示

            // 计费项将会生成，是否需要创建发票

            // 打开新建的销售订单（链接）——如果创建了销售单才显示



            // 关闭报价是关闭商机的另一种方式，

            // -- 必填项校验-- 根据系统设置来判断 TODO
            var user = UserInfoBLL.GetUserInfo(user_id);
            // 1.更新商机信息

            #region 1.更新商机信息
            // 根据系统设置来选择商机的阶段-- todo
            param.opportunity.status_id = (int)DicEnum.OPPORTUNITY_STATUS.CLOSED;

            var stageList = new d_general_dal().GetGeneralByTableId((int)GeneralTableEnum.OPPORTUNITY_STATUS);
            var defaultStage = stageList.FirstOrDefault(_ => _.ext1 == "1");
            if (defaultStage != null)
            {
                param.opportunity.stage_id = defaultStage.id;
            }
            var old_opportunity = new crm_opportunity_dal().GetOpportunityById(param.opportunity.id);
            new crm_opportunity_dal().Update(param.opportunity);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user_id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                oper_object_id = param.opportunity.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_opportunity, param.opportunity),
                remark = "修改商机信息"
            });

            #endregion

            // 2.更新客户信息
            #region 2.更新客户信息
            var account = new CompanyBLL().GetCompany(param.quote.account_id);
            if (account.type_id != (int)DicEnum.ACCOUNT_TYPE.CUSTOMER)
            {
                account.type_id = (int)DicEnum.ACCOUNT_TYPE.CUSTOMER;
                new crm_account_dal().Update(account);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user_id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                    oper_object_id = param.quote.account_id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(new CompanyBLL().GetCompany(param.quote.account_id), account),
                    remark = "修改客户信息"
                });
            }

            #endregion

            long? contact_id = null;
            if (param.opportunity.contact_id != null)
            {
                crm_contact contact = new ContactBLL().GetContact((long)param.opportunity.contact_id);
                if (contact.is_active == 1)
                {
                    contact_id = contact.id;
                }
            }



            // 3.保存项目信息
            #region 3.如果项目关联了项目提案，修改项目提案信息
            if (param.quote.project_id != null)
            {
                var project = new pro_project_dal().GetProjectById((long)param.quote.project_id);
                if (project != null)
                {
                    if (project.type_id != (int)PROJECT_TYPE.ACCOUNT_PROJECT)
                    {
                        project.type_id = (int)PROJECT_TYPE.ACCOUNT_PROJECT;
                        project.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        project.update_user_id = user.id;
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PROJECT,
                            oper_object_id = project.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.CompareValue(new pro_project_dal().GetProjectById((long)param.quote.project_id), project),
                            remark = "修改项目提案类型"

                        });
                        new pro_project_dal().Update(project);
                    }
                    param.project_id = project.id;
                }
            }
            #endregion

            // 4.新增工单信息
            #region 4.如果报价未关联项目提案，有需要转换的计费项
            // todo 关联sdk_ticket

            #endregion


            // 5.转换为工单/项目成本
            #region 5.转换为工单/项目成本
            // todo 关联sdk_ticket_charge
            // 一次性折扣根据需要拆分为两行——收税的、不收税的，分别计算折扣额。计算时仍然按照全部周期为一次性的报价项，而不是排除了服务和工时等报价项。
            #endregion

            // 将报价项转换为计费项

            new OpportunityBLL().InsertContract(param.dic,param.opportunity,user,1,param.project_id);


            // 6.新增销售订单
            #region 6.当有产品/一次性折扣、成本、配送转为计费项时，销售订单就会自动生成。Crm_sales_order
            if (param.dic != null && param.dic.Count > 0)
            {
                var saleOrder = new crm_sales_order_dal().GetSingleSalesOrderByWhere($" and opportunity_id = {param.opportunity.id} ");
                if (saleOrder == null)
                {
                    saleOrder = new crm_sales_order()
                    {
                        id = _dal.GetNextIdCom(),

                        opportunity_id = param.opportunity.id,
                        status_id = (int)SALES_ORDER_STATUS.OPEN,
                        contact_id = contact_id,
                        owner_resource_id = param.opportunity.resource_id,
                        begin_date = DateTime.Now,
                        create_user_id = user.id,
                        update_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    };
                    new crm_sales_order_dal().Insert(saleOrder);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SALE_ORDER,
                        oper_object_id = saleOrder.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(saleOrder),
                        remark = "关闭报价，新增销售订单"
                    });
                    param.saleOrderId = saleOrder.id;
                }
            }


            #endregion

            // 7.新增项目备注
            #region 7.转为项目计费项时，会生成备注
            if (param.quote.project_id != null)
            {
                com_activity addActivity = new com_activity()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = (int)ACTIVITY_CATE.PROJECT_NOTE,
                    action_type_id = (int)ACTIVITY_TYPE.PROJECT_NOTE,
                    parent_id = null,
                    object_id = (long)param.quote.project_id,
                    object_type_id = (int)OBJECT_TYPE.PROJECT,
                    // todo发布范围
                    account_id = param.opportunity.account_id,
                    contact_id = contact_id,
                    resource_id = param.opportunity.resource_id,
                    contract_id = contact_id,
                    opportunity_id = param.opportunity.id,
                    ticket_id = null,
                    // todo 标题
                    description = $"",     // todo 内容描述拼接
                    status_id = null,
                    complete_description = null,
                    complete_time = null,
                    create_user_id = user.id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_user_id = user.id,
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

                };
                new com_activity_dal().Insert(addActivity);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACTIVITY,
                    oper_object_id = addActivity.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(addActivity),
                    remark = "商机关闭，新增项目备注"

                });
            }

            #endregion

            // 8.新增备注（商机关闭）
            #region 8.商机关闭时，会自动生成备注

            com_activity closeOppoActivity = new com_activity()
            {
                id = _dal.GetNextIdCom(),
                cate_id = (int)ACTIVITY_CATE.NOTE,
                action_type_id = (int)ACTIVITY_TYPE.OPPORTUNITYUPDATE,
                parent_id = null,
                object_id = param.opportunity.id,
                object_type_id = (int)OBJECT_TYPE.OPPORTUNITY,
                account_id = param.opportunity.account_id,
                contact_id = contact_id,
                resource_id = param.opportunity.resource_id,
                contract_id = null,         // todo 如果转为合同成本，则为“合同”；否则为空
                opportunity_id = param.opportunity.id,
                ticket_id = null,
                start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),  // todo 从页面获取时间，去页面时间的12：00：00
                end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),
                description = $"关闭时间：{DateTime.Now.ToString("dd/MM/yyyy")}/r通知人：{user.email}/r主题：{param.opportunity.name}已经关闭/r内容：商机关闭向导定义",     // todo 内容描述拼接
                status_id = null,
                complete_description = null,
                complete_time = null,
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

            };

            new com_activity_dal().Insert(closeOppoActivity);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACTIVITY,
                oper_object_id = closeOppoActivity.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(closeOppoActivity),
                remark = "新增关闭商机的备注"
            });

            #endregion

            return ERROR_CODE.SUCCESS;
        }






        public bool SetPrimaryQuote(long user_id, long quote_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var quote = new crm_quote_dal().GetQuote(quote_id);
            if (quote != null)
            {
                var quoteList = new crm_quote_dal().GetQuoteByWhere($" and opportunity_id = {quote.opportunity_id} ");
                var primaryQuote = quoteList.FirstOrDefault(_ => _.is_primary_quote == 1);
                if (primaryQuote != null && quote.id != primaryQuote.id)
                {
                    primaryQuote.is_primary_quote = null;
                    primaryQuote.update_user_id = user.id;
                    primaryQuote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                    var oldPrimaryQuote = new QuoteBLL().GetQuote(primaryQuote.id);

                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                        oper_object_id = primaryQuote.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = _dal.CompareValue(oldPrimaryQuote, primaryQuote),
                        remark = "更改主报价为报价"
                    });
                    new crm_quote_dal().Update(primaryQuote);

                    quote.is_primary_quote = 1;
                    quote.update_user_id = user.id;
                    quote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                        oper_object_id = quote.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = _dal.CompareValue(new crm_quote_dal().GetQuote(quote_id), quote),
                        remark = "更改报价为主报价"
                    });
                    new crm_quote_dal().Update(quote);
                }
                return true;
            }
            return false;
        }


        /// <summary>
        /// 报价单绑定报价模板
        /// </summary>
        /// <param name="cq"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool UpdateQuoteTemp(crm_quote cq, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            cq.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            cq.update_user_id = user_id;
            if (_dal.Update(cq))
            {
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user_id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,

                    oper_object_id = cq.id,// 操作对象id

                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,

                    oper_description = _dal.AddValue(cq),
                    remark = "关联报价模板"
                });

            }
            return true;
        }
        /// <summary>
        /// 返回一个d_tax_region_cate对象
        /// </summary>
        /// <param name="aid"></param>
        /// <param name="bid"></param>
        /// <returns></returns>
        public d_tax_region_cate GetTaxRegion(int aid, int bid)
        {
            var data = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>(@"select * from d_tax_region_cate  where tax_region_id=" + aid + " and tax_cate_id=" + bid + "");
            return data;
        }
        /// <summary>
        /// 返回d_tax_region_cate_tax的list数据集
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<d_tax_region_cate_tax> GetTaxRegiontax(int id)
        {

            var data = new d_tax_region_cate_tax_dal().FindListBySql<d_tax_region_cate_tax>(@"select * from d_tax_region_cate_tax  where tax_region_cate_id=" + id + "");

            return data;
        }

        /// <summary>
        /// 获取税收地区名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetTaxName(int id)
        {
            string name = new d_general_dal().FindById(id).name;
            return name;
        }
        /// <summary>
        /// 获取替换报价模板内的变量
        /// </summary>
        /// <param name="cid"></param>
        /// <param name="aid"></param>
        /// <param name="qid"></param>
        /// <param name="oid"></param>
        /// <returns></returns>
        public DataTable GetVar(int cid, int aid, int qid, int oid)
        {
            var list = _dal.GetVar(cid, aid, qid, oid);
            return list;
        }
        /// <summary>
        /// 获取替换报价子项的数据
        /// </summary>
        /// <param name="qiid"></param>
        /// <returns></returns>
        public DataTable GetQuoteItemVar(int qiid)
        {
            var list = _dal.GetQuoteItemVar(qiid);
            return list;
        }
        /// <summary>
        /// 在报价子项中获取object_id,返回一个产品名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetProductName(int id)
        {
            var d = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time=0");
            if (d != null)
            {
                return d.name;
            }
            else
            {
                return string.Empty;
            }
        }
        public string GetItemTypeName(int id)
        {
            return new d_general_dal().FindById(id).name;
        }
        public int GetTaxid(int tid)
        {
            return (int)new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id={tid}").id;
        }
        /// <summary>
        /// 更改报价的排序方式
        /// </summary>
        /// <param name="quote_id"></param>
        /// <param name="group_id"></param>
        /// <param name="user_id"></param>
        public void UpdateGroup(long quote_id, int group_id, long user_id)
        {
            var quote = _dal.GetQuote(quote_id);
            if (quote.group_by_id != group_id) // 未改变分组不用更改
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                quote.group_by_id = group_id;
                quote.update_user_id = user_id;
                quote.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user_id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE,
                    oper_object_id = quote_id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.CompareValue(_dal.GetQuote(quote_id), quote),
                    remark = "修改报价排序方式"
                });
                _dal.Update(quote);
            }

        }
        /// <summary>
        /// 检查报价是否关联销售订单
        /// </summary>
        /// <param name="quote_id"></param>
        /// <returns></returns>
        public bool CheckRelatSaleOrder(long quote_id)
        {
            var saleOrder = _dal.FindSignleBySql<crm_sales_order>($"SELECT * from crm_sales_order s where  s.opportunity_id  in (  select op.id FROM crm_quote q LEFT JOIN crm_opportunity op on op.id = q.opportunity_id where q.id={quote_id})");

            return saleOrder != null;
        }
        /// <summary>
        /// 获取到商机下的主报价（商机下如果有报价，一个会有主报价）
        /// </summary>
        /// <param name="oppo_id"></param>
        /// <returns></returns>
        public crm_quote GetPrimaryQuote(long oppo_id)
        {
            return _dal.FindSignleBySql<crm_quote>($"select * from crm_quote where is_primary_quote = 1 and opportunity_id={oppo_id} and delete_time=0");
        }
    }
}
