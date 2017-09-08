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
        public Dictionary<long,string> costCodeList;      // todo 报价项对应的物料代码 类型待确定撒
        public ctt_contract contract;   //  界面上输入的合同信息

        public bool isIncludePO;
        public bool isIncludeShip;
        public bool isIncludeCharges;

        public bool convertToServiceTicket = false;  // 转换为服务台工单
        public bool convertToProject = false;  // 转换为项目成本
        public bool convertToNewContractt = false;  // 转换为合同成本（新合同）
        public bool convertToOldContract = false;  // 转换为合同成本（从已存在的合同中选择）
        public bool convertToTicket = false;  // 转换为工单成本

        // 查找带回合同时可能会涉及的字段
        public bool isAddService = false;     // 将服务/包 累加到现有服务/包
        public bool isUpdatePrice = false;     // 是否更改单价
        public bool isUpdateCost = false;      // 是否更改成本


        public DateTime effective_date;  // 生效时间--不知道干嘛用的
         // todo 通知 
    }
}
