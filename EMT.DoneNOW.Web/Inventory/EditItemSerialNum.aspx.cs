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
        protected string editId;    // 多次编辑时取消接收的串号id
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
                var usns = Session["PurchaseUnReceiveItemSn"] as Dictionary<long, string>;
                if (itemCnt>0)
                {
                    sns[itemId] = Request.Form["sn"];
                    if (usns.ContainsKey(itemId))
                    {
                        usns.Remove(itemId);
                    }
                }
                else
                {
                    sns[itemId] = Request.Form["selectedSn"];
                    usns[itemId] = Request.Form["selectedSnNum"];
                }
                Session["PurchaseOrderItemSn"] = sns;
                Session["PurchaseUnReceiveItemSn"] = usns;
                Response.Write("<script>window.close();</script>");
                Response.End();
            }
            else
            {
                var sns = Session["PurchaseReceiveItemSn"] as Dictionary<long, string>;
                var usns = Session["PurchaseUnReceiveItemSn"] as Dictionary<long, string>;
                if (usns.ContainsKey(itemId))   // 上次编辑为取消接收串号
                {
                    if (itemCnt < 0)
                    {
                        editId = sns[itemId];
                        editSn = usns[itemId];
                    }
                }
                else if (sns.ContainsKey(itemId))   // 上次编辑为接收串号
                {
                    if (itemCnt > 0)
                    {
                        editSn = sns[itemId];
                    }
                }
            }
        }
    }
}