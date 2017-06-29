using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class OpportunityConditionDto
    {
        public int close_days;  // 商机距离关闭剩余天数
        public int probability; // 商机成功几率
        public int? stage;      // 商机阶段
    }
}
