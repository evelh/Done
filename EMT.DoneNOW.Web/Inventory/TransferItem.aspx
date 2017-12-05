<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransferItem.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.TransferItem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link href="../Content/Roles.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="../Content/style.css" />
  <title>库存转移</title>
</head>
<body>
  <div class="TitleBar">
    <div class="Title">
      <span class="text1">库存转移</span>
    </div>
  </div>
  <div class="ButtonContainer header-title">
    <ul>
      <li class="Button ButtonIcon NormalState" id="SaveCloseBtn">
        <span class="Icon SaveAndClone"></span>
        <span class="Text">保存并关闭</span>
      </li>
      <li class="Button ButtonIcon NormalState" id="CancelBtn">
        <span class="Icon Cancel"></span>
        <span class="Text">取消</span>
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div class="DivSection" style="border: none; padding-left: 20px;">
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tbody>
          <tr>
            <td width="30%" class="FieldLabels">
              <table border="0">
                <tbody>
                  <tr>
                    <td valign="top">产品名称
                      <div style="padding-bottom: 15px;">
                        <span class="lblNormalClass" style="font-weight: normal;">
                          <label><%=product.product_name %></label>
                        </span>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">
              <table border="0">
                <tbody>
                  <tr>
                    <td valign="top">库存位置
                      <div style="padding-bottom: 15px;">
                        <span class="lblNormalClass" style="font-weight: normal;">
                          <label><%=product.location_name %></label>
                        </span>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">
              <table border="0">
                <tbody>
                  <tr>
                    <td style="width: 120px;">移库数量
                      <span class="errorSmall">*</span>
                      <div>
                        <asp:TextBox ID="remove_quantity" runat="server"></asp:TextBox>
                      </div>
                    </td>
                    <td valign="top"><span style="padding-left:10px;">可用数</span>
                      <div style="padding-bottom: 15px;padding-left:10px;">
                        <span class="lblNormalClass" style="font-weight: normal;">
                          <label id="quantity"><%=product.quantity-int.Parse(product.reserved_picked)+int.Parse(product.picked)+int.Parse(product.picked) %></label></span>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">目标库存位置
              <span class="errorSmall">*</span>
              <div>
                <select id="warehouse_id" name="warehouse_id" style="width:215px;height:26px;">
                  <option value=""></option>
                    <%if (locationList != null) {
                          foreach (var lct in locationList)
                          {
                            if (lct.id == product.warehouse_id)
                              continue;
                                %>
                          <option value="<%=lct.id %>" <%if (backLocation != 0 && lct.id == backLocation) { %> selected="selected" <%} %> ><%=lct.name %></option>
                      <%}
                    } %>
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td width="30%" class="FieldLabels">备注
              <div>
                <asp:TextBox ID="note" runat="server" Style="height: 100px; width: 200px; margin-top: 0px; margin-bottom: 0px;" TextMode="MultiLine"></asp:TextBox>
              </div>
            </td>
          </tr>
          <tr id="snTr" <%if (!is_serialized) { %> style="display:none;" <%} %>>
            <td class="FieldLabels">产品序列号<span class="errorSmall">*</span>
              <br /><span style="font-size:11px;color:#666;padding:3px 0 3px 0;color:red;">这个产品是序列化的，请选择你想要转移的产品序列号。</span>
              <div style="padding-bottom:6px;">
                <textarea style="width:236px;height:120px;" id="sn" name="sn" readonly="readonly"><%=backSn %></textarea>
                <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=1561&muilt=1&con1121=<%=product.id %>&field=pdtSn&callBack=GetProductSn', '<%=EMT.DoneNOW.DTO.OpenWindow.ServiceSelect %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle; cursor: pointer;" />
              </div>
              <asp:HiddenField ID="pdtSnHidden" runat="server" />
              <asp:HiddenField ID="pdtSn" runat="server" />
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </form>
  <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
  <script type="text/javascript" src="../Scripts/common.js"></script>
  <script>
    $("#CancelBtn").click(function () {
      window.close();
    })
    $("#SaveCloseBtn").click(function () {
      if ($("#remove_quantity").val() == "") {
        LayerMsg("请输入移库数量");
        return;
      }
      if ($("#warehouse_id").val() == "") {
        LayerMsg("请选择目标库存位置");
        return;
      }
      <%if (is_serialized) { %>
      if (pdtCnt == 0) {
        LayerMsg("请选择您想要移库的产品序列号！");
        return;
      }
      if (parseInt($("#remove_quantity").val()) != pdtCnt) {
        LayerMsg("选择的移库产品序列号个数应等于移库数量！");
        return;
      }
      <%} %>
      $("#form1").submit();
    })
    $("#remove_quantity").change(function () {
      if ((/^\d{1,15}$/.test(this.value)) == false) {
        LayerMsg("只能输入整数！");
        this.value = '';
        this.focus();
        return false;
      } else {
        var q1 = $("#remove_quantity").val();
        var q2 = $("#quantity").text();
        q1 = parseInt(q1);
        if (q1 <= 0) {
          LayerMsg("移库数量应该大于0！");
          this.value = '';
          this.focus();
          return false;
        }
        q2 = parseInt(q2);
        if (q1 > q2) {
          LayerMsg("移库数量只能小于等于可用数！");
          this.value = '';
          this.focus();
          return false;
        }
      }
    });
    <%if (is_serialized) { %>
    var pdtCnt = 0;
    function GetProductSn() {
      var sns = $("#pdtSn").val();
      if (sns == "") {
        $("#sn").text("");
        return;
      }
      snList = sns.split(',');
      var sntext = "";
      pdtCnt = snList.length;
      for (var i = 0; i < snList.length; i++) {
        sntext = sntext + snList[i] + "\n";
      }
      $("#sn").text(sntext);
    }
    <%} %>
  </script>
</body>
</html>
