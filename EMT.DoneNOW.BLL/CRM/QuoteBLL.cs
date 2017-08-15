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
using EMT.DoneNOW.BLL.CRM;
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

                    var quoteItemList = new crm_quote_item_dal().GetQuoteItems(" and quote_id = "+quote.id);   // 删除报价的同时，删除报价下的所有报价项
                    if(quoteItemList!=null&& quoteItemList.Count > 0)
                    {
                        var quoteItemBLL = new QuoteItemBLL();
                        quoteItemList.ForEach(_ => {
                            //_.delete_user_id = user_id;
                            //_.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            quoteItemBLL.DeleteQuoteItem(_.id,user.id);
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
                remark = "修改商机信息"
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

        public bool SetPrimaryQuote(long user_id,long quote_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            var quote = new crm_quote_dal().GetQuote(quote_id);
            if (quote != null)
            {
                var quoteList = new crm_quote_dal().GetQuoteByWhere($" and opportunity_id = {quote.opportunity_id} ");
                var primaryQuote = quoteList.FirstOrDefault(_ => _.is_primary_quote == 1);
                if (primaryQuote!=null&&quote.id != primaryQuote.id)
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
        public bool UpdateQuoteTemp(crm_quote cq,long user_id) {
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
        public d_tax_region_cate GetTaxRegion(int aid,int bid) {
            var data = new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>(@"select * from d_tax_region_cate  where tax_region_id="+aid+" and tax_cate_id="+bid+"");
            return data;
        }
        /// <summary>
        /// 返回d_tax_region_cate_tax的list数据集
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<d_tax_region_cate_tax> GetTaxRegiontax(int id)
        {
           
            var data = new d_tax_region_cate_tax_dal().FindListBySql<d_tax_region_cate_tax>(@"select * from d_tax_region_cate_tax  where tax_region_cate_id="+id+"");

            return data;
        }

        /// <summary>
        /// 获取税收地区名称
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public string GetTaxName(int id) {
            string name =new d_general_dal().FindById(id).name;
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
        public DataTable GetVar(int cid, int aid, int qid,int oid)
        {
            var list = _dal.GetVar(cid,aid,qid,oid);
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

        public string GetItemTypeName(int id) {
            return new d_general_dal().FindById(id).name;
        }
        public int GetTaxid(int tid) {
            return (int)new d_tax_region_cate_dal().FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id={tid}").id;
        }
    }
}
