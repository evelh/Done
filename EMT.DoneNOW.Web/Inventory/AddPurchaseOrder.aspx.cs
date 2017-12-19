using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class AddPurchaseOrder : BasePage
    {
        protected List<DictionaryEntryDto> paymentTerms;    // 付款期限
        protected List<DictionaryEntryDto> taxRegion;       // 税区
        protected List<DictionaryEntryDto> shipCate;        // 配送类型
        protected List<DictionaryEntryDto> itemDescType;    // 采购项描述信息显示内容类型
        protected long orderId = 0;     // 采购订单id
        protected bool isAdd;
        protected ivt_order orderEdit;
        private InventoryOrderBLL bll = new InventoryOrderBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["act"] == "edit")
                isAdd = false;
            else
                isAdd = true;
            
            if (!isAdd)
                orderId = long.Parse(Request.QueryString["id"]);

            if (!IsPostBack)
            {
                Session["PurchaseOrderItem"] = new PurchaseOrderItemManageDto();
                var generalBll = new GeneralBLL();
                paymentTerms= generalBll.GetDicValues(GeneralTableEnum.PAYMENT_TERM);
                taxRegion = generalBll.GetDicValues(GeneralTableEnum.TAX_REGION);
                shipCate = generalBll.GetDicValues(GeneralTableEnum.PAYMENT_SHIP_TYPE);
                itemDescType = generalBll.GetDicValues(GeneralTableEnum.ITEM_DESC_DISPLAY_TYPE);
                if (!isAdd)
                    orderEdit = bll.GetPurchaseOrder(orderId);
            }
            else
            {
                var action = Request.Form["subAct"];
                if (action== "Cancle")
                {
                    Session.Remove("PurchaseOrderItem");
                    Response.Write("<script>window.close();</script>");
                    Response.End();
                    return;
                }

                var order = AssembleModel<ivt_order>();
                var location = AssembleModel<crm_location>();
                var items = Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;

                if (!string.IsNullOrEmpty(Request.Form["checkShowTaxCate"]) && Request.Form["checkShowTaxCate"].Equals("on"))
                    order.display_tax_cate = 1;
                if (!string.IsNullOrEmpty(Request.Form["checkTaxSeparate"]) && Request.Form["checkTaxSeparate"].Equals("on"))
                    order.display_tax_seperate_line = 1;

                var shipType= Request.Form["shipAddr"];
                if (shipType == "0")
                    order.ship_to_type_id = (int)DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.WORK_ADDRESS;
                else if (shipType == "1")
                    order.ship_to_type_id = (int)DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.OTHER_ADDRESS;
                else if (shipType == "2")
                    order.ship_to_type_id = (int)DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.SELECTED_COMPANY;
                else
                {
                    Response.End();
                    return;
                }

                if (action== "SaveClose"|| action == "SaveSubmit" || action == "SaveNew" || action == "SubmitEmail")
                {
                    if (action == "SaveSubmit" || action == "SubmitEmail")
                    {
                        // TODO: 提交验证

                        order.status_id = (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED;
                        order.submitted_resource_id = LoginUserId;
                        order.submit_time = EMT.Tools.Date.DateHelper.ToUniversalTimeStamp();
                    }
                    else
                    {
                        if(isAdd)
                            order.status_id = (int)DicEnum.PURCHASE_ORDER_STATUS.NEW;
                    }
                    if(!isAdd)
                    {
                        order.id = orderId;
                        bll.EditOrder(order, location, LoginUserId);
                    }
                    else
                    {
                        bll.AddOrder(order, items.items, location, LoginUserId);
                    }
                    if (action == "SaveClose")
                    {
                        Response.Write("<script>window.close();self.opener.location.reload();</script>");
                        Response.End();
                    }
                    if (action == "SaveNew")
                    {
                        Response.Write("<script>window.location.href='AddPurchaseOrder.aspx?act=add';self.opener.location.reload();</script>");
                        Response.End();
                    }
                    if (action == "SaveSubmit" || action == "SubmitEmail")
                    {
                        Response.Write("<script>window.close();self.opener.location.reload();</script>");
                        Response.End();
                    }
                }
            }
        }
    }
}