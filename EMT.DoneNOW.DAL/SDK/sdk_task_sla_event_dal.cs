
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_sla_event_dal : BaseDAL<sdk_task_sla_event>
    {
        /// <summary>
        /// 获取到工单sla事件
        /// </summary>
        public sdk_task_sla_event GetTaskSla(long ticket_id)
        {
            return FindSignleBySql<sdk_task_sla_event>($"SELECT * from sdk_task_sla_event where delete_time = 0 and task_id = {ticket_id}");
        }
    }
}
