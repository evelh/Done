using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class RejectPurchase : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btReject_Click(object sender, EventArgs e)
        {
            long costId = Convert.ToInt64(Request.QueryString["costId"]);
            if (new ContractCostBLL().PurchaseReject(costId, LoginUserId))
            {
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
        }
    }
}