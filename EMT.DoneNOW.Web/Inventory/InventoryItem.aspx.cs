﻿using System;
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
    public partial class InventoryItem : BasePage
    {
        protected InventoryItemEditDto product;
        protected string sn = null;             // 产品序列号
        protected bool isSerialized = false;    // 是否序列化产品
        protected int snCnt = 0;
        protected long productId = 0;   // 初始化的产品id
        protected string productName;   // 初始化的产品名称
        protected List<ivt_warehouse> locationList;
        private InventoryProductBLL bll = new InventoryProductBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request.QueryString["id"];
            if (!IsPostBack)
            {
                if (!string.IsNullOrEmpty(id))  // 编辑
                {
                    long pdId = Convert.ToInt64(id);
                    product = bll.GetIvtProductEdit(pdId);
                    isSerialized = new ProductBLL().GetProduct(product.product_id).is_serialized == 1;
                    var snList = bll.GetProductSnList(pdId);
                    if (snList != null && snList.Count > 0)
                    {
                        snCnt = snList.Count;
                        foreach (var s in snList)
                            sn += s.sn + "\n";
                    }
                    locationList = new InventoryLocationBLL().GetLocationList();
                }
                else    // 新增
                {
                    if (!string.IsNullOrEmpty(Request.QueryString["pdtId"]))
                    {
                        productId = long.Parse(Request.QueryString["pdtId"]);
                        var pdt = new ProductBLL().GetProduct(productId);
                        productName = pdt.name;
                        isSerialized = pdt.is_serialized == 1;
                    }
                    locationList = new InventoryLocationBLL().GetLocationListUnResource();
                }
            }
            else
            {
                var pdt = AssembleModel<ivt_warehouse_product>();
                string sn = Request.Form["sn"];
                if (string.IsNullOrEmpty(id))
                {
                    bll.AddIvtProduct(pdt, sn, LoginUserId);
                }
                else
                {
                    pdt.id = Convert.ToInt64(id);
                    bll.EditIvtProduct(pdt, sn, LoginUserId);
                }
                if ("SaveNew".Equals(Request.Form["act"]))
                {
                    Response.Write("<script>window.location.href='InventoryItem.aspx';self.opener.location.reload();</script>");
                    Response.End();
                }
                else
                {
                    Response.Write("<script>window.close();self.opener.location.reload();</script>");
                    Response.End();
                }
            }
        }
    }
}