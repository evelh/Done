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

       
    }

}
