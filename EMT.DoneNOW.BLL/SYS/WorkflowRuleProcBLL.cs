using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class WorkflowRuleProcBLL
    {
        private WorkflowRuleProcBLL()
        {
            sdk_task_dal.AddEdit += TicketAddEditEvent;
        }
        private static WorkflowRuleProcBLL singleInstance = new WorkflowRuleProcBLL();
        public static WorkflowRuleProcBLL Instance
        {
            get { return singleInstance; }
        }

        private sys_workflow_dal dal = new sys_workflow_dal();
        private List<WorkflowRuleDto> workflowList;     // 激活可用的工作流列表
        /// <summary>
        /// 初始化工作流列表
        /// </summary>
        public void WorkflowRuleChanged()
        {
            workflowList = new WorkflowRuleBLL().GetAllWorkflow();
        }


        #region 工作流事件
        /// <summary>
        /// 工单创建事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public void TicketAddEditEvent(object sender, sdk_task_dal.InsertEventArgs e)
        {
            var ticket = sender as sdk_task;
            if (ticket.type_id != (int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET
                && ticket.type_id != (int)DicEnum.TASK_TYPE.RECURRING_TICKET_MASTER)
                return;

            sys_workflow_log_dal logDal = new sys_workflow_log_dal();
            foreach (var wf in workflowList)
            {
                if (wf.workflow_object_id == (int)DicEnum.WORKFLOW_OBJECT.TICKET)
                {
                    foreach (var evt in wf.eventJson)
                    {
                        if (((string)evt["event"]).Equals(e.EventType))   // 新增事件
                        {
                            if (((string)evt["value"]).Equals("1") || ((string)evt["value"]).Equals("2"))   // 任何人或员工新增
                            {
                                string sql = GetWorkflowSql(wf.id, wf.workflow_object_id, ticket.id);
                                if (string.IsNullOrEmpty(sql))
                                    continue;

                                var workflowSql = new Tools.Serialize().DeserializeJson<List<dynamic>>(sql);
                                foreach (var wfsql in workflowSql)
                                {
                                    if (string.IsNullOrEmpty((string)wfsql["update"]))
                                        continue;

                                    if (dal.ExecuteSQL((string)wfsql["update"]) > 0)
                                        logDal.AddWorkflowLog(wf.id, ticket.id, (string)wfsql["update"]);
                                }
                            }
                        }
                    }
                }
            }
        }

        #endregion

        /// <summary>
        /// 根据工作流获取sql
        /// </summary>
        /// <param name="ruleId">工作流id</param>
        /// <param name="objType">对象类型</param>
        /// <param name="objId">对象id</param>
        /// <returns></returns>
        private string GetWorkflowSql(long ruleId, long objType, long objId)
        {
            return dal.GetWorkflowSql(ruleId, objType, objId);
        }
    }
}
