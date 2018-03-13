using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_task_relation_dal : BaseDAL<sdk_task_relation>
    {
        // SELECT * from sdk_task_relation where task_id =9180 and parent_task_id = 9269 and delete_time = 0
        public sdk_task_relation GetRela(long ticketId,long relaTicketId)
        {
            return FindSignleBySql<sdk_task_relation>($"SELECT * from sdk_task_relation where task_id ={ticketId} and parent_task_id = {relaTicketId} and delete_time = 0");
        }
    }
}
