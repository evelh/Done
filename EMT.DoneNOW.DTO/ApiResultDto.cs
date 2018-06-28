using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class ApiResultDto
    {
        public int code;
        public string msg;
        public object data;
    }
    public enum ERROR_CODE
    {
        SUCCESS = 0,                                // 成功
        ERROR = 1,                                  // 错误

        /* 通用错误 */
        PARAMS_ERROR = 1000,                        // 参数缺失或错误

        /* 登录验证错误 */
        TIME_OUT = 2000,                            // 登录超时
        USER_NOT_FIND,                              // 用户未注册
        PASSWORD_ERROR,                             // 密码错误
        LOCK,                                       // 限制登录
        USER_LIMITCOUNT,                             // 登录人数超过登录限制人数
        // Occupy

        /* CRM */
        CRM_ACCOUNT_NAME_EXIST = 3000,              // 客户名称已存在
        PHONE_OCCUPY,                               // 电话被占用
        MOBILE_PHONE_OCCUPY,



        ACTIVATION,                                  //已经激活
        NO_ACTIVATION,                               //已经失活
        SYS_NAME_EXIST,                              //员工姓名已存在
        EXIST,                                       //已经存在
        DEFAULT,                                     //已经设为默认

        SYSTEM,                                      //无法删除系统默认
        MARKET_USED,                                 //市场已经被使用
        TERRITORY_USED,                              //地域已经被使用
        REGION_USED,                                 //区域已经被使用
        COMPETITOR_USED,                             //竞争对手已经被使用
        OPPORTUNITY_SOURCE_USED,                     //商机来源已经被使用
        ACTION_TYPE_USED,                            //活动类型已经被使用
        OPPORTUNITY_STAGE_USED,                      //商机阶段已经被使用
        WIN_OPPORTUNITY_REASON_USED,                 //关闭商机原因已经被使用
        LOSS_OPPORTUNITY_REASON_USED,                //丢失商机原因已经被使用
        ACCOUNT_TYPE_USED,                           //客户类别已经被使用
        CONTRACT_TYPE_USED,                          //合同类别已经被使用
        CONTRACT_MILESTONE_USED,                     //里程碑状态已经被使用
        CONTRACT_NO_ACTIVE,                          //不存在当前激活的合同
        TICKET_SOURCE_USED,                                // 工单来源已经被使用
        TICKET_STATUS_USED,                                // 工单状态已经被使用
        TICKET_PRIORITY_USED,                                // 工单优先级已经被使用
        TICKET_ISSUE_USED,                                // 工单问题类型已经被使用
        TICKET_ISSUE_HAS_SUB,                                // 工单问题类型有子问题
        PROJECT_USED,                                // 项目已经被使用
        LEDGER_USED,                                  // z=总账代码已经被使用
        PAY_TERM_USED,                                  // 付款期限已经被使用
        PAY_TYPE_USED,                                  // 付款类型已经被使用
        SHIP_TYPE_USED,                                 // 配送类型已经被使用
        TAX_REGION_USED,                                 // 税区已经被使用
        TAX_CATE_USED,                                 // 税种已经被使用
        NOTE_TYPE_USED,                                 // 备注类型已经被使用
        NOTIFICATION_RULE,                 //通知规则表的费率为空
    }
}
