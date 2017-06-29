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
            dic.Add("opportunity_stage", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机阶段")));          // 商机阶段
            dic.Add("opportunity_source", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机来源")));          // 商机来源
            dic.Add("opportunity_interest_degree", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机客户感兴趣程度")));          // 商机客户感兴趣程度
            dic.Add("oppportunity_win_reason_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机赢单原因类型")));          // 商机赢单原因类型
            dic.Add("oppportunity_loss_reason_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机丢单原因类型")));          // 商机丢单原因类型
            dic.Add("oppportunity_advanced_field", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机扩展字段")));          // 商机扩展字段
            dic.Add("oppportunity_status", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机状态")));          // 商机状态
            dic.Add("oppportunity_range_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("表单模板应用范围")));          // 表单模板应用范围
            dic.Add("projected_close_date", new d_general_dal().GetDictionary(new d_general_table_dal().GetGeneralTableByName("商机模板项目关闭日期")));          // 商机模板项目关闭日期

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
        public crm_opportunity GetOpportunity(long id)
        {
            return _dal.FindById(id);
        }

        /// <summary>
        /// 新增商机
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE Insert(crm_opportunity optnt, string token)
        {
            optnt.id = _dal.GetNextIdCom();
            optnt.opportunity_no = ""; // TODO: 商机号码生成
            optnt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            optnt.create_user_id = CachedInfoBLL.GetUserInfo(token).id;
            optnt.update_time = optnt.create_time;
            optnt.update_user_id = optnt.create_user_id;
            
            _dal.Insert(optnt);  // TODO: log

            return ERROR_CODE.ERROR;
        }

        /// <summary>
        /// 更新商机信息
        /// </summary>
        /// <param name="optnt"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        public bool Update(crm_opportunity optnt, string token)
        {
            optnt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            optnt.update_user_id = CachedInfoBLL.GetUserInfo(token).id;

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
            crm_opportunity contact = GetOpportunity(id);
            contact.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            contact.delete_user_id = CachedInfoBLL.GetUserInfo(token).id;
            // TODO: 日志
            return _dal.SoftDelete(contact);
        }
    }
}
