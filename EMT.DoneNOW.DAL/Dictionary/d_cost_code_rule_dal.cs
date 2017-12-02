using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_cost_code_rule_dal : BaseDAL<d_cost_code_rule>
    {
        /// <summary>
        /// 根据物料代码id获取规则信息
        /// </summary>
        public List<d_cost_code_rule> GetRuleByCodeId(long cost_code_id)
        {
            return FindListBySql<d_cost_code_rule>($"SELECT * from d_cost_code_rule where delete_time = 0 and cost_code_id = {cost_code_id}");
        }
    }
}
