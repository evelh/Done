using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Activity
{
    public partial class Notes : BasePage
    {
        protected string action = "add";        // add/edit
        protected com_activity note = null;

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}