using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// InventoryAjax 的摘要说明
    /// </summary>
    public class InventoryAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var inven_id = context.Request.QueryString["id"];
            switch (action)
            {
                case "delete": Delete(context, Convert.ToInt64(inven_id)); ; break;

                default: break;

            }
        }
        public void Delete(HttpContext context, long inven_id)
        {
            var result = new ProductBLL().DeleteInventory(inven_id, LoginUserId);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("删除成功！");
            }
            else if (result == DTO.ERROR_CODE.SYSTEM)
            {
                context.Response.Write("系统默认不能删除！");
            }
            else
            {
                context.Response.Write("删除失败！");
            }
        }

    }
}