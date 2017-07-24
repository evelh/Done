using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;

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
        public ERROR_CODE Insert(OpportunityAddOrUpdateDto opt, long userId)
        {
            var optnt = opt.general;
            optnt.id = _dal.GetNextIdCom();
            optnt.opportunity_no = ""; // TODO: 商机号码生成
            optnt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            optnt.create_user_id = userId;
            optnt.update_time = optnt.create_time;
            optnt.update_user_id = optnt.create_user_id;
            
            _dal.Insert(optnt);     // 新增商机
            // 记录日志
            sys_oper_log_dal.InsertLog<crm_opportunity>(optnt, optnt.id, userId, DicEnum.OPER_LOG_TYPE.ADD, DicEnum.OPER_LOG_OBJ_CATE.OPPORTUNITY);



            return ERROR_CODE.ERROR;
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
