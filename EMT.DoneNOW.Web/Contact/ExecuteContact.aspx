<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExecuteContact.aspx.cs" Inherits="EMT.DoneNOW.Web.Contact.ExecuteContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>执行联系人活动</title>
    <style>
        li{
            list-style:none;
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
        .DivSectionWithHeader>.HeaderRow>span {
    padding: 2px 4px 6px 6px;
    color: #666;
    height: 16px;
    font-size: 12px;
    font-weight: bold;
    line-height: 17px;
    text-transform: uppercase;
}
        .DivSectionWithHeader>.HeaderRow>span {
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
        li a{
            color:black;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">执行联系人活动</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li onclick="Exexute()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -128px -32px;" class="icon-1"></i>执行</li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    保存
                    <i class="icon-2" style="background: url(../Images/ButtonBarIcons.png) no-repeat -180px -50px;"></i>
                    <ul>
                        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i><a href="#">保存模板</a></li>
                        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i><a href="#">保存模板并关闭</a></li>
                        <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i><a href="#">保存模板为...</a></li>
                    </ul>
                </li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div style="height: 600px; overflow: auto">
            <!-- General -->
            <div id="GeneralPanel" style="padding: 10px 10px 10px 10px;">
                <div id="ContactCountAndPreviewPanel">
                    <span id="SelectedContactCountAtlabel" class="FieldLabel" style="font-weight: normal;">已选择<%=conIdArr.Length %> 个联系人</span>&nbsp;&nbsp;
						<a onclick="ViewSelectContact('<%=conIds %>');">查看选择的联系人</a>
                </div>
                <div id="TemplateInfoPanel">
                    <div>
                        <span id="TemplateNameATLabel" class="FieldLabel" style="font-weight: bold;">模板名称:</span>
                        <div>
                            <span id="TemplateNameATTextEdit" style="display: inline-block; margin-right: 10px;">
                                <input name="" type="text" value="" readonly="readonly" id="tempId" class="txtBlack8Class" style="width: 300px;" />
                                <input type="hidden" id="tempIdHidden"/>
                            </span>
                            <span id="btnLoadTemplate" class="ButtonBase"  style="display: inline-block; margin-bottom: 5px;">
                                <a onclick="">打开模板</a>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Email -->
            <div id="EmailPanel" class="DivSectionWithHeader" style="display:none;">
                <div class="HeaderRow">
                    <span id="EmailSectionAtcheckbox" disabled="disabled" class="FieldLabel">
                        <span class="txtBlack8Class">
                        <input id="" type="checkbox" name="" disabled="disabled" style="vertical-align: middle;" />
                        <label  style="vertical-align: middle;">邮件</label>
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
                            { %> checked="checked" <%} %>  style="vertical-align: middle;" />
                        <label for="NoteSectionAtcheckbox_ATCheckBox" style="vertical-align: middle;">Note</label>
                        </span>
                    </span>
                    <span id="NoteSectionHeaderAtlabel" style="font-weight: bold;"></span>
                </div>
                <div class="Content" id="NoteContent" <%if (chooseType != "note")
                    { %> style="display:none;" <%} %>
                    <div id="NoteDataPanel">
                        <table style="margin: 2px 0px 0px 0px">
                            <tbody>
                                <tr>
                                    <td valign="top" width="400">
                                        <span id="NoteActionTypeAtlabel" class="FieldLabel" style="font-weight: bold;">备注类型<font style="color: Red;"> *</font></span>
                                        <div>
                                            <span id="NoteActionTypeAtdropdownlist" style="display: inline-block;">
                                                <select name="note_action_type" id="note_action_type" class="txtBlack8Class" style="width: 200px;">
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
                                            <textarea name="note_content" id="note_content" class="txtBlack8Class"  maxlength="625" style="height: 75px; width: 500px; "></textarea>
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
                        <input id="ckTodo" type="checkbox" name=""  style="vertical-align: middle;" />
                        <label style="vertical-align: middle;">待办</label>
                         </span>
                    </span>
                </div>
                <div class="Content" id="TodoContent" style="display:none;">
                    <div id="TodoDataPanel" style="display: block;">

                        <table style="margin: 2px 0px 0px 0px">
                            <tbody>
                                <tr>
                                    <td width="400">
                                        <span id="TodoActionTypeAtlabel" class="FieldLabel" style="font-weight: bold;">待办类型<font style="color: Red;"> *</font></span>
                                        <div>
                                            <span id="TodoActionTypeAtdropdownlist" style="display: inline-block;">
                                                <select name="todo_action_type" id="todo_action_type" class="txtBlack8Class" style="width: 200px;">
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
                                        <b>
                                            <span class="FieldLabel" style="float:left;">内容:</span></b>
                                        <span id="TodoDescriptionAttextedit" style="display: inline-block;">
                                            <textarea name="todo_content" id="todo_content" class="txtBlack8Class" maxlength="625" style="height: 75px; width: 500px;" ></textarea></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="FieldLabel">
                                        <span id="TodoAssignedToAtlabel" class="FieldLabel" style="font-weight: bold;">分配给：<font style="color: Red;"> *</font></span>
                                        <div>
                                            <span id="TodoAssignedToAtdropdownlist" style="display: inline-block;">
                                                <select name="todo_resource_id" id="todo_resource_id" class="txtBlack8Class" style="width: 200px;">
                                                    <option value="-1">客户经理</option>
                                                    <%if (resList != null && resList.Count > 0) {
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
                                            <span  style="display: inline-block;">
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
        if (SubmiteCheck()) {
            $("#form1").submit();
        }
    }

    function SubmiteCheck() {
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

    
    

</script>
