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
        public List<ctt_contract_exclusion_role> GetList(long contractId)
        {
            return FindListBySql($"SELECT * FROM ctt_contract_exclusion_role WHERE contract_id={contractId} AND delete_time=0");
        }
    }

}
