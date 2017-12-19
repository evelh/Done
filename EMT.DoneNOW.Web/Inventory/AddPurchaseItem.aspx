<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddPurchaseItem.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.AddPurchaseItem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>采购项</title>
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
  <link href="../Content/index.css" rel="stylesheet" />
  <link href="../Content/style.css" rel="stylesheet" />
  <style>
    .content label{width:120px;}
  </style>
</head>
<body>
  <div class="header">采购项</div>
  <div class="header-title" style="min-width: 700px;">
    <ul>
      <li id="SaveClose">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
        <input type="button" value="保存并关闭" />
      </li>
      <li onclick="javascript:window.close()">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
        <input type="button" value="取消" />
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div>
      <div class="content clear">
        <table border="none" cellspacing="" cellpadding="" style="width: 404px;">
          <tr>
            <td>
              <div class="clear">
                <label>产品名称<span class="red">*</span></label>
                <input type="text" id="product" name="product" readonly="readonly" <%if (!isAdd) { %> value="<%=new EMT.DoneNOW.BLL.ProductBLL().GetProduct(product.product_id).name %>" <%} %> style="float:left;" />
                <input type="hidden" id="productHidden" name="product_id" <%if (!isAdd) { %> value="<%=product.product_id %>" <%} %> />
                <i onclick="window.open('../Common/SelectCallBack?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=product','_blank','left=200,top=200,width=900,height=750', false);" style="width: 20px; height: 20px; float: left; margin-left: 2px; margin-top: 6px; background: url(../Images/data-selector.png) no-repeat;"></i>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>仓库<span class="red">*</span></label>
                <select id="warehouse_id" name="warehouse_id">
                  <option></option>
                  <% foreach (var lct in warehosreList) { %>
                  <option value="<%=lct.id %>" <%if (!isAdd && product.warehouse_id == lct.id) { %> selected="selected" <%} %> ><%=lct.name %></option>
                  <%} %>
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>采购数量<span class="red">*</span></label>
                <input type="text" id="quantity" name="quantity" <%if (!isAdd) { %> value="<%=product.quantity %>" <%} %> />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>成本</label>
                <input type="text" id="unit_cost" name="unit_cost" <%if (!isAdd) { %> value="<%=product.unit_cost %>" <%} %> />
              </div>
            </td>
          </tr>
          </table>
        </div>
    </div>
  </form>
  <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../Scripts/common.js"></script>
  <script>
    $("#SaveClose").click(function () {
      if ($("#productHidden").val() == "") {
        LayerMsg("请选择产品");
        return;
      }
      if ($("#warehouse_id").val() == "") {
        LayerMsg("请选择仓库");
        return;
      }
      if ($("#quantity").val() == "") {
        LayerMsg("请输入采购数量");
        return;
      }
      $("#form1").submit();
    })
  </script>
</body>
</html>
