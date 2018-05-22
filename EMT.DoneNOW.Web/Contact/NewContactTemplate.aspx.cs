using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contact
{
    public partial class NewContactTemplate : BasePage
    {
        protected crm_contact_action_tmpl thisTemp;
        protected bool isHasPar = true;
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
                thisTemp = new ContactBLL().GetTempById(long.Parse(id));
            if (Request.QueryString["noPar"] == "1")
                isHasPar = false;
        }
    }
}