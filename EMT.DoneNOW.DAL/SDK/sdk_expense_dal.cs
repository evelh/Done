using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_expense_dal : BaseDAL<sdk_expense>
    {
        /// <summary>
        /// 根据项目Id 获取费用信息
        /// </summary>
        public List<sdk_expense> GetExpByProId(long project_id)
        {
            return FindListBySql<sdk_expense>($"SELECT * from sdk_expense where project_id = {project_id} and delete_time = 0");
        }
        /// <summary>
        /// 根据任务id获取相应费用信息
        /// </summary>
        public List<sdk_expense> GetExpByTaskId(long task_id)
        {
            return FindListBySql<sdk_expense>($"SELECT * from sdk_expense where task_id = {task_id} and delete_time = 0");
        }
    }
}
