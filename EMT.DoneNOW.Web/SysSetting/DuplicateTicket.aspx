<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DuplicateTicket.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.DuplicateTicket" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>重复工单处理</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <style>
        .content input[type='text'] {
            height: 24px;
        }

        .content input[type='radio'] {
            height: 13px;
            width: 13px;
        }
        input[type="checkbox"], input[type="radio"]{
            /*margin-right:-10px;*/
        }

        td {
            height: 20px;
        }
        .lblNormalClass{
            /*font-weight:bold;*/
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">重复工单处理</span>
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
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 90px;">
            <div class="content clear">
                <div class="information clear">
                    <p class="lblNormalClass">重复工单定义</p>
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td style="min-width: 500px;"><span style="font-weight: bold; margin-left: 10px;">定义重复工单为：</span></td>
                                    <td colspan="3"></td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div>
                                            <input type="checkbox" id="isSameNo" style="margin-top: 0px;" name="isSameNo" <%if (dto.SameNo)
                                                {%>
                                                checked="checked" <%} %> />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                    </td>
                                    <td colspan="3"></td>

                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div>
                                            <input type="checkbox" id="isSameAlertId" style="margin-top: 0px;" name="isSameAlertId" <%if (dto.SameAlertId)
                                                {%>
                                                checked="checked" <%} %> />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                    </td>
                                    <td colspan="3"></td>

                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div>
                                            <input type="checkbox" id="isSameExter" style="margin-top: 0px;" name="isSameExter" <%if (dto.SameExter)
                                                {%>
                                                checked="checked" <%} %> />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                    </td>
                                    <td colspan="3"></td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div>
                                            <input type="checkbox" id="isSameTitleConfig" style="margin-top: 0px;" name="isSameTitleConfig"  />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text" class="SameTitleConfig" name="SameTitleConfigDay" value="<%=dto.SameTitleConfigDay %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled" maxlength="3"  />
                                        <span style="margin-left: 0px;">天</span>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text"  class="SameTitleConfig Hours" name="SameTitleConfigHours" value="<%=dto.SameTitleConfigHours %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled"  />
                                        <span style="margin-left: 0px;">小时</span>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text"  class="SameTitleConfig Minut" name="SameTitleConfigMin" value="<%=dto.SameTitleConfigMin %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled"  />
                                        <span style="margin-left: 0px;">分钟</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div>
                                            <input type="checkbox" id="isSameTitle" style="margin-top: 0px;" name="isSameTitle" />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text" class="SameTitle" name="SameTitleDay" value="<%=dto.SameTitleDay %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;"  disabled="disabled" maxlength="3" />
                                        <span style="margin-left: 0px;">天</span>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text" class="SameTitle Hours" name="SameTitleHours" value="<%=dto.SameTitleHours %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled"  />
                                        <span style="margin-left: 0px;">小时</span>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text" class="SameTitle Minut" name="SameTitleMin" value="<%=dto.SameTitleMin %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled"  />
                                        <span style="margin-left: 0px;">分钟</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left: 20px;">
                                        <div>
                                            <input type="checkbox" id="isSameConfig" style="margin-top: 0px;" name="isSameConfig"  />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text" class="SameConfig" name="SameConfigDay" value="<%=dto.SameConfigDay %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled"  maxlength="3" />
                                        <span style="margin-left: 0px;">天</span>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text" class="SameConfig Hours" name="SameConfigHours" value="<%=dto.SameConfigHours %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled"  />
                                        <span style="margin-left: 0px;">小时</span>
                                    </td>
                                    <td style="min-width: 60px;">
                                        <input type="text" class="SameConfig Minut" name="SameConfigMin" value="<%=dto.SameConfigMin %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width: 45px;" disabled="disabled" />
                                        <span style="margin-left: 0px;">分钟</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear">
                <div class="information clear">
                    <p  class="lblNormalClass">重复工单活动</p>
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td style="min-width: 500px;"><span style="font-weight: bold; margin-left: 10px;">当找到重复的工单时：</span></td>

                                </tr>
                                <tr>
                                    <td>
                                        <div style="margin-left: 15px;">
                                            <input type="radio" id="rdAsNote" style="margin-top: 0px;" name="SameAction" checked="checked" value="AsNote" />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                        <div style="margin-left: 30px;" id="AsNoteDiv">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input type="checkbox" id="isFirstComplete" style="margin-top: 0px;" name="isFirstComplete" />
                                                            <span style="margin-left: 0px;">激活</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <select id="isFirstCompleteStatusId" name="isFirstCompleteStatusId" disabled="disabled">
                                                            <option></option>
                                                            <%if (stausList != null && stausList.Count > 0)
                                                                {
                                                                    foreach (var status in stausList)
                                                                    {%>
                                                            <option value="<%=status.id %>" <%if (dto.CompleteStatusId == status.id)
                                                                {%> selected="selected" <% } %>><%=status.name %></option>
                                                            <% }
                                                                } %>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input type="checkbox" id="isFirstOtherThanComplete" style="margin-top: 0px;" name="isFirstOtherThanComplete"  />
                                                            <span style="margin-left: 0px;">激活</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <select id="isFirstOtherThanCompleteStatusId" name="isFirstOtherThanCompleteStatusId"  disabled="disabled">
                                                            <option></option>
                                                            <%if (stausList != null && stausList.Count > 0)
                                                                {
                                                                    foreach (var status in stausList)
                                                                    {%>
                                                            <option value="<%=status.id %>" <%if (dto.NoCompleteStatusId == status.id)
                                                                {%> selected="selected" <% } %>><%=status.name %></option>
                                                            <% }
                                                                } %>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="margin-left: 15px;">
                                            <input type="radio" id="rdAsInclide" style="margin-top: 0px;" name="SameAction" value="AsInclide" />
                                            <span style="margin-left: 0px;">激活</span>
                                        </div>
                                        <div style="margin-left: 30px; display: none;" id="AsInclideDiv">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input type="checkbox" id="isSecondComplete" style="margin-top: 0px;" name="isSecondComplete"  />
                                                            <span style="margin-left: 0px;">激活</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <select id="isSecondCompleteStatusId" name="isSecondCompleteStatusId"  disabled="disabled">
                                                            <option></option>
                                                            <%if (stausList != null && stausList.Count > 0)
                                                                {
                                                                    foreach (var status in stausList)
                                                                    {%>
                                                            <option value="<%=status.id %>" <%if (dto.CompleteStatusId == status.id)
                                                                {%> selected="selected" <% } %>><%=status.name %></option>
                                                            <% }
                                                                } %>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <div>
                                                            <input type="checkbox" id="isSecondOtherThanComplete" style="margin-top: 0px;" name="isSecondOtherThanComplete" />
                                                            <span style="margin-left: 0px;">激活</span>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <select id="isSecondOtherThanCompleteStatusId" name="isSecondOtherThanCompleteStatusId"  disabled="disabled">
                                                            <option></option>
                                                            <%if (stausList != null && stausList.Count > 0)
                                                                {
                                                                    foreach (var status in stausList)
                                                                    {%>
                                                            <option value="<%=status.id %>" <%if (dto.NoCompleteStatusId == status.id)
                                                                {%> selected="selected" <% } %>><%=status.name %></option>
                                                            <% }
                                                                } %>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div  style="margin-left: 15px;">
                                            <input type="radio" id="rdNoAction" style="margin-top: 0px;" name="SameAction" value="NoAction" />
                                            <span style="margin-left: 0px;">激活</span>
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

    $(".Hours").blur(function () {
        var thisValue = $(this).val();
        if (!isNaN(thisValue)) {
            if (Number(thisValue) > 23) {
                LayerMsg("小时数不能超过23小时");
                $(this).val("23");
            }
            else if (Number(thisValue) < 0) {
                LayerMsg("小时数不能小于0小时");
                $(this).val("0");
            }
        }
        else {
            $(this).val("");
        }
    })

    $(".Minut").blur(function () {
        var thisValue = $(this).val();
        if (!isNaN(thisValue)) {
            if (Number(thisValue) >59) {
                LayerMsg("分钟数不能超过59分钟");
                $(this).val("59");
            }
            else if (Number(thisValue) < 0) {
                LayerMsg("分钟数不能小于0分钟");
                $(this).val("0");
            }
        }
        else {
            $(this).val("");
        }
    })

    $("#isSameTitleConfig").click(function () {
        if ($(this).is(":checked")) {
            $(".SameTitleConfig").prop("disabled", false);
        }
        else {
            $(".SameTitleConfig").prop("disabled", true);
        }
    })
    $("#isSameTitle").click(function () {
        if ($(this).is(":checked")) {
            $(".SameTitle").prop("disabled", false);
        }
        else {
            $(".SameTitle").prop("disabled", true);
        }
    })
    $("#isSameConfig").click(function () {
        if ($(this).is(":checked")) {
            $(".SameConfig").prop("disabled", false);
        }
        else {
            $(".SameConfig").prop("disabled", true);
        }
    })


    $("#rdAsNote").click(function () {
        $("#AsNoteDiv").show();
        $("#AsInclideDiv").hide();
    })
    $("#isFirstComplete").click(function () {
        if ($(this).is(":checked")) {
            $("#isFirstCompleteStatusId").prop("disabled", false);
        }
        else {
            $("#isFirstCompleteStatusId").prop("disabled", true);
        }
    })
    $("#isFirstOtherThanComplete").click(function () {
        if ($(this).is(":checked")) {
            $("#isFirstOtherThanCompleteStatusId").prop("disabled", false);
        }
        else {
            $("#isFirstOtherThanCompleteStatusId").prop("disabled", true);
        }
    })
    $("#rdAsInclide").click(function () {
        $("#AsNoteDiv").hide();
        $("#AsInclideDiv").show();
    })
    $("#isSecondComplete").click(function () {
        if ($(this).is(":checked")) {
            $("#isSecondCompleteStatusId").prop("disabled", false);
        }
        else {
            $("#isSecondCompleteStatusId").prop("disabled", true);
        }
    })
    $("#isSecondOtherThanComplete").click(function () {
        if ($(this).is(":checked")) {
            $("#isSecondOtherThanCompleteStatusId").prop("disabled", false);
        }
        else {
            $("#isSecondOtherThanCompleteStatusId").prop("disabled", true);
        }
    })
    $("#rdNoAction").click(function () {
        $("#AsNoteDiv").hide();
        $("#AsInclideDiv").hide();
    })



    $(function () {
        <%if (dto.SameTitleConfig)
    { %>
         $("#isSameTitleConfig").trigger("click");
        <%} %>

         <%if (dto.SameTitle)
    { %>
        $("#isSameTitle").trigger("click");
        <%} %>

         <%if (dto.SameConfig)
    { %>
        $("#isSameConfig").trigger("click");
        <%} %>

        <%if (dto.actionValue == "AsNote") {
        %>
        $("#rdAsNote").trigger("click");
        $("#isSecondCompleteStatusId").val("");
        $("#isSecondOtherThanCompleteStatusId").val("");
        <%if (dto.NoteComplete)
    { %>
        $("#isFirstComplete").trigger("click");
        <%} %>
           <%if (dto.NoteNoComplete)
    { %>
        $("#isFirstOtherThanComplete").trigger("click");
        <%} %>

   <% }
    else if(dto.actionValue == "AsInclide")
    {%>
        $("#rdAsInclide").trigger("click");
        $("#isFirstCompleteStatusId").val("");
        $("#isFirstOtherThanCompleteStatusId").val("");
          <%if (dto.IncidentComplete)
    { %>
        $("#isSecondComplete").trigger("click");
        <%} %>
           <%if (dto.IncidentNoComplete)
    { %>
        $("#isSecondOtherThanComplete").trigger("click");
        <%} %>
   <% }
    else if(dto.actionValue == "NoAction")
    {
%>
        $("#rdNoAction").trigger("click");
   <%
    }

    %>

     })

    $("#SaveClose").click(function () {
        if ($("#rdAsNote").is(":checked")) {
            if ($("#isFirstComplete").is(":checked")) {
                var isFirstCompleteStatusId = $("#isFirstCompleteStatusId").val();
                if (isFirstCompleteStatusId == "") {
                    LayerMsg("请选择相关状态");
                    return false;
                }
            }
            if ($("#isFirstOtherThanComplete").is(":checked")) {
                var isFirstOtherThanCompleteStatusId = $("#isFirstOtherThanCompleteStatusId").val();
                if (isFirstOtherThanCompleteStatusId == "") {
                    LayerMsg("请选择相关状态");
                    return false;
                }
            }
        }
        if ($("#rdAsInclide").is(":checked")) {
            if ($("#isSecondComplete").is(":checked")) {
                var isSecondCompleteStatusId = $("#isSecondCompleteStatusId").val();
                if (isSecondCompleteStatusId == "") {
                    LayerMsg("请选择相关状态");
                    return false;
                }
            }
            if ($("#isSecondOtherThanComplete").is(":checked")) {
                var isSecondOtherThanCompleteStatusId = $("#isSecondOtherThanCompleteStatusId").val();
                if (isSecondOtherThanCompleteStatusId == "") {
                    LayerMsg("请选择相关状态");
                    return false;
                }
            }
        }
        
        return true;
    })
</script>
