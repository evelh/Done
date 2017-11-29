using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// SaleOrderAjax 的摘要说明
    /// </summary>
    public class SaleOrderAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            string action = DNRequest.GetQueryString("act");
            switch (action)
            {
                case "status":
                    var soid = context.Request.QueryString["id"];
                    var status = context.Request.QueryString["status_id"];
                    ChangeSaleOrderStatus(context, long.Parse(soid), int.Parse(status));
                    break;

                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    return;
            }
        }
        /// <summary>
        /// 更改销售订单的状态
        /// </summary>
        /// <param name="context"></param>
        /// <param name="soid"></param>
        /// <param name="status_id"></param>
        private void ChangeSaleOrderStatus(HttpContext context, long soid, int status_id)
        {
            if (status_id == 469)
            {
                if (AuthBLL.GetUserSaleorderAuth(LoginUserId, LoginUser.security_Level_id, soid).CanDelete == false)
                {
                    return;
                }
            }
            var result = new SaleOrderBLL().UpdateSaleOrderStatus(soid, status_id, LoginUserId);
            context.Response.Write(result);
        }


    }
}