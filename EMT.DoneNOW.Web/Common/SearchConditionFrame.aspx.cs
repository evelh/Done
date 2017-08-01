using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.Tools;

namespace EMT.DoneNOW.Web
{
    public partial class SearchConditionFrame : BasePage
    {
        private QueryCommonBLL bll = new QueryCommonBLL();
        protected string queryPage;     // 查询页名称
        protected List<QueryConditionParaDto> condition;    // 根据不同页面类型获取的查询条件列表
        protected void Page_Load(object sender, EventArgs e)
        {
            InitData();
            condition = bll.GetConditionPara(GetLoginUserId(), DNRequest.GetQueryString("type"));
        }

        private void InitData()
        {
            if (queryNameList==null)
            {
                queryNameList = new List<PageQueryConditionNameDto>();
                PageQueryConditionNameDto query;

                query = new PageQueryConditionNameDto();
                query.page_name = "客户查询";
                query.page_query = new List<PageQueryConditionNameDto.PageQuery>() {
                    new PageQueryConditionNameDto.PageQuery { query_name="查询", query_url= "Common/SearchFrameSet.aspx?entity=客户查询" }
                };
                queryNameList.Add(query);

                query = new PageQueryConditionNameDto();
                query.page_name = "联系人查询";
                query.page_query = new List<PageQueryConditionNameDto.PageQuery>() {
                    new PageQueryConditionNameDto.PageQuery { query_name = "查询", query_url = "Common/SearchFrameSet.aspx?entity=联系人查询" }
                };
                queryNameList.Add(query);

                query = new PageQueryConditionNameDto();
                query.page_name = "商机查询";
                query.page_query = new List<PageQueryConditionNameDto.PageQuery>() {
                    new PageQueryConditionNameDto.PageQuery { query_name = "查询", query_url = "Common/SearchFrameSet.aspx?entity=商机查询" }
                };
                queryNameList.Add(query);
            }

            string name = DNRequest.GetQueryString("type");
            foreach (var page in queryNameList)
            {
                if (page.page_name.Equals(name))
                {
                    currentQuery = page;
                    queryPage = page.page_name;
                }
                /*
                foreach (var q in page.page_query)
                {
                    if (q.query_name.Equals(name))
                    {
                        currentQuery = page;
                        queryPage = page.page_name;
                    }
                }
                */
            }
        }

        private static List<PageQueryConditionNameDto> queryNameList;     // 所有查询页的标题、链接等信息
        protected PageQueryConditionNameDto currentQuery;   // 当前查询页的标题、链接等信息
    }
}