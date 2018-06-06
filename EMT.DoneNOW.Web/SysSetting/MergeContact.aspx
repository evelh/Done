<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MergeContact.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.MergeContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title></title>
    <style>
        .errorSmall {
            color: red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="TransLi">
                    <asp:Button ID="Merge" runat="server" BorderStyle="None" Text="合并" OnClick="Merge_Click" />
                </li>
            </ul>
        </div>
        <div style="margin-left: 30px;">
            <p style="">客户<span class="errorSmall">*</span></p>
            <div style="padding-bottom: 10px;">
                <input type="text" name="" id="accountId" value="<%=account!=null?account.name:"" %>" size="32" maxlength="32" style="margin-right: 1px" />&nbsp;
                <input type="hidden" id="accountIdHidden" name="accountId" value="<%=account!=null?account.id.ToString():"" %>" />
                <a onclick="AccountCallBack()">
                    <img src="../Images/data-selector.png" border="0" width="16" height="16" style="vertical-align: middle;" />
                </a>
            </div>
        </div>
        <div style="margin-left: 20px;">
            <div style="width: 50%; float: left;">
                <table width="100%" cellpadding="5" cellspacing="0" class="Searchareaborder">
                    <tbody>
                        <tr>
                            <td valign="center" align="left" class="FieldLabels" style="padding-left: 10px;">源联系人<span class="errorSmall">*</span>
                                <div style="padding-bottom: 10px;">
                                    <input type="text" name="" id="fromConId" value="<%=fromContact!=null?fromContact.name:"" %>" size="32" maxlength="32" style="margin-right: 1px" />&nbsp;
                                    <input type="hidden" id="fromConIdHidden" name="fromConId" value="<%=fromContact!=null?fromContact.id.ToString():"" %>" />
                                    <a onclick="FromCallBack()">
                                        <img src="../Images/data-selector.png" border="0" width="16" height="16" style="vertical-align: middle;" /></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <!--AccountObjectID-->
                            <td valign="center" width="30%" align="left" class="txtBlack8Class" style="padding-left: 10px; font-weight: normal;">
                                <input type="checkbox" name="ckDel" id="ckDel" <%if (isDel)
                                    {%> checked="checked" <%} %> />删除源联系人</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div style="width: 50%; float: left;">
                <table width="100%" cellpadding="5" cellspacing="0" class="Searchareaborder">
                    <tbody>
                        <tr>
                            <td valign="center" align="left" class="FieldLabels" style="padding-left: 10px;">目标联系人<span class="errorSmall">*</span>
                                <div style="padding-bottom: 10px;">
                                    <input type="text" name="" id="toConId" value="<%=toContact!=null?toContact.name:"" %>" size="32" maxlength="32" style="margin-right: 1px" />&nbsp;
                                    <input type="hidden" id="toConIdHidden" name="toConId" value="<%=toContact!=null?toContact.id.ToString():"" %>" />
                                    <a onclick="ToCallBack()">
                                        <img src="../Images/data-selector.png" border="0" width="16" height="16" style="vertical-align: middle;" /></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td height="30">&nbsp;</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <div style="margin-left: 20px;">
            <div style="width: 49%; float: left; overflow-x: auto; overflow-y: auto; position: fixed; top: 190px; bottom: 0;">
                <asp:Literal ID="liLeft" runat="server"></asp:Literal>
            </div>
            <div style="width: 49%; float: right; overflow-x: auto; overflow-y: auto; position: fixed; top: 190px; right: 0; bottom: 0;">
                <asp:Literal ID="liRight" runat="server"></asp:Literal>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    function FromCallBack() {
        var accountId = $("#accountIdHidden").val();
        if (accountId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=fromConId&callBack=ToEvent&con628=" + accountId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else
        {
            LayerMsg("请先选择客户");
        }
        
    }

    function ToCallBack() {
        var accountId = $("#accountIdHidden").val();
        if (accountId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=toConId&callBack=ToEvent&con628=" + accountId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择客户");
        }
    }
    function ToEvent() {
        var accountId = $("#accountIdHidden").val();
        var toConId = $("#toConIdHidden").val();
        var fromConId = $("#fromConIdHidden").val();
        var url = "../SysSetting/MergeContact?fromConId=" + fromConId + "&toConId=" + toConId + "&accountId=" + accountId;
        if ($("#ckDel").is(":checked")) {
            url += "&isDel=1";
        }
        location.href = url;
    }

    function AccountCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&callBack=AccountCall", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function AccountCall() {
        $("#fromConId").val("");
        $("#fromConIdHidden").val("");
        $("#toConId").val("");
        $("#toConIdHidden").val("");
        ToEvent();
    }

    $("#Merge").click(function () {
        var toConId = $("#toConIdHidden").val();
        var fromConId = $("#fromConIdHidden").val();
        if (fromConId == "") {
            LayerMsg("请选择源联系人！");
            return false;
        }
        if (toConId == "") {
            LayerMsg("请选择目标联系人！");
            return false;
        }
        if (toConId == fromConId) {
            LayerMsg("目标联系人不能是源联系人！");
            return false;
        }
        return true;
    })

</script>
