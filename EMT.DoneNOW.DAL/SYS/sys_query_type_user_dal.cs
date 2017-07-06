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
        public string GetQuerySql(int type, long userId, string condition, string orderBy, out int count)
        {
            // TODO: 记录总数
            count = 0;
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "f_rpt_getsql";
                p.Add("in_type_id", type);
                p.Add("in_user_id", userId);
                p.Add("in_user_condition", condition);
                p.Add("in_user_orderby", orderBy);
                p.Add("@srtn", 0, DbType.String, ParameterDirection.ReturnValue);
                var result = conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure).FirstOrDefault();
                return p.Get<string>("@srtn");
            }

        }
    }
}
