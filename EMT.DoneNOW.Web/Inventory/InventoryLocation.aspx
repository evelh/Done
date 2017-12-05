<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InventoryLocation.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.InventoryLocation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link rel="stylesheet" href="../Content/Roles.css" />
  <title><%if (location == null) { %>新增仓库<%} else { %>编辑仓库<%} %></title>
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <div class="TitleBar">
        <div class="Title">
          <span class="text1"><%if (location == null) { %>新增仓库<%} else { %>编辑仓库<%} %></span>
        </div>
      </div>
      <div class="ButtonContainer header-title">
        <ul>
          <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton">
            <span class="Icon SaveAndClone"></span>
            <span class="Text">保存并关闭</span>
          </li>
          <li class="Button ButtonIcon NormalState" id="CancelButton">
            <span class="Icon Cancel"></span>
            <span class="Text">取消</span>
          </li>
        </ul>
      </div>
      <div class="DivSection" style="border: none; padding-left: 0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td width="30%" class="FieldLabels">仓库名称
                <span class="errorSmall">*</span>
                <div>
                  <asp:TextBox ID="name" runat="server"></asp:TextBox>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">
                <div>
                  <asp:CheckBox ID="is_default" runat="server" />
                  默认
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">
                <div>
                  <asp:CheckBox ID="is_active" runat="server" />
                  激活
                </div>
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
    <% if (location != null && location.is_active == 1) { %>
    $("#is_active").change(function () {
      if ($("#is_active").is(':checked') == false) {
        LayerAlert("停用的仓库不能关联产品。 您确定要停用此仓库吗？", "确定", function () { });
      }
    })
    <%} %>
    $("#CancelButton").click(function () {
      window.close();
    })
    $("#SaveAndCloneButton").click(function () {
      if ($("#is_active").is(':checked') == false && $("#is_default").is(':checked') == true) {
        LayerMsg("默认仓库必须激活");
        return;
      }
      if ($("#name").val() == "") {
        LayerMsg("请输入仓库名称");
        return;
      }
      $("#form1").submit();
    })
  </script>
</body>
</html>
