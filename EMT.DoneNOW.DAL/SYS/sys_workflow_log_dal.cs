using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sys_workflow_log_dal : BaseDAL<sys_workflow_log>
    {
        /// <summary>
        /// 新增工作流规则执行日志
        /// </summary>
        /// <param name="ruleId">工作流规则id</param>
        /// <param name="objId">对象id</param>
        /// <param name="sql">工作流执行sql</param>
        /// <param name="remark">备注</param>
        public void AddWorkflowLog(long ruleId, long objId, string sql, string remark = null)
        {
            sys_workflow_log log = new sys_workflow_log();
            sys_workflow_log_dal dal = new sys_workflow_log_dal();
            log.id = dal.GetNextIdCom();
            log.object_id = objId;
            log.workflow_id = ruleId;
            log.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            log.exec_sql = sql;
            log.remark = remark;
            dal.Insert(log);
        }
    }

}
