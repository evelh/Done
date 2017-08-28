<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TerritortAddAccount.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.TerritortAddAccount" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save" runat="server" Text="保存"  BorderStyle="None" OnClick="Save_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
            <div>
                <asp:ListBox ID="AccountList" runat="server" SelectionMode="Multiple" Height="400px" Width="150px"></asp:ListBox>
            </div>            
        </div>
    </form>
    <script>
    </script>
</body>
</html>
