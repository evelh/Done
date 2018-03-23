using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class TicketRecurrDayDto
    {
        public int every;
        public int no_sat;
        public int no_sun;
    }
    public class TicketRecurrWeekDto
    {
        public int every;
        public int[] dayofweek;
    }
    public class TicketRecurrMonthDto
    {
        public int month;
        public int day;
        public string no;
        public string dayofweek;
    }
}
