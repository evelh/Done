using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Inventory
{
    public partial class ReceivePurchaseOrder : BasePage
    {
        protected QueryResultDto queryResult;
        protected ivt_order order;
        private InventoryOrderBLL bll = new InventoryOrderBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            long orderId = 0;
            if(!string.IsNullOrEmpty(Request.QueryString["id"]))
                orderId = long.Parse(Request.QueryString["id"]);
            string itemIds = Request.QueryString["ids"];
            List<ivt_order_product> items = null;
            
            if (!string.IsNullOrEmpty(itemIds))
            {
                items = bll.GetPurchaseItems(itemIds);
                if (items == null || items.Count == 0)
                {
                    Response.End();
                    return;
                }
                long ordId = items[0].order_id;
                foreach (var itm in items)
                {
                    if (itm.order_id != ordId)
                    {
                        Response.Write("<script>alert('一次只能接收同一个采购订单的采购项');window.close();</script>");
                        Response.End();
                    }
                }
                orderId = ordId;
                Session["PurchaseReceiveItem"] = items;
            }
            else if (orderId == 0)
            {
                Response.End();
                return;
            }
            order = bll.GetPurchaseOrder(orderId);

            QueryCommonBLL queryBll = new QueryCommonBLL();
            QueryParaDto queryPara = new QueryParaDto();
            queryPara.query_params = new List<Para>();
            queryPara.query_params.Add(new Para { id = 1171, value = orderId.ToString() });
            queryPara.query_type_id = (long)QueryType.PurchaseItem;
            queryPara.para_group_id = 160;
            queryPara.page = 1;
            queryPara.page_size = 500;
            queryResult = queryBll.GetResult(0, queryPara);
            if(!string.IsNullOrEmpty(itemIds))
            {
                for (int idx = queryResult.result.Count - 1; idx >= 0; --idx)
                {
                    if (!items.Exists(_ => _.id.ToString() == (queryResult.result[idx]["采购项id"]).ToString()))
                    {
                        queryResult.result.RemoveAt(idx);
                        queryResult.count = queryResult.count - 1;
                    }
                }
            }

            if (!IsPostBack)
            {
                Session["PurchaseReceiveItemSn"] = new Dictionary<long, string>();
            }
            else
            {
                List<InventoryOrderReceiveItemDto> itemList = new List<InventoryOrderReceiveItemDto>();
                var sns = Session["PurchaseReceiveItemSn"] as Dictionary<long, string>;
                foreach (var itm in queryResult.result)
                {
                    InventoryOrderReceiveItemDto recvItem = new InventoryOrderReceiveItemDto();
                    recvItem.id = long.Parse(itm["采购项id"].ToString());

                    var cost = Request.Form["cost" + recvItem.id];
                    var recvCnt = Request.Form["receive" + recvItem.id];
                    if (string.IsNullOrEmpty(recvCnt) || int.Parse(recvCnt) == 0)
                        continue;

                    recvItem.count = int.Parse(recvCnt);
                    recvItem.cost = string.IsNullOrEmpty(cost) ? 0 : decimal.Parse(cost);

                    if (sns[recvItem.id] != null)
                    {
                        recvItem.sns = sns[recvItem.id].Split(',').ToList();
                    }
                }
                if (itemList.Count==0)
                {
                    Response.Write("<script>alert('请选择接收项');</script>");
                    return;
                }
                decimal freight_cost = 0;
                if (!string.IsNullOrEmpty(Request.Form["freight_cost"]))
                    freight_cost = decimal.Parse(Request.Form["freight_cost"]);

                bll.OrderReceive(orderId, Request.Form["vendor_invoice_no"], freight_cost, itemList, LoginUserId);
                Response.Write("<script>window.close();self.opener.location.reload();</script>");
                Response.End();
            }
        }
    }
}