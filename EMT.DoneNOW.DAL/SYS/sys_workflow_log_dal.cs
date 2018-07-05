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
            log.id = GetNextIdCom();
            log.object_id = objId;
            log.workflow_id = ruleId;
            log.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            log.exec_sql = sql;
            log.remark = remark;
            Insert(log);
        }

        /// <summary>
        /// 查询指定时间内的工作流规则触发日志
        /// </summary>
        /// <param name="createTime">触发时间下限</param>
        /// <returns></returns>
        public List<DTO.DictionaryEntryDto> GetLogListByTime(long createTime)
        {
            return FindListBySql<DTO.DictionaryEntryDto>("select workflow_id as `val`,object_id as `show` from sys_workflow_log where create_time>" + createTime);
        }
    }

}
