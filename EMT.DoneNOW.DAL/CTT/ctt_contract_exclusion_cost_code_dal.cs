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
        /// <summary>
        /// 根据合同和工作类型，获取唯一的例外因素
        /// </summary>
        public ctt_contract_exclusion_cost_code GetSinCode(long contractId,long codeId)
        {
            return FindSignleBySql<ctt_contract_exclusion_cost_code>($"SELECT * from ctt_contract_exclusion_cost_code where contract_id = {contractId} and cost_code_id = {codeId} and delete_time = 0");
        }

        
    }

}
