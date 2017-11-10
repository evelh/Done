using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class v_activity_contact_dal : BaseDAL<v_activity_contact>
    {
        /// <summary>
        /// 获取联系人指定类型的活动信息
        /// </summary>
        /// <param name="contactId">联系人id</param>
        /// <param name="typeIds">活动类型(1：待办；2：备注；3：商机；4：销售订单；5：工单；6：合同；7：项目，使用,分割。如： 3,4,6)</param>
        /// <returns></returns>
        public List<v_activity> GetActivities(long contactId, string typeIds)
        {
            long timestamp = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now.AddMonths(-6));
            string sql = $"SELECT * FROM v_activity_contact WHERE activity_contact_id={contactId} AND cate IN ({typeIds}) AND act_date_1lv>{timestamp} ";

            return FindListBySql<v_activity>(sql);
        }
        
    }

}
