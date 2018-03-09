
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
        /// <summary>
        /// 获取到任务的任务成员信息
        /// </summary>
        public List<sys_resource> GetSysResByTaskId(long task_id)
        {
            return FindListBySql<sys_resource>($"SELECT * from sys_resource where id in (SELECT resource_id from sdk_task_resource WHERE delete_time = 0  and task_id = {task_id} and contact_id is NULL) and delete_time = 0");
        }
        /// <summary>
        /// 根据项目id，和员工id，查找任务团队中相关信息
        /// </summary>
        public List<sdk_task_resource> GetListByProIdResId(long project_id,long resource_id)
        {
            return FindListBySql<sdk_task_resource>($"SELECT str.* from sdk_task_resource str INNER JOIN sdk_task st on st.id = str.task_id INNER JOIN pro_project pp on st.project_id = pp.id where pp.id = {project_id} and resource_id = {resource_id} and str.delete_time = 0 and st.delete_time = 0 and pp.delete_time = 0 ");
        }
        /// <summary>
        /// 根据项目id和联系人id获取相关信息
        /// </summary>
        public List<sdk_task_resource> GetListByConId(long project_id,long contact_id)
        {
            return FindListBySql<sdk_task_resource>($"SELECT str.* from sdk_task_resource str INNER JOIN sdk_task st on st.id = str.task_id INNER JOIN pro_project pp on st.project_id = pp.id where pp.id = {project_id} and str.contact_id = {contact_id} and str.delete_time = 0 and st.delete_time = 0 and pp.delete_time = 0 ");
        }
        /// <summary>
        /// 根据工单ID 和 联系人ID 获取相关数据
        /// </summary>
        public sdk_task_resource GetConTact(long ticketId,long contactId)
        {
            return FindSignleBySql<sdk_task_resource>($"SELECT * from sdk_task_resource where task_id = {ticketId} and contact_id = {contactId} and delete_time = 0");
        }
    }
}
