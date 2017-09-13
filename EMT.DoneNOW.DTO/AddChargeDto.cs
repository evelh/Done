using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class AddChargeDto
    {
        public ctt_contract_cost cost;         // 添加成本实体
        public bool isAddCongigItem = false;   // 添加保存之后是否添加配置项向导
    }
}
