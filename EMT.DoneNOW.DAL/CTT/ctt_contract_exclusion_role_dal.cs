using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_exclusion_role_dal : BaseDAL<ctt_contract_exclusion_role>
    {
        /// <summary>
        /// 获取一个合同关联的不计费角色列表
        /// </summary>
        /// <param name="contractId"></param>
        /// <returns></returns>
        public List<ctt_contract_exclusion_role> FindListByContractId(long contractId)
        {
            return FindListBySql($"SELECT * FROM ctt_contract_exclusion_role WHERE contract_id={contractId} AND delete_time=0");
        }
        /// <summary>
        /// 根据合同和角色ID 获取唯一的例外因素
        /// </summary>
        public ctt_contract_exclusion_role GetSinRole(long contractId,long roleId)
        {
            return FindSignleBySql<ctt_contract_exclusion_role>($"SELECT * from ctt_contract_exclusion_role where contract_id = {contractId} and role_id = {roleId} and delete_time = 0");
        }
    }

}
