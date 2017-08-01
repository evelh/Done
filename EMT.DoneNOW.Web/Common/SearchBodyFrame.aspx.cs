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
        protected string queryPage;     // 查询页名称
        protected string addBtn;        // 根据不同查询页得到的新增按钮名
        protected QueryResultDto queryResult = null;            // 查询结果数据
        protected List<QueryResultParaDto> resultPara = null;   // 查询结果列信息
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected List<DictionaryEntryDto> queryParaValue = new List<DictionaryEntryDto>();  // 查询条件和条件值
        protected void Page_Load(object sender, EventArgs e)
        {
            queryPage = HttpContext.Current.Request.QueryString["type"];
            if (string.IsNullOrEmpty(queryPage))
            {
                queryPage = "客户查询";
            }
            InitData();
            GetMenus();
            string flag = HttpContext.Current.Request.QueryString["show"];
            if (string.IsNullOrEmpty(flag) || !flag.Equals("1"))
                QueryData();
        }

        /// <summary>
        /// 数据初始化
        /// </summary>
        private void InitData()
        {
            switch(queryPage)
            {
                case "客户查询":
                    addBtn = "新增客户";
                    break;
                case "联系人查询":
                    addBtn = "新增联系人";
                    break;
                default:
                    addBtn = "新增客户";
                    break;
            }
        }

        /// <summary>
        /// 根据查询条件获取查询结果
        /// </summary>
        private void QueryData()
        {
            queryParaValue.Clear();
            resultPara = bll.GetResultParaSelect(GetLoginUserId(), queryPage);    // 获取查询结果列信息

            var keys = HttpContext.Current.Request.QueryString;
            string order = keys["order"];   // order by 条件
            int page = string.IsNullOrEmpty(keys["page_num"]) ? 1 : int.Parse(keys["page_num"]);  // 查询页数

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
            }

            if (queryResult == null)  // 不使用缓存或缓存过期
            {
                var para = bll.GetConditionPara(GetLoginUserId(), queryPage);   // 查询条件信息
                QueryParaDto queryPara = new QueryParaDto();
                queryPara.query_params = new List<Para>();
                foreach (var p in para)
                {
                    Para pa = new Para();
                    if (p.data_type == (int)DicEnum.QUERY_PARA_TYPE.NUMBER
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATE
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATETIME)    // 数值和日期类型是范围值
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

                queryPara.query_page_name = queryPage;
                queryPara.page = page;
                queryPara.order_by = order;
                queryPara.page_size = 0;

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
            switch(queryPage)
            {
                case "客户查询":
                    dics = new CompanyBLL().GetField();
                    contextMenu.Add(new PageContextMenuDto { text = "修改客户", click_function = "EditCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看客户", click_function = "ViewCompany()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增记录", click_function = "Add()" });

                    PageContextMenuDto classcate = new PageContextMenuDto { text = "设置类别", click_function = "" };
                    // 设置公司类别子菜单
                    var classification = dics["classification"] as List<DictionaryEntryDto>;
                    if (classification != null)
                    {
                        List<PageContextMenuDto> classsub = new List<PageContextMenuDto>();
                        foreach(var c in classification)
                        {
                            classsub.Add(new PageContextMenuDto { text = c.show, click_function = $"openopenopen({c.val})" });
                        }
                        classcate.submenu = classsub;
                    }
                    contextMenu.Add(classcate);

                    contextMenu.Add(new PageContextMenuDto { text = "关闭商机向导", click_function = "openopenopen()" });
                    contextMenu.Add(new PageContextMenuDto { text = "丢失商机向导", click_function = "openopenopen()" });
                    contextMenu.Add(new PageContextMenuDto { text = "重新指定客户经理向导", click_function = "openopenopen()" });
                    contextMenu.Add(new PageContextMenuDto { text = "注销客户向导", click_function = "openopenopen()" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除客户", click_function = "DeleteCompany()" });
                    break;
                case "联系人查询":
                    contextMenu.Add(new PageContextMenuDto { text = "修改联系人", click_function = "EditContact()" });
                    contextMenu.Add(new PageContextMenuDto { text = "查看联系人", click_function = "ViewContact()" });
                    contextMenu.Add(new PageContextMenuDto { text = "新增备注", click_function = "openopenopen()" });
                    contextMenu.Add(new PageContextMenuDto { text = "Livelink", click_function = "openopenopen()" });
                    contextMenu.Add(new PageContextMenuDto { text = "删除联系人", click_function = "DeleteContact()" });
                    break;
                default:
                    break;
            }
        }
    }
}