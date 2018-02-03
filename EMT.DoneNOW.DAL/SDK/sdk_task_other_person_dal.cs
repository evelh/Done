
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_other_person_dal : BaseDAL<sdk_task_other_person>
    {
        /// <summary>
        /// 获取工单或者任务的其他信息
        /// </summary>
        public List<sdk_task_other_person> GetTicketOther(long ticket_id)
        {
            return FindListBySql<sdk_task_other_person>($"SELECT * from  sdk_task_other_person where delete_time = 0 and task_id = {ticket_id}");
        }
    }
}
