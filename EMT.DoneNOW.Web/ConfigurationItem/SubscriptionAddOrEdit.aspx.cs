using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class SubscriptionAddOrEdit : BasePage
    {
        protected bool isAdd = true;
        protected crm_subscription subscription = null;
        protected crm_installed_product iProduct = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var iProduct_id = Request.QueryString["insProId"];
                iProduct = new crm_installed_product_dal().GetInstalledProduct(long.Parse(iProduct_id));
                if (iProduct == null)
                {
                    Response.End();
                }

                var id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    subscription = new crm_subscription_dal().GetSubscription(long.Parse(id));
                }
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}