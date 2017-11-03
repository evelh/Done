
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
        /// <summary>
        /// 获取task的关联员工
        /// </summary>
        public List<sdk_task_resource> GetResByTaskId(long taskId)
        {
            return FindListBySql<sdk_task_resource>($"SELECT * from sdk_task_resource WHERE delete_time = 0  and task_id = {taskId} and contact_id is NULL");
        }
        /// <summary>
        /// 获取task的联系人
        /// </summary>
        public List<sdk_task_resource> GetConByTaskId(long taskId)
        {
            return FindListBySql<sdk_task_resource>($"SELECT * from sdk_task_resource WHERE delete_time = 0  and task_id = {taskId} and resource_id is NULL");
        }
        /// <summary>
        /// 根据TaskId 员工ID，角色ID，获取相关任务角色配置，保证分配对象的唯一性
        /// </summary>
        public sdk_task_resource GetSinByTasResRol(long task_id,long res_id,long role_id)
        {
            return FindSignleBySql<sdk_task_resource>($"SELECT * from sdk_task_resource where task_id = {task_id} and resource_id = {res_id} and role_id = {role_id} and delete_time = 0");
        }
    }
}
