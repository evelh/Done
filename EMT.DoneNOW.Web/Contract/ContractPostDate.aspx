<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractPostDate.aspx.cs" Inherits="EMT.DoneNOW.Web.ContractPostDate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>输入提交日期</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <style>
        /*加载的css样式*/
#BackgroundOverLay{
    width:100%;
    height:100%;
    background: black;
    opacity: 0.6;
    z-index: 25;
    position: absolute;
    top: 0;
    left: 0;
    display: none;
}
#LoadingIndicator {
    width: 100px;
    height:100px;
    background-image: url(../Images/Loading.gif);
    background-repeat: no-repeat;
    background-position: center center;
    z-index: 30;
    margin:auto;
    position: absolute;
    top:0;
    left:0;
    bottom:0;
    right: 0;
    display: none;
}
    </style>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <div class="TitleBar">
        <div class="Title">
            <span class="text1">输入提交日期</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon" style="margin: 0;width: 0;"></span>
                <asp:Button ID="Post" OnClientClick="return kkk()" runat="server" Text="审批并提交" BorderStyle="None" OnClick="Post_Click" />
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels" style="padding:  0 0 10px 10px;">
                        <div style="padding: 0;">
                            请输入提交日期
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels" style="padding:  0 0 10px 10px;font-weight: normal;">
                        选择日期
                        <span class="errorSmall">*</span>
                        <div>
                            <input id="post_datett" name="post_datett" type="text" style="width:100px;" onclick="WdatePicker()" class="Wdate"/>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
<%--加载--%>
<div id="BackgroundOverLay"></div>
<div id="LoadingIndicator"></div>
            <input type="hidden" name="post_date" id="post_date" />
            <script src="../Scripts/jquery-3.1.0.min.js"></script>
            <script src="../Scripts/SysSettingRoles.js"></script>
            <script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
            <script>
                function kkk() {
                   var k = $("#post_datett").val();
                    if (k == null || k == '') {
                        alert("请选择提交日期！");
                        return false;
                    }
                    k = k.replace(/[^0-9]+/g, '');
                    $("#post_date").val(k);
                    load();
                }
                function load() {
                    $("#BackgroundOverLay").show();
                    $("#LoadingIndicator").show();
                }
            </script>
        </div>
    </form>
</body>
</html>
