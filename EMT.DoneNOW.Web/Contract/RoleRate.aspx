<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RoleRate.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.RoleRate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link href="../Content/reset.css" rel="stylesheet" />
  <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="../Content/style.css" />
  <title></title>
</head>
<body>
  <form id="form1" runat="server">
    <div>
      <!--顶部-->
      <div class="TitleBar">
        <div class="Title">
          <span class="text1">新增区域</span>
          <a href="###" class="help"></a>
        </div>
      </div>
      <!--按钮-->
      <div class="ButtonContainer header-title">
        <ul id="btn">
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
            <asp:Button ID="SaveClose" runat="server" Text="保存并关闭" BorderStyle="None" />
          </li>
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
            <asp:Button ID="SaveNew" runat="server" Text="保存并新建" BorderStyle="None" />
          </li>
          <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
            <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" />
          </li>
        </ul>
      </div>
      <div class="DivSection" style="border: none; padding-left: 0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tbody>
            <tr>
              <td width="30%" class="FieldLabels">角色名称
                <div>
                  <asp:DropDownList ID="role_id" runat="server"></asp:DropDownList>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">角色小时费率
                <div>
                  <asp:TextBox ID="role_rate" Enabled="false" runat="server"></asp:TextBox>
                </div>
              </td>
            </tr>
            <tr>
              <td width="30%" class="FieldLabels">合同角色小时费率
                <div>
                  <asp:TextBox ID="rate" runat="server"></asp:TextBox>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </form>
  <script src="../Scripts/jquery-3.1.0.min.js"></script>
</body>
</html>
