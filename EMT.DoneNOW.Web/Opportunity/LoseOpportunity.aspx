<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoseOpportunity.aspx.cs" Inherits="EMT.DoneNOW.Web.Opportunity.LoseOpportunity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Button ID="finish" runat="server" Text="结束" OnClick="finish_Click" />
        <div>
            <asp:DropDownList ID="opportunity" runat="server"></asp:DropDownList>
            
            <asp:DropDownList ID="stage_id" runat="server"></asp:DropDownList>

            <asp:DropDownList ID="resource_id" runat="server"></asp:DropDownList>
        </div>
        
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
