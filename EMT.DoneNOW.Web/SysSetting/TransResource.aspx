<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransResource.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.TransResource" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title></title>
    <style>
        .errorSmall{
            color:red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="Trans"><%--<i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>--%>
                    <asp:Button ID="Trans" runat="server" BorderStyle="None" Text="转移" OnClick="Trans_Click" />
                </li>
            </ul>
        </div>
        <div style="margin-left:20px;">
            <div style="width:50%;float:left;">
                <table width="100%" cellpadding="0" cellspacing="0" class="Searchareaborder" style="padding-left: 10px;">
                    <tbody>
                        <tr>
                            <td valign="center" align="left" class="FieldLabels">转移员工<span class="errorSmall">*</span>
                                <div style="padding-bottom: 10px;">
                                     <asp:DropDownList ID="ddLeftRes" runat="server" Width="190px" OnSelectedIndexChanged="ddLeftRes_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div style="width:50%;float:left;">
                 <table width="100%" cellpadding="0" cellspacing="0" class="Searchareaborder" style="padding-left: 10px;">
                    <tbody>
                        <tr>
                            <td valign="center" align="left" class="FieldLabels">目标员工<span class="errorSmall">*</span>
                                <div style="padding-bottom: 10px;">
                                    <asp:DropDownList ID="ddRightRes" runat="server" Width="190px" OnSelectedIndexChanged="ddRightRes_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div style="margin-left:20px;">
             <div style="width:49%;float:left;overflow-x: auto;overflow-y: auto;position: fixed;top: 108px;bottom:0;">
                 <asp:Literal ID="liLeft" runat="server"></asp:Literal>
             </div>
             <div style="width:49%;float:right;overflow-x: auto;overflow-y: auto;position: fixed;top: 108px;right: 0;bottom: 0;">
                 <asp:Literal ID="liRight" runat="server"></asp:Literal>
             </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#Trans").click(function () {
        var ddLeftRes = $("#ddLeftRes").val();
        var ddRightRes = $("#ddRightRes").val();
        if (ddLeftRes == "") {
            LayerMsg("请选择转移员工！");
            return false;
        }
        if (ddRightRes == "") {
            LayerMsg("请选择目标员工！");
            return false;
        }
        if (confirm("所有的客户，未关闭/未实施/未丢失的商机，未完成的待办和活动将移交，是否继续？")) {
            return true;
        }
        else {
            return false;
        }
        
    })
</script>
