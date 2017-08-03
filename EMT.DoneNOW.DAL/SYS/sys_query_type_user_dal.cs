using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using System.Data;
using Dapper;

namespace EMT.DoneNOW.DAL
{
    public class sys_query_type_user_dal : BaseDAL<sys_query_type_user>
    {
        /// <summary>
        /// 执行f_rpt_getsql，生成查询sql语句
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="type"></param>
        /// <param name="userId"></param>
        /// <param name="condition"></param>
        /// <param name="orderBy"></param>
        /// <returns></returns>
        public string GetQuerySql(long groupId, long type, long userId, string condition, string orderBy)
        {
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "f_rpt_getsql";
                p.Add("in_para_group_id", groupId);
                p.Add("in_type_id", type);
                p.Add("in_user_id", userId);
                p.Add("in_user_condition", condition);
                p.Add("in_user_orderby", orderBy);
                p.Add("@srtn", 0, DbType.String, ParameterDirection.ReturnValue);
                var result = conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure).FirstOrDefault();
                return p.Get<string>("@srtn");
            }

        }

        /// <summary>
        /// 执行p_rpt_getsql_count，获取查询总记录数
        /// </summary>
        /// <param name="groupId"></param>
        /// <param name="type"></param>
        /// <param name="userId"></param>
        /// <param name="condition"></param>
        /// <returns></returns>
        public int GetQueryCount(long groupId, long type, long userId, string condition)
        {
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "p_rpt_getsql_count";
                p.Add("in_para_group_id", groupId);
                p.Add("in_type_id", type);
                p.Add("in_user_id", userId);
                p.Add("in_user_condition", condition);
                p.Add("@out_count", 0, DbType.Int32, ParameterDirection.Output);
                var result = conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure).FirstOrDefault();
                return p.Get<int>("@out_count");
            }

        }

        /// <summary>
        /// 根据用户id和条件组id查找
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="groupId"></param>
        /// <returns></returns>
        public sys_query_type_user GetQueryTypeUser(long userId, long groupId)
        {
            if (userId > 0)
                return FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id={userId} AND query_para_group_id={groupId}");
            else
                return FindSignleBySql<sys_query_type_user>($"SELECT * FROM sys_query_type_user WHERE user_id is null AND query_para_group_id={groupId}");
        }
    }
}
