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
        protected List<QueryConditionParaDto> condition;    // 根据不同页面类型获取的查询条件列表
        protected void Page_Load(object sender, EventArgs e)
        {
            condition = bll.GetConditionPara(GetLoginUserId(), DNRequest.GetQueryString("type"));
        }
        
    }
}