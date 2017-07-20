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
        protected string flag;
        protected void Page_Load(object sender, EventArgs e)
        {
            queryPage = HttpContext.Current.Request.QueryString["type"];
            if (string.IsNullOrEmpty(queryPage))
            {
                queryPage = HttpContext.Current.Request.QueryString["search_page"];
                if (string.IsNullOrEmpty(queryPage))
                    queryPage = "客户查询";
            }
            flag = HttpContext.Current.Request.QueryString["page"];
            if (flag != null && flag.Equals("1"))
                QueryData();
            else
                flag = "";
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
                var para = bll.GetConditionPara(GetLoginUserId(), queryPage);
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
                            pa.value = ql;
                        if (!string.IsNullOrEmpty(qh))
                            pa.value2 = qh;
                        pa.id = p.id;

                        queryPara.query_params.Add(pa);
                    }
                    else
                    {
                        string val = keys[p.id.ToString()];
                        if (string.IsNullOrEmpty(val))
                            continue;
                        pa.id = p.id;
                        pa.value = val;

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
    }
}