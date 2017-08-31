<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OpportunityStage.aspx.cs" Inherits="EMT.DoneNOW.Web.OpportunityStage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>商机阶段</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增商机阶段</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_Close" OnClientClick="save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <asp:Button ID="Save_New" OnClientClick="save_deal()" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
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
                            <asp:TextBox ID="Name" runat="server" style="width:400px;"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Description
                        <div>
                            <asp:TextBox ID="Description" runat="server" style="width:400px;height:80px;" TextMode="MultiLine"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div>
                            <asp:CheckBox ID="Won" runat="server" />
                            Default stage for won opportunities
                        </div>
                        <div>
                           <asp:CheckBox ID="Lost" runat="server" />
                            Default stage for lost opportunities
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Sort Order
                        <span class="errorSmall">*</span>
                        <div>
                            <asp:TextBox ID="Sort_Order" runat="server" style="width:200px;"></asp:TextBox>
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
        function save_deal() {
            if ($("#Name").val() == null || $("#Name").val() == '')
            {
                alert("请输入商机阶段的名称！");
                return false;
            }
            if ($("#Sort_Order").val() == null || $("#Sort_Order").val() == '') {
                alert("请输入商机阶段的Sort_Order！");
                return false;
            }
        }
    </script>
</body>
</html>
