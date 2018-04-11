
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_service_call_task_dal : BaseDAL<sdk_service_call_task>
    {
        public List<sdk_service_call_task> GetTaskCall(long callId)
        {
            return FindListBySql<sdk_service_call_task>($"SELECT * from sdk_service_call_task where service_call_id = {callId} and delete_time = 0");
        }

        public sdk_service_call_task GetSingTaskCall(long callId,long ticketId)
        {
            return FindSignleBySql<sdk_service_call_task>($"SELECT * from sdk_service_call_task where service_call_id = {callId} and task_id={ticketId} and delete_time = 0");
        }

        public List<sdk_service_call_task> GetTaskCallByTask(long taskId)
        {
            return FindListBySql<sdk_service_call_task>($"SELECT * from sdk_service_call_task where task_id = {taskId} and delete_time = 0");
        }


    }
}
