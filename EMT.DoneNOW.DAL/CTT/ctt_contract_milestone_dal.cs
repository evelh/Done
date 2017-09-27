using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_milestone_dal : BaseDAL<ctt_contract_milestone>
    {
        /// <summary>
        /// 查找对应合同id的所有里程碑
        /// </summary>
        /// <param name="contractId"></param>
        /// <returns></returns>
        public List<ctt_contract_milestone> FindListByContractId(long contractId)
        {
            string sql = $"SELECT * FROM ctt_contract_milestone WHERE contract_id={contractId} AND delete_time=0";
            return FindListBySql(sql);
        }
    }

}
