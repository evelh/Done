using EMT.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class SearchFrameSet : System.Web.UI.Page
    {
        protected int catId = 0;
        protected long queryTypeId = 0;
        protected long paraGroupId = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            catId = DNRequest.GetQueryInt("cat");

            var info = new BLL.QueryCommonBLL().GetQueryGroup(catId);
            if (info == null || info.Count == 0)
            {
                Response.Close();
                return;
            }
            queryTypeId = info[0].query_type_id;
            paraGroupId = info[0].id;
        }
    }
}