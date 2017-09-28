using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

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
        /// <summary>
        /// 根据sql语句查询出符合条件的条目(从视图中查询)
        /// </summary>
        public List<InvoiceDeductionDto> GetInvDedDtoList(string where="")
        {
            return FindListBySql<InvoiceDeductionDto>("select * from v_posted_all where 1=1 " + where);
        }

        public List<crm_account_deduction> GetAccDeds(string ids)
        {
            return FindListBySql<crm_account_deduction>($"SELECT * from crm_account_deduction where id in ({ids}) and delete_time = 0");
        }
    }

}