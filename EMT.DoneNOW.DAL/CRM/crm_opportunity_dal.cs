using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;


namespace EMT.DoneNOW.DAL
{
    public class crm_opportunity_dal : BaseDAL<crm_opportunity>
    {

        public List<crm_opportunity> Find(OpportunityConditionDto condition, int pageNum, string orderby)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append(" 1=1 ");
            if (condition.close_days > 0)  // 商机剩余关闭时间
                sql.Append($" AND cust_type={condition.close_days}");
            sql.Append($" AND probability>={condition.probability}");   // 商机成功几率
            if (condition.stage != null && condition.stage != 0)  // 商机阶段
                sql.Append($" AND stage_id={condition.stage}");

            DateTime dt = DateTime.Now.ToUniversalTime();
            //condition.close_days

            sql.Append(QueryStringDeleteFlag(" "));

            if (!string.IsNullOrEmpty(orderby))
                sql.Append($" ORDER BY {orderby}");
            return null;
            //return FindListPage(CompanyListQueryString(), sql.ToString(), pageNum);
        }

        /// <summary>
        /// 通过客户id查询商机历史，按照名称升序排序
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_opportunity> FindOpHistoryByAccountId(long account_id)
        {
            return FindListBySql($"SELECT * from crm_opportunity where account_id = {account_id} and delete_time = 0 ORDER BY name");
        }

        /// <summary>
        /// 根据商机ID去获取商机
        /// </summary>
        /// <param name="opportunity_id"></param>
        /// <returns></returns>
        public crm_opportunity GetOpportunityById(long opportunity_id)
        {
            return FindSignleBySql<crm_opportunity>($"SELECT * from crm_opportunity where id = {opportunity_id}  AND delete_time = 0");
        }

        /// <summary>
        /// 获取到该客户下所有有报价的商机
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_opportunity> GetHasQuoteOppo(long account_id)
        {
            return FindListBySql<crm_opportunity>($"select DISTINCT o.* FROM crm_opportunity o inner JOIN crm_quote q on q.opportunity_id = o.id where o.delete_time = 0 and q.delete_time = 0 and o.account_id = {account_id} ");
        }

        /// <summary>
        /// 获取到该客户下所有没有报价的商机
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_opportunity> GetNoQuoteOppo(long account_id)
        {
            return FindListBySql<crm_opportunity>($"select DISTINCT o.* FROM crm_opportunity o, crm_quote q where o.delete_time=0 and q.delete_time = 0 and o.account_id={account_id} and o.id not in (select DISTINCT o.id FROM crm_opportunity o inner JOIN crm_quote q on q.opportunity_id = o.id where o.delete_time = 0 and q.delete_time = 0 and o.account_id = {account_id}); ");
        }

        public crm_opportunity GetOpportunityByOtherId(long id)
        {
            return FindSignleBySql<crm_opportunity>($"SELECT o.* FROM crm_opportunity o LEFT JOIN crm_quote q on o.id = q.opportunity_id where(o.id = {id} AND o.delete_time = 0) or(q.id = {id} and q.delete_time = 0) ");
        }


    }

}
