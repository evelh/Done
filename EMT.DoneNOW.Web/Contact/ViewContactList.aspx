<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewContactList.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.ViewContactList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>联系人操作 - 当前所选联系人</title>
    <style>
        li {
            list-style: None;
        }

        .errorSmallClass {
            color: red;
        }

        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
            border-right-width: 1px;
            border-right-style: solid;
            font-size: 12px;
            font-weight: bold;
            height: 19px;
            padding: 4px;
            vertical-align: top;
            word-wrap: break-word;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        .dataGridHeader {
            border-left: outset 1px;
            border-right: outset 1px;
            border-bottom: outset 1px;
            font-size: 9px;
            font-weight: bold;
            color: #555;
            text-decoration: none;
            height: 25px;
            background-color: #cbd9e4;
            vertical-align: top;
        }

        .dataGridBody td, .dataGridAlternating td, .dataGridBodyHover td, .dataGridAlternatingHover td, .dataGridDisabled td, .dataGridDisabledHover td {
            border-width: 1px;
            border-style: solid;
            border-left-color: #F8F8F8;
            border-right-color: #F8F8F8;
            border-top-color: #e8e8e8;
            border-bottom-width: 0;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: top;
            padding: 4px;
            word-wrap: break-word;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            background-color: white;
            border-left-width: 0;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: middle;
            padding: 10px 0 4px 0;
            vertical-align: top;
            word-wrap: break-word;
            border-right-width: 1px;
            border-right-style: solid;
        }

        .windowshade td {
            border-width: 1px;
            border-style: solid;
            border-left-color: white;
            border-right-color: white;
            border-top-color: white;
            border-bottom-width: 0;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: top;
            padding: 4px;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">联系人操作 - 当前所选联系人</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div id="timeEntryGrid_timeEntryGrid_divgrid" class="GridContainer" style="padding-left:10px;padding-right:10px;">
            <div id="timeEntryGrid_timeEntryGrid_divdata" showheader="true" style="width: 100%;">
                <table class="dataGridBody" cellspacing="0" rules="all" border="1" id="timeEntryGrid_timeEntryGrid_datagrid" style="width: 100%; border-collapse: collapse; border-bottom-color: white;">
                    <tbody>
                        <tr class="dataGridHeader">
                            <%
                                string[] orderThArr = null;
                                if (!string.IsNullOrEmpty(sortOrder))
                                {
                                    orderThArr = sortOrder.Split('_');
                                }
                            %>
                            <td style="text-align: left" onclick="ChangeOrder('name','<%=sortOrder != null && orderThArr[0] == "name"&&orderThArr[1] == "asc"?"desc":"asc" %>')">名称
                                                                <%if (sortOrder != null && orderThArr[0] == "name")
                                                                    { %>
                                <img src="../Images/sort-<%=orderThArr[1] == "desc" ? "desc" : "asc" %>.png" />
                                <%} %>
                            </td>
                            <td style="text-align: left" onclick="ChangeOrder('email','<%=sortOrder != null && orderThArr[0] == "email"&&orderThArr[1] == "asc"?"desc":"asc" %>')">邮箱
                                                                <%if (sortOrder != null && orderThArr[0] == "email")
                                                                    { %>
                                <img src="../Images/sort-<%=orderThArr[1] == "desc" ? "desc" : "asc" %>.png" />
                                <%} %>
                            </td>
                            <td style="text-align: left" onclick="ChangeOrder('title','<%=sortOrder != null && orderThArr[0] == "title"&&orderThArr[1] == "asc"?"desc":"asc" %>')">标题
                                                                <%if (sortOrder != null && orderThArr[0] == "title")
                                                                    { %>
                                <img src="../Images/sort-<%=orderThArr[1] == "desc" ? "desc" : "asc" %>.png" />
                                <%} %>
                            </td>
                        </tr>
                        <%if (conList != null && conList.Count > 0)
                            {
                                foreach (var contact in conList)
                                {%>
                        <tr class="rightMenu">
                            <td><%=contact.name %></td>
                            <td><%=contact.email %></td>
                            <td><%=contact.title %></td>
                        </tr>
                        <%}
                            }
                            else
                            {%>
                        <tr>
                            <td colspan="8" style="text-align: center; color: red;">暂无数据</td>
                        </tr>
                        <%} %>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script>

    function ChangeOrder(type, order) {
        if (order == "") {
            order = "asc";
        }
        var sortOrder = type + "_" + order;
        location.href = "ViewContactList?ids=<%=conIds %>&sortOrder=" + sortOrder;
    }
</script>
