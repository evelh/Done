<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteTemplate.test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>

            <label name="label1" for="form1" form="form1" aria-valuemax="200">你好你好</label><input id="Submit1" type="submit" value="submit" />
            <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
        </div>
    </form>
</body>
</html>
