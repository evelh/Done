<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CodeRuleManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.CodeRuleManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>规则</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"新增":"编辑" %>规则</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />

                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 100px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                 <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">部门</span>
                                        <div>
                                            <select name="department_id" id="department_id" style="width: 232px;">
                                                <option></option>
                                                <%if (depList != null && depList.Count > 0)
    {
        foreach (var cate in depList)
        {%>
                                                <option value="<%=cate.id %>" <%if (codeRule != null && codeRule.department_id == cate.id)
    {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
    } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">员工</span>
                                        <div>
                                            <select name="resource_id" id="resource_id" style="width: 232px;">
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">客户</span>
                                        <div>
                                            <input type="hidden" id="accountIdHidden" name="account_ids" value="<%=codeRule!=null?codeRule.account_ids:"" %>"/>
                                            <input type="hidden" id="accountId"/>
                                            <select id="accSelect" style="width: 232px;height:100px;" multiple="multiple">
                                            </select>
                                            <a onclick="AccCallBack()"><img src="../Images/data-selector.png" style="height: 20px;width: 20px;float: left;margin-left: 10px;"/></a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">超支政策</span>
                                        <div>
                                            <select name="overdraft_policy_id" id="overdraft_policy_id" style="width: 232px;">
                                                <option></option>
                                                <%if (policyList != null && policyList.Count > 0)
    {
        foreach (var cate in policyList)
        {%>
                                                <option value="<%=cate.id %>" <%if (codeRule != null && codeRule.overdraft_policy_id == cate.id)
    {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
    } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">限制</span>
                                        <div>
                                            <input type="text" id="max" name="max" class="ToDec2" style="width: 220px;" maxlength="11" value="<%=codeRule!=null&&codeRule.max!=null?((decimal)codeRule.max).ToString("#0.00"):"" %>" />
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        GetResByDep();
        GetCompany();
        <%if (codeRule != null) {
        if (codeRule.resource_id != null) {%>
        $("#resource_id").val('<%=codeRule.resource_id %>');
       <% }
    } %>
    })
    $(".ToDec2").blur(function () {
        var thisValue = $(this).val();
        if (!isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }
    })
    $("#department_id").change(function () {
        GetResByDep();
    })
    function GetResByDep() {
        var department_id = $("#department_id").val();
        var html = "<option></option>";
        if (department_id != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResByDepId&depId=" + department_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#resource_id").html(html);
    }

    function AccCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=accountId&muilt=1&callBack=GetCompany", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function GetCompany() {
        var accountId = $("#accountIdHidden").val();
        var html = "";
        if (accountId != null) {
            $.ajax({
                type: "GET",
                url: "../Tools/CompanyAjax.ashx?act=GetAccountByIds&ids=" + accountId,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            html += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                }
            })
        }
        $("#accSelect").html(html);
        $("#accSelect option").dblclick(function () {
            RemoveAccount(this);
        })
            
    }
    function RemoveAccount(val) {
        $(val).remove();
        var ids = "";
        $("#accSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#accountIdHidden").val(ids);
    }
</script>
