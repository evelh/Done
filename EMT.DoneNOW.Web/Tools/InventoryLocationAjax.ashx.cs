using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// InventoryLocationAjax 的摘要说明
    /// </summary>
    public class InventoryLocationAjax : BaseAjax
    {
        private BLL.InventoryLocationBLL bll = new BLL.InventoryLocationBLL();
        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            var inven_id = context.Request.QueryString["id"];
            switch (action)
            {
                case "getInfo":
                    GetInfo(context, Convert.ToInt64(inven_id));
                    break;
                case "delete":
                    Delete(context, Convert.ToInt64(inven_id));
                    break;
                case "setDefault":
                    SetDefault(context, Convert.ToInt64(inven_id));
                    break;
                case "setActive":
                    SetActive(context, Convert.ToInt64(inven_id));
                    break;
                case "setInactive":
                    SetInactive(context, Convert.ToInt64(inven_id));
                    break;
                case "GetLocationList":
                    GetLocationList(context);
                    break;
                default:
                    break;

            }
        }

        private void Delete(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.DeleteLocation(id, LoginUserId)));
        }

        private void GetInfo(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.GetLocationInfo(id, LoginUserId)));
        }

        private void SetDefault(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.SetLocationDefault(id, LoginUserId)));
        }

        private void SetActive(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.SetLocationIsActive(id, true, LoginUserId)));
        }

        private void SetInactive(HttpContext context, long id)
        {
            context.Response.Write(new Tools.Serialize().SerializeJson(bll.SetLocationIsActive(id, false, LoginUserId)));
        }

        private void GetLocationList(HttpContext context)
        {
            var wareList = bll.GetLocationListUnResource();
            if (wareList != null && wareList.Count > 0)
            {
                var wareID = context.Request.QueryString["ware_id"];
                if (!string.IsNullOrEmpty(wareID))
                {
                    var thisWare = wareList.FirstOrDefault(_ => _.id.ToString() == wareID);
                    if (thisWare != null)
                    {
                        wareList.Remove(thisWare);
                    }
                }
                context.Response.Write(new Tools.Serialize().SerializeJson(wareList));
            }
        }
    }
}