<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RejectPurchase.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.RejectPurchase" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Button ID="btReject" runat="server" Text="拒绝" Height="23px" OnClick="btReject_Click" Width="54px" />
        <div style="margin:10px 0 0 16px;width:236px;">
          <asp:Label ID="Label1" runat="server" Text="Label" Width="100%">拒绝采购审批的原因<span style="color:red;">*</span></asp:Label>
          <asp:TextBox ID="TextBox1" runat="server" Width="100%" Height="99px" TextMode="MultiLine"></asp:TextBox>
        </div>
    </form>
</body>
</html>
