using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_account_alert_dal : BaseDAL<crm_account_alert>
    {
        /// <summary>
        /// 根据客户id查找
        /// </summary>
        /// <returns></returns>
        public List<crm_account_alert> FindByAccount(long account_id)
        {
            return FindListBySql("SELECT * FROM crm_account_alert WHERE account_id=" + account_id);
        }
    }
}
