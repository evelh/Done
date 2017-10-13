<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteAndInvoiceEmailTempl.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteAndInvoiceEmailTempl" %>
<%--发票和报价的邮件模板--%>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:CheckBox ID="Active" runat="server" />激活
            <br />
            下拉框
            <asp:DropDownList ID="VariableList" runat="server"></asp:DropDownList>
        </div>
    </form>
</body>
</html>
