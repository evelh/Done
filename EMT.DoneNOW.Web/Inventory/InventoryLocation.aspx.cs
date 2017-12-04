using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class InventoryLocation : BasePage
    {
        protected ivt_warehouse location = null;
        private InventoryLocationBLL bll = new InventoryLocationBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (IsPostBack)
            {
                if (string.IsNullOrEmpty(id))
                {
                    bll.AddLocation(name.Text, is_default.Checked, is_active.Checked, LoginUserId);
                }
                else
                {
                    bll.EditLocation(Convert.ToInt64(id), name.Text, is_default.Checked, is_active.Checked, LoginUserId);
                }
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
            else
            {
                if (string.IsNullOrEmpty(id))
                    is_active.Checked = true;
                else
                {
                    location = bll.GetLocation(Convert.ToInt64(id));
                    if (location==null)
                    {
                        Response.End();
                        return;
                    }
                    if (location.resource_id == null)
                        is_default.Checked = (location.is_default == 1);
                    else
                        is_default.Enabled = false;

                    is_active.Checked = location.is_active == 1;
                    name.Text = location.name;
                }
            }
        }
    }
}