<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CompanyFindBack.aspx.cs" Inherits="EMT.DoneNOW.Web.Common.CompanyFindBack" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%if (accountList != null && accountList.Count > 0)
                {%>

            <table>
                <%
                    foreach (var item in accountList)
                    { %>
                <tr><td>
                <input class="dianji" name="account" type="checkbox" value="<%=item.id %>" /> </td><td><label id="<%=item.id %>"><%=item.name %></label>
                   </td></tr>

                <% } %>
            </table>
            <%} %>

            <%--   <input type="button" id="btnDone" value="选择" />--%>
            <input type="button" id="btnCancel" onclick="window.close();" value="取消" />
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(document).ready(function () {
        $(".dianji").click(function () {
            window.opener.document.getElementById("ParentComoanyNameHide").value = $(this).val();
            window.opener.document.getElementById("ParentComoanyName").value = $(this).parent().next().children().text();
            window.close();
        });
    });
</script>
