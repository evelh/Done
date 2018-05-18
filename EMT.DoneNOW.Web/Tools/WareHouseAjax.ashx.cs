using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System.Text;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// WareHouse 的摘要说明
    /// </summary>
    public class WareHouseAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "WarehouseProductInfo":
                        WarehouseProductInfo(context);
                        break;
                    default:
                        break;
                }
            }
            catch (Exception)
            {

                context.Response.End();
            }
        }
        /// <summary>
        /// 获取库存产品信息
        /// </summary>
        public void WarehouseProductInfo(HttpContext context)
        {
            var id = context.Request.QueryString["id"];
            if (!string.IsNullOrEmpty(id))
            {
                var thisWarePro = new ivt_warehouse_product_dal().FindNoDeleteById(long.Parse(id));
                if(thisWarePro!=null)
                    context.Response.Write(new Tools.Serialize().SerializeJson(thisWarePro));
            }
        }



    }
}