using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using System.Data;
using Dapper;

namespace EMT.DoneNOW.DAL
{
    public class sys_widget_dal : BaseDAL<sys_widget>
    {
        /// <summary>
        /// 小窗口获取获取数据sql
        /// </summary>
        /// <param name="widgetId"></param>
        /// <param name="type"></param>
        /// <param name="userId"></param>
        /// <param name="filter"></param>
        /// <returns></returns>
        public string GetWidgetSql(long widgetId, int type, long userId, long? filter = null)
        {
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "p_widget_getsql";
                p.Add("in_widget", widgetId);
                p.Add("in_type", type);
                p.Add("in_user", userId);
                p.Add("in_tab_filer_value", filter);
                p.Add("@out_sql", 0, DbType.String, ParameterDirection.Output);
                var result = conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure).FirstOrDefault();
                return p.Get<string>("@out_sql");
            }
        }

        /// <summary>
        /// 小窗口钻取
        /// </summary>
        /// <param name="widgetId"></param>
        /// <param name="userId"></param>
        /// <param name="filter"></param>
        /// <param name="orderby"></param>
        /// <param name="group1"></param>
        /// <param name="group2"></param>
        /// <returns></returns>
        public string GetWidgetDrillSql(long widgetId, long userId, long? filter, string orderby, string group1, string group2)
        {
            if (string.IsNullOrEmpty(orderby))
                orderby = null;
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "f_widget_getsql_drill";
                p.Add("in_widget", widgetId);
                p.Add("in_user_id", userId);
                p.Add("in_tab_filer_value", filter);
                p.Add("in_user_orderby", orderby);
                p.Add("in_con1", group1);
                p.Add("in_con2", group2);
                p.Add("@srtn", 0, DbType.String, ParameterDirection.ReturnValue);
                var result = conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure).FirstOrDefault();
                return p.Get<string>("@srtn");
            }
        }

        /// <summary>
        /// 小窗口钻取的记录数
        /// </summary>
        /// <param name="widgetId"></param>
        /// <param name="userId"></param>
        /// <param name="filter"></param>
        /// <param name="orderby"></param>
        /// <param name="group1"></param>
        /// <param name="group2"></param>
        /// <returns></returns>
        public int GetWidgetDrillCount(long widgetId, long userId, long? filter, string orderby, string group1, string group2)
        {
            if (string.IsNullOrEmpty(orderby))
                orderby = null;
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "p_widget_getsql_drill_count";
                p.Add("in_widget", widgetId);
                p.Add("in_user_id", userId);
                p.Add("in_tab_filer_value", filter);
                p.Add("in_user_orderby", orderby);
                p.Add("in_con1", group1);
                p.Add("in_con2", group2);
                p.Add("@out_count", 0, DbType.Int32, ParameterDirection.Output);
                var result = conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure).FirstOrDefault();
                return p.Get<int>("@out_count");
            }
        }
    }

}
