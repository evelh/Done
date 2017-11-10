using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_budget_dal : BaseDAL<sdk_task_budget>
    {
        /// <summary>
        /// 根据taskid和合同费率id查找相关值
        /// </summary>
        public sdk_task_budget GetSinByTIdRid(long task_id,long crId)
        {
            return FindSignleBySql<sdk_task_budget>($"SELECT * from sdk_task_budget where delete_time = 0 and task_id = {task_id} and contract_rate_id = {crId}");
        }
        /// <summary>
        /// 根据taskid获取相关信息
        /// </summary>
        public List<sdk_task_budget> GetListByTaskId(long task_id)
        {
            return FindListBySql<sdk_task_budget>($"SELECT * from sdk_task_budget where task_id = {task_id} and delete_time = 0");
        }

    }
}
