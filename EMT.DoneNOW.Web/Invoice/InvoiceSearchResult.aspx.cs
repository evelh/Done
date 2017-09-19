using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Invoice
{
    public partial class InvoiceSearchResult :BasePage
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
        }
    }
}