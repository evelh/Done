using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// PurchaseOrderAjax 的摘要说明
    /// </summary>
    public class PurchaseOrderAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var id = context.Request.QueryString["id"];
            switch (action)
            {
                case "approval":
                    PurchaseApproval(context);
                    break;
                case "approvalReject":
                    PurchaseApprovalReject(context);
                    break;
                case "purchaseShip":
                    PurchaseOrderShip(context);
                    break;
                case "purchaseUnShip":
                    PurchaseOrderUnShip(context);
                    break;
                case "SubmitOrder":
                    SubmitPurchaseOrder(context);
                    break;
                case "CancleOrder":
                    CanclePurchaseOrder(context);
                    break;
                case "DeleteOrder":
                    DeletePurchaseOrder(context);
                    break;
                case "AddPurchaseItemDefault":
                    AddPurchaseItemDefault(context);
                    break;
                case "isEditOrder":
                    isEditOrder(context);
                    break;
                case "deleteItem":
                    DeletePurchaseItem(context);
                    break;
                case "getItemSnCnt":
                    GetPurchaseItemSnCnt(context);
                    break;
                case "getItemMemo":
                    GetPurchaseItemMemo(context);
                    break;
                case "setItemMemo":
                    SetPurchaseItemMemo(context);
                    break;
                default:
                    break;

            }
        }

        /// <summary>
        /// 采购审批通过
        /// </summary>
        /// <param name="context"></param>
        private void PurchaseApproval(HttpContext context)
        {
            var id = context.Request.QueryString["ids"];
            string[] ids = id.Split(',');
            var bll = new ContractCostBLL();
            foreach(string costId in ids)
            {
                bll.PurchaseApproval(long.Parse(costId), LoginUserId);
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }

        /// <summary>
        /// 采购审批拒绝
        /// </summary>
        /// <param name="context"></param>
        private void PurchaseApprovalReject(HttpContext context)
        {
            var id = context.Request.QueryString["ids"];
            string[] ids = id.Split(',');
            var bll = new ContractCostBLL();
            foreach (string costId in ids)
            {
                bll.PurchaseReject(long.Parse(costId), LoginUserId);
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(true));
        }

        /// <summary>
        /// 配送
        /// </summary>
        /// <param name="context"></param>
        private void PurchaseOrderShip(HttpContext context)
        {
            bool isEditSo = false;
            if (context.Request.QueryString["isEditSo"] == "1")
                isEditSo = true;
            context.Response.Write(new Tools.Serialize().SerializeJson(new InventoryProductBLL().PurchaseShip(context.Request.QueryString["ids"], isEditSo, LoginUserId)));
        }

        /// <summary>
        /// 取消配送
        /// </summary>
        /// <param name="context"></param>
        private void PurchaseOrderUnShip(HttpContext context)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(new InventoryProductBLL().PurchaseUnShip(context.Request.QueryString["ids"], LoginUserId)));
        }

        /// <summary>
        /// 提交采购订单
        /// </summary>
        /// <param name="context"></param>
        private void SubmitPurchaseOrder(HttpContext context)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(new InventoryOrderBLL().SubmitOrder(long.Parse(context.Request.QueryString["id"]), LoginUserId)));
        }

        /// <summary>
        /// 取消采购订单
        /// </summary>
        /// <param name="context"></param>
        private void CanclePurchaseOrder(HttpContext context)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(new InventoryOrderBLL().CancleOrder(long.Parse(context.Request.QueryString["id"]), LoginUserId)));
        }

        /// <summary>
        /// 删除采购订单
        /// </summary>
        /// <param name="context"></param>
        private void DeletePurchaseOrder(HttpContext context)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(new InventoryOrderBLL().DeleteOrder(long.Parse(context.Request.QueryString["id"]), LoginUserId)));
        }

        /// <summary>
        /// 采购订单添加默认采购项
        /// </summary>
        /// <param name="context"></param>
        private void AddPurchaseItemDefault(HttpContext context)
        {
            bool isDefault = "1".Equals(context.Request.QueryString["isDefault"]) ? true : false;
            long vendorId = long.Parse(context.Request.QueryString["vendorId"]);
            var list = new InventoryProductBLL().GetDefaultOrderItems(isDefault, vendorId);
            var items = context.Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;
            if (items != null)
            {
                for (int i = 0; i < list.Count; ++i)
                {
                    list[i].id = items.index++;
                }
                items.items.AddRange(list);
            }

            context.Response.Write(new Tools.Serialize().SerializeJson(""));
		}

		/// <summary>
        /// 判断采购单是否可编辑
        /// </summary>
        private void isEditOrder(HttpContext context)
        {
            bool result = true;
            var id = context.Request.QueryString["id"];
            try
            {
                if (!string.IsNullOrEmpty(id))
                {
                    var thisOrder = new DAL.ivt_order_dal().FindNoDeleteById(long.Parse(id));
                    if(thisOrder!=null&&thisOrder.status_id!=(int)DTO.DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_FULL&& thisOrder.status_id != (int)DTO.DicEnum.PURCHASE_ORDER_STATUS.CANCELED)
                    {
                        result = true;
                    }
                    else
                    {
                        result = false;
                    }
                }
                else
                {
                    result = false;
                }
            }
            catch (Exception)
            {

                result = false;
            }
           
            context.Response.Write(result);

        }

        /// <summary>
        /// 删除采购项
        /// </summary>
        /// <param name="context"></param>
        private void DeletePurchaseItem(HttpContext context)
        {
            long id = long.Parse(context.Request.QueryString["id"]);
            if (new InventoryOrderBLL().DeleteOrderItem(id, LoginUserId))
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(true));
            }
            else
            {
                var items = context.Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;
                var item = items.items.Find(_ => _.id == id);
                if (item == null)
                    context.Response.Write(new Tools.Serialize().SerializeJson(false));
                else
                {
                    items.items.Remove(item);
                    context.Session["PurchaseOrderItem"] = items;
                    context.Response.Write(new Tools.Serialize().SerializeJson(true));
                }
            }
        }

        /// <summary>
        /// 返回采购接收时输入的采购项串号个数
        /// </summary>
        /// <param name="context"></param>
        private void GetPurchaseItemSnCnt(HttpContext context)
        {
            var ids = context.Request.QueryString["ids"].Split(',');
            var sns = context.Session["PurchaseReceiveItemSn"] as Dictionary<long, string>;
            var usns = context.Session["PurchaseUnReceiveItemSn"] as Dictionary<long, string>;
            List<long[]> snsCnt = new List<long[]>();
            foreach (var itemId in ids)
            {
                long id = long.Parse(itemId);
                int cnt;
                if (usns.ContainsKey(id))
                {
                    cnt = sns[id].Split(',').Length;
                    cnt = 0 - cnt;
                }
                else if (sns.ContainsKey(id))
                {
                    sns[id] = sns[id].Replace("\r\n", ",");
                    var idArr = sns[id].Split(',').ToList();
                    idArr.RemoveAll(_ => string.IsNullOrEmpty(_));
                    cnt = idArr.Count;
                }
                else
                    cnt = 0;
                snsCnt.Add(new long[] { id, cnt });
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(snsCnt));
        }

        /// <summary>
        /// 获取采购项的备注和预期到达时间
        /// </summary>
        /// <param name="context"></param>
        private void GetPurchaseItemMemo(HttpContext context)
        {
            var items = context.Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;
            long id = long.Parse(context.Request.QueryString["id"]);
            var item = items.items.Find(_ => _.id == id);
            if (item != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(new string[] { item.note, item.arrivalDate }));
            }
            else
            {
                var pdt = new InventoryOrderBLL().GetOrderProduct(id);
                context.Response.Write(new Tools.Serialize().SerializeJson(new string[] { pdt.note, pdt.estimated_arrival_date == null ? "" : ((DateTime)pdt.estimated_arrival_date).ToString("yyyy-MM-dd") }));
            }
        }

        /// <summary>
        /// 设置采购项备注
        /// </summary>
        /// <param name="context"></param>
        private void SetPurchaseItemMemo(HttpContext context)
        {
            var items = context.Session["PurchaseOrderItem"] as PurchaseOrderItemManageDto;
            long id = long.Parse(context.Request.QueryString["id"]);
            string memo = context.Request.QueryString["memo"];
            string date = context.Request.QueryString["date"];
            var item = items.items.Find(_ => _.id == id);
            if (item != null)
            {
                item.note = memo;
                item.arrivalDate = date;
                context.Session["PurchaseOrderItem"] = items;
                context.Response.Write(new Tools.Serialize().SerializeJson(true));
            }
            else
            {
                var rtn = new InventoryOrderBLL().SaveOrderProductMemo(id, memo, date, LoginUserId);
                context.Response.Write(new Tools.Serialize().SerializeJson(rtn));
            }
        }
    }
}