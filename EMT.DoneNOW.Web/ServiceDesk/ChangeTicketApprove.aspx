<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChangeTicketApprove.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.ChangeTicketApprove" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>变更单审批</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
              <div class="TitleBar">
                <div class="Title">
                    <span class="text1">变更单审批</span>
                </div>
            </div>
              <div class="ButtonContainer header-title" style="margin:0;">
                <ul id="btn">
                    <li id="saveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input type="button" value="批准" style="width:38px;" onclick="Approval()" />
                    </li>
                    <li id="Close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" value="拒绝" style="width: 30px;" onclick="Refuse()"/>
                    </li>
                </ul>
            </div>
            <div style="padding-left: 10px;">
                <textarea id="reason" style="width: 200px;height: 100px;"><%=thisOther!=null?thisOther.description:"" %></textarea>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    function Approval() {
        var reason = $("#reason").val();
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=OtherPersonManage&ticket_id=<%=thisTicket.id %>&is_app=1&reason=" + reason,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("审批成功！");
                }
            }
        })
        setTimeout(function () { window.close(); self.parent.location.reload(); }, 800);
    }

    function Refuse() {
        var reason = $("#reason").val();
        if (reason == "") {
            LayerMsg("请填写审批说明！");
            return;
        }
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=OtherPersonManage&ticket_id=<%=thisTicket.id %>&reason=" + reason,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("拒绝成功！");
                }
            }
        })
        setTimeout(function () { window.close(); self.parent.location.reload(); }, 800);
    }
</script>
