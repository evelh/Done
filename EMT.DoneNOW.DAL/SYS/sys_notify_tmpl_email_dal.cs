using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_notify_tmpl_email_dal : BaseDAL<sys_notify_tmpl_email>
    {
        /// <summary>
        /// 根据模板ID获取相关邮件信息
        /// </summary>
        public List<sys_notify_tmpl_email> GetEmailByTempId(long not_tem_id)
        {
            return FindListBySql<sys_notify_tmpl_email>($"SELECT * from sys_notify_tmpl_email where notify_tmpl_id = {not_tem_id} ");
        }
    }
}
