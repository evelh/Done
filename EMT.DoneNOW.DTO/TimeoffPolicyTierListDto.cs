using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 休假策略分类级别
    /// </summary>
    public class TimeoffPolicyTierListDto
    {
        public int index = 1;
        public List<TimeoffPolicyTierDto> items = new List<TimeoffPolicyTierDto>();
    }

    public class TimeoffPolicyTierDto
    {
        public long id;                 // id
        public int cate;                // 假期类别
        public decimal annualHours;     // 年假小时数
        public decimal capHours;        // 滚存限额
        public decimal? hoursPerPeriod; // 每周期时长
        public int eligibleMonths;      // 起始月数
    }
}
