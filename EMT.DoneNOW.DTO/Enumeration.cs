using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{

    /// <summary>
    /// 字典表字典项对应的id值
    /// </summary>
    public class DicEnum
    {
        /// <summary>
        /// 客户告警类型 - 10
        /// </summary>
        public enum ACCOUNT_ALERT_TYPE  
        {
            COMPANY_DETAIL_ALERT = 36,
            NEW_TICKET_ALERT = 37,
            TICKET_DETAIL_ALERT = 38,
        }

        /// <summary>
        /// 表单模板应用范围-18
        /// </summary>
        public enum RANG_TYPE
        {
            OWN = 88,           // 我自己
            DEPARTMENT = 89,    // 指定部门
            ALL = 90,           // 任何人
        }

        /// <summary>
        /// 通知大类-20
        /// </summary>
        public enum NOTIFY_CATE
        {
            CRM = 96,               // CRM
            PROJECT = 97,           // 项目
            SERVICE_DESK = 98,      // 服务台
            SERVICE_BOOK = 99,      // 服务预定
            CONTACT = 100,          // 合同
            TIME_SHEET = 101,       // 工时表
            INVENTORY = 102,        // 库存
            TICKETS = 103,          // Taskfire工单
            OTHERS = 104,           // 杂项
        }

        /// <summary>
        /// 通知发送邮箱来源类型-24
        /// </summary>
        public enum FROM_EMAIL_TYPE
        {
            FROM_EMAIL = 251,              // 发起人
            PLATFORM_SUPPORT_EMAIL = 252,  // 平台支撑邮箱
            OTHER_EMAIL = 253,             // 其他指定邮箱
        }

        /// <summary>
        /// 表单模板类型-27
        /// </summary>
        public enum FORM_TMPL_TYPE
        {
            OPPORTUNITY = 451,      // 商机
        }

        /// <summary>
        /// 用户自定义字段对象类型-32
        /// </summary>
        public enum UDF_CATE
        {
            TASK = 511,
            TICKETS = 512,
            SITE = 513,             // 站点
            CONFIGURATION = 514,
            PRODUCTS = 515,
            CONTRACTS = 516,        // 合同
            COMPANY = 517,          // 客户
            CONTACT = 518,          // 联系人
            OPPORTUNITY = 519,      // 商机
            SALES = 520,
            ORDERS = 521,
            PROJECTS = 522,           
            CONFIGURATION_ITEMS=523,// 配置项
        }

        /// <summary>
        /// 自定义字段类型-33
        /// </summary>
        public enum UDF_DATA_TYPE
        {
            SINGLE_TEXT = 526,          // 单行文本
            MUILTI_TEXT = 527,          // 多行文本
            DATETIME = 528,             // 日期
            NUMBER = 529,               // 数字
            LIST = 530,                 // 列表
        }

        /// <summary>
        /// 自定义字段显示样式-34
        /// </summary>
        public enum UDF_DISPLAY_FORMAT
        {
            UNDEFINED = 547,        // 未定义
            SINGLE_LINE = 548,      // 单行
            MUILTI_LINE = 549,      // 多行
        }

        /// <summary>
        /// user状态-46
        /// </summary>
        public enum USER_STATUS
        {
            NORMAL = 616,     // 正常
            FREEZE = 617,     // 冻结
            EXPIRED = 618,    // 过期
        }

        /// <summary>
        /// 查询页面分类-65
        /// </summary>
        public enum QUERY_TYPE
        {
            CUSTOMER = 726,         // 客户
            CONTACT = 727,          // 联系人
        }

        /// <summary>
        /// 查询结果列字段显示类型-66
        /// </summary>
        public enum QUERY_RESULT_DISPLAY_TYPE
        {
            RETURN_VALUE = 729,     // 查找带回返回值
            ID = 730,               // id
            NUM = 731,              // 数值
            TXT = 732,              // 文本
            PIC = 733,              // 图片
            TOOLTIP = 734,          // title
        }

        /// <summary>
        /// 显示对象类型-67
        /// </summary>
        public enum OBJECT_TYPE
        {
            CUSTOMER = 735,     // 客户
            CONTACT = 736,      // 联系人
            OPPORTUNITY = 737,  // 商机
            QUOTE = 738,        // 报价
            CONTRACT = 739,     // 合同
        }

        /// <summary>
        /// 操作日志：对象种类-68
        /// </summary>
        public enum OPER_LOG_OBJ_CATE
        {
            CUSTOMER = 760,                             // 客户
            CUSTOMER_EXTENSION_INFORMATION = 761,       // 客户扩展信息
            CONTACTS = 762,                             // 联系人
            CONTACTS_EXTENSION_INFORMATION = 763,       // 联系人扩展信息
            CUSTOMER_SITE = 764,                        // 客户站点    
            TODO = 765,                                 // 待办
            FROM = 766,                                 // 表单模板
            FROMOPPORTUNITY = 767,                      // 商机表单模板
            OPPORTUNITY = 768,                          // 商机
        }

        /// <summary>
        /// 操作日志：操作类型-69
        /// </summary>
        public enum OPER_LOG_TYPE
        {
            ADD = 800,          // 新增
            DELETE = 801,       // 删除
            UPDATE = 802,       // 修改
        }

        /// <summary>
        /// 查询条件类型-70
        /// </summary>
        public enum QUERY_PARA_TYPE
        {
            SINGLE_LINE = 805,      // 单行文本
            NUMBER = 806,           // 数值
            DATE = 807,             // 日期
            DATETIME = 808,         // 日期时间
            DROPDOWN = 809,         // 下拉选择框
            MULTI_DROPDOWN = 810,   // 多选下拉框
            AREA = 811,             // 行政区
        }
    }

    public enum ActionEnum
    {
        /// <summary>
        /// 登录
        /// </summary>
        Login,
        /// <summary>
        /// 退出
        /// </summary>
        Logout,
    }
}
