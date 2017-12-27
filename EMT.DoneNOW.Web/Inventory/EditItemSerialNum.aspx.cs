using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class EditItemSerialNum : BasePage
    {
        protected int itemCnt;      // 接收数
        protected long itemId;      // 采购项id
        protected string editSn;    // 多次编辑时前次的值
        protected void Page_Load(object sender, EventArgs e)
        {
            itemId = long.Parse(Request.QueryString["id"]);
            itemCnt = int.Parse(Request.QueryString["num"]);
            if(itemCnt==0)
            {
                Response.End();
                return;
            }
            if(IsPostBack)
            {
                var sns = Session["PurchaseReceiveItemSn"] as Dictionary<long, string>;
                if (itemCnt>0)
                {
                    sns[itemId] = Request.Form["sn"];
                }
                else
                {
                    sns[itemId] = Request.Form["selectedSn"];
                }
                Session["PurchaseOrderItemSn"] = sns;
                Response.Write("<script>window.close();</script>");
                Response.End();
            }
            else
            {
                var sns = Session["PurchaseReceiveItemSn"] as Dictionary<long, string>;
                if (sns.ContainsKey(itemId))
                {
                    editSn = sns[itemId];
                }
            }
        }
    }
}