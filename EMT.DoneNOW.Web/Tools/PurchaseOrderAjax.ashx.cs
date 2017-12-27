﻿using System;
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
    }
}