using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 新增合同实体
    /// </summary>
    public class ContractAddDto
    {
        public ctt_contract contract;           // 合同主表信息
        public List<UserDefinedFieldValue> udf; // 合同自定义字段
        public List<ctt_contract_milestone> milestone;      // 合同里程碑

        public List<ServiceInfoDto> serviceList;        // 服务列表

        public List<ContractRateDto> rateList;          //角色费率

        public List<long> notifyUserIds;        // 邮件通知的员工id
        public string notifySubject;            // 邮件通知的主题
        public string notifyMessage;            // 邮件通知的消息
        public string notifyEmails;             // 邮件通知其他邮箱

        public decimal? alreadyReceived;        // 固定价格合同-已收款总额
        public decimal? toBeInvoiced;           // 固定价格合同-待开票总额
        public long? defaultCostCode;           // 固定价格合同-默认里程碑计费代码
    }

    public class ServiceInfoDto
    {
        public decimal price;
        public decimal number;
        public long serviceId;
        public sbyte type;    // 1:服务；2：服务包
    }

    public class ContractRateDto
    {
        public long roleId;
        public decimal rate;
    }
}
