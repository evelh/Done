using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class v_contract_summary_dal : BaseDAL<v_contract_summary>
    {
        /// <summary>
        /// 根据合同id获取合同概要视图信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public v_contract_summary FindByContractId(long id)
        {
            string sql = $"SELECT * FROM v_contract_summary WHERE id={id}";
            return FindSignleBySql<v_contract_summary>(sql);
        }
    }

}
