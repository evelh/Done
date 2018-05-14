<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddAccountContactGroup.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.AddAccountContactGroup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css"/>
    <title>添加/移除 联系人组成员</title>
    <style>
        li{
            list-style: None;
        }
        .errorSmallClass{
            color:red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">添加/移除 联系人组成员 - <%=pageAccount.name %></div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="Save()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>保存</li>
                <li onclick="SaveClose()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>保存并关闭</li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>取消</li>
            </ul>
        </div>
        <div style="padding-right: 10px; padding-left: 10px; padding-bottom: 10px; padding-top: 10px; vertical-align: middle">
            <span id="ContactGroupLabel" class="FieldLabel" style="font-weight: bold;">分组</span>
            <span class="errorSmallClass">*</span>&nbsp;
			<span id="ddlContactGroups" style="display: inline-block;">
                <select id="GroupSelect" class="txtBlack8Class" style="width: 300px;">
                    <option value=""></option>
                    <%if (pageGroupList != null && pageGroupList.Count > 0)
                        {
                            foreach (var thisGroup in pageGroupList)
                            {%>
                    <option value="<%=thisGroup.id %>" <%if (pageGroup != null && pageGroup.id == thisGroup.id)
                        { %> selected="selected" <%} %> ><%=thisGroup.name %></option>
                    <%}
                        } %>
                </select>
            </span>
        </div>
        <div id="contactSelectSection" style="padding: 5px">
            <span>
                <table id="_ctl1_ContainerTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td valign="middle" style="align: center;">
                                <table id="_ctl1_LeftListBoxTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span id="_ctl1_LeftListBoxLabel" class="lblNormalClass" style="font-weight: bold;"></span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <select size="15" name="from[]" id="multiselect" class="form-control" multiple="multiple" style="height: 300px; width: 285px;">
                                                    <%if (notInContract != null && notInContract.Count > 0) {
                                                            foreach (var contact in notInContract)
                                                            {%>
                                                    <option value="<%=contact.id %>"><%=contact.name %></option>
                                                            <%}
                                                        } %>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td valign="middle" style="align: center;padding-left:10px;padding-right:10px;">
                                <table id="_ctl1_MiddleButtonTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><button type="button" id="multiselect_rightSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="height: 20px;"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                  <button type="button" id="multiselect_leftSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-left"></i></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td valign="middle" style="align: center;">
                                <table id="_ctl1_RightListBoxTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span id="_ctl1_RightListBoxLabel" class="lblNormalClass" style="font-weight: bold;"></span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <select size="15" name="to[]" id="multiselect_to" class="form-control" multiple="multiple" style="height: 300px; width: 285px;">
                                                     <%if (INContract != null && INContract.Count > 0) {
                                                            foreach (var contact in INContract)
                                                            {%>
                                                    <option value="<%=contact.id %>"><%=contact.name %></option>
                                                            <%}
                                                        } %>
                                                </select></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </span>
            <div><span style="float:left;margin-left: 184px;"><button type="button" id="multiselect_rightAll" class="btn btn-block" style="width:100px;">添加全部&nbsp;<i class="glyphicon glyphicon-forward"></i></button></span>
                <span style="width: 62px;float: left;height: 1px;"></span>
                <span><button type="button" id="multiselect_leftAll" class="btn btn-block" style="width:100px;"><i class="glyphicon glyphicon-backward"></i>&nbsp;移除全部</button></span>
                
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/multiselect.min.js" type="text/javascript" charset="utf-8"></script>
<script>
    jQuery(document).ready(function ($) {
        $('#multiselect').multiselect({
            sort: false
        });
    });
    $(function () {
        <%if (isDisGroup && pageGroup != null) { %>
        $("#GroupSelect").prop("disabled", true);
        <%}%>
    })
    function Save() {
        var groupId = $("#GroupSelect").val();
        if (SaveContact()) {
            location.href = "AddAccountContactGroup?accountId=<%=pageAccount.id %>&groupId=" + groupId;
        }
    }

    function SaveClose() {
        if (SaveContact()) {
            self.opener.location.reload();
            window.close();
        }
    }

    function SaveContact() {
        var groupId = $("#GroupSelect").val();
        if (groupId == "") {
            LayerMsg("请先选择分组！");
            return false;
        }
        var chooseConIds = "";
        $("#multiselect_to option").each(function () {
            chooseConIds += $(this).val()+',';
        })
        if (chooseConIds != "") {
            chooseConIds = chooseConIds.substring(0, chooseConIds.length-1);
        }
        $.ajax({
            type: "GET",
            url: "../Tools/ContactAjax.ashx?act=AccountContractGroupManage&accountId=<%=pageAccount.id %>&groupId=" + groupId + "&ids=" + chooseConIds,
            async: false,
            dataType:"json",
            success: function (data) {
                
            }
        })

        return true;
    }

    $("#GroupSelect").change(function () {
        var groupId = $("#GroupSelect").val();
        location.href = "AddAccountContactGroup?accountId=<%=pageAccount.id %>&groupId=" + groupId;
    })
    
</script>
