using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 新增预付
    /// </summary>
    public class ContractBlockAddDto
    {
        public int type;        // 1:预付时间；2:预付费用；3:事件
        public long contractId;
        public bool isMonthly;
        public int? delayDays;
        public DateTime startDate;
        public DateTime? endDate;
        public int? purchaseNum;
        public bool? firstPart;
        public decimal? amount;
        public decimal? hours;
        public decimal? hourlyRate;
        public bool is_billed;
        public bool status;
        public DateTime datePurchased;
        public string paymentNum;
        public int? paymentType;
        public string note;
    }
}
