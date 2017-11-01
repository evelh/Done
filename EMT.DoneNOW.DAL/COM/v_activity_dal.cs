using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class v_activity_dal : BaseDAL<v_activity>
    {
        /// <summary>
        /// 从试图获取活动列表下第一级六个月内的活动信息
        /// </summary>
        /// <param name="accountId">客户id</param>
        /// <param name="typeIds">活动类型(1：待办；2：备注；3：商机；4：销售订单；5：工单；6：合同；7：项目，使用,分割。如： 3,4,6)</param>
        /// <param name="isAsc">按活动时间是否升序</param>
        /// <returns></returns>
        public List<v_activity> GetActivitiesFirstLevel(long accountId, string typeIds, bool isAsc)
        {
            long timestamp = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now.AddMonths(-6));
            string orderBy = " DESC ";
            if (isAsc)
                orderBy = " ASC ";
            string sql = $"SELECT * FROM v_activity WHERE account_id={accountId} AND cate IN ({typeIds}) AND lv=1 AND act_date_1lv>{timestamp} ORDER BY act_date_1lv {orderBy}";
            
            return FindListBySql(sql);
        }

        /// <summary>
        /// 从试图获取活动列表下第二三级的活动信息
        /// </summary>
        /// <param name="parentId"></param>
        /// <param name="level"></param>
        /// <param name="isAsc"></param>
        /// <returns></returns>
        public List<v_activity> GetActivities(long parentId, int level, bool? isAsc)
        {
            string orderBy = "";
            if (isAsc != null && (bool)isAsc)
                orderBy = " ASC ";
            else if (isAsc != null && (!(bool)isAsc))
                orderBy = " DESC ";
            string sql = "";
            if (level == 2)
            {
                if (orderBy != "")
                    orderBy = " ORDER BY act_date_2lv " + orderBy;
                sql = $"SELECT * FROM v_activity WHERE id_1lv={parentId} AND lv=2 {orderBy} ";
            }
            else if(level==3)
            {
                sql = $"SELECT * FROM v_activity WHERE id_2lv={parentId} AND lv=3 ORDER BY act_date ASC ";
            }

            return FindListBySql(sql);
        }
    }

}
