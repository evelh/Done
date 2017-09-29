<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractType.aspx.cs" Inherits="EMT.DoneNOW.Web.ContractType" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
     <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>合同类型</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">合同类型</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul id="btn">
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        名称
                        <span class="errorSmall">*</span>
                        <div>
                            <asp:TextBox ID="Name" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                       描述
                        <div>
                            <asp:TextBox ID="Description" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                 <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <asp:CheckBox ID="Active" runat="server" />
                            激活
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
    <script>
        $("#Save_Close").click(function () {
            var t = $("#Name").val();
            if (t == null || t == '') {
                alert("请填写合同类别名称");
                return false;
            }
        });
    </script>

</body>
</html>
