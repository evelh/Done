using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_account_reference_dal : BaseDAL<crm_account_reference>
    {
        /// <summary>
        /// 根据客户id查询出该客户的发票模板设置
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_account_reference GetAccountInvoiceRef(long account_id)
        {
            return FindSignleBySql<crm_account_reference>($"SELECT * from crm_account_reference where account_id ={account_id} and invoice_tmpl_id is not null and delete_time = 0");
        }

        /// <summary>
        /// 根据客户id查询出该客户的报价模板设置
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public crm_account_reference GetAccountQuoteRef(long account_id)
        {
            return FindSignleBySql<crm_account_reference>($"SELECT * from crm_account_reference where account_id ={account_id} and invoice_tmpl_id is null and delete_time = 0");
        }
    }
}
