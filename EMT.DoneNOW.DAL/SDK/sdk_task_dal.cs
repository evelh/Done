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
        /// 获取项目tsak
        /// </summary>
        public List<sdk_task> GetProjectTask(long project_id)
        {
            return FindListBySql<sdk_task>($"select * from sdk_task where delete_time = 0 and project_id = {project_id} and type_id in({(int) TASK_TYPE.PROJECT_TASK},{(int)TASK_TYPE.PROJECT_ISSUE}) ");
            // and type_id in({(int)TASK_TYPE.PROJECT_TASK},{(int)TASK_TYPE.PROJECT_ISSUE})
        }
        /// <summary>
        /// 返回费率数量
        /// </summary>
        public int GetRateSum(long project_id)
        {
            return (int)GetSingle($"select count(1) from pro_project_team_role x,pro_project_team y where x.delete_time=0 and y.delete_time=0 and x.project_team_id=y.id and y.project_id={project_id}");
        }
    }
}
