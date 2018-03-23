using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 休假策略关联员工信息
    /// </summary>
    public class TimeoffAssociateResourceDto
    {
        public int index = 1;
        public List<TimeoffResourceTierDto> items = new List<TimeoffResourceTierDto>();
    }

    public class TimeoffResourceTierDto
    {
        public long id;
        public string resourceId;
        public string resourceName;
        public DateTime effBeginDate;
        public DateTime? effEndDate;
    }
}
