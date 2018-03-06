using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class EditServiceAlert : BasePage
    {
        protected bool msg1 = false;
        protected bool msg2 = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            msg1 = !string.IsNullOrEmpty(Request.QueryString["msg1"]);
            msg2 = !string.IsNullOrEmpty(Request.QueryString["msg2"]);
        }
    }
}