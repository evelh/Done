using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class MasterTicketDto
    {
        public sdk_task masterTicket;
        /// <summary>
        /// 工单的相关周期
        /// </summary>
        public sdk_recurring_ticket masterRecurr;

        public int day_day;
        public bool day_no_sat=false;
        public bool day_no_sun=false;


        public int week_week;
        public bool week_mon=false;
        public bool week_tus=false;
        public bool week_wed=false;
        public bool week_thu=false;
        public bool week_fri=false;
        public bool week_sat=false;
        public bool week_sun=false;

        public string month_type;
        public int month_month;
        public int month_day;
        public string month_week_num;  // 这个月的第几周
        public string month_week_day;  // 这周的那一天

        public string year_type;
        public string year_month;
        public int year_month_day;
        public string year_month_week_num;  // 这个月的第几周
        public string year_month_week_day;  // 这周的那一天

        // 添加备注使用
        public string noteTitle;
        public string noteDescription;
        public long publishId;
        public long noteTypeId;

        // 添加附件使用
        public List<AddFileDto> filtList;

        // 发送通知使用
        public bool ccMe = false;
        public bool ccAccMan = false;
        public bool sendFromSys = false;
        public bool ccOwn = false;
        public string ccCons;
        public string ccRes;
        public string otherEmail;
        public int tempId;
        public string subject;
        public string appText;

        // 自定义信息
        public List<UserDefinedFieldValue> udfList;

    }
}
