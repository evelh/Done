
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_service_call_task_resource_dal : BaseDAL<sdk_service_call_task_resource>
    {
        // 
        public List<sdk_service_call_task_resource> GetTaskResList(long callTaskId)
        {
            return FindListBySql<sdk_service_call_task_resource>($"SELECT * from sdk_service_call_task_resource where service_call_task_id = {callTaskId} and delete_time = 0");
        }

        public sdk_service_call_task_resource GetSingResCall(long callTaskId,long resId)
        {
            return FindSignleBySql<sdk_service_call_task_resource>($"SELECT * from sdk_service_call_task_resource where service_call_task_id = {callTaskId} and resource_id = {resId} and delete_time = 0");
        }
        // 
    }
}
