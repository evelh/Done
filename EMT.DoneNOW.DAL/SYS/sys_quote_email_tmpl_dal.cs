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
        /// 获取到所有的邮件模板
        /// </summary>
        /// <returns></returns>
        public List<sys_quote_email_tmpl> GetEmailTemlList()
        {
            return FindListBySql<sys_quote_email_tmpl>($"select * from sys_quote_email_tmpl where status_id = 1 and delete_time = 0");
        }
    }
}
