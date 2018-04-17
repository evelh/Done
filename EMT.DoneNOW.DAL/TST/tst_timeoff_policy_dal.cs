using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using System.Data;
using Dapper;

namespace EMT.DoneNOW.DAL
{
    public class tst_timeoff_policy_dal : BaseDAL<tst_timeoff_policy>
    {
        /// <summary>
        /// 重新计算用户的假期分配和余额
        /// </summary>
        /// <param name="resourceId">员工id</param>
        /// <param name="effDate">重新计算的生效日期</param>
        public void ReCalcResourceTimeoffActivityBalance(long resourceId, DateTime effDate)
        {
            using (IDbConnection conn = DapperHelper.BuildConnection())
            {
                var p = new DynamicParameters();
                string funcName = "p_ins_timeoff_activity";
                p.Add("in_resource", resourceId);
                p.Add("in_begin", effDate);
                conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure);
                
            }
        }
    }

}
