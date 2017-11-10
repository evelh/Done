using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class OpportunityBLL
    {
        private readonly crm_opportunity_dal _dal = new crm_opportunity_dal();

        /// <summary>
        /// 获取商机相关的字典项
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("opportunity_stage", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STAGE)));          // 商机阶段
            dic.Add("opportunity_source", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_SOURCE)));          // 商机来源
            dic.Add("opportunity_interest_degree", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_INTEREST_DEGREE)));          // 商机客户感兴趣程度
            dic.Add("oppportunity_win_reason_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_WIN_REASON_TYPE)));          // 商机赢单原因类型
            dic.Add("oppportunity_loss_reason_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_LOSS_REASON_TYPE)));          // 商机丢单原因类型
            dic.Add("oppportunity_advanced_field", new d_general_dal().GetDictionaryByCode(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD)));          // 商机扩展字段
            dic.Add("oppportunity_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STATUS)));          // 商机状态
            dic.Add("oppportunity_range_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.FORM_TEMPLATE_RANGE_TYPE)));          // 表单模板应用范围
            dic.Add("projected_close_date", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)
                GeneralTableEnum.PROJECTED_CLOSED_DATE)));          // 商机模板项目关闭日期
            dic.Add("notify_tmpl", new sys_notify_tmpl_dal().GetDictionary());        // 添加商机时的通知模板

            dic.Add("classification", new d_account_classification_dal().GetDictionary());    // 分类类别
            dic.Add("country", new DistrictBLL().GetCountryList());                          // 国家表
            dic.Add("addressdistrict", new d_district_dal().GetDictionary());                       // 地址表（省市县区）
            dic.Add("sys_resource", new sys_resource_dal().GetDictionary());                // 客户经理
            dic.Add("competition", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.COMPETITOR)));          // 竞争对手
            dic.Add("market_segment", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.MARKET_SEGMENT)));    // 行业

            dic.Add("territory", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TERRITORY)));              // 销售区域

            dic.Add("sufix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NAME_SUFFIX)));              // 名字后缀
            dic.Add("period_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE))); // 周期类型（一次性，按月，按年等）
            return dic;
        }

        /// <summary>
        /// 获取一个客户下所有商机
        /// </summary>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public List<crm_opportunity> GetOpportunityByCompany(long companyId)
        {
            return _dal.FindListBySql(_dal.QueryStringDeleteFlag($"SELECT * FROM crm_opportunity WHERE account_id='{companyId}'"));
        }

        /// <summary>
        /// 根据商机id查找
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public OpportunityAddOrUpdateDto GetOpportunity(long id)
        {
            var bll = new UserDefinedFieldsBLL();
            crm_opportunity optu = _dal.FindById(id);
            var udf = bll.GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
            var udfValue = bll.GetUdfValue(DicEnum.UDF_CATE.OPPORTUNITY, id, udf);
            // TODO: activity，notify
            return new OpportunityAddOrUpdateDto { general = optu, udf = udfValue };
        }

        /// <summary>
        /// 根据商机id查找
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_opportunity GetOpportunityById(long id)
        {
            return _dal.FindById(id);
        }

        /// <summary>
        /// 新增商机
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(OpportunityAddOrUpdateDto param, long user_id, out string id)
        {
            id = "";
            if (string.IsNullOrEmpty(param.general.name))                     // string必填项校验   || string.IsNullOrEmpty(param.notify.subject)
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失
            if (param.general.account_id == 0 || param.general.resource_id == 0 || param.general.stage_id == 0 || param.general.status_id == 0)  // int 必填项校验
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失   || param.notify.notify_tmpl_id == 0

            var user = UserInfoBLL.GetUserInfo(user_id);

            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失


            // crm_opportunity
            #region 1.保存商机
            param.general.competitor_id = param.general.competitor_id == 0 ? null : param.general.competitor_id;
            param.general.source_id = param.general.source_id == 0 ? null : param.general.source_id;
            param.general.stage_id = param.general.stage_id == 0 ? null : param.general.stage_id;
            param.general.status_id = param.general.status_id == 0 ? null : param.general.status_id;
            param.general.interest_degree_id = param.general.interest_degree_id == 0 ? null : param.general.interest_degree_id;
            param.general.contact_id = param.general.contact_id == 0 ? null : param.general.contact_id;
            param.general.id = _dal.GetNextIdCom();
            param.general.create_user_id = user.id;
            param.general.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.general.update_user_id = user.id;
            param.general.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (param.general.win_reason_type_id == 0)
            {
                param.general.win_reason_type_id = null;
                param.general.win_reason = "";
            }
            if (param.general.loss_reason_type_id == 0)
            {
                param.general.loss_reason_type_id = null;
                param.general.loss_reason = "";
            }

            _dal.Insert(param.general);
            id = param.general.id.ToString();
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                oper_object_id = param.general.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(param.general),
                remark = "保存商机信息"
            });
            #endregion

            #region 2.保存通知   -- 暂时不进行处理
            //param.notify.cate_id = (int)NOTIFY_CATE.CRM;
            //param.notify.event_id = (int)NOTIFY_EVENT.OPPORTUNITY_CREATEDOREDITED;
            //param.notify.id = _dal.GetNextIdCom();
            //param.notify.create_user_id = user.id;
            //param.notify.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //param.notify.update_user_id = user.id;
            //param.notify.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);    
            //param.notify.event_id = (int)NOTIFY_EVENT.OPPORTUNITY_CREATEDOREDITED;
            //new com_notify_email_dal().Insert(param.notify);
            //param.notify.is_success = 0;                    // todo ,发送是否成功，成功扣1，不成功扣0
            //new sys_oper_log_dal().Insert(new sys_oper_log()
            //{
            //    user_cate = "用户",
            //    user_id = (int)user.id,
            //    name = user.name,
            //    phone = user.mobile == null ? "" : user.mobile,
            //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.NOTIFY,
            //    oper_object_id = param.notify.id,// 操作对象id
            //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //    oper_description = _dal.AddValue(param.notify),
            //    remark = "保存通知信息"

            //});
            #endregion

            #region 3.保存活动

            com_activity activity = new com_activity()
            {
                id = _dal.GetNextIdCom(),
                cate_id = (int)ACTIVITY_CATE.NOTE,
                action_type_id = (int)ACTIVITY_TYPE.OPPORTUNITYUPDATE,
                parent_id = null,
                object_id = param.general.id,
                object_type_id = (int)OBJECT_TYPE.OPPORTUNITY,
                account_id = param.general.account_id,
                contact_id = param.general.contact_id,
                resource_id = param.general.resource_id,
                contract_id = null,
                opportunity_id = param.general.id,
                ticket_id = null,
                start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),  // todo 从页面获取时间，去页面时间的12：00：00
                end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),
                description = $"新商机：{param.general.name},全部收益：{ReturnOppoRevenue(param.general.id)}，成交概率:{param.general.probability}，阶段:{new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STAGE)).FirstOrDefault(_ => _.val == param.general.stage_id.ToString()).show}，预计完成时间:{param.general.projected_close_date}，商机负责人:{new sys_resource_dal().GetDictionary().FirstOrDefault(_ => _.val == param.general.resource_id.ToString()).show}，状态:{new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STATUS)).FirstOrDefault(_ => _.val == param.general.status_id.ToString()).show}",     // todo 内容描述拼接
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                is_system_generate = 1,

            };

            new com_activity_dal().Insert(activity);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.NOTIFY,  // tochange   todo 应该时活动，暂时没有
                oper_object_id = activity.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(activity),
                remark = "保存活动信息"

            });
            #endregion


            #region 4.保存商机自定义信息

            var opportunity_udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
            new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.OPPORTUNITY, user.id, param.general.id, opportunity_udfList, param.udf, OPER_LOG_OBJ_CATE.OPPORTUNITY); // 里面有记录日志的方法


            #endregion


            // var optnt = opt.general;
            // optnt.id = _dal.GetNextIdCom();
            //// optnt.opportunity_no = ""; // TODO: 商机号码生成
            // optnt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            // optnt.create_user_id = userId;
            // optnt.update_time = optnt.create_time;
            // optnt.update_user_id = optnt.create_user_id;
            // _dal.Insert(optnt);     // 新增商机
            // // 记录日志
            // sys_oper_log_dal.InsertLog<crm_opportunity>(optnt, optnt.id, userId, DicEnum.OPER_LOG_TYPE.ADD, DicEnum.OPER_LOG_OBJ_CATE.OPPORTUNITY);



            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 更新商机信息
        /// </summary>
        /// <param name="optnt"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public ERROR_CODE Update(OpportunityAddOrUpdateDto param, long user_id)
        {
            // if (string.IsNullOrEmpty(param.general.name) || string.IsNullOrEmpty(param.notify.subject))                     // string必填项校验
            if (string.IsNullOrEmpty(param.general.name))                     // string必填项校验
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失
            // if (param.general.account_id == 0 || param.general.resource_id == 0 || param.general.stage_id == 0 || param.general.status_id == 0 || param.notify.notify_tmpl_id == 0)  // int 必填项校验
            if (param.general.account_id == 0 || param.general.resource_id == 0 || param.general.stage_id == 0 || param.general.status_id == 0)  // int 必填项校验
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失

            var user = UserInfoBLL.GetUserInfo(user_id);

            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失

            var old_opportunity = _dal.GetOpportunityById(param.general.id);

            param.general.oid = old_opportunity.oid;
            param.general.competitor_id = param.general.competitor_id == 0 ? null : param.general.competitor_id;
            param.general.source_id = param.general.source_id == 0 ? null : param.general.source_id;
            param.general.stage_id = param.general.stage_id == 0 ? null : param.general.stage_id;
            param.general.status_id = param.general.status_id == 0 ? null : param.general.status_id;
            param.general.interest_degree_id = param.general.interest_degree_id == 0 ? null : param.general.interest_degree_id;
            param.general.contact_id = param.general.contact_id == 0 ? null : param.general.contact_id;
            if (param.general.win_reason_type_id == 0)
            {
                param.general.win_reason_type_id = null;
                param.general.win_reason = "";
            }
            if (param.general.loss_reason_type_id == 0)
            {
                param.general.loss_reason_type_id = null;
                param.general.loss_reason = "";
            }
            param.general.update_user_id = user_id;
            param.general.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Update(param.general);    // 更改商机
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                oper_object_id = param.general.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_opportunity, param.general),
                remark = "修改商机信息"
            });



            var oppo_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);  // 获取到所有的自定义的字段信息
            if (oppo_list != null && oppo_list.Count > 0)   // 首先判断是否设置自定义字段
            {
                var udf_oppo = param.udf;  // 获取到传过来的自定义字段的值

                if (udf_oppo != null && udf_oppo.Count > 0)   // todo 用户未填写自定义信息为null，是否算更改插日志
                {
                    new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.OPPORTUNITY, oppo_list, param.general.id, udf_oppo, user, DicEnum.OPER_LOG_OBJ_CATE.FROMOPPORTUNITY_EXTENSION_INFORMATION);
                }
            }
            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 按条件查询
        /// </summary>
        /// <returns></returns>
        public List<crm_opportunity> FindList(JObject jsondata)
        {
            OpportunityConditionDto condition = jsondata.ToObject<OpportunityConditionDto>();
            string orderby = ((JValue)(jsondata.SelectToken("orderby"))).Value.ToString();
            string page = ((JValue)(jsondata.SelectToken("page"))).Value.ToString();
            int pagenum;
            if (!int.TryParse(page, out pagenum))
                pagenum = 1;
            return _dal.Find(condition, pagenum, orderby);
        }

        /// <summary>
        /// 删除商机
        /// </summary>
        /// <param name="id"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public bool DeleteOpportunity(long opportunity_id, long user_id)
        {
            var opportunity = _dal.GetOpportunityById(opportunity_id);
            if (opportunity != null)
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                opportunity.delete_user_id = user_id;
                opportunity.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                _dal.Update(opportunity);

                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.OPPORTUNITY,
                    oper_object_id = opportunity.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                    oper_description = _dal.AddValue(opportunity),
                    remark = "删除商机"
                });



                var quoteBLL = new QuoteBLL();
                var quoteList = new crm_quote_dal().GetQuoteByWhere(" and opportunity_id=" + opportunity.id);
                if (quoteList != null && quoteList.Count > 0)
                {
                    quoteList.ForEach(_ =>
                    {
                        //_.delete_user_id = user_id;
                        //_.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        quoteBLL.DeleteQuote(_.id, user.id);
                    });
                }


            }
            else
            {
                return false;
            }
            return true;
            /*
            crm_opportunity contact = GetOpportunity(id);
            contact.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contact.delete_user_id = CachedInfoBLL.GetUserInfo(token).id;
            // TODO: 日志
            return _dal.SoftDelete(contact,id);
            */
        }

        /// <summary>
        /// 关闭商机(赢得商机)
        /// </summary>
        /// <param name="param"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE CloseOpportunity(CloseOpportunityDto param, long user_id)
        {
            var closeSetting = new SysSettingBLL().GetSetById(SysSettingEnum.CRM_OPPORTUNITY_WIN_REASON);
            if (closeSetting.setting_value != ((int)DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE).ToString())
            {
                if (param.opportunity.win_reason_type_id == 0)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            else if (closeSetting.setting_value == ((int)DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL).ToString())
            {
                if (string.IsNullOrEmpty(param.opportunity.win_reason))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            // todo 根据页面的勾选情况进行不同的必填项验证


            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            #region 处理逻辑1. 修改商机相关信息
            param.opportunity.status_id = (int)OPPORTUNITY_STATUS.CLOSED;
            var updateDto = new OpportunityAddOrUpdateDto()
            {
                general = param.opportunity,
            };
            Update(updateDto, user.id);
            #endregion
            #region 2.更新客户信息
            // 如果商机客户类型不是“客户”或者需要补充地址信息中心，则修改客户信息
            // 目前客户地址是必填无需补充，所以暂时只判断客户类型即可
            var account = new CompanyBLL().GetCompany(param.opportunity.account_id);
            if (account != null)
            {
                if (account.type_id != (int)DicEnum.ACCOUNT_TYPE.CUSTOMER)
                {
                    account.type_id = (int)DicEnum.ACCOUNT_TYPE.CUSTOMER;
                    account.update_user_id = user.id;
                    account.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                        oper_object_id = account.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = _dal.CompareValue(new CompanyBLL().GetCompany(param.opportunity.account_id), account),
                        remark = "修改客户类型"

                    });
                    new crm_account_dal().Update(account);

                }
            }
            #endregion
            long? contact_id = null;
            if (param.opportunity.contact_id != null)
            {
                var contact = new ContactBLL().GetContact((long)param.opportunity.contact_id);
                if (contact != null && contact.is_active == 1)
                {
                    contact_id = contact.id;
                }
            }
            var priQuote = new QuoteBLL().GetPrimaryQuote(param.opportunity.id);
            List<crm_quote_item> quoteItemList = null;
            if (priQuote != null)
            {
                quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id = {priQuote.id}");
            }
            #region 3.保存项目信息
            if (param.activateProject) // 代表用户勾选了从报价激活项目提案
            {
                // ctt_contract_cost 计费项表
                if (priQuote != null && priQuote.project_id != null)
                {
                    var project = new pro_project_dal().GetProjectById((long)priQuote.project_id);
                    if (project != null)
                    {
                        project.type_id = (int)PROJECT_TYPE.ACCOUNT_PROJECT;
                        if (project.labor_revenue == 0)
                        {
                            project.labor_revenue = ReturnOppoRevenue(param.opportunity.id);
                        }
                        if (project.labor_budget == 0)
                        {
                            project.labor_budget = ReturnOppoCost(param.opportunity.id);
                        }
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
                            oper_description = _dal.CompareValue(new pro_project_dal().GetProjectById((long)priQuote.project_id), project),
                            remark = "修改项目提案类型"

                        });
                        new pro_project_dal().Update(project);
                    }
                }
            }
            #endregion

            // 新增合同和更新合同二选一的关系
            #region 4.新增合同信息 -- todo 需求逻辑（二，三，四，五）
            if (param.createContract) // 代表用户勾选了创建周期服务合同
            {
                var lastAddContract = new ctt_contract_dal().GetLastAddContract();
                // 新创建合同对象
                var thisProced = 1;
                if (param.contract.occurrences == null)
                {
                    thisProced = (int)ReturnPeriod(param.contract.start_date, param.contract.end_date, (int)param.contract.period_type);
                }
                else
                {
                    thisProced = (int)param.contract.occurrences;
                }

                var thisEndDate = DateTime.Now;
                if (param.contract.end_date > Convert.ToDateTime("0002-01-01"))
                {
                    thisEndDate = param.contract.end_date;
                }
                else
                {
                    thisEndDate = param.contract.start_date.AddMonths(thisProced * ReturnMonths((int)param.contract.period_type)).AddDays(-1);
                }
                decimal? setup_fee = null;   // 初始费用报价项
                if (priQuote != null)
                {
                    var thisStatrItem = new crm_quote_item_dal().GetStartItem(priQuote.id);
                    if (thisStatrItem != null)
                    {
                        setup_fee = thisStatrItem.unit_price;
                    }
                }
                var contract = new ctt_contract()
                {
                    id = _dal.GetNextIdCom(),
                    name = param.contract.name,
                    account_id = param.opportunity.account_id,
                    is_sdt_default = 0,
                    type_id = (int)CONTRACT_TYPE.SERVICE,
                    contact_id = contact_id,
                    status_id = 1,
                    period_type = param.contract.period_type,
                    start_date = param.contract.start_date,
                    end_date = thisEndDate,
                    // occurrences = param.contract.occurrences,
                    description = "",
                    cate_id = lastAddContract == null ? null : lastAddContract.cate_id,
                    external_no = null,
                    sla_id = lastAddContract == null ? null : lastAddContract.sla_id,
                    setup_fee = setup_fee,
                    timeentry_need_begin_end = lastAddContract == null ? (sbyte)1 : lastAddContract.timeentry_need_begin_end,
                    occurrences = thisProced,
                    // 通知接收人？？todo 
                    create_user_id = user.id,
                    update_user_id = user.id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

                };
                new ctt_contract_dal().Insert(contract);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT,
                    oper_object_id = contract.id,
                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                    oper_description = _dal.AddValue(contract),
                    remark = "商机关闭，创建合同"

                });

                var udf_contract_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);  // 
                List<UserDefinedFieldValue> udf_general_list = null;
                new UserDefinedFieldsBLL().SaveUdfValue(DicEnum.UDF_CATE.CONTRACTS, user.id, contract.id, udf_contract_list, udf_general_list, OPER_LOG_OBJ_CATE.CONTRACT_EXTENSION);

                if (quoteItemList != null && quoteItemList.Count > 0)
                {
                    var serviceItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE && _.optional != 1).ToList();
                    if (serviceItem != null && serviceItem.Count > 0)
                    {
                        var conSerDal = new ctt_contract_service_dal();
                        var conserPriDal = new ctt_contract_service_period_dal();
                        var ivtSerBunSerDal = new ivt_service_bundle_service_dal();
                        var ccspbsDal = new ctt_contract_service_period_bundle_service_dal();
                        var ccsbsDal = new ctt_contract_service_bundle_service_dal();
                        var ccsabsDal = new ctt_contract_service_adjust_bundle_service_dal();
                        var ivtSerDal = new ivt_service_dal();

                        foreach (var item in serviceItem)
                        {
                            var isService = isServiceOrBag((long)item.object_id);
                            ctt_contract_service conService = new ctt_contract_service()
                            {
                                id = _dal.GetNextIdCom(),
                                contract_id = contract.id,
                                object_id = (long)item.object_id,
                                object_type = (sbyte)isService,
                                effective_date = param.contract.start_date,
                                unit_cost = item.unit_cost,
                                unit_price = item.unit_price,
                                adjusted_price = item.unit_price * item.quantity,
                                quantity = (int)item.quantity,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            };
                            conSerDal.Insert(conService);
                            new sys_oper_log_dal().Insert(new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE,
                                oper_object_id = conService.id,
                                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                oper_description = _dal.AddValue(conService),
                                remark = "创建合同服务"

                            });

                            var period = ReturnPeriod(contract.start_date, contract.end_date, (int)contract.period_type);
                            var startTime = param.contract.start_date;

                            for (int i = 0; i < period; i++)
                            {
                                var endDate = startTime.AddMonths(ReturnMonths((int)param.contract.period_type)).AddDays(-1);

                                if (i == period - 1)
                                {
                                    endDate = thisEndDate;
                                }

                                ctt_contract_service_period thisSerPri = new ctt_contract_service_period()
                                {
                                    id = conserPriDal.GetNextIdCom(),
                                    contract_id = contract.id,
                                    contract_service_id = conService.id,
                                    object_id = (long)item.object_id,
                                    object_type = (sbyte)isService,
                                    period_begin_date = startTime,
                                    period_end_date = param.contract.period_type == (int)QUOTE_ITEM_PERIOD_TYPE.ONE_TIME ? param.contract.end_date : endDate,
                                    quantity = (int)item.quantity,
                                    period_adjusted_price = item.unit_price * item.quantity,
                                    period_cost = item.quantity * item.unit_cost,
                                    period_price = item.quantity * item.unit_price,
                                    create_user_id = user.id,
                                    update_user_id = user.id,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

                                };
                                conserPriDal.Insert(thisSerPri);
                                new sys_oper_log_dal().Insert(new sys_oper_log()
                                {
                                    user_cate = "用户",
                                    user_id = (int)user.id,
                                    name = user.name,
                                    phone = user.mobile == null ? "" : user.mobile,
                                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE_PERIOD,
                                    oper_object_id = thisSerPri.id,
                                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                    oper_description = _dal.AddValue(thisSerPri),
                                    remark = "创建合同分期服务"

                                });


                                startTime = startTime.AddMonths(ReturnMonths((int)param.contract.period_type));


                                if (isService == 2)
                                {
                                    var serIdList = ivtSerBunSerDal.GetSerList((long)item.object_id);
                                    if (serIdList != null && serIdList.Count > 0)
                                    {
                                        foreach (var serID in serIdList)
                                        {
                                            var ivtSer = ivtSerDal.FindNoDeleteById(serID.id);
                                            if (ivtSer == null)
                                                continue;
                                            ctt_contract_service_period_bundle_service ccspbs = new ctt_contract_service_period_bundle_service()
                                            {
                                                id = _dal.GetNextIdCom(),
                                                contract_service_period_id = thisSerPri.id,
                                                service_id = serID.service_id,
                                                vendor_account_id = ivtSer.vendor_id,
                                                period_cost = ivtSer.unit_cost == null ? 0 : (decimal)ivtSer.unit_cost,
                                            };
                                            ccspbsDal.Insert(ccspbs);
                                            new sys_oper_log_dal().Insert(new sys_oper_log()
                                            {
                                                user_cate = "用户",
                                                user_id = (int)user.id,
                                                name = user.name,
                                                phone = user.mobile == null ? "" : user.mobile,
                                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE,
                                                oper_object_id = ccspbs.id,
                                                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                                oper_description = _dal.AddValue(ccspbs),
                                                remark = ""

                                            });


                                            //ctt_contract_service_adjust_bundle_service ccsabs = new ctt_contract_service_adjust_bundle_service()
                                            //{
                                            //    id = ccsabsDal.GetNextIdCom(),
                                            //    contract_service_adjust_id = 
                                            //};
                                        }
                                    }
                                }
                            }
                            if (isService == 2) // 代表是服务包
                            {
                                var serIdList = ivtSerBunSerDal.GetSerList((long)item.object_id);
                                if (serIdList != null && serIdList.Count > 0)
                                {
                                    foreach (var serID in serIdList)
                                    {
                                        ctt_contract_service_bundle_service ccsbs = new ctt_contract_service_bundle_service()
                                        {
                                            id = _dal.GetNextIdCom(),
                                            contract_service_id = conService.id,
                                            service_id = serID.id,
                                        };
                                        ccsbsDal.Insert(ccsbs);
                                        new sys_oper_log_dal().Insert(new sys_oper_log()
                                        {
                                            user_cate = "用户",
                                            user_id = (int)user.id,
                                            name = user.name,
                                            phone = user.mobile == null ? "" : user.mobile,
                                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE,
                                            oper_object_id = ccsbs.id,
                                            oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                            oper_description = _dal.AddValue(ccsbs),
                                            remark = ""

                                        });
                                    }
                                }
                            }
                        }
                    }
                }


                // 同时将生成的计费项关联到新合同
                param.contract.id = contract.id;
            }

            #endregion

            #region 5.更新合同信息
            if (param.addServicesToExistingContract) // 代表用户勾选了将服务加入已存在的定期服务合同
            {
                var oldContract = new ctt_contract_dal().GetSingleContract(param.contract.id);

                if (quoteItemList != null && quoteItemList.Count > 0)
                {
                    var startCostItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.START_COST).ToList();
                    if (startCostItem != null && startCostItem.Count > 0)
                    {
                        var sum = startCostItem.Sum(_ => (_.quantity != null && _.unit_price != null) ? _.quantity * _.unit_price : 0);

                        if (oldContract.setup_fee == null || oldContract.setup_fee == 0)
                        {
                            if (sum != null && sum != 0)
                            {
                                oldContract.setup_fee = sum;
                                oldContract.update_user_id = user.id;
                                oldContract.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                                new sys_oper_log_dal().Insert(new sys_oper_log()
                                {
                                    user_cate = "用户",
                                    user_id = (int)user.id,
                                    name = user.name,
                                    phone = user.mobile == null ? "" : user.mobile,
                                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT,
                                    oper_object_id = oldContract.id,
                                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                    oper_description = _dal.CompareValue(new ctt_contract_dal().GetSingleContract(oldContract.id), oldContract),
                                    remark = "商机关闭，更新合同信息"

                                });
                                new ctt_contract_dal().Update(oldContract);
                            }
                        }
                    }
                }

                // （二） 报价项中的服务/包，合同中不存在，插入服务包
                var ccsDal = new ctt_contract_service_dal();
                var conServiceList = new ctt_contract_service_dal().GetConSerList(param.contract.id);
                if (quoteItemList != null && quoteItemList.Count > 0)
                {
                    var serviceItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE).ToList();
                    if (serviceItem != null && serviceItem.Count > 0)
                    {
                        serviceItem.ForEach(_ =>
                        {
                            // 如果报价的服务/包在合同中不存在，则插入服务/包信息
                            if (conServiceList.Any(csl => csl.object_id != _.object_id))
                            {
                                // 新增
                                var service = new ctt_contract_service()
                                {
                                    id = _dal.GetNextIdCom(),
                                    effective_date = param.effective_date,
                                    object_id = (long)_.object_id,
                                    object_type = (sbyte)isServiceOrBag((int)_.object_id),
                                    unit_price = _.unit_price,
                                    unit_cost = _.unit_cost,
                                    quantity = _.quantity == null ? 0 : (int)_.quantity,
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    create_user_id = user.id,
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_user_id = user.id,
                                };
                                ccsDal.Insert(service);
                                new sys_oper_log_dal().Insert(new sys_oper_log()
                                {
                                    user_cate = "用户",
                                    user_id = (int)user.id,
                                    name = user.name,
                                    phone = user.mobile == null ? "" : user.mobile,
                                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE,
                                    oper_object_id = service.id,// 操作对象id
                                    oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                    oper_description = _dal.AddValue(service),
                                    remark = "新增合同服务项"

                                });
                            }
                            else // 如果报价的服务/包在合同中存在，且用户选择了更新操作，则更新服务/包信息
                            {
                                if (param.isAddService)
                                {
                                    var conSer = conServiceList.FirstOrDefault(cs => cs.object_id == _.object_id);
                                    if (conSer != null)
                                    {
                                        conSer.effective_date = param.effective_date;
                                        if (param.isUpdatePrice)
                                        {
                                            conSer.unit_price = _.unit_price;
                                        }
                                        if (param.isUpdateCost)
                                        {
                                            conSer.unit_cost = _.unit_cost;
                                        }
                                        conSer.quantity += (int)_.quantity;
                                        new sys_oper_log_dal().Insert(new sys_oper_log()
                                        {
                                            user_cate = "用户",
                                            user_id = (int)user.id,
                                            name = user.name,
                                            phone = user.mobile == null ? "" : user.mobile,
                                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_SERVICE,
                                            oper_object_id = conSer.id,// 操作对象id
                                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                                            oper_description = _dal.CompareValue(ccsDal.GetSinConSer(conSer.id), conSer),
                                            remark = "修改合同服务项"

                                        });
                                        ccsDal.Update(conSer);
                                    }
                                }
                            }

                        });
                    }
                }

            }

            #endregion

            // createTicketPostSaleQueue
            #region 6.新增工单信息
            if (param.createTicketPostSaleQueue) // 代表用户勾选了创建服务台工单售后队列
            {


            }

            #endregion
            string ids = "";
            #region 7.转换为工单/项目/合同成本，不包括——转换为工单成本（新建已完成工单）逻辑
            if (param.convertToServiceTicket)
            {

            }
            else if (param.convertToNewContractt || param.convertToOldContract)
            {   // 
                InsertContract(param.costCodeList, param.opportunity, user, param.contract.id, out ids, null);
            }
            else if (param.convertToProject)
            {
                 InsertContract(param.costCodeList, param.opportunity, user, null, out ids, priQuote.project_id, null);
            }
            else if (param.convertToTicket)
            {

            }

            #endregion

            #region 9.新增通知信息
            //com_notify_email notity = new com_notify_email() {
            //    id = _dal.GetNextIdCom(),
            //    cate_id = (int)NOTIFY_CATE.CRM,
            //    event_id = (int)NOTIFY_EVENT.OPPORTUNITY_CLOSED,
            //    create_user_id = user.id,
            //    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    update_user_id = user.id,
            //    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    to_email = "",   // 界面输入，包括发送对象、员工、其他地址等四个部分组成
            //    notify_tmpl_id = 0,  // 根据通知模板
            //    from_email = notifyTemp.from_other_email,
            //    from_email_name = notifyTemp.from_other_email_name,
            //    body_text = opportunityDto.notify.body_text + notifyTemp.body_text,
            //    body_html = opportunityDto.notify.body_html + notifyTemp.body_html,
            //    subject = opportunityDto.notify.subject,
            //    is_html_format = notifyTemp.is_html_format,// 
            //};

            #endregion

            #region 10.新增销售订单  
            if (param.isIncludeCharges || param.isIncludePO || param.isIncludeShip)
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
                        remark = "商机关闭，新增销售订单"
                    });
                    param.saleOrderId = saleOrder.id;
                }

            }

            #endregion


            #region 12.新增项目备注/合同备注
            // todo 只有转为合同/ 项目计费项时，才会生成备注。工单不会生成
            if (param.convertToNewContractt || param.convertToOldContract || param.convertToProject)
            {
                bool isProject = param.convertToProject;
                com_activity addActivity = new com_activity()
                {
                    id = _dal.GetNextIdCom(),
                    cate_id = isProject ? (int)ACTIVITY_CATE.PROJECT_NOTE : (int)ACTIVITY_CATE.CONTRACT_NOTE,
                    action_type_id = isProject ? (int)ACTIVITY_TYPE.PROJECT_NOTE : (int)ACTIVITY_TYPE.CONTRACT_NOTE,// 根据项目/合同 去设置
                    parent_id = null,
                    object_id = param.opportunity.id,
                    object_type_id = isProject ? (int)OBJECT_TYPE.PROJECT : (int)OBJECT_TYPE.CONTRACT,
                    account_id = param.opportunity.account_id,
                    contact_id = contact_id,
                    resource_id = param.opportunity.resource_id,
                    contract_id = null,// todo - 如果转为合同成本，则为“合同ID”；否则为空
                    opportunity_id = param.opportunity.id,
                    name= "项目的产品/运输/成本/一次性折扣被转换为"+(isProject?"项目":"合同")+"成本",
                    ticket_id = null,
                    start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),  // todo 从页面获取时间，去页面时间的12：00：00
                    end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),
                    description = $"",     // todo 内容描述拼接
                    status_id = null,
                    complete_description = null,
                    complete_time = null,
                    create_user_id = user.id,
                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    update_user_id = user.id,
                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    publish_type_id = isProject ? (int)NOTE_PUBLISH_TYPE.PROJECT_INTERNA_USER : (int)NOTE_PUBLISH_TYPE.CONTRACT_INTERNA_USER,
                    is_system_generate = 1,

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
                    remark = "商机关闭，创建备注"

                });
            }



            #endregion


            #region 13.新增备注-商机关闭的备注
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
                contract_id = null,// todo - 如果转为合同成本，则为“合同ID”；否则为空
                opportunity_id = param.opportunity.id,
                ticket_id = null,
                start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),  // todo 从页面获取时间，去页面时间的12：00：00
                end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),
                description = $"",     // todo 内容描述拼接
                status_id = null,
                complete_description = null,
                complete_time = null,
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                is_system_generate = 1,

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
                remark = "商机关闭，创建备注"

            });

            #endregion
            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 将报价项转换为计费项
        /// </summary>
        public void InsertContract(Dictionary<long, string> costCodeList, crm_opportunity opportunity, UserInfoDto user, long? contract_id, out string ids, long? project_id = null, long? tickte_id = null)
        {
            ids = "";
            var qiDal = new crm_quote_item_dal();
            var cccDal = new ctt_contract_cost_dal();
            var qiBLL = new QuoteItemBLL();
            if (costCodeList != null && costCodeList.Count > 0)
            {
                foreach (var item in costCodeList)
                {
                    var quote_item = qiDal.GetQuoteItem(item.Key);
                    if (quote_item == null)
                    {
                        continue;
                    }
                    long? product_id = null;
                    int status_id = 0;
                    if (quote_item.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT)
                    {
                        product_id = quote_item.object_id;
                        status_id = (int)COST_STATUS.PENDING_PURCHASE;
                    }
                    else
                    {
                        status_id = (int)COST_STATUS.PENDING_DELIVERY;
                    }
                    int subCateid = 0;
                    if (contract_id != null)
                    {
                        subCateid = (int)BILLING_ENTITY_SUB_TYPE.CONTRACT_COST;
                    }
                    else if (project_id != null)
                    {
                        subCateid = (int)BILLING_ENTITY_SUB_TYPE.TICKET_COST;
                    }
                    else
                    {
                        subCateid = (int)BILLING_ENTITY_SUB_TYPE.PROJECT_COST;
                    }

                    if (quote_item.type_id != (int)QUOTE_ITEM_TYPE.DISCOUNT)
                    {
                        ctt_contract_cost cost = new ctt_contract_cost()
                        {
                            id = _dal.GetNextIdCom(),
                            opportunity_id = (int)opportunity.id,
                            quote_item_id = (int)item.Key,
                            cost_code_id = long.Parse(item.Value),
                            product_id = product_id,
                            name = quote_item.name,
                            description = quote_item.description,
                            date_purchased = DateTime.Now,
                            is_billable = 1,
                            bill_status = 0,
                            cost_type_id = (int)COST_TYPE.OPERATIONA,
                            status_id = status_id,
                            quantity = quote_item.quantity,
                            unit_price = quote_item.unit_price,
                            unit_cost = quote_item.unit_cost,
                            extended_price = quote_item.unit_price * quote_item.quantity,
                            create_user_id = user.id,
                            update_user_id = user.id,
                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            project_id = project_id,
                            contract_id = contract_id,
                            ticket_id = tickte_id,
                            sub_cate_id = subCateid,
                        };
                        cccDal.Insert(cost);
                        ids += cost.id.ToString() + ",";
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,
                            oper_object_id = cost.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.ADD,
                            oper_description = _dal.AddValue(cost),
                            remark = "将报价项转换为计费项"

                        });
                    }
                    else
                    {
                        var qiList = qiDal.GetItemsByItemID(quote_item.id);
                        if (qiList != null && qiList.Count > 0)
                        {
                            var oneItem = qiList.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME && _.optional == 0 && _.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES).ToList();

                            var taxMoney = qiBLL.GetOneTimeMoneyTax(oneItem, quote_item);
                            BILLING_ENTITY_SUB_TYPE sub_cate = BILLING_ENTITY_SUB_TYPE.CONTRACT_COST;
                            if (project_id != null)
                            {
                                sub_cate = BILLING_ENTITY_SUB_TYPE.PROJECT_COST;
                            }
                            if (tickte_id != null)
                            {
                                sub_cate = BILLING_ENTITY_SUB_TYPE.TICKET_COST;
                            }
                            ctt_contract_cost taxCost = new ctt_contract_cost()
                            {
                                id = _dal.GetNextIdCom(),
                                opportunity_id = (int)opportunity.id,
                                quote_item_id = (int)item.Key,
                                cost_code_id = long.Parse(item.Value),
                                product_id = product_id,
                                name = quote_item.name + "(包含税)",
                                description = quote_item.description,
                                date_purchased = DateTime.Now,
                                is_billable = 1,
                                cost_type_id = (int)COST_TYPE.OPERATIONA,
                                status_id = status_id,
                                quantity = quote_item.quantity,
                                unit_price = taxMoney,
                                unit_cost = quote_item.unit_cost,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                project_id = project_id,
                                contract_id = contract_id,
                                sub_cate_id = (int)subCateid,
                            };
                            cccDal.Insert(taxCost);
                            ids += taxCost.id.ToString() + ",";
                            new sys_oper_log_dal().Insert(new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,
                                oper_object_id = taxCost.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                oper_description = _dal.AddValue(taxCost),
                                remark = "赢得商机时将报价项转换为计费项"

                            });

                            ctt_contract_cost noTaxCost = new ctt_contract_cost()
                            {
                                id = _dal.GetNextIdCom(),
                                opportunity_id = (int)opportunity.id,
                                quote_item_id = (int)item.Key,
                                cost_code_id = long.Parse(item.Value),
                                product_id = product_id,
                                name = quote_item.name + "(不包含税)",
                                description = quote_item.description,
                                date_purchased = DateTime.Now,
                                is_billable = 1,
                                cost_type_id = (int)COST_TYPE.OPERATIONA,
                                status_id = status_id,
                                quantity = quote_item.quantity,
                                unit_price = taxMoney,
                                unit_cost = quote_item.unit_cost,
                                create_user_id = user.id,
                                update_user_id = user.id,
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                project_id = project_id,
                                contract_id = contract_id,
                                sub_cate_id = subCateid,
                            };
                            cccDal.Insert(noTaxCost);
                            ids += noTaxCost.id.ToString() + ",";
                            new sys_oper_log_dal().Insert(new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = (int)user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTRACT_COST,
                                oper_object_id = noTaxCost.id,// 操作对象id
                                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                                oper_description = _dal.AddValue(noTaxCost),
                                remark = "赢得商机时将报价项转换为计费项"

                            });
                        }
                    }

                }
            }


        }
        public ERROR_CODE LoseOpportunity(LoseOpportunityDto opportunityDto, long user_id)
        {

            // 1.修改商机信息
            // 2.保存通知
            // 3.新增商机丢失的备注
            // 4.新增销售订单取消的备注
            // 5.商机关联的销售单未被实施，或者部分实施，则销售单将被取消


            // 验证必填参数-- 根据系统设置决定是否校验（todo）
            var lostSetting = new SysSettingBLL().GetSetById(SysSettingEnum.CRM_OPPORTUNITY_LOSS_REASON);
            // 根据系统设置来进行必填项的验证
            if (lostSetting.setting_value != ((int)DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_NONE).ToString())
            {
                if (opportunityDto.opportunity.loss_reason_type_id == 0)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            else if (lostSetting.setting_value == ((int)DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL).ToString())
            {
                if (string.IsNullOrEmpty(opportunityDto.opportunity.loss_reason))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }


            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失


            #region 处理逻辑1. 修改商机相关信息
            var updateDto = new OpportunityAddOrUpdateDto()
            {
                general = opportunityDto.opportunity,
            };
            Update(updateDto, user.id);
            #endregion


            #region 处理逻辑2. 保存通知

            //var notifyTemp = new sys_notify_tmpl_email_dal().FindSignleBySql<sys_notify_tmpl_email>($"select * from sys_notify_tmpl_email where id= {opportunityDto.notifyTempId}");  // 获取到通知模板


            // 生成通知对象
            //var notifyEmail = new com_notify_email()
            //{
            //    cate_id = (int)NOTIFY_CATE.CRM,
            //    event_id = (int)NOTIFY_EVENT.OPPORTUNITY_LOST,
            //    id = _dal.GetNextIdCom(),
            //    create_user_id = user.id,
            //    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    update_user_id = user.id,
            //    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    to_email = opportunityDto.notify.to_email,
            //    notify_tmpl_id = opportunityDto.notifyTempId,
            //    from_email = notifyTemp.from_other_email,
            //    from_email_name = notifyTemp.from_other_email_name,
            //    body_text = opportunityDto.notify.body_text + notifyTemp.body_text,
            //    body_html = opportunityDto.notify.body_html + notifyTemp.body_html,
            //    subject = opportunityDto.notify.subject,
            //    is_html_format = notifyTemp.is_html_format,// 
            //                                               // 是否发送 ==--todo
            //};
            //new com_notify_email_dal().Insert(notifyEmail);
            //new sys_oper_log_dal().Insert(new sys_oper_log()
            //{
            //    user_cate = "用户",
            //    user_id = (int)user.id,
            //    name = user.name,
            //    phone = user.mobile == null ? "" : user.mobile,
            //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.NOTIFY,
            //    oper_object_id = notifyTemp.id,// 操作对象id
            //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //    oper_description = _dal.AddValue(notifyTemp),
            //    remark = "商机丢失新增通知信息"

            //});


            #endregion

            #region 处理逻辑3. 新增备注  商机丢失时，会自动生成商机丢失备注
            // 若商机关联的联系人为激活状态，则为该联系人，否则空
            long? contact_id = null;
            if (opportunityDto.opportunity.contact_id != null)
            {
                var contact = new ContactBLL().GetContact((long)opportunityDto.opportunity.contact_id);
                if (opportunityDto.opportunity.contact_id != null && (contact != null))
                {
                    if (contact.is_active == 1)
                    {
                        contact_id = contact.id;
                    }
                }
            }

            // 创建丢失商机的活动对象
            com_activity loseOppoActivity = new com_activity()
            {
                id = _dal.GetNextIdCom(),
                cate_id = (int)ACTIVITY_CATE.NOTE,
                action_type_id = (int)ACTIVITY_TYPE.OPPORTUNITYUPDATE,
                parent_id = null,
                object_id = opportunityDto.opportunity.id,
                object_type_id = (int)OBJECT_TYPE.OPPORTUNITY,
                account_id = opportunityDto.opportunity.account_id,
                contact_id = contact_id,
                resource_id = opportunityDto.opportunity.resource_id,
                contract_id = null,
                opportunity_id = opportunityDto.opportunity.id,
                ticket_id = null,
                start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),  // todo 从页面获取时间，去页面时间的12：00：00
                end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),
                description = "",// todo 通知暂时不做，做通知时，将内容补上
                                 // description = $"关闭时间：{DateTime.Now.ToString("dd/MM/yyyy")} /r  通知对象:{notifyEmail.to_email} /r 主题：{notifyEmail.subject} /r 内容 ：{notifyEmail.body_text}",     // todo 内容描述拼接
                // status_id = (int)OPPORTUNITY_STATUS.LOST,
                complete_description = null,
                complete_time = null,
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                is_system_generate = 1,

            };

            new com_activity_dal().Insert(loseOppoActivity);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACTIVITY,
                oper_object_id = loseOppoActivity.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(loseOppoActivity),
                remark = "新增丢失商机的备注"

            });

            #endregion

            #region 处理逻辑4.  新增备注--销售订单取消备注
            com_activity cancelSaleOrderActivity = new com_activity()
            {
                id = _dal.GetNextIdCom(),
                cate_id = (int)ACTIVITY_CATE.NOTE,
                action_type_id = (int)ACTIVITY_TYPE.OPPORTUNITYUPDATE,
                parent_id = null,
                object_id = opportunityDto.opportunity.id,
                object_type_id = (int)OBJECT_TYPE.OPPORTUNITY,
                account_id = opportunityDto.opportunity.account_id,
                contact_id = contact_id,
                resource_id = opportunityDto.opportunity.resource_id,
                contract_id = null,
                opportunity_id = opportunityDto.opportunity.id,
                ticket_id = null,
                start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),  // todo 从页面获取时间，去页面时间的12：00：00
                end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),
                description = $"销售订单取消 /r 这个商机被关闭 / 执行，然后重新开放。其相应的销售订单未完成，因此已被取消。",     // todo 内容描述拼接
                status_id = null,
                complete_description = null,
                complete_time = null,
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                is_system_generate = 1,
            };

            new com_activity_dal().Insert(cancelSaleOrderActivity);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACTIVITY,
                oper_object_id = loseOppoActivity.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(cancelSaleOrderActivity),
                remark = "新增取消销售订单的备注"

            });

            #endregion

            #region 处理逻辑5. 保存销售订单

            // 一个商机只会有一个销售订单
            var saleOrderDal = new crm_sales_order_dal();
            var salesOrder = saleOrderDal.GetSingleSalesOrderByWhere($" and opportunity_id = {opportunityDto.opportunity.id}");

            if (salesOrder != null)
            {
                if (salesOrder.status_id == (int)SALES_ORDER_STATUS.IN_PROGRESS || salesOrder.status_id == (int)SALES_ORDER_STATUS.PARTIALLY_FULFILLED)
                {
                    salesOrder.status_id = (int)SALES_ORDER_STATUS.CANCELED;
                    salesOrder.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    salesOrder.update_user_id = user.id;
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.SALE_ORDER,
                        oper_object_id = salesOrder.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                        oper_description = _dal.CompareValue(saleOrderDal.GetSingleSalesOrderByWhere($" and id={salesOrder.id}"), salesOrder),
                        remark = "丢失商机时修改销售订单的状态为取消"

                    });
                    saleOrderDal.Update(salesOrder);
                }
            }



            #endregion

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 返回商机总收入
        /// </summary>
        /// <param name="opportunity"></param>
        /// <returns></returns>
        public decimal ReturnOppoRevenue(long oId)
        {
            var opportunity = _dal.FindNoDeleteById(oId);
            if (opportunity == null)
                return 0;
            decimal total = 0;
            var month = opportunity.number_months == null ? 0 : (int)opportunity.number_months;
            total += (decimal)(opportunity.one_time_revenue == null ? 0 : opportunity.one_time_revenue);
            total += (decimal)((opportunity.monthly_revenue == null ? 0 : opportunity.monthly_revenue) * month);
            total += (decimal)((opportunity.quarterly_revenue == null ? 0 : (opportunity.quarterly_revenue / 3)) * month);
            total += (decimal)((opportunity.semi_annual_revenue == null ? 0 : (opportunity.semi_annual_revenue / 6)) * month);
            total += (decimal)((opportunity.yearly_revenue == null ? 0 : (opportunity.yearly_revenue / 12)) * month);
            if (opportunity.use_quote == 1)
            {
                var priQuote = new crm_quote_dal().GetPriQuote(oId);
                if (priQuote != null)
                {
                    var itemList = new crm_quote_item_dal().GetAllQuoteItem(priQuote.id);
                    if (itemList != null && itemList.Count > 0)
                    {
                       var shipList = itemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.optional == 0).ToList(); // 配送类型的报价项
                        var oneTimeList = itemList.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME && _.optional == 0 && _.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES).ToList();
                        var discountQIList = itemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.optional == 0).ToList();

                        // 加上配送的金额
                        if (shipList != null && shipList.Count > 0)
                        {
                            var totalPrice = shipList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);
                            total += (decimal)totalPrice;
                        }
                        // 减去折扣的金额
                        if (discountQIList != null && discountQIList.Count > 0)
                        {
                            var totalPrice = (discountQIList.Where(_ => _.discount_percent == null).ToList().Sum(_ => (_.unit_discount != null && _.quantity != null) ? _.unit_discount * _.quantity : 0) + (oneTimeList != null && oneTimeList.Count > 0 ? discountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_ => oneTimeList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0) * _.discount_percent * 100 / 100) : 0));
                            total -= (decimal)totalPrice;
                        }

                    }
                }
            }
            return total;
        }
        /// <summary>
        /// 返回商机总成本
        /// </summary>
        /// <param name="opportunity"></param>
        /// <returns></returns>
        public decimal ReturnOppoCost(long oId)
        {
            var opportunity = _dal.FindNoDeleteById(oId);
            if (opportunity == null)
                return 0;
            decimal total = 0;
            var month = opportunity.number_months == null ? 0 : (int)opportunity.number_months;
            total += (decimal)(opportunity.one_time_cost == null ? 0 : opportunity.one_time_cost);
            total += (decimal)((opportunity.monthly_cost == null ? 0 : opportunity.monthly_cost) * month);
            total += (decimal)((opportunity.quarterly_cost == null ? 0 : (opportunity.quarterly_cost / 3)) * month);
            total += (decimal)((opportunity.semi_annual_cost == null ? 0 : (opportunity.semi_annual_cost / 6)) * month);
            total += (decimal)((opportunity.yearly_cost == null ? 0 : (opportunity.yearly_cost / 12)) * month);
            if (opportunity.use_quote == 1)
            {
                var priQuote = new crm_quote_dal().GetPriQuote(oId);
                if (priQuote != null)
                {
                    var itemList = new crm_quote_item_dal().GetAllQuoteItem(priQuote.id);
                    if (itemList != null && itemList.Count > 0)
                    {
                        var shipList = itemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.optional == 0).ToList(); // 配送类型的报价项
                        if (shipList != null && shipList.Count > 0)
                        {
                            var totalPrice = shipList.Sum(_ => ( _.unit_cost != null && _.quantity != null) ? _.unit_cost * _.quantity : 0);
                            total += (decimal)totalPrice;
                        }
                    }
                }
            }
            return total;
        }

        /// <summary>
        /// 根据id判断是服务还是服务包或者都不是（服务返回1 服务包返回2 ，都不是返回0）
        /// </summary>
        /// <param name="object_id"></param>
        /// <returns></returns>
        public int isServiceOrBag(long object_id)
        {
            // GetSinService
            var service = new ivt_service_dal().GetSinService(object_id);
            if (service != null)
            {
                return 1;
            }

            var serviceBundle = new ivt_service_bundle_dal().GetSinSerBun(object_id);
            if (serviceBundle != null)
            {
                return 2;
            }
            return 0;
        }
        /// <summary>
        /// 根据服务/包 的Id返回名字
        /// </summary>
        /// <param name="object_id"></param>
        /// <returns></returns>
        public string ReturnServiceName(long object_id)
        {
            // GetSinService
            var service = new ivt_service_dal().GetSinService(object_id);
            if (service != null)
            {
                return service.name;
            }

            var serviceBundle = new ivt_service_bundle_dal().GetSinSerBun(object_id);
            if (serviceBundle != null)
            {
                return serviceBundle.name;
            }
            return "";
        }

        /// <summary>
        /// 根据开始时间，结束时间和周期类型返回周期数
        /// </summary>
        /// <param name="start_date">开始时间</param>
        /// <param name="endDate">结束时间</param>
        /// <param name="type">周期类型</param>
        /// <returns></returns>
        public decimal ReturnPeriod(DateTime start_date, DateTime endDate, int type)
        {
            // period_type 43
            decimal period = 1; // 周期数
            var months = (endDate.Year - start_date.Year) * 12 + (endDate.Month - start_date.Month) + (endDate.Day >= start_date.Day ? 1 : 0);  // 相差月份
            decimal periodMonths = 1;
            switch (type)
            {
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                    periodMonths = 6;
                    period = Math.Ceiling(months / periodMonths);
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                    periodMonths = 1;
                    period = months;
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                    periodMonths = 3;
                    period = Math.Ceiling(months / periodMonths);
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                    periodMonths = 12;
                    period = Math.Ceiling(months / periodMonths);
                    break;
                default:
                    break;
            }

            return period;
        }
        /// <summary>
        /// 根据周期ID 返回周期月数
        /// </summary>
        public int ReturnMonths(int type)
        {
            int month = 0;
            switch (type)
            {
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                    month = 6;
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                    month = 1;
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                    month = 3;
                    break;
                case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                    month = 12;
                    break;
                default:
                    break;
            }
            return month;
        }
    }
}
