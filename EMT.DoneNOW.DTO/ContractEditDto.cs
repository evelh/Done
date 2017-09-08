using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class ContractEditDto
    {
        public ctt_contract contract;
        public string accountName;      // 客户名称
        public string contactName;      // 联系人名称
        public string billToAccount;    // 计费客户名称
        public string billToContact;    // 合同通知联系人名称
        public string costCode;         // 成本代码
    }
}
