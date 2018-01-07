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
    public partial class ViewPurchaseOrder : BasePage
    {
        protected ivt_order order;
        protected List<ivt_order_product> items;
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = long.Parse(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                var bll = new InventoryOrderBLL();
                order = bll.GetPurchaseOrder(id);
                items = bll.GetPurchaseItemsByOrderId(id);
            }
            else
            {

            }
        }
    }
}