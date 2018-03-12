<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuickAddNote.aspx.cs" Inherits="EMT.DoneNOW.Web.Activity.QuickAddNote" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>新增备注</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <link rel="stylesheet" href="../Content/Roles.css" />
    <link rel="stylesheet" href="../Content/LostOpp.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">新增备注</span>
                </div>
            </div>
            <div class="ButtonContainer">
                <ul>
                    <li class="Button ButtonIcon NormalState" id="SaveClose" tabindex="0">
                        <span class="Icon SaveAndClone"></span>
                        <span class="Text">保存并关闭</span>
                    </li>
                    <li class="Button ButtonIcon NormalState" onclick="javascript:window.close();" tabindex="0">
                        <span class="Icon Cancel"></span>
                        <span class="Text">取消</span>
                    </li>
                </ul>
            </div>
            <div class="DivSection" style="border: none; padding-left: 0;">
                <div>
                    <textarea id="desc" name="desc" style="width: 200px; height: 100px;" placeholder="添加一个备注..."></textarea>
                </div>
                <%if (cate == 2)
                { %>
                <input type="checkbox" <%if (string.IsNullOrEmpty(resouceName))
                    { %> disabled="disabled" <%} %> name="isNotify" />通知<%=resouceName %>
                <%} %>
                <%if (isTicket)
                    { %>
                <input type="checkbox" name="inter" />内部用户

                <select name="ticketNoteType">
                    <%if (ticketNoteTypeList != null && ticketNoteTypeList.Count > 0)
                        {
                            foreach (var ticketNoteType in ticketNoteTypeList)
                            {
                    %>
                    <option value="<%=ticketNoteType.id %>"><%=ticketNoteType.name %></option>
                    <% }
                        } %>
                </select>
                <%} %>
            </div>
            <input type="hidden" name="cate" value="<%=cate %>" />
            <input type="hidden" name="level" value="<%=level %>" />
            <input type="hidden" name="objType" value="<%=objType %>" />
            <input type="hidden" name="objectId" value="<%=objectId %>" />
        </div>
    </form>
    <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../Scripts/common.js"></script>
    <script>
        $("#SaveClose").click(function () {
            if ($("#desc").val() == "") {
                LayerMsg("请输入备注信息");
                return;
            }
            $("#form1").submit();
        })
    </script>
</body>
</html>
