using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web
{
    public partial class DispatchViewList : BasePage
    {
        protected string workIds;
        protected string resIds;
        protected bool isShowNoRes;
        protected bool isShowCalls;
        protected bool isAdd = false;
        protected long modeId;
        protected List<sdk_dispatcher_view> viewList = new DispatchBLL().GetDisViewList();
        protected void Page_Load(object sender, EventArgs e)
        {
            workIds = Request.QueryString["workIds"];
            resIds = Request.QueryString["resIds"];
            isShowNoRes = !string.IsNullOrEmpty(Request.QueryString["isShowNoRes"]);
            isShowCalls = !string.IsNullOrEmpty(Request.QueryString["isShowCalls"]);
            if (!string.IsNullOrEmpty(Request.QueryString["modeId"]))
                modeId = long.Parse(Request.QueryString["modeId"]);
            if (!string.IsNullOrEmpty(Request.QueryString["isAdd"]))
                isAdd = true;
        }
    }
}