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
        CALENDAR_DISPLAY = 9,       //日历显示模式
        OPPORTUNITY_STAGE = 11,
        OPPORTUNITY_SOURCE = 12,
        OPPORTUNITY_INTEREST_DEGREE = 13,
        OPPORTUNITY_WIN_REASON_TYPE = 14,
        OPPORTUNITY_LOSS_REASON_TYPE = 15,
        OPPORTUNITY_ADVANCED_FIELD = 16,        // 商机扩展字段
        OPPORTUNITY_STATUS = 17,
        FORM_TEMPLATE_RANGE_TYPE = 18,
        PROJECTED_CLOSED_DATE = 19,
        NOTIFICATION_TEMPLATE_CATE_DATE_GROUP = 23,//通知大类对应的变量分组
        FORM_TEMPLATE_TYPE = 27,
        SALES_ORDER_STATUS = 28,                   // 销售订单状态
        PAYMENT_TERM = 29,                         // 报价：付款期限           
        PAYMENT_TYPE = 30,                         // 报价：付款类型
        PAYMENT_SHIP_TYPE = 31,                    // 报价：配送类型
        DATE_DISPLAY_FORMAT = 35,
        TIME_DISPLAY_FORMAT = 36,
        NUMBER_DISPLAY_FORMAT = 37,
        CURRENCY_POSITIVE_FORMAT = 38,
        CURRENCY_NEGATIVE_FORMAT = 39,
        QUOTE_ITEM_TYPE = 42,                      // 报价项：类型
        QUOTE_ITEM_PERIOD_TYPE = 43,               // 报价项：付费周期类型
        QUOTE_ITEM_TAX_CATE = 44,                  // 报价项：税收种类
        UDF_FILED_GROUP=47,                        //自定义字段分组
        NAME_SUFFIX = 48,
        SEX = 49,
        EMAILTYPE = 50,
        OUTSOURCE_SECURITY = 51,                  //外包权限
        RESOURCE_TYPE = 52,                     // 员工类型
        PAYROLL_TYPE = 53,                      // 薪资类型
        TRAVEL_RESTRICTIONS = 54,               // 员工出差限度
        TIME_OFF_PERIOD_TYPE = 56,              // 休假策略：累计增长周期类型
        ATTACHMENT_TYPE = 62,                   // 附件类型
        DEPARTMENT_CATE = 64,                     //部门：类型
        ACCOUNT_SUFFIX = 75,                     // 客户名称后缀
        LIMIT_TYPE = 76,                         //系统权限：类型 取值 有无、全部部分 等
        LIMIT_TYPE_VALUE = 77,                    //系统权限：类型详情 取值 有无（有、无）、全部部分（全部、我的、无）等
        MATERIAL_CODE_TO_USE = 80,              // 系统管理：系统配置：配送报价项转为账单时使用的物料代码
        HOLIDAY_SET = 94,                       // 节假日设置
        LINE_OF_BUSINESS=95,                    //系统管理：组织：业务条线
        COST_CODE_CATE=106,                     //产品：成本种类
        INSTALLED_PRODUCT_CATE = 108,           // 配置项种类
        LICENSE_TYPE = 109,                      //安全等级：授权类型
        QUOTE_GROUP_BY = 110,                    // 报价分组条件
        CONTRACT_TYPE=111,                     // 合同类型
        CONTRACT_CATE = 112,                    // 合同分类
        EXPENSE_TYPE = 113,                     // 费用类型
        CHARGE_TYPE = 114,                      // 合同的成本类型
        CHARGE_STATUS = 115,                    // 合同的成本状态
        CONTRACT_MILESTONE=117,                  //合同里程碑
        BILL_POST_TYPE = 118,                   // 合同：工时计费设置
        ACCOUNT_DEDUCTION_TYPE=121,              //审批并提交操作类型
        PROJECT_TYPE = 123,                       // 项目类型
        PROJECT_STATUS =124,                       // 项目：项目状态
        PROJECT_LINE_OF_BUSINESS=125,              // 项目业务范围
        TICKET_TYPE = 129,                         // 工单类型
        TASK_TYPE =130,                            //任务类型
        TASK_ISSUE_TYPE = 132,                     // 工单问题类型
        TASK_PRIORITY_TYPE = 134,                  // 工单优先级
        TICKET_STATUS =135,                        // 工单状态
        TASK_SOURCE_TYPES = 137,                   // 任务来源
        INVOICE_TEMPLATE_BODY_GROUP_BY =141,      //发票模板主体-分组条件
        INVOICE_TEMPLATE_BODY_ITEMIZE =142,      //发票模板主体-逐项列出
        INVOICE_TEMPLATE_BODY_ORDER_BY =143,     //发票模板主体-排序条件
        NOTE_PUBLISH_TYPE = 146,                 // 合同/项目等备注发布类型
        ATTACHMENT_PUBLISH_TYPE = 147,           // 附件发布类型
        TASK_LIBRARY_CATE  = 149,                 // 任务库种类
        SERVICE_CALL_STATUS = 152,                // 服务请求状态
        ITEM_DESC_DISPLAY_TYPE = 155,               // 采购项描述信息显示内容类型
        TIMEOFF_REQUEST_STATUS=158,                // 休假申请状态
        KNOWLEDGE_BASE_CATE = 164,              // 知识库文章目录
        KB_PUBLISH_TO_TYPE=165,                  // 知识库：发布对象类型
        TICKET_CATE = 167,                       // 工单种类
        SKILLS_CATE = 175,                      // 技能类别
        DASHBOARD_COLOR_THEME = 184,            // 仪表板色系
        WIDGET_TYPE = 189,                      // 小窗口类型
        WIDGET_ENTITY = 190,                    // 小窗口实体
        DYNAMIC_START_DATE_TYPE = 196,          // 动态日期开始日期类型
        DYNAMIC_END_DATE_TYPE = 197,            // 动态日期结束日期类型
        SYS_TICKET_RESOLUTION_METRICS = 206,    // 工单解决参数设置
    }

    /// <summary>
    /// 字典表字典项对应的id值
    /// </summary>
    public class DicEnum
    {
        /// <summary>
        /// 客户类型 - 6
        /// </summary>
        public enum ACCOUNT_TYPE
        {
            CUSTOMER = 14,                       // 客户Customer 
            LEADER = 15,                         // 领导者Leads
            POTENTIAL_CUSTOMER = 16,             // 潜在客户Prospects
            TERMINATION_OF_COOPERATION = 17,     // 终止合作Dead
            CANCELLATION_OF_CUSTOMER = 18,       // 注销客户Cancelation
            MANUFACTURER = 19,                   // 厂商Vendor 
            COOPERATIVE_PARTNER = 20,            // 合作伙伴Partners
        }

        /// <summary>
        /// 活动类型 - 7
        /// </summary>
        public enum ACTIVITY_TYPE
        {

            OPPORTUNITYUPDATE = 21,         // 商机更新
            PHONE = 22,                     // 电话
            MEETING = 23,                   // 会议
            OUTLINE = 24,                   // 概要
            GRAFFITI_RECORD = 25,           // 涂鸦记录
            EMAIL = 26,                     // 邮件
            IN_CHARGE = 27,                 // 计费中
            SALES = 28,                     // 销售
            CANCELLATION = 29,              // 注销
            TASK_INFO = 1490,               // 任务详情
            TASK_NOTE = 1491,               // 任务备注
            CONTRACT_NOTE = 1492,           // 合同备注
            PROJECT_EMAIL = 1493,           // 项目Email
            PROJECT_NOTE = 1494,            // 项目备注
            PROJECT_STATUS = 1495,          // 项目状态
        }


        /// <summary>
        /// 活动种类 - 8
        /// </summary>
        public enum ACTIVITY_CATE
        {
            TODO = 30,
            NOTE = 31,
            PROJECT_NOTE = 1497,                  // 项目备注
            CONTRACT_NOTE = 1498,                 // 合同备注
            TASK_NOTE = 1499,                       // 任务备注
            TICKET_NOTE = 1500,                   // 工单备注
        }
        /// <summary>
        /// 活动：活动类型：日历显示模式 - 9
        /// </summary>
        public enum CALENDAR_DISPLAY
        {
            NONE=32,             // 无
            CALANDAR=33,         // 日历
            LIST=34,             // 列表
            CALANDAR_LIST=35,    // 日历和列表
        }

        /// <summary>
        /// 客户告警类型 - 10
        /// </summary>
        public enum ACCOUNT_ALERT_TYPE
        {
            COMPANY_DETAIL_ALERT = 36,  // 客户提醒
            NEW_TICKET_ALERT = 37,      // 新建工单提醒
            TICKET_DETAIL_ALERT = 38,   // 工单进度提醒
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
            NOTREADYTOBUY = 83,                              // 考虑中
            ACTIVE = 84,                                     // 激活
            LOST = 85,                                       // 丢失
            CLOSED = 86,                                     // 关闭
            IMPLEMENTED = 87,                                // 实施          
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
            CONTRACT = 100,          // 合同
            TIME_SHEET = 101,       // 工时表
            INVENTORY = 102,        // 库存
            TICKETS = 103,          // Taskfire工单
            OTHERS = 104,           // 杂项
            QUOTE_TEMPLATE_OTHERS = 105, //报价模板-其他
            QUOTE_TEMPLATE_BODY = 106,  //报价模板-body           
            INVOICE_TEMPLATE_OTHERS=1967,//发票模板-其他
            INVOICE_TEMPLATE_BODY=1968,//发票模板body
            OTHER_USES = 1969,         // 其他用途

        }
        /// <summary>
        /// 通知事件-21
        /// </summary>
        public enum NOTIFY_EVENT
        {
            OPPORTUNITY_CREATEDOREDITED=107,                          // 商机-创建或编辑
            OPPORTUNITY_CLOSED=108,                                   // 商机-达成
            OPPORTUNITY_RE_ASSIGNED=109,                              // 商机-再分配
            OPPORTUNITY_LOST=110,                                     // 商机-丢失
            OPPORTUNITY_ATTACHMENT_ADDED=111,                         // 商机附件-创建
            QUOTE_CREATED_OR_EDITED =112,                              // 报价-创建或编辑
            SALES_ORDER_CREATED_OR_EDITED =113,                        // 销售订单 - 创建或编辑
            SALES_ORDER_ATTACHMENT_ADDED =114,                         // 销售订单附件-创建
            TO_DO_CREATED_OR_EDITED = 115,                             // 待办事项-创建或编辑
            NOTE_CREATED_OR_EDITED = 116,                              // 记录-创建或编辑
            ACCOUNT_CANCELED = 117,                                    // 客户-取消
            ACCOUNT_ATTACHMENT_ADDED = 118,                            // 客户附件-创建
            CONFIGURATION_ITEM_CREATED = 119,                          // 配置项-创建
            CONFIGURATION_ITEM_ATTACHMENT_ADDED = 120,                 // 配置项附件-创建
            PROJECT_CREATED = 121,                                     // 项目-创建
            PROJECT_COMPLETED = 122,                                   // 项目-完成
            PROJECT_ATTACHMENT_ADDED = 123,                            // 项目附件-创建
            PROJECT_NOTE_CREATED_OR_EDITED =124,                       // 项目记录-创建或编辑
            TASK_CREATED_OR_EDITED=125,                                // task新建修改编辑 
            TASK_COPIED=126,                                      // 任务-复制
            TASK_ATTACHMENT_ADDED =127,                           // 任务附件-创建
            TASK_TIME_ENTRY_CREATED_EDITED=128,                   // 任务工时记录-创建或编辑
            TASK_NOTE_CREATED_EDITED =129,                        // 任务记录-创建或编辑
            ISSUE_CREATED_EDITED =130,                            // 问题 - 创建或编辑
            TICKET_CREATED_EDITED=131,                            // 工单-创建或编辑
            TICKET_FORWARDED=132,                                 // 工单-转发
            TICKET_ATTACHMENT_ADDED=133,                          // 工单附件-创建
            TICKET_TIME_ENTRY_CREATED_EDITED = 134,               // 工单工时记录-创建或编辑
            TICKET_NOTE_CREATED_EDITED=135,                       // 工单记录-创建或编辑
            RECURRENCE_MASTER_CREATED_EDITED=136,                 // 定期主工单-创建或编辑
            QUICK_CALL_CREATED=137,                               // 快速服务预定-创建
            SERVICE_CALL_CREATED_EDITED=138,                      // 服务预定-创建或编辑
            BLOCK_CONTRACT_RULE =139,                             // 预付时间合同通知规则
            PER_CONTRACT_RULE=140,                                // 事件合同通知规则    
            RETAINER_CONTRACT_RULE=141,                           // 预付费合同通知规则
            EXPENSE_REPORT_ATTACHMENT_ADDED=142,                  // 报表附件新增
            NONE =1972,                                       // 无
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
        /// 销售订单状态-28
        /// </summary>
        public enum SALES_ORDER_STATUS
        {
            OPEN = 465,                // 打开
            IN_PROGRESS = 466,         // 进行中
            PARTIALLY_FULFILLED = 467, // 部分实施
            FULFILLED = 468,           // 完成
            CANCELED = 469,            // 取消
        }
        /// <summary>
        /// 付款类型 30 
        /// </summary>
        public enum payment_type
        {
            American_Express=478,    // 全款
            Cash = 479,              // 现金
            Check=480,               // 支票
            Company_Check=481,       // 公司支票
            Company_Credit_Card=482, // 公司信用卡
            Discover=483,            // 
            Master_Card=484,         // 万事达卡
            Other=485,               // 其他
            PayPal=486,              // 贝宝
            Personal=487,            // 
            Visa=488,                // 维萨信用卡 
        }

        /// <summary>
        /// 用户自定义字段对象类型-32
        /// </summary>
        public enum UDF_CATE
        {
            TASK = 511,            // 任务
            TICKETS = 512,         // 工单
            SITE = 513,             // 站点
            CONFIGURATION = 514,
            PRODUCTS = 515,         //产品
            CONTRACTS = 516,        // 合同
            COMPANY = 517,          // 客户
            CONTACT = 518,          // 联系人
            OPPORTUNITY = 519,      // 商机
            SALES = 520,            // 销售订单
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
            PRODUCT = 600,                 // 产品
            DEGRESSION = 601,              // 成本
            WORKING_HOURS = 602,           // 工时
            COST = 603,                    // 费用
            DISTRIBUTION_EXPENSES = 604,   // 配送费用
            DISCOUNT = 605,                // 折扣   
            SERVICE = 606,                 // 服务
            SERVICE_PACK = 607,            // 服务包
            START_COST = 608,              // 初始费用

        }
        /// <summary>
        /// 报价项：付费周期类型-43
        /// </summary>
        public enum QUOTE_ITEM_PERIOD_TYPE
        {
            ONE_TIME = 609,    // 一次性收费
            MONTH = 610,       // 按月收费
            QUARTER = 611,     // 按季度收费
            HALFYEAR = 612,       // 半年收费
            YEAR = 613,         // 按年收费

        }
        /// <summary>
        /// 报价项：税收种类-44
        /// </summary>
        public enum QUOTE_ITEM_TAX_CATE
        {
            SALESTAX = 598,       //消费税
            TAXABLE = 599,       // 应纳税
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
        /// 自定义字段分组 - 47
        /// </summary>
        public enum UDF_FILED_GROUP
        {
            TASK = 627,      // 任务
            TICKET = 628,    // 工单
        }

        /// <summary>
        /// 员工：外包权限-51
        /// </summary>
        public enum OUTSOURCE_SECURITY_ROLE_TYPE
        {
            NONE = 644,                 // 无
            ALLOW_OUTSOURCE = 645,      // 允许外包
            ALLOW_PARTNER = 646,        // 允许合作伙伴管理
            ALL = 647,                  // 全部（管理员）
        }

        /// <summary>
        /// 休假策略：累计增长周期 - 56
        /// </summary>
        public enum TIMEOFF_PERIOD_TYPE
        {
            DAY = 667,              // 天
            WEEK = 668,             // 周
            DOUBLE_WEEK = 669,      // 双周
            HALF_MONTH = 670,       // 半月
            MONTH = 671,            // 月
        }

        /// <summary>
        /// 审批人的审批类型 - 57
        /// </summary>
        public enum APPROVE_TYPE
        {
            TIMESHEET_APPROVE = 673,    // 工时表审批人
            EXPENSE_APPROVE = 674,      // 费用表审批人
        }

        /// <summary>
        /// 技能类别的类型 - 58
        /// </summary>
        public enum SKILLS_CATE_TYPE
        {
            SKILLS = 676,               // 技能
            CERTIFICATION = 677,        // 证书培训
            DEGREE = 678,               // 学位
        }

        /// <summary>
        /// 附件类型-62
        /// </summary>
        public enum ATTACHMENT_TYPE
        {
            ATTACHMENT = 704,   // 附件
            URL = 705,          // url
            FILE_LINK = 706,    // 文件目录
            FOLDER_LINK = 707,  // 文件夹目录
        }

        /// <summary>
        /// 附件对象类型-63
        /// </summary>
        public enum ATTACHMENT_OBJECT_TYPE
        {
            RESOURCE = 708,         // 员工
            CONTRACT = 709,         // 合同
            OPPORTUNITY = 710,      // 商机
            NOTES = 711,            // 备注
            SALES_ORDER = 712,      // 销售订单
            PROJECT = 713,          // 项目
            TASK = 714,             // 任务
            ATTACHMENT = 715,       // 附件
            COMPANY = 716,          // 客户
            EXPENSE_REPORT = 717,   // 费用报表
            LABOUR = 718,           // 工时
            KNOWLEDGE = 719,        // 知识库
            CONFIGITEM = 720,       // 配置项
        }

        /// <summary>
        /// 部门：类型 -64
        /// </summary>
        public enum DEPARTMENT_CATE
        {
            DEPARTMENT = 723,     //部门
            SERVICE_QUEUE = 724,  //服务队列
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
            CONTACT_CALLBACK = 879,             // 联系人查找带回-可以传客户ID进行筛选
            PRODUCT_CALLBACK = 882,             // 产品查找带回
            MANY_PRODUCT_CALLBACK = 885,          // 产品多选查找带回
            SERVICE_CALLBACK = 883,               // 服务查找带回
            SERVICE_BUNDLE_CALLBACK = 884,        // 服务集查找带回
            COST_CALLBACK = 887,                // 成本查找带回
            CHARGE_CALLBACK = 888,              // 费用查找带回
            SHIP_CALLBACK = 889,                // 配送费用查找带回
            INSTALLEDPRODUCT = 890,               // 配置项管理-查询
            PRODUCT_CATE_CALLBACK = 891,          //配置项管理-产品种类查找带回
            SUBSCRIPTION = 892,                 // 订阅管理-查询
            SALEORDER = 894,                    // 销售订单 - 查询
            CONTRACT = 895,                     // 合同
            MATERIALCODE_CALLBACK = 896,          //物料代码查找带回
            VENDOR_CALLBACK = 897,                //供应商查找带回
            RESOURCE=881,                         //系统管理-员工查询
            SYS_ROLE = 898,                     // 系统管理-角色查询
            SYS_DEPARTMENT = 899,               // 系统管理-部门查询
            //CONTRACT_CALLBACK = 902,            // 合同查找带回------废弃，使用917
            MARKET=906,                          //市场
            TERRITORY=907,                          //地域
            PRODUCTINVENTORY = 909,               // 库存
		    PRODUCT=910,                         //产品
            CONTRACT_INTERNAL_COST=911,           // 合同管理-内部成本查询
            CONTRACT_RATE = 912,                // 合同费率查询
            RESOURCE_CALLBACK = 913,              // 员工的查找带回（姓名 邮箱）
			CONFIGITEMTYPE=914,                   //配置项类型
            RELATION_CONFIGITEM=915,              // 关联到该合同的配置项
            NORELATION_CONFIGITEM = 916,          // 未关联到该合同的该合同的客户的配置项
            CONTRACTMANAGE_CALLBACK=917,          // 合同管理-合同查找带回
            SECURITY_LEVEL=918,                   //安全等级
            CONTRACT_MILESTONE=919,               //里程碑状态
            CONTRACT_CHARGE=920,                  // 合同成本查询（无查询条件）
            REVOKE_CHARGES = 921,               //撤销成本审批
            CONTRACT_TYPE = 922,                 // 合同类别
            CONTRACT_UDF = 923,                 // 合同管理-自定义字段
            REVOKE_RECURRING_SERVICES = 924,    //撤销定期服务审批
            REVOKE_MILESTONES = 925,            //撤销里程碑审批
            REVOKE_SUBSCRIPTIONS = 926,         //撤销订阅审批
			CONTRACT_DEFAULT_COST = 927,             // 合同默认成本
            CONTRACT_TIME_RATE = 928,                 // 合同预付时间系数
            ACCOUNTREGION=929,                   //客户区域
            COMPETITOR=930,                       //竞争对手
            ACCOUNTTYPE=931,                      //客户类型
            COUNTRY=932,                          //国家
            SUFFIXES =933,                           //姓名后缀
            ACTIONTYPE=934,                        //活动类型
            OPPORTUNITYAGES=935,                       //商机阶段
            OPPORTUNITYSOURCE=936,                   //商机来源
            OPPPORTUNITYWINREASON=937,             //关闭商机的原因
            OPPPORTUNITYLOSSREASON = 938,             //丢失商机的原因
            CONTRACT_BLOCK_TIME = 1510,             // 合同管理-预付时间
            CONTRACT_MILESTONES = 1511,             // 合同管理-里程碑
            INVOICE_TEMPLATE =1512,                    //发票模板
            INVOICE_HISTORY = 1513,               //历史发票
            APPROVE_CHARGES = 1514,               //成本审批
            APPROVE_MILESTONES = 1515,            //里程碑审批
            APPROVE_SUBSCRIPTIONS = 1516,         //订阅审批
            APPROVE_RECURRING_SERVICES = 1517,    //定期服务审批           
            GENERATE_INVOICE=1518,                 // 生成发票
            CONTRACT_SERVICE = 1519,                // 合同管理-服务/服务包
            CONTRACT_SERVICE_TRANS_HISTORY = 1520,  // 合同管理-服务/包交易历史
            CONTRACT_BLOCK = 1521,                  // 合同管理-预付费用
            CONTRACT_BLOCK_TICKET = 1522,           // 合同管理-事件查询
            CONFIGSUBSCRIPTION =1523,              // 配置项中的订阅管理 
            PROJECTCALLBACK=1524,                  // 项目的查找带回
            RES_ROLE_DEP_CALLBACK=1529,            // 员工部门角色查找带回
            PROJECT_SEARCH= 1530,                   // 项目查询
            CRM_NOTE_SEARCH = 1531,                 // 客户备注查询
            TODOS = 1532,                           // 客户代办查询
            COMPANY_VIEW_CONTRACT = 1533,           // 客户详情-合同
            PROJECT_TEMP_SEARCH = 1535,             // 项目模板查询
            PROJECT_PROPOSAL_SEARCH = 1536,         // 项目提案查询
			TASK_PHASE = 1538,                      // 任务父阶段的查找带回
            COMPANY_VIEW_INVOICE = 1534,            // 客户详情-发票查询
            COMPANY_VIEW_ATTACHMENT = 1537,         // 客户详情-附件
            PROJECT_TASK = 1539,                    // 项目详情，task列表
            OPPORTUNITY_VIEW_ATTACHMENT = 1540,     // 商机详情-附件查询
            SALES_ORDER_VIEW_ATTACHMENT = 1541,     // 销售订单详情-附件查询
            INSPRODUCT_CALLBACK=1542,               // 配置项的查找带回
            PRO_EXPENSE_REPORT_CALLBACK = 1543,            // 费用报表查找带回 
            PROJECT_CALLBACK = 1544,                // 项目查找带回
            APPROVE_EXPENSE = 1545,                 // 费用审批
            REVOKE_EXPENSE = 1546,                  // 系统管理-撤销费用审批
            PROJECT_TEAM = 1547,                    // 项目管理-项目详情-团队查询
            PROJECT_COST_EXPENSE = 1548,            // 项目管理-项目详情-成本和费用查询
            INVENTORY_LOCATION = 1549,              // 库存仓库查询
            INVENTORY_ITEM = 1550,                  // 库存产品查询
            PROJECT_NOTE = 1552,                    // 项目管理-项目备注查询
            ACCOUNT_POLICY = 1553,                  // 客户策略
            APPROVE_LABOUR = 1554,                  // 工时审批
            REVOKE_LABOUR = 1555,                   // 系统管理-撤销工时审批
            PROJECT_RATE =1556,                     // 项目管理-项目详情-费率查询
            PROJECT_CALENDAR=1557,                  // 项目管理-项目详情-日历查询
            PROJECT_ATTACH = 1558,                  // 项目管理-项目详情-附件查询
            PROJECT_UDF = 1559,                     // 项目管理-项目详情-自定义查询
            TASK_HISTORY = 1560,                    // 任务操作历史
            WAREHOUSEPRODUCTSN=1561,                // 库存产品串号查询
            INVENTORY_TRANSFER = 1562,              // 库存转移查询
            PURCHASE_APPROVAL = 1563,               // 采购审批查询
            PURCHASING_FULFILLMENT = 1564,          // 库存管理-待采购产品查询
            RESERVED_PICKED = 1565,                 // 库存管理-预留和拣货详单
            CONTRACT_NOTIFY_RULE=1566,          // 合同通知规则
            PURCHASE_ORDER = 1567,                  // 采购订单查询
            PURCHASE_ITEM = 1568,                   // 采购订单采购项
            SERNUM_CALLBACK = 1569,                 // 库存管理-产品序列号查找带回
            CONTRACT_PROJECT=1570,                  // 合同查看 - 项目
            PURCHASE_RECEIVE = 1571,                // 采购接收查询
            SHIPPING_LIST = 1572,                   // 库存管理-配送管理-配送列表查询que
            SHIPED_LIST = 1573,                     // 库存管理-配送管理-已配送列表查询
            PURCHASE_ORDER_HISTORY=1574,            // 库存管理-采购订单历史-查询
            SHIPPING_ITEM_SERIAL_NUM = 1575,        // 库存管理-产品序列号查找带回（取消接收用）
            EXC_CONTRACT_CALLBACK = 1576,           // 合同管理-合同详情-例外因素-合同查找带回
            CONTRACT_PRODUCT_SN_CALLBACK = 1577,    // 成本-成本产品序列号查找带回（取消拣货用）
            EXPENSE_REPORT = 1578,                  // 工时表-我的费用报表-查询
            HOLIDAY_SET = 1579,                     // 系统设置-节假日设置
            HOLIDAYS = 1580,                        // 系统设置-节假日查询
            MYAPPROVE_EXPENSE_REPORT=1581,          // 工时表-等待我审批的费用报表-查询
            APPROVED_REPORT=1582,                   // 工时表-已审批的费用报表-查询
            TICKET_SEARCH = 1583,                   // 工单管理-工单查询
            TICKET_ACCOUNT_LIST=1584,               // 客户未关闭工单列表
            TICKET_SLA_LIST = 1585,                 // 工单管理-SLA事件查询
            TICKET_SERVICE_LIST = 1586,             // 工单管理-待办和服务预定
            TICKET_COST_EXPENSE = 1587,             // 工单管理-成本和费用
            SERVICE=1588,                                // 服务查询  
            SERVICE_BUNDLE=1589,                         // 服务包查询
            MY_TASK_TICKET=1590,                    // 我的任务和工单
            REPORT_CRM_EXPORT_COMPANY = 1591,       // 报表-导出-导出客户信息
            REPORT_CRM_EXPORT_CONTACT = 1592,       // 报表-导出-导出联系人信息
            REPORT_CRM_INSPRO_DETAIL = 1593,        // 报表-CRM配置项-配置项详情
            REPORT_SERVICEDESK_TICKETBYACCOUNT = 1594, // 报表--服务台常规-工单和任务按客户
            REPORT_CONTRACT_BILLED = 1595,          // 报表-CRM配置项-已计费信息
            REPORT_PROJECT_PROJECT_LIST = 1597,     // 报表-项目项目-项目清单
            REPORT_OTHER_SYSTEM_LOGINLOG = 1598,    // 报表-其他-系统-登录日志
            REPORT_OTHER_SYSTEM_OPERLOG = 1599,     // 报表-其他-系统-操作日志
            WORKFLOW_RULE = 1600,                   // 工作流规则查询
            MASTER_SUB_TICKET_SEARCH = 1601,        // 定期主工单管理-详情-子工单查询
            SERVICE_CALL_SEARCH = 1602,             // 服务预定管理-服务预定查询
            SERVICE_CALL_TICKET = 1603,             // 服务预定关联工单查询 
            KNOWLEDGEBASE_ARTICLE = 1604,           // 知识库文档管理-查询
            MASTER_TICKET_SEARCH = 1605,            // 定期主工单查询
            TICKET_MERGE = 1606 ,                   // 合并工单的查找带回
            TICKET_REQUEST = 1607,                  // 工单详情-变更请求工单
            TICKET_INCIDENT = 1608,                 // 工单详情-事故清单  
            TICKET_PROBLEM = 1609,                  // 工单详情-问题清单
            PROJECT_PHASE = 1610,                   // 项目阶段的查找带回
            TIMEOFF_POLICY = 1611,                  // 休假策略查询
            TIMEOFF_POLICY_RESOURCE = 1612,         // 休假策略-关联员工查询
            TIMEOFF_POLICY_TIER = 1613,             // 休假策略-级别查询
            ACCOUNT_SERVICE_DETAILS = 1614,         // 工单详情-客户服务详情
            TICKET_INCLIDENT_RELATION = 1615,       // 工单详情-事故关联其他工单
            DISPATCH_TICKET_SEARCH = 1616,          // 调度工作室-工单查询
            MY_QUEUE_ACTIVE = 1617,                 // 服务台-我的工作区-活动工单 
            MY_QUEUE_MY_TICKET = 1618,              // 服务台-我的工作区-我创建的工单
            MY_QUEUE_CHANGE_APPROVEL = 1619,        // 服务台-我的工作区-变更申请审批 
            MY_QUEUE_VIEW = 1620,                   // 服务台-我的工作区-队列视图 
            RESOURCE_POLICY_ASSIGNMENT = 1622,      // 员工详情-休假策略
            RESOURCE_TIME_SHEET = 1623,             // 员工详情-工时表审批人
            RESOURCE_EXPENSE_REPORT = 1624,         // 员工详情-费用审批人
            RESOURCE_DEPARTMENT = 1625,             // 员工详情-员工部门
            RESOURCE_SERVICE_DESK_QUEUES = 1626,    // 员工详情-员工队列
            RESOURCE_SKILL = 1627,                  // 员工详情-员工技能
            RESOURCE_CERTIFICATE = 1628,            // 员工详情-员工证书和培训
            RESOURCE_DEGREE = 1629,                 // 员工详情-员工学位
            RESOURCE_ATTACHMENT = 1630,             // 员工详情-员工附件
            TIMEOFF_MY_CURRENT = 1631,              // 工时表管理-我的当前工时表
            TIMEOFF_WAIT_APPROVE = 1632,            // 工时表管理-等待我审批的工时表
            TIMEOFF_WAIT_APPROVE_DETAIL = 1633,     // 工时表管理-等待我审批的工时表-列表详情
            TIMEOFF_SUBMITED = 1634,                // 工时表管理-已提交工时表
            TIMEOFF_MY_REQUEST = 1635,              // 工时表管理-我的休假请求
            TIMEOFF_MY_BALANCE = 1636,              // 工时表管理-休假余额详情
            TIMEOFF_REQUEST_WAIT_APPROVE = 1637,    // 工时表管理-等待我审批的休假请求
            WORKGROUP_CALLBACK = 1638,              // 工作组-查找带回
            TASK_SEARCH_NO = 1639,                  // 系统管理-快捷搜索-任务编号
            COMPANY_VIEW_ACCOUNT_PROFIT_MARGIN=1642,       // 客户查看-客户利润率
            COMPANY_VIEW_MONTH_PROFIT_MARGIN=1643,         // 客户查看-月利润率
            COMPANY_VIEW_MONTH_PROFIT_MARGIN_BYDATE=1644,  // 客户查看-月利润率（按照计费时间）
            COMPANY_VIEW_CONTRACT_PROFIT = 1645,           // 客户查看-合同利润
            COMPANY_VIEW_CONTRACT_PROFIT_BYDATE = 1646,    // 客户查看-合同利润（按照计费时间）
            COMPANY_VIEW_CONTRACT_PROFIT_MARGIN = 1647,    // 客户查看-合同利润率
            COMPANY_VIEW_PROJECT_PROFIT = 1648,            // 客户查看-项目利润
            COMPANY_VIEW_PROJECT_PROFIT_BYDATE = 1649,     // 客户查看-项目利润（按照计费时间）
            COMPANY_VIEW_PROJECT_PROFIT_MARGIN = 1650,     // 客户查看-项目利润率
            COMPANY_VIEW_RES_WORKHOUR =1651,               // 客户查看-员工已工作时间
            COMPANY_VIEW_RES_WORKHOUR_BYDATE = 1652,       // 客户查看-员工已工作时间（按照计费时间）
            COMPANY_VIEW_ACCOUNT_OVERVIEW = 1653,          // 客户查看-客户总览
            COMPANY_VIEW_ACCOUNT_OVERVIEW_BYDATE = 1654,   // 客户查看-客户总览（按照计费时间）

            REPORT_CRM_MY_ACCOUNT_TICKET=1655,              // 报表-CRM-我的客户的工单
            REPORT_CRM_OPPORTUNITY_DETAILS = 1656,          // 报表-CRM-商机-商机详情
            REPORT_CRM_OPPORTUNITY_STATUS = 1657,           // 报表-CRM-商机-商机状态
            REPORT_CRM_OPPORTUNITY_CRM_NOTE = 1658,         // 报表-CRM-商机-CRM备注
            CONTACR_GROUP_SEARCH=1659,                      // CRM 联系人组
            VIEW_CONTACT_GROUP_SEARCH =1660,                // 查看联系人组-成员信息
            CONTACR_GROUP_CONTACT_CALLBACK = 1661,          // 联系人组成员添加-联系人查找带回
            CONTACT_ACTION_TEMP = 1662,                     // 联系人活动 模板
            ACCOUNT_CONTACT_GROUP_SEARCH = 1663,            // 查看客户-联系人组
            OTHER_INSTALLED_PRODUCT_SEARCH=1664, 
            WAREHOUSE_PRODUCT_CALLBACK= 1665,               // 配置项管理-配置项替换-库存产品查找带回



            //RESOURCE_CALLBACK,                      // 
            //以下是还没有配查询语句的枚举（系统管理）

            General,                       //general表的通用处理
            Line_Of_Business,              //系统管理：组织：业务条线
            Project_Status,                 //项目：项目状态
            Task_Type,                       //任务类型
            Payment_Term,                    //付款期限
            Payment_Type,                    //付款类型
            Payment_Ship_Type,               //配送类型
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
            PROJECT = 740,      // 项目
            SALEORDER = 741,    // 销售订单
            TICKETS = 742,      // 工单
            NOTES = 743,        // 备注
            ATTACHMENT = 744,   // 附件
            TASK=745,           // TASK
            LABOUR=746,         // 工时
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
            ACTIVITY = 765,                             // 活动   // todo 数据库添加
            QUOTE = 770,                                // 报价   
            QUOTE_ITEM = 771,                           // 报价项 
            QUOTE_TEMP = 772,                           // 报价模板
            CONTRACT = 773,                             // 合同
            PRODUCT = 774,                              // 产品
            FROMOPPORTUNITY_EXTENSION_INFORMATION = 775,// 商机扩展信息            
            SECURITY_LEVEL = 776,                       // 安全等级
            CONFIGURAITEM = 777,                        // 配置项
            SALE_ORDER = 778,                           // 销售订单
            SUBSCRIPTION = 779,                         // 订阅
            CONTRACT_EXTENSION = 780,                   // 合同扩展信息
            CONTRACT_BLOCK,                             //合同预付
            CONTRACT_COST = 782,                        // 合同成本
            CONTRACT_SERVICE = 783,                     // 合同服务
            CONTRACT_MILESTONE = 784,                   // 合同里程碑
            CONTRACT_DEFAULT_COST = 785,                // 合同默认成本
            CONTRACT_NOTIFY_RULE = 786,                 // 合同通知规则
            CONTRACT_NOTIFY_RULE_RECIVED= 787,          // 合同通知规则邮件接收人
            CONTRACT_SERVICE_ADJUST =788,                //合同服务调整
            CONTRACT_SERVICE_PERIOD = 789,                        //合同服务周期
            CONTRACT_RATE = 790,                        // 合同费率
            CONTRACT_INTERNAL_COST = 791,               // 合同内部成本
            CONTRACT_EXCLUSTION_ROLE=792,               //合同例外因素-不计费的角色
            CONTRACT_EXCLUSTION_COST = 793,             //合同例外因素-不计费工作类型
            General_Code = 794,                         // 通用代码
            WAREHOUSE_PRODUCT =795,                     // 库存产品
            PRODUCT_VENDOR=796,                         // 产品供应商
            ACCOUNTCLASS=797,                           // 客户类别
            DEPARTMENT=798,                             // 部门
            ROLE=799,                                   // 角色
            RESOURCE=1370,                              // 员工
            PROJECT = 1371,                             // 项目
            SUBSCRIPTION_PERIOD=1372,                   //订阅周期
            ACCOUNT_DEDUCTION=1373,                    //审批并提交
            REFERENCE = 1374,                              // 客户发票/报价设置
            INVOCIE =1375,                                // 发票
            INVOCIE_DETAIL=1376,                         // 发票详情
            PROJECT_EXTENSION_INFORMATION=1377,         // 项目扩展信息
            PROJECT_ITEM=1378,                          // 项目团队
            PROJECT_ITEM_ROLE=1379,                     // 项目团队角色
            PROJECT_TASK=1380,                          // 任务
            PROJECT_CALENDAR=1381,                      // 项目日历条目
            PROJECT_TASK_RESOURCE = 1382,               // 任务分配对象
            SDK_WORK_RECORD=1383,                       // 工时报表sdk_work_entry_report
            SDK_WORK_ENTRY =1384,                        // 工时
            SDK_EXPENSE_REPORT = 1385,                  // 费用报表   
            SDK_EXPENSE = 1386,                         // 费用
            SDK_TASK_LIBARY = 1387,                     // 任务库
            SDK_MILESTONE=1388,                         // 阶段里程碑
            ATTACHMENT = 1389,                          // 附件
            INVENTORY_LOCATION = 1390,                  // 库存仓库
            INVENTORY_ITEM = 1391,                      // 库存产品
            INVENTORY_ORDER = 1392,                     // 采购订单
            PROJECT_TASK_PREDECESSOR = 1393,            // 任务的前驱任务
            INVENTORY_ITEM_SN = 1394,                   // 库存产品串号
            INVENTORY_ITEM_TRANSFER = 1395,             // 库存转移
            INVENTORY_ITEM_TRANSFER_SN = 1396,          // 库存转移序号
            WAREHOUSE_RESERVE=1397,                     // 库存预留
            PROJECT_PHASE_WORK_HOURS = 1398,            // 项目阶段预估工时
            PURCHASE_ORDER_ITEM = 1399,                 // 采购项
            CTT_CONTRACT_COST_PRODUCT = 1400,           // 成本关联产品
            CTT_CONTRACT_COST_PRODUCT_SN = 1401,        // 成本关联产品的串号
            PURCHASE_RECEIVE = 1402,                    // 采购接收
            PURCHASE_RECEIVE_SN = 1403,                 // 采购接收串号
            HOLIDAY = 1404,                             // 节假日假期日
            TIMEOFF_POLICY = 1405,                      // 假期策略
            TIMEOFF_ITEM = 1406,                        // 假期策略类别
            TIMEOFF_ITEM_TIER = 1407,                   // 假期策略级别
            TIMEOFF_REQUEST = 1408,                     // 休假请求tst_timeoff_request
            TIMEOFF_REQUEST_LOG = 1409,                 // 休假请求审批tst_timeoff_request_log
            WORK_ENTRY_REPORT_LOG = 1410,               // 工时表审批tst_work_entry_report_log
            TIMEOFF_RESOURCE = 1411,                    // 假期策略关联员工
            SERVICE_DISPATCHER_VIEW = 1412,             // 调度工作室视图
            SERVICE_CALL = 1415,                        // 服务预定
            SERVICE_CALL_RESOURCE=1416,                 // 服务预定负责人
            SERVICE_CALL_TICKET = 1417,                 // 服务预定关联工单
            PROJECT_TASK_INFORMATION = 1418,            // 任务的扩展信息（自定义信息）
            SERVICE_APPOINTMENT = 1419,                 // 约会
            TICKET_CHECK_LIST = 1420,                   // 工单的检查单
            TICKET_SERVICE_REQUEST = 1421,              // 服务请求审批人信息
            TICKET_RELATION = 1422,                     // 工单关联关系
            IVT_SERVICE = 1423,                         // 服务
            IVT_SERVICE_BUNDLE = 1424,                  // 服务包
            WORKFLOW_RULE = 1425,                       // 工作流规则
            CHANGE_REQUEST = 1426,                      // 任务的其他信息（变更请求用）
            CHANGE_REQUEST_APPROL = 1427,               // 变更申请单审批人信息
            MASTER_TICKET = 1428,                       // 定期主工单
            SDK_KONWLEDGE = 1429,                       // 知识库
            SDK_KONWLEDGE_COMMENT = 1430,               // 知识库评论
            SDK_KONWLEDGE_TICKET = 1431,                // 知识库关联工单
            DASHBOARD_WIDGET = 1436,                    // 仪表板小窗口
            DASHBOARD_WIDGET_GUAGE = 1437,              // 仪表板小窗口部件
            TICKET_SLA_EVENT,                           // 工单sla 事件
            
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
            DYNAMIC_DATE = 803,     // 动态日期范围
            NONE_INPUT = 804,       // 不需要输入的类型（空、非空等）
            SINGLE_LINE = 805,      // 单行文本
            NUMBER = 806,           // 数值(做范围判断)
            DATE = 807,             // 日期(做范围判断)
            DATETIME = 808,         // 日期时间(做范围判断)
            DROPDOWN = 809,         // 下拉选择框
            MULTI_DROPDOWN = 810,   // 多选下拉框
            AREA = 811,             // 行政区
            CALLBACK = 812,         // 查找带回
            BOOLEAN = 813,          // 布尔值
            MUILT_CALLBACK = 814,   // 多选查找带回
            NUMBER_EQUAL = 816,     // 数值(做等于判断)
            TIMESPAN = 817,         // 日期-时间戳(做范围判断)
            UN_EQUAL = 818,         // 不等于
            DYNAMIC = 819,          // 动态参考
            CHANGED = 820,          // 变更
            DATE_EQUAL = 2807,      // 日期(做等于判断)
        }

        /// <summary>
        /// 地址类型-71
        /// </summary>
        public enum LOCATION_CATE
        {
            REGISTER_ADDR = 821,    // 注册地址
            RECIEVE_ADDR = 822,     // 收货地址
            INVOICE_ADDR = 823,     // 发票地址
            WORK_ADDR = 824,        // 办公地址
            BILLING = 825,          // billing
        }

        /// <summary>
        /// 活动状态-72
        /// </summary>
        public enum ACTIVITY_STATUS
        {
            NOT_COMPLETED = 827,    // 未完成
            COMPLETED = 828,        // 已完成
        }

        /// <summary>
        /// 系统权限：limit类型-76
        /// </summary>
        public enum LIMIT_TYPE
        {
            HAVE_NONE = 960,            // 有无
            ALL_PART_MINE_NONE = 961,   // 全部部分我的无
            ALL_MINE_NONE = 962,        // 全部我的无
            ALL_NONE = 963,             // 全部无
            TASK = 964,                 // task
            TICKET = 965,               // ticket
            CONTACT = 966,              // contact
            NOT_REQUIRE = 967,          // 无需权限
        }

        /// <summary>
        /// 系统权限：limit_type_value 取值-77
        /// </summary>
        public enum LIMIT_TYPE_VALUE
        {
            // 961对应值
            ALL961 = 970,              // 全部
            MY_TORRITORY961 = 971,     // 我的地域
            MINE961 = 972,             // 我的
            NONE961 = 973,             // 无

            // 962对应值
            ALL962 = 974,              // 全部
            MINE962 = 975,             // 我的
            NONE962 = 976,             // 无

            //963对应值
            ALL963 = 977,               // 全部
            NONE963 = 978,              // 无

            // 964对应值
            MY_TASK964 = 979,           // MY_TASK
            UNASSIGNED_TASKS964 = 980,  // MY_TASKS_UNASSIGNED_DEPARTMENT_TASKS
            DEPARTMENT_TASKS964 = 981,  // MY TASKS & DEPARTMENT TASKS
            ALL_TASK964 = 982,          // All Tasks

            // 965对应值
            ALL965 = 983,              // 全部
            MINE_AND_COMPANY965 = 984, // Mine + Companies
            MINE965 = 985,             // 我的

            // 966对应值
            ALL966 = 986,              // 全部
            MY_COMPANY966 = 987,       // 我是客户经理
            MY_PROJECT966 = 988,       // 我是项目经理
            NONE966 = 989,             // 无

            // 967对应值
            NOT_REQUIRE967 = 1240,     // 无需权限

            // 960对应值
            HAVE960 = 1241,            // 有
            NO960 = 1242,              // 无
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
        /// <summary>
        /// 系统管理：系统配置：库存记账方法 - 83
        /// </summary>
        public enum INVENTORY_ACCOUNTING_METHOD
        {
            /// <summary>
            /// 平均
            /// </summary>
            AVERAGE_COST = 1030,
            /// <summary>
            /// 先进先出
            /// </summary>
            FIFO = 1031,
            /// <summary>
            /// 后进先出
            /// </summary>
            LIFO = 1032,
        }

        /// <summary>
        /// 系统管理：系统配置： 工时是否可以代理操作  - 90
        /// </summary>
        public enum PROXY_TIME_ENTRY
        {
            DISABLED = 1077,
            ENABLED_TIMESHEET_APPROVERS=1078,
            ENABLED_TIMESHEET_APPROVERS_ADMINISTRATORS=1079,
        }

        /// <summary>
        /// 成本种类 106
        /// </summary>
        public enum COST_CODE_CATE
        {
            GENERAL_ALLOCATION_CODE = 1158,        //  一般成本  //工作类型
            EXPENSE_CATEGORY = 1159,               // 费用
            INTERNAL_ALLOCATION_CODE = 1160,       // 内部成本
            MATERIAL_COST_CODE = 1161,             // 物料成本
            RECURRING_CONTRACT_SERVICE_CODE = 1162,// 周期服务成本
            MILESTONE_CODE = 1163,                 // 里程碑
            PRODUCT_CODE = 1164,                   // 产品
            QUICKBOOKS = 1165,                     // 
            BLOCK_PURCHASE = 1166,                 // 预付时间
            RETAINER_PURCHASE = 1167,              // 预付费用
            TICKET_PURCHASE = 1168                 // 事件
        }

        /// <summary>
        /// 报价分组条件-110
        /// </summary>
        public enum QUOTE_GROUP_BY
        {
            NO = 1192,                    // 按照不分组
            CYCLE = 1193,                  // 按照周期分组
            PRODUCT = 1194,               // 按照产品分组
            CYCLE_PRODUCT = 1195,         // 按照周期产品分组
            PRODUCT_CYCLE = 1196,         // 按照产品周期分组
        }

        /// <summary>
        /// 合同类型-111
        /// </summary>
        public enum CONTRACT_TYPE
        {
            SERVICE = 1199,             // 定期服务合同
            TIME_MATERIALS = 1200,      // 工时及物料合同
            FIXED_PRICE = 1201,         // 固定价格合同
            BLOCK_HOURS = 1202,         // 预付时间合同
            RETAINER = 1203,            // 预付费合同
            PER_TICKET = 1204,          // 事件合同
        }
        public enum EXPENSE_TYPE
        {
            STANDARD = 1223,              // 标准
            TOTAL_MILEAGE=1224,           // 总里程
            ENTERTAINMENT_EXPENSES=1225,  // 招待费用
        }

        /// <summary>
        /// 合同-成本类型 - 114
        /// </summary>
        public enum COST_TYPE
        {
            OPERATIONA = 1228,          // 运营成本
            CAPTITALIZED = 1229,        // 投资成本
        }
        /// <summary>
        /// 合同-成本状态 - 115
        /// </summary>
        public enum COST_STATUS
        {
            UNDETERMINED = 1232,           // 待定
            PENDING_APPROVAL = 1233,       // 待审批
            PENDING_PURCHASE = 1234,       // 待采购/待拣货
            IN_PURCHASING = 1235,          // 采购中
            PENDING_DELIVERY = 1236,       // 待配送
            ALREADY_DELIVERED = 1237,      // 已配送
            CANCELED = 1238,             // 已取消
        }
        /// <summary>
        /// 合同：里程碑：状态-117
        /// </summary>
        public enum MILESTONE_STATUS {
            IN_PROGRESS=1265,
            READY_TO_BILL=1266,
            BILLED=1267,
        }
        /// <summary>
        /// 合同：工时计费设置 118
        /// </summary>
        public enum BILL_POST_TYPE
        {
            CHECK_BILL=1270,            // 查核计费
            ENTRY_APP_BILL =1271,        // 工时表审批计费
            BILL_NOW =1272,              // 即时计费
        }
        /// <summary>
        /// 合同计费对象子类型 --120
        /// </summary>
        public enum BILLING_ENTITY_SUB_TYPE
        {
            PROJECT_COST_DEDUCTION=1297,                // 项目成本扣除
            PROJECT_COST =1298,                          // 项目成本
            TICKET_COST_DEDUCTION = 1299,               // 工单成本扣除
            TICKET_COST = 1300,                         // 工单成本
            CHARGE =1301,                                // 费用
            CHARGE_DEDUCTION =1302,                      // 费用扣除
            SUBSCRIBE =1303,                             // 订阅
            SUBSCRIBE_COST = 1304,                      // 订阅成本
            START_CHARGE =1305,                          // 初始费用
            REGULAR_SERVICE =1306,                       // 定期服务
            REGULAR_SERVICE_ADJUSTMENT =1307,            // 定期服务调整
            REGULAR_SERVICE_PACKAGE =1308,               // 定期服务包
            REGULAR_SERVICE_PACKAGE_ADJUSTMENT = 1309,  // 定期服务包调整
            MILEPOST =1310,                              // 里程碑
            PREPAID_TIME =1311,                          // 预付时间
            PREPAID_COST =1312,                          // 预付费用
            EVENTS =1313,                                // 事件
            CONTRACT_COST = 1314,                       // 合同成本
        }

        /// <summary>
        /// 审批并提交操作类型 -121
        /// </summary>
        public enum ACCOUNT_DEDUCTION_TYPE
        {
            LABOUR = 1318,               // 工时
            LABOUR_AJUST=1319,           // 工时调整
            PREPAID_TIME_SELF_BILLING=1320, //预付时间自身计费
            CHARGE =1321,                //成本
            EXPENSES=1322,               // 费用
            MILESTONES=1323,            //里程碑
            SUBSCRIPTIONS=1324,         //订阅
            SERVICE =1325,              //服务
            SERVICE_ADJUST=1326,        //服务调整
            INITIAL_COST =1327,         //初始费用
        }
        /// <summary>
        /// 成本表：是否计费/发票显示方式 - 122
        /// </summary>
        public enum SHOW_ON_INVOICE
        {
            NO_SHOW_ONINCOICE = 1333,   // 不在发票上显示
            SHOW_DISBILLED = 1334,      // 在发票上显示”不收费“
            BILLED = 1335,              // 计费
        }
        /// <summary>
        /// 项目类型 - 123
        /// </summary>
        public enum PROJECT_TYPE
        {
            ACCOUNT_PROJECT = 1338,        // 客户项目
            IN_PROJECT = 1339,             // 内部项目
            PROJECT_DAY = 1340,            // 项目提案
            TEMP = 1341,                   // 模板
            BENCHMARK = 1342,              // 基准(快照)
        }
        /// <summary>
        /// 项目状态 - 124
        /// </summary>
        public enum PROJECT_STATUS
        {
            DISABLE = 1345,                     // 停用
            NEW = 1346,                         // 新建
            HAVE_IN_HAND = 1347,                // 进行中
            DELAY = 1348,                       // 推迟
            CHANGE = 1349,                      // 变更
            WAITING_ACCESSORIES = 1350,         // 等待配件
            WAITING_CUSTOMERS = 1351,          // 等待客户
            DONE = 1352,                        // 等待客户
        }

        /// <summary>
        /// 库存转移类型 - 126
        /// </summary>
        public enum INVENTORY_TRANSFER_TYPE
        {
            INVENTORY = 1481,       // 仓库间转移
            PROJECT = 1482,         // 转移给客户
            TICKETS = 1483,         // 配置项交换
            CANCLE_RECEIVE = 1484,  // 取消接收
            MANUAL = 1485,          // 手工修改库存
        }

        /// <summary>
        /// 客户报价发票设置 - 127
        /// </summary>
        public enum INVOICE_ADDRESS_TYPE
        {
            USE_ACCOUNT_ADDRESS=1486,          // 使用客户地址
            USE_PARENT_ACC_ADD =1487,           // 使用父客户地址
            USE_PARENT_INVOIVE_ADD =1488,       // 使用父客户发票地址
            USE_INSERT =1489,                   // 手工输入地址
        }
        /// <summary>
        /// 工单类型 - 129
        /// </summary>
        public enum TICKET_TYPE
        {
            ALARM=1804,                       // 告警
            CHANGE_REQUEST=1803,              // 变更请求
            INCIDENT=1801,                    // 事故
            PROBLEM=1802,                     // 问题
            SERVICE_REQUEST=1800,             // 服务请求
        }
        /// <summary>
        ///  任务类型 - 130
        /// </summary>
        public enum TASK_TYPE
        {
            PROJECT_TASK=1807,                 // 项目任务
            PROJECT_ISSUE=1808,                // 项目问题
            SERVICE_DESK_TICKET = 1809,        // IT服务请求
            COMPANY_TASK = 1810,               // 公司任务
            TRAVEL_TIME = 1811,                // 出差时间
            PROJECT_PHASE = 1812,              // 项目阶段
            CLIENT_TASK = 1813,                // 客户任务
            PERSONAL_TIME = 1814,              // 私人时间
            VACATION_TIME = 1815,              // 假期
            SICK_TIME = 1816,                  // 病假
            PAID_TIME_OFF = 1817,              // 带薪休假
            RECURRING_TICKET_MASTER = 1818,    // 定期主工单
            TASKFIRE_TICKET = 1819,            // 内部 Client Portal 工单
        }
        /// <summary>
        /// 工单问题类型 - 132
        /// </summary>
        public enum TASK_ISSUE_TYPE
        {
            UPGRADE = 1837,           // 升级
            SERVICE = 1838,           // 服务
            THE_SERVER = 1839,        // 服务器
            COMPUTER = 1840,          // 计算机
            NETWORK = 1841,           // 网络
        }
        /// <summary>
        /// 工单优先级 - 134
        /// </summary>
        public enum TASK_PRIORITY_TYPE
        {
            serious = 1883,               // 严重
            high = 1884,                  // 高
            medium = 1885,                // 中
            low = 1886,                   // 低
        }

        /// <summary>
        /// 工单状态 - 135
        /// </summary>
        public enum TICKET_STATUS
        {
            NEW = 1889,                                 // 新建
            ALREADY_ALLOCATED =1890,                     // 已分配
            HAVE_IN_HAND =1891,                          // 进行中
            UPGRADE = 1892,                             // 升级
            WAITING_FOR_CUSTOMERS =1893,                 // 等待客户
            DONE = 1894,                                // 已完成
        }
        /// <summary>
        /// 工时方法 - 136
        /// </summary>
        public enum TIME_ENTRY_METHOD_TYPE
        {
            NONE = 1900,                        // 无
            FIXWORK = 1901,                     // 固定工作
            FIXDURATION = 1902,                 // 固定时间
        }
        /// <summary>
        /// 任务来源 - 137
        /// </summary>
        public enum TASK_SOURCE_TYPES
        {
            CLIENT_PORTAL=1906,      // 
            PHONE=1907,              // 电话
            OTHER=1908,              // 其他
            ONLINE=1909,             // 口述/在线
            EMAIL=1910,              // 邮件
            MONITORING_HINTS=1911,   // 监视提示
            NETWORK_PORT=1912,       // 网路端口
        }
        /// <summary>
        /// SLA事件类型 - 139
        /// </summary>
        public enum SLA_EVENT_TYPE
        {
            FIRSTRESPONSE=1919,    // 初次响应
            RESOLUTION=1920,       // 已解决
            RESOLUTIONPLAN=1921,   // 解决方案计划
            WAITINGCUSTOMER=1922,  // 等待客户
        }

        /// <summary>
        /// 费用报表状态 - 144
        /// </summary>
        public enum EXPENSE_REPORT_STATUS
        {
            HAVE_IN_HAND=2101,            // 进行中
            WAITING_FOR_APPROVAL =2102,   // 等待审批
            PAYMENT_BEEN_APPROVED =2103,  // 付款已审批
            REJECTED = 2104,              // 已拒绝
            ALREADY_PAID =2105,           // 已支付
        }
        /// <summary>
        /// 工时类型 - 145
        /// </summary>
        public enum WORK_ENTRY_TYPE
        {
            COMPAMY_IN_ENTRY = 2109,   // 公司内部工时
            PROJECT_ENTRY = 2110,      // 项目工时
            TICKET_ENTRY = 2111,       // 工单工时
        }
        /// <summary>
        /// 发布类型 -- 146
        /// </summary>
        public enum NOTE_PUBLISH_TYPE
        {
            CONTRACT_ALL_USER=2117,              // 合同-全部用户
            CONTRACT_INTERNA_USER = 2118,        // 合同-内部用户
            TASK_ALL_USER = 2119,            // 
            TASK_INTERNA_USER = 2120,            // 
            PROJECT_ALL_USER = 2121,            //  项目-全部用户
            PROJECT_INTERNA_USER = 2122,            // 项目-团队中员工
            PROJECT_TEAM = 2123,            //  项目-团队全部成员
            TICKET_ALL_USER = 2124,             // 工单-全部用户
            TICKET_INTERNA_USER = 2125,         // 工单-内部用户
            TICKET_TEAM = 2126                  // 工单-团队用户
        }

        /// <summary>
        /// 附件发布类型 - 147
        /// </summary>
        public enum PUBLISH_TYPE
        {
            PUBLIC = 2128,          // 全部用户
            INTERNAL = 2129,        // 内部用户
        }

        /// <summary>
        /// 费用超支政策 - 148
        /// </summary>
        public enum EXPENSE_OVERDRAFT_POLICY
        {
            ALLOW_ALL_WARNING=2138,          // 允许全部需警告
            ALLOW_WITH_RECEIPT =2139,        // 允许需收据
            NOT_OVERDRAFT =2140,             // 不允许透支
            RECEIPT_REQUIRED_ALWAYS =2141,   // 总是要求回执
        }

        /// <summary>
        /// 采购订单状态 - 150
        /// </summary>
        public enum PURCHASE_ORDER_STATUS
        {
            NEW = 2147,                 // 新建
            SUBMITTED = 2148,           // 已提交
            RECEIVED_PARTIAL = 2149,    // 部分接收
            RECEIVED_FULL = 2150,       // 全部接收
            CANCELED = 2151,            // 已取消
        }
        /// <summary>
        /// 成本关联产品状态 - 151
        /// </summary>
        public enum CONTRACT_COST_PRODUCT_STATUS
        {
            NEW = 2155,                  // 新建
            ON_ORDER=2156,               // 采购中
            PICKED=2157,                 // 已拣货
            PENDING_DISTRIBUTION=2158,   // 待配送
            DISTRIBUTION=2159,           // 已配送
        }
        /// <summary>
        /// 服务请求状态-152
        /// </summary>
        public enum SERVICE_CALL_STATUS
        {
            NEW=2162,                    // 新建
            DONE=2163,                   // 已完成
            CANCEL=2164,                 // 已取消
        }
        /// <summary>
        /// 工作类型计费方法-153
        /// </summary>
        public enum WORKTYPE_BILLING_METHOD
        {
            USE_ROLE_RATE = 2166,           // 使用角色费率
            FLOAT_ROLE_RATE = 2167,         // 在角色费率基础上浮动
            RIDE_ROLE_RATE = 2168,          // 在角色费率基础上乘以系数
            USE_UDF_ROLE_RATE = 2169,       // 使用自定义费率
            BY_TIMES = 2170,                // 按次收费
        }

        /// <summary>
        /// 采购订单地址类型-154
        /// </summary>
        public enum INVENTORY_ORDER_SHIP_ADDRESS_TYPE
        {
            WORK_ADDRESS = 2173,            // 办公地点
            OTHER_ADDRESS = 2174,           // 其他地址
            SELECTED_COMPANY = 2175,        // 指定客户
        }

        /// <summary>
        /// 采购项描述信息显示类别-155
        /// </summary>
        public enum INVENTORY_ORDER_ITEM_DISPLAY_TYPE
        {
            PRODUCT_NOTE = 2178,        // 产品备注
            QUOTE_NOTE = 2179,          // 报价项备注
            CHARGE_NOTE = 2180,         // 成本备注
        }

        /// <summary>
        /// 系统支持邮箱-156
        /// </summary>
        public enum SUPPORT_EMAIL
        {
            SYS_EMAIL=2185,        // 系统发送邮件邮箱地址
        }

        /// <summary>
        /// 工时报表状态 - 157
        /// </summary>
        public enum WORK_ENTRY_REPORT_STATUS
        {
            HAVE_IN_HAND = 2188,                // 进行中
            WAITING_FOR_APPROVAL = 2189,        // 等待审批
            PAYMENT_BEEN_APPROVED = 2190,       // 已审批
            REJECTED = 2191,                    // 已拒绝
            ALREADY_PAID = 2192,                // 已支付
        }

        /// <summary>
        /// 休假审批状态 - 158
        /// </summary>
        public enum TIMEOFF_REQUEST_STATUS
        {
            COMMIT = 2195,          // 已提交
            APPROVAL = 2196,        // 已审批
            REFUSE = 2197,          // 已拒绝
            CANCLE = 2198,          // 取消
        }

        /// <summary>
        /// 工时表操作类型 - 161
        /// </summary>
        public enum WORK_ENTRY_REPORT_OPER_TYPE
        {
            SUBMIT = 2219,          // 提交
            CANCLE_SUBMIT = 2220,   // 取消提交
            APPROVAL = 2221,        // 审批通过
            REJECT = 2222,          // 审批拒绝
        }

        /// <summary>
        /// 休假申请操作类型 - 162
        /// </summary>
        public enum TIMEOFF_REQUEST_OPER
        {
            CANCLE = 2225,      // 取消申请
            PASS = 2226,        // 审批通过
            REJECT = 2227,      // 审批拒绝
        }

        /// <summary>
        /// 费用报表操作 - 163
        /// </summary>
        public enum EXPENSE_RECORD_OPER
        {
            SUBMIT = 2230,           // 提交
            CANCEL_SUBMIT = 2231,    // 取消提交
            APPROVAL_PASS = 2232,    // 审批通过
            APPROVAL_REFUSE = 2233,  // 审批拒绝
            PAYMENT = 2234,          // 支付
            RETURN_APPROVAL = 2235,  // 支付改回审批通过
        }
        /// <summary>
        /// 知识库发布对象类型 - 165
        /// </summary>
        public enum KB_PUBLISH_TYPE
        {
            ALL_USER=2255,              // 所有用户
            INTER_USER=2256,            // 内部用户
            INTER_USER_ACCOUNT=2257,    // 内部用户和指定客户
            INTER_USER_CLASS=2258,      // 内部用户和指定客户类别
            INTER_USER_TERR = 2259,     // 内部用户和指定客户地域
        }
        /// <summary>
        /// 定期工单频率类型 - 166
        /// </summary>
        public enum RECURRING_TICKET_FREQUENCY_TYPE
        {
            DAY = 2265,         // 天
            WEEK = 2266,        // 周
            MONTH = 2267,       // 月
            YEAR = 2268,        // 年
        }
        /// <summary>
        /// 工单种类 - 167
        /// </summary>
        public enum TICKET_CATE
        {
            STANDARD = 2273,     // 标准
            AEM_WARN = 2274,     // AEM告警
        }
        /// <summary>
        /// 变更申请工单：审批通过原则 - 168
        /// </summary>
        public enum APPROVAL_TYPE
        {
            ALL_APPROVERS_MUST_APPROVE = 2277,   // 全部通过
            ONE_APPROVER_MUST_APPROVE = 2278,    // 任意一个通过
        }
        /// <summary>
        /// 调度工作室：显示天数 - 169
        /// </summary>
        public enum DISPATCHER_MODE
        {
            ONE_DAY_VIEW=2281,                            // 当天
            SEVEN_DAY_WORK_VIEW =2282,                    // 所在周工作日
            FIVE_DAY_WORK_VIEW =2283,                     // 所在周
            SEVEN_DAY_WORK_VIEW_FROM_SELECTED_DAY =2284,  // 当天起7天
        }
        /// <summary>
        /// 工作流对象 - 176
        /// </summary>
        public enum WORKFLOW_OBJECT
        {
            OPPORTUNITY = 2410,             // 商机
            SALES_ORDER = 2411,             // 销售订单
            CONFIGURATION_ITEM = 2412,      // 配置项
            CONTRACT = 2413,                // 合同
            PROJECT = 2414,                 // 项目
            TASK = 2415,                    // 任务
            TICKET = 2416,                  // 工单
        }

        /// <summary>
        /// 工作流操作符 - 177
        /// </summary>
        public enum WORKFLOW_OPERATOR
        {
            EQUAL = 2426,           // =
            GREATER = 2427,         // >
            SMALLER = 2428,         // <
            NO_SMALLER = 2429,      // >=
            NO_GREATER = 2430,      // <=
            NO_EQUAL = 2431,        // 不等于
            CONTAIN = 2432,         // 包含
            EXCEED = 2433,          // 超过（预估时间）
            CHANGED = 2434,         // 改变
            CHANGED_TO = 2435,      // 更改至
            CHANGED_FROM = 2436,    // 更改自
            IN = 2437,              // 属于列表
            NOT_IN = 2438,          // 不属于列表
        }
        /// <summary>
        /// 变更单审批状态 - 181
        /// </summary>
        public enum CHANGE_APPROVE_STATUS
        {
            NOT_ASSIGNED=2457,           // 未指派
            ASSIGNED = 2458,             // 已指派
            REQUESTED =2459,             // 已申请
            PARCIALLY_APPROVED =2460,    // 部分批准
            APPROVED = 2461,             // 已批准
            REJECTED = 2462,             // 已拒绝
        }
        /// <summary>
        /// 审批人员审批变更单 - 183
        /// </summary>
        public enum CHANGE_APPROVE_STATUS_PERSON
        {
            WAIT=2488,          // 待审批
            APPROVED = 2489,    // 已批准
            REJECTED = 2490,    // 已拒绝
        }

        /// <summary>
        /// 小窗口图形类型
        /// </summary>
        public enum WIDGET_CHART_VISUAL_TYPE
        {
            PIE = 2545,                         // 饼图
            DOUGHNUT = 2546,                    // 圆环图
            LINE = 2547,                        // 折线图
            BAR = 2548,                         // 条形图
            COLUMN = 2549,                      // 柱状图
            STACKED_BAR = 2550,                 // 堆积条形图
            STACKED_COLUMN = 2551,              // 堆积柱状图
            GROUPED_BAR = 2552,                 // 分组条形图
            GROUPED_COLUMN = 2553,              // 分组柱状图
            STACKED_COLUMN_PERCENT = 2554,      // 百分比堆积条形图
            STACKED_BAR_PERCENT = 2555,         // 百分比堆积柱状图
            STACKED_AREA = 2556,                // 堆积面积图
            TABLE = 2557,                       // 表格
            FUNNEL = 2558,                      // 漏斗图
            NEEDLE = 2559,                      // 仪表盘
            DOUGHNUT_GUAGE = 2560,              // 圆环图
            NUMBER = 2561,                      // 数字
        }

        /// <summary>
        /// 小窗口类型 - 189
        /// </summary>
        public enum WIDGET_TYPE
        {
            CHART = 2581,           // 图形
            CHART_COMPARE = 2582,   // 图形（比较两个指标）
            GUAGE = 2583,           // 进度指示
            GRID = 2584,            // 表格
            HTML = 2585,            // HTML
        }
        /// <summary>
        /// 工单解决参数设置 - 206
        /// </summary>
        public enum SYS_TICKET_RESOLUTION_METRICS
        {
            MAXIMUM_DEAL_DAY=3084,                        // 严重工单最大平均解决天数
            MAXIMUM_OPEN_CRITICAL_TICKETS =3085,          // 最大未解决严重工单数
            MAXIMUM_OPEN_TICKETS = 3086,                  // 最大未解决工单数
            MAXIMUM_NEW_TICKETS = 3087,                   // 最大新建工单数
            MAXIMUM_AVERAGE_TICKETS_PER_RESOURCE = 3088,  // 人均最大平均工单数
        }
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
        Resource=23,                    //员工
        InstalledProductView = 32,     // 配置项管理
        Subscription = 34,              // 订阅
        SaleOrder = 36,                 // 销售订单
        Contract = 37,                  // 合同
        Role = 40,                      // 角色
        Department = 41,                // 部门   
        Market=47,                        //市场
        Territory=48,                     //地域
        ProuductInventory=50,           //产品库存
        Prouduct = 51,                  //产品
		InternalCost = 52,                // 合同内部成本
        ContractRate = 53,              // 合同费率
        ResourceCallBack = 54,          // 员工查找带回
		CONFIGITEM=55,                  //配置项
        Relation_ConfigItem = 56,       // 关联到该合同的配置项
        Norelation_ConfigItem = 57,     // 未关联到该合同的配置项
        SECURITYLEVEL=59,               //安全等级
        MILESTONE=60,                   //里程碑
        Contract_Charge = 61,               // 合同成本
        REVOKE_CHARGES = 62,               //撤销成本审批
        ContractType=63,                  //合同类别
        ContractUDF = 64,               // 合同自定义字段
        REVOKE_RECURRING_SERVICES = 65,    //撤销定期服务审批
        REVOKE_MILESTONES = 66,            //撤销里程碑审批
        REVOKE_SUBSCRIPTIONS = 67,         //撤销订阅审批  
		CONTRACT_DEFAULT_COST = 68,        // 合同默认成本
        CONTRACT_RATE=69,                  // 合同预付时间
        ACCOUNTREGION = 70,                   //客户区域
        COMPETITOR = 71,                       //竞争对手
        ACCOUNTTYPE =72,                      //客户类型
        SUFFIXES = 74,                           //姓名后缀
        ACTIONTYPE = 75,                        //活动类型
        OPPORTUNITYAGES = 76,                       //商机阶段
        OPPORTUNITYSOURCE = 77,                   //商机来源
        OPPPORTUNITYWINREASON = 78,             //关闭商机的原因
        OPPPORTUNITYLOSSREASON = 79,             //丢失商机的原因
        ContractBlockTime = 80,             // 合同管理-预付时间
        ContractMilestone = 81,             // 合同管理-里程碑
        InvoiceTemplate = 82,               //发票模板
        Invoice_History = 83,               //历史发票
        APPROVE_CHARGES = 84,               //成本审批
        APPROVE_MILESTONES = 85,            //里程碑审批
        APPROVE_SUBSCRIPTIONS=86,           //订阅审批
        APPROVE_RECURRING_SERVICES = 87,    //定期服务审批
        GENERATE_INVOICE=88,                // 生成发票
        ContractService = 89,               // 合同管理-服务/服务包
        ContractServiceTransHistory = 90,   // 合同管理-服务/包-交易历史
        ContractBlock = 91,                 // 合同管理-预付费用
        ContractBlockTicket = 92,           // 合同管理-事件查询
        CONFIGSUBSCRIPTION = 93,           // 配置项界面订阅管理
        PROJECT_SEARCH=100,                  // 项目查询
        CRMNote = 101,                  // 客户备注查询
        Todos = 102,                    // 客户代办查询
        CompanyViewContract = 103,      // 客户详情-合同
        CompanyViewInvoice = 104,       // 客户详情-发票查询
        PROJECT_TEMP_SEARCH = 105,      // 项目模板查询
        PROJECT_PROPOSAL_SEARCH = 106,  // 项目提案查询
        CompanyViewAttachment = 107,    // 客户详情-附件
        PROJECT_TASK = 109,              // 项目详情-task列表
        PROJECT_PHASE=110,               // 项目详情-TASK列表-阶段
        PROJECT_PHASE_BUDGET = 111,      // 项目详情-TASK列表-阶段预算
        PROJECT_TASK_OVERDUE = 112,      // 项目详情-TASK列表-过期task
        PROJECT_TASK_COMPLETE = 113,      // 项目详情-TASK列表-完成
        PROJECT_TASK_INCOMPLETE = 114,      // 项目详情-TASK列表-未完成
        PROJECT_TASK_BLOCK = 115,      // 项目详情-TASK列表-影响后续任务完成
        PROJECT_TASK_NOTNOTIME = 116,      // 项目详情-TASK列表-不能按时完成
        PROJECT_ISSUE = 117,            // 项目详情-TASK列表-问题
        PROJECT_BASELINE = 118,         // 项目详情-TASK列表-基准
        OpportunityViewAttachment = 119,// 商机详情-附件查询
        SalesOrderViewAttachment = 120, // 销售订单详情-附件查询
        APPROVE_EXPENSE = 124,          // 费用审批  approve_expense
        REVOKE_EXPENSE = 125,           // 系统管理-撤销费用审批
        PROJECT_TEAM = 126,             // 项目管理-项目详情-团队查询
        PROJECT_COST_EXPENSE = 127,     // 项目管理-项目详情-成本和费用查询
        InventoryLocation = 128,        // 库存仓库查询
        InventoryItem = 129,            // 库存产品查询
        PROJECT_NOTE = 131,             // 项目管理-项目详情-备注查询
        ACCOUNT_POLICY = 132,           // 客户策略
        APPROVE_LABOUR = 133,           // 工时审批 approve_labour
        REVOKE_LABOUR = 134,            // 系统管理-撤销工时审批
        PROJECT_RATE = 135,             // 项目管理-项目详情-费率查询
        PROJECT_CALENDAR = 136,         // 项目管理-项目详情-日历查询
        PROJECT_ATTACH = 137,           // 项目管理-项目详情-附件查询
        PROJECT_UDF = 138,              // 项目管理-项目详情-自定义查询
        TASK_HISTORY = 139,             // 任务操作历史
        WAREHOUSEPRODUCTSN = 140,                // 库存产品串号查询
        InventoryTransfer = 141,        // 库存转移
        PurchaseApproval = 142,         // 采购审批查询
        PurchaseFulfillment = 143,      // 待采购产品查询
        CONTRACT_NOTIFY_RULE=145,       // 合同通知规则
        PurchaseOrder = 146,            // 采购订单查询
        PurchaseItem = 147,             // 采购订单采购项
        CONTRACT_PROJECT=149,           // 合同查看 - 项目
        PurchaseReceive = 150,          // 采购接收
        ShippingList = 151,             // 库存管理-配送管理-配送列表查询
        ShipedList = 152,               // 库存管理-配送管理-已配送列表查询
        PURCHASE_ORDER_HISTORY=153,     // 库存管理-采购订单历史-查询
        ShippingItemSerailNum = 154,    // 库存管理-产品序列号查找带回（取消接收用）
        EXPENSE_REPORT=157,             // 工时表-我的费用报表-查询
        HolidaySet = 158,               // 系统设置-节假日设置
        Holidays = 159,                 // 系统设置-节假日查询
        MYAPPROVE_EXPENSE_REPORT = 160, // 工时表-等待我审批的费用报表-查询
        APPROVED_REPORT = 161,          // 工时表-已审批的费用报表-查询  
        TICKET_SEARCH = 168,            // 工单管理-工单查询
        TICKET_ACCOUNT_LIST = 169,      // 客户未关闭工单列表
        TICKET_SLA_LIST = 170,              // 工单管理-SLA事件查询
        TICKET_SERVICE_LIST = 171,          // 工单管理-待办和服务预定
        TICKET_COST_EXPENSE = 172,          // 工单管理-成本和费用
        SERVICE=173,                        // 服务查询  
        SERVICE_BUNDLE=174,                 // 服务包查询
        MY_TASK_TICKET = 175,               // 我的任务和工单
        REPORT_CRM_EXPORT_COMPANY = 176,    // 报表-导出-导出客户信息
        REPORT_CRM_EXPORT_CONTACT = 177,    // 报表-导出-导出联系人信息
        REPORT_CRM_INSPRO_DETAIL = 178,     // 报表-CRM配置项-配置项详情
        REPORT_SERVICEDESK_TICKETBYACCOUNT = 179, // 报表--服务台常规-工单和任务按客户
        REPORT_CONTRACT_BILLED = 180,          // 报表-CRM配置项-已计费信息
        WorkflowRule = 185,             // 工作流规则查询
        MASTER_SUB_TICKET_SEARCH = 186,       // 定期主工单管理-详情-子工单查询 
        SERVICE_CALL_SEARCH = 187,             // 服务预定管理-服务预定查询
        SERVICE_CALL_TICKET = 188,             // 服务预定关联工单查询 
        KnowledgebaseArticle = 189,     // 知识库文档管理-查询
        MASTER_TICKET_SEARCH = 190,         // 定期主工单查询
        TICKET_REQUEST = 192,            // 工单详情-变更请求
        TICKET_INCIDENT = 193,                 // 工单详情-事故清单
        TICKET_PROBLEM = 194,                  // 工单详情-问题清单
        TimeoffPolicy = 196,            // 休假策略查询
        TimeoffPolicyResource = 197,    // 休假策略-关联员工查询
        TimeoffPolicyTier = 198,        // 休假策略-级别查询
        ACCOUNT_SERVICE_DETAILS = 199,   // 工单详情-客户服务详情
        TICKET_INCLIDENT_RELATION=200,   // 工单详情-事故关联其他工单
        DISPATCH_TICKET_SEARCH = 201,          // 调度工作室-工单查询
        MY_QUEUE_ACTIVE = 202,                 // 服务台-我的工作区-活动工单 
        MY_QUEUE_MY_TICKET = 203,              // 服务台-我的工作区-我创建的工单
        MY_QUEUE_CHANGE_APPROVEL = 204,        // 服务台-我的工作区-变更申请审批 
        MY_QUEUE_VIEW = 205,                   // 服务台-我的工作区-队列视图 
        ResourcePolicyAssignment = 207,     // 员工详情-休假策略
        ResourceTimeSheet = 208,            // 员工详情-工时表审批人
        ResourceExpense = 209,              // 员工详情-费用审批人
        ResourceDepartment = 210,           // 员工详情-员工部门
        ResourceServiceDeskQueue = 211,     // 员工详情-员工队列
        ResourceSkill = 212,                // 员工详情-员工技能
        ResourceCertificate = 213,          // 员工证书和培训
        ResourceDegree = 214,               // 员工详情-员工学位
        ResourceAttachment = 215,           // 员工详情-员工附件
        TimeoffMyCurrent = 217,             // 工时表管理-我的当前工时表
        TimeoffWaitApprove = 218,           // 工时表管理-等待我审批的工时表
        TimeoffWaitApproveDetail = 219,     // 工时表管理-等待我审批的工时表-列表详情
        TimeoffSubmited = 220,              // 工时表管理-已提交工时表
        TimeoffMyRequest = 221,             // 工时表管理-我的休假请求
        TimeoffMyBalance = 222,             // 工时表管理-休假余额详情
        TimeoffRequestWaitApprove = 223,    // 等待我审批的休假请求
        TASK_SEARCH_NO = 225,               // 系统管理-快捷搜索-任务编号


        WidgetDrillCompany = 216,           // 小窗口-客户
        WidgetDrillConfiguration = 226,     // 小窗口-配置项
        WidgetDrillContract = 227,          // 小窗口-合同
        WidgetDrillInvoiceItems = 232,      // 小窗口-发票条目
        WidgetDrillMilestones = 235,        // 小窗口-里程碑
        WidgetDrillMiscellaneous = 237,     // 小窗口-其他
        WidgetDrillOpportunity = 238,       // 小窗口-商机
        WidgetDrillOutOffice = 239,         // 小窗口-外出
        WidgetDrillPendingBillItems = 234,  // 小窗口-待审批并提交条目
        WidgetDrillPostedBillItems = 233,   // 小窗口-已审批并提交条目
        WidgetDrillProjects = 240,          // 小窗口-项目
        WidgetDrillTask = 241,              // 小窗口-任务
        WidgetDrillQuotes = 242,            // 小窗口-报价
        WidgetDrillQuoteItems = 243,        // 小窗口-报价项
        WidgetDrillRecurMasterTickets = 244,// 小窗口-定期服务主工单
        WidgetDrillScheduledItems = 245,    // 小窗口-已调度条目
        WidgetDrillServiceCalls = 246,      // 小窗口-服务预定
        WidgetDrillSurveys = 247,           // 小窗口-问卷调查
        WidgetDrillTickets = 248,           // 小窗口-工单
        WidgetDrillTimeoffRequest = 230,    // 小窗口-休假申请
        WidgetDrillTimesheet = 231,         // 小窗口-工时表
        WidgetDrillTodoNotes = 249,         // 小窗口-备注和待办
        WidgetDrillWorkEntries = 236,       // 小窗口-工时

        MyWorkListTicket = 250,              // 我的工作列表 工单列表
        MyWorkListTask = 251,                // 我的工作列表 任务列表

        COMPANY_VIEW_ACCOUNT_PROFIT_MARGIN = 252,       // 客户查看-客户利润率
        COMPANY_VIEW_MONTH_PROFIT_MARGIN = 253,         // 客户查看-月利润率
        COMPANY_VIEW_MONTH_PROFIT_MARGIN_BYDATE = 254,  // 客户查看-月利润率（按照计费时间）
        COMPANY_VIEW_CONTRACT_PROFIT = 255,             // 客户查看-合同利润
        COMPANY_VIEW_CONTRACT_PROFIT_BYDATE = 256,      // 客户查看-合同利润（按照计费时间）
        COMPANY_VIEW_CONTRACT_PROFIT_MARGIN = 257,      // 客户查看-合同利润率
        COMPANY_VIEW_PROJECT_PROFIT = 258,              // 客户查看-项目利润
        COMPANY_VIEW_PROJECT_PROFIT_BYDATE = 259,       // 客户查看-项目利润（按照计费时间）
        COMPANY_VIEW_PROJECT_PROFIT_MARGIN = 260,     // 客户查看-项目利润率
        COMPANY_VIEW_RES_WORKHOUR = 261,                // 客户查看-员工已工作时间
        COMPANY_VIEW_RES_WORKHOUR_BYDATE = 262,         // 客户查看-员工已工作时间（按照计费时间）  
        COMPANY_VIEW_ACCOUNT_OVERVIEW = 263,            // 客户查看-客户总览    
        COMPANY_VIEW_ACCOUNT_OVERVIEW_BYDATE = 264,     // 客户查看-客户总览（按照计费时间）
        REPORT_CRM_MY_ACCOUNT_TICKET = 265,            // 报表-CRM-我的客户的工单
        REPORT_CRM_OPPORTUNITY_DETAILS = 266,          // 报表-CRM-商机-商机详情
        REPORT_CRM_OPPORTUNITY_STATUS = 267,           // 报表-CRM-商机-商机状态
        REPORT_CRM_OPPORTUNITY_CRM_NOTE = 268,         // 报表-CRM-商机-CRM备注
        CONTACR_GROUP_SEARCH = 269, 
        VIEW_CONTACT_GROUP_SEARCH =270,
        CONTACR_GROUP_CONTACT_CALLBACK = 271,
        CONTACT_ACTION_TEMP = 272,                     // 联系人活动 模板
        ACCOUNT_CONTACT_GROUP_SEARCH = 273,
        OTHER_INSTALLED_PRODUCT_SEARCH=274,
  
       

        //以下是还没有配查询语句的枚举（系统管理）
        General,                       //general表的通用处理
        Line_Of_Business,              //系统管理：组织：业务条线
        Project_Status,                 //项目：项目状态
        Task_Type,                       //任务类型
        Payment_Term,                    //付款期限
        Payment_Type,                    //付款类型
        Payment_Ship_Type,               //配送类型
        Quote_Email_Tmpl,                //报价邮件模板
        Invoice_Email_Tmpl,              //发票邮件模板
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
        COMPANTREPORT,

        ContactAdd = 111,                            //
        ContactEdit = 112,                            //
        ContactLocationSelect = 113,                  // 联系人页面地址的查找带回
        ContactView = 114,                            // 查看联系人
        ContactCallBack = 115,                        // 联系人查找带回

        OpportunityAdd = 121,                       // 添加商机
        OpportunityEdit = 122,                      // 修改商机
        OpportunityLose = 123,                    // 丢失商机
        OpportunityView = 124,                    // 查看商机
        OpportunityClose = 125,                     // 关闭商机（即赢得商机）

        QuoteAdd = 131,                             // 报价新增
        QuoteEdit = 132,                            // 报价修改
        QuoteLost = 133,                            // 丢失报价
        QuoteView = 134,                            // 电子报价单预览

        LocationAdd = 141,                         // 地址新增
        LoactionEdit = 142,                        // 地址修改

        TodoAdd = 150,                          // 新增活动
        NoteAdd = 151,                          // 备注新增
        AttachmentAdd,                          // 附件新增

        RoleSelect = 160,                        // 角色查询
        ResourceSelect = 161,                    // 员工的查找带回

        QuoteItemAdd = 170,                      // 报价项新增
        QuoteItemEdit = 171,                     // 报价项修改
        QuoteItemManage = 172,                   // 报价项管理

        QuoteTemplateAdd = 181,                 // 报价模板新增
        QuoteTemplateEdit = 182,                // 报价模板编辑

        ProductSelect = 190,                    // 产品查找带回
        ManyProductSelect = 191,                // 多选产品查找带回
        ProductView=192,                        //产品查看
        ProuductEdit=193,                       //产品编辑

        ServiceSelect = 200,                      // 服务的查找带回
        ServiceBundleSelect = 201,               // 服务集的查找带回

        AddInstalledProduct = 210,              // 添加配置项
        EditInstalledProduct = 211,             // 修改配置项
        RelationContract = 212,                 // 将配置项关联合同
        InstalledProductIwarid=213,             // 配置项向导
        SubscriptionEdit = 220,                // 修改订阅
        SubscriptionAdd = 221,                 // 新增订阅


        SaleOrderEdit = 225,                  // 销售订单的编辑
        SaleOrderView = 226,                   // 销售订单的查看

        CostCodeSelect = 230,                  // 物料成本的查找带回


        ContractAdd = 301,                      // 合同新增
        ContractEdit = 302,                     // 合同编辑
        ContractSelectCallBack = 303,           // 合同查找带回
        ConIntCostAdd = 304,                    // 合同内部成本新增
        ConIntCostEdit = 305,                       // 合同内部成本编辑
        ConChargeAdd = 306,                         // 合同成本新增
        ConChargeEdit = 307,                        // 合同成本修改
        ConChargeDetails = 308,                     // 合同成本查看
        ProductCata = 310,                        //产品种类查找带回
        MaterialCode = 311,                       //物料代码查找带回
        ConDefCostAdd = 312,                      // 合同默认成本新增
        ConDefCostEdit = 313,                     // 合同默认成本修改
        ConRateAdd=314,                           // 合同预付时间系数新增
        ConRateEdit = 315,                        // 合同预付时间系数编辑
        ConBlockAdd = 316,                      // 合同新增预付
        ConBlockEdit = 317,                     // 合同编辑预付
        ConMilestoneAdd = 318,                  // 合同新增里程碑
        ConMilestoneEdit = 319,                 // 合同编辑里程碑
        ConServiceAdd,                          // 合同新增服务/服务包
        ConServiceEditInvoiceDesc,              // 合同服务编辑发票描述
        BillCodeCallback,                       // 计费代码查找带回


        VendorAdd,                          //添加供应商
        TerritorySource,                   //地域带回员工
        VendorSelect,                    //查找供应商
        TERRITORY,                             //添加地域
        MARKET_SEGMENT,                        //添加市场
        REGION,                                //添加区域
        COMPETITOR,                            //添加竞争对手
        ACTION_TYPE,                           //添加活动类型
        OPPORTUNITY_STAGE,                     //添加商机阶段
        OPPORTUNITY_SOURCE,                    //添加商机来源
        NAME_SUFFIX,                           //添加姓名后缀
        SysOPPORTUNITY_ADVANCED_FIELD,        //添加商机扩展字段

        Inventory,                             //产品库存编辑
        InventoryTransfer,                     //移库

        Resource=340,                              //员工信息展示
        ResourceCopy = 341,                        //复制员工信息

        SecurityLevel=350,                         //安全等级界面

        Role=360,                                  //角色
        Department=361,                            //部门
        ConfigItemType=362,                        //配置项类型
        ContractType=363,                          //合同类别

        ContractPostDate = 363,                    //合同审批，提交日期
        ContractAdjust = 364,                      //合同审批，调整总价
        ContractMilestone= 365,                    //合同审批，查看里程碑详情
        ContractChargeSelect=366,                  //合同审批，成本关联预付费时的，选择操作窗口

        InvoiceTemplate=370,                      //新增发票模板
        InvoiceTemplateAttr = 371,                //发票模板属性

        InvoiceHistoryEdit =380,                   //历史发票更改（发票编号和日期）

        ACCOUNTTYPE=390,                           //客户类别
        OPPORTUNITYWIN=391,                        //关闭商机原因
        OPPORTUNITYLOSS= 391,                       //丢失商机原因

        PROJECTCALLBACK=400,                  // 项目查找带回
        INVOICE_PREFERENCE = 401,             // 发票设置
        INVOICE_PROCESS = 402,                 // 发票处理
        INVOICE_WIZARD = 403,                  // 发票向导
        INVOICE_PREVIEW = 404,                 // 发票预览

        GeneralAddAndEdit=410,                         //general表的新增和修改
        GeneralJs=411,                                 //注册js语句

        QuotePreference,                        // 客户报价参数设置

        QuoteBodyItem=420,                             //打开报价模板编辑
        EmailTemp=421,                                 //邮件模板

        PROJECT_RECIPIENTSELECTOR=430,              // 通知邮件配置


        PROJECT_ADD ,                          // 项目新增
        PROJECT_EDIT ,                         // 项目编辑
        PROJECT_VIEW ,                         // 项目查看

        TASKPHASE_CALLBACK,       // task阶段的查找带回
        TASKADD,                  // task新增
        TASKEDIT ,                // task修改
        TASKVIEW,                 // 查看task
        TASK_MODIFY,              // task批量修改
        TASK_TO_LIBARY,           // 添加到任务库

        WORK_ENTRY_ADD,          // 工时新增修改
        WORK_ENTRY_EDIT,         // 工时新增修改

        TASK_NOTE_ADD,         // 任务备注新增修改 
        TASK_NOTE_EDIT,        // 任务备注新增修改 

        TASK_ATTACH,
        PROJETC_ATTACH,
        TASK_EXPENSE_ADD,     // 任务费用新增修改
        TASK_EXPENSE_EDIT,    // 任务费用新增修改
        RESOURCE_CALLBACK,    // 员工的查找带回

        ACCOUNT_POLICY,
        EXPENSE_REPORT_CALLBACK,
        SERNUM_CALLBACK,       // 产品序列号查找带回

        EXC_CONTRACT_CALLBACK,
        EXPENSE_REPORT_DETAIL, // 费用报表详情界面
        COMPANY_POLICY,        // 客户策略
        EXPENSE_REPORT_REFUSE, // 费用报表拒绝原因
        EXPENSE_REPORT_VIEW,   // 费用报表查看
        ADD_TICKET_LABOUR,     // 新增工单工时
        ADD_TICKET_NOTE,       // 新增工单备注
        ADD_TICKET_SERVICECALL,       // 新增工单服务预定
        ADD_TICKET_ATTACH,     // 新增工单附件
        ADD_TICKET_EXPENSE,    // 新增工单费用
        SHOW_TICKET_HISTORY,   // 工单历史查看
        DISPATCH_CALENDAR,     // 调度工作室

    }
    /// <summary>
    /// 固定的物料代码
    /// </summary>
    public enum CostCode
    {
        // 1159
        ENTERTAINMENT_EXPENSE=17,    // 娱乐费用（招待费用）
        MILEAGE=18,             // 总里程

        // 1160-休假类别
        Sick = 23,                  // 病假
        Vacation = 25,              // 年休假
        Floating = 27,              // 浮动假期
        Holiday = 28,               // 节假日
        Personal = 35,              // 私人时间

        // 1161
        CHANGEORDER =36,           // 变更
        NOTAXDISCOUNT=37,          // 不收税折扣
        DISCOUNT=43,               // 折扣
    }
}
