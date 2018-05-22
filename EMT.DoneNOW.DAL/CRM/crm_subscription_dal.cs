using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_subscription_dal : BaseDAL<crm_subscription>
    {

        public crm_subscription GetSubscription(long id)
        {
            return FindSignleBySql<crm_subscription>($"select * from crm_subscription where delete_time = 0 and id = {id}");
        }
        /// <summary>
        /// 根据配置项获取订阅信息
        /// </summary>
        public List<crm_subscription> GetSubByInsProId(long insProId)
        {
            return FindListBySql($"SELECT * from crm_subscription where delete_time = 0 and installed_product_id={insProId}");
        }

        //public List<crm_subscription> GetSubByIds(string ids)
        //{
        //    return null;
        //}
    }
}
