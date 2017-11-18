using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 系统设置信息表id枚举
    /// </summary>
    public enum SysSettingEnum
    {
       
        SHIPITEM_COSTCODE_CLOSE = 14,        // 配送类型的报价项关闭商机时默认的物料代码
        CRM_OPPORTUNITY_LOSS_REASON = 16,   // 丢失商机是否需要填写丢失原因
        CRM_OPPORTUNITY_WIN_REASON = 17,    // 赢得商机是否需要填写赢得原因
        ALL_USER_ASSIGN_NODE_TOTAASL = 25,   // 允许用户分配非部门工作类型
        PRO_TASK_DONE_REASON = 28,           // 完成Task时是否必填原因
        SDK_ALLOW_CROSS_NIGHT = 59,          // 是否允许跨夜
        SDK_REQUIRED_SUMMAY_NOTE = 72,            // 工时说明是否必填
        SDK_WORKENTRY_BILL_ROUND = 74,            // 计费时长的取整方式
        SDK_WORKENTRY_WORK_ROUND = 75,            // 实际工作时长的取整
    }
}
