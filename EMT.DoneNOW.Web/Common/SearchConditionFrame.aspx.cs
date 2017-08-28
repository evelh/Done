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
        //protected string queryPage;     // 查询页名称
        protected int catId = 0;
        protected long queryTypeId;     // 查询页id
        protected long paraGroupId;     // 查询条件分组id
        protected List<QueryConditionParaDto> condition;    // 根据不同页面类型获取的查询条件列表
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["cat"], out catId))
                catId = 0;
            if (!long.TryParse(Request.QueryString["type"], out queryTypeId))
                queryTypeId = 0;
            if (!long.TryParse(Request.QueryString["group"], out paraGroupId))
                paraGroupId = 0;
            if (catId == 0 || queryTypeId == 0 || paraGroupId == 0)
            {
                Response.Close();
                return;
            }

            InitData();
            condition = bll.GetConditionPara(GetLoginUserId(), paraGroupId);
        }

        private void InitData()
        {
            currentQuery = new PageQueryConditionNameDto();
            currentQuery.page_query = new List<PageQueryConditionNameDto.PageQuery>();

            switch (catId)
            {
                case (int)DicEnum.QUERY_CATE.COMPANY:
                    currentQuery.page_name = "客户查询";
                    break;
                case (int)DicEnum.QUERY_CATE.CONTACT:
                    currentQuery.page_name = "联系人查询";
                    break;
                case (int)DicEnum.QUERY_CATE.OPPORTUNITY:
                    currentQuery.page_name = "商机查询";
                    break;
                case (int)DicEnum.QUERY_CATE.QUOTE:
                    currentQuery.page_name = "报价查询";
                    break;
                case (int)DicEnum.QUERY_CATE.QUOTE_TEMPLATE:
                    currentQuery.page_name = "报价模板查询";
                    break;
                case (int)DicEnum.QUERY_CATE.INSTALLEDPRODUCT:
                    currentQuery.page_name = "配置项查询";
                    break;
                case (int)DicEnum.QUERY_CATE.SUBSCRIPTION:
                    currentQuery.page_name = "订阅查询";
                    break;
                default:
                    currentQuery.page_name = "客户查询";
                    break;
            }

            var info = new QueryCommonBLL().GetQueryGroup(catId);
            foreach (var v in info)
            {
                currentQuery.page_query.Add(new PageQueryConditionNameDto.PageQuery { query_name = v.name, typeId = v.query_type_id, groupId = v.id });
            }

            //if (queryNameList==null)
            //{
            //    queryNameList = new List<PageQueryConditionNameDto>();
            //    PageQueryConditionNameDto query;

            //    query = new PageQueryConditionNameDto();
            //    query.page_name = "客户查询";
            //    query.page_query = new List<PageQueryConditionNameDto.PageQuery>() {
            //        new PageQueryConditionNameDto.PageQuery { query_name="查询", query_url= "Common/SearchFrameSet.aspx?entity=客户查询" }
            //    };
            //    queryNameList.Add(query);

            //    query = new PageQueryConditionNameDto();
            //    query.page_name = "联系人查询";
            //    query.page_query = new List<PageQueryConditionNameDto.PageQuery>() {
            //        new PageQueryConditionNameDto.PageQuery { query_name = "查询", query_url = "Common/SearchFrameSet.aspx?entity=联系人查询" }
            //    };
            //    queryNameList.Add(query);

            //    query = new PageQueryConditionNameDto();
            //    query.page_name = "商机查询";
            //    query.page_query = new List<PageQueryConditionNameDto.PageQuery>() {
            //        new PageQueryConditionNameDto.PageQuery { query_name = "查询", query_url = "Common/SearchFrameSet.aspx?entity=商机查询" }
            //    };
            //    queryNameList.Add(query);
            //}

            //string name = DNRequest.GetQueryString("type");
            //foreach (var page in queryNameList)
            //{
            //    if (page.page_name.Equals(name))
            //    {
            //        currentQuery = page;
            //        queryPage = page.page_name;
            //    }
            //    /*
            //    foreach (var q in page.page_query)
            //    {
            //        if (q.query_name.Equals(name))
            //        {
            //            currentQuery = page;
            //            queryPage = page.page_name;
            //        }
            //    }
            //    */
            //}
        }

        //private static List<PageQueryConditionNameDto> queryNameList;     // 所有查询页的标题、链接等信息
        protected PageQueryConditionNameDto currentQuery;   // 当前查询页的标题、链接等信息
    }
}