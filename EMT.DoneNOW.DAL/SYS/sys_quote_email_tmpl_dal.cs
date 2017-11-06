using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_quote_email_tmpl_dal : BaseDAL<sys_quote_email_tmpl>
    {
        /// <summary>
        /// 获取到发票的邮件模板
        /// </summary>
        /// <returns></returns>
        public List<sys_quote_email_tmpl> GetInvoiceEmailTemlList()
        {
            return FindListBySql<sys_quote_email_tmpl>($"select * from sys_quote_email_tmpl where cate_id=2 and status_id = 1 and delete_time = 0");
        }

        /// <summary>
        /// 获取到报价的邮件模板
        /// </summary>
        /// <returns></returns>
        public List<sys_quote_email_tmpl> GetQuoteEmailTemlList()
        {
            return FindListBySql<sys_quote_email_tmpl>($"select * from sys_quote_email_tmpl where cate_id=1 and status_id = 1 and delete_time = 0");
        }
    }
}
