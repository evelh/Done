using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_dal : BaseDAL<ctt_contract>
    {
        public ctt_contract GetSingleContract(long id)
        {
            return FindSignleBySql<ctt_contract>($"select * from ctt_contract where id = {id} and delete_time = 0");
        }
        /// <summary>
        ///  获得最后一次手工添加的定期服务合同（暂时认定商机为null 的是手工添加的  todo）
        /// </summary>
        /// <returns></returns>
        public ctt_contract GetLastAddContract()
        {
            return FindSignleBySql<ctt_contract>($"SELECT * from ctt_contract where delete_time = 0 and id = (select MAX(id) from ctt_contract where opportunity_id is NULL)");
        }
    }

}
