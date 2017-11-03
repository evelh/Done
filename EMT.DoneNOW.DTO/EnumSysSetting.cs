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
    }
}
