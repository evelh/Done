using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_internal_cost_dal : BaseDAL<ctt_contract_internal_cost>
    {
        /// <summary>
        /// 查找对应合同id的所有合同内部成本
        /// </summary>
        /// <param name="contractId"></param>
        /// <returns></returns>
        public List<ctt_contract_internal_cost> FindListByContractId(long contractId)
        {
            string sql = $"SELECT * FROM ctt_contract_internal_cost WHERE contract_id={contractId} AND delete_time=0";
            return FindListBySql(sql);
        }


        /// <summary>
        /// // 用于添加内部成本时校验 合同-员工-角色 唯一性校验
        /// </summary>
        public ctt_contract_internal_cost GetCheckkSinIntCost(long cid,long rid,long role_id)
        {
            return FindSignleBySql<ctt_contract_internal_cost>($"SELECT * from ctt_contract_internal_cost where contract_id = {cid} and resource_id = {rid} and role_id = {role_id} and delete_time = 0");
        }
    }

}
