
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_checklist_dal : BaseDAL<sdk_task_checklist>
    {
        /// <summary>
        /// 根据工单 Id 获取相应检查单
        /// </summary>
        public List<sdk_task_checklist> GetCheckByTask(long task_id)
        {
            return FindListBySql<sdk_task_checklist>($"SELECT * from sdk_task_checklist where task_id = {task_id} and delete_time = 0");
        }
    }
}
