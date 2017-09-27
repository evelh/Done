using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_exclusion_cost_code_dal : BaseDAL<ctt_contract_exclusion_cost_code>
    {
        /// <summary>
        /// 查找对应合同id的所有例外因素
        /// </summary>
        /// <param name="contractId"></param>
        /// <returns></returns>
        public List<ctt_contract_exclusion_cost_code> FindListByContractId(long contractId)
        {
            string sql = $"SELECT * FROM ctt_contract_exclusion_cost_code WHERE contract_id={contractId} AND delete_time=0";
            return FindListBySql(sql);
        }
    }

}
