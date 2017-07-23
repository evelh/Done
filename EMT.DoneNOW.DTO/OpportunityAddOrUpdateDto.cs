using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class OpportunityAddOrUpdateDto
    {
        public crm_opportunity general;         // 基本信息
        public List<UserDefinedFieldValue> udf; // 自定义字段
        // TODO: activity
        public com_notify_email notify;         // 通知
    }
}
