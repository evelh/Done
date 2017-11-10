using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.DAL
{
    public class sdk_task_dal : BaseDAL<sdk_task>
    {
        /// <summary>
        /// 获取所有的task
        /// </summary>
        public List<sdk_task> GetProTask(long project_id,string where ="")
        {
            return FindListBySql<sdk_task>($"select * from sdk_task where delete_time = 0 and project_id = {project_id} "+where); 
        }

        public List<sdk_task> GetTaskByIds(string ids)
        {
            return FindListBySql<sdk_task>($"select * from sdk_task where delete_time = 0 and id in ({ids})");
        }
        /// <summary>
        /// 获取项目tsak  为任务，问题
        /// </summary>
        public List<sdk_task> GetProjectTask(long project_id)
        {
            return FindListBySql<sdk_task>($"select * from sdk_task where delete_time = 0 and project_id = {project_id} and type_id in({(int) TASK_TYPE.PROJECT_TASK},{(int)TASK_TYPE.PROJECT_ISSUE}) ");
            // and type_id in({(int)TASK_TYPE.PROJECT_TASK},{(int)TASK_TYPE.PROJECT_ISSUE})
        }
        /// <summary>
        /// 获取tsak 为阶段，任务，问题的task
        /// </summary>
        public List<sdk_task> GetAllProTask(long project_id)
        {
            return FindListBySql<sdk_task>($"select * from sdk_task where delete_time = 0 and project_id = {project_id} and type_id in({(int)TASK_TYPE.PROJECT_TASK},{(int)TASK_TYPE.PROJECT_ISSUE},{(int)TASK_TYPE.PROJECT_PHASE}) ");
            // and type_id in({(int)TASK_TYPE.PROJECT_TASK},{(int)TASK_TYPE.PROJECT_ISSUE})
        }
        /// <summary>
        /// 返回费率数量
        /// </summary>
        public int GetRateSum(long project_id)
        {
            return (int)GetSingle($"select count(1) from pro_project_team_role x,pro_project_team y where x.delete_time=0 and y.delete_time=0 and x.project_team_id=y.id and y.project_id={project_id}");
        }

        /// <summary>
        /// 根据no查询相关task
        /// </summary>
        public List<sdk_task> GetTaskByNo(string no)
        {
            return FindListBySql<sdk_task>($"SELECT * from sdk_task where delete_time = 0 and no like '%{no}%'");
        }
        /// <summary>
        /// 根据父阶段ID获取相应的task
        /// </summary>
        public List<sdk_task> GetTaskByParentId(long task_id)
        {
            return FindListBySql<sdk_task>($"SELECT * from sdk_task where delete_time = 0 and parent_id = {task_id}");
        }

        public List<sdk_task> GetNoParTaskByProId(long project_id)
        {
            return FindListBySql<sdk_task>($"SELECT * from sdk_task where project_id = {project_id} and parent_id is NULL and delete_time = 0");
        }
        /// <summary>
        /// 根据项目id和排序号获取唯一的task
        /// </summary>
        public sdk_task GetSinTaskBySortNo(long project_id,string sortNo)
        {
            return FindSignleBySql<sdk_task>($"SELECT sort_order from sdk_task where delete_time = 0 and project_id = {project_id} and sort_order = '{sortNo}'");
        }
    }
}
