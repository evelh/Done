
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
        /// <summary>
        /// 获取指定服务预定下的所有包含该负责人的信息
        /// </summary>
        public List<sdk_service_call_task_resource> GetResByCallRes(long callId,long resId)
        {
            return FindListBySql($"SELECT ssctr.* from sdk_service_call ssc INNER JOIN sdk_service_call_task ssct on ssc.id = ssct.service_call_id INNER JOIN sdk_service_call_task_resource ssctr on ssct.id = ssctr.service_call_task_id where ssc.delete_time = 0 and ssct.delete_time = 0 and ssctr.delete_time = 0 and resource_id = {resId} and ssc.id= {callId}");
        }
        // 

    }
}
