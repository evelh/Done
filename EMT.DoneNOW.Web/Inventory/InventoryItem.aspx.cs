using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class InventoryItem : BasePage
    {
        protected InventoryItemEditDto product;
        protected string sn = null;
        protected int snCnt = 0;
        protected List<ivt_warehouse> locationList;
        private InventoryProductBLL bll = new InventoryProductBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(id))
                {
                    long pdId = Convert.ToInt64(id);
                    product = bll.GetIvtProductEdit(pdId);
                    var snList = bll.GetProductSnList(pdId);
                    if (snList !=null &&snList.Count>0)
                    {
                        snCnt = snList.Count;
                        foreach (var s in snList)
                            sn += s.sn + "\n";
                    }
                    locationList = new InventoryLocationBLL().GetLocationList();
                }
                else
                    locationList = new InventoryLocationBLL().GetLocationListUnResource();
            }
            else
            {
                var pdt = AssembleModel<ivt_warehouse_product>();
                string sn = Request.Form["sn"];
                if (string.IsNullOrEmpty(id))
                {
                    bll.AddIvtProduct(pdt, sn, LoginUserId);
                }
                else
                {
                    pdt.id = Convert.ToInt64(id);
                    bll.EditIvtProduct(pdt, sn, LoginUserId);
                }
                if ("SaveNew".Equals(Request.Form["act"]))
                {
                    Response.Write("<script>window.location.href='InventoryItem.aspx';self.opener.location.reload();</script>");
                    Response.End();
                }
                else
                {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");
                    Response.End();
                }
            }
        }
    }
}