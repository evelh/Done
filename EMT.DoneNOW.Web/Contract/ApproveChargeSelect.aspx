<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApproveChargeSelect.aspx.cs" Inherits="EMT.DoneNOW.Web.ApproveChargeSelect" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None"/><br /><br />
            <asp:Button ID="Button1" runat="server" Text="自动生成预付费" BorderStyle="None"/><br /><br />
            <asp:Button ID="Button2" runat="server" Text="强制生成（不够的部分单独生成一个条目）" BorderStyle="None"/><br /><br />
        </div>
    </form>
</body>
</html>
