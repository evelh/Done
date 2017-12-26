using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL;

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
                case "createPurchaseOrder":
                    break;
                case "isEditOrder":
                    isEditOrder(context);
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
    }
}