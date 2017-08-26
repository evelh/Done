using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_subscription_period_dal : BaseDAL<crm_subscription_period>
    {
        public List<crm_subscription_period> GetSubPeriodByWhere(string where = "")
        {
            if (where != "")
            {
                return FindListBySql<crm_subscription_period>("select * from crm_subscription_period where delete_time = 0 " + where);
            }
            return FindListBySql<crm_subscription_period>("select * from crm_subscription_period where delete_time = 0");
        }
        public crm_subscription_period GetSingleSubPeriodByWhere(string where = "")
        {
            if (where != "")
            {
                return FindSignleBySql<crm_subscription_period>("select * from crm_subscription_period where delete_time = 0 " + where);
            }
            return FindSignleBySql<crm_subscription_period>("select * from crm_subscription_period where delete_time = 0");
        }
    }
}
