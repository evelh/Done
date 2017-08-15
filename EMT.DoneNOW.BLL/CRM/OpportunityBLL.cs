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

namespace EMT.DoneNOW.BLL.CRM
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
                                                                                                                                                      //dic.Add("district", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("行政区")));                // 行政区
            dic.Add("territory", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TERRITORY)));              // 销售区域
                                                                                                                                                      //  dic.Add("company_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ACCOUNT_TYPE)));              // 客户类型
                                                                                                                                                      //  dic.Add("taxRegion", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TAX_REGION)));              // 税区
            dic.Add("sufix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NAME_SUFFIX)));              // 名字后缀
                                                                                                                                                      //  dic.Add("action_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.ACTION_TYPE)));        // 活动类型



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
        /// 新增商机
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(OpportunityAddOrUpdateDto param, long user_id,out string id)
        {
            id = "";
            if (string.IsNullOrEmpty(param.general.name))                     // string必填项校验   || string.IsNullOrEmpty(param.notify.subject)
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失
            if (param.general.account_id == 0 || param.general.resource_id == 0 || param.general.stage_id == 0 || param.general.status_id == 0 )  // int 必填项校验
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

            decimal total = 0;
            total += (decimal)(param.general.one_time_revenue == null ? 0 : param.general.one_time_revenue);
            total += (decimal)((param.general.monthly_revenue==null?0: param.general.monthly_revenue) * param.general.number_months);
            total += (decimal)((param.general.quarterly_revenue == null ? 0 : param.general.monthly_revenue) * param.general.number_months);
            total += (decimal)((param.general.semi_annual_revenue == null ? 0 : param.general.monthly_revenue) * param.general.number_months);
            total += (decimal)((param.general.yearly_revenue == null ? 0 : param.general.monthly_revenue) * param.general.number_months);
           

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
                description = $"新商机：{param.general.name},全部收益：{total}，成交概率{param.general.probability}，阶段{new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STAGE)).FirstOrDefault(_=>_.val==param.general.stage_id.ToString()).show}，预计完成时间:{param.general.projected_close_date}，商机负责人{new sys_resource_dal().GetDictionary().FirstOrDefault(_=>_.val== param.general.resource_id.ToString()).show}，状态{new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STATUS)).FirstOrDefault(_=>_.val== param.general.status_id.ToString()).show}",     // todo 内容描述拼接
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

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
            if (param.general.account_id == 0 || param.general.resource_id == 0 || param.general.stage_id == 0 || param.general.status_id == 0 )  // int 必填项校验
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

            return ERROR_CODE.SUCCESS;
            //    optnt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            //    optnt.update_user_id = userId;

            //    // TODO: 日志
            //    return _dal.Update(optnt);
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
                var quoteList = new crm_quote_dal().GetQuoteByWhere(" and opportunity_id="+opportunity.id);
                if (quoteList != null && quoteList.Count > 0)
                {
                    quoteList.ForEach(_ =>
                    {
                        //_.delete_user_id = user_id;
                        //_.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        quoteBLL.DeleteQuote(_.id,user.id);
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
    }
}
