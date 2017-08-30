<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysRegion.aspx.cs" Inherits="EMT.DoneNOW.Web.SysRegion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>新增区域</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增区域</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_close" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_close_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <asp:Button ID="Save_New" runat="server" Text="保存并新建"  BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancel" runat="server" Text="取消"  BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Name
                        <span class="errorSmall">*</span>
                        <div>
                            <asp:TextBox ID="Region_Name" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Description
                        <div>
                           <asp:TextBox ID="Region_Description" runat="server"></asp:TextBox>
                        </div>
                    </td>

                </tr>
            </tbody>
        </table>
    </div>
        </div>
     <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
        <script>
            $("#Save_close").click(function () {
                if ($("#Region_Name").val() == null || $("#Region_Name").val() == '')
                {
                    alert("请输入区域名称");
                }
            });
            $("#Save_New").click(function () {
                if ($("#Region_Name").val() == null || $("#Region_Name").val() == '') {
                    alert("请输入区域名称");
                }
            });
        </script>
    </form>
</body>
</html>
