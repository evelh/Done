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
                description = $"新商机：{param.general.name},全部收益：{ReturnOppoRevenue(param.general)}，成交概率:{param.general.probability}，阶段:{new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STAGE)).FirstOrDefault(_ => _.val == param.general.stage_id.ToString()).show}，预计完成时间:{param.general.projected_close_date}，商机负责人:{new sys_resource_dal().GetDictionary().FirstOrDefault(_ => _.val == param.general.resource_id.ToString()).show}，状态:{new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STATUS)).FirstOrDefault(_ => _.val == param.general.status_id.ToString()).show}",     // todo 内容描述拼接
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

        // 关闭商机(赢得商机)
        public ERROR_CODE CloseOpportunity(CloseOpportunityDto param, long user_id)
        {

            // 1.修改商机操作
            // 2.更改商机的客户的客户类型和地址相关操作
            // 3.当勾选 从报价激活项目提案 更新项目，将计费项关联到项目（未创建表，暂不处理）
            // 4.新增合同信息

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


            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;

            #region 处理逻辑1. 修改商机相关信息
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
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
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


            #region 3.保存项目信息
            if (param.activateProject) // 代表用户勾选了从报价激活项目提案
            {


            }

            #endregion

            // 新增合同和更新合同二选一的关系
            #region 4.新增合同信息
            if (param.createContract) // 代表用户勾选了创建周期服务合同
            {

                // 新创建合同对象
                var contract = new ctt_contract() {
                    id = _dal.GetNextIdCom(),
                    name = param.contract.name,
                    account_id = param.opportunity.account_id,
                    is_sdt_default = 0,
                    contact_id = contact_id,
                    start_date = param.contract.start_date,
                    end_date = param.contract.end_date,
                    occurrences = param.contract.occurrences,
                    description="",
                    cate_id=null,    // 最后一次手工添加定期服务合同时选择的种类?? 从哪里取  todo
                    external_no = null,
                    sla_id =  null,// 最后一次手工添加定期服务合同时选择的sla?? 从哪里取  todo
                    setup_fee = null,  // 报价项初始费用
                    timeentry_need_begin_end  =0,  // 最后一次手工添加定期服务合同时选择的该字段值 从哪里取  todo
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
                // 同时将生成的计费项关联到新合同
            }

            #endregion

            #region 5.更新合同信息
            if (param.addServicesToExistingContract ) // 代表用户勾选了将服务加入已存在的定期服务合同
            {
                var oldContract = new ctt_contract_dal().GetSingleContract(param.contract.id);
                if(oldContract.setup_fee==null|| oldContract.setup_fee == 0)
                {
                    oldContract.setup_fee = param.contract.setup_fee;
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
                        oper_description = _dal.CompareValue(new ctt_contract_dal().GetSingleContract(oldContract.id),oldContract),
                        remark = "商机关闭，更新合同信息"

                    });
                    new ctt_contract_dal().Update(oldContract);

                }

            }

            #endregion

            // createTicketPostSaleQueue
            #region 6.新增工单信息
            if (param.createTicketPostSaleQueue) // 代表用户勾选了创建服务台工单售后队列
            {


            }

            #endregion

            #region 7.转换为工单/项目/合同成本，不包括——转换为工单成本（新建已完成工单）逻辑

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
            // todo 只有当  产品/一次性折扣、成本、配送转为计费项时，销售订单就会自动生成
            // todo 判断是否有这些报价项转换
            var saleOrder = new crm_sales_order() {
                id=_dal.GetNextIdCom(),
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
            #endregion


            #region 12.新增项目备注/合同备注
            // todo 只有转为合同/项目计费项时，才会生成备注。工单不会生成
            // 待确定
            //com_activity addActivity = new com_activity()
            //{
            //    id = _dal.GetNextIdCom(),
            //    cate_id = (int)ACTIVITY_CATE.NOTE,
            //    action_type_id = (int)ACTIVITY_TYPE.OPPORTUNITYUPDATE,// 根据项目/合同 去设置
            //    parent_id = null,
            //    object_id = param.opportunity.id,
            //    object_type_id = (int)OBJECT_TYPE.OPPORTUNITY,
            //    account_id = param.opportunity.account_id,
            //    contact_id = contact_id,
            //    resource_id = param.opportunity.resource_id,
            //    contract_id = null,// todo - 如果转为合同成本，则为“合同ID”；否则为空
            //    opportunity_id = param.opportunity.id,
            //    ticket_id = null,
            //    start_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),  // todo 从页面获取时间，去页面时间的12：00：00
            //    end_date = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Parse(DateTime.Now.ToShortDateString() + " 12:00:00")),
            //    description = $"",     // todo 内容描述拼接
            //    status_id = null,
            //    complete_description = null,
            //    complete_time = null,
            //    create_user_id = user.id,
            //    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    update_user_id = user.id,
            //    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

            //};
            //new com_activity_dal().Insert(addActivity);
            //new sys_oper_log_dal().Insert(new sys_oper_log()
            //{
            //    user_cate = "用户",
            //    user_id = (int)user.id,
            //    name = user.name,
            //    phone = user.mobile == null ? "" : user.mobile,
            //    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
            //    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACTIVITY,
            //    oper_object_id = addActivity.id,// 操作对象id
            //    oper_type_id = (int)OPER_LOG_TYPE.ADD,
            //    oper_description = _dal.AddValue(addActivity),
            //    remark = "商机关闭，创建备注"

            //});


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
                status_id = (int)OPPORTUNITY_STATUS.LOST,
                complete_description = null,
                complete_time = null,
                create_user_id = user.id,
                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                update_user_id = user.id,
                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),

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
        public decimal ReturnOppoRevenue(crm_opportunity opportunity)
        {
            decimal total = 0;
            var month = opportunity.number_months == null ? 0 : (int)opportunity.number_months;
            total += (decimal)(opportunity.one_time_revenue == null ? 0 : opportunity.one_time_revenue);
            total += (decimal)((opportunity.monthly_revenue == null ? 0 : opportunity.monthly_revenue) * month);
            total += (decimal)((opportunity.quarterly_revenue == null ? 0 : (opportunity.quarterly_revenue / 3)) * month);
            total += (decimal)((opportunity.semi_annual_revenue == null ? 0 : (opportunity.semi_annual_revenue / 6)) * month);
            total += (decimal)((opportunity.yearly_revenue == null ? 0 : (opportunity.yearly_revenue / 12)) * month);
            return total;
        }
        /// <summary>
        /// 返回商机总成本
        /// </summary>
        /// <param name="opportunity"></param>
        /// <returns></returns>
        public decimal ReturnOppoCost(crm_opportunity opportunity)
        {
            decimal total = 0;
            var month = opportunity.number_months == null ? 0 : (int)opportunity.number_months;
            total += (decimal)(opportunity.one_time_cost == null ? 0 : opportunity.one_time_cost);
            total += (decimal)((opportunity.monthly_cost == null ? 0 : opportunity.monthly_cost) * month);
            total += (decimal)((opportunity.quarterly_cost == null ? 0 : (opportunity.quarterly_cost / 3)) * month);
            total += (decimal)((opportunity.semi_annual_cost == null ? 0 : (opportunity.semi_annual_cost / 6)) * month);
            total += (decimal)((opportunity.yearly_cost == null ? 0 : (opportunity.yearly_cost / 12)) * month);
            return total;
        }


    }
}
