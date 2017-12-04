using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_predecessor_dal : BaseDAL<sdk_task_predecessor>
    {
        /// <summary>
        /// 根据taskid 获取到将这个作为前驱任务的Task
        /// </summary>
        public List<sdk_task> GetTaskByPreId(long preTaskId)
        {
            return FindListBySql<sdk_task>($"SELECT * from sdk_task where id in( SELECT task_id from sdk_task_predecessor where predecessor_task_id = {preTaskId} and delete_time = 0)  and delete_time = 0");
        } 
        /// <summary>
        /// 查找相关前驱任务
        /// </summary>
        public List<sdk_task_predecessor> GetRelList(long taskId)
        {
            return FindListBySql<sdk_task_predecessor>($"SELECT * from sdk_task_predecessor where task_id = {taskId} AND delete_time = 0");
        }
        /// <summary>
        /// 根据任务和前驱任务的id去查找到唯一的前驱任务信息
        /// </summary>
        public sdk_task_predecessor GetSinByTaskAndPre(long task_id,long pre_task_id)
        {
            return FindSignleBySql<sdk_task_predecessor>($"SELECT * from sdk_task_predecessor  where delete_time = 0 and task_id={task_id} and predecessor_task_id = {pre_task_id}");
        }
    }
}
