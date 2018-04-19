using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class ResourceAssPolicy : BasePage
    {
        protected long resourceId;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                Response.End();
                return;
            }
            resourceId = long.Parse(Request.QueryString["id"]);
        }
    }
}