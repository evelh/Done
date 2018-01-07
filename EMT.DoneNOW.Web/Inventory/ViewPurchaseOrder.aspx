<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewPurchaseOrder.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.ViewPurchaseOrder" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>查看采购订单</title>
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
  <link href="../Content/index.css" rel="stylesheet" />
  <link href="../Content/style.css" rel="stylesheet" />
  <style>
    label {
      font-weight: normal;
      font-size: 12px;
    }
    .lableLeft {
      width: 110px;
      font-weight: bold;
      padding-left: 10px;
      text-align:left;
    }
    .itemTable td{text-align:left;border:solid 1px #d3d3d3;}
    .itemTable th{text-align:left;border:solid 1px #d3d3d3;}
    .infoTable td{text-align:left;vertical-align:top;}
  </style>
</head>
<body>
  <div class="header">查看采购订单</div>
  <div class="header-title" style="min-width: 400px;">
    <ul>
      <li id="Print">
        <input type="button" value="打印" />
      </li>
      <li id="Close" onclick="javascript:window.close();">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
        <input type="button" value="关闭" />
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div style="width: 660px;">
      <div style="margin-top: 60px; margin-left: 340px;">
        <label style="font-size: 20px;">采购订单</label><br />
        <label style="width: 130px;">采购订单号</label><label><%=order.purchase_order_no %></label><br />
        <%if (!string.IsNullOrEmpty(order.external_purchase_order_no)) { %>
        <label style="width: 130px;">外部采购订单号</label><label><%=order.external_purchase_order_no %></label><br />
        <%} %>
        <label style="width: 130px;">采购订单创建日期</label><label><%= EMT.Tools.Date.DateHelper.TimeStampToDateTime(order.create_time).ToString("yyyy-MM-dd") %></label><br />
      </div>
      <div style="width: 100%; padding: 20px 20px 20px 40px;">
        <table>
          <tr>
            <td style="width: 50%;">
              <div style="width: 90%;">
                <% var vendor = new EMT.DoneNOW.BLL.CompanyBLL().GetCompany(order.vendor_account_id);
                    var location = new EMT.DoneNOW.BLL.LocationBLL().GetLocation(order.location_id);
                    var dstDal = new EMT.DoneNOW.DAL.d_district_dal();
                    var addr = dstDal.FindById(location.province_id).name + dstDal.FindById(location.city_id).name;
                    if (location.district_id != null)
                      addr += dstDal.FindById((int)location.district_id).name;
                    %>
                <table class="infoTable">
                  <tr>
                    <td style="width:40%;">收货地址</td>
                    <td><span><%=location.location_label %></span><br /><span><%=addr %></span><br /><span><%=location.address %></span></td>
                  </tr>
                  <tr>
                    <td style="width:40%;">收货电话</td>
                    <td><%=order.phone %></td>
                  </tr>
                  <%if (!string.IsNullOrEmpty(order.fax)) { %>
                  <tr>
                    <td style="width:40%;">收货传真</td>
                    <td><%=order.fax %></td>
                  </tr>
                  <%} %>
                  <%if (order.shipping_type_id!=null) { %>
                  <tr>
                    <td style="width:40%;">配送类型</td>
                    <td><%=new EMT.DoneNOW.BLL.GeneralBLL().GetSingleGeneral((int)order.shipping_type_id).name %></td>
                  </tr>
                  <%} %>
                  <%if (order.expected_ship_date!=null) { %>
                  <tr>
                    <td style="width:40%;">配送日期</td>
                    <td><%=((DateTime)order.expected_ship_date).ToString("yyyy-MM-dd") %></td>
                  </tr>
                  <%} %>
                  <%if (!string.IsNullOrEmpty(order.note)) { %>
                  <tr>
                    <td style="width:40%;">备注</td>
                    <td><%=order.note %></td>
                  </tr>
                  <%} %>
                </table>
              </div>
            </td>
            <td style="width: 50%;vertical-align:top;">
              <div style="width: 100%;">
                <table>
                  <%if (!string.IsNullOrEmpty(order.vendor_invoice_no)) { %>
                  <tr>
                    <td>供应商发票号</td>
                    <td><%=order.vendor_invoice_no %></td>
                  </tr>
                  <%} %>
                  <%if (order.payment_term_id!=null) { %>
                  <tr>
                    <td>支付期限</td>
                    <td><%=new EMT.DoneNOW.BLL.GeneralBLL().GetSingleGeneral((int)order.payment_term_id).name %></td>
                  </tr>
                  <%} %>
                  <tr>
                    <td>供应商名称</td>
                    <td><%=vendor.name %></td>
                  </tr>
                  <tr>
                    <td>供应商电话</td>
                    <td><%=vendor.phone %></td>
                  </tr>
                </table>
              </div>
            </td>
          </tr>
        </table>
      </div>
      <div style="width: 100%; padding: 0 35px 60px 35px;">
        <table class="itemTable" >
          <tr>
            <th>产品</th>
            <th>描述</th>
            <th>供应商/厂商产品编号</th>
            <th>成本</th>
            <th>采购数量</th>
            <th>总价</th>
          </tr>
          <%
              decimal totalCost = 0;
              foreach (var item in items) {
                var pdt = new EMT.DoneNOW.BLL.ProductBLL().GetProduct(item.product_id);
                decimal cost = (pdt.unit_cost == null ? 0 : ((decimal)(pdt.unit_cost) * item.quantity));
                totalCost += cost;
                string note = "";
                if (order.item_desc_display_type_id == (int)EMT.DoneNOW.DTO.DicEnum.INVENTORY_ORDER_ITEM_DISPLAY_TYPE.PRODUCT_NOTE)
                  note = pdt.description;
                else if (order.item_desc_display_type_id == (int)EMT.DoneNOW.DTO.DicEnum.INVENTORY_ORDER_ITEM_DISPLAY_TYPE.CHARGE_NOTE && item.contract_cost_id != null)
                  note = new EMT.DoneNOW.DAL.ctt_contract_cost_dal().FindById((long)item.contract_cost_id).description;
                else if (order.item_desc_display_type_id == (int)EMT.DoneNOW.DTO.DicEnum.INVENTORY_ORDER_ITEM_DISPLAY_TYPE.QUOTE_NOTE)
                  note = "";
                  %>
          <tr>
            <td><%=pdt.name %></td>
            <td><%=note %></td>
            <td><%=pdt.manu_product_no %></td>
            <td><%=pdt.unit_cost %></td>
            <td><%=item.quantity %></td>
            <td><%=cost %></td>
          </tr>
          <%} %>
          <tr>
            <td colspan="5" style="text-align:right;">总额</td>
            <td><%=totalCost %></td>
          </tr>
        </table>
      </div>
      <div style="padding-left:180px;">
        <label style="font-size:14px;">签字</label><label style="border-bottom:solid 1px #d3d3d3;width:280px;">&nbsp;</label>
        <label style="font-size:14px;">日期</label><label style="border-bottom:solid 1px #d3d3d3;width:80px;">&nbsp;</label>
      </div>
    </div>
  </form>
</body>
</html>
