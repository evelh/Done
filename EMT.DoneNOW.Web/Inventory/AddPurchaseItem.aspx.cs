using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class AddPurchaseItem : BasePage
    {
        protected List<ivt_warehouse> warehosreList;    // 仓库列表
        protected bool isAdd;       // true：新增采购项；false：编辑采购项
        protected long orderId;     // 采购订单id
        protected ivt_order_product product;    // 采购项
        private InventoryOrderBLL bll = new InventoryOrderBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["act"] == "edit")
                isAdd = false;
            else
                isAdd = true;
            orderId = long.Parse(Request.QueryString["orderId"]);

            long productId = 0;
            if (!isAdd)
                productId = long.Parse(Request.QueryString["productId"]);

            warehosreList = new InventoryLocationBLL().GetLocationListUnResource();

            if (!IsPostBack)
            {
                if (isAdd)      // 新增
                    product = null;
                else            // 编辑
                {
                    if (orderId != 0)       // 采购订单已保存的采购项也已保存
                        product = bll.GetOrderProduct(productId);
                    else
                    {
                        var items = Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;
                        int index = items.items.FindIndex(_ => _.id == productId);
                        if (index < 0)
                        {
                            Response.End();
                            return;
                        }
                        product = new ivt_order_product();
                        product.warehouse_id = items.items[index].warehouse_id;
                        product.product_id = items.items[index].product_id;
                        product.quantity = items.items[index].quantity;
                        product.unit_cost = items.items[index].unit_cost;
                    }
                }
            }
            else
            {
                if (orderId==0)
                {
                    var items = Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;
                    PurchaseItemDto pdt = AssembleModel<PurchaseItemDto>();
                    pdt.locationName = warehosreList.Find(_ => _.id == pdt.warehouse_id).name;
                    if (!isAdd)
                    {
                        pdt.id = productId;
                        int index = items.items.FindIndex(_ => _.id == productId);
                        if (index >= 0)
                            items.items.RemoveAt(index);
                    }
                    else
                    {
                        pdt.id = items.index;
                        items.index++;
                    }
                    items.items.Add(pdt);
                    Session["PurchaseOrderItem"] = items;
                }
                else
                {
                    if (isAdd)
                    {
                        ivt_order_product pdt = AssembleModel<ivt_order_product>();
                        pdt.order_id = orderId;
                        pdt.was_auto_filled = 0;
                        bll.AddOrderItem(pdt, LoginUserId);
                    }
                    else
                    {
                        ivt_order_product pdt = AssembleModel<ivt_order_product>();
                        pdt.order_id = orderId;
                        pdt.id = productId;
                        bll.EditOrderItem(pdt, LoginUserId);
                    }
                }
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
        }
    }
}