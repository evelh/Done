using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.ServiceDesk
{
    public partial class ServiceDeskDashboard : BasePage
    {
        protected string refreshMin;
        protected void Page_Load(object sender, EventArgs e)
        {
            refreshMin = Request.QueryString["refreshMin"];
        }
    }
}