<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeleteMasterTicket.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.DeleteMasterTicket" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>删除定期主工单</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <style>
        .PageLevelInstructions span {
    font-size: 12px;
    color: #666;
    line-height: 16px;
}
        #txtBlack8 {
    font-size: 12px;
    color: #333;
    font-weight: 100;
}
        .PageLevelInstructions {
    padding: 0 10px 12px 10px;
    margin-left:15px;
}
        input[type=radio] {
    vertical-align: middle;
    margin-right: 3px;
    padding: 0;
    margin-top: -2px;
}
        table.PageLevelInstructions tbody tr td {
    text-align: left;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">删除定期主工单</div>
        <div class="header-title">
            <ul>
                <li id="SaveNew">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" id="delete" value="删除" />
                </li>
                <li id="Close">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" id="CloseButton" value="取消" />
                </li>
            </ul>
        </div>
        <table width="100%" height="30" cellspacing="5" cellpadding="0" border="0" class="PageLevelInstructions">
            <tbody>
                <tr>
                    <td align="left" colspan="3" id="txtBlack8" style="padding-bottom: 10px;"><span>请选择删除选项:</span></td>
                </tr>
                <tr>
                    <td align="left" id="txtBlack8" style="padding-bottom: 10px;">
                        <input type="radio" id="delete_1" name="recurringDeleteOption" checked="" /><span>删除全部可以删除的子工单.</span></td>
                </tr>
                <tr>
                    <td align="left" id="txtBlack8">
                        <input type="radio" id="delete_2" name="recurringDeleteOption" value="2" /><span>删除全部未到期且可以删除的工单.</span></td>
                </tr>
            </tbody>
        </table>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script>
    
    $("#Close").click(function () {
        window.close();
    })
    $("#SaveNew").click(function () {
        var isDeleteFuture = "";
        if ($("#delete_2").is(":checked")) {
            isDeleteFuture = "1";
        }
        var ticketId = '<%=ticket.id %>';
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=DeleteMasterTicket&ticket_id=" + ticketId + "&delete_future=" + isDeleteFuture,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg(data.dic["delete"] + "个子工单被删除<br />" + data.dic["no_delete"] +"个子工单不能删除<br />定期主工单被删除");
                    }
                    else {
                        LayerMsg(data.dic["delete"] + "个子工单被删除<br />" + data.dic["no_delete"] + "个子工单不能删除<br />定期主工单未被删除");
                    }
                }
                setTimeout(function () { window.close(); self.opener.location.reload(); }, 1200);
            },
        });
    })
</script>
