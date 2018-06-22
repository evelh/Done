<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AcceptOfferWidget.aspx.cs" Inherits="EMT.DoneNOW.Web.AcceptOfferWidget" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>接收小窗口-<%=wgtName %></title>
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="accept" runat="server" Text="接收" style="border-style:None;width: 64px;height: 26px;font-size: 16px;background-color: #faf3f3;border:1px solid #e3e3e3" OnClick="save_Click" BorderStyle="None" />
            <asp:Button ID="decline" runat="server" Text="拒绝" style="border-style:None;width: 64px;height: 26px;font-size: 16px;background-color: #faf3f3;border:1px solid #e3e3e3" OnClick="decline_Click" BorderStyle="None" />
        </div>
        <div style="margin:10px;position: fixed;top: 30px;left: 0;right: 0;bottom: 0;">
            <p><%=resName %>分享了一个小窗口（<%=wgtName %>）给你，如果接收，请先选择仪表板。</p>
            <asp:DropDownList runat="server" ID="dashboardList" style="width: 200px;height: 24px;">

            </asp:DropDownList>
        </div>
    </form>
    <script>
        window.parent.close();
    </script>
</body>
</html>
