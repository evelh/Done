<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExecuteContact.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.ExecuteContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>执行联系人活动</title>
    <style>
        body {
            min-width: 830px;
        }

        li {
            list-style: none;
        }

        .DivSectionWithHeader {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 4px 0 4px 0;
        }

            .DivSectionWithHeader .HeaderRow {
                position: relative;
                padding-bottom: 3px;
            }

            .DivSectionWithHeader > .HeaderRow > span {
                padding: 2px 4px 6px 6px;
                color: #666;
                height: 16px;
                font-size: 12px;
                font-weight: bold;
                line-height: 17px;
                text-transform: uppercase;
            }

            .DivSectionWithHeader > .HeaderRow > span {
                display: inline-block;
                vertical-align: middle;
                position: relative;
            }

        .txtBlack8Class {
            font-size: 12px;
            color: #333;
            font-weight: normal;
        }

        input[type=checkbox] {
            margin: 0 3px 0 0;
            padding-top: 1px;
        }

        .FieldLabel, .workspace .FieldLabel, TABLE.FieldLabel TD, span.fieldlabel span label {
            font-size: 12px;
            color: #4F4F4F;
        }

        span.FieldLabel {
            margin-bottom: 1px;
            display: inline-block;
        }

        .DivSectionWithHeader .Content {
            padding: 0 28px 4px 28px;
        }

        .FieldLevelInstruction {
            font-size: 11px;
            color: #666;
            line-height: 16px;
            font-weight: 100;
        }

        li a {
            color: black;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">执行联系人活动</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="Exexute()" id="execLi"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -128px -32px;" class="icon-1"></i>执行</li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    保存
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li id="SaveLi"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i><a>保存模板</a></li>
                        <li id="SaveCloseLi"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i><a>保存模板并关闭</a></li>
                        <li id="SaveAsLi"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i><a>保存模板为...</a></li>
                    </ul>
                </li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div style="height: 600px; overflow: auto">
            <!-- General -->
            <div id="GeneralPanel" style="padding: 10px 10px 10px 10px;">
                <div id="ContactCountAndPreviewPanel">
                    <span id="SelectedContactCountAtlabel" class="FieldLabel" style="font-weight: normal;">已选择<%=conIdArr!=null?conIdArr.Length.ToString():"" %> 个联系人</span>&nbsp;&nbsp;
						<a onclick="ViewSelectContact('<%=conIds %>');">查看选择的联系人</a>
                </div>
                <div id="TemplateInfoPanel">
                    <div>
                        <span id="TemplateNameATLabel" class="FieldLabel" style="font-weight: bold;">模板名称:</span>
                        <div>
                            <span id="TemplateNameATTextEdit" style="display: inline-block; margin-right: 10px;">
                                <input name="" type="text" value="<%=actionTemp!=null?actionTemp.name:"" %>" readonly="readonly" id="tempId" class="txtBlack8Class" style="width: 300px;" />
                                <input type="hidden" id="tempIdHidden" value="<%=actionTemp!=null?actionTemp.id.ToString():"" %>" />
                            </span>
                            <span id="btnLoadTemplate" class="ButtonBase" style="display: inline-block; margin-bottom: 5px;">
                                <a onclick="TempCallBack()">打开模板</a>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <div id="ShowTempDescription" style="display:none;padding:10px;">
                <div id="">
                    <div>
                        <span id="DescriptionATLabel" class="FieldLabel" style="font-weight: bold;">模板描述</span>
                        <div>
                            <span id="DescriptionATTextEdit" style="display: inline-block;">
                                <input name="description" type="text" value="<%=actionTemp!=null?actionTemp.description:"" %>" readonly="readonly" id="description" class="txtBlack8Class" style="width: 200px;" /></span>
                        </div>
                    </div>

                </div>
            </div>
            <!-- Email -->
            <div id="EmailPanel" class="DivSectionWithHeader" style="display: none;">
                <div class="HeaderRow">
                    <span id="EmailSectionAtcheckbox" disabled="disabled" class="FieldLabel">
                        <span class="txtBlack8Class">
                            <input id="ckSendEmail" type="checkbox" name="" disabled="disabled" style="vertical-align: middle;" />
                            <label style="vertical-align: middle;">邮件</label>
                        </span>
                    </span>
                </div>
                <div class="Content">
                    <div id="EmailDataDisabledPanel">
                        <span class="FieldLabel">Bulk E-mailing is currently disabled. Contact your Autotask Administrator for access to this function.</span>
                    </div>
                </div>
            </div>
            <!-- Note -->
            <div id="NotePanel" class="DivSectionWithHeader" style="">
                <div class="HeaderRow">
                    <span id="NoteSectionAtcheckbox">
                        <span class="txtBlack8Class">
                            <input id="ckNote" type="checkbox" name="" <%if (chooseType == "note")
                                { %>
                                checked="checked" <%} %> style="vertical-align: middle;" />
                            <label for="NoteSectionAtcheckbox_ATCheckBox" style="vertical-align: middle;">备注</label>
                        </span>
                    </span>
                    <span id="NoteSectionHeaderAtlabel" style="font-weight: bold;"></span>
                </div>
                <div class="Content" id="NoteContent" <%if (chooseType != "note")
                    { %>
                    style="display: none;" <%} %>>
                    <div id="NoteDataPanel">
                        <table style="margin: 2px 0px 0px 0px">
                            <tbody>
                                <tr>
                                    <td valign="top" width="400">
                                        <span id="NoteActionTypeAtlabel" class="FieldLabel" style="font-weight: bold;">备注类型<font style="color: Red;"> *</font></span>
                                        <div>
                                            <span id="NoteActionTypeAtdropdownlist" style="display: inline-block;">
                                                <select name="note_action_type" id="note_action_type" class="txtBlack8Class" style="width: 130px;">
                                                    <%if (noteTypeList != null && noteTypeList.Count > 0)
                                                        {
                                                            foreach (var noteType in noteTypeList)
                                                            {%>
                                                    <option value="<%=noteType.id %>"><%=noteType.name %></option>
                                                    <%   }
                                                        } %>
                                                </select>
                                            </span>
                                            <br />
                                            <span class="FieldLevelInstruction">(日历的操作类型备注上不可用)
                                            </span>
                                        </div>
                                        <br />
                                    </td>
                                    <td>
                                        <span class="FieldLabel" style="float: left; padding-top: 3px">
                                            <b>内容:</b>
                                        </span>

                                        <span id="NoteDescriptionAttextedit" style="display: inline-block;">
                                            <textarea name="note_content" id="note_content" class="txtBlack8Class" maxlength="625" style="height: 75px; width: 500px;"></textarea>
                                        </span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- Todo -->
            <div id="TodoPanel" class="DivSectionWithHeader">
                <div class="HeaderRow">
                    <span id="TodoSectionAtcheckbox">
                        <span class="txtBlack8Class">
                            <input id="ckTodo" type="checkbox" name="" <%if (chooseType == "todo")
                                { %>
                                checked="checked" <%} %> style="vertical-align: middle;" />
                            <label style="vertical-align: middle;">待办</label>
                        </span>
                    </span>
                </div>
                <div class="Content" id="TodoContent" <%if (chooseType != "todo")
                    { %>
                    style="display: none;" <%} %>>
                    <div id="TodoDataPanel" style="display: block;">

                        <table style="margin: 2px 0px 0px 0px">
                            <tbody>
                                <tr>
                                    <td width="400">
                                        <span id="TodoActionTypeAtlabel" class="FieldLabel" style="font-weight: bold;">待办类型<font style="color: Red;"> *</font></span>
                                        <div>
                                            <span id="TodoActionTypeAtdropdownlist" style="display: inline-block;">
                                                <select name="todo_action_type" id="todo_action_type" class="txtBlack8Class" style="width: 130px;">
                                                    <%if (noteTypeList != null && noteTypeList.Count > 0)
                                                        {
                                                            foreach (var noteType in noteTypeList)
                                                            {%>
                                                    <option value="<%=noteType.id %>"><%=noteType.name %></option>
                                                    <%   }
                                                        } %>
                                                </select></span>
                                            <br />
                                            <span class="FieldLevelInstruction">(日历的操作类型待办上不可用)
                                            </span>
                                        </div>
                                    </td>
                                    <td valign="top" rowspan="4">
                                        <b><span class="FieldLabel" style="float: left;">内容:</span></b>
                                        <span id="TodoDescriptionAttextedit" style="display: inline-block;">
                                            <textarea name="todo_content" id="todo_content" class="txtBlack8Class" maxlength="625" style="height: 75px; width: 500px;"></textarea></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabel">
                                        <span id="TodoAssignedToAtlabel" class="FieldLabel" style="font-weight: bold;">分配给：<font style="color: Red;"> *</font></span>
                                        <div>
                                            <span id="TodoAssignedToAtdropdownlist" style="display: inline-block;">
                                                <select name="todo_resource_id" id="todo_resource_id" class="txtBlack8Class" style="width: 130px;">
                                                    <option value="-1">客户经理</option>
                                                    <%if (resList != null && resList.Count > 0)
                                                        {
                                                            foreach (var res in resList)
                                                            {%>
                                                    <option value="<%=res.id %>"><%=res.name %></option>
                                                    <%}
                                                        } %>
                                                </select>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="width: 90px">
                                            <span id="TodoStartDateTimeAtlabel" class="FieldLabel" style="font-weight: bold;">开始日期<font style="color: Red;"> *</font></span>
                                        </span>
                                        <div>
                                            <span style="display: inline-block;">
                                                <input name="startDate" type="text" value="" id="startDate" class="txtBlack8Class" style="width: 130px;" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" />
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="width: 90px">
                                            <span id="TodoEndDateTimeAtlabel" class="FieldLabel" style="font-weight: bold;">结束日期<font style="color: Red;"> *</font></span>
                                        </span>
                                        <div>
                                            <span id="TodoEndDateEdit" style="display: inline-block;">
                                                <input name="endDate" type="text" value="" id="endDate" class="txtBlack8Class" style="width: 130px;" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" />&nbsp;
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="SaveType" />
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $(function () {
        if ($("#ckNote").is(":checked")) {
            $("#NoteContent").show();
        }
        if ($("#ckTodo").is(":checked")) {
            $("#TodoContent").show();
        }
        <%if (actionTemp != null)
    { %>
        GetTempInfoById();
        <%} %>
        <%if (isTemp)
    { %>
        $("#execLi").hide();
        $("#GeneralPanel").hide();
        $("#ShowTempDescription").show();
        <% }%>
    })
    function ViewSelectContact(conIds) {
        window.open('ViewContactList.aspx?ids=<%=conIds %>', '_blank', 'left=200,top=200,width=960,height=750', false);
    }
    $("#ckNote").click(function () {
        if ($(this).is(":checked")) {
            $("#NoteContent").show();
        }
        else {
            $("#NoteContent").hide();
        }
    })
    $("#ckTodo").click(function () {
        if ($(this).is(":checked")) {
            $("#TodoContent").show();
        }
        else {
            $("#TodoContent").hide();
        }
    })
    // 执行 操作
    function Exexute() {
        if (SubmiteCheck("1")) {
            $("#form1").submit();
        }
    }

    $("#SaveLi").click(function () {
        $("#SaveType").val("Save");
        if (SubmiteCheck("")) {
            var tempIdHidden = $("#tempIdHidden").val();
            if (tempIdHidden != "") {
                <%if (isTemp){ %>
                SaveNewByName("<%=actionTemp!=null?actionTemp.name:"" %>", "<%=actionTemp!=null?actionTemp.description:"" %>", "");
                <%}else{ %>
                SaveNewByName("", "", "");

                <% }%>
            }
            else {
                // 打开页面
                window.open('../Contact/NewContactTemplate.aspx', 'newContactTemp', 'left=200,top=200,width=730,height=750', false);
            }
        }

    })

    $("#SaveCloseLi").click(function () {
        $("#SaveType").val("SaveClose");
        if (SubmiteCheck("")) {
            var tempIdHidden = $("#tempIdHidden").val();
            if (tempIdHidden != "") {
                 <%if (isTemp){ %>
                SaveNewByName("<%=actionTemp!=null?actionTemp.name:"" %>", "<%=actionTemp!=null?actionTemp.description:"" %>", "");
                <%}else{ %>
                SaveNewByName("", "", "");

                <% }%>
            }
            else {
                // 打开页面
                window.open('../Contact/NewContactTemplate.aspx', 'newContactTemp', 'left=200,top=200,width=730,height=750', false);
            }
        }
    })

    $("#SaveAsLi").click(function () {
        $("#SaveType").val("SaveAs");
        if (SubmiteCheck("")) {
            // 打开页面
            window.open('../Contact/NewContactTemplate.aspx', 'newContactTemp', 'left=200,top=200,width=730,height=750', false);
        }
    })


    function SaveNewByName(name, desc, isNew) {
        if (SubmiteCheck("1")) {
            var url = "../Tools/ContactAjax.ashx?act=SaveActionTemp";
            if (name != "" && name != undefined && name != null) {
                url += "&name=" + name;
            }
            if (desc != "" && desc != undefined && desc != null) {
                url += "&description=" + desc;
            }
            if (isNew != "1") {
                var tempIdHidden = $("#tempIdHidden").val();
                if (tempIdHidden != "") {
                    url += "&tempId=" + tempIdHidden;
                }
            }

            if ($("#ckNote").is(":checked")) {
                var note_action_type = $("#note_action_type").val();
                if (note_action_type != "") {
                    url += "&noteActionTypeId=" + note_action_type;
                }
                url += "&noteDescription=" + $("#note_content").val();
            }
            if ($("#ckSendEmail").is(":checked")) {
                url += "&sendEmail=1";
            }
            if ($("#ckTodo").is(":checked")) {
                var todo_action_type = $("#todo_action_type").val();
                var todo_resource_id = $("#todo_resource_id").val();
                var startDate = $("#startDate").val();
                var endDate = $("#endDate").val();
                if (todo_action_type != "") {
                    url += "&todoActionTypeId=" + todo_action_type;
                }
                if (todo_resource_id != "") {
                    url += "&todoResourceId=" + todo_resource_id;
                }
                if (startDate != "") {
                    url += "&todoStartDate=" + startDate;
                }
                if (endDate != "") {
                    url += "&todoEndDate=" + endDate;
                }
                url += "&todoDescription=" + $("#todo_content").val();
            }
            var saveType = $("#SaveType").val();
            $.ajax({
                type: "GET",
                url: url,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "" && data.result) {
                        LayerMsg("保存成功！")
                        setTimeout(function () {
                            if (saveType == "SaveClose") {
                                self.opener.location.reload();
                                window.close();
                            }
                            else if (saveType == "Save" || saveType == "SaveAs") {
                                // tempId  data.id
                                location.href = "ExecuteContact?groupId=<%=Request.QueryString["groupId"] %>&isGroup=<%=Request.QueryString["isGroup"] %>&accountId=<%=Request.QueryString["accountId"] %>&ids=<%=Request.QueryString["ids"] %>&tempId=" + data.id +"&isTemp=<%=Request.QueryString["isTemp"] %>";
                            }
                        }, 800);

                    }
                    else {
                        LayerMsg("保存失败！")
                    }
                }
            })
        }
    }

    function SubmiteCheck(checkLast) {
        var note_action_type = $("#note_action_type").val();
        if ($("#ckNote").is(":checked")) {
            if (note_action_type == "") {
                LayerMsg("请选择备注类型！");
                return false;
            }
        }

        var todo_action_type = $("#todo_action_type").val();
        var todo_resource_id = $("#todo_resource_id").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();
        if ($("#ckTodo").is(":checked")) {
            if (todo_action_type == "") {
                LayerMsg("请选择待办类型！");
                return false;
            }
            if (todo_resource_id == "") {
                LayerMsg("请选择分配对象！");
                return false;
            }
            if (startDate == "") {
                LayerMsg("请填写开始日期！");
                return false;
            }
            if (endDate == "") {
                LayerMsg("请填写结束日期！");
                return false;
            }
        }

        if (checkLast == "") {
            if ($("#ckNote").is(":checked") && $("#ckTodo").is(":checked")) {
                return true;
            }
            else {
                if (confirm("您已经从这个模板中移除了一个或多个动作。如果继续，您将在这些部分中输入的任何数据将被丢弃。 ")) {
                    return true;
                }
                else {
                    return false;
                }
            }
        }
        else {
            return true;
        }

    }

    function TempCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_ACTION_TEMP %>&field=tempId&callBack=GetTempInfoById", "contactTempSelect", 'left=200,top=200,width=600,height=800', false);
    }

    // 根据模板获取模板信息
    function GetTempInfoById() {
        var tempIdHidden = $("#tempIdHidden").val();
        if (tempIdHidden != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=GetTempInfo&tempId=" + tempIdHidden,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.note_action_type_id != "" && data.note_action_type_id != undefined) {
                            $("#ckNote").prop("checked", true);
                            $("#NoteContent").show();
                            $("#note_action_type").val(data.note_action_type_id);
                        }
                        else {
                            $("#ckNote").prop("checked", false);
                            $("#NoteContent").hide();
                        }
                        if (data.note_description != undefined) {
                            $("#note_content").val(data.note_description);
                        }

                        if (data.todo_action_type_id != "" && data.todo_action_type_id != undefined) {
                            $("#ckTodo").prop("checked", true);
                            $("#TodoContent").show();
                            $("#todo_action_type").val(data.todo_action_type_id);
                        }
                        else {
                            $("#ckTodo").prop("checked", false);
                            $("#TodoContent").hide();
                        }
                        if (data.todo_description != undefined) {
                            $("#todo_content").val(data.todo_description);
                        }
                        if (data.todo_resource_id != "" && data.todo_resource_id != undefined) {
                            $("#todo_resource_id").val(data.todo_resource_id);
                        }
                        if (data.todo_start_date != "" && data.todo_start_date != undefined) {
                            var startDate = new Date(data.todo_start_date);
                            $("#startDate").val(startDate.getFullYear() + "-" + (Number(startDate.getMonth()) + 1) + "-" + startDate.getDate() + " " + startDate.getHours() + ":" + startDate.getMinutes() + ":" + startDate.getSeconds());
                        }
                        if (data.todo_end_date != "" && data.todo_end_date != undefined) {
                            var endDate = new Date(data.todo_end_date);
                            $("#endDate").val(endDate.getFullYear() + "-" + (Number(endDate.getMonth()) + 1) + "-" + endDate.getDate() + " " + endDate.getHours() + ":" + endDate.getMinutes() + ":" + endDate.getSeconds());
                        }
                    }
                }
            })
        }
    }



</script>
