using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 休假信息
    /// </summary>
    public class TimeoffInfoDto
    {
        public DateTime timeoffDate;    // 休假日期
        public string monthDay;         // 日期月日
        public string tooltip;          // tooltip
        public int status_id;           // 状态id
        public string status;           // 状态
    }
}
