<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryItem.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.InventoryItem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link rel="stylesheet" href="../Content/Roles.css" />
  <title><%if (product == null) { %>新增库存产品<%} else { %>编辑库存产品<%} %></title>
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <div class="TitleBar">
        <div class="Title">
          <span class="text1"><%if (product == null) { %>新增库存产品<%} else { %>编辑库存产品<%} %></span>
        </div>
      </div>
      <div class="ButtonContainer header-title">
        <ul>
          <li class="Button ButtonIcon NormalState" id="SaveCloseBtn">
            <span class="Icon SaveAndClone"></span>
            <span class="Text">保存并关闭</span>
          </li>
          <li class="Button ButtonIcon NormalState" id="SaveNewBtn">
            <span class="Icon SaveAndClone"></span>
            <span class="Text">保存并新增</span>
          </li>
          <li class="Button ButtonIcon NormalState" id="CancelBtn">
            <span class="Icon Cancel"></span>
            <span class="Text">取消</span>
          </li>
        </ul>
        <input type="hidden" id="act" name="act" />
      </div>
      <div class="DivSection" style="border: none; padding-left: 20px;width:360px;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td >
                <span class="FieldLabels" style="font-weight: bold;">产品名称<span class="errorSmall">*</span></span>
                  <div>
                    <input type="hidden" id="ProIdHidden" name="product_id" <%if (product != null) { %> value="<%=product.product_id %>" <%} %> />
                    <input type="text" disabled="disabled" id="ProId" style="width: 248px;padding:0;" <%if (product != null) { %> value="<%=product.product_name %>" <%} %> />
                    <img src="../Images/data-selector.png" <%if (product == null) { %> onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=ProId&callBack=GetProduct', '<%=EMT.DoneNOW.DTO.OpenWindow.ServiceSelect %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle; cursor: pointer;" <%} else { %> onclick="javascript:LayerMsg('不能修改产品！');" <%} %> />
                  </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">仓库
                <span class="errorSmall">*</span>
                <div>
                  <select id="warehouse_id" <%if (product == null) { %> name="warehouse_id" <%} else { %> disabled="disabled" <%} %> style="width: 250px;height:26px;">
                    <option value=""></option>
                    <%if (locationList != null) {
                          foreach(var lct in locationList)
                          {%>
                                <option value="<%=lct.id %>" <%if (product != null && product.warehouse_id == lct.id) { %> selected="selected" <%} %> ><%=lct.name %></option>
                          <%}
                        } %>
                  </select>
                  <%if (product != null) { %>
                  <input type="hidden" name="warehouse_id" value="<%=product.warehouse_id %>" />
                  <%} %>
                </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">参考号
                <div>
                  <input type="text" name="reference_number" style="width: 248px;padding:0;" <%if (product != null) { %> value="<%=product.reference_number %>" <%} %> />
                </div>
              </td>
            </tr>
            <tr>
              <td class="FieldLabels">仓位
                <div>
                  <input type="text" name="bin" style="width: 248px;padding:0;" <%if (product != null) { %> value="<%=product.bin %>" <%} %> />
                </div>
              </td>
            </tr>
            <tr>
              <td>
                <table>
                  <tr>
                    <td class="FieldLabels">最小数<span class="errorSmall">*</span>
                      <div style="width:130px;">
                        <input type="text" id="quantity_minimum" name="quantity_minimum" style="width:105px;" <%if (product != null) { %> value="<%=product.quantity_minimum %>" <%} %> />
                      </div>
                    </td>
                    <td class="FieldLabels">最大数<span class="errorSmall">*</span>
                      <div style="width:130px;">
                        <input type="text" id="quantity_maximum" name="quantity_maximum" style="width:105px;" <%if (product != null) { %> value="<%=product.quantity_maximum %>" <%} %> />
                      </div>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr>
              <td>
                <table>
                  <tr>
                    <td class="FieldLabels">库存数量<span class="errorSmall">*</span>
                      <div style="width:130px;">
                        <input type="text" id="quantity" name="quantity" style="width:105px;" <%if (product != null) { %> value="<%=product.quantity %>" <%} %> />
                      </div>
                    </td>
                    <%if (product != null) { %>
                    <td class="FieldLabels">采购中
                      <div style="width:130px;">
                        <div style="padding-bottom:11px;"><%=product.on_order %></div>
                      </div>
                    </td>
                    <%} %>
                  </tr>
                </table>
              </td>
            </tr>
            <%if (product != null) { %>
            <tr>
              <td>
                <table>
                  <tr>
                    <td class="FieldLabels">预留和拣货
                      <div style="width:130px;">
                        <div style="padding-bottom:11px;"><%=product.reserved_picked %></div>
                      </div>
                    </td>
                    <td class="FieldLabels">尚未接收
                      <div style="width:130px;">
                        <div style="padding-bottom:11px;"><%=product.back_order %></div>
                      </div>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <%} %>
            <tr id="snTr" <%if (sn == null) { %> style="display:none;" <%} %>>
              <td class="FieldLabels">产品序列号<span class="errorSmall">*</span>
                <br /><span style="font-size:11px;color:#666;padding:3px 0 3px 0;">每个序列号占一行</span>
                <div style="padding-bottom:6px;">
                  <textarea style="width:236px;height:120px;" id="sn" name="sn"><%=sn %></textarea>
                </div>
                <span id="snCnt">总数：<%=snCnt %></span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script type="text/javascript" src="../Scripts/common.js"></script>
  <script>
    var isSnPd = 0;
    <%if (sn != null) { %>
    isSnPd = 1;
    <%}%>
    $("#sn").change(function () {
      $("#snCnt").text("总数：" + getSNCnt());
    })
    $("#CancelBtn").click(function () {
      window.close();
    })
    $("#SaveCloseBtn").click(function () {
      $("#act").val("SaveClose");
      submitCheck();
    })
    $("#SaveNewBtn").click(function () {
      $("#act").val("SaveNew");
      submitCheck();
    })
    function submitCheck() {
      if ($("#ProIdHidden").val() == "") {
        LayerMsg("请选择产品");
        return;
      }
      if ($("#warehouse_id").val() == null || $("#warehouse_id").val() == "") {
        LayerMsg("请选择仓库");
        return;
      }
      if ($("#quantity_minimum").val() == "") {
        LayerMsg("请输入最小数");
        return;
      }
      if ($("#quantity_maximum").val() == "") {
        LayerMsg("请输入最大数");
        return;
      }
      if ($("#quantity").val() == "") {
        LayerMsg("请输入库存数量");
        return;
      }
      if ($("#quantity").val() == "") {
        LayerMsg("请输入库存数量");
        return;
      }
      if (isSnPd == 1) {
        var snCnt = getSNCnt();
        if (snCnt == 0) {
          LayerMsg("请输入产品序列号");
          return;
        }
        if (snCnt != parseInt($("#quantity").val())) {
          LayerMsg("输入的串号数必须等于库存数！");
          return;
        }
      }
      $("#form1").submit();
    }
    function getSNCnt() {
      var sns = $("#sn").val().split("\n");
      var cnt = 0;
      var tmp;
      for (var i = 0; i < sns.length; ++i) {
        tmp = sns[i].replace("\n", "").replace(/ /g, "");
        if (tmp != "")
          cnt++;
      }
      return cnt;
    }
    function GetProduct() {
      if ($("#ProIdHidden").val() != "") {
        requestData("../Tools/ProductAjax.ashx?act=product&product_id=" + $("#ProIdHidden").val(), null, function (data) {
          if (data.is_serialized == 1) {
            $("#snTr").show();
            isSnPd = 1;
          } else {
            $("#snTr").hide();
            isSnPd = 0;
          }
        });
      }
    }
  </script>
</body>
</html>
