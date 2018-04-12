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
        CRM_OPPORTUNITY_LOSS_REASON = 16,    // 丢失商机是否需要填写丢失原因
        CRM_OPPORTUNITY_WIN_REASON = 17,     // 赢得商机是否需要填写赢得原因
        SDK_EXPENSE_SHOW_WORK_TYPE=18,       // 新增编辑费用时是否显示工作类型
        INVENTORY_ACCOUNTING_METHOD=20,      // 系统配置：库存记账方法
        CTT_COST_APPROVAL_VALUE = 22,        // 新增修改成本时，如果总价在这个范围内则状态为原来状态，否则状态是待审批
        ALL_USER_ASSIGN_NODE_TOTAASL = 25,   // 允许用户分配非部门工作类型
        SDK_CHECK_RES = 26,                  // 保存任务时检查员工的可用性
        SDK_DEPARTMENT_REQUIRE = 27,         // 分配项目任务/问题时需要部门
        PRO_TASK_DONE_REASON = 28,           // 完成Task时是否必填原因
        SDK_TICKER_MERGE_QUEUE = 40,         // 工单合并-移动合并工单（源工单）到以下队列（空则不移动）
        SDK_TICKET_ADD_LABOUR = 41,          // 已完成工单是否允许添加工时
        SDK_TICKET_STATUS_LABOUR = 44,       // 添加工时的时候是否 必须将工单状态改为非“new”
        SDK_TICKET_COMPLETE_REASON = 45,     // 关闭工单或者重新打开工单需要输入原因
        SDK_ALLOW_CROSS_NIGHT = 59,          // 是否允许跨夜
        TIMEOFF_ALLOW_FLOAT = 64,            // 支持浮动假期
        TIMEOFF_ALLOW_PERSONAL = 65,         // 支持私人时间
        TIMEOFF_ALLOW_SICK = 66,             // 支持病假
        TIMEOFF_ALLOW_VACATION = 67,         // 支持年休假
        SDK_ENTRY_PROXY = 70,                // 工时是否允许代理操作
        SDK_REQUIRED_SUMMAY_NOTE = 72,       // 工时说明是否必填
        SDK_ENTRY_REQUIRED = 73,             // 工时的时间相关字段是否可以不显示
        SDK_WORKENTRY_BILL_ROUND = 74,       // 计费时长的取整方式
        SDK_WORKENTRY_WORK_ROUND = 75,       // 实际工作时长的取整
        USE_KNOWLEDGE_BASE =77,              // 是否使用知识库
    }
}
