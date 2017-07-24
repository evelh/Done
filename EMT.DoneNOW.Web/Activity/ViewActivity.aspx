<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewActivity.aspx.cs" Inherits="EMT.DoneNOW.Web.Activity.ViewActivity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

        <div class="FeedHeader">
            <div class="null"></div>
            <div class="NewRootNote">
                <textarea placeholder="Add a note..." id="insert"></textarea>
            </div>
            <div class="add clear">
                <span id="WordNumber">2000</span>
                <asp:DropDownList ID="Type" runat="server" Width="100px">
                </asp:DropDownList>
                <asp:Button ID="add" runat="server" Text="添加" />
            </div>
            <div class="checkboxs clear">
                <div class="clear">
                    <label>待办</label>
                    <asp:CheckBox ID="Todos" runat="server" />
                </div>
                <div class="clear">
                    <label>备注</label>
                    <asp:CheckBox ID="Note" runat="server" />
                </div>
                <div class="clear">
                    <label>商机</label>
                    <asp:CheckBox ID="Opportunities" runat="server" />
                </div>
                <div class="clear">
                    <label>销售单</label>
                   <asp:CheckBox ID="SalesOrders" runat="server" />
                </div>
                <div class="clear">
                    <label>工单</label>
                    <asp:CheckBox ID="Tickets" runat="server" />
                </div>
                <div class="clear">
                    <label>合同</label>
                   <asp:CheckBox ID="Contacts" runat="server" />
                </div>
                    <div class="clear">
                    <label>项目</label>
                   <asp:CheckBox ID="Projects" runat="server" />
                </div>
            </div>
            <div class="addselect">
                <div class="clear">
                    <label>排序方式：</label>
              <asp:DropDownList ID="OrderBy" runat="server">
                <asp:ListItem Value="1">时间从早到晚</asp:ListItem>
                <asp:ListItem Value="2">时间从晚到早</asp:ListItem>
            </asp:DropDownList>
                </div>
            </div>
            <hr class="activityTitlerighthr" />
        </div>
        <%--    <table>
                <tr>
                    <td colspan="2">
                        <input type="text" onkeydown="Prompt()"/>
                        <asp:TextBox ID="insert" runat="server" TextMode="MultiLine" MaxLength="1000" Rows="5" Width="500px" Height="25%" Wrap="true" Style="overflow-y: visible"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="padding-right: 5px; padding-top: 10px; width: 350px;">
                        <span id="WordNumber"></span>
                    </td>
                    <td align="right" style="padding-top: 10px;">
                        <%
                           // Type.DataValueField = "val";
                           //  Type.DataTextField = "show";
                           //  Type.DataSource = action_type;
                           //  Type.DataBind();
                           //  Type.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                        %>
                        <asp:DropDownList ID="Type" runat="server" Width="100px">
                        </asp:DropDownList>
                        <asp:Button ID="add" runat="server" Text="添加" /></td>
                </tr>
            </table>--%>

    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        var maxNumber = 2000;
        $("#WordNumber").text(maxNumber);
        $("#insert").keyup(function () {
            var insert = $("#insert").val();
            if (insert != '') {
                var length = insert.length;
                $("#WordNumber").text(maxNumber - length);
                if (length > 2000) {
                    $(this).val($(this).val().substring(0, 2000));
                }
            }

        });
    })
</script>
