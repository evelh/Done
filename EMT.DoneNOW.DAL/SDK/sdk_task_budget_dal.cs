using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_budget_dal : BaseDAL<sdk_task_budget>
    {
        public sdk_task_budget GetSinByTIdRid(long task_id,long crId)
        {
            return FindSignleBySql<sdk_task_budget>($"SELECT * from sdk_task_budget where delete_time = 0 and task_id = {task_id} and contract_rate_id = {crId}");
        }

    }
}
