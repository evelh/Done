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
    public partial class ViewContactGroup : BasePage
    {
        protected crm_contact_group thisGroup;
        protected void Page_Load(object sender, EventArgs e)
        {
            var groupId = Request.QueryString["groupId"];
            if (!string.IsNullOrEmpty(groupId))
                thisGroup = new ContactBLL().GetGroupById(long.Parse(groupId));

            if (thisGroup == null)
            {
                Response.Write("<script>alert('为获取到相应联系人组');window.close();</script>");
            }
        }
    }
}