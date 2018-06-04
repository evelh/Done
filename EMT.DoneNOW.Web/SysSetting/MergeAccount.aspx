<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MergeAccount.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.MergeAccount" %>

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
        <div style="margin-left: 20px;">
            <div style="width: 50%; float: left;">
                <table width="100%" cellpadding="5" cellspacing="0" class="Searchareaborder">
                    <tbody>
                        <tr>
                            <td valign="center" align="left" class="FieldLabels" style="padding-left: 10px;">源客户<span class="errorSmall">*</span>
                                <div style="padding-bottom: 10px;">
                                    <input type="text" name="" id="fromAccId" value="<%=fromAccount!=null?fromAccount.name:"" %>" size="32" maxlength="32" style="margin-right:1px" />&nbsp;
                                    <input type="hidden" id="fromAccIdHidden" name="fromAccId" value="<%=fromAccount!=null?fromAccount.id.ToString():"" %>"/>
                                    <a onclick="FromCallBack()"><img src="../Images/data-selector.png" border="0"  width="16" height="16" style="vertical-align: middle;" /></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <!--AccountObjectID-->
                            <td valign="center" width="30%" align="left" class="txtBlack8Class" style="padding-left: 10px; font-weight: normal;">
                                <input type="checkbox" name="ckDel" id="ckDel" <%if (isDel) {%> checked="checked" <%} %> />删除源客户</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div style="width: 50%; float: left;">
                <table width="100%" cellpadding="5" cellspacing="0" class="Searchareaborder">
                    <tbody>
                        <tr>
                            <td valign="center" align="left" class="FieldLabels" style="padding-left: 10px;">目标客户<span class="errorSmall">*</span>
                                <div style="padding-bottom: 10px;">
                                    <input type="text" name="" id="toAccId" value="<%=toAccount!=null?toAccount.name:"" %>" size="32" maxlength="32" style="margin-right:1px" />&nbsp;
                                    <input type="hidden" id="toAccIdHidden" name="toAccId" value="<%=toAccount!=null?toAccount.id.ToString():"" %>"/>
                                    <a onclick="ToCallBack()"><img src="../Images/data-selector.png" border="0"  width="16" height="16" style="vertical-align: middle;" /></a>
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
            <div style="width: 49%; float: left; overflow-x: auto; overflow-y: auto; position: fixed; top: 140px; bottom: 0;">
                <asp:Literal ID="liLeft" runat="server"></asp:Literal>
            </div>
            <div style="width: 49%; float: right; overflow-x: auto; overflow-y: auto; position: fixed; top: 140px; right: 0; bottom: 0;">
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
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=fromAccId&callBack=ToEvent", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    
    function ToCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=toAccId&callBack=ToEvent", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function ToEvent() {
        var toAccId = $("#toAccIdHidden").val();
        var fromAccId = $("#fromAccIdHidden").val();
        var url = "../SysSetting/MergeAccount?fromAccId=" + fromAccId + "&toAccId=" + toAccId;
        if ($("#ckDel").is(":checked")) {
            url += "&isDel=1";
        }
        location.href = url;
    }

    $("#Merge").click(function () {
        var toAccId = $("#toAccIdHidden").val();
        var fromAccId = $("#fromAccIdHidden").val();
        if (fromAccId == "") {
            LayerMsg("请选择源客户！");
            return false;
        }
        if (toAccId == "") {
            LayerMsg("请选择目标客户！");
            return false;
        }
        if (toAccId == fromAccId) {
            LayerMsg("目标客户不能是源客户！");
            return false;
        }
        if (confirm("所有的联系人，商机，销售订单，待办，活动，配置项，项目，工单，备注，合同，附件，是否继续？")) {
            return true;
        }
        else {
            return false;
        }
    })


</script>
