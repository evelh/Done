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
        protected string searchName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            searchName = DNRequest.GetQueryString("entity");
        }
    }
}