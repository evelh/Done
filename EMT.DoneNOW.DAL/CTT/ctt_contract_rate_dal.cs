using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_rate_dal : BaseDAL<ctt_contract_rate>
    {
        /// <summary>
        /// 根据合同Id 获取相关角色费率信息
        /// </summary>
        public List<ctt_contract_rate> GetRateByConId(long contract_id)
        {
            return FindListBySql<ctt_contract_rate>($"SELECT * from ctt_contract_rate where delete_time = 0 and contract_id = {contract_id}");
        }
        /// <summary>
        /// 根据合同和角色id 获取相关角色费率
        /// </summary>
        public ctt_contract_rate GetSinRate(long contract_id,long role_id)
        {
            return FindSignleBySql<ctt_contract_rate>($"SELECT * from ctt_contract_rate where delete_time = 0 and contract_id = {contract_id} and role_id ={role_id}");
        }
    }

}
