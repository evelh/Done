using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public  class CloseOpportunityDto
    {
        public crm_opportunity opportunity;  // 关闭商机时修改商机信息
        public bool activateProject;  // 从报价项激活项目提案activateProposalProject
        public bool createContract; // 创建定期服务合同
        public bool addServicesToExistingContract;    // 将服务加入已存在的定期服务合同
        public bool createTicketPostSaleQueue; // 创建服务台工单售后队列
        public List<string> costCodeList;      // todo 报价项对应的物料代码 类型待确定撒
         // todo 通知
    }
}
