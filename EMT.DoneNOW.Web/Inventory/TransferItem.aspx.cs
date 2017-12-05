using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class TransferItem : BasePage
    {
        protected InventoryItemEditDto product;
        protected List<ivt_warehouse> locationList;
        protected bool is_serialized;
        protected string backSn = "";
        protected long backLocation = 0;
        private InventoryProductBLL bll = new InventoryProductBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = long.Parse(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                product = bll.GetIvtProductEdit(id);
                locationList = new InventoryLocationBLL().GetLocationListUnResource();
                var pdt = new ProductBLL().GetProduct(product.product_id);
                is_serialized = pdt.is_serialized == 1 ? true : false;
            }
            else
            {
                long targetLocationId = long.Parse(Request.Form["warehouse_id"]);
                int count=int.Parse(remove_quantity.Text);
                if(bll.TransferProduct(id, targetLocationId, count, pdtSnHidden.Value, note.Text, LoginUserId))
                {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");
                    Response.End();
                }
                else
                {
                    product = bll.GetIvtProductEdit(id);
                    locationList = new InventoryLocationBLL().GetLocationListUnResource();
                    var pdt = new ProductBLL().GetProduct(product.product_id);
                    is_serialized = pdt.is_serialized == 1 ? true : false;
                    backSn = Request.Form["sn"];
                    backLocation = targetLocationId;
                }
            }
        }
    }
}