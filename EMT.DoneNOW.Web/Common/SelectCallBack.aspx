<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SelectCallBack.aspx.cs" Inherits="EMT.DoneNOW.Web.SelectCallBack" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <% foreach (var c in company) { %>
            <input type="text" onclick="GetBack(<%=c.val %>,this);" value="<%=c.show %>"/>
            <%} %>
        </div>
    </form>
    <script>
        function GetBack(val, ipt) {
            window.opener.document.getElementById("companyName").value = ipt.value;
            window.opener.document.getElementById("account_id").value = val;
            window.close();
        }
    </script>
</body>
</html>
