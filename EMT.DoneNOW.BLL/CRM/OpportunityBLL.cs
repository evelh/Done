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
            dic.Add("oppportunity_advanced_field", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_ADVANCED_FIELD)));          // 商机扩展字段
            dic.Add("oppportunity_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OPPORTUNITY_STATUS)));          // 商机状态
            dic.Add("oppportunity_range_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.FORM_TEMPLATE_RANGE_TYPE)));          // 表单模板应用范围
            dic.Add("projected_close_date", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.PROJECTED_CLOSED_DATE)));          // 商机模板项目关闭日期

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
        public ERROR_CODE Insert(OpportunityAddOrUpdateDto param, long user_id)
        {
            if (string.IsNullOrEmpty(param.general.name) ||  string.IsNullOrEmpty(param.notify.subject))                     // string必填项校验
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失
            if (param.general.account_id == 0 || param.general.resource_id == 0 || param.general.stage_id == 0 || param.general.status_id == 0 || param.notify.notify_tmpl_id == 0)  // int 必填项校验
                return ERROR_CODE.PARAMS_ERROR;             // 返回参数丢失

            var user = UserInfoBLL.GetUserInfo(user_id);

            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;           // 查询不到用户，用户丢失


            // crm_opportunity
            #region 1.保存商机
          
            param.general.id = _dal.GetNextIdCom();
            param.general.create_user_id = user.id;
            param.general.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.general.update_user_id = user.id;
            param.general.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

            _dal.Insert(param.general);

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

            #region 2.保存通知
            param.notify.cate_id = (int)NOTIFY_CATE.CRM;
            param.notify.event_id = (int)NOTIFY_EVENT.OPPORTUNITY_CREATEDOREDITED;
            param.notify.id = _dal.GetNextIdCom();
            param.notify.create_user_id = user.id;
            param.notify.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.notify.update_user_id = user.id;
            param.notify.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.NOTIFY,
                oper_object_id = param.notify.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(param.notify),
                remark = "保存商机信息"

            });
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
                description = "",     // todo 内容描述拼接
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
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.ACTIVITY,
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
        public bool Update(crm_opportunity optnt, long userId)
        {
            optnt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            optnt.update_user_id = userId;

            // TODO: 日志
            return _dal.Update(optnt);
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
        public bool DeleteContact(long id, string token)
        {
            return false;
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
