<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReceivePurchaseOrder.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.ReceivePurchaseOrder" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>接收/取消接收采购订单</title>
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
  <link href="../Content/index.css" rel="stylesheet" />
  <link href="../Content/style.css" rel="stylesheet" />
  <style>
    .content label {
      width: 130px;
    }
    table th{background-color:#cbd9e4;border-color:#98b4ca;text-align:center;border:1px solid #98b4ca}
    table td{border:1px solid #e8e8fa;}
  </style>
</head>
<body>
  <div class="header">新增采购订单</div>
  <div class="header-title" style="min-width: 400px;">
    <ul>
      <li id="SaveClose">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
        <input type="button" value="保存并关闭" />
      </li>
      <li id="ViewPrint">
        <input type="button" value="打印预览" />
      </li>
      <li id="Cancle">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
        <input type="button" value="取消" />
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div class="content clear" style="margin-left:15px;min-width:660px;">
      <table border="none" cellspacing="" cellpadding="" style="width: 316px;">
        <tr>
          <td style="border:0px;">
            <div class="clear">
              <label>供应商</label>
              <label style="text-align:left;margin-left:15px;"><%=new EMT.DoneNOW.BLL.CompanyBLL().GetCompany(order.vendor_account_id).name %></label>
            </div>
          </td>
        </tr>
        <tr>
          <td style="border:0px;">
            <div class="clear">
              <label>采购订单号</label>
              <label style="text-align:left;margin-left:15px;"><%=order.purchase_order_no %></label>
            </div>
          </td>
        </tr>
        <tr>
          <td style="border:0px;">
            <div class="clear">
              <label>采购订单创建日期</label>
              <label style="text-align:left;margin-left:15px;"><%=EMT.Tools.Date.DateHelper.TimeStampToDateTime(order.create_time).ToString("yyyy-MM-dd hh:mm") %></label>
            </div>
          </td>
        </tr>
      </table>
      <table border="none" cellspacing="" cellpadding="" style="width: 342px;">
        <tr>
          <td style="border:0px;">
            <div class="clear">
              <label>采购订单发票号</label>
              <input type="text" id="vendor_invoice_no" name="vendor_invoice_no" value="<%=order.vendor_invoice_no %>" />
            </div>
          </td>
        </tr>
        <tr>
          <td style="border:0px;">
            <div class="clear">
              <label>采购订单外部编号</label>
              <label style="text-align:left;margin-left:15px;"><%=order.external_purchase_order_no %></label>
            </div>
          </td>
        </tr>
        <tr>
          <td style="border:0px;">
            <div class="clear">
              <label>运费</label>
              <input type="text" id="freight_cost" name="freight_cost" value="<%=order.freight_cost %>" />
            </div>
          </td>
        </tr>
      </table>
    </div>
    <div style="margin-left:15px;margin-right:15px;">
      <input type="button" value="自动填充“接收数”" style="margin:6px 0 5px 0;" onclick="autoCalcReceive()" />
      <% string ids = ""; %>
      <table border="" cellspacing="0" cellpadding="0" style="overflow: scroll; width: 100%; height: 100%;border:1px solid #98b4ca;min-width:1070px;">
        <tr>
          <th style="width:152px;">产品名称</th>
          <th style="width:62px;">仓库</th>
          <th style="width:146px;">销售订单（客户）</th>
          <th style="width:146px;">工单/项目/合同</th>
          <th style="width:70px;">采购数量</th>
          <th style="width:70px;">接收数</th>
          <th style="width:86px;">本次接收数</th>
          <th style="width:86px;">单位成本</th>
          <th style="width:88px;">序列号</th>
          <th style="width:70px;">尚未接收数</th>
          <th style="width:134px;">预计到达日期</th>
        </tr>
        <%if (queryResult.count > 0) {
              EMT.DoneNOW.BLL.InventoryProductBLL bll = new EMT.DoneNOW.BLL.InventoryProductBLL();
              foreach (var rslt in queryResult.result) {
                if (ids == "")
                  ids = rslt["采购项id"].ToString();
                else
                  ids += "," + rslt["采购项id"].ToString();
                var received = bll.GetReceivedCnt(long.Parse(rslt["采购项id"].ToString()));
            %>
        <tr>
          <td><%=rslt["产品名称"] %></td>
          <td><%=rslt["仓库"] %></td>
          <td><%=rslt["销售订单（客户）"] %></td>
          <td><%=rslt["工单或项目或合同"] %></td>
          <td id="orderCnt<%=rslt["采购项id"] %>"><%=rslt["采购数量"] %></td>
          <td><%=received %></td>
          <td><input type="text" style="width:60px;" id="receive<%=rslt["采购项id"] %>" name="receive<%=rslt["采购项id"] %>" /></td>
          <td><input type="text" style="width:60px;" value="<%=rslt["成本"] %>" id="cost<%=rslt["采购项id"] %>" name="cost<%=rslt["采购项id"] %>" /></td>
          <td><%if (bll.IsProductSerialized(long.Parse(rslt["采购项id"].ToString()))) { %><input type="button" value="新增或编辑" onclick='editSerialNum(<%=rslt["采购项id"] %>)' /><%} %></td>
          <td id="unreceivedCnt<%=rslt["采购项id"] %>"><%=int.Parse(rslt["采购数量"].ToString()) - received %></td>
          <td><%=rslt["预计到达日期"] %></td>
        </tr>
        <%}} %>
      </table>
      <input type="hidden" id="itemIds" value="<%=ids %>" />
    </div>
  </form>
  <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../Scripts/common.js"></script>
  <script>
    function editSerialNum(id) {
      var cnt = $("#receive" + id).val();
      if (cnt == 0 || cnt == "")
        return;
      window.open('../Inventory/EditItemSerialNum.aspx?id=<%=Request.QueryString["id"]%>&num=' + cnt, windowObj.inventoryItemSerailNum + windowType.add, 'left=0,top=0,location=no,status=no,width=400,height=500', false);
    }
    function autoCalcReceive() {
      if ($("#itemIds").val() == "") {
        return;
      }
      var ids = $("#itemIds").val().split(",");
      var idRm = "";
      for (i = 0; i < ids.length; i++) {
        $("#receive" + ids[i]).val($("#unreceivedCnt" + ids[i]).text());
      }
    }
    $("#SaveClose").click(function () {
      $("#form1").submit();
    })
    $("#Cancle").click(function () {
      window.close();
    })
  </script>
</body>
</html>
