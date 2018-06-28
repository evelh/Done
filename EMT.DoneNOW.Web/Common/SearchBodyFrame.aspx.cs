using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    public partial class SearchBodyFrame : BasePage
    {
        private QueryCommonBLL bll = new QueryCommonBLL();
        protected int catId = 0;
        //protected string queryPage;     // 查询页名称
        protected long queryTypeId;     // 查询页id
        protected long paraGroupId;     // 查询条件分组id
        protected string addBtn;        // 根据不同查询页得到的新增按钮名
        protected QueryResultDto queryResult = null;            // 查询结果数据
        protected List<QueryResultParaDto> resultPara = null;   // 查询结果列信息
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected List<DictionaryEntryDto> queryParaValue = new List<DictionaryEntryDto>();  // 查询条件和条件值
        protected int tableWidth = 1200;
        protected long objId = 0;

        // 额外的参数(带入页面供js使用)
        protected string param1;
        protected string param2;

        protected bool isShowTitle = false;     // 页面是否显示title
        protected string title;                 // 页面title

        protected DateTime searchTime = DateTime.Now;   // 合同服务查询的查询日期

        protected string isCheck = ""; //  用于控制是否显示checkBox
        protected void Page_Load(object sender, EventArgs e)
        {
            isCheck = Request.QueryString["isCheck"];
            param1 = string.IsNullOrEmpty(Request.QueryString["param1"]) ? "" : Request.QueryString["param1"];
            param2 = string.IsNullOrEmpty(Request.QueryString["param2"]) ? "" : Request.QueryString["param2"];


            if (!string.IsNullOrEmpty(Request.QueryString["widgetDrill"]))
            {
                WidgetDrillQuery();
                InitPageTitle();
                return;
            }

            if (!int.TryParse(Request.QueryString["cat"], out catId))
                catId = 0;
            if (!long.TryParse(Request.QueryString["type"], out queryTypeId))
                queryTypeId = 0;
            if (!long.TryParse(Request.QueryString["group"], out paraGroupId))
                paraGroupId = 0;
            if (catId == 0 || queryTypeId == 0)
            {
                Response.Close();
                return;
            }
            // 一个query_type下只有一个group时可以不传参gruop_id
            if (paraGroupId == 0)
            {
                var groups = bll.GetQueryGroup(catId);
                foreach (var g in groups)
                {
                    if (g.query_type_id == queryTypeId)
                    {
                        if (paraGroupId != 0)   // 一个query_type下有多个group，不能判断使用哪个
                        {
                            Response.Close();
                            return;
                        }
                        paraGroupId = g.id;
                    }
                }
            }

            if (!long.TryParse(Request.QueryString["id"], out objId))
                objId = 0;


            InitPageTitle();
            InitData();
            GetMenus();
            string flag = Request.QueryString["show"];
            if (string.IsNullOrEmpty(flag) || !flag.Equals("1"))
            {
                QueryData();
                CalcTableWidth();
            }
        }

        /// <summary>
        /// 小窗口钻取查询处理
        /// </summary>
        private void WidgetDrillQuery()
        {
            long widgetId;
            if (!long.TryParse(Request.QueryString["id"], out widgetId))
            {
                Response.End();
                return;
            }
            var wgtBll = new DashboardBLL();
            var widget = wgtBll.GetWidgetById(widgetId);
            if (widget == null)
            {
                Response.End();
                return;
            }
            var groups = bll.GetQueryGroup(widget.entity_id);
            if (groups.Count != 1)
            {
                Response.End();
                return;
            }
            catId = groups[0].cate_id;
            queryTypeId = groups[0].query_type_id;
            paraGroupId = groups[0].id;
            if(queryTypeId==(long)QueryType.WidgetDrillTimeoffRequest|| queryTypeId == (long)QueryType.WidgetDrillTimesheet)
            {
                isCheck = "1";
            }

            resultPara = bll.GetResultParaSelect(LoginUserId, paraGroupId);    // 获取查询结果列信息
            var keys = Request.QueryString;
            string order = keys["order"];   // order by 条件
            int page;
            if (!int.TryParse(keys["page_num"], out page))
                page = 1;
            int pageSize = string.IsNullOrEmpty(keys["page_size"]) ? 0 : int.Parse(keys["page_size"]);  // 查询每页个数

            QueryWidgetDrillParaDto queryPara = new QueryWidgetDrillParaDto();
            queryPara.query_type_id = queryTypeId;
            queryPara.para_group_id = paraGroupId;
            queryPara.page = page;
            queryPara.order_by = order;
            queryPara.page_size = pageSize;
            queryPara.widget_id = widgetId;
            queryPara.group1 = keys["val1"];
            queryPara.group2 = keys["val2"];
            queryResult = bll.GetResultWidgetDrill(LoginUserId, queryPara);


            GetMenus();
            CalcTableWidth();
        }

        /// <summary>
        /// 设置页面title
        /// </summary>
        private void InitPageTitle()
        {
            switch (queryTypeId)
            {
                case (int)QueryType.WidgetDrillCompany:
                    title = "客户管理";
                    break;
                case (int)QueryType.WidgetDrillConfiguration:
                    title = "配置项管理";
                    break;
                case (int)QueryType.WidgetDrillContract:
                    title = "合同管理";
                    break;
                case (int)QueryType.WidgetDrillInvoiceItems:
                    title = "发票条目";
                    break;
                case (int)QueryType.WidgetDrillMilestones:
                    title = "里程碑";
                    break;
                case (int)QueryType.WidgetDrillMiscellaneous:
                    title = "其他";
                    break;
                case (int)QueryType.WidgetDrillOpportunity:
                    title = "商机";
                    break;
                case (int)QueryType.WidgetDrillOutOffice:
                    title = "外出";
                    break;
                case (int)QueryType.WidgetDrillPendingBillItems:
                    title = "待审批并提交条目";
                    break;
                case (int)QueryType.WidgetDrillPostedBillItems:
                    title = "已审批并提交条目";
                    break;
                case (int)QueryType.WidgetDrillProjects:
                    title = "项目";
                    break;
                case (int)QueryType.WidgetDrillTask:
                    title = "任务";
                    break;
                case (int)QueryType.WidgetDrillQuotes:
                    title = "报价";
                    break;
                case (int)QueryType.WidgetDrillQuoteItems:
                    title = "报价项";
                    break;
                case (int)QueryType.WidgetDrillRecurMasterTickets:
                    title = "定期服务主工单";
                    break;
                case (int)QueryType.WidgetDrillScheduledItems:
                    title = "已调度条目";
                    break;
                case (int)QueryType.WidgetDrillServiceCalls:
                    title = "服务预定";
                    break;
                case (int)QueryType.WidgetDrillSurveys:
                    title = "问卷调查";
                    break;
                case (int)QueryType.WidgetDrillTickets:
                    title = "工单";
                    break;
                case (int)QueryType.WidgetDrillTimeoffRequest:
                    title = "休假请求";
                    break;
                case (int)QueryType.WidgetDrillTimesheet:
                    title = "工时表管理";
                    break;
                case (int)QueryType.WidgetDrillTodoNotes:
                    title = "备注和待办";
                    break;
                case (int)QueryType.WidgetDrillWorkEntries:
                    title = "工时";
                    break;
                case (int)QueryType.SharedDashboard:
                    title = "共享仪表板";
                    break;
                default:
                    title = "";
                    break;
            }
            if (!string.IsNullOrEmpty(title))
                isShowTitle = true;
            else
                isShowTitle = false;
        }

        /// <summary>
        /// 数据初始化
        /// </summary>
        private void InitData()
        {
            switch (catId)
            {
                case (int)DicEnum.QUERY_CATE.COMPANY:
                    addBtn = "新增客户";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTACT:
                case (int)DicEnum.QUERY_CATE.CONTACT_COMPANY_VIEW:
                    addBtn = "新增联系人";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPORTUNITY:
                case (int)DicEnum.QUERY_CATE.OPPORTUNITY_COMPANY_VIEW:
                case (int)DicEnum.QUERY_CATE.OPPORTUNITY_CONTACT_VIEW:
                    addBtn = "新增商机";
                    break;
                case (int)DicEnum.QUERY_CATE.QUOTE:
                    addBtn = "新增报价";
                    break;
                case (int)DicEnum.QUERY_CATE.QUOTE_TEMPLATE:
                    addBtn = "新增报价模板";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT:
                    addBtn = "新增合同";
                    break;
                case (int)DicEnum.QUERY_CATE.PRODUCTINVENTORY:
                    addBtn = "新增产品库存";
                    break;
                case (int)DicEnum.QUERY_CATE.RESOURCE:
                case (int)DicEnum.QUERY_CATE.SYS_DEPARTMENT:
                case (int)DicEnum.QUERY_CATE.SYS_ROLE:
                case (int)DicEnum.QUERY_CATE.CONFIGITEMTYPE:
                case (int)DicEnum.QUERY_CATE.CONTRACT_MILESTONE:
                case (int)DicEnum.QUERY_CATE.COMPANY_VIEW_ATTACHMENT:
                case (int)DicEnum.QUERY_CATE.SALES_ORDER_VIEW_ATTACHMENT:
                case (int)DicEnum.QUERY_CATE.OPPORTUNITY_VIEW_ATTACHMENT:
                case (int)DicEnum.QUERY_CATE.MASTER_TICKET_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_SKILL:
                case (int)DicEnum.QUERY_CATE.SYSTEM_SKILL_CATE:
                case (int)DicEnum.QUERY_CATE.SYSTEM_CERTIFICATION:
                case (int)DicEnum.QUERY_CATE.SYSTEM_DEGREE:
                case (int)DicEnum.QUERY_CATE.SYSTEM_CERTIFICATION_CATE:
                case (int)DicEnum.QUERY_CATE.SYSTEM_DEGREE_CATE:
                case (int)DicEnum.QUERY_CATE.SYSTEM_RESOURCE_WORKGROUP_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_TIME_APPROVAL_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_EXPENSE_APPROVAL_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_QUEUE_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_TICKET_SOURCE_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_TICKET_STATUS_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_TICKET_PRIORITY_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_TICKET_ISSUE_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_CHANGE_BOARD_SEARCH:
                case (int)DicEnum.QUERY_CATE.SYSTEM_CHECK_LIB_SEARCH:
                case (int)DicEnum.QUERY_CATE.USER_DEFINED_FIELD:
                case (int)DicEnum.QUERY_CATE.SHARED_DASHBOARD:
                case (int)DicEnum.QUERY_CATE.SYSTEM_PROJECT_STATUS:
                case (int)DicEnum.QUERY_CATE.SYSTEM_TASK_LIBRARY_CATE:
                case (int)DicEnum.QUERY_CATE.SYSTEM_PAYMENT_TYPE:
                case (int)DicEnum.QUERY_CATE.SYSTEM_PAYMENT_TERM:
                case (int)DicEnum.QUERY_CATE.SYSTEM_SHIP_TYPE:
                    addBtn = "新增";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_INTERNAL_COST:
                    addBtn = "新增内部成本";
                    break;
                case (int)DicEnum.QUERY_CATE.PRODUCT:
                    addBtn = "新增产品";
                    break;
                case (int)DicEnum.QUERY_CATE.INSTALLEDPRODUCT:
                    addBtn = "新增配置项";
                    break;
                case (int)DicEnum.QUERY_CATE.RELATION_CONFIGITEM:
                    addBtn = "新增配置项";
                    break;
                case (int)DicEnum.QUERY_CATE.REVOKE_CHARGES:
                case (int)DicEnum.QUERY_CATE.REVOKE_MILESTONES:
                case (int)DicEnum.QUERY_CATE.REVOKE_RECURRING_SERVICES:
                case (int)DicEnum.QUERY_CATE.REVOKE_SUBSCRIPTIONS:
                case (int)DicEnum.QUERY_CATE.REVOKE_LABOUR:
                case (int)DicEnum.QUERY_CATE.REVOKE_EXPENSE:
                    addBtn = "完成";
                    break;
                case (int)DicEnum.QUERY_CATE.APPROVE_MILESTONES://审批里程碑  
                case (int)DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS://审批订阅
                case (int)DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES://审批定期服务
                case (int)DicEnum.QUERY_CATE.APPROVE_CHARGES://审批成本
                case (int)DicEnum.QUERY_CATE.APPROVE_LABOUR://审批成本
                case (int)DicEnum.QUERY_CATE.APPROVE_EXPENSE://审批成本
                    addBtn = "审批并提交";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_CHARGE:
                    addBtn = "添加合同成本";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_DEFAULT_COST:
                    addBtn = "添加合同默认成本";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_TIME_RATE:
                    addBtn = "添加预付时间系数";
                    break;
                case (int)DicEnum.QUERY_CATE.INVOICE_TEMPLATE:
                    addBtn = "新增发票模板";
                    break;
                case (int)DicEnum.QUERY_CATE.MARKET:
                    addBtn = "新增市场领域";
                    break;
                case (int)DicEnum.QUERY_CATE.TERRITORY:
                    addBtn = "新增客户地域";
                    break;
                case (int)DicEnum.QUERY_CATE.ACCOUNTREGION:
                    addBtn = "新增区域";
                    break;
                case (int)DicEnum.QUERY_CATE.COMPETITOR:
                    addBtn = "新增竞争对手";
                    break;
                case (int)DicEnum.QUERY_CATE.ACCOUNTTYPE:
                    addBtn = "新增客户类别";
                    break;
                case (int)DicEnum.QUERY_CATE.SUFFIXES:
                    addBtn = "新增姓名后缀";
                    break;
                case (int)DicEnum.QUERY_CATE.ACTIONTYPE:
                    addBtn = "新增活动类型";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPORTUNITYAGES:
                    addBtn = "新增商机阶段";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPORTUNITYSOURCE:
                    addBtn = "新增商机来源";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPPORTUNITYWINREASON:
                    addBtn = "新增关闭商机原因";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPPORTUNITYLOSSREASON:
                    addBtn = "新增丢失商机原因";
                    break;
                case (int)DicEnum.QUERY_CATE.CONFIGSUBSCRIPTION:
                    addBtn = "新增订阅";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_BLOCK:
                    addBtn = "新增预付费用";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_BLOCK_TIME:
                    addBtn = "新增预付时间";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_BLOCK_TICKET:
                    addBtn = "新增事件";
                    break;
                case (int)DicEnum.QUERY_CATE.INVOICE_HISTORY:
                    addBtn = "历史发票";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_MILESTONES:
                    addBtn = "新增合同里程碑";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_TYPE:
                    addBtn = "新增合同类别";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_RATE:
                    addBtn = "新增费率";
                    break;
                case (int)DicEnum.QUERY_CATE.CRM_NOTE_SEARCH:
                    addBtn = "新增备注";
                    break;
                case (int)DicEnum.QUERY_CATE.TODOS:
                    addBtn = "新增待办";
                    break;
                case (int)DicEnum.QUERY_CATE.INVENTORY_LOCATION:
                    addBtn = "新增仓库";
                    break;
                case (int)DicEnum.QUERY_CATE.INVENTORY_ITEM:
                    addBtn = "新增库存产品";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_TEAM:
                    addBtn = "新增项目团队";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_COST_EXPENSE:
                    addBtn = "新增成本或者费用";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_NOTE:
                    addBtn = "新增备注";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_CALENDAR:
                    addBtn = "新增日历条目";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_ATTACH:
                    addBtn = "新增";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_UDF:
                    addBtn = "项目自定义";
                    break;
                case (int)DicEnum.QUERY_CATE.PURCHASING_FULFILLMENT:
                    addBtn = "创建采购订单";
                    break;
                case (int)DicEnum.QUERY_CATE.PURCHASE_ORDER:
                case (int)DicEnum.QUERY_CATE.PURCHASE_ITEM:
                case (int)DicEnum.QUERY_CATE.HOLIDAY_SET:
                case (int)DicEnum.QUERY_CATE.HOLIDAYS:
                    addBtn = "新增";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_NOTIFY_RULE:
                    addBtn = "新增通知规则";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_TEMP_SEARCH:
                    addBtn = "新增项目模板";
                    break;
                case (int)DicEnum.QUERY_CATE.PURCHASE_RECEIVE:
                    addBtn = "接收";
                    break;
                case (int)DicEnum.QUERY_CATE.PROJECT_SEARCH:
                    addBtn = "添加项目";
                    break;
                case (int)DicEnum.QUERY_CATE.EXPENSE_REPORT:
                    addBtn = "添加费用报表";
                    break;
                case (int)DicEnum.QUERY_CATE.WORKFLOW_RULE:
                case (int)DicEnum.QUERY_CATE.TIMEOFF_POLICY:
                case (int)DicEnum.QUERY_CATE.RESOURCE_TIME_SHEET:
                case (int)DicEnum.QUERY_CATE.RESOURCE_EXPENSE_REPORT:
                case (int)DicEnum.QUERY_CATE.RESOURCE_DEPARTMENT:
                case (int)DicEnum.QUERY_CATE.RESOURCE_SERVICE_DESK_QUEUES:
                case (int)DicEnum.QUERY_CATE.RESOURCE_SKILL:
                case (int)DicEnum.QUERY_CATE.RESOURCE_CERTIFICATE:
                case (int)DicEnum.QUERY_CATE.RESOURCE_DEGREE:
                case (int)DicEnum.QUERY_CATE.RESOURCE_ATTACHMENT:
                case (int)DicEnum.QUERY_CATE.CONTACR_GROUP_SEARCH:
                case (int)DicEnum.QUERY_CATE.CONTACT_ACTION_TEMP:
                case (int)DicEnum.QUERY_CATE.INVOICE_EMAIL_TEMPLATE:
                case (int)DicEnum.QUERY_CATE.QUOTE_EMAIL_TEMPLATE:
                    addBtn = "新增";
                    break;
                case (int)DicEnum.QUERY_CATE.KNOWLEDGEBASE_ARTICLE:
                    addBtn = "新增文章";
                    break;
                case (int)DicEnum.QUERY_CATE.TIMEOFF_MY_CURRENT:
                    addBtn = "新增常规工时";
                    break;
                case (int)DicEnum.QUERY_CATE.TIMEOFF_REQUEST_WAIT_APPROVE:
                    addBtn = "批准";
                    break;
                case (int)DicEnum.QUERY_CATE.TIMEOFF_MY_REQUEST:
                    addBtn = "新增休假请求";
                    break;
                case (int)DicEnum.QUERY_CATE.ACCOUNT_CONTACT_GROUP_SEARCH:
                    addBtn = "添加联系人到群组";
                    break;
                case (int)DicEnum.QUERY_CATE.DATA_IMPORT_LOG:
                    addBtn = "添加导入";
                    break;
                default:
                    addBtn = "";
                    break;
            }

            // 判断权限
            if (!string.IsNullOrEmpty(addBtn))
            {
                if (!CheckAddAuth((QueryType)queryTypeId))  // 没有权限，不显示新增按钮
                    addBtn = "";
            }
        }

        /// <summary>
        /// 根据查询条件获取查询结果
        /// </summary>
        private void QueryData()
        {
            queryParaValue.Clear();
            resultPara = bll.GetResultParaSelect(GetLoginUserId(), paraGroupId);    // 获取查询结果列信息

            //var keys = Request.Form;
            var keys = HttpContext.Current.Request.QueryString;
            string order = keys["order"];   // order by 条件
            int page;
            if (!int.TryParse(keys["page_num"], out page))
                page = 1;
            //int page = string.IsNullOrEmpty(keys["page_num"]) ? 1 : int.Parse(keys["page_num"]);  // 查询页数
            int pageSize = string.IsNullOrEmpty(keys["page_size"]) ? 0 : int.Parse(keys["page_size"]);  // 查询每页个数

            // 检查order
            if (order != null)
            {
                order = order.Trim();
                string[] strs = order.Split(' ');
                if (strs.Length != 2 || (!strs[1].ToLower().Equals("asc") && !strs[1].ToLower().Equals("desc")))
                    order = "";
            }
            if (string.IsNullOrEmpty(order))
                order = null;

            if (!string.IsNullOrEmpty(keys["search_id"]))   // 使用缓存查询条件
            {
                queryResult = bll.GetResult(GetLoginUserId(), keys["search_id"], page, order);
                return;
            }

            if (objId != 0)    // 查询条件只有实体id，可以默认带入id查找
            {
                var cdts = bll.GetConditionParaVisiable(GetLoginUserId(), paraGroupId);
                if (cdts.Count == 1)
                {
                    QueryParaDto queryPara = new QueryParaDto();

                    queryPara.query_params = new List<Para>();
                    Para pa = new Para();
                    pa.id = cdts[0].id;
                    pa.value = objId.ToString();
                    queryPara.query_params.Add(pa);

                    #region 查询合同服务，特殊处理，添加时间条件
                    if (catId == (int)DicEnum.QUERY_CATE.CONTRACT_SERVICE)
                    {
                        var cdas = bll.GetConditionParaAll(GetLoginUserId(), paraGroupId);
                        if (cdas.Count == 2)
                        {
                            var cd = cdas[0];
                            if (cdas[0].id == cdts[0].id)
                                cd = cdas[1];
                            pa = new Para();
                            pa.id = cd.id;
                            pa.value = Request.QueryString["serviceTime"];
                            if (string.IsNullOrEmpty(pa.value))
                                pa.value = DateTime.Now.ToString("yyyy-MM-dd");
                            queryPara.query_params.Add(pa);
                            if (!DateTime.TryParse(pa.value, out searchTime))
                                searchTime = DateTime.Now;
                        }
                    }
                    #endregion

                    queryPara.query_type_id = queryTypeId;
                    queryPara.para_group_id = paraGroupId;
                    queryPara.page = page;
                    queryPara.order_by = order;
                    queryPara.page_size = pageSize;

                    queryResult = bll.GetResult(GetLoginUserId(), queryPara);
                    return;
                }
            }

            if (queryResult == null)  // 不使用缓存或缓存过期
            {
                var para = bll.GetConditionParaAll(GetLoginUserId(), paraGroupId);   // 查询条件信息
                QueryParaDto queryPara = new QueryParaDto();
                queryPara.query_params = new List<Para>();
                foreach (var p in para)
                {
                    Para pa = new Para();
                    if (p.data_type == (int)DicEnum.QUERY_PARA_TYPE.NUMBER
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATE
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATETIME
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.TIMESPAN)    // 数值和日期类型是范围值
                    {
                        string ql = keys["con" + p.id.ToString() + "_l"];
                        string qh = keys["con" + p.id.ToString() + "_h"];
                        if (string.IsNullOrEmpty(ql) && string.IsNullOrEmpty(qh))   // 空值，跳过
                            continue;
                        if (!string.IsNullOrEmpty(ql))
                        {
                            queryParaValue.Add(new DictionaryEntryDto("con" + p.id.ToString() + "_l", ql));     // 记录查询条件和条件值
                            pa.value = ql;
                        }
                        if (!string.IsNullOrEmpty(qh))
                        {
                            queryParaValue.Add(new DictionaryEntryDto("con" + p.id.ToString() + "_h", qh));     // 记录查询条件和条件值
                            pa.value2 = qh;
                        }
                        pa.id = p.id;

                        queryPara.query_params.Add(pa);
                    }
                    else    // 其他类型一个值
                    {
                        string val = keys["con" + p.id.ToString()];
                        if (string.IsNullOrEmpty(val))
                            continue;
                        pa.id = p.id;
                        pa.value = val;
                        queryParaValue.Add(new DictionaryEntryDto("con" + p.id.ToString(), val));     // 记录查询条件和条件值

                        queryPara.query_params.Add(pa);
                    }
                }
                #region 部分特殊处理添加的参数
                if (queryTypeId == (int)QueryType.EXPENSE_REPORT)
                    queryPara.query_params.Add(new Para() { id = 1236, value = LoginUserId.ToString() });
                else if (queryTypeId == (int)QueryType.MY_QUEUE_ACTIVE)
                {
                    if (!string.IsNullOrEmpty(param1) && !string.IsNullOrEmpty(param2))
                        queryPara.query_params.Add(new Para() { id = long.Parse(param1), value = param2 });
                    if (paraGroupId == 215)
                    {
                        if (string.IsNullOrEmpty(keys["con3962"]))
                            queryPara.query_params.Add(new Para() { id = 2626, value = LoginUserId.ToString() });
                    }
                    else if (paraGroupId == 230)
                        queryPara.query_params.Add(new Para() { id = 2730, value = LoginUserId.ToString() });
                    var param3 = string.IsNullOrEmpty(Request.QueryString["param3"]) ? "" : Request.QueryString["param3"];
                    var param4 = string.IsNullOrEmpty(Request.QueryString["param4"]) ? "" : Request.QueryString["param4"];
                    if (!string.IsNullOrEmpty(param3) && !string.IsNullOrEmpty(param4))
                        queryPara.query_params.Add(new Para() { id = long.Parse(param3), value = param4 });
                }
                else if (queryTypeId == (int)QueryType.MY_QUEUE_MY_TICKET)
                    queryPara.query_params.Add(new Para() { id = 2658, value = LoginUserId.ToString() });
                else if (queryTypeId == (int)QueryType.MY_QUEUE_CHANGE_APPROVEL)
                    queryPara.query_params.Add(new Para() { id = 2662, value = LoginUserId.ToString() });
                else if (queryTypeId == (int)QueryType.PROJECT_SEARCH || queryTypeId == (int)QueryType.InstalledProductView || queryTypeId == (int)QueryType.KnowledgebaseArticle || queryTypeId == (int)QueryType.Invoice_History)
                {
                    if (!string.IsNullOrEmpty(param1) && !string.IsNullOrEmpty(param2))
                        queryPara.query_params.Add(new Para() { id = long.Parse(param1), value = param2 });
                }
                else if (queryTypeId == (int)QueryType.Contact || queryTypeId == (int)QueryType.Opportunity || queryTypeId == (int)QueryType.SaleOrder || queryTypeId == (int)QueryType.Quote || queryTypeId == (int)QueryType.CRMNote || queryTypeId == (int)QueryType.Todos || queryTypeId == (int)QueryType.Company)
                {
                    var id = keys["conparam1"];
                    string val = keys["conparam2"];
                    if (!string.IsNullOrEmpty(val) && !string.IsNullOrEmpty(id))
                        queryPara.query_params.Add(new Para() { id = long.Parse(id), value = val });

                }
                if (queryTypeId == (int)QueryType.Todos || queryTypeId == (int)QueryType.Company)
                {
                    if (!string.IsNullOrEmpty(param1) && !string.IsNullOrEmpty(param2) && new System.Text.RegularExpressions.Regex(@"^[0-9]*$").IsMatch(param1))
                        queryPara.query_params.Add(new Para() { id = long.Parse(param1), value = param2 });
                    var param3 = string.IsNullOrEmpty(Request.QueryString["param3"]) ? "" : Request.QueryString["param3"];
                    var param4 = string.IsNullOrEmpty(Request.QueryString["param4"]) ? "" : Request.QueryString["param4"];
                    if (!string.IsNullOrEmpty(param3) && !string.IsNullOrEmpty(param4))
                        queryPara.query_params.Add(new Para() { id = long.Parse(param3), value = param4 });
                }
                if (queryTypeId == (int)QueryType.REPORT_CRM_MY_ACCOUNT_TICKET)
                {
                    queryPara.query_params.Add(new Para() { id = 3605, value = LoginUserId.ToString() });
                }

                #endregion

                queryPara.query_type_id = queryTypeId;
                queryPara.para_group_id = paraGroupId;
                queryPara.page = page;
                queryPara.order_by = order;
                queryPara.page_size = pageSize;

                queryResult = bll.GetResult(GetLoginUserId(), queryPara);

                if (queryTypeId == (int)QueryType.PurchaseItem)
                {
                    var items = Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;
                    if (items != null && items.items.Count > 0)
                    {
                        queryResult.page_count += items.items.Count;
                        queryResult.count += items.items.Count;
                        queryResult.page_size = queryResult.page_size == 0 ? 20 : queryResult.page_size;
                        queryResult.page = queryResult.page == 0 ? 1 : queryResult.page;
                        foreach (var item in items.items)
                        {
                            Dictionary<string, object> oi = new Dictionary<string, object>();
                            foreach (var rsltClmn in resultPara)
                            {
                                if (rsltClmn.name == "采购项id")
                                    oi.Add("采购项id", item.id);
                                else if (rsltClmn.name == "产品名称")
                                    oi.Add("产品名称", item.product);
                                else if (rsltClmn.name == "仓库")
                                    oi.Add("仓库", item.locationName);
                                else if (rsltClmn.name == "成本")
                                    oi.Add("成本", item.unit_cost);
                                else if (rsltClmn.name == "采购数量")
                                    oi.Add("采购数量", item.quantity);
                                else if (rsltClmn.name == "销售订单（客户）")
                                    oi.Add("销售订单（客户）", item.accountName);
                                else if (rsltClmn.name == "工单或项目或合同")
                                    oi.Add("工单或项目或合同", item.contractName);
                                else if (rsltClmn.name == "库存数")
                                    oi.Add("库存数", item.ivtQuantity);
                                else if (rsltClmn.name == "最大数")
                                    oi.Add("最大数", item.max);
                                else if (rsltClmn.name == "最小数")
                                    oi.Add("最小数", item.min);
                                else if (rsltClmn.name == "采购中")
                                    oi.Add("采购中", item.onOrder);
                                else if (rsltClmn.name == "尚未接收")
                                    oi.Add("尚未接收", item.back_order);
                                else if (rsltClmn.name == "预留和拣货")
                                    oi.Add("预留和拣货", item.reserved_picked);
                                else if (rsltClmn.name == "可用数")
                                    oi.Add("可用数", item.avaCnt);
                                else if (rsltClmn.name == "自动添加")
                                    oi.Add("自动添加", item.was_auto_filled == 1 ? "√" : "");
                                else
                                    oi.Add(rsltClmn.name, "");
                            }
                            if (queryResult.result == null)
                                queryResult.result = new List<Dictionary<string, object>>();
                            queryResult.result.Add(oi);
                        }
                    }
                    decimal totalSale = 0;
                    if (queryResult.count > 0 && resultPara.Exists(_ => _.name == "成本") && resultPara.Exists(_ => _.name == "库存数"))
                    {
                        foreach (var item in queryResult.result)
                        {
                            if (string.IsNullOrEmpty(item["采购数量"].ToString()) || string.IsNullOrEmpty(item["成本"].ToString()))
                                continue;
                            int quantity = int.Parse(item["采购数量"].ToString());
                            decimal cost = decimal.Parse(item["成本"].ToString());
                            totalSale += (quantity * cost);
                        }
                    }
                    param1 = totalSale.ToString();
                }

                if (queryTypeId == (int)QueryType.TimeoffPolicyResource)    // 休假策略关联员工
                {
                    if (Request.QueryString["con2467"] == "0")
                    {
                        var items = Session["TimeoffAssRes"] as TimeoffAssociateResourceDto;
                        if (items != null && items.items.Count > 0)
                        {
                            queryResult.page_count += items.items.Count;
                            queryResult.count += items.items.Count;
                            queryResult.page_size = queryResult.page_size == 0 ? 20 : queryResult.page_size;
                            queryResult.page = queryResult.page == 0 ? 1 : queryResult.page;
                            foreach (var item in items.items)
                            {
                                Dictionary<string, object> oi = new Dictionary<string, object>();
                                foreach (var rsltClmn in resultPara)
                                {
                                    if (rsltClmn.name == "id")
                                        oi.Add("id", item.id);
                                    else if (rsltClmn.name == "员工")
                                        oi.Add("员工", item.resourceName);
                                    else if (rsltClmn.name == "生效开始日期")
                                        oi.Add("生效开始日期", item.effBeginDate.ToString("yyyy-MM-dd"));
                                    else if (rsltClmn.name == "生效结束日期")
                                        oi.Add("生效结束日期", "");
                                    else
                                        oi.Add(rsltClmn.name, "");
                                }
                                if (queryResult.result == null)
                                    queryResult.result = new List<Dictionary<string, object>>();
                                queryResult.result.Add(oi);
                            }
                        }
                    }
                }

                if (queryTypeId == (int)QueryType.TimeoffPolicyTier)
                {
                    if (Request.QueryString["cateType"] == "1")
                    {
                        var perPeriodPara = resultPara.Find(_ => _.name == "每周期假期时间（小时）");
                        if (perPeriodPara != null)
                            resultPara.Remove(perPeriodPara);
                    }
                    if (Request.QueryString["con2468"] == "0")
                    {
                        var items = Session["TimeoffPolicyTier"] as TimeoffPolicyTierListDto;
                        string itemCate = Request.QueryString["cate"];
                        int cat;
                        if (items != null && items.items.Count > 0 && int.TryParse(itemCate, out cat))
                        {
                            var cateItems = from itm in items.items where itm.cate == cat select itm;
                            if (cateItems.Count() > 0)
                            {
                                queryResult.page_count += items.items.Count;
                                queryResult.count += items.items.Count;
                                queryResult.page_size = queryResult.page_size == 0 ? 20 : queryResult.page_size;
                                queryResult.page = queryResult.page == 0 ? 1 : queryResult.page;
                                foreach (var item in cateItems)
                                {
                                    Dictionary<string, object> oi = new Dictionary<string, object>();
                                    foreach (var rsltClmn in resultPara)
                                    {
                                        if (rsltClmn.name == "id")
                                            oi.Add("id", item.id);
                                        else if (rsltClmn.name == "工作年限（月）")
                                            oi.Add("工作年限（月）", item.eligibleMonths);
                                        else if (rsltClmn.name == "每年假期时间（小时）")
                                            oi.Add("每年假期时间（小时）", item.annualHours);
                                        else if (rsltClmn.name == "滚存限额或累计增长限额")
                                            oi.Add("滚存限额或累计增长限额", item.capHours);
                                        else if (rsltClmn.name == "每周期假期时间（小时）")
                                            oi.Add("每周期假期时间（小时）", item.hoursPerPeriod);
                                        else
                                            oi.Add(rsltClmn.name, "");
                                    }
                                    if (queryResult.result == null)
                                        queryResult.result = new List<Dictionary<string, object>>();
                                    queryResult.result.Add(oi);
                                }
                            }
                        }
                    }
                }

                if (queryTypeId == (int)QueryType.ResourceDegree
                    || queryTypeId == (int)QueryType.ResourceCertificate
                    || queryTypeId == (int)QueryType.ResourceAttachment
                    || queryTypeId == (int)QueryType.ResourceDepartment
                    || queryTypeId == (int)QueryType.ResourceExpense
                    || queryTypeId == (int)QueryType.ResourceServiceDeskQueue
                    || queryTypeId == (int)QueryType.ResourceSkill
                    || queryTypeId == (int)QueryType.ResourceTimeSheet)
                {
                    resultPara.Add(new QueryResultParaDto
                    {
                        id = 0,
                        length = 4,
                        name = "操作",
                        type = (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TXT,
                        visible = 1
                    });
                }
            }
        }

        /// <summary>
        /// 根据查询页面类型获取右键菜单
        /// </summary>
        private void GetMenus()
        {
            contextMenu = new List<PageContextMenuDto>();
            Dictionary<string, object> dics = null;
            switch (queryTypeId)
            {
                case (long)QueryType.Company:
                    dics = new CompanyBLL().GetField();
                    contextMenu.Add(new PageContextMenuDto { text = "修改客户", click_function = "EditCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "AddNote()" });

                    PageContextMenuDto classcate = new PageContextMenuDto { text = "设置类别", click_function = "" };
                    // 设置公司类别子菜单
                    var classification = dics["classification"] as List<DictionaryEntryDto>;
                    if (classification != null)
                    {
                        List<PageContextMenuDto> classsub = new List<PageContextMenuDto>();
                        foreach (var c in classification)
                        {
                            classsub.Add(new PageContextMenuDto { text = c.show, click_function = $"openopenopen({c.val})\" \" style='color:grey;'" });
                        }
                        classcate.submenu = classsub;
                    }
                    contextMenu.Add(classcate);

                    contextMenu.Add(new PageContextMenuDto { text = "关闭商机向导", click_function = "CloseOpportunity()" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失商机向导", click_function = "LoseOpportunity()" });
                    contextMenu.Add(new PageContextMenuDto { text = "重新指定客户经理向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "注销客户向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除客户", click_function = "DeleteCompany()" });
                    break;
                case (long)QueryType.WidgetDrillCompany:
                    contextMenu.Add(new PageContextMenuDto { text = "修改客户", click_function = "EditCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "关闭商机向导", click_function = "CloseOpportunity()" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失商机向导", click_function = "LoseOpportunity()" });
                    contextMenu.Add(new PageContextMenuDto { text = "重新指定客户经理向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "注销客户向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除客户", click_function = "DeleteCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "AddNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增工单", click_function = "AddTicket()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.Contact:
                case (long)QueryType.ContactCompanyView:
                    contextMenu.Add(new PageContextMenuDto { text = "修改联系人", click_function = "EditContact()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看联系人", click_function = "ViewContact()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "AddNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除联系人", click_function = "DeleteContact()" });
                    break;
                case (long)QueryType.Opportunity:
                case (long)QueryType.OpportunityCompanyView:
                case (long)QueryType.OpportunityContactView:
                case (long)QueryType.WidgetDrillOpportunity:
                    contextMenu.Add(new PageContextMenuDto { text = "修改商机", click_function = "EditOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看商机", click_function = "ViewOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增报价", click_function = "AddQuote()",id="AddQuoteMenu" });
                   
                    contextMenu.Add(new PageContextMenuDto { text = "关闭商机", click_function = "CloseOppo()" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失商机", click_function = "LostOppo()" });
                    contextMenu.Add(new PageContextMenuDto { text = "重新指定商机负责人", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除商机", click_function = "DeleteOpp()" });
                   
                    break;
                case (long)QueryType.Quote:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑报价", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "报价参数设定", click_function = "QuotePref()" });
                    contextMenu.Add(new PageContextMenuDto { text = "报价项管理", click_function = "QuoteManage()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看商机", click_function = "ViewOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看报价", click_function = "ViewQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制报价", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "关闭报价", click_function = "CloseQuote()", id = "CloQuoteMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失报价", click_function = "LossQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除报价", click_function = "DeleteQuote()" });
                    break;
                case (long)QueryType.QuoteTemplate:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设为默认", click_function = "Default()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "NoActive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    break;
                case (long)QueryType.InvoiceTemplate:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设为默认", click_function = "Default()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "NoActive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    break;
                case (long)QueryType.InstalledProductView:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "替换", click_function = "Swap()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新建工单", click_function = "NewTicket()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活当前记录", click_function = "ActiveIProduct()", id = "ActiveThis" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活选中记录", click_function = "ActiveIProducts()", id = "ActiveChoose" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用当前记录", click_function = "NoActiveIProduct()", id = "NoActiveThis" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用选中记录", click_function = "NoActiveIProducts()", id = "NoActiveChoose" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前记录经过合同审核", click_function = "ReViewByContract()", id = "ReViewByContractMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前记录不经过合同审核", click_function = "NoReViewByContract()", id = "NoReViewByContractMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "选中记录经过合同审核", click_function = "ReViewByContractSelect()", id = "ReViewByContractSelectMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "选中记录不经过合同审核", click_function = "NoReViewByContractSelect()", id = "NoReViewByContractSelectMenu" });

                    contextMenu.Add(new PageContextMenuDto { text = "删除当前配置项", click_function = "DeleteIProduct()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除选中配置项", click_function = "DeleteIProducts()" });
                    break;
                case (long)QueryType.WidgetDrillConfiguration:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑配置项", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活配置项", click_function = "Active()", id = "ActiveThis" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用配置项", click_function = "Inactive()", id = "NoActiveThis" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除配置项", click_function = "DeleteIProduct()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制配置项", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增工单", click_function = "AddTicket()" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前记录经过合同审核", click_function = "ReViewByContract()", id = "ReViewByContractMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前记录不经过合同审核", click_function = "NoReViewByContract()", id = "NoReViewByContractMenu" });
                    break;
                case (long)QueryType.Subscription:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "创建订阅副本", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "创建选中订阅副本", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消订阅", click_function = "", id = "CancelSubscription" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消选中订阅", click_function = "", id = "CancelSubscriptions" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活订阅", click_function = "", id = "ActiveSubscription" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用订阅", click_function = "", id = "NoActiveSubscription" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当前订阅", click_function = "DeleteSubscription()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除选中订阅", id = "DeleteSubscriptions" });
                    break;
                case (long)QueryType.SaleOrder:
                    contextMenu.Add(new PageContextMenuDto { text = "修改销售订单", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "NewNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增待办", click_function = "NewTodo()" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消销售订单", click_function = "CancelSaleOrder()" });
                    break;
                case (long)QueryType.CRMNote:
                    contextMenu.Add(new PageContextMenuDto { text = "修改备注", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转为待办", click_function = "SetScheduled()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除备注", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.Todos:
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.Contract:
                case (long)QueryType.WidgetDrillContract:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑合同", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看合同", click_function = "ViewContract()" });
                    contextMenu.Add(new PageContextMenuDto { text = "在新窗口中查看合同", click_function = "ViewNewWindow()" });
                    contextMenu.Add(new PageContextMenuDto { text = "续约", click_function = "RenewContract()", id = "RenewContract" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制合同", click_function = "CopyContract()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除合同", click_function = "DeleteContract()" });
                    break;
                case (long)QueryType.ProuductInventory:
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "移库", click_function = "Transfer()" });
                    contextMenu.Add(new PageContextMenuDto { text = "订购", click_function = "Order()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除库存", click_function = "Delete()" });
                    break;
                case (long)QueryType.Role:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "Inactive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "从全部激活的合同中排除", click_function = "Exclude()" });
                    break;
                case (long)QueryType.Department:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.Resource:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    //contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "查找相似员工", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "发邮件给当前员工", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "发邮件给选中员工", click_function = "openopenopen()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.Prouduct:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.CONFIGITEM:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "Inactive()" });
                    break;
                case (long)QueryType.InternalCost:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.Relation_ConfigItem:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "替换", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "解除与当前合同关系", click_function = "Norelation()" });
                    contextMenu.Add(new PageContextMenuDto { text = "LiveLinks", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当前配置项", click_function = "Delete()" });
                    break;
                case (long)QueryType.Norelation_ConfigItem:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "openopenopen()\" \" style='color:grey;'" });

                    contextMenu.Add(new PageContextMenuDto { text = "关联当前合同关系", click_function = "Relation()" });
                    contextMenu.Add(new PageContextMenuDto { text = "Set As Reviewed", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "Set As Not Reviewed", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当前配置项", click_function = "Delete()" });
                    break;
                case (long)QueryType.SECURITYLEVEL:
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "Inactive()" });
                    break;
                case (long)QueryType.MILESTONE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "Inactive()" });
                    break;
                case (long)QueryType.APPROVE_MILESTONES:
                    contextMenu.Add(new PageContextMenuDto { text = "审批并提交", click_function = "Post()" });
                    contextMenu.Add(new PageContextMenuDto { text = "里程碑详情", click_function = "Miledetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ContractDetail()" });
                    break;
                case (long)QueryType.Contract_Charge:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看", click_function = "ViewCharge()" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前成本设置为可计费", click_function = "Post()", id = "thisBilled" });
                    contextMenu.Add(new PageContextMenuDto { text = "选中成本设置为可计费", click_function = "Post()", id = "ChooseBilled" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前成本设置为不可计费", click_function = "Post()", id = "thisNoBilled" });
                    contextMenu.Add(new PageContextMenuDto { text = "选中成本设置为不可计费", click_function = "Post()", id = "ChooseNoBilled" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当前成本", click_function = "Post()", id = "delete" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除选中成本", click_function = "Post()", id = "ChooseDelete" });
                    break;
                case (long)QueryType.CONTRACT_DEFAULT_COST:
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.APPROVE_SUBSCRIPTIONS:
                    contextMenu.Add(new PageContextMenuDto { text = "审批并提交", click_function = "Post()" });
                    contextMenu.Add(new PageContextMenuDto { text = "调整总价", click_function = "AdjustExtend()" });
                    contextMenu.Add(new PageContextMenuDto { text = "恢复初始值", click_function = "Restore_Initiall()" });
                    break;
                case (long)QueryType.APPROVE_RECURRING_SERVICES:
                    contextMenu.Add(new PageContextMenuDto { text = "审批并提交", click_function = "Post()" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ContractDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "调整总价", click_function = "AdjustExtend()" });
                    contextMenu.Add(new PageContextMenuDto { text = "恢复初始值", click_function = "Restore_Initiall()" });
                    break;
                case (long)QueryType.APPROVE_CHARGES:
                    contextMenu.Add(new PageContextMenuDto { text = "审批并提交", click_function = "Post()" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ContractDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "工单详情", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "项目详情", click_function = "ProjectDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "调整总价", click_function = "AdjustExtend()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置为可计费", click_function = "Billing()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置为不可计费", click_function = "NoBilling()" });
                    contextMenu.Add(new PageContextMenuDto { text = "恢复初始值", click_function = "Restore_Initiall()" });
                    break;
                case (long)QueryType.CONTRACT_RATE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.Invoice_History:
                    contextMenu.Add(new PageContextMenuDto { text = "修改发票", click_function = "EditInvoice()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看发票", click_function = "InvoiceView()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看本批发票", click_function = "InvoiceAllView()" });
                    contextMenu.Add(new PageContextMenuDto { text = "输出本批发票到XML文件", click_function = "openopenopen()\" \" style='color:grey;'" });
                    //contextMenu.Add(new PageContextMenuDto { text = "清除web service日期数据", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "作废发票", click_function = "VoidInvoice()" });
                    contextMenu.Add(new PageContextMenuDto { text = "作废本批次全部发票", click_function = "VoidBatchInvoice()" });
                    contextMenu.Add(new PageContextMenuDto { text = "作废发票并取消审批", click_function = "VoidInvoiceAndUnPost()" });
                    contextMenu.Add(new PageContextMenuDto { text = "发票设置", click_function = "InvoiceEdit()" });
                    break;
                case (long)QueryType.ACCOUNTTYPE:
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "NoActive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;

                case (long)QueryType.ContractType:
                case (long)QueryType.OPPORTUNITYAGES:
                case (long)QueryType.OPPORTUNITYSOURCE:
                case (long)QueryType.OPPPORTUNITYLOSSREASON:
                case (long)QueryType.OPPPORTUNITYWINREASON:
                case (long)QueryType.ACTIONTYPE:
                case (long)QueryType.SUFFIXES:
                case (long)QueryType.ACCOUNTREGION:
                case (long)QueryType.Market:
                case (long)QueryType.COMPETITOR:
                case (long)QueryType.Territory:
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.CONFIGSUBSCRIPTION:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "更新", click_function = "Update()" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消", click_function = "Cancel()" });
                    contextMenu.Add(new PageContextMenuDto { text = "失效", click_function = "Invalid()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.ContractUDF:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    break;
                case (long)QueryType.ContractBlock:
                case (long)QueryType.ContractBlockTime:
                case (long)QueryType.ContractBlockTicket:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "SetInactive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "SetActive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.ContractRate:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.ContractMilestone:
                case (long)QueryType.WidgetDrillMilestones:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.ContractService:
                    contextMenu.Add(new PageContextMenuDto { text = "调整服务/服务包", click_function = "AdjustService()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑发票描述", click_function = "EditDescription()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.CompanyViewContract:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑合同", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看合同", click_function = "ViewContract()" });
                    contextMenu.Add(new PageContextMenuDto { text = "续约", click_function = "RenewContract()", id = "RenewContract" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制合同", click_function = "CopyContract()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除合同", click_function = "DeleteContract()" });
                    break;
                case (long)QueryType.CompanyViewInvoice:
                    contextMenu.Add(new PageContextMenuDto { text = "查看发票", click_function = "InvoiceView()" });
                    contextMenu.Add(new PageContextMenuDto { text = "作废发票", click_function = "VoidInvoice()" });
                    contextMenu.Add(new PageContextMenuDto { text = "作废发票并取消审批", click_function = "VoidInvoiceAndUnPost()" });
                    contextMenu.Add(new PageContextMenuDto { text = "发票设置", click_function = "InvoiceEdit()" });
                    break;
                case (long)QueryType.CompanyViewAttachment:
                    param1 = ((int)DicEnum.ATTACHMENT_OBJECT_TYPE.COMPANY).ToString();
                    param2 = Request.QueryString["con674"];
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.OpportunityViewAttachment:
                    param1 = ((int)DicEnum.ATTACHMENT_OBJECT_TYPE.OPPORTUNITY).ToString();
                    param2 = Request.QueryString["con976"];
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.SalesOrderViewAttachment:
                    param1 = ((int)DicEnum.ATTACHMENT_OBJECT_TYPE.SALES_ORDER).ToString();
                    param2 = Request.QueryString["con977"];
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.InventoryLocation:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑库存仓库", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活库存仓库", click_function = "", id = "activeBtn" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用库存仓库", click_function = "", id = "inactiveBtn" });
                    contextMenu.Add(new PageContextMenuDto { text = "设为默认", click_function = "", id = "defaultBtn" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "", id = "deleteBtn" });
                    break;
                case (long)QueryType.InventoryItem:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑库存产品", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "库存转移", click_function = "Transfer()" });
                    contextMenu.Add(new PageContextMenuDto { text = "创建采购订单", click_function = "Order()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除库存产品", click_function = "Delete()" });
                    break;
                case (long)QueryType.PROJECT_TEAM:
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()", id = "EditTeamMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "移除", click_function = "DeleteRes()", id = "DeleteResMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "找相似", click_function = "FindSmilar()", id = "SmilarMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "移除", click_function = "DeleteCon()", id = "DeleteConMenu" });
                    break;
                case (long)QueryType.PROJECT_COST_EXPENSE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()", id = "EditMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看", click_function = "ShowDetailes()", id = "ViewMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前成本/费用设置为可计费", id = "SingBillMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "选中成本/费用设置为可计费", id = "ChooseBillMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "当前成本/费用设置为不可计费", id = "SingNonBillMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "选中成本/费用设置为不可计费", id = "ChooseNonBillMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当期成本/费用", id = "SingDeleteMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除选中成本/费用", id = "ChooseDeleteMenu" });
                    break;
                case (long)QueryType.PROJECT_NOTE:
                    contextMenu.Add(new PageContextMenuDto { text = "查看备注", click_function = "ViewNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑备注", click_function = "EditNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除备注", click_function = "DeleteNote()" });
                    break;
                case (long)QueryType.PROJECT_CALENDAR:
                    //contextMenu.Add(new PageContextMenuDto { text = "查看日历条目", click_function = "ViewCalendar()" }); 
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "EditCalendar()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.PROJECT_ATTACH:
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.PurchaseOrder:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "提交", click_function = "Submit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "接收/取消接收", click_function = "Receive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看/打印", click_function = "ViewPrint()" });
                    contextMenu.Add(new PageContextMenuDto { text = "发送邮件", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消", click_function = "Cancle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.PurchaseItem:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑采购项", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑关联成本", click_function = "EditCost()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看/添加备注", click_function = "EditNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.CONTRACT_NOTIFY_RULE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑通知规则", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除通知规则", click_function = "Delete()" });
                    break;
                case (long)QueryType.APPROVE_LABOUR:
                    contextMenu.Add(new PageContextMenuDto { text = "审批并提交", click_function = "PostSin()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑工时", click_function = "EditWorkEntry()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑工单", click_function = "EditTicket()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "工时详情", click_function = "EntryDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ContractDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "项目详情", click_function = "ProjectDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "信息变更", click_function = "ChangePrice()" });
                    contextMenu.Add(new PageContextMenuDto { text = "工单详情", click_function = "TicketDetail()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "恢复初始值", click_function = "RestoreInitiall()" });
                    break;
                case (long)QueryType.APPROVE_EXPENSE:
                    contextMenu.Add(new PageContextMenuDto { text = "审批并提交", click_function = "PostSin()" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ContractDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "项目详情", click_function = "ProjectDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "工单详情", click_function = "TicketDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置为可计费", click_function = "MakeBill()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置为不可计费", click_function = "MakeUnBill()" });
                    contextMenu.Add(new PageContextMenuDto { text = "信息变更", click_function = "ChangePrice()" });
                    contextMenu.Add(new PageContextMenuDto { text = "恢复初始值", click_function = "RestoreInitiall()" });
                    break;
                case (long)QueryType.PROJECT_TEMP_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "查看", click_function = "ViewDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.PURCHASE_ORDER_HISTORY:
                    contextMenu.Add(new PageContextMenuDto { text = "查看采购订单", click_function = "ViewDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "修改采购订单", click_function = "Edit()" });
                    break;
                case (long)QueryType.PROJECT_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "查看项目", click_function = "ViewProject()" });

                    break;
                case (long)QueryType.HolidaySet:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.Holidays:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.EXPENSE_REPORT:
                    contextMenu.Add(new PageContextMenuDto { text = "查看", click_function = "ViewReport()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "EditReport()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "CopyReport()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "DeleteReport()" });
                    break;
                case (long)QueryType.MYAPPROVE_EXPENSE_REPORT:
                    contextMenu.Add(new PageContextMenuDto { text = "查看", click_function = "ShowDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.APPROVED_REPORT:
                    contextMenu.Add(new PageContextMenuDto { text = "查看", click_function = "ShowDetail()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "标记为已支付", click_function = "PaidThis()" });
                    contextMenu.Add(new PageContextMenuDto { text = "全部标记为已支付", click_function = "PaidAll()" });
                    contextMenu.Add(new PageContextMenuDto { text = "标记为已审批", click_function = "Approval()" });
                    contextMenu.Add(new PageContextMenuDto { text = "全部标记为已审批", click_function = "ApprovalAll()" });
                    break;
                case (long)QueryType.WorkflowRule:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "SetActive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "SetInactive()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.TICKET_SEARCH:
                case (long)QueryType.TICKET_REQUEST:
                case (long)QueryType.TICKET_INCIDENT:
                case (long)QueryType.TICKET_PROBLEM:
                    var ticketView = new PageContextMenuDto { text = "查看" };
                    ticketView.submenu = new List<PageContextMenuDto>() {
                        new PageContextMenuDto(){text = "查看工单", click_function = "ViewTicket()" },
                        new PageContextMenuDto(){ text = "工单历史", click_function = "TicketHistory()"},
                        new PageContextMenuDto(){ text = "客户工单历史", click_function = "AccountTicketHistory()"},
                        new PageContextMenuDto(){text = "查看报表", click_function = "ViewTicketReport()" },
                    };
                    contextMenu.Add(ticketView);
                    var ticketAdd = new PageContextMenuDto { text = "添加" };
                    ticketAdd.submenu = new List<PageContextMenuDto>() {
                        new PageContextMenuDto(){text = "添加工时", click_function = "AddLabour()" },
                        new PageContextMenuDto(){ text = "为服务预定添加工时", click_function = "AddLabourForService()"},
                        new PageContextMenuDto(){ text = "添加备注", click_function = "AddNote()"},
                        new PageContextMenuDto(){text = "添加服务预定", click_function = "AddTicketService()" },
                    };
                    contextMenu.Add(ticketAdd);
                    var ticketManage = new PageContextMenuDto { text = "工单操作" };
                    ticketManage.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "编辑工单", click_function = "EditTicket()" },
                         new PageContextMenuDto(){text = "转发/修改", click_function = "ModifyTicket()" },
                         new PageContextMenuDto(){text = "接受", click_function = "Accept()" },
                         new PageContextMenuDto(){text = "接受并添加工时", click_function = "" },
                         new PageContextMenuDto(){text = "复制", click_function = "Copy()" },
                         new PageContextMenuDto(){text = "复制到项目", click_function = "CopyToProject()" },
                         new PageContextMenuDto(){text = "合并到另一个工单", click_function = "MergeTicket()" },
                         new PageContextMenuDto(){text = "吸收合并其他工单", click_function = "AbsorbTicket()" },
                         new PageContextMenuDto(){text = "加入到我的工作列表", click_function = "AddToMyWorkList()" },
                         new PageContextMenuDto(){text = "加入到主负责人的工作列表", click_function = "AddToPriResWorkList()" },
                         new PageContextMenuDto(){text = "加入到其他负责人的工作列表", click_function = "AddToOtherResWorkList()" },
                         new PageContextMenuDto(){text = "取消与项目管理关系", click_function = "CancelProject()" },
                         new PageContextMenuDto(){text = "删除工单", click_function = "DeleteTicket()" },
                    };
                    if (queryTypeId == (long)QueryType.TICKET_REQUEST || queryTypeId == (long)QueryType.TICKET_INCIDENT || queryTypeId == (long)QueryType.TICKET_PROBLEM)
                        ticketManage.submenu.Add(new PageContextMenuDto() { text = "解除和工单的关联", click_function = "DisRelationTicket()" });
                    contextMenu.Add(ticketManage);
                    break;
                case (long)QueryType.TICKET_ACCOUNT_LIST:

                    break;
                case (long)QueryType.SERVICE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "DeleteService()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "InActive()", id = "InActSer" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()", id = "ActSer" });
                    break;
                case (long)QueryType.SERVICE_BUNDLE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "DeleteServiceBundle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "InActive()", id = "InActSer" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()", id = "ActSer" });
                    break;
                case (long)QueryType.TICKET_COST_EXPENSE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.MY_TASK_TICKET:
                    #region 工单右键
                    contextMenu.Add(new PageContextMenuDto { text = "工时", click_function = "AddLabour()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "服务预定工时", click_function = "AddServiceLabour()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑工单", click_function = "EditTicket()", class_name = "ticket" });
                    var MyTicketView = new PageContextMenuDto { text = "查看", class_name = "ticket" };
                    MyTicketView.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "工单详情", click_function = "ViewTicket()", class_name = "ticket" },
                         new PageContextMenuDto(){text = "工单历史", click_function = "ViewTicketHistory()", class_name = "ticket" },
                         new PageContextMenuDto(){text = "客户打开工单历史", click_function = "ViewTicketOpenHistory()" , class_name = "ticket"},
                         new PageContextMenuDto(){text = "生成报表", click_function = "ToGoReport()", class_name = "ticket" },
                    };
                    contextMenu.Add(MyTicketView);
                    contextMenu.Add(new PageContextMenuDto { text = "复制工单", click_function = "CopyTicket()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制工单到项目", click_function = "CopyTicketToProject()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "合并到其他工单", click_function = "MergeToTicket()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "合并到多个工单", click_function = "AbsorbToTicket()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加服务预定", click_function = "AddServiceCall()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加工单备注", click_function = "AddTicketNote()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "修改工单", click_function = "ModifyTicket()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除工单", click_function = "DeleteTicket()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加到我的工作列表", click_function = "AddToMyWorkList()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加到主负责人的工作列表", click_function = "AddToPriResWorkList()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加到其他负责人的工作列表", click_function = "AddToOtherResWorkList()", class_name = "ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "解除关联项目", click_function = "DisProject()", class_name = "ticket" });
                    #endregion

                    #region 任务右键
                    contextMenu.Add(new PageContextMenuDto { text = "工时", click_function = "AddTaskLabour()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "服务预定工时", click_function = "AddTaskServiceLabour()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑任务", click_function = "EditTask()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加服务预定", click_function = "AddTaskServiceCall()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看任务详情", click_function = "ViewTask()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看任务备注", click_function = "ViewTaskNote()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看项目", click_function = "ViewProject()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "生成报表", click_function = "ToGoTaskReport()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加到我的工作列表", click_function = "AddToMyWorkList()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加到主负责人的工作列表", click_function = "AddToPriResWorkList()", class_name = "task" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加到其他负责人的工作列表", click_function = "AddToOtherResWorkList()", class_name = "task" });
                    #endregion
                    break;
                case (long)QueryType.TimeoffPolicy:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.TimeoffPolicyTier:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.KnowledgebaseArticle:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "DeleteServiceBundle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "详情", click_function = "View()" });
                    break;
                case (long)QueryType.TimeoffPolicyResource:
                    contextMenu.Add(new PageContextMenuDto { text = "取消关联", click_function = "Disassociate()" });
                    break;
                case (long)QueryType.MASTER_TICKET_SEARCH:
                case (long)QueryType.WidgetDrillRecurMasterTickets:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    contextMenu.Add(new PageContextMenuDto { text = "停用", click_function = "InActive()", id = "InActTic" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()", id = "ActTic" });
                    break;
                case (long)QueryType.MASTER_SUB_TICKET_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "实例详情", click_function = "ViewTicket()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑实例", click_function = "EditTicket()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当前实例", click_function = "DeletSinge()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除已选实例", click_function = "DeleteChoose()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除所有未开始实例", click_function = "DeleteInFuture()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除所有实例，", click_function = "DeleteAll()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转发/修改当前实例", click_function = "ForwardSingle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转发/修改已选实例", click_function = "Forward()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转发/修改所有未开始实例", click_function = "ForwardFuture()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转发/修改所有实例", click_function = "ForwardAll()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑服务预定", click_function = "EditService()" });
                    break;
                case (long)QueryType.SERVICE_CALL_TICKET:
                    contextMenu.Add(new PageContextMenuDto { text = "添加工时", click_function = "AddLabour()", class_name = "NeedSave ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "为服务预定添加工时", click_function = "AddServiceLabour()", class_name = "NeedSave ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加工时", click_function = "AddTaskLabour()", class_name = "NeedSave task" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加包含起止时间的工时", click_function = "AddTaskTimeLabour()", class_name = "NeedSave task" });
                    contextMenu.Add(new PageContextMenuDto { text = "根据服务预定添加工时", click_function = "AddTaskServiceLabour()", class_name = "NeedSave task" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑工单", click_function = "EditTicket()", class_name = "NeedSave ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑任务", click_function = "EditTask()", class_name = "NeedSave task" });
                    contextMenu.Add(new PageContextMenuDto { text = "管理负责人", click_function = "ManageRes()", class_name = "NeedSave" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看工单详情", click_function = "ViewTicket()", class_name = "NeedSave ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加工单备注", click_function = "AddTicketNote()", class_name = "NeedSave ticket" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看任务详情", click_function = "ViewTask()", class_name = "NeedSave task" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加任务备注", click_function = "AddTask()", class_name = "NeedSave task" });
                    contextMenu.Add(new PageContextMenuDto { text = "移除", click_function = "RemoveTicket()", class_name = "NeedSave" });
                    break;
                case (long)QueryType.SERVICE_CALL_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑服务预定", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewAccount()" });
                    contextMenu.Add(new PageContextMenuDto { text = "为调度条目添加备注", click_function = "AddItemNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转移/修改调度工单", click_function = "ModifyTicket()" });
                    contextMenu.Add(new PageContextMenuDto { text = "生成工作说明书", click_function = "GetWorkBook()" });
                    contextMenu.Add(new PageContextMenuDto { text = "完成服务预定", click_function = "DoneServiceCall()", id = "DoneMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "再次调度（复制）", click_function = "CopyCall()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除服务预定", click_function = "DeleteCall()" });
                    break;
                case (long)QueryType.TimeoffMyRequest:
                    contextMenu.Add(new PageContextMenuDto { text = "取消休假请求", click_function = "Cancle()" });
                    break;
                case (long)QueryType.TimeoffWaitApprove:
                    contextMenu.Add(new PageContextMenuDto { text = "详情", click_function = "Detail()" });
                    break;
                case (long)QueryType.TimeoffMyCurrent:
                case (long)QueryType.ResourcePolicyAssignment:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.TICKET_SERVICE_LIST:
                    #region 待办相关
                    var todoGeneral = new PageContextMenuDto { text = "常规", class_name = "ToDo" };
                    todoGeneral.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "编辑待办", click_function = "EditToDo()", class_name = "ToDo" },
                         new PageContextMenuDto(){text = "查看待办", click_function = "ViewToDo()", class_name = "ToDo" },
                         new PageContextMenuDto(){text = "完成待办", click_function = "DoneToDo()" , class_name = "ToDo"},
                    };
                    contextMenu.Add(todoGeneral);
                    var todoView = new PageContextMenuDto { text = "查看", class_name = "ToDo" };
                    todoView.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "查看客户", click_function = "ViewAccountTo()", class_name = "ToDo" },
                         new PageContextMenuDto(){text = "查看商机", click_function = "ViewOppo()", class_name = "ToDo" },
                    };
                    contextMenu.Add(todoView);
                    var todoOther = new PageContextMenuDto { text = "其他", class_name = "ToDo" };
                    todoOther.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "删除待办", click_function = "DeleteToDo()", class_name = "ToDo" },
                    };
                    contextMenu.Add(todoOther);
                    #endregion

                    #region 服务预定相关
                    var callGeneral = new PageContextMenuDto { text = "常规", class_name = "Call" };
                    callGeneral.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "编辑服务预定", click_function = "EditCall()", class_name = "Call" },
                         new PageContextMenuDto(){text = "为服务预定添加工时", click_function = "AddLabourForCall()", class_name = "Call" },
                         new PageContextMenuDto(){text = "完成服务预定", click_function = "DoneCall()" , class_name = "Call"},
                         new PageContextMenuDto(){text = "再次完成（复制）", click_function = "CopyCall()" , class_name = "Call"},
                         new PageContextMenuDto(){text = "查看客户", click_function = "ViewAccount()" , class_name = "Call"},
                         new PageContextMenuDto(){text = "从服务预定中移除工单", click_function = "RemoveTicket()" , class_name = "Call"},
                    };
                    contextMenu.Add(callGeneral);
                    var callItem = new PageContextMenuDto { text = "预定条目", class_name = "Call" };
                    callItem.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "为预定条目添加备注", click_function = "AddNoteForItem()", class_name = "Call" },
                         new PageContextMenuDto(){text = "转发/修改相关工单", click_function = "ForwardTicet()", class_name = "Call" },
                    };
                    contextMenu.Add(callItem);
                    var callOther = new PageContextMenuDto { text = "其他", class_name = "Call" };
                    callOther.submenu = new List<PageContextMenuDto>() {
                         new PageContextMenuDto(){text = "生成说明书", click_function = "GetWorkBook()", class_name = "Call" },
                         new PageContextMenuDto(){text = "删除预定", click_function = "DeleteCall()", class_name = "Call" },
                    };
                    contextMenu.Add(callOther);
                    #endregion
                    break;
                case (long)QueryType.MY_QUEUE_ACTIVE:
                case (long)QueryType.MY_QUEUE_MY_TICKET:
                case (long)QueryType.MY_QUEUE_CHANGE_APPROVEL:
                case (long)QueryType.MY_QUEUE_VIEW:
                case (long)QueryType.WidgetDrillTickets:
                    contextMenu.Add(new PageContextMenuDto { text = "添加工时", click_function = "AddLabour()", id = "btnAddLab", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "为服务预定添加工时", click_function = "AddServiceLabour()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑工单", click_function = "EditTicket()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑定期服务主工单", click_function = "EditMasterTicket()", id = "btnEditMaster", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看工单", click_function = "ViewTask()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "工单历史", click_function = "ViewTaskHistory()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "客户工单历史", click_function = "ViewAccountTaskHistory()", class_name = "",id="AccTicketHistory" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看报表", click_function = "ViewReport()", class_name = "" ,id="ReportHidden"});
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "CopyTask()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制到项目", click_function = "CopyToProject()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "合并到另一个工单", click_function = "MergeOtherTicket()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "吸收合并其他工单", click_function = "AbsorbOther()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加服务预定", click_function = "AddCall()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加备注", click_function = "AddNote()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "转发/修改", click_function = "TicketModify()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除工单", click_function = "DeleteTicket()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到我的工作列表", click_function = "AddToMyWorkList()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到主负责人的工作列表", click_function = "AddToPriResWorkList()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到其他负责人的工作列表", click_function = "AddToOtherResWorkList()", class_name = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消与项目管理关系", click_function = "RemoveProject()", class_name = "" });
                    break;
                case (long)QueryType.DISPATCH_TICKET_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑工单", click_function = "EditTicket()", id = "MenuEditTicket" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看工单", click_function = "ViewTicket()", id = "MenuViewTicket" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到新的服务预定", click_function = "AddNewCall()", id = "MenuAddNewCall" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到已存在的服务预定", click_function = "AddAlreadyCall()", id = "MenuAddAlreadyCall" });
                    break;
                case (long)QueryType.OTHER_INSTALLED_PRODUCT_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "替换", click_function = "Swap()" });
                    contextMenu.Add(new PageContextMenuDto { text = "移动", click_function = "Move()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设为父配置项", click_function = "SetAsParent()", id = "AsParent" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消父配置项设置", click_function = "RemoveParent()", id = "CancelParent" });
                    contextMenu.Add(new PageContextMenuDto { text = "设为子配置项", click_function = "SetAsChild()", id = "AsChild" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消子配置项设置", click_function = "RemoveChild()", id = "CancelChild" });
                    contextMenu.Add(new PageContextMenuDto { text = "经过合同审核", click_function = "ReViewByContract()", id = "ReViewByContractMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "不经过合同审核", click_function = "NoReViewByContract()", id = "NoReViewByContractMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.VIEW_CONTACT_GROUP_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "创建备注", click_function = "CreateNoteSingle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "创建待办", click_function = "CreateTodoSingle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "从联系人组移除", click_function = "RemoveSingle()" });
                    break;
                case (long)QueryType.ACCOUNT_CONTACT_GROUP_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "添加/移除组成员", click_function = "AddRemove()" });
                    contextMenu.Add(new PageContextMenuDto { text = "为组成员创建备注", click_function = "CreateNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "为组成员创建待办", click_function = "CreateTodo()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看组", click_function = "ViewGroup()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑组", click_function = "EditGroup()" });
                    break;
                case (long)QueryType.CONTACR_GROUP_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "查看联系人组", click_function = "ViewGroup()" });
                    contextMenu.Add(new PageContextMenuDto { text = "为组成员创建备注", click_function = "CreateNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "为组成员创建待办", click_function = "CreateTodo()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑联系人组", click_function = "EditGroup()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制联系人组", click_function = "CopyGroup()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活联系人组", click_function = "ActiveGroup()", id = "Active" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活联系人组", click_function = "InActiveGroup()", id = "InActive" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除联系人组", click_function = "DeleteGroup()" });
                    break;
                case (long)QueryType.CONTACT_ACTION_TEMP:
                    contextMenu.Add(new PageContextMenuDto { text = "查看联系人活动模板", click_function = "View()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑联系人活动模板", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除联系人活动模板", click_function = "Delete()" });
                    break;
                case (long)QueryType.Quote_Email_Tmpl:
                case (long)QueryType.Invoice_Email_Tmpl:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置默认", click_function = "Default()", id = "Default" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.SYS_FORM_TEMP_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑模板", click_function = "EditTemp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活模板", click_function = "Active()", id = "LiActive" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活模板", click_function = "InActive()", id = "LiInActive" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制模板", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除模板", click_function = "Delete()" });
                    break;
                case (long)QueryType.SYSTEM_RESOURCE_WEEK_GOAL:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑员工", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置周目标", click_function = "SetWeek()" });
                    break;
                case (long)QueryType.SYSTEM_SKILL:
                case (long)QueryType.SYSTEM_SKILL_CATE:
                case (long)QueryType.SYSTEM_CERTIFICATION:
                case (long)QueryType.SYSTEM_CERTIFICATION_CATE:
                case (long)QueryType.SYSTEM_DEGREE:
                case (long)QueryType.SYSTEM_DEGREE_CATE:
                case (long)QueryType.SYSTEM_RESOURCE_WORKGROUP_SEARCH:
                case (long)QueryType.SYSTEM_TIME_APPROVAL_SEARCH:
                case (long)QueryType.SYSTEM_EXPENSE_APPROVAL_SEARCH:
                case (long)QueryType.SYSTEM_TASK_LIBRARY:
                case (long)QueryType.SYSTEM_TASK_LIBRARY_CATE:
                case (long)QueryType.SYSTEM_CODE_MATERIAL:
                case (long)QueryType.SYSTEM_CODE_INTER_TIME:
                case (long)QueryType.SYSTEM_CODE_ECPENSE_CATE:
                case (long)QueryType.SYSTEM_CODE_SERVICE:
                case (long)QueryType.SYSTEM_CODE_ILESTONE:
                case (long)QueryType.SYSTEM_PAYMENT_TYPE:
                case (long)QueryType.SYSTEM_PAYMENT_TERM:
                case (long)QueryType.SYSTEM_SHIP_TYPE:
                case (long)QueryType.SYSTEM_TAX_CATE:
                case (long)QueryType.SYSTEM_TAX_REGION:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()", id = "DeleteLi" });
                    break;
                case (long)QueryType.SYSTEM_QUEUE_SEARCH:
                case (long)QueryType.SYSTEM_TICKET_SOURCE_SEARCH:
                case (long)QueryType.SYSTEM_TICKET_ISSUE_SEARCH:
                case (long)QueryType.SYSTEM_CHANGE_BOARD_SEARCH:
                case (long)QueryType.SYSTEM_PROJECT_STATUS:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()", id = "EditLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()", id = "ActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活", click_function = "InActive()", id = "InActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()", id = "DeleteLi" });
                    break;
                case (long)QueryType.SYSTEM_TICKET_STATUS_SEARCH:
                case (long)QueryType.SYSTEM_TICKET_PRIORITY_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()", id = "ActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活", click_function = "InActive()", id = "InActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置图标", click_function = "SetLogo()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()", id = "DeleteLi" });
                    break;
                case (long)QueryType.SYSTEM_TICKET_SUB_ISSUE_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    break;
                case (long)QueryType.SYSTEM_CHECK_LIB_SEARCH:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()", id = "ActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活", click_function = "InActive()", id = "InActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()", id = "DeleteLi" });
                    break;
                case (long)QueryType.UserDefinedField:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()", id = "ActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活", click_function = "InActive()", id = "InActiveLi" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()", id = "DeleteLi" });
                    break;
                case (long)QueryType.SharedDashboard:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "共享", click_function = "Share()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (long)QueryType.SYSTEM_CODE_WORK_TYPE:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "从合同中排除此工作类型", click_function = "Exclude()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()", id = "DeleteLi" });
                    break;
                case (int)QueryType.WidgetDrillInvoiceItems:
                    contextMenu.Add(new PageContextMenuDto { text = "工时详情", click_function = "ShowLabour()", id = "labourMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "项目详情", click_function = "ShowProject()", id = "projectMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "任务详情", click_function = "ShowTicket()", id = "taskMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ShowContract()", id = "contractMenu" });
                    break;
                case (int)QueryType.WidgetDrillPendingBillItems:
                    contextMenu.Add(new PageContextMenuDto { text = "审批并提交", click_function = "ApprovalAndPost()", class_name = "menu", id = "appPostMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "调整价格", click_function = "AjustPrice()", class_name = "menu", id = "AjustPriceMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑成本", click_function = "EditCost()", class_name = "menu", id = "EditChargeMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑工单", click_function = "EditTicket()", class_name = "menu", id = "EditTicketMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "里程碑详情", click_function = "ShowMile()", class_name = "menu", id = "MileDetailMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ShowContract()", class_name = "menu", id = "contractMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "工时详情", click_function = "ShowEntry()", class_name = "menu", id = "EntrytMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "项目详情", click_function = "ShowProject()", class_name = "menu", id = "ProjectMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "任务详情", click_function = "ShowTask()", class_name = "menu", id = "taskMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "设置为不计费", click_function = "MakeAsNoBill()", class_name = "menu", id = "MakeAsNoBillMenu" });
                    break;
                case (int)QueryType.WidgetDrillPostedBillItems:
                    contextMenu.Add(new PageContextMenuDto { text = "工时详情", click_function = "ShowEntry()", class_name = "menu", id = "EntrytMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "里程碑详情", click_function = "ShowMile()", class_name = "menu", id = "MileDetailMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "合同详情", click_function = "ShowContract()", class_name = "menu", id = "contractMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "项目详情", click_function = "ShowProject()", class_name = "menu", id = "ProjectMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "任务详情", click_function = "ShowTask()", class_name = "menu", id = "TaskMenu" });
                    break;
                case (int)QueryType.WidgetDrillTask:
                    contextMenu.Add(new PageContextMenuDto { text = "查看任务详情", click_function = "TaskViewDetails()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑任务", click_function = "EditObject()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转发/编辑", click_function = "ModifySingTask()" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到我的工作清单", click_function = "AddToMyWorkList()" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到主负责人清单", click_function = "AddToPriResWorkList()" });
                    contextMenu.Add(new PageContextMenuDto { text = "加入到其他员工的工作清单", click_function = "AddToOtherResWorkList()" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加工时", click_function = "NewAddWorkEntry()" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加工时(输入开始结束时间)", click_function = "NewAddWorkEntryStart()" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加服务预定", click_function = "AddTaskServiceCall()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看备注", click_function = "ViewNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看项目", click_function = "ViewProject()" });
                    break;
                case (int)QueryType.WidgetDrillProjects:
                    contextMenu.Add(new PageContextMenuDto { text = "查看项目", click_function = "ViewProject()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑项目", click_function = "EditObject()" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加项目备注", click_function = "NewAddNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加项目日历条目", click_function = "AddCalendar()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看项目财务", click_function = "ViewFinancials()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
                    break;
                case (int)QueryType.WidgetDrillQuotes:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑报价", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑报价设置", click_function = "QuotePref()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑/查看 报价条目", click_function = "QuoteManage()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看商机", click_function = "ViewOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看报价", click_function = "ViewQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制报价", click_function = "CopyQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "赢得报价", click_function = "CloseQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失报价", click_function = "LossQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除报价", click_function = "DeleteQuote()" });
                    break;
                case (int)QueryType.WidgetDrillQuoteItems:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑报价项", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑报价", click_function = "EditQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "编辑/查看 报价条目", click_function = "QuoteManage()" });
                    break;
                case (int)QueryType.WidgetDrillServiceCalls:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑服务预定", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "完成服务预定", click_function = "DoneServiceCall()",id="DoneMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "CopyCall()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewAccount()" });
                    contextMenu.Add(new PageContextMenuDto { text = "添加备注", click_function = "AddItemNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转发/编辑 工单", click_function = "ModifyTicket()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除服务预定", click_function = "DeleteCall()" });
                    break;
                case (int)QueryType.WidgetDrillTimeoffRequest:
                    contextMenu.Add(new PageContextMenuDto { text = "批准申请", click_function = "ApproveSingle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "拒绝申请", click_function = "RejectSingle()" });
                    contextMenu.Add(new PageContextMenuDto { text = "批准选中申请", click_function = "ApproveSelect()" });
                    contextMenu.Add(new PageContextMenuDto { text = "拒绝选中申请", click_function = "RejectSelect()" });
                    break;
                case (int)QueryType.WidgetDrillTimesheet:
                    contextMenu.Add(new PageContextMenuDto { text = "批准申请", click_function = "ApproveSingle()" ,id="AppSinMenu"});
                    contextMenu.Add(new PageContextMenuDto { text = "拒绝申请", click_function = "RejectSingle()", id = "RejSinMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "提交申请", click_function = "SubmitSingle()", id = "SubSinMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看详情", click_function = "ShowDetail()", id = "SinDetailMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "批准选中申请", click_function = "ApproveSelect()", id = "AppSelMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "拒绝选中申请", click_function = "RejectSelect()", id = "RejSelMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "提交选中申请", click_function = "SubmitSelect()", id = "SubSelMenu" });
                    break;
                case (int)QueryType.WidgetDrillTodoNotes:
                case (int)QueryType.WidgetDrillScheduledItems:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看", click_function = "View()" });
                    contextMenu.Add(new PageContextMenuDto { text = "转为待办", click_function = "SetScheduled()", id="TransTodoMenu"});
                    contextMenu.Add(new PageContextMenuDto { text = "完成待办", click_function = "FinishTodo()", id = "CompleteTodoMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看商机", click_function = "ViewOpportunity()", id="ShowOppoMenu"});
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });

                    break;
                case (int)QueryType.WidgetDrillWorkEntries:
                    contextMenu.Add(new PageContextMenuDto { text = "工单详情", click_function = "ViewTicket()",id="TicketMenu" });
                    contextMenu.Add(new PageContextMenuDto { text = "任务详情", click_function = "ViewTask()" ,id="TaskMenu"});
                    break;
                default:
                    break;
            }
            // 判断权限，用户不可访问的菜单移除
            var menus = base.GetSearchContextMenu((QueryType)queryTypeId);  // 获取该用户不可见的菜单名称 
            for (int i = contextMenu.Count - 1; i >= 0; --i)
            {
                if (menus.Exists(_ => contextMenu[i].text.Equals(_)))
                    contextMenu.RemoveAt(i);
            }
        }

        /// <summary>
        /// 计算查询结果table宽度
        /// </summary>
        private void CalcTableWidth()
        {
            if (resultPara == null)
                return;

            int charCnt = 0;
            foreach (var p in resultPara)
            {
                if (p.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                    || p.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE
                    || p.type == (int)DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP)
                    continue;

                charCnt += p.length;
            }
            tableWidth = charCnt * 16;
        }
    }
}