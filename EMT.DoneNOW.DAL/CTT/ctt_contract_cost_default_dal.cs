using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_cost_default_dal : BaseDAL<ctt_contract_cost_default>
    {
        /// <summary>
        /// 根据合同ID 查询默认成本
        /// </summary>
        public ctt_contract_cost_default GetSinCostDef(long cid)
        {
            return FindSignleBySql<ctt_contract_cost_default>($" SELECT * from ctt_contract_cost_default where contract_id = {cid} and delete_time = 0;");
        }
    }

}
