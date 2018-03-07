using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using System.Data;
using Dapper;

namespace EMT.DoneNOW.DAL
{
    public class sys_workflow_dal : BaseDAL<sys_workflow>
    {
        /// <summary>
        /// 调用f_workflow_getsql返回工作流sql
        /// </summary>
        /// <param name="ruleId"></param>
        /// <param name="objType"></param>
        /// <param name="objId"></param>
        /// <returns></returns>
        public string GetWorkflowSql(long ruleId, long objType, long objId)
        {
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "f_workflow_getsql";
                p.Add("in_rule_id", ruleId);
                p.Add("in_object", objType);
                p.Add("in_id", objId);
                p.Add("@sqlrtn", 0, DbType.String, ParameterDirection.ReturnValue);
                var result = conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure).FirstOrDefault();
                return p.Get<string>("@sqlrtn");
            }
        }
    }

}
