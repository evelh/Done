<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeleteContact.aspx.cs" Inherits="EMT.DoneNOW.Web.DeleteContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>删除联系人</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="Delete" runat="server" Text="删除客户" BorderStyle="None" OnClick="deleteContact()" />                    
                </li>              
            </ul>
        </div>
    </form>

    <script>
        function deleteContact() {
            if (confirm("确认要删除吗？")) {

            } else {
                return false;
            }
        }
    </script>
</body>
</html>
