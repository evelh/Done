using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class Refresh : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BLL.AuthBLL.InitSecLevelPermit();
            new Tools.RedisCacheder().RemoveCacheByPrefix("");
        }
    }
}