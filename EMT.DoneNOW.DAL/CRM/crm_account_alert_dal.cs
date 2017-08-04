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

        /// <summary>
        ///  根据类型获取到对应的提醒
        /// </summary>
        /// <param name="account_id"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public crm_account_alert FindAlert(long account_id, DTO.DicEnum.ACCOUNT_ALERT_TYPE type)
        {
            return FindSignleBySql<crm_account_alert>($"select * from crm_account_alert where account_id={account_id} and delete_time=0 and alert_type_id = {(int)type}");
        }
    }
}
