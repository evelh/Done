
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_other_dal : BaseDAL<sdk_task_other>
    {
        /// <summary>
        /// 获取工单或者任务的其他信息
        /// </summary>
        public List<sdk_task_other> GetTicketOther(long ticket_id)
        {
            return FindListBySql<sdk_task_other>($"SELECT * from  sdk_task_other where delete_time = 0 and task_id = {ticket_id}");
        }
    }
}
