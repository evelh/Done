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

        public List<long> notifyUserIds;        // 邮件通知的员工id
        public string notifySubject;            // 邮件通知的主题
        public string notifyMessage;            // 邮件通知的消息
        public string notifyEmails;             // 邮件通知其他邮箱
    }
}
