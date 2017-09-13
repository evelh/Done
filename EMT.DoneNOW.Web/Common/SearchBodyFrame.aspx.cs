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

        protected string isCheck = ""; //  用于控制是否显示checkBox
        protected void Page_Load(object sender, EventArgs e)
        {
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
            isCheck = Request.QueryString["isCheck"];
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
        /// 数据初始化
        /// </summary>
        private void InitData()
        {
            switch(catId)
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
                    addBtn = "新增";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTRACT_INTERNAL_COST:
                    addBtn = "新增内部成本";
					break;
                case (int)DicEnum.QUERY_CATE.PRODUCT:
                    addBtn = "新增产品";
                    break;
                case (int)DicEnum.QUERY_CATE.RELATION_CONFIGITEM:
                    addBtn = "新增配置项";
					break;
                case (int)DicEnum.QUERY_CATE.REVOKE_CHARGES:
                case (int)DicEnum.QUERY_CATE.REVOKE_MILESTONES:
                case (int)DicEnum.QUERY_CATE.REVOKE_RECURRING_SERVICES:
                case (int)DicEnum.QUERY_CATE.REVOKE_SUBSCRIPTIONS:
                    addBtn = "完成";
                    break;
                case (int)DicEnum.QUERY_CATE.APPROVE_MILESTONES://审批里程碑
                    addBtn = "审批并提交";
                    break;
                default:
                    addBtn = "";
                    break;
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
                var cdts = bll.GetConditionPara(GetLoginUserId(), paraGroupId);
                if (cdts.Count == 1)
                {
                    QueryParaDto queryPara = new QueryParaDto();

                    queryPara.query_params = new List<Para>();
                    Para pa = new Para();
                    pa.id = cdts[0].id;
                    pa.value = objId.ToString();
                    queryPara.query_params.Add(pa);

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
                var para = bll.GetConditionPara(GetLoginUserId(), paraGroupId);   // 查询条件信息
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
                        string ql = keys[p.id.ToString() + "_l"];
                        string qh = keys[p.id.ToString() + "_h"];
                        if (string.IsNullOrEmpty(ql) && string.IsNullOrEmpty(qh))   // 空值，跳过
                            continue;
                        if (!string.IsNullOrEmpty(ql))
                        {
                            queryParaValue.Add(new DictionaryEntryDto(p.id.ToString() + "_l", ql));     // 记录查询条件和条件值
                            pa.value = ql;
                        }
                        if (!string.IsNullOrEmpty(qh))
                        {
                            queryParaValue.Add(new DictionaryEntryDto(p.id.ToString() + "_h", qh));     // 记录查询条件和条件值
                            pa.value2 = qh;
                        }
                        pa.id = p.id;

                        queryPara.query_params.Add(pa);
                    }
                    else    // 其他类型一个值
                    {
                        string val = keys[p.id.ToString()];
                        if (string.IsNullOrEmpty(val))
                            continue;
                        pa.id = p.id;
                        pa.value = val;
                        queryParaValue.Add(new DictionaryEntryDto(p.id.ToString(), val));     // 记录查询条件和条件值

                        queryPara.query_params.Add(pa);
                    }
                }

                queryPara.query_type_id = queryTypeId;
                queryPara.para_group_id = paraGroupId;
                queryPara.page = page;
                queryPara.order_by = order;
                queryPara.page_size = pageSize;

                queryResult = bll.GetResult(GetLoginUserId(), queryPara);
            }
        }

        /// <summary>
        /// 根据查询页面类型获取右键菜单
        /// </summary>
        private void GetMenus()
        {
            contextMenu = new List<PageContextMenuDto>();
            Dictionary<string, object> dics = null;
            switch(queryTypeId)
            {
                case (long)QueryType.Company:
                    dics = new CompanyBLL().GetField();
                    contextMenu.Add(new PageContextMenuDto { text = "修改客户", click_function = "EditCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "openopenopen()\" \" style='color:grey;'" });

                    PageContextMenuDto classcate = new PageContextMenuDto { text = "设置类别", click_function = "" };
                    // 设置公司类别子菜单
                    var classification = dics["classification"] as List<DictionaryEntryDto>;
                    if (classification != null)
                    {
                        List<PageContextMenuDto> classsub = new List<PageContextMenuDto>();
                        foreach(var c in classification)
                        {
                            classsub.Add(new PageContextMenuDto { text = c.show, click_function = $"openopenopen({c.val})\" \" style='color:grey;'" });
                        }
                        classcate.submenu = classsub;
                    }
                    contextMenu.Add(classcate);

                    contextMenu.Add(new PageContextMenuDto { text = "关闭商机向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失商机向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "重新指定客户经理向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "注销客户向导", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除客户", click_function = "DeleteCompany()" });
                    break;
                case (long)QueryType.Contact:
                case (long)QueryType.ContactCompanyView:
                    contextMenu.Add(new PageContextMenuDto { text = "修改联系人", click_function = "EditContact()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看联系人", click_function = "ViewContact()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除联系人", click_function = "DeleteContact()" });
                    break;
                case (long)QueryType.Opportunity:
                case (long)QueryType.OpportunityCompanyView:
                case (long)QueryType.OpportunityContactView:
                    contextMenu.Add(new PageContextMenuDto { text = "修改商机", click_function = "EditOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看商机", click_function = "ViewOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增报价", click_function = "AddQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "修改报价", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "关闭商机", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失商机", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "重新指定商机负责人", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除商机", click_function = "DeleteOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.Quote:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑报价", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "报价参数设定", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "报价项管理", click_function = "QuoteManage()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看商机", click_function = "ViewOpp()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看报价", click_function = "ViewQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制报价", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "关闭报价", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失报价", click_function = "LossQuote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除报价", click_function = "DeleteQuote()" });
                    break;
                case (long)QueryType.QuoteTemplate:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "设为默认", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "未激活", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "openopenopen()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.InstalledProductView:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "替换", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活当前记录", click_function = "",id="ActiveThis" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活选中记录", click_function = "", id = "ActiveChoose" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活当前记录", click_function = "", id = "NoActiveThis" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活选中记录", click_function = "", id = "NoActiveChoose" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当前配置项", click_function = "DeleteIProduct()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除选中配置项", click_function = "DeleteIProducts()" });
                    break;
                case (long)QueryType.Subscription:

                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "创建订阅副本", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "创建选中订阅副本", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消订阅", click_function = "", id = "CancelSubscription" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消选中订阅", click_function = "", id = "CancelSubscriptions" });
                    contextMenu.Add(new PageContextMenuDto { text = "激活订阅", click_function = "", id = "ActiveSubscription" });
                    contextMenu.Add(new PageContextMenuDto { text = "失活订阅", click_function = "", id = "NoActiveSubscription" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除当前订阅", click_function = "DeleteSubscription()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除选中订阅", id = "DeleteSubscriptions" });
                    break;
                case (long)QueryType.SaleOrder:
                    contextMenu.Add(new PageContextMenuDto { text = "修改销售订单", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "NewNote()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增待办", click_function = "NewTodo()" });
                    contextMenu.Add(new PageContextMenuDto { text = "取消销售订单", click_function = "CancelSaleOrder()" });
                    break;
                case (long)QueryType.Contract:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑合同", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看合同", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "在新窗口中查看合同", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "续约", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "复制合同", click_function = "openopenopen()\" \" style='color:grey;'" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除合同", click_function = "openopenopen()\" \" style='color:grey;'" });
                    break;
                case (long)QueryType.ProuductInventory:
                    contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "移库", click_function = "Transfer()" });
                    contextMenu.Add(new PageContextMenuDto { text = "订购", click_function = "Order()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除库存", click_function = "Delete()" });
                    break;
                case (long)QueryType.Role:
                    contextMenu.Add(new PageContextMenuDto { text = "编辑", click_function = "Edit()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
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
                    contextMenu.Add(new PageContextMenuDto { text = "复制", click_function = "Copy()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查找相似员工", click_function = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "发邮件给当前员工", click_function = "" });
                    contextMenu.Add(new PageContextMenuDto { text = "发邮件给选中员工", click_function = "" });
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
                    contextMenu.Add(new PageContextMenuDto { text = "解除与当前合同关系", click_function = "Norelation()"});
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
                default:
                    break;
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