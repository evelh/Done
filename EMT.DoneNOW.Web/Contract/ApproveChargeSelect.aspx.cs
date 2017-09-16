using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class ApproveChargeSelect :BasePage
    {
        protected int id;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
        }
    }
}