<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="syscopy.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.syscopy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
            <asp:Button ID="Button2" runat="server" Text="2222" OnClick="Button2_Click" />
            <div>
                <table class="kkkk"><tr><td runat="server">222</td></tr></table>
            </div>
        </div>
    </form>
    <script>

        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=delete&id=" + entityid,
                success: function (data) {
                    alert(data);
                }

            })
        }
    </script>
</body>
</html>
