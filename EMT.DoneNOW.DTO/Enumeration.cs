using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 字典表索引表
    /// </summary>
    public enum GeneralTableEnum
    {
        REGION = 1,             // 客户区域
        TERRITORY = 2,          // 客户地域
        MARKET_SEGMENT = 3,
        COMPETITOR = 4,
        TAX_REGION = 5,
        ACCOUNT_TYPE = 6,
        ACTION_TYPE = 7,
        OPPORTUNITY_STAGE = 11,
        OPPORTUNITY_SOURCE = 12,
        OPPORTUNITY_INTEREST_DEGREE = 13,
        OPPORTUNITY_WIN_REASON_TYPE = 14,
        OPPORTUNITY_LOSS_REASON_TYPE = 15,
        OPPORTUNITY_ADVANCED_FIELD = 16,        // 商机扩展字段
        OPPORTUNITY_STATUS = 17,
        FORM_TEMPLATE_RANGE_TYPE = 18,
        PROJECTED_CLOSED_DATE = 19,
        NOTIFICATION_TEMPLATE_CATE_DATE_GROUP=23,//通知大类对应的变量分组
        FORM_TEMPLATE_TYPE = 27,
        PAYMENT_TERM=29,                         // 报价：付款期限           
        PAYMENT_TYPE=30,                         // 报价：付款类型
        PAYMENT_SHIP_TYPE=31,                    // 报价：配送类型
        DATE_DISPLAY_FORMAT = 35,
        TIME_DISPLAY_FORMAT = 36,
        NUMBER_DISPLAY_FORMAT = 37,
        CURRENCY_POSITIVE_FORMAT = 38,
        CURRENCY_NEGATIVE_FORMAT = 39,
        QUOTE_ITEM_TYPE =42,                      // 报价项：类型
        QUOTE_ITEM_PERIOD_TYPE=43,               // 报价项：付费周期类型
        QUOTE_ITEM_TAX_CATE=44,                  // 报价项：税收种类
        NAME_SUFFIX = 48,                        
    }

    /// <summary>
    /// 字典表字典项对应的id值
    /// </summary>
    public class DicEnum
    {
        /// <summary>
        /// 活动类型 - 7
        /// </summary>
        public enum ACTIVITY_TYPE
        {
            OPPORTUNITYUPDATE = 21,          // 商机更新
            PHONE = 22,                    // 电话
            MEETING = 23,                  // 会议
            OUTLINE = 24,                    // 概要
            GRAFFITI_RECORD = 25,            // 涂鸦记录
            EMAIL = 26,                      // 邮件
            IN_CHARGE = 27,                  // 计费中
            SALES = 28,                      // 销售
            CANCELLATION = 29,               // 注销

        }


        /// <summary>
        /// 活动种类 - 8
        /// </summary>
        public enum ACTIVITY_CATE
        {
            TODO = 30,
            NOTE = 31,
        }


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
        /// 商机阶段-11
        /// </summary>
        public enum OPPORTUNITY_STAGE
        {
            NEW_CLUE = 39,                        // 新线索
            INITIAL_CONTACT = 40,                 // 初次联系
            BY_IDENTIFICATION = 41,               // 通过鉴定
            PROPOSAL_MAKING = 42,                 // 制定建议书
            SENDING_CONTRACT = 43,                // 发送合同
            CLOSE = 44                            // 关闭
        }
        /// <summary>
        /// 商机来源-12
        /// </summary>
        public enum OPPORTUNITY_SOURCE
        {
            COLD_CALL = 45,                            // 
            CUSTOMER_REFERRAL = 46,                    // 
            DIRECT_MAIL = 47,                          // 
            EMAIL_CAMPAIGN = 48,                       // 
            EMPLOYEE_REFERRAL = 49,                    // 
            EXISTING_CUSTOMER = 50,                    // 
            GOOGLE = 51,                               // 谷歌
            INTERNET = 52,                             // 互联网
            MAIL_CAMPAIGN = 53,                        // 
            MICROSOFT = 54,                            // 微软
            NETWORKING_EVENT = 55,                     // 
            PARTNER_REFERRAL = 56,                     // 
            PROSPECTING = 57,                          // 勘探
            PUBLIC_SPEAKING_SEMINAR = 58,              // 
            SURVEY = 59,                               // 调查
            TELEMARKETING = 60,                        // 电话营销
            TRADE_SHOW = 61,                           // 
            VENDOR = 62,                               // 供应商
            WEBSITE = 63                               // 网站

        }
        /// <summary>
        /// 商机状态-17
        /// </summary>
        public enum OPPORTUNITY_STATUS
        {
            NOTREADYTOBUY=83,                              // 考虑中
            ACTIVE=84,                                     // 激活
            LOST=85,                                       // 丢失
            CLOSED=86,                                     // 关闭
            IMPLEMENTED=87,                                // 实施          
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
            QUOTE_TEMPLATE_OTHERS = 105, //报价模板-其他
            QUOTE_TEMPLATE_BODY =106,  //报价模板-body           


        }
        /// <summary>
        /// 通知事件-21
        /// </summary>
        public enum NOTIFY_EVENT
        {
            OPPORTUNITY_CREATEDOREDITED,                          // 商机-创建或编辑
            OPPORTUNITY_CLOSED,                                   // 商机-达成
            OPPORTUNITY_RE_ASSIGNED,                              // 商机-再分配
            OPPORTUNITY_LOST,                                     // 商机-丢失
            //OPPORTUNITY ATTACHMENT - ADDED,                     // 
            //QUOTE - CREATED OR EDITED,                          // 
            //SALES ORDER - CREATED OR EDITED,                    // 
            //SALES ORDER ATTACHMENT - ADDED,                     // 
            //TO-DO - CREATED OR EDITED,                          // 
            //NOTE - CREATED OR EDITED,                           // 
            //ACCOUNT - CANCELED,                                 // 
            //ACCOUNT ATTACHMENT - ADDED,                         // 
            //CONFIGURATION ITEM - CREATED,                       // 
            //CONFIGURATION ITEM ATTACHMENT - ADDED,              // 
            //PROJECT - CREATED,                                  // 
            //PROJECT - COMPLETED,                                // 
            //PROJECT ATTACHMENT - ADDED,                         // 
            //PROJECT NOTE - CREATED OR EDITED,                   // 
            //TASK - CREATED OR EDITED,                           // 
            //TASK - COPIED,                                      // 
            //TASK ATTACHMENT - ADDED,                            // 
            //TASK TIME ENTRY - CREATED OR EDITED,                // 
            //TASK NOTE - CREATED OR EDITED,                      // 
            //ISSUE - CREATED OR EDITED,                          // 
            //TICKET - CREATED OR EDITED,                         // 
            //TICKET - FORWARDED,                                 // 
            //TICKET ATTACHMENT - ADDED,                          // 
            //TICKET TIME ENTRY - CREATED OR EDITED,              // 
            //TICKET NOTE - CREATED OR EDITED,                    // 
            //RECURRENCE MASTER - CREATED OR EDITED,              // 
            //QUICK CALL - CREATED,                               // 
            //SERVICE CALL - CREATED OR EDITED,                   // 
            //BLOCK HOUR CONTRACT - NOTIFICATION RULE,            // 
            //PER TICKET CONTRACT - NOTIFICATION RULE,            // 
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
            CONFIGURATION_ITEMS = 523,// 配置项
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
        /// 报价模板纸张尺寸-40
        /// </summary>
        public enum PAGE_SIZE
        {
           LETTER = 584,         //信纸：8.5" x 11" （215.9 mm x 279.4 mm）
            A4 = 585,            //A4：8.25" x 11.75 （210 mm x 297 mm）
        }

        /// <summary>
        /// 报价模板：页码位置-41
        /// </summary>
        public enum PAGE_NUMBER_LOCATION
        {
            NO = 588,                //不显示
            BOTTOMLEFT = 589,         //底部靠左
            BOTTOMCENTER = 590,        //底部居中
            BOTTOMRIGHT = 591,        //底部靠右
        }

        /// <summary>
        /// 报价项：类型-42
        /// </summary>
        public enum QUOTE_ITEM_TYPE
        {
            PRODUCT=600,                 // 产品
            DEGRESSION=601,              // 成本
            WORKING_HOURS=602,           // 工时
            COST=603,                    // 费用
            DISTRIBUTION_EXPENSES=604,   // 配送费用
            DISCOUNT=605,                // 折扣   
            SERVICE=606,                 // 服务
            SERVICE_PACK=607,            // 服务包
            START_COST=608,              // 初始费用

        }
        /// <summary>
        /// 报价项：付费周期类型-43
        /// </summary>
        public enum QUOTE_ITEM_PERIOD_TYPE
        {
            ONE_TIME=609,    // 一次性收费
            MONTH=610,       // 按月收费
            QUARTER=611,     // 按季度收费
            YEAR=612,        // 按年收费

        }
        /// <summary>
        /// 报价项：税收种类-44
        /// </summary>
        public enum QUOTE_ITEM_TAX_CATE
        {
            TAXABLE=599,       // 应纳税
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
        /// 查询页面cat_id-65
        /// </summary>
        public enum QUERY_CATE
        {
            COMPANY = 726,          // 客户
            CONTACT = 727,          // 联系人
            COMPANY_CALLBACK = 728, // 客户查找带回
            OPPORTUNITY = 865,      // 商机
            QUOTE = 866,            // 报价
            ROLL_CALLBACK = 867,    // 角色查找带回
            QUOTE_TEMPLATE = 868,   // 报价模板
            ADDRESS_CALLBACK = 869, // 地址查找带回
            OPPORTUNITY_COMPANY_VIEW = 870,     // 客户管理-详情-商机查询
            CONTACT_COMPANY_VIEW = 871,         // 客户管理-详情-联系人查询
            SUBCOMPANY_COMPANY_VIEW = 872,      // 客户管理-详情-子客户查询
            OPPORTUNITY_CONTACT_VIEW = 873,     // 联系人管理-详情-商机查询
            SUB_COMPANY_CALLBACK = 877,         // 独立客户查找带回（没有父客户和子客户）
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
            NOTIFY = 769,                               // 通知
            ACTIVITY = 760,                             // 活动   // todo 数据库添加
            QUOTE = 761,                                // 报价   todo 数据库添加
            QUOTE_ITEM=762,                             // 报价项   todo 数据库添加
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
            NUMBER = 806,           // 数值(做范围判断)
            DATE = 807,             // 日期
            DATETIME = 808,         // 日期时间
            DROPDOWN = 809,         // 下拉选择框
            MULTI_DROPDOWN = 810,   // 多选下拉框
            AREA = 811,             // 行政区
            CALLBACK = 812,         // 查找带回
            MUILT_CALLBACK = 814,   // 多选查找带回
            NUMBER_EQUAL = 816,     // 数值(做等于判断)
            TIMESPAN = 817,         // 日期-时间戳
        }

        /// <summary>
        /// 系统管理：系统配置：关闭/丢失商机必填项-81
        /// </summary>
        public enum SYS_CLOSE_OPPORTUNITY
        {
            NEED_TYPE = 1017,           // 需要原因类型
            NEED_TYPE_DETAIL = 1018,    // 需要原因类型和详情
            NEED_NONE = 1019,           // 不需要
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

    /// <summary>
    /// 查询分页面
    /// </summary>
    public enum QueryType
    {
        CompanyOpportunity = 1,     // 客户管理-商机查询
        CompanyTicket = 2,          // 客户管理-工单查询
        CompanyConfiguration = 3,   // 客户管理-配置项查询
        Company = 4,                // 客户管理-客户查询
        Contact = 5,                // 联系人管理-联系人查询
        CompanyCallBack = 6,        // 查找带回客户
        Opportunity = 7,            // 商机管理-商机查询
        Quote = 8,                  // 报价管理-报价查询
        CallBackRoll = 9,           // 角色查找带回
        QuoteTemplate = 10,         // 报价模板管理-查询
        AddressCallBack = 11,      // 地址查找带回
        OpportunityCompanyView = 12,       // 客户管理-详情-商机查询
        ContactCompanyView = 13,           // 客户管理-详情-联系人查询
        SubcompanyCompanyView = 14,        // 客户管理-详情-子客户查询
        OpportunityContactView = 15,       // 联系人管理-详情-商机查询
    }
    /// <summary>
    /// 打开新窗口的名称
    /// </summary>
    public enum OpenWindow
    {
        CompanyAdd = 101,                           // 
        CompanyEdit = 102,                          // 
        CompanyDelete = 103,                        // 
        CompanyNameSmilar = 104,                    // 名称相似
        CompanySelect = 105,                        // 查找带回客户
        Subsidiaries = 106,                         // 添加子客户
        CompanyView = 107,
        ParentCompanyView = 108,
        CompanySiteConfiguration = 109,             // 客户站点页面

        ContactAdd = 111,                            //
        ContactEdit = 112,                            //
        ContactView = 114,                            // 查看联系人
        ContactLocationSelect = 113,                  // 联系人页面地址的查找带回

        OpportunityAdd = 121,                       // 添加商机
        OpportunityEdit = 122,                      // 修改商机
        OpportunityLose = 123,                    // 丢失商机
        OpportunityView = 124,                    // 查看商机
        
        QuoteAdd = 131,                             // 报价新增
        QuoteEdit = 132,                            // 报价修改
        QuoteLost = 133,                            // 丢失报价
        QuoteView = 134,                            // 电子报价单预览

        LocationAdd = 141,                         // 地址新增
        LoactionEdit = 142,                        // 地址修改

        TodoAdd = 150,                          // 新增活动
        NoteAdd = 151,                          // 备注新增

        RoleSelect = 160,                        // 角色查询

        QuoteItemAdd = 170,                      // 报价项新增
        QuoteItemEdit = 171,                     // 报价项修改
        QuoteItemManage = 172,                   // 报价项管理

        QuoteTemplateAdd = 181,                 // 报价模板新增
        QuoteTemplateEdit = 182,                // 报价模板编辑
    }
}
