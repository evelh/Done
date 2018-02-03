<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketNote.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketNote" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增备注":"编辑备注" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <style>
        .content label {
            width: 120px;
        }

        .CloseButton {
            background-image: url(../Images/delete.png);
            width: 16px;
            height: 16px;
            float: left;
        }

        .mytitle {
            margin-left: -620px;
        }

        .grid thead tr td {
            background-color: #cbd9e4;
            border-color: #98b4ca;
            color: #64727a;
        }

        .grid {
            font-size: 12px;
            background-color: #FFF;
        }

            .grid thead td {
                border-width: 1px;
                border-style: solid;
                font-size: 13px;
                font-weight: bold;
                height: 19px;
                padding: 4px 4px 4px 4px;
                word-wrap: break-word;
                vertical-align: top;
            }

            .grid table {
                border-collapse: collapse;
                width: 100%;
                border-bottom-width: 1px;
                /*border-bottom-style: solid;*/
            }

            .grid tbody td {
                border-width: 1px;
                border-style: solid;
                border-left-color: #F8F8F8;
                border-right-color: #F8F8F8;
                border-top-color: #e8e8e8;
                border-bottom-width: 0;
                padding: 4px 4px 4px 4px;
                vertical-align: top;
                word-wrap: break-word;
                font-size: 12px;
                color: #333;
            }

        .CkTitle {
            margin-left: 40px;
            float: left;
            margin-top: -3px;
        }

        .AddItemToTicketTopSection {
            color: #4F4F4F;
            padding: 10px;
            background-repeat: no-repeat;
            background-position: left;
            padding-left: 40px;
            border: none;
        }

        .AddNoteTitleImage {
            background-image: url(../Images/TicketNoteIcon.png);
        }

        .Popup_TitleCell {
            height: 30px;
        }

        .AddItemToTicketTopSection td[class="Popup_TitleCell"] span {
            font-size: 16px;
            font-weight: Bold;
        }

        .Popup_Title {
            font-size: 19px;
            color: #4F4F4F;
        }

        td {
            text-align: left;
        }

        .content label {
            width: 120px;
        }

        .content label {
            display: inline-block;
            color: #151515;
            font-size: 14px;
            width: 95px;
            text-align: right;
            height: 30px;
            line-height: 30px;
            position: relative;
            float: left;
            overflow: hidden;
        }

        label {
            display: inline-block;
            max-width: 100%;
            margin-bottom: 5px;
            font-weight: 700;
        }
        .checkbox input[type=checkbox], .checkbox-inline input[type=checkbox], .radio input[type=radio], .radio-inline input[type=radio]{
            margin-left:13px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增备注":"编辑备注" %></div>
        <div class="header-title">
            <ul>
                <li id="SaveClose">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" />
                </li>
                  <li id="SaveNew">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_new" runat="server" Text="保存并新增" OnClick="save_new_Click" />
                </li>
                 <li id="SaveModify">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_modify" runat="server" Text="保存并修改" OnClick="save_modify_Click" />
                </li>
                <li id="Close">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <input type="button" id="CloseButton" value="关闭" />
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 90px;">
            <div class="DivSection AddItemToTicketTopSection AddNoteTitleImage" style="margin-left: 10px;">
                <table cellspacing="0" cellpadding="0" border="0" style="height: 44px; border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td class="Popup_TitleCell" style="text-align: left;"><span title="T20170812.0001 - ticket title01" class="Popup_Title" style="width: 750px;"><%=thisTicket==null?"":thisTicket.no+" - "+thisTicket.title %></span></td>
                        </tr>
                        <tr>
                            <td class="Popup_SubtitleCell" style="text-align: left;"><span title="<%=thisAccount==null?"":thisAccount.name %>" class="Popup_Subtitle" style="width: 765px;"><%=thisAccount==null?"":thisAccount.name %></span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="information clear" style="margin-left: 10px; padding: 20px;">
                <div class="content">
                    <table border="none" cellspacing="" cellpadding="" style="width: 750px;">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>备注类型<span class="red">*</span></label><asp:DropDownList ID="action_type_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                            <td>
                                <div class="clear">
                                    <label>发布</label>
                                    <asp:DropDownList ID="publish_type_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <div class="clear">
                                    <label>工单状态<span class="red">*</span></label><asp:DropDownList ID="status_id" runat="server"></asp:DropDownList>
                                </div>
                            </td>
                            <td></td>
                        </tr>


                        <tr>
                            <td colspan="2">
                                <label>标题<span class="red">*</span></label>
                                <input type="text" id="name" name="name" value="<%=thisNote!=null?thisNote.name:"" %>" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <label>描述<span class="red">*</span></label>
                                <textarea name="description" style="width: 520px;" id="description"><%=thisNote!=null?thisNote.description:"" %></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <input type="checkbox" id="AppResol" name="AppResol" style="margin-left: 109px;" />
                                <label style="margin-left: -9px; width: 105px;">追加到解决方案</label>
                            </td>
                        </tr>
                    </table>

                </div>
                <div id="DIVAttach" style="visibility: visible; position: relative; top: 0px; left: 0px; display: block;">
                    <table width="100%" cellpadding="5" cellspacing="0">
                        <tbody>
                            <tr>
                                <td>

                                    <table width="100%" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="workspace">
                                                        <table border="0" width="100%" cellpadding="3" cellspacing="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <div style="padding-bottom: 10px; text-align: left; padding-left: 55px;">
                                                                            <a class="PrimaryLink" id="AddAttachmentLink" onclick="AddAttch()">
                                                                                <img src="../Images/ContentAttachment.png" style="height: 15px; width: 15px; display: unset;" alt="" />&nbsp;&nbsp;新增附件</a>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td style="text-align: left;">
                                                                        <div id="AttachmentPanel" class="AttachmentContainer" style="padding-bottom: 10px; padding-left: 45px;">
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <%--    <tr>
                                            <td class="FieldLabels" style="text-align: left; padding-left: 60px;">附加到这个任务的文件
                                                    <div class="grid">
                                                        <input type="hidden" name="attIds" id="attIds" />
                                                        <table width="100%" cellpadding="0" style="border-collapse: collapse; width: 600px;">
                                                            <thead>
                                                                <tr style="height: 21px;">
                                                                    <td width="1%" style="min-width: 22px;">&nbsp;</td>
                                                                    <td width="30%">名称</td>
                                                                    <td width="29%">文件</td>
                                                                    <td width="30%" align="center">日期</td>
                                                                    <td width="10%" align="right">大小</td>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <%if (thisNoteAtt != null && thisNoteAtt.Count > 0)
                                                                    {
                                                                        foreach (var thisAtt in thisNoteAtt)
                                                                        {%>

                                                                <tr class="thisAttTR" id="<%=thisAtt.id %>" data-val="<%=thisAtt.id %>">
                                                                    <td><a onclick="RemoveThistTr('<%=thisAtt.id %>')">
                                                                        <img src="../Images/delete.png" style="height: 15px; width: 15px; display: unset;" /></a></td>
                                                                    <td><%=thisAtt.filename %></td>
                                                                    <td><a onclick="OpenAttach('<%=thisAtt.id %>')"><%=thisAtt.filename %></a></td>
                                                                    <td align="center"><span id="DisplayValueForDateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisAtt.create_time).ToString("yyyy-MM-dd") %></span></td>
                                                                    <td align="right"><%=thisAtt.sizeinbyte %></td>

                                                                </tr>
                                                                <%
                                                                        }
                                                                    } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                            </td>

                                        </tr>--%>
                                            <tr>
                                                <td></td>
                                            </tr>

                                        </tbody>
                                    </table>

                                </td>
                            </tr>
                        </tbody>
                    </table>

                </div>
            </div>
            <div class="information clear" style="margin-left: 10px; padding: 20px;">
                <div id="FormContent" class="DivSection NoneBorder" style="padding-left: 0px; padding-right: 12px; margin-left: 20px;">
                    <p class="informationTitle"><i></i>通知</p>
                    <div>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tbody>
                                <tr>
                                    <td>
                                        <div id="mnuNotify" style="position: relative; top: 0px; left: 0px; visibility: visible; display: block;">
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td>
                                                            <table class="searchareaborder" width="738px" cellspacing="0" cellpadding="0" border="0" style="width: 500px;">
                                                                <tbody>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <table cellspacing="0" cellpadding="0" border="0" style="margin-left: 0px; width: 75%;">
                                                                                <tbody>
                                                                                    <tr>

                                                                                        <td width="369px" class="fieldLabels">
                                                                                            <div class="CheckBoxList">
                                                                                                <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CkAccMan" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">客户经理</span>
                                                                                                </div>
                                                                                                <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CkAccTeam" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">客户团队</span>
                                                                                                </div>

                                                                                                <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CkTicCon" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">工单联系人<%=thisContact==null?"":$"({thisContact.name})" %></span>
                                                                                                </div>
                                                                                                 <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CkAddCon" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">附加联系人</span>
                                                                                                </div>

                                                                                              <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CkPriRes" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">主负责人</span>
                                                                                                </div>
                                                                                                <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CkOtherRes" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">其他负责人</span>
                                                                                                </div>
                                                                                               
                                                                                                

                                                                                                <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="Cksys" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">使用<%=sys_email!=null?sys_email.remark:"" %> 发送</span>
                                                                                                </div>

                                                                                                <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CKIncloAtt" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">通知邮件中包含附件</span>
                                                                                                </div>

                                                                                            </div>
                                                                                        </td>

                                                                                        <td class="fieldLabels" width="357px" style="padding-left: 10px">
                                                                                            <div class="CheckBoxList">

                                                                                                   <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CKcreate" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">条目创建人<%=ticket_creator != null?"("+ticket_creator.name+")":"" %></span>
                                                                                                </div>
                                                                                                <div class="checkbox" style="padding-bottom: 0px;">
                                                                                                    <asp:CheckBox ID="CCMe" runat="server" />
                                                                                                    &nbsp;<span style="cursor: default;" class="CkTitle">抄送给我<%=thisUser != null?"("+thisUser.name+")":"" %></span>
                                                                                                </div>
                                                                                                
                                                                                            </div>
                                                                                        </td>

                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>

                                                                        <td class="FieldLabels" width="369px" style="padding-left: 30px;"><span style="margin-left: -300px;">联系人</span>
                                                                            <div style="margin-left: -18px;">
                                                                                <div id="" style="width: 350px; height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                                                    <div class='grid' style='overflow: auto; height: 147px;'>
                                                                                        <table width='100%' border='0' cellspacing='0' cellpadding='3'>
                                                                                            <thead>
                                                                                                <tr>
                                                                                                    <td width='1%'>
                                                                                                        <%--<input type='checkbox' id='checkAll' />--%>
                                                                                                    </td>
                                                                                                    <td width='33%'>联系人姓名</td>
                                                                                                    <td width='33%'>邮箱地址</td>
                                                                                                </tr>
                                                                                            </thead>
                                                                                            <tbody id="conhtml">
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                        </td>
                                                                        <td class="FieldLabels"><span>员工</span>
                                                                            <span class="FieldLevelInstructions">(<a style="color: #376597; cursor: pointer;" onclick="LoadRes()">加载员工</a>)</span>
                                                                            <div id="reshtml" style="width: 350px; height: 170px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                                                            </div>
                                                                        </td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span style="float: left;">其他邮件地址</span>
                                                                            <div>
                                                                                <input type="text" style="width: 726px;" name="otherEmail" id="otherEmail" />
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span style="margin-left: -660px;">通知模板</span>
                                                                            <div>
                                                                                <asp:DropDownList ID="notify_id" runat="server" Width="727px"></asp:DropDownList>
                                                                            </div>
                                                                        </td>ss
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="FieldLabels" colspan="2" style="padding-top: 9px;"><span style="margin-left: -688px;">主题</span>
                                                                            <div>
                                                                                <input type="text" id="subjects" name="subjects" value="" style="width: 726px" />
                                                                                <input type="hidden" name="contact_ids" id="contact_ids" />
                                                                                <input type="hidden" name="resIds" id="resIds" />
                                                                                <input type="hidden" name="workGropIds" id="workGropIds" />
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="FieldLabels" width="369px" style="padding-top: 9px;"><span style="float: left;">附加信息</span></td>

                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" class="FieldLabels">
                                                                            <div>
                                                                                <textarea rows="6" style="width: 726px" name="AdditionalText" id="AdditionalText"></textarea>
                                                                            </div>
                                                                        </td>
                                                                    </tr>

                                                                    <tr>
                                                                        <td colspan="2" style="text-align: right;"><a href="#" class="PrimaryLink" onclick="defaultSettings();">修改默认设置</a>&nbsp;&nbsp;</td>
                                                                    </tr>

                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>


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
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/index.js"></script>
<script type="text/javascript" src="../Scripts/common.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $(function () {
        GetConByAccount();

    })
    function AddAttch() {
        window.open("../Project/AddTaskAttach.aspx?object_id=<%=object_id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 重新显示session文件内容
    function ReloadSession() {
        // 重新加载session，显示新增文件
        debugger;
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetTaskFileSes&object_id=<%=object_id %>",
            success: function (data) {
                if (data != "") {
                    $("#AttachmentPanel").html(data);
                }
            },
        });
    }

    // 移除session内容
    function RemoveSess(index) {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=RemoveSess&object_id=<%=object_id %>&index=" + index,
            success: function (data) {
                $("#AttachmentPanel").html(data);
            },
        });
    }
    function GetConByAccount() {
        // conhtml

        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ContactAjax.ashx?act=GetContacts&account_id=<%=thisAccount.id %>",
            success: function (data) {
                if (data != "") {
                    $("#conhtml").html(data);
                }
            },
        });

    }
    function GetWorkGroupIds() {
        var ids = "";
        $(".checkWork").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#workGropIds").val(ids);
    }
    function RemoveThistTr(trId) {
        LayerConfirm("确定要删除这个文件吗？", "是", "否", function () { $("#" + trId).remove(); });
    }
    function GetContratID() {
        var ids = "";
        $(".checkCon").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#contact_ids").val(ids);
    }
    function GetResID() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#resIds").val(ids);
    }
    function LoadRes() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=GetResAndWorkGroup",
            success: function (data) {
                if (data != "") {
                    var resList = JSON.parse(data);
                    var resHtml = "";
                    resHtml += "<div class='grid' style='overflow: auto;height: 147px;'><table width='100%' border='0' cellspacing='0' cellpadding='3'><thead><tr><td width='1%'></td><td width='33%'>员工姓名</td ><td width='33%'>邮箱地址</td></tr ></thead ><tbody>";// <input type='checkbox' id='checkAll'/>
                    for (var i = 0; i < resList.length; i++) {
                        resHtml += "<tr><td><input type='checkbox' value='" + resList[i].id + "' class='" + resList[i].type + "' /></td><td>" + resList[i].name + "</td><td><a href='mailto:" + resList[i].email + "'>" + resList[i].email + "</a></td></tr>";
                    }
                    resHtml += "</tbody></table></div>";

                    $("#reshtml").html(resHtml);
                }
            },
        });
    }
    $("#CloseButton").click(function () {
        window.close();
    })
    function OpenAttach(attId) {
        window.open("../Activity/OpenAttachment.aspx?id=" + attId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=1080,height=800', false);

    }
    // 获取旧的task的id集合，修改时删除不必要附件
    function GetOldAttList() {
        // attIds
        var ids = "";
        $(".thisAttTR").each(function () {
            ids += $(this).attr("id") + ",";
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#attIds").val(ids);
    }
</script>
