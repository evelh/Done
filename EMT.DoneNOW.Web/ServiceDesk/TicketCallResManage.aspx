<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketCallResManage.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketCallResManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>管理负责人</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <style>
        td{
            text-align:left;
        }
        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
    border-color: #98b4ca;
    background-color: #cbd9e4;
    color: #64727a;
}
        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
    border-right-width: 1px;
    border-right-style: solid;
    font-size: 13px;
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
        .dataGridBody td:first-child, .dataGridAlternating td:first-child, .dataGridBodyHover td:first-child, .dataGridAlternatingHover td:first-child, .dataGridDisabled td:first-child, .dataGridDisabledHover td:first-child {
    border-left-color: #98b4ca;
}
        .dataGridBody tr, .dataGridBodyHover tr, .dataGridAlternating tr, .dataGridAlternatingHover tr, .dataGridBodyHighlight tr, .dataGridGroupBreak tr {
    height: 22px;
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
        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
    border-bottom-color: #98b4ca;
    border-right-color: #98b4ca;
}
 .CKRes{
     margin-left:60px;
 }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">管理负责人</div>
        <div class="header-title">
            <ul>
                <li id="SaveClose">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" id="save_close" value="保存并关闭" />
                </li>
                <li id="Close" onclick="javascript:window.close();">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" id="CloseButton" value="取消" />
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 100px;">
            <div id="dgResources_dgResources_divdata" style="width: 100%; overflow: auto; height: 239px; z-index: 0;">
                <table class="dataGridBody" border="1" id="dgResources_dgResources_datagrid" style="width: 100%; border-collapse: collapse;">
                    <tbody>
                        <tr class="dataGridHeader">
                            <td style="width:150px;text-align:center;"><span>是否是主负责人</span>&nbsp;</td>
                            <td><span>姓名</span>&nbsp;</td>
                            <td  style="width: 150px;text-align:center;">当前服务预定负责人</td>
                        </tr>
                        <%if (priRes != null)
                            { %>
                        <tr class="dataGridBody">
                            <td style="text-align:center;">✔</td>
                            <td><span><span><%=priRes.name %></span><span class="FieldLevelInstruction" style="font-size: 11px; margin-left: 6px;"></span></span></td>
                            <td style="text-align:center;">
                                <span class="txtBlack8Class" ">
                                <%if (resList != null && resList.Count > 0 && resList.Any(_ => _.resource_id == priRes.id))
                                    { %>
                                <input  type="checkbox" name="" class="CKRes" checked="checked" value="<%=priRes.id %>" />
                                <%}
                                 else
                                 { %>
                            <input  type="checkbox" class="CKRes" name="" value="<%=priRes.id %>"/>
                                <%} %>
                                               </span>
                            </td>
                        </tr>
                        <%} %>
                        <%if (ticketRes != null && ticketRes.Count > 0&&resNameList!=null&&resNameList.Count>0)
                            {
                                foreach (var res in ticketRes)
                                {
                                    var thisRes = resNameList.FirstOrDefault(_ => _.id == res.resource_id);
                                    if (thisRes == null)
                                        continue;
                                    %>
                        <tr class="dataGridBody">
                            <td></td>
                            <td><span><span><%=thisRes.name %></span><span class="FieldLevelInstruction" style="font-size: 11px; margin-left: 6px;"></span></span></td>
                            <td style="text-align:center;">
                                <span class="txtBlack8Class" ">
                                <%if ( resList.Any(_ => _.resource_id == res.resource_id))
                                    { %>
                                <input  type="checkbox" class="CKRes" name="" checked="checked" value="<%=res.resource_id %>" />
                                <%}
                                 else
                                 { %>
                            <input  type="checkbox" class="CKRes" name="" value="<%=res.resource_id %>"/>
                                <%} %>
                                               </span>
                            </td>
                        </tr>
                        <%
                                }
                          } %>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script>
    $("#SaveClose").click(function () {
        var ids = "";
        $(".CKRes").each(function () {
            var thisValue = $(this).val();
            if ($(this).is(":checked") && thisValue != "" && thisValue != undefined) {
                ids += thisValue + ',';
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=CallTicketResManage&callTicketId=<%=thisTicketCall.id %>&resIds=" + ids,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功！");
                }
                else {
                    LayerMsg("保存失败！");
                }
                setTimeout(function () { self.opener.location.reload();  window.close(); }, 800);
            },
        });

    })
</script>
