
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class sdk_recurring_ticket_dal : BaseDAL<sdk_recurring_ticket>
    {
        public sdk_recurring_ticket GetByTicketId(long ticketId)
        {
            return FindSignleBySql<sdk_recurring_ticket>($"SELECT * from sdk_recurring_ticket where task_id = {ticketId} and delete_time = 0");
        }
    }
}
