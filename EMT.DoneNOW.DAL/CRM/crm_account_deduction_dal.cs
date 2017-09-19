using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_account_deduction_dal : BaseDAL<crm_account_deduction>
    {
        /// <summary>
        /// 查询该客户下的条目
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_account_deduction> GetAccDed(long account_id)
        {
            return FindListBySql<crm_account_deduction>($"SELECT * from crm_account_deduction where account_id = {account_id} and delete_time = 0");
        }
    }

}