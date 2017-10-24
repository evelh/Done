
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_resource_dal : BaseDAL<sdk_task_resource>
    {
        /// <summary>
        /// 根据taskid 获取任务分配对象
        /// </summary>
        public List<sdk_task_resource> GetTaskResByTaskId(long taskId)
        {
            return FindListBySql<sdk_task_resource>($"SELECT * from sdk_task_resource WHERE delete_time = 0  and task_id = {taskId}");
        }
            
    }
}
