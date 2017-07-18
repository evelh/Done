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
        private string queryPage;
        protected void Page_Load(object sender, EventArgs e)
        {
            queryPage = HttpContext.Current.Request.QueryString["type"];
            if (string.IsNullOrEmpty(queryPage))
                queryPage = "客户查询";
            QueryData();
        }

        private void QueryData()
        {
            QueryResultDto queryResult = null;

            var keys = HttpContext.Current.Request.QueryString;
            string order = keys["order"];   // order by 条件
            int page = string.IsNullOrEmpty(keys["search_page"]) ? 1 : int.Parse(keys["search_page"]);  // 查询页数

            // 检查order
            if (order != null)
            {
                order = order.Trim();
                string[] strs = order.Split(' ');
                if (strs.Length != 2 || strs[1].ToLower().Equals("asc") || strs[1].ToLower().Equals("desc"))
                    order = "";
            }

            if (!string.IsNullOrEmpty(keys["search_id"]))   // 使用缓存查询条件
            {
                queryResult = bll.GetResult(GetLoginUserId(), keys["search_id"], page, order);
            }
            
            if (queryResult==null)  // 不使用缓存或缓存过期
            {
                var para = bll.GetConditionPara(GetLoginUserId(), queryPage);
                QueryParaDto queryPara = new QueryParaDto();
                foreach(var p in para)
                {
                    if (p.data_type == (int)DicEnum.QUERY_PARA_TYPE.NUMBER
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATE
                        || p.data_type == (int)DicEnum.QUERY_PARA_TYPE.DATETIME)    // 数值和日期类型是范围值
                    {

                    }
                }
            }
        }
    }
}