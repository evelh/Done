using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System.Timers;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 工作流规则的处理
    /// </summary>
    public class WorkflowRuleProcBLL
    {
        private WorkflowRuleProcBLL()
        {
            timer = new Timer();
            timer.Interval = 60000;
            timer.Elapsed += EventTimer;
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

            if (workflowList.Count > 0)
            {
                timer.Start();
                InitTickets();
            }
            else
            {
                timer.Stop();
                DisposeTickets();
            }
        }


        
        #region 工单
        private void InitTickets()
        {
            sdk_task_dal.AddEdit += TicketAddEditEvent;
            sdk_task_dal.Changed += TicketChange;
            var tks = new sdk_task_dal().FindListBySql($"select * from sdk_task where (type_id={(int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET} or type_id={(int)DicEnum.TASK_TYPE.RECURRING_TICKET_MASTER}) and delete_time=0");
            lock (locker)
            {
                tickets = new Dictionary<long, sdk_task>();
                foreach (var tk in tks)
                {
                    tickets.Add(tk.id, tk);
                }
            }
        }
        private void DisposeTickets()
        {
            sdk_task_dal.AddEdit -= TicketAddEditEvent;
            sdk_task_dal.Changed -= TicketChange;
        }

        /// <summary>
        /// 工单创建修改事件
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TicketAddEditEvent(object sender, sdk_task_dal.InsertEventArgs e)
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

        /// <summary>
        /// 修改工单id列表
        /// </summary>
        /// <param name="id"></param>
        private void TicketChange(long id)
        {
            lock (locker)
            {
                if (!tickets.ContainsKey(id))
                    tickets.Add(id, null);
                else
                    tickets[id] = null;
            }
        }
        
        private Dictionary<long, sdk_task> tickets;
        #endregion

        #region 工作流事件定时线程
        private object locker = new object();
        private Timer timer;
        private List<DictionaryEntryDto> workflowLogCache;  // 工作流触发日志缓存（36小时内）

        // 判断定时时间触发执行
        private void EventTimer(object sender, System.Timers.ElapsedEventArgs e)
        {
            DateTime crtTime = DateTime.Now;
            long crtTimeTik = Tools.Date.DateHelper.ToUniversalTimeStamp(crtTime);
            sys_workflow_log_dal logDal = new sys_workflow_log_dal();

            // 更新日志缓存
            if ((crtTime.Hour % 3 == 0 && crtTime.Minute == 0) || workflowLogCache == null)  // 3小时更新一次
                workflowLogCache = logDal.GetLogListByTime(Tools.Date.DateHelper.ToUniversalTimeStamp(crtTime.AddHours(-36)));


            sdk_task_dal taskDal = new sdk_task_dal();
            for (var i = tickets.Count - 1; i >= 0; i--)
            {
                if (tickets.ElementAt(i).Value == null)
                {
                    var ticket = taskDal.FindSignleBySql<sdk_task>($"select * from sdk_task where id={tickets.ElementAt(i).Key} and (type_id={(int)DicEnum.TASK_TYPE.SERVICE_DESK_TICKET} or type_id={(int)DicEnum.TASK_TYPE.RECURRING_TICKET_MASTER}) and delete_time=0");
                    if (ticket == null)
                        tickets.Remove(tickets.ElementAt(i).Key);
                    else
                        tickets[tickets.ElementAt(i).Key] = ticket;
                }
            }
            foreach (var wf in workflowList)
            {
                if (wf.workflow_object_id == (int)DicEnum.WORKFLOW_OBJECT.TICKET)
                {
                    lock (locker)
                    {
                        foreach (var tkt in tickets)
                        {
                            if (workflowLogCache.Exists(_ => _.val == wf.id.ToString() && _.show == tkt.Key.ToString()))
                                continue;
                            // TODO: 根据event名称判断事件及时间，event名称暂未配置
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
