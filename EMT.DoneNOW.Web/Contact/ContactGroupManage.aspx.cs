using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Contact
{
    public partial class ContactGroupManage : BasePage
    {
        protected bool isAdd = true;
        protected crm_contact_group pageGroup;
        protected bool isCopy = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            var id = Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
                pageGroup = new ContactBLL().GetGroupById(long.Parse(id));
            if (pageGroup != null)
                isAdd = false;
            if (Request.QueryString["isCopy"] == "1")
                isAdd = true; isCopy = true;
                
        }
    }
}