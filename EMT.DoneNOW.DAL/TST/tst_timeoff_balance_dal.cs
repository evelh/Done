using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using System.Data;
using Dapper;

namespace EMT.DoneNOW.DAL
{
    public class tst_timeoff_balance_dal : BaseDAL<tst_timeoff_balance>
    {
        /// <summary>
        /// 重新计算用户的假期余额
        /// </summary>
        /// <param name="resourceId">员工id</param>
        /// <param name="cate">请假类型</param>
        /// <param name="effDate">重新计算的生效日期</param>
        public void ReCalcResourceTimeoffBalance(long resourceId, DTO.CostCode cate, DateTime effDate)
        {
            try
            {
                using (IDbConnection conn = DapperHelper.BuildConnection())
                {
                    var p = new DynamicParameters();
                    string funcName = "p_ins_timeoff_activity";
                    p.Add("in_resource", resourceId);
                    p.Add("in_begin", effDate);
                    p.Add("in_cate", (int)cate);
                    conn.Query(funcName, p, null, true, null, CommandType.StoredProcedure);

                }
            }
            catch (Exception e)     // 可能超时，超时返回
            {
                return;
            }
        }
    }

}
