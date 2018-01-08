<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskAddOrEdit" EnableEventValidation="false" %>

<!DOCTYPE html>


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/NewConfigurationItem.css" rel="stylesheetNormal" />
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <title><%=isAdd?"新增":"编辑" %></title>
    <style>
        .RightClickMenu, .LeftClickMenu {
            padding: 16px;
            background-color: #FFF;
            border: solid 1px #CCC;
            cursor: pointer;
            z-index: 999;
            position: absolute;
            box-shadow: 1px 1px 4px rgba(0,0,0,0.33);
        }

        .RightClickMenuItem {
            min-height: 24px;
            min-width: 100px;
        }

        .RightClickMenuItemIcon {
            padding: 1px 5px 1px 5px;
            width: 16px;
        }

        .RightClickMenuItemTable tr:first-child td:last-child {
            white-space: nowrap;
        }

        .RightClickMenuItemLiveLinks > span, .RightClickMenuItemText > span {
            font-size: 12px;
            font-weight: normal;
            color: #4F4F4F;
        }

        .ProjectInfo_Inset {
            background-color: #F0F5FB;
            border: 1px solid #D7D7D7;
            padding: 10px;
        }

            .ProjectInfo_Inset > table > tbody > tr > td {
                vertical-align: top;
            }

        .ProjectInfo_Text {
            font-size: 12px;
            color: #333;
        }

        .ProjectInfo_TextBold {
            font-size: 12px;
            color: #4f4f4f;
            font-weight: 700;
        }

        .ProjectInfo_Button {
            color: #376597;
            font-size: 12px;
        }

        .ProjectInfo_ButtonDisabled {
            color: #333;
            font-size: 12px;
        }

        .ProjectInfo_CheckboxVerticalAlign {
            padding-top: 19px;
        }

        .NotificationRecipients_table {
            width: 100%;
            font-size: 11px;
        }

        .NotificationRecipients_halfColumn {
            width: 50%;
        }

        .NotificationRecipients_horizontalSpace {
            width: 10px;
        }

        .NotificationRecipients_label {
            font-weight: 700;
        }

        .NotificationRecipients_rightAlign {
            text-align: right;
        }

        .NotificationRecipients_select {
            width: 320px;
        }

        .NotificationRecipients_textbox {
            width: 704px;
        }

        .NotificationRecipients_text {
            display: inline;
            font-size: 12px;
            color: #4f4f4f;
        }

        .NotificationRecipients_links {
            text-decoration: underline;
            font-size: 12px;
            color: #369;
        }

        .NotificationRecipients_leftMargin {
            margin-left: 5px;
        }

        .NotificationRecipients_rightSide {
            float: right;
        }

        .NotificationRecipients_fromLine {
            margin-bottom: 15px;
        }

        .NotificationRecipients_editDefaultSettingsContainer {
            text-align: right;
        }

        .Edit_Inset {
            background-color: #f0f5fb;
            border: 1px solid #d5dce2;
            padding: 10px;
            border-radius: 10px;
        }

        #save, #save_close, #save_view, #save_add, #save2, #save_close2 {
            border-style: None;
            background-color: whitesmoke;
            font-size: 12px;
            font-weight: bold;
            /*color: buttontext;*/
            color: #4f4f4f;
        }

        .PredecessorItemsSelectDialog_Grid.PredecessorItemsSelectDialog_Small {
            width: 708px;
            padding-bottom: 10px;
        }

        .PredecessorItemsSelectDialog_Grid {
            font-size: 12px;
            border-top: 1px solid rgb(215, 215, 215);
        }

            .PredecessorItemsSelectDialog_Grid .PredecessorItemsSelectDialog_HeaderContainer {
                overflow: hidden;
                background-color: rgb(235, 235, 235);
                border-left: 1px solid rgb(215, 215, 215);
                border-right: 1px solid rgb(215, 215, 215);
            }

                .PredecessorItemsSelectDialog_Grid .PredecessorItemsSelectDialog_HeaderContainer table {
                    table-layout: fixed;
                    width: 100%;
                }

            .PredecessorItemsSelectDialog_Grid table {
                border-collapse: collapse;
                border-spacing: 0px;
            }

        table {
            display: table;
            border-collapse: separate;
            border-spacing: 2px;
            border-color: grey;
        }

        .PredecessorItemsSelectDialog_Grid.PredecessorItemsSelectDialog_Small .PredecessorItemsSelectDialog_RowContainer {
            height: 60px;
        }

        .PredecessorItemsSelectDialog_Grid .PredecessorItemsSelectDialog_RowContainer {
            overflow-x: hidden;
            overflow-y: scroll;
            border-left: 1px solid rgb(215, 215, 215);
            border-bottom: 1px solid rgb(215, 215, 215);
            border-right: 1px solid rgb(215, 215, 215);
        }

            .PredecessorItemsSelectDialog_Grid .PredecessorItemsSelectDialog_RowContainer table {
                table-layout: fixed;
                width: 100%;
            }

        .PredecessorItemsSelectDialog_Grid table {
            border-collapse: collapse;
            border-spacing: 0px;
        }

        .CancelDialogButton {
            background-image: url(../Images/cancel1.png);
            background-position: 0 -32px;
            border-radius: 50%;
            cursor: pointer;
            height: 32px;
            position: absolute;
            right: -14px;
            top: -14px;
            width: 32px;
        }

        .PhaseEditor_HeadingText {
            color: #666;
            font-size: 11px;
            font-weight: bold;
        }

        .PhaseEditor_smallHeadingText {
            font-size: 9px;
            font-weight: normal;
            color: #191919;
        }

        .PhaseEditor_BudgetTable > tbody > tr > td {
            color: #333;
            padding: 4px;
            border: 1px solid #CCC;
        }

        .PhaseEditor_head {
            background-color: #EBEBEB;
            text-align: center;
            font-weight: bold;
            margin: 0;
        }

        .PhaseEditor_Text {
            color: #333;
            font-size: 11px;
        }

        .menu {
            position: absolute;
            z-index: 999;
            display: none;
        }

            .menu ul {
                margin: 0;
                padding: 0;
                position: relative;
                width: 150px;
                border: 1px solid gray;
                background-color: #F5F5F5;
                padding: 10px 0;
            }

                .menu ul li {
                    padding-left: 20px;
                    height: 25px;
                    line-height: 25px;
                    cursor: pointer;
                }

                    .menu ul li ul {
                        display: none;
                        position: absolute;
                        right: -150px;
                        top: -1px;
                        background-color: #F5F5F5;
                        min-height: 90%;
                    }

                        .menu ul li ul li:hover {
                            background: #e5e5e5;
                        }

                    .menu ul li:hover {
                        background: #e5e5e5;
                    }

                        .menu ul li:hover ul {
                            display: block;
                        }

                    .menu ul li .menu-i1 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: left;
                    }

                    .menu ul li .menu-i2 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: right;
                    }

                .menu ul .disabled {
                    color: #AAAAAA;
                }

        .layui-layer-btn {
            font-size: 10pt;
        }

        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 25;
            position: absolute;
            top: 0;
            left: 0;
            display: none;
        }

        .Dialog.Large {
            position: fixed;
            background-color: #ffffff;
            border: solid 4px #b9b9b9;
            display: none;
        }
    </style>
</head>
<body class="Linen AutotaskBlueTheme">
    <form id="NewTaskForm" runat="server">
        <div class="Active ThemePrimaryColor TitleBar">
            <% var type = "";
                switch (type_id)
                {
                    case (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE:
                        type = "问题";
                        break;
                    case (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE:
                        type = "阶段";
                        break;
                    case (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_TASK:
                        type = "任务";
                        break;
                    default:
                        break;
                }
            %>
            <div class="Title"><span class="Text"><%=isAdd?"新增":"修改" %><%=type %></span><span class="SecondaryText"></span></div>
            <div class="TitleBarButton Star" id="za129bcc0139b41ea8e2f627eb64b9cd3" title="Bookmark this page">
                <div class="TitleBarIcon Star"></div>
            </div>
            <div class="ContextHelpButton" onclick="window.open(&#39;/Help/default_csh.htm#1117&#39;, &#39;Projects_Task_New&#39;, &#39;height=650,width=960,top=100,left=100,status=0,toolBar=0,menubar=0,directories=0,resizable=1,scrollbars=1&#39;);"></div>
        </div>
        <%
            var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
        %>
        <div class="PageContentContainer">
            <div class="PageHeadingContainer">
                <div class="ValidationSummary" id="za5428cdc14ae42d99d7dfb4b7578ff93">
                    <div class="CustomValidation Valid"></div>
                    <div class="FormValidation Valid">
                        <div class="ErrorContent">
                            <div class="TransitionContainer">
                                <div class="IconContainer">
                                    <div class="Icon"></div>
                                </div>
                                <div class="TextContainer"><span class="Count"></span><span class="Count Spacer"></span><span class="Message"></span></div>
                            </div>
                        </div>
                        <div class="ChevronContainer">
                            <div class="Up"></div>
                            <div class="Down"></div>
                        </div>
                    </div>
                </div>
                <div class="ButtonContainer">
                    <div class="DropDownButtonContainer f1">
                        <div class="Left">
                            <a class="NormalState Button ButtonIcon Save" id="SaveDropDownButton_LeftButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                                <asp:Button ID="save" runat="server" Text="保存" BorderStyle="None" OnClick="save_Click" /></span></a>
                        </div>
                        <div class="Right"><a class="NormalState Button ButtonIcon IconOnly DropDownArrow" id="SaveDropDownButton_RightButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -176px -48px; width: 15px;"></span><span class="Text"></span></a></div>
                    </div>
                    <div class="RightClickMenu" style="left: 10px; top: 36px; display: none; margin-top: 35px;" id="D1">
                        <div class="RightClickMenuItem">
                            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                <tbody>
                                    <tr>
                                        <td class="RightClickMenuItemText">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                                                <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" /></span>

                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="RightClickMenuItem">
                            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                <tbody>
                                    <tr>
                                        <td class="RightClickMenuItemText">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                                                <asp:Button ID="save_view" runat="server" Text="保存并查看详情" BorderStyle="None" OnClick="save_view_Click" />
                                            </span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="RightClickMenuItem">
                            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                <tbody>
                                    <tr>
                                        <td class="RightClickMenuItemText">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                                                <asp:Button ID="save_add" runat="server" Text="保存并新建" BorderStyle="None" OnClick="save_add_Click" /></span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="RightClickMenuItem">
                            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                <tbody>
                                    <tr>
                                        <td class="RightClickMenuItemText">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                                                <asp:Button ID="save2" runat="server" Text="保存" BorderStyle="None" OnClick="save2_Click" /></span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>

                    <%if (!isAdd)
                        {
                            if (isPhase)
                            {%>
                    <a class="Button ButtonIcon New NormalState" id="AddNoteButton" tabindex="0" onclick="AddNote()"><span class="Icon"></span><span class="Text">新增备注</span></a>
                    <%}
                        else
                        {%>
                    <div class="DropDownButtonContainer A1">
                        <div class="Left">
                            <a class="NormalState Button ButtonIcon Save" id="" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">新增</span></a>
                        </div>
                        <div class="Right"><a class="NormalState Button ButtonIcon IconOnly DropDownArrow" id="" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -176px -48px; width: 15px;"></span><span class="Text"></span></a></div>
                    </div>
                    <div class="RightClickMenu" style="left: 110px; top: 36px; display: none; margin-top: 35px;" id="B1">

                        <div class="RightClickMenuItem">
                            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                <tbody>
                                    <tr>
                                        <td class="RightClickMenuItemText" onclick="AddNote()">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">备注</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="RightClickMenuItem">
                            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                <tbody>
                                    <tr>
                                        <td class="RightClickMenuItemText">
                                            <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">服务预定</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>


                    </div>
                    <%if (thisTask.is_cancelled == 1)
                        { %>
                    <a class="Button ButtonIcon NormalState" id="RecoveryTaskButton" tabindex="0" onclick="RecoveTask()"><span class="Icon"></span><span class="Text">恢复任务</span></a>

                    <%}
                        else
                        { %>
                    <a class="Button ButtonIcon NormalState" id="CancelTaskButton" tabindex="0" onclick="CancelTask()"><span class="Icon"></span><span class="Text">取消任务</span></a>
                    <%} %>
                    <%}
                        } %>

                    <a class="NormalState Button ButtonIcon Cancel" id="CancelButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">关闭</span></a>
                </div>
            </div>
            <%if (!isAdd)
                { %>
            <div class="nav-title">
                <ul class="clear">
                    <%if (!isPhase)
                        { %>
                    <li class="boders IsShowDivLi" id="general" style="font-size: small;">常规信息</li>
                    <li id="serCalls" style="font-size: small;" class="IsShowDivLi">服务预定</li>
                    <li id="note" style="font-size: small;" class="IsShowDivLi">备注</li>
                    <%}
                        else
                        { %>
                    <li class="boders IsShowDivLi" id="general" style="font-size: small;">常规信息</li>
                    <li id="phaseNote" style="font-size: small;" class="IsShowDivLi">备注</li>
                    <li id="milestones" style="font-size: small;" class="IsShowDivLi">里程碑</li>
                    <%} %>
                </ul>
            </div>
            <%} %>
            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer" id="za7dce764d22b4572aaf851391e3b7f6f" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: <%=isAdd?85:130 %>px;">
                    <div class="IsShowDiv" id="generalDiv">
                        <div class="Normal Section">
                            <div class="Heading">
                                <div class="Left"><span class="Text">常规信息</span><span class="SecondaryText"></span></div>
                                <div class="Spacer"></div>
                            </div>
                            <div class="Content">
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="title">任务标题</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox" data-editor-id="Title" data-rdp="Title">
                                        <div class="InputField">
                                            <input id="title" type="text" value="<%=isAdd?"":isCopy?"(copy of)"+thisTask.title:thisTask.title %>" name="title" /><span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly ProjectTask" id="TaskLibraryButton" tabindex="0" title="Task Library" onclick=""><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -16px -79px;"></span><span class="Text"></span></a></span>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="PhaseName">父阶段名称<span class="SecondaryText">(在此阶段内放置条目)</span></label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox" data-editor-id="PhaseName" data-rdp="PhaseName">
                                        <div class="InputField">

                                            <input id="PhaseName" type="text" value="<%=parTask==null?"":parTask.title %>" name="PhaseName" disabled="disabled" />
                                            <input type="hidden" name="parent_id" id="PhaseNameHidden" value="<%=parTask == null ? "" : parTask.id.ToString() %>" />
                                            <span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PhaseSelectorButton" tabindex="0" title="选择阶段" onclick="ChoosePhase()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><a class="NormalState Button ButtonIcon IconOnly Delete" id="PhaseDeleteButton" tabindex="0" title="清除选择的阶段" onclick="CancelPhase()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -64px 0px;"></span><span class="Text"></span></a>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="CustomLayoutContainer">

                                        <div class="ProjectInfo_Inset">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <span class="ProjectInfo_TextBold">项目:</span>
                                                    </td>
                                                    <td>
                                                        <div>
                                                            <a class="ProjectInfo_Button" href="#" onclick="projectInfo.getProjectInfo(); return false;"><%=thisProject.name %></a>
                                                        </div>
                                                        <div class="ProjectInfo_Text"><%=((DateTime)thisProject.start_date).ToString("yyyy-MM-dd") %> - <%=((DateTime)thisProject.end_date).ToString("yyyy-MM-dd") %></div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><%
                                                            EMT.DoneNOW.Core.crm_account proAccount = new EMT.DoneNOW.DAL.crm_account_dal().FindNoDeleteById(thisProject.account_id);

                                                    %>
                                                        <span class="ProjectInfo_TextBold">客户:</span>
                                                    </td>
                                                    <td>
                                                        <div>
                                                            <a class="ProjectInfo_Button" onclick="window.open('../Company/ViewCompany.aspx?id=<%=proAccount.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>','left=200,top=200,width=900,height=750', false);"><%=proAccount.name %></a>
                                                        </div>
                                                        <% var defaultLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocationByAccountId(proAccount.id);



                                                        %>
                                                        <div class="ProjectInfo_Text">
                                                            <%=country.First(_=>_.val.ToString()==defaultLocation.country_id.ToString()).show  %>
                                                            <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.province_id.ToString()).show  %>
                                                            <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.city_id.ToString()).show  %>
                                                            <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.district_id.ToString()).show  %>
                                                        </div>
                                                        <div class="ProjectInfo_Text"><%=defaultLocation.address %> <%=defaultLocation.additional_address %></div>
                                                        <div class="ProjectInfo_Text"><%=proAccount.phone %></div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="Large Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="description">描述</label>
                                        </div>
                                    </div>
                                    <div class="Editor TextArea" data-editor-id="Description" data-rdp="Description">
                                        <div class="InputField">
                                            <textarea class="Medium" id="description" name="description" placeholder=""><%=isAdd?"":thisTask.description %></textarea>
                                        </div>
                                    </div>
                                </div>
                                <%if (type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                                    { %>
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="status_id">状态</label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect" data-editor-id="Status" data-rdp="Status">
                                        <div class="InputField">
                                            <asp:DropDownList ID="status_id" runat="server"></asp:DropDownList>

                                        </div>
                                    </div>
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="priority">优先级</label>
                                            </div>
                                        </div>
                                        <div class="Editor IntegerBox" data-editor-id="Priority" data-rdp="Priority">
                                            <div class="InputField">
                                                <input id="priority" type="text" value="<%=isAdd ? "" : thisTask.priority.ToString() %>" name="priority" maxlength="5" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="purchase_order_no">采购订单号</label>
                                            </div>
                                        </div>
                                        <div class="Editor TextBox" data-editor-id="PurchaseOrderNumber" data-rdp="PurchaseOrderNumber">
                                            <div class="InputField">
                                                <input id="purchase_order_no" type="text" value="<%=isAdd ? "" : thisTask.purchase_order_no %>" name="purchase_order_no" maxlength="50" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="RadioButtonGroupContainer">
                                        <div class="RadioButtonGroupLabel">
                                            <div><span class="Label">显示在客户端</span></div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="DisplayInCapYes" data-rdp="DisplayInCapYes">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="DisplayInCapYes" runat="server" GroupName="DisplayInCap" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="DisplayInCapYes">是，允许客户端用户完成</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="DisplayInCapYesNoComplete" data-rdp="DisplayInCapYesNoComplete">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="DisplayInCapYesNoComplete" runat="server" GroupName="DisplayInCap" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="DisplayInCapYesNoComplete">是，不允许客户端用户完成</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="DisplayInCapNone" data-rdp="DisplayInCapNone">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="DisplayInCapNone" runat="server" GroupName="DisplayInCap" />

                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="DisplayInCapNone">否</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Editor CheckBox" data-editor-id="IsIssue" data-rdp="IsIssue">
                                        <div class="InputField">
                                            <div>
                                                <asp:CheckBox ID="isProject_issue" runat="server" />

                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="IsIssue">标记为问题</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="IssueReportedBy">问题提出人</label>
                                        </div>
                                    </div>
                                    <div class="Editor DataSelector" data-editor-id="IssueReportedBy" data-rdp="IssueReportedBy">
                                        <div class="InputField">
                                            <input id="issue_report_contact_id" type="text" value="" autocomplete="off" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="ChooseRc" tabindex="0"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="issue_report_contact_idHidden" name="issue_report_contact_id" type="hidden" value="" /><div class="ContextOverlayContainer" id="IssueReportedBy_ContextOverlay">
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Predecessors">前驱任务</label>
                                        </div>
                                    </div>
                                    <div class="Editor MultipleSelect" data-editor-id="Predecessors" data-rdp="Predecessors">
                                        <div class="InputField">
                                            <select id="Predecessors" multiple="multiple" name="Predecessors">
                                            </select><span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PredecessorSelectButton" tabindex="0" onclick="ChoosePreTask()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a></span>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                            </div>
                        </div>
                        <%if (type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                            { %>
                        <div class="Normal Section">
                            <div class="Heading">
                                <div class="Left"><span class="Text">日程表</span><span class="SecondaryText"></span></div>
                                <div class="Spacer"></div>
                            </div>
                            <div class="DescriptionText">固定工作任务是所有员工参与的任务，持续天数和小时/员工不会自动计算，持续天数和预估小时数由用户指定。对于固定时间任务，工作量会平均分配给指定的员工（小时/员工=预估小时数/已分配的员工数量）。任务的持续天数是花费时间最长的员工持续天数（员工持续天数=（小时/员工）/员工日工作时间）。</div>
                            <div class="Content">
                                <div class="Normal Column">
                                    <div class="RadioButtonGroupContainer">
                                        <div class="RadioButtonGroupLabel">
                                            <div><span class="Label">任务类型</span></div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="TaskTypeFixedWork" data-rdp="TaskTypeFixedWork">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="TaskTypeFixedWork" runat="server" GroupName="TaskType" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="TaskTypeFixedWork">固定工作</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Editor RadioButton" data-editor-id="TaskTypeFixedDuration" data-rdp="TaskTypeFixedDuration">
                                            <div class="InputField">
                                                <div>
                                                    <asp:RadioButton ID="TaskTypeFixedDuration" runat="server" GroupName="TaskType" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="TaskTypeFixedDuration">固定时间</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="EstimatedHours">预估时间</label>
                                        </div>
                                    </div>
                                    <div class="Editor DecimalBox">
                                        <div class="InputField">
                                            <input id="estimated_hours" type="text" value="<%=isAdd ? "0.00" : thisTask.estimated_hours.ToString("#0.00") %>" name="estimated_hours" maxlength="10" class="To2Input" />
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Duration">持续时间</label>
                                        </div>
                                    </div>
                                    <div class="Editor IntegerBox" data-editor-id="Duration" data-rdp="Duration">
                                        <div class="InputField">
                                            <input id="estimated_duration" type="text" value="<%=isAdd ? 1 : thisTask.estimated_duration %>" name="estimated_duration" maxlength="3" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="HoursPerResource">每个员工小时</label>
                                        </div>
                                    </div>
                                    <div class="Editor DecimalBox" data-editor-id="HoursPerResource" data-rdp="HoursPerResource">
                                        <div class="InputField">
                                            <input id="hours_per_resource" type="text" value="<%=(!isAdd)&&thisTask.hours_per_resource!=null?((decimal)thisTask.hours_per_resource).ToString("#0.00"):"0.00" %>" name="hours_per_resource" maxlength="12" class="To2Input" />
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="Small Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="StartDateTime">开始时间</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor DateBox" data-editor-id="StartDateTime" data-rdp="StartDateTime">
                                            <div class="InputField">
                                                <div class="Container">
                                                    <% var startDate = (DateTime)thisProject.start_date;
                                                        if (parTask != null)
                                                        {
                                                            startDate = EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)parTask.estimated_begin_time);
                                                        }
                                                    %>
                                                    <input id="estimated_beginTime" type="text" value="<%=isAdd ? startDate.ToString("yyyy-MM-dd HH:mm:ss") : EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time).ToString("yyyy-MM-dd HH:mm:ss") %>" name="estimated_beginTime" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" style="width: 150px" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="Small Column" style="margin-left: 50px;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="EndDate">结束时间</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor DateBox" data-editor-id="EndDate" data-rdp="EndDate">
                                            <div class="InputField">
                                                <div class="Container">
                                                    <input id="estimated_end_date" type="text" value="<%=isAdd ? startDate.ToString("yyyy-MM-dd") : ((DateTime)thisTask.estimated_end_date).ToString("yyyy-MM-dd") %>" name="estimated_end_date" onclick="WdatePicker()" style="width: 100px;" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="StartNoEarlierThanDate">开始时间不早于</label>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox" data-editor-id="StartNoEarlierThanDate" data-rdp="StartNoEarlierThanDate">
                                        <div class="InputField">
                                            <div class="Container">
                                                <input id="start_no_earlier_than_date" type="text" value="<%=thisTask != null && thisTask.start_no_earlier_than_date != null ? ((DateTime)thisTask.start_no_earlier_than_date).ToString("yyyy-MM-dd") : "" %>" name="start_no_earlier_than_date" onclick="WdatePicker()" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="Normal Section" id="AssignSectionHeader">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse Toggle1">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">分配</span><span class="SecondaryText"></span></div>
                                <div class="Spacer"></div>
                            </div>
                            <div class="Content">
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="department_id">部门</label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect" data-editor-id="Department" data-rdp="Department">
                                        <div class="InputField">
                                            <asp:DropDownList ID="department_id" runat="server"></asp:DropDownList>
                                            <span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly Report" id="WorkloadReportButton" tabindex="0" title="Workload Report"><span class="Icon"></span><span class="Text"></span></a></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="Editor CheckBox" data-editor-id="FilterResourcesByProjectBillingRoles" data-rdp="FilterResourcesByProjectBillingRoles">
                                        <div class="InputField">
                                            <div>
                                                <input id="FilterResByProBilRoles" type="checkbox" value="true" name="FilterResByProBilRoles" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="FilterResourcesByProjectBillingRoles">通过项目计费角色过滤员工</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="WorkType">工作类型<span class="SecondaryText">(分配员工必填)</span></label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect">
                                        <div class="InputField">
                                            <select id="WorkType" name="cost_code_id">
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="PrimaryResource">主负责人</label>
                                        </div>
                                    </div>
                                    <div class="Editor DataSelector" data-editor-id="PrimaryResource" data-rdp="PrimaryResource">
                                        <div class="InputField">
                                            <input id="owner_resource_id" type="text" value="" autocomplete="off" style="width: 250px;" />
                                            <input type="hidden" name="owner_resource_id" id="owner_resource_idHidden" />
                                            <a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PrimaryResource_Button" tabindex="0" onclick="ChoosePriRes()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a>
                                            <div class="ContextOverlayContainer" id="PrimaryResource_ContextOverlay">
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="SecondaryResources">其他负责人</label>
                                        </div>
                                    </div>
                                    <div class="Editor DataSelector" data-editor-id="SecondaryResources" data-rdp="SecondaryResources">
                                        <div class="InputField">
                                            <input id="SecondaryResources_DisplayTextBox" type="text" value="" autocomplete="off" style="width: 250px;" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="SecondaryResources_Button" tabindex="0" onclick="ChooseResDep()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="SecondaryResources" name="SecondaryResources" type="hidden" value="" /><div class="ContextOverlayContainer" id="SecondaryResources_ContextOverlay">

                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                            <div>
                                                <%-- <select id="SecondaryResources_displayListBox" multiple="multiple"></select>--%>
                                                <select multiple="multiple" style="width: 264px; min-height: 80px;" id="resDepList">
                                                    <%string repDepIds = "";
                                                        if (!isAdd)
                                                        {

                                                            var resList = new EMT.DoneNOW.DAL.sdk_task_resource_dal().GetResByTaskId(thisTask.id);
                                                            if (resList != null && resList.Count > 0)
                                                            {
                                                                var syDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                                                var srDal = new EMT.DoneNOW.DAL.sys_role_dal();
                                                                var sdeDal = new EMT.DoneNOW.DAL.sys_resource_department_dal();
                                                                foreach (var res in resList)
                                                                {
                                                                    if (res.resource_id != null && res.role_id != null)
                                                                    {
                                                                        var thisDepList = sdeDal.GetResDepByResAndRole((long)res.resource_id, (long)res.role_id);
                                                                        if (thisDepList != null && thisDepList.Count > 0)
                                                                        {
                                                                            repDepIds += thisDepList[0].id.ToString() + ",";
                                                                        }
                                                                        var thisResou = syDal.FindNoDeleteById((long)res.resource_id);
                                                                        var thisRole = srDal.FindNoDeleteById((long)res.role_id);
                                                                        if (thisResou != null && thisRole != null)
                                                                        {
                                                    %>
                                                    <option><%=thisResou.name + $"({thisRole.name})" %></option>
                                                    <%
                                                                        }
                                                                    }

                                                                }

                                                            }
                                                        }
                                                        if (repDepIds != "")
                                                        {
                                                            repDepIds = repDepIds.Substring(0, repDepIds.Length - 1);
                                                        }
                                                    %>
                                                </select>
                                                <input type="hidden" id="resDepIds" />
                                                <input type="hidden" id="resDepIdsHidden" name="resDepList" value="<%=repDepIds %>" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Contacts">联系人</label>
                                        </div>
                                    </div>
                                    <div class="Editor DataSelector" data-editor-id="Contacts" data-rdp="Contacts">
                                        <div class="InputField">
                                            <input id="Contacts_DisplayTextBox" type="text" value="" autocomplete="off" style="width: 250px;" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="Contacts_Button" tabindex="0" onclick="ChooseContact()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="Contacts" name="Contacts" type="hidden" value="" /><div class="ContextOverlayContainer" id="Contacts_ContextOverlay">
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="AutoComplete ContextOverlay">
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                            <div>

                                                <select multiple="multiple" style="width: 264px; min-height: 80px;" id="conIds">
                                                    <% string conIds = "";
                                                        if (!isAdd)
                                                        {
                                                            var conList = new EMT.DoneNOW.DAL.sdk_task_resource_dal().GetConByTaskId(thisTask.id);
                                                            if (conList != null && conList.Count > 0)
                                                            {
                                                                var cDal = new EMT.DoneNOW.DAL.crm_contact_dal();
                                                                foreach (var con in conList)
                                                                {
                                                                    var thisContact = cDal.FindNoDeleteById((long)con.contact_id);
                                                                    if (thisContact != null)
                                                                    {
                                                                        conIds += thisContact.id.ToString() + ",";
                                                    %>
                                                    <option><%=thisContact.name %></option>
                                                    <%}
                                                                }
                                                            }
                                                        }
                                                        if (conIds != "")
                                                        {
                                                            conIds = conIds.Substring(0, conIds.Length - 1);
                                                        }
                                                    %>
                                                </select>
                                                <input type="hidden" id="contactID" />
                                                <input type="hidden" id="contactIDHidden" name="conIds" value="<%=conIds %>" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="Normal Section" id="UdfSectionHeader">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse Toggle2">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">用户自定义字段</span><span class="SecondaryText"></span></div>
                                <div class="Spacer"></div>
                            </div>
                            <div class="Content">
                                <%if (task_udfList != null && task_udfList.Count > 0)
                                    {
                                        foreach (var udf in task_udfList)
                                        {

                                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                            {%>
                                <div class="Normal Column">
                                    <div class="Udf EditorLabelContainer">
                                        <div class="Label">
                                            <label><%=udf.name %></label>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox Udf">
                                        <div class="InputField">
                                            <div class="Container">
                                                <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=(!isAdd) && task_udfValueList != null && task_udfValueList.Count > 0 ? task_udfValueList.FirstOrDefault(_ => _.id == udf.id).value : "" %>" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                    {
                                %>
                                <div class="Normal Column">
                                    <div class="Udf EditorLabelContainer">
                                        <div class="Label">
                                            <label><%=udf.name %></label>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox Udf">
                                        <div class="InputField">
                                            <div class="Container">
                                                <textarea name="<%=udf.id %>" rows="2" cols="20"><%=(!isAdd) && task_udfValueList != null && task_udfValueList.Count > 0 ? task_udfValueList.FirstOrDefault(_ => _.id == udf.id).value : "" %></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%}
                                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                    {
                                %>
                                <div class="Normal Column">
                                    <div class="Udf EditorLabelContainer">
                                        <div class="Label">
                                            <label><%=udf.name %></label>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox Udf">
                                        <div class="InputField">
                                            <div class="Container">
                                                <%

                                                    string val = "";
                                                    if (!isAdd)
                                                    {
                                                        object value = task_udfValueList.FirstOrDefault(_ => _.id == udf.id).value;
                                                        if (value != null && (!string.IsNullOrEmpty(value.ToString())))
                                                        {
                                                            val = DateTime.Parse(value.ToString()).ToString("yyyy-MM-dd");
                                                        }
                                                    }
                                                %>
                                                <input type="text" onclick="WdatePicker()" name="<%=udf.id %>" class="sl_cdt" value="<%=val %>" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <% }
                                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                    {
                                %>
                                <div class="Normal Column">
                                    <div class="Udf EditorLabelContainer">
                                        <div class="Label">
                                            <label><%=udf.name %></label>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox Udf">
                                        <div class="InputField">
                                            <div class="Container">
                                                <input type="text" name="<%=udf.id %>" class="sl_cdt" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" value="<%=(!isAdd) && task_udfValueList != null && task_udfValueList.Count > 0 ? task_udfValueList.FirstOrDefault(_ => _.id == udf.id).value : "" %>" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%
                                            }
                                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                            {

                                            }
                                        }
                                    } %>
                            </div>
                        </div>

                        <div class="Normal Section" id="notificationHeader">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse Toggle3">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">通知</span><span class="SecondaryText"></span></div>
                                <div class="Spacer"></div>
                            </div>
                            <div class="Content">
                                <div class="Normal Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Notifications_NotificationTemplate">通知模板</label>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect" data-editor-id="Notifications_NotificationTemplate" data-rdp="Notifications_NotificationTemplate">
                                        <div class="InputField">
                                            <asp:DropDownList ID="template_id" runat="server" Width="264px"></asp:DropDownList>
                                        </div>
                                    </div>
                                </div>
                                <div class="Large Column">
                                    <div class="CustomLayoutContainer">
                                        <div class="NotificationRecipients_fromLine">
                                            <span class="NotificationRecipients_text NotificationRecipients_label">发件人:&nbsp;&nbsp;</span>
                                            <span class="NotificationRecipients_text" id="FromEmail"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="Large Column">
                                    <div class="CustomLayoutContainer">
                                        <div>
                                            <span class="NotificationRecipients_text"><a onclick="OpenSelectPage('To')">收件人:</a></span>
                                            <span class="NotificationRecipients_text">
                                                <a id="to_me" onclick="ToMe()">自己</a>
                                                <a id="teamMember" style="margin-left: 5px;" onclick="ToTeamMember()">团队成员</a>
                                                <a id="ProLead" style="margin-left: 5px;" onclick="ToProjectLead()">项目主管</a>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Notifications_ToEmailDisplay"></label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox LabeledValue" data-editor-id="Notifications_ToEmailDisplay">
                                        <span class="Value" id="To_Email" style="font-size: 9pt;"></span>
                                    </div>

                                </div>
                                <div class="Large Column">
                                    <div class="CustomLayoutContainer">
                                        <div>
                                            <span class="NotificationRecipients_text"><a onclick="OpenSelectPage('Cc')">抄送:</a></span>
                                            <span class="NotificationRecipients_text">
                                                <a id="cc_me" onclick="CcToMe()">自己</a>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Notifications_CCEmailDisplay"></label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox LabeledValue" data-editor-id="Notifications_CCEmailDisplay">
                                        <span class="Value" id="Cc_Email" style="font-size: 9pt;"></span>
                                    </div>
                                </div>
                                <div class="Large Column">
                                    <div class="CustomLayoutContainer">
                                        <div>
                                            <span class="NotificationRecipients_text"><a onclick="OpenSelectPage('Bcc')">密送:</a></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="Large Column">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Notifications_BccEmailDisplay"></label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox LabeledValue" data-editor-id="Notifications_BccEmailDisplay">
                                        <span class="Value" id="Bcc_Email" style="font-size: 9pt;"></span>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Notifications_Subject">主题</label>
                                        </div>
                                    </div>
                                    <div class="Editor TextBox" data-editor-id="Notifications_Subject" data-rdp="Notifications_Subject">
                                        <div class="InputField">
                                            <input type="text" style="width: 696px;" id="subject" name="subject" value="" />
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="Notifications_AdditionalEmailText">其他邮件文本</label>
                                        </div>
                                    </div>
                                    <div class="Editor TextArea" data-editor-id="Notifications_AdditionalEmailText" data-rdp="Notifications_AdditionalEmailText">
                                        <div class="InputField">
                                            <textarea style="min-height: 100px; width: 610px;" id="otherEmail" name="otherEmail"></textarea>
                                        </div>
                                    </div>
                                    <div class="CustomLayoutContainer">
                                        <div class="NotificationRecipients_editDefaultSettingsContainer">
                                            <a href="#" onclick="notificationRecipients.openDefaultSettings();" class="NotificationRecipients_links">修改默认设置</a>:
				&nbsp;
                                        </div>

                                        <input type="hidden" name="NoToMe" id="NoToMe" />
                                        <input type="hidden" name="NoToTeamMem" id="NoToTeamMem" />
                                        <input type="hidden" name="NoToProlead" id="NoToProlead" />

                                        <input type="hidden" name="NoToContactIds" id="NoToContactIds" />
                                        <input type="hidden" name="NoToResIds" id="NoToResIds" />
                                        <input type="hidden" name="NoToDepIds" id="NoToDepIds" />
                                        <input type="hidden" name="NoToWorkIds" id="NoToWorkIds" />
                                        <input type="hidden" name="NoToOtherMail" id="NoToOtherMail" />

                                        <input type="hidden" name="NoCcMe" id="NoCcMe" />
                                        <input type="hidden" name="NoCcContactIds" id="NoCcContactIds" />
                                        <input type="hidden" name="NoCcResIds" id="NoCcResIds" />
                                        <input type="hidden" name="NoCcDepIds" id="NoCcDepIds" />
                                        <input type="hidden" name="NoCcWorkIds" id="NoCcWorkIds" />
                                        <input type="hidden" name="NoCcOtherMail" id="NoCcOtherMail" />

                                        <input type="hidden" name="NoBccContactIds" id="NoBccContactIds" />
                                        <input type="hidden" name="NoBccResIds" id="NoBccResIds" />
                                        <input type="hidden" name="NoBccDepIds" id="NoBccDepIds" />
                                        <input type="hidden" name="NoBccWorkIds" id="NoBccWorkIds" />
                                        <input type="hidden" name="NoBccOtherMail" id="NoBccOtherMail" />

                                    </div>
                                </div>
                            </div>
                        </div>
                        <%}
                            else
                            { %>
                        <div class="Normal Section">
                            <div class="Heading">
                                <div class="Left"><span class="Text">日程表</span><span class="SecondaryText"></span></div>
                                <div class="Spacer"></div>
                            </div>
                            <div class="Content">
                                <div class="Large Column">
                                    <div class="Small Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="StartDate">开始时间</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor DateBox" data-editor-id="StartDate" data-rdp="StartDate">
                                            <div class="InputField">
                                                <div class="Container">
                                                    <% var startDate = (DateTime)thisProject.start_date;
                                                        if (parTask != null)
                                                        {
                                                            startDate = EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)parTask.estimated_begin_time);
                                                        }
                                                    %>
                                                    <input id="estimated_beginTime" type="text" value="<%=isAdd ? startDate.ToString("yyyy-MM-dd HH:mm:ss") : EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time).ToString("yyyy-MM-dd HH:mm:ss") %>" name="estimated_beginTime" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" style="width: 150px" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Small Column" style="margin-left: 50px;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="EndDate">结束时间</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor DateBox" data-editor-id="EndDate" data-rdp="EndDate">
                                            <div class="InputField">
                                                <div class="Container">
                                                    <input id="estimated_end_date" type="text" value="<%=isAdd ? startDate.ToString("yyyy-MM-dd") : ((DateTime)thisTask.estimated_end_date).ToString("yyyy-MM-dd") %>" name="estimated_end_date" onclick="WdatePicker()" style="width: 100px;" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Small Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="EstimatedHours">预估时间</label>
                                            </div>
                                        </div>
                                        <div class="Editor TextBox LabeledValue" data-editor-id="EstimatedHours">
                                            <div class="InputField"><span class="Value"><%=isAdd ? "" : thisTask.estimated_hours.ToString("#0.00")  %></span></div>

                                        </div>
                                    </div>
                                    <div class="Small Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="Duration">持续时间</label>
                                            </div>
                                        </div>
                                        <div class="Editor TextBox LabeledValue" data-editor-id="Duration">
                                            <div class="InputField">
                                                <span class="Value"><%=thisTask!=null&&thisTask.estimated_duration!=null?thisTask.estimated_duration.ToString():""  %></span><span class="CustomHtml"><div class="StandardText">days</div>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="Normal Section" id="BudgetSectionHeader">
                            <div class="Heading" data-toggle-enabled="true">
                                <div class="Toggle Collapse">
                                    <div class="Vertical"></div>
                                    <div class="Horizontal"></div>
                                </div>
                                <div class="Left"><span class="Text">预算</span><span class="SecondaryText"></span></div>
                                <div class="Spacer"></div>
                            </div>
                            <div class="DescriptionText">与此项目关联的合同将决定这个项目可用的角色。</div>
                            <% if (rateList != null && rateList.Count > 0){ %>
                            <div class="Content">
                                <div class="Large Column">
                                    <div class="CustomLayoutContainer">
                                        <table class="PhaseEditor_BudgetTable" style="710px;">
                                            <colgroup>
                                                <col class="PhaseEditor_col1">
                                                <col class="PhaseEditor_col2">
                                                <col class="PhaseEditor_col3">
                                                <col class="PhaseEditor_col4">
                                                <col class="PhaseEditor_col5">
                                            </colgroup>
                                            <tbody>
                                                <tr class="PhaseEditor_head">
                                                    <td>
                                                        <span class="PhaseEditor_HeadingText">角色</span>
                                                    </td>
                                                    <td>
                                                        <span class="PhaseEditor_HeadingText">合同计费角色</span><br>
                                                        <span class="PhaseEditor_smallHeadingText">（每小时）</span>
                                                    </td>
                                                    <td>
                                                        <span class="PhaseEditor_HeadingText">预估时间</span>
                                                    </td>
                                                    <td>
                                                        <span class="PhaseEditor_HeadingText">预算时间</span><br>
                                                        <span class="PhaseEditor_smallHeadingText">（总数/剩余）</span>
                                                    </td>
                                                    <td>
                                                        <span class="PhaseEditor_HeadingText">实际时间</span>
                                                    </td>
                                                </tr>
                                                <%if (rateList != null && rateList.Count > 0)
                                                                              {
                                                                                  var roleDal = new EMT.DoneNOW.DAL.sys_role_dal();
                                                                                  var stbDal = new EMT.DoneNOW.DAL.sdk_task_budget_dal();
                                                                                  var proBLL = new EMT.DoneNOW.BLL.ProjectBLL();
                                                                                  var yuguTime = proBLL.ESTIMATED_HOURS(thisProject.id);
                                                                                  var shijiTime = proBLL.ProWorkHours(thisProject.id);
                                                                                  foreach (var rate in rateList)
                                                                                  {
                                                                                      EMT.DoneNOW.Core.sdk_task_budget stb = null;
                                                                                      var thisrole = roleDal.FindNoDeleteById(rate.role_id);
                                                                                      if (!isAdd && thisTask != null)
                                                                                      {
                                                                                          stb = stbDal.GetSinByTIdRid(thisTask.id, rate.id);
                                                                                      }
                                                %>
                                                <tr>
                                                    <td>
                                                        <span class="PhaseEditor_Text"><%=thisrole == null ? "" : thisrole.name %></span>
                                                    </td>
                                                    <td class="PhaseEditor_numericInput">
                                                        <span class="PhaseEditor_Text">¥<%=rate.rate != null ? ((decimal)rate.rate).ToString("#0.00") : "" %></span>
                                                    </td>
                                                    <td class="PhaseEditor_numericInput">
                                                        <span class="PhaseEditor_Text"><%=yuguTime.ToString("#0.00") %></span>
                                                    </td>
                                                    <td class="col4 PhaseEditor_numericInput">
                                                        <input class="PhaseEditor_inputText" type="text" id="<%=rate.id %>_esHours" name="<%=rate.id %>_esHours" value="<%=stb == null ? "" : ((int)stb.estimated_hours).ToString("#0.00") %>" />
                                                        <div class="PhaseEditor_Text PhaseEditor_hoursRemaining">&nbsp;/&nbsp;<%=stb == null ? "" : stb.estimated_hours.ToString("#0.00") %></div>
                                                    </td>
                                                    <td class="PhaseEditor_numericInput">
                                                        <span class="PhaseEditor_Text"><%=shijiTime.ToString("#0.00") %></span>
                                                    </td>
                                                </tr>
                                                <%}
                                                                              }
                                                                              else
                                                                              { %>

                                                <%} %>


                                                <tr>
                                                    <td colspan="5" class="PhaseEditor_noBorder">&nbsp;</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="Normal Column">
                                    <div class="Medium Column"><a class="Button ButtonIcon NormalState" id="RecalculateBudgetButton" tabindex="0"><span class="Icon"></span><span class="Text">Recalculate</span></a></div>
                                </div>
                            </div>
                            <%} %>
                        </div>


                        <%} %>
                    </div>
                    <%if (!isAdd)
                        { %>
                    <%if (!isPhase)
                        { %>
                    <div class="IsShowDiv" id="serCallsDiv" style="display: none;">
                    </div>

                    <%}
                        else
                        { %>
                    <div class="IsShowDiv" id="milestonesDiv" style="display: none;">
                        <div class="ScrollingContentContainer">
                            <div class="ScrollingContainer" id="z5bc1074cedb74feba8b7539e6ef70863">
                                <div class="Instructions">
                                    <div class="InstructionItem">与固定价格合同相关的项目可以通过里程碑在项目进度的不同点通知客户。它们是通过固定价格合同直接创建和管理的（只适用于固定价格合同）。 </div>
                                </div>


                                <div class="Normal Section">
                                    <div class="Heading">
                                        <div class="Left"><span class="Text">项目合同</span><span class="SecondaryText"></span></div>
                                        <div class="Spacer"></div>
                                    </div>
                                    <div class="Content">
                                        <div class="Normal Column">
                                            <div class="StandardText">名字</div>
                                            <a class="Button ButtonIcon Link NormalState" id="ContractLinkButton" tabindex="0"><%=thisProContract==null?"":thisProContract.name %></a>
                                        </div>
                                        <div class="Normal Column">
                                            <div class="StandardText">类型</div>
                                            <div class="StandardText">
                                                <% if (thisProContract != null)
                                                    {
                                                        var thistype = new EMT.DoneNOW.DAL.d_general_dal().FindNoDeleteById(thisProContract.type_id); %><%=thistype==null?"":thistype.name %><%} %>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="Normal Section">
                                    <div class="Heading">
                                        <div class="Left"><span class="Text">合同里程碑</span><span class="SecondaryText"></span></div>
                                        <div class="Spacer"></div>
                                    </div>
                                    <div class="DescriptionText">与固定价格合同相关联的项目可以通过里程碑在项目进度不同阶段向客户收费。里程碑是通过固定价格合同直接创建和管理的。可以将一个或多个里程碑与此阶段相关联，但一个里程碑只能与一个项目阶段相关联。 .</div>
                                    <div class="Content">
                                        <div class="Large Column">
                                            <div class="GridBar ButtonContainer"><a class="Button ButtonIcon DisabledState" id="AssociateListButton" tabindex="0" style="color: rgba(95,95,95,0.4);"><span class="Icon"></span><span class="Text">关联</span></a><a class="Button ButtonIcon DisabledState" id="DisassociateListButton" tabindex="0" style="color: rgba(95,95,95,0.4);"><span class="Icon"></span><span class="Text">取消关联</span></a><a class="Button ButtonIcon DisabledState" id="ReadyForBillingListButton" tabindex="0" style="color: rgba(95,95,95,0.4);"><span class="Icon"></span><span class="Text">标记为准备计费</span></a></div>
                                            <div class="Grid Small" id="PhaseMilestoneGrid">
                                                <div class="HeaderContainer">
                                                    <table cellpadding="0">
                                                        <colgroup>
                                                            <col class="Normal ToggleSelection">
                                                            <col class=" Context">
                                                            <col class=" Text DynamicSizing" data-persistence-key="Name" data-unique-css-class="U2" style="width: auto;">
                                                            <col class="Normal Text" data-persistence-key="Status" data-unique-css-class="U3">
                                                            <col class="Normal Currency" data-persistence-key="Amount" data-unique-css-class="U4">
                                                            <col class="Normal Date" data-persistence-key="DueDate" data-unique-css-class="U5">
                                                            <col class=" Boolean" data-persistence-key="IsAssociated" data-unique-css-class="U6">
                                                        </colgroup>
                                                        <tbody>
                                                            <tr class="HeadingRow">
                                                                <td class=" ToggleSelection">
                                                                    <div class="Standard"><a class="Button ButtonIcon IconOnly CheckBox NormalState" id="PhaseMilestoneGrid_SelectionColumnButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px -32px;"></span><span class="Text"></span></a></div>
                                                                </td>
                                                                <td class="Context">
                                                                    <div class="Standard">
                                                                        <div></div>
                                                                    </div>
                                                                </td>
                                                                <td class="Text Dynamic">
                                                                    <div class="Standard">
                                                                        <div class="Heading">里程碑名称</div>
                                                                    </div>
                                                                </td>
                                                                <td class="Normal Text">
                                                                    <div class="Standard">
                                                                        <div class="Heading">状态</div>
                                                                    </div>
                                                                </td>
                                                                <td class=" Currency">
                                                                    <div class="Standard">
                                                                        <div class="Heading">金额</div>
                                                                    </div>
                                                                </td>
                                                                <td class=" Date">
                                                                    <div class="Standard">
                                                                        <div class="Heading">到期日</div>
                                                                    </div>
                                                                </td>
                                                                <td class=" Boolean">
                                                                    <div class="Standard">
                                                                        <div class="Heading">关联</div>
                                                                    </div>
                                                                </td>
                                                                <td class="ScrollBarSpacer" style="width: 17px;"></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div class="ScrollingContentContainer">

                                                    <div class="NoDataMessage">没有数据</div>
                                                    <div class="RowContainer BodyContainer">
                                                        <table cellpadding="0">
                                                            <colgroup>
                                                                <col class="Normal ToggleSelection">
                                                                <col class=" Context">
                                                                <col class=" Text DynamicSizing" style="width: auto;">
                                                                <col class="Normal Text">
                                                                <col class="Normal Currency">
                                                                <col class="Normal Date">
                                                                <col class=" Boolean">
                                                            </colgroup>
                                                            <tbody>
                                                                <%if (thisPhaMile != null && thisPhaMile.Count > 0)
                                                                    {
                                                                        foreach (var thisMile in thisPhaMile)
                                                                        {%>
                                                                <tr class="D" data-val="<%=thisMile.id %>">
                                                                    <td class="ToggleSelection  U0">
                                                                        <!--conMile   taskMile-->
                                                                        <div class="Decoration Icon CheckBox">
                                                                            <input type="checkbox" class="CheckMile <%=thisMile.type %> <%=thisMile.status_id %>" value="<%=thisMile.id %>" />
                                                                        </div>
                                                                    </td>
                                                                    <td class="Context  U1"><a class="ButtonIcon Button MileContextMenu ContextMenu NormalState">
                                                                        <input type="hidden" value="<%=thisMile.id %>" />
                                                                        <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px;"></div>
                                                                    </a></td>
                                                                    <td class="Text  U2"><%=thisMile.name %></td>
                                                                    <td class="Text Normal U3"><%=thisMile.status %></td>
                                                                    <td class="Currency  U4"><%=thisMile.amount.ToString("#0.00") %></td>
                                                                    <td class="Date  U5"><%=thisMile.dueDate.ToString("yyyy-MM-dd") %></td>
                                                                    <td class="Boolean  U6">
                                                                        <div class="Decoration Icon CheckMark"><%=thisMile.isAss %></div>
                                                                    </td>
                                                                </tr>
                                                                <%}
                                                                    } %>
                                                            </tbody>
                                                        </table>
                                                        <div class="ContextOverlayContainer" id="PhaseMilestoneGrid_ContextOverlay">
                                                            <div class="ContextOverlay">
                                                                <div class="Outline Arrow"></div>
                                                                <div class="Arrow"></div>
                                                                <div class="Active LoadingIndicator"></div>
                                                                <div class="Content"></div>
                                                            </div>
                                                            <div class="ContextOverlay">
                                                                <div class="Outline Arrow"></div>
                                                                <div class="Arrow"></div>
                                                                <div class="Active LoadingIndicator"></div>
                                                                <div class="Content"></div>
                                                            </div>
                                                        </div>
                                                        <div class="DragIndicator">
                                                            <div class="Bar"></div>
                                                            <div class="LeftArrow"></div>
                                                            <div class="RightArrow"></div>
                                                        </div>
                                                        <div class="DragStatus"></div>
                                                    </div>
                                                </div>
                                                <div class="FooterContainer"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%} %>
                    <div id="noteDiv" style="display: none;" class="IsShowDiv">
                        <div class="TabContainer Active" id="NotesTab">
                            <div class="DynamicGridContainer">
                                <div class="Grid Large" id="TaskNoteGrid">
                                    <div class="HeaderContainer">
                                        <table cellpadding="0">
                                            <colgroup>
                                                <col class=" Context">
                                                <col class=" Text DynamicSizing" data-persistence-key="Title" data-unique-css-class="U1" style="width: auto;">
                                                <col class="Normal Text" data-persistence-key="TaskNoteType" data-unique-css-class="U2">
                                                <col class="Normal Text" data-persistence-key="PostedBy" data-unique-css-class="U3">
                                                <col class="Normal Date" data-persistence-key="DatePosted" data-unique-css-class="U4">
                                            </colgroup>
                                            <tbody>
                                                <tr class="HeadingRow">
                                                    <td class=" Context">
                                                        <div class="Standard">
                                                            <div></div>
                                                        </div>
                                                    </td>
                                                    <td class=" Text Dynamic">
                                                        <div class="Standard">
                                                            <div class="Heading">标题</div>
                                                        </div>
                                                    </td>
                                                    <td class="Normal Text">
                                                        <div class="Standard">
                                                            <div class="Heading">类型</div>
                                                        </div>
                                                    </td>
                                                    <td class="Normal Text">
                                                        <div class="Standard">
                                                            <div class="Heading">发表人</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Date">
                                                        <div class="Standard">
                                                            <div class="Heading">发表时间</div>
                                                        </div>
                                                    </td>
                                                    <td class="ScrollBarSpacer" style="width: 17px;"></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="ScrollingContentContainer">
                                        <%if (noteList != null && noteList.Count > 0)
                                            { %>
                                        <div class="RowContainer BodyContainer">
                                            <table cellpadding="0">
                                                <colgroup>
                                                    <col class=" Context">
                                                    <col class=" Text DynamicSizing" style="width: auto;">
                                                    <col class="Normal Text">
                                                    <col class="Normal Text">
                                                    <col class="Normal Date">
                                                </colgroup>
                                                <tbody>
                                                    <%
                                                        var sysList = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                                                        foreach (var thisNote in noteList)
                                                        { %>
                                                    <tr class="D" id="<%=thisNote.id %>" data-val="<%=thisNote.id %>">
                                                        <td class="Context  U0"><a class="ButtonIcon Button NoteContextMenu ContextMenu NormalState">
                                                            <input type="hidden" value="<%=thisNote.id %>" />
                                                            <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px;"></div>
                                                        </a></td>
                                                        <td class="Text  U1"><%=thisNote.name %></td>
                                                        <td class="Text Normal U2"><%="" %></td>
                                                        <td class="Text Normal U3"><% var thisRes = sysList.FirstOrDefault(_ => _.val == thisNote.create_user_id.ToString()); %>
                                                            <%=thisRes==null?"":thisRes.show %>
                                                        </td>
                                                        <td class="Date  U4"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisNote.create_time).ToString("yyyy-MM-dd") %></td>
                                                    </tr>
                                                    <%}%>
                                                </tbody>
                                            </table>
                                            <div class="ContextOverlayContainer" id="TaskNoteGrid_ContextOverlay">
                                                <div class="ContextOverlay" style="left: 6px; top: 166px;">
                                                    <div class="Bottom Arrow Outline" style="left: 1px;"></div>
                                                    <div class="Bottom Arrow" style="left: 1px;"></div>
                                                    <div class="LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                                <div class="ContextOverlay">
                                                    <div class="Outline Arrow"></div>
                                                    <div class="Arrow"></div>
                                                    <div class="Active LoadingIndicator"></div>
                                                    <div class="Content"></div>
                                                </div>
                                            </div>
                                            <div class="DragIndicator">
                                                <div class="Bar"></div>
                                                <div class="LeftArrow"></div>
                                                <div class="RightArrow"></div>
                                            </div>
                                            <div class="DragStatus"></div>
                                        </div>
                                        <%}
                                            else
                                            { %>
                                        <div class="NoDataMessage">没有数据</div>
                                        <%} %>
                                    </div>
                                    <div class="FooterContainer"></div>
                                </div>

                            </div>
                        </div>
                    </div>
                    <%} %>
                </div>
            </div>
        </div>

        <div class="Dialog Large" style="margin-left: 100px; margin-top: 10px; z-index: 100; height: 650px;" id="Nav2">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title"><span class="Text">定义前驱任务</span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="ButtonContainer"><a class="Button ButtonIcon Okay NormalState" id="SaveAndCloseDialogButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat 0px -64px;"></span><span class="Text">完成</span></a></div>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer" id="z593dad524573453c982e0308d60c09ae" style="overflow-x: auto; overflow-y: auto; position: unset;">
                            <div class="Normal Section">
                                <div class="Heading">
                                    <div class="Left"><span class="Text">定义前驱任务</span><span class="SecondaryText"></span></div>
                                    <div class="Spacer"></div>
                                </div>
                                <div class="DescriptionText">为日程表条目定义前驱方法：点击编号列，输入延迟时间，可以定义多个前驱。</div>
                                <div class="Content">
                                    <div class="Large Column">
                                        <div class="Grid Small" id="PredecessorItemsGrid">
                                            <div class="HeaderContainer">
                                                <table cellpadding="0">
                                                    <colgroup>
                                                        <col class=" Interaction" data-is-drop-into-enabled="true">
                                                        <col class=" Nesting DynamicSizing" data-persistence-key="Name" data-unique-css-class="U1" style="width: auto;">
                                                        <col class="Normal Date" data-persistence-key="StartDate" data-unique-css-class="U2">
                                                        <col class="Normal Date" data-persistence-key="EndDate" data-unique-css-class="U3">
                                                    </colgroup>
                                                    <tbody>
                                                        <tr class="HeadingRow">
                                                            <td class="">
                                                                <div class="Standard"></div>
                                                            </td>
                                                            <td class=" Nesting Dynamic">
                                                                <div class="Standard">
                                                                    <div class="Heading">阶段/任务/问题</div>
                                                                </div>
                                                            </td>
                                                            <td class=" Date">
                                                                <div class="Standard">
                                                                    <div class="Heading">开始时间</div>
                                                                </div>
                                                            </td>
                                                            <td class=" Date">
                                                                <div class="Standard">
                                                                    <div class="Heading">结束时间</div>
                                                                </div>
                                                            </td>
                                                            <td class="ScrollBarSpacer" style="width: 17px;"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="ScrollingContentContainer" style="height: 160px;">
                                                <div class="NoDataMessage" id="NoPreTask">没有条目展示</div>
                                                <div class="RowContainer BodyContainer">
                                                    <table cellpadding="0">
                                                        <colgroup>
                                                            <col class=" Interaction">
                                                            <col class=" Nesting DynamicSizing" style="width: auto;">
                                                            <col class="Normal Date">
                                                            <col class="Normal Date">
                                                        </colgroup>
                                                        <tbody id="choProTaskList">
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="FooterContainer"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Section" style="height: 240px">
                                <div class="Heading">
                                    <% string preIds = "";
                                        if (preList != null && preList.Count > 0)
                                        {
                                            preList.ForEach(_ => { preIds += _.predecessor_task_id.ToString() + ','; });
                                            if (preIds != null)
                                            {
                                                preIds = preIds.Substring(0, preIds.Length - 1);
                                            }
                                        }
                                    %>

                                    <input type="hidden" name="tempPreIds" id="tempPreIds" value="<%=preIds %>" />
                                    <input type="hidden" name="preIds" id="preIds" value="<%=preIds %>" />

                                    <!--用户在页面上选择的前驱任务Ids -->
                                    <div class="Left"><span class="Text">前驱任务</span><span class="SecondaryText"></span></div>
                                    <div class="Spacer"></div>
                                </div>
                                <div class="DescriptionText">这个条目的开始日期是根据最新的前驱的结束日期+延迟时间来确定的。如果定义了多个前驱，则使用最新的前驱结束日期+延迟时间。</div>
                                <div class="Content">
                                    <div class="Large Column">
                                        <div class="PredecessorItemsSelectDialog_Grid PredecessorItemsSelectDialog_Small">
                                            <div class="PredecessorItemsSelectDialog_HeaderContainer">
                                                <table cellpadding="0">
                                                    <colgroup>
                                                        <col class="PredecessorItemsSelectDialog_Id">
                                                        <col class="PredecessorItemsSelectDialog_Context">
                                                        <col class="PredecessorItemsSelectDialog_Text">
                                                        <col class="PredecessorItemsSelectDialog_Date">
                                                        <col class="PredecessorItemsSelectDialog_Date">
                                                        <col class="PredecessorItemsSelectDialog_Text">
                                                        <col class="PredecessorItemsSelectDialog_SizingSpacer" width="0">
                                                    </colgroup>
                                                    <tbody id="predecessorTableBody">
                                                        <tr>
                                                            <td class="PredecessorItemsSelectDialog_Context">ID</td>
                                                            <td class="PredecessorItemsSelectDialog_Context" style="width: 30px;"></td>
                                                            <td class="PredecessorItemsSelectDialog_Dynamic PredecessorItemsSelectDialog_Text">阶段/任务/问题</td>
                                                            <td class="PredecessorItemsSelectDialog_Date">开始时间</td>
                                                            <td class="PredecessorItemsSelectDialog_Date">结束时间</td>
                                                            <td class="PredecessorItemsSelectDialog_Text">延迟天数</td>
                                                            <td class="PredecessorItemsSelectDialog_ScrollBarSpacer" width="14px"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="PredecessorItemsSelectDialog_BodyContainer PredecessorItemsSelectDialog_RowContainer" style="height: 150px;">
                                                <table cellpadding="0" id="PredecessorItemsSelectedTable">
                                                    <colgroup>
                                                        <col class="PredecessorItemsSelectDialog_Id">
                                                        <col class="PredecessorItemsSelectDialog_Context">
                                                        <col class="PredecessorItemsSelectDialog_Text">
                                                        <col class="PredecessorItemsSelectDialog_Date">
                                                        <col class="PredecessorItemsSelectDialog_Date">
                                                        <col class="PredecessorItemsSelectDialog_Text">
                                                        <col class="PredecessorItemsSelectDialog_SizingSpacer" width="0">
                                                    </colgroup>
                                                    <tbody>
                                                        <tr id="HiddenField" style="display: none;">
                                                            <td class="PredecessorItemsSelectDialog_OutlineId PredecessorItemsSelectDialog_Text"></td>
                                                            <td class="PredecessorItemsSelectDialog_Context"><a class="PredecessorItemsSelectDialog_Delete PredecessorItemsSelectDialog_Button" onclick="(function () { $('#').remove();})();">
                                                                <div class="PredecessorItemsSelectDialog_Icon"></div>
                                                            </a></td>
                                                            <td class="PredecessorItemsSelectDialog_Title PredecessorItemsSelectDialog_Text"></td>
                                                            <td class="PredecessorItemsSelectDialog_Date"></td>
                                                            <td class="PredecessorItemsSelectDialog_Date"></td>
                                                            <td class="PredecessorItemsSelectDialog_Text">
                                                                <input class="LagInput" placeholder="Lag (days)" type="text" value=""></td>
                                                            <td class="PredecessorItemsSelectDialog_SizingSpacer" width="0"></td>
                                                        </tr>
                                                        <%if (preList != null && preList.Count > 0)
                                                            {
                                                                var stDal = new EMT.DoneNOW.DAL.sdk_task_dal();
                                                                foreach (var thisPre in preList)
                                                                {
                                                                    var thisPreTask = stDal.FindNoDeleteById(thisPre.predecessor_task_id);
                                                        %>
                                                        <tr id='<%=thisPre.predecessor_task_id %>_temp'>
                                                            <td class='PredecessorItemsSelectDialog_OutlineId PredecessorItemsSelectDialog_Text'><%=thisPreTask.sort_order %></td>
                                                            <td class='PredecessorItemsSelectDialog_Context' style='width: 30px;'><a class='PredecessorItemsSelectDialog_Delete PredecessorItemsSelectDialog_Button' onclick='RemoveThis("<%=thisPre.predecessor_task_id %>")'>
                                                                <div class='PredecessorItemsSelectDialog_Icon'><span class='Icon' style='background: url(../Images/ButtonBarIcons.png) no-repeat -66px -2px;'>&nbsp;&nbsp;&nbsp;&nbsp;</span></div>
                                                            </a></td>
                                                            <td class='PredecessorItemsSelectDialog_Title PredecessorItemsSelectDialog_Text'><%=thisPreTask.title %></td>
                                                            <td class='PredecessorItemsSelectDialog_Date'><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisPreTask.estimated_begin_time).ToString("yyyy-MM-dd") %></td>
                                                            <td class='PredecessorItemsSelectDialog_Date'><%=((DateTime)thisPreTask.estimated_end_date).ToString("yyyy-MM-dd") %></td>
                                                            <td class='PredecessorItemsSelectDialog_Text'>
                                                                <input class='LagInput' placeholder='Lag (days)' type='text' id='<%=thisPreTask.id %>_lagDays' name='<%=thisPreTask.id %>_lagDays' value='<%=thisPre.dependant_lag %>'></td>
                                                            <td class='PredecessorItemsSelectDialog_SizingSpacer' width='0'></td>
                                                        </tr>
                                                        <%} %>

                                                        <%} %>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="PredecessorItemsSelectDialog_FooterContainer"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--黑色幕布-->
        <div id="BackgroundOverLay"></div>
        <div class="Dialog Large" style="margin-left: 100px; margin-top: 100px; z-index: 100; height: 650px; display: none;" id="CompletionReasonDialog">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" id="CloseStatusReson"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title"><span class="Text">完成任务原因</span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="DialogHeadingContainer">
                        <div class="ValidationSummary" id="z3ce7f40373d04055865c00c8e1805891">
                            <div class="CustomValidation Valid"></div>
                            <div class="FormValidation Valid">
                                <div class="ErrorContent">
                                    <div class="TransitionContainer">
                                        <div class="IconContainer">
                                            <div class="Icon"></div>
                                        </div>
                                        <div class="TextContainer"><span class="Count"></span><span class="Count Spacer"></span><span class="Message"></span></div>
                                    </div>
                                </div>
                                <div class="ChevronContainer">
                                    <div class="Up"></div>
                                    <div class="Down"></div>
                                </div>
                            </div>
                        </div>
                        <div class="ButtonContainer">
                            <a class="Button ButtonIcon Save NormalState" id="SaveAndCloseCompleteButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">
                                <asp:Button ID="save_close2" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close2_Click" /></span></a>
                        </div>
                    </div>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer" id="za40a15b2846a4b8a8cab26c764754801" style="position: unset;">
                            <form action="/Mvc/Projects/Task.mvc/CompletionReasonDialog" id="CompletionReasonForm" method="post">
                                <div class="Medium NoHeading Section">
                                    <div class="Content">
                                        <div class="Normal Column">
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label for="ajax303a00d30ad844dcb3e55c4b5a88de3c_1_Reason">原因</label><span class="Required">*</span>
                                                </div>
                                            </div>
                                            <div class="Editor TextArea" data-editor-id="ajax303a00d30ad844dcb3e55c4b5a88de3c_1_Reason" data-rdp="ajax303a00d30ad844dcb3e55c4b5a88de3c_1_Reason">
                                                <div class="InputField">
                                                    <textarea class="Medium" id="reason" name="reason" placeholder=""></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" id="IsCheckResHOurs" />
        <div id="AssMileMenu" class="menu">
            <ul style="width: 220px;">
                <li id="" onclick="AssSingMile()" style="font-size: 9pt;"><i class="menu-i1"></i>关联里程碑
                </li>
            </ul>
        </div>
        <div id="DisAssMileMenu" class="menu">
            <ul style="width: 220px;">
                <li id="" onclick="DisAssSingMile()" style="font-size: 9pt;"><i class="menu-i1"></i>取消关联
                </li>
            </ul>
        </div>
        <div id="NoteManageMenu" class="menu">
            <ul style="width: 220px;">
                <li id="" onclick="EditNote()" style="font-size: 9pt;"><i class="menu-i1"></i>修改备注
                </li>
                <li id="" onclick="DeleteNote()" style="font-size: 9pt;"><i class="menu-i1"></i>删除备注
                </li>
            </ul>
        </div>

        <input type="hidden" id="IsEditEsTime" name="IsEditEsTime" value="" /><!--ti   -->
        <% EMT.DoneNOW.Core.v_task_all thisVTask = null;
            if (!isAdd)
            {
                thisVTask = new EMT.DoneNOW.DAL.v_task_all_dal().FindById(thisTask.id);
            } %>
        <input type="hidden" id="shengyuTime" value="<%=thisVTask!=null&&thisVTask.remain_hours!=null?((decimal)thisVTask.remain_hours).ToString("#0.00"):"" %>" />
        <input type="hidden" id="olfEsTime" name="olfEsTime" value="<%=thisTask!=null?thisTask.estimated_hours.ToString("#0.00"):"" %>" />
    </form>
</body>
</html>
<%--<script src="../Scripts/jquery-3.2.1.min.js"></script>--%>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<%--<script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>--%>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<%--<script src="../Scripts/NewProject.js"></script>--%>
<script>
    var colors = ["#efefef", "white"];
    var index1 = 0; var index2 = 0; var index3 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index1 % 2]);
        index1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index2 % 2]);
        index2++;
    });
    $(".Toggle3").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index3 % 2]);
        index3++;
    });
    $(".f1").on("mouseover", function () {
        $(this).css("background", "white");
        $(this).css("border-bottom", "none");
        $("#D1").show();
    });
    $(".f1").on("mouseout", function () {
        $("#D1").hide();
        $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("border-bottom", "1px solid #BCBCBC");
    });
    $("#D1").on("mouseover", function () {
        $(this).show();
        $(".f1").css("background", "white");
        $(".f1").css("border-bottom", "none");
    });
    $("#D1").on("mouseout", function () {
        $(this).hide();
        $(".f1").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".f1").css("border-bottom", "1px solid #BCBCBC");
    });


    $(".A1").on("mouseover", function () {
        $(this).css("background", "white");
        $(this).css("border-bottom", "none");
        $("#B1").show();
    });
    $(".A1").on("mouseout", function () {
        $("#B1").hide();
        $(this).css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(this).css("border-bottom", "1px solid #BCBCBC");
    });
    $("#B1").on("mouseover", function () {
        $(this).show();
        $(".A1").css("background", "white");
        $(".A1").css("border-bottom", "none");
    });
    $("#B1").on("mouseout", function () {
        $(this).hide();
        $(".A1").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".A1").css("background", "-ms-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".A1").css("background", "-webkit-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".A1").css("background", "-moz-linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".A1").css("border-bottom", "1px solid #BCBCBC");
    });

    $(".lblNormalClass").on("mouseover", function () {
        $(this).parent().css("background", "#E9F0F8");
    });
    $(".lblNormalClass").on("mouseout", function () {
        $(this).parent().css("background", "#FFF");
    });
    $(".CancelDialogButton").on("click", function () {
        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
    });

</script>
<script src="../Scripts/common.js"></script>
<script>

    $(function () {



        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
           <%if (type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
    { %>
        if ($("#isProject_issue").is(":checked")) {
            $("#issue_report_contact_id").prop("disabled", false);
            $("#ChooseRc").click(function () { ChooseReportBy(); });
        }
        else {
            $("#issue_report_contact_id").prop("disabled", true);
            $("#ChooseRc").removeAttr("click");
        }
        if ($("#TaskTypeFixedWork").is(":checked")) {
            $("#hours_per_resource").val("0.00");
            $("#hours_per_resource").prop("disabled", true);
            $("#estimated_hours").prop("disabled", false);
        }
        else if ($("#TaskTypeFixedDuration").is(":checked")) {
            $("#estimated_hours").val("0.00");
            $("#estimated_hours").prop("disabled", true);
            $("#hours_per_resource").prop("disabled", false);
        } else {

        }
        GetWorkTypeByDepId();
        <%} %>

        <%if (!isAdd)
    {
        if (!isPhase)
        {


        %>GetPreSelectByIds();
        GetResDep();
        GetContact();
        <%if (thisTask.cost_code_id != null)
    { %>
        $("#WorkType").val('<%=thisTask.cost_code_id %>');
        <%}
    }%>
        <%}%>
    })
    $("#CancelButton").click(function () {
        window.close();
    })

    $("#isProject_issue").click(function () {
        if ($(this).is(":checked")) {
            $("#issue_report_contact_id").prop("disabled", false);
            $("#ChooseRc").click(function () { ChooseReportBy(); });
        } else {
            $("#issue_report_contact_id").prop("disabled", true);
            $("#ChooseRc").removeAttr("onclick");
        }
    })
    $("#TaskTypeFixedWork").click(function () {
        if ($(this).is(":checked")) {
            var hours_per_resource = $("#hours_per_resource").val();
            if (hours_per_resource == "") {
                $("#hours_per_resource").val("0.00");
            }

            $("#hours_per_resource").prop("disabled", true);
            $("#estimated_hours").prop("disabled", false);
        }
    })
    $("#TaskTypeFixedDuration").click(function () {
        if ($(this).is(":checked")) {
            var estimated_hours = $("#estimated_hours").val();
            if (estimated_hours == "") {
                $("#estimated_hours").val("0.00");
            }

            $("#estimated_hours").prop("disabled", true);
            $("#hours_per_resource").prop("disabled", false);
        }
    })
    <%if (!isPhase)
    { %>

    $("#start_no_earlier_than_date").blur(function () {
        debugger;
        var thanDateVal = $("#start_no_earlier_than_date").val();
        var startDateVal = $("#estimated_beginTime").val();
        if (thanDateVal != "" && startDateVal != "") {

            var startDateArr = startDateVal.split(' ');
            startDateVal = startDateArr[0];

            if (compareTime(thanDateVal, startDateVal)) {
                LayerMsg("开始时间不早于 要早于开始时间");
                $(this).val("");
            }
        }
    })
    $("#estimated_beginTime").blur(function () {
        debugger;
        // isStar = "";
        var thanDateVal = $("#start_no_earlier_than_date").val();
        var startDateVal = $("#estimated_beginTime").val();
        if (thanDateVal != "" && startDateVal != "") {
            var startDateArr = startDateVal.split(' ');
            startDateVal = startDateArr[0];
            if (compareTime(thanDateVal, startDateVal)) {
                LayerMsg("不早于开始时间要早于开始时间");
                $(this).val("");
            }
        }
        if (startDateVal != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=CheckDate&project_id=<%=thisProject.id %>&date=" + startDateVal,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        LayerConfirm("开始时间在周末或者节假日内，是否继续", "是", "否", function () { }, function () { $("#estimated_beginTime").val(""); });
                    } else {
                        // $("#estimated_beginTime").val("");
                    }
                }
            })
        }
    })
    $("#estimated_end_date").blur(function () {

        var thisValue = $(this).val();
        if (thisValue != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=CheckDate&project_id=<%=thisProject.id %>&date=" + thisValue,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        LayerConfirm("结束时间在周末或者节假日内，是否继续", "是", "否", function () { }, function () { $(this).val(""); });
                    }
                    else {
                       //  $(this).val("");
                    }
                }
            })
        }

    })
    <%} %>

    $(".To2Input").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && (!isNaN(thisValue))) {
            $(this).val(toDecimal2(thisValue))
        } else {
            $(this).val("");
        }
        JiSuanTime();
    })


    $("#department_id").change(function () {
        GetWorkTypeByDepId(); // 过滤工作类型
        // 判断主负责人是否在该部门中  todo
        var res_id = $("#owner_resource_idHidden").val();
        var dId = $(this).val();
        if (res_id != "" && dId != "0" && dId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/DepartmentAjax.ashx?act=IsHasRes&department_id=" + dId + "&resource_id=" + res_id,
                async: false,
                // dataType: "json",
                success: function (data) {
                    debugger;
                    if (data == "True") {
                        $("#owner_resource_idHidden").val("");
                        $("#owner_resource_id").val("");
                    }
                }

            })
        }
        // 成员不用清除，查找带回需要添加部门过滤
    });
    $("#template_id").change(function () {
        GetInfoByTemp();
    });

    //  #save,#save_close,#save_view,#save_add,#save2
    $("#save").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_close").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_view").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_add").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#save2").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_close2").click(function () {
        var reason = $("#reason").val();
        if (reason == "") {
            LayerMsg("请填写完成说明");
            return false;
        }
        return true;
    })

    // 
    $("#SaveAndCloseDialogButton").click(function () {  // 前驱任务的选择
        var tempPreIds = $("#tempPreIds").val();   // 选择的前驱任务的Id赋值到界面
        $("#preIds").val(tempPreIds);
        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
        GetPreSelectByIds();
    })

    function GetPreSelectByIds() {
        var tempPreIds = $("#tempPreIds").val();   // 选择的前驱任务的Id赋值到界面
        $("#preIds").val(tempPreIds);
        var appHtml = "";
        if (tempPreIds != "") {
            var tempPreIdArr = tempPreIds.split(',');
            for (var i = 0; i < tempPreIdArr.length; i++) {
                appHtml += "<option data-val='" + tempPreIdArr[i] + "' value='" + tempPreIdArr[i] + "'>" + $("#" + tempPreIdArr[i] + "_temp").children().first().next().next().text() + "(" + $("#" + tempPreIdArr[i] + "_temp").children().first().next().next().next().next().next().children().first().val() + ")</option>";
            }
            $("#Predecessors").html(appHtml);
            $("#Predecessors option").dblclick(function () {
                RemoveChoosePreOption(this);  // 双击清除选择的前驱任务
            })

        } else {
            $("#Predecessors").html("");
        }
    }
    $("#CloseStatusReson").click(function () {
        $("#CompletionReasonDialog").hide();
        $("#BackgroundOverLay").hide();
    })
    // 双击删除选择的前驱任务，并更新相关id信息
    function RemoveChoosePreOption(val) {
        debugger;
        var thisId = $("#Predecessors").val();
        $(val).remove();

        var ids = "";
        $("#Predecessors option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#preIds").val(ids);
        RemoveThis(thisId);
    }

    function JiSuanTime() {
        var estimated_hours = $("#estimated_hours").val();       // 预估时间
        var hours_per_resource = $("#hours_per_resource").val(); // 每个员工小时

        if (estimated_hours == "" || (isNaN(estimated_hours))) {
            estimated_hours = 0;
        }
        if (hours_per_resource == "" || (isNaN(hours_per_resource))) {
            hours_per_resource = 0;
        }

        // 获取团队人数，计算预估时间相关,团队成员不算联系人
        var teamNum = 0;
        var leader = $("#owner_resource_idHidden").val();
        if (leader != "") {
            teamNum = Number(teamNum) + Number(1);
        }
        var otherPer = $("#resDepIdsHidden").val();
        if (otherPer != "") {
            otherPerArr = otherPer.split(',');
            teamNum = Number(teamNum) + Number(otherPerArr.length);
        }
        if (teamNum != 0) {
            // 根据固定时间 和固定工作进行计算相关字段  
            if ($("#TaskTypeFixedDuration").is(":checked")) {
                estimated_hours = hours_per_resource * teamNum;
                $("#estimated_hours").val(toDecimal2(estimated_hours));
                $("#hours_per_resource").val(toDecimal2(hours_per_resource));
            } else if ($("#TaskTypeFixedWork").is(":checked")) {
                hours_per_resource = Number(estimated_hours) / Number(teamNum);
                $("#estimated_hours").val(toDecimal2(estimated_hours));
                $("#hours_per_resource").val(toDecimal2(hours_per_resource));
            }

        }

    }

    function TranDate(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        m = m < 10 ? '0' + m : m;
        var d = date.getDate();
        d = d < 10 ? ('0' + d) : d;
        return y + '-' + m + '-' + d;
    };
    // 阶段的查找带回
    function ChoosePhase() {
        // PhaseName
        // PhaseNameHidden
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TASK_PHASE %>&field=PhaseName&callBack=CheckChoosePhase&con963=<%=thisProject.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKPHASE_CALLBACK %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 校验查找带回的阶段是不是自己
    function CheckChoosePhase() {
        var choosePhaseId = $("#PhaseNameHidden").val();
        if (choosePhaseId != "") {
        <%if (isAdd)
    {%>
            var thisTaskId = '<%=thisTask==null?"":thisTask.id.ToString() %>';
            if (choosePhaseId == thisTaskId) {
                LayerMsg("所选阶段不能是自己哟！");
                $("#PhaseName").val("");
                $("#PhaseNameHidden").val("");
            }
        <%}%>
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetTaskSubNum&task_id=" + choosePhaseId,
                success: function (data) {
                    if (data == "99") {
                        LayerMsg("所选阶段子任务过多，请选择其他阶段！");
                        $("#PhaseName").val("");
                        $("#PhaseNameHidden").val("");
                    }
                },
            });



        }


    }
    // 清除阶段的查找带回
    function CancelPhase() {
        $("#PhaseName").val("");
        $("#PhaseNameHidden").val("");
    }
    // 问题提出人查找带回 // 从客户的联系人中选择
    function ChooseReportBy() {
        // issue_report_contact_id
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=issue_report_contact_id&muilt=1&callBack=GetContact&con628=<%=thisProject.account_id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactCallBack %>', 'left=200,top=200,width=600,height=800', false);
    }

    // 前驱任务查找带回
    function ChoosePreTask() {
        $("#Nav2").show();
        $("#BackgroundOverLay").show();
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetTaskList&showType=showTime&project_id=<%=thisProject.id %>",
            success: function (data) {
                if (data != "") {
                    $("#choProTaskList").html(data);
                    $(".Interaction").each(function () {
                        $(this).click(function () {
                            debugger;
                            var thisValue = $(this).parent().data("val");
                            <% if (!isAdd && thisTask != null)
    { %>
                            if (thisValue == '<%=thisTask.id %>') {
                                return false;
                            }
                            <%}%>
                            if (thisValue != undefined && thisValue != null && thisValue != "") {
                                var tempPreIds = $("#tempPreIds").val();
                                if (tempPreIds != "") {  // 
                                    tempPreArr = tempPreIds.split(',');
                                    var isHas = "";
                                    for (var i = 0; i < tempPreArr.length; i++) {
                                        if (thisValue == tempPreArr[i]) {
                                            isHas = "1";
                                            return false;
                                        }
                                    }
                                    if (isHas == "") {
                                        tempPreIds += "," + thisValue;
                                    }
                                    else {
                                        return false;
                                    }
                                } else {
                                    tempPreIds += thisValue;
                                }
                                $("#tempPreIds").val(tempPreIds);
                                // ajax 获取task信息 ，将信息展示，序号Id 从页面获取
                                var thisNo = $(this).children().first().text();  // 获取task序号
                                $.ajax({
                                    type: "GET",
                                    async: false,
                                    url: "../Tools/ProjectAjax.ashx?act=GetSinTask&task_id=" + thisValue,
                                    dataType: 'json',
                                    success: function (data) {
                                        if (data != "") {
                                            debugger;
                                            var thidStarDate = new Date();
                                            thidStarDate.setTime(data.estimated_begin_time);
                                            var StartDate = TranDate(thidStarDate);
                                            var EndDateArr = data.estimated_end_date.split("T");
                                            var endDa = EndDateArr[0];
                                            var appHtml = "<tr id='" + data.id + "_temp'><td class='PredecessorItemsSelectDialog_OutlineId PredecessorItemsSelectDialog_Text'>" + thisNo + "</td><td class='PredecessorItemsSelectDialog_Context' style='width: 30px;'><a class='PredecessorItemsSelectDialog_Delete PredecessorItemsSelectDialog_Button' onclick='RemoveThis(" + data.id + ")'><div class='PredecessorItemsSelectDialog_Icon'><span class='Icon' style='background: url(../Images/ButtonBarIcons.png) no-repeat -66px -2px;'>&nbsp;&nbsp;&nbsp;&nbsp;</span></div></a></td><td class='PredecessorItemsSelectDialog_Title PredecessorItemsSelectDialog_Text'>" + data.title + "</td><td class='PredecessorItemsSelectDialog_Date'>" + StartDate + "</td><td class='PredecessorItemsSelectDialog_Date'>" + endDa + "</td><td class='PredecessorItemsSelectDialog_Text'><input class='LagInput' placeholder='Lag (days)' type='text' id='" + data.id + "_lagDays' name='" + data.id + "_lagDays' value='0'></td><td class='PredecessorItemsSelectDialog_SizingSpacer' width='0'></td></tr>";

                                            //document.getElementById("PredecessorItemsSelectedTable").innerHTML += appHtml;
                                            $("#PredecessorItemsSelectedTable").append(appHtml);
                                            //  var thisHtml = $("#PredecessorItemsSelectedTable").html();
                                            //  $("#PredecessorItemsSelectedTable").html(thisHtml + appHtml);
                                        }
                                    },
                                });
                                // 

                            }
                        })
                    })
                } else {
                    $("#NoPreTask").show();
                }
            },
        });
        <%if (!isAdd && thisTask != null)
    { %>
        $("#" + "<%=thisTask.id %>").css("color", "grey");
        <%}%>


    }
    function RemoveThis(val) {
      



        $("#" + val + "_temp").remove();
        var tempPreIds = $("#tempPreIds").val();
        if (tempPreIds != "") {  // 
            tempPreArr = tempPreIds.split(',');
            var ids = "";
            for (var i = 0; i < tempPreArr.length; i++) {
                if (val != tempPreArr[i]) {
                    ids += tempPreArr[i] + ",";
                }
            }
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
            }
            $("#tempPreIds").val(ids);
        }
    }
    // 通过部门ID去过滤工作类型
    function GetWorkTypeByDepId() {
        // department_id
        var department_id = $("#department_id").val();
        if (department_id != undefined && department_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/DepartmentAjax.ashx?act=GetWorkType&department_id=" + department_id,
                success: function (data) {
                    if (data != "") {
                        $("#WorkType").html(data);
                    }
                },
            });
        }
        else {
            $("#WorkType").html("<option value='0'> <option>");
        }

    }
    // 查找带回主负责人  // 可能会根据部门和员工进行过滤
    function ChoosePriRes() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&field=owner_resource_id";
        var department_id = $("#department_id").val();
        if (department_id != undefined && department_id != "" && department_id !== "0") {  // 根据部门过滤
            url += "&con961=" + department_id;
        }
        if ($("#FilterResByProBilRoles").is(":checked")) {                                   // 根据项目过滤
            url += "&con962=<%=thisProject.id %>";
        }

        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function ChooseResDep() {
        var url = "../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RES_ROLE_DEP_CALLBACK %>&muilt=1&callBack=GetResDep&field=resDepIds";
        var department_id = $("#department_id").val();
        if (department_id != undefined && department_id != "" && department_id !== "0") {  // 根据部门过滤
            url += "&con961=" + department_id;
        }
        if ($("#FilterResByProBilRoles").is(":checked")) {                                   // 根据项目过滤
            url += "&con962=<%=thisProject.id %>";
        }
        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function GetResDep() {
        debugger;
        var resDepIds = $("#resDepIdsHidden").val();
        if (resDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=GetResDepList&resDepIds=" + resDepIds,
                async: false,
                //dataType:"json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $("#resDepList").html(data);
                        $("#resDepList option").dblclick(function () {
                            RemoveResDep(this);
                        })
                    }
                }

            })
        }
    }
    // 双击移除
    function RemoveResDep(val) {
        $(val).remove();
        var ids = "";
        $("#resDepList option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#resDepIdsHidden").val(ids);
    }

    function ChooseContact() {

        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTACT_CALLBACK %>&field=contactID&muilt=1&callBack=GetContact&con628=<%=thisProject.account_id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactCallBack %>', 'left=200,top=200,width=600,height=800', false);


    }
    function GetContact() {
        debugger;
        var contactIDHidden = $("#contactIDHidden").val();
        if (contactIDHidden != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetConList&ids=" + contactIDHidden,
                success: function (data) {
                    if (data != "") {
                        $("#conIds").html(data);
                        $("#conIds option").dblclick(function () {
                            RemoveCon(this);
                        })

                    } else {
                        $("#conIds").html("");
                    }
                },
            });
        }
    }

    function RemoveCon(val) {
        $(val).remove();
        var ids = "";
        $("#conIds option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#contactIDHidden").val(ids);
    }


    function GetInfoByTemp() {
        var template_id = $("#template_id").val();
        if (template_id != undefined && template_id != "" && template_id != "0") {

        }
    }
    var ToMeSum = 0;
    function ToMe() {
        debugger;
        var userEmail = GetMeEmail();
        if (userEmail != "") {

            if (ToMeSum == 0) {
                ToMeSum += 1;
                $("#NoToMe").val("1");
                var To_Email = $("#To_Email").html();
                if (To_Email != "") {
                    $("#To_Email").html(To_Email + ';' + userEmail);
                } else {
                    $("#To_Email").html(userEmail);
                }
            }
        }
    }
    function GetMeEmail() {
        <% var user = EMT.DoneNOW.BLL.UserInfoBLL.GetUserInfo(GetLoginUserId()); %>
        var userEmail = "";
        <% if (user != null)
    {%>
        userEmail = '<%=user.name %>';
        <%}%>
        return userEmail;
    }
    function GetLeadEmail() {
        var owner_resource_id = $("#owner_resource_idHidden").val();
        var leadEma = "";
        if (owner_resource_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetInfoByDepId&DepId=" + owner_resource_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        leadEma = data.name;
                    }
                }
            })
        }
        return leadEma;
    }

    var ToTeamMemberSum = 0;
    function ToTeamMember() {
        debugger;
        var memIDs = $("#resDepIdsHidden").val();
        if (memIDs != undefined && memIDs != "") {
            var menEmails = "";
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResouList&ids=" + memIDs,
                async: false,
                //dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        menEmails = data;
                    }
                }
            })
            debugger;
            if (menEmails != "") {

                menEmails = menEmails.substring(0, menEmails.length - 1);
                var To_Email = $("#To_Email").html();
                if (To_Email != "") {

                    if (ToMeSum != 0) {
                        menEmails += ";" + GetMeEmail();
                    }
                    if (ToProjectLeadSum != 0) {
                        menEmails += ";" + GetLeadEmail();
                    }
                    $("#To_Email").html(menEmails);
                } else {
                    $("#To_Email").html(menEmails);
                }
            }

            // todo 联系人姓名
        }
        debugger;
        var conIds = $("#contactIDHidden").val();
        if (conIds != "") {

            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=GetConName&ids=" + conIds,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        var To_Email = $("#To_Email").html();
                        if (To_Email != "") {
                            $("#To_Email").html(To_Email + data);
                        } else {
                            data = data.substring(1, data.length);
                            $("#To_Email").html(data);
                        }
                        $("#NoToContactIds").val(conIds);
                    }
                }
            })
        }

        // alert(conText);
    }
    var ToProjectLeadSum = 0;
    function ToProjectLead() {
        var owner_resource_id = $("#owner_resource_id").val();
        if (owner_resource_id != "") {
            var resouEmail = "";
            resouEmail = GetLeadEmail();
            if (resouEmail != "") {
                if (ToProjectLeadSum == 0) {
                    ToProjectLeadSum += 1;
                    var NoToProlead = $("#NoToProlead").val();
                    var To_Email = $("#To_Email").html();
                    if (NoToProlead != "") {
                        var isadd = "";
                        var NoToProleadArr = NoToProlead.split(',');
                        for (i = 0; i < NoToProleadArr.length; i++) {
                            if (NoToProleadArr[i] == owner_resource_id) {
                                isadd = "1";
                                break;
                            }
                        }
                        if (isadd == "") {
                            $("#NoToProlead").val(NoToProlead + ',' + owner_resource_id);
                            if (To_Email != "") {
                                $("#To_Email").html(To_Email + ';' + resouEmail);
                            } else {
                                $("#To_Email").html(resouEmail);
                            }
                        }
                    } else {
                        $("#NoToProlead").val(owner_resource_id);
                        if (To_Email != "") {
                            $("#To_Email").html(To_Email + ';' + resouEmail);

                        } else {
                            $("#To_Email").html(resouEmail);
                        }
                    }
                }
            }
        }
    }

    var CcMeSum = 0;
    function CcToMe() {
        var userEmail = GetMeEmail();
        if (userEmail != "") {
            if (CcMeSum == 0) {
                CcMeSum += 1;
                $("#NoCcMe").val("1");
                var Cc_Email = $("#Cc_Email").html();
                if (Cc_Email != "") {
                    $("#Cc_Email").html(Cc_Email + ';' + userEmail);
                } else {
                    $("#Cc_Email").html(userEmail);
                }
            }
        }
    }
    function OpenSelectPage(val) {
        // var account_id = $("#account_idHidden").val();
        var url = "RecipientSelector?account_id=<%=thisProject.account_id %>&thisType=" + val;

        var NoContactIds = $("#No" + val + "ContactIds").val();
        if (NoContactIds != "") {
            url += "&conIds" + NoContactIds;
        }
        var NoResIds = $("#No" + val + "ResIds").val();
        if (NoResIds != "") {
            url += "&resouIds" + NoResIds;
        }
        var NoDepIds = $("#No" + val + "DepIds").val();
        if (NoDepIds != "") {
            url += "&depIds" + NoDepIds;
        }
        var NoWorkIds = $("#No" + val + "WorkIds").val();
        if (NoWorkIds != "") {
            url += "&workIds" + NoWorkIds;
        }
        var NoOtherMail = $("#No" + val + "OtherMail").val();
        if (NoOtherMail != "") {
            url += "&otherEmail" + NoOtherMail;
        }


        window.open(url, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_RECIPIENTSELECTOR %>', 'left=200,top=200,width=750,height=800', false);
    }

    function GetDataBySelectPage(val) {
        debugger;
        var thisEmailText = "";
        var NoContactIds = $("#No" + val + "ContactIds").val();
        var NoResIds = $("#No" + val + "ResIds").val();
        var NoDepIds = $("#No" + val + "DepIds").val();
        var NoWorkIds = $("#No" + val + "WorkIds").val();
        var NoOtherMail = $("#No" + val + "OtherMail").val();

        if (NoContactIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=GetConName&ids=" + NoContactIds,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoResIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResouList&isReSouIds=1&ids=" + NoResIds,
                async: false,
                //dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoDepIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/DepartmentAjax.ashx?act=GetNameByIds&ids=" + NoDepIds,
                async: false,
                //dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoWorkIds != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetWorkName&ids=" + NoWorkIds,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        thisEmailText += data;
                    }
                }
            })
        }
        if (NoOtherMail != "") {
            thisEmailText = NoOtherMail;
        }
        if (val == "To") {
            if (ToMeSum != 0) {
                thisEmailText += GetMeEmail();
            }
            $("To_Email").html(thisEmailText);
        } else if (val == "Cc") {


            $("Cc_Email").html(thisEmailText);
        } else if (val == "Bcc") {
            $("Bcc_Email").html(thisEmailText);
        }
    }
    var isStar = "";
    var isEnd = "";
    var isShowAlert = "";  // 修改预估时间
    function SubmitCheck() {
        debugger;
        var title = $("#title").val();
        if (title == "") {
            LayerMsg("请填写任务标题！");
            return false;
        }
        var estimated_beginTime = $("#estimated_beginTime").val();
        if (estimated_beginTime == "") {
            LayerMsg("请填写开始时间");
            return false;
        }
        var estimated_end_date = $("#estimated_end_date").val();
        if (estimated_end_date == "") {
            LayerMsg("请填写结束时间");
            return false;
        }
        debugger;

        // 校验开始结束时间是否在节假日内或者周末内
        //if (isStar == "") {

        //}

        //if (isStar != "1") {
        //    return false;
        //}

        //if (isEnd == "") {

        //}

        //if (isEnd != "1") {
        //    return false;
        //}
        <%if (!isAdd && type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
    { %>
        var estimated_hours = $("#estimated_hours").val();
        var oldTime = $("#olfEsTime").val();
        var thisStatus = $("#status_id").val();
        var shengyuTime = $("#shengyuTime").val();
        <%if (thisTask != null && thisTask.projected_variance != 0)
    { %>
        if (status_id != '<%=EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE %>' && estimated_hours != oldTime && shengyuTime != "" && Number(shengyuTime) > 0) {
            LayerConfirm("您正在修改预估时间，任务剩余时间为" + shengyuTime + "小时，将其保留，还是置为0", "保留", "置为0", function () { isShowAlert = "1"; if (SubmitCheck()) { return true; } else { return false; } }, function () { isShowAlert = "1"; $("#IsEditEsTime").val("0"); if (SubmitCheck()) { return true; } else { return false; } });
            if (isShowAlert != "1") {
                return false;
            }
        }

        <%}%>
        <%}%>
            // status_id
       <%if (type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
    { %>
        var status_id = $("#status_id").val();
        if (status_id == "" || status_id == "0" || status_id == undefined) {
            LayerMsg("请选择状态！");
            return false;
        }
        var DisplayInCapYes = $("#DisplayInCapYes").is(":checked");
        var DisplayInCapYesNoComplete = $("#DisplayInCapYesNoComplete").is(":checked");
        var DisplayInCapNone = $("#DisplayInCapNone").is(":checked");
        if ((!DisplayInCapYes) && (!DisplayInCapYesNoComplete) && (!DisplayInCapNone)) {
            LayerMsg("请选择显示在客户端！");
            return false;
        }
        // template_id
        var TaskTypeFixedWork = $("#TaskTypeFixedWork").is(":checked");
        var TaskTypeFixedDuration = $("#TaskTypeFixedDuration").is(":checked");

        if ((!TaskTypeFixedWork) && (!TaskTypeFixedDuration)) {
            LayerMsg("请选择任务类型！");
            return false;
        }
        var template_id = $("#template_id").val();
        if (template_id == undefined || template_id == "" || template_id == "0") {
            LayerMsg("请选择通知模板！");
            return false;
        }
        //  选择团队，工作类型必填
        var WorkType = $("#WorkType").val();
        if (WorkType == "" || WorkType == "0") {
            var owner_resource_idHidden = $("#owner_resource_idHidden").val();
            var resDepIdsHidden = $("#resDepIdsHidden").val();
            if (owner_resource_idHidden != "" || resDepIdsHidden != "") {
                LayerMsg("请选择工作类型！");
                return false;
            }
        }


        if (compareTime(estimated_beginTime, estimated_end_date)) {
            LayerMsg("结束时间不能早于开始时间");
            return false;
        }
        if (CheckTeamRes()) {
            LayerMsg("同一员工不可在团队中分配多次");
            return false;
        }
        if (CheckPriResInTeam()) {
            LayerMsg("主负责人不能分配多次");
            return false;
        }
        var resource_id = $("#owner_resource_idHidden").val();
        var resDepIdsHidden = $("#resDepIdsHidden").val();
        if (resource_id != "" || resDepIdsHidden != "") {
            var department_id = $("#department_id").val();
            if (department_id == "" || department_id == "0") {
                   <%var thisDepSet = new EMT.DoneNOW.BLL.SysSettingBLL().GetSetById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_DEPARTMENT_REQUIRE);
    if (thisDepSet != null && thisDepSet.setting_value == "1")
    {%>
                LayerMsg("为任务分配员工时，部门为必填项");
                return false;
                    <%}%>
            }
        }
        if (resource_id != "") {
             <%var thisResWorkHourSet = new EMT.DoneNOW.BLL.SysSettingBLL().GetSetById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_DEPARTMENT_REQUIRE);
    if (thisResWorkHourSet != null && thisResWorkHourSet.setting_value == "1")
    { %>
            //  获取员工剩余时间进行比较
            var estimated_duration = $("#estimated_duration").val();
            if (estimated_duration == undefined || estimated_duration == null) {
                estimated_duration = "";
            }
            var hours_per_resource = $("#hours_per_resource").val();
            if (hours_per_resource == "" || hours_per_resource == undefined || hours_per_resource == null) {
                $("#hours_per_resource").val("0.00");
                hours_per_resource = "0.00";
            }
            if ($("#IsCheckResHOurs").val() != "1") {

                $.ajax({
                    type: "GET",
                    url: "../Tools/ResourceAjax.ashx?act=CheckResAvailability&project_id=<%=thisProject.id %>&res_id=" + resource_id + "&startTime=" + estimated_beginTime + "&endTime=" + estimated_end_date + "&days=" + estimated_duration + "&thisTaskRpeHour=" + hours_per_resource,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        debugger;
                        if (data != "") {
                            if (data.result == "False") {
                                LayerConfirm("主负责人剩余工作时间为" + data.reason + "小时，没有足够的可用时间，是否继续", "是", "否", function () {
                                    $("#IsCheckResHOurs").val("1");

                                    SubmitCheck();
                                }, function () {
                                    $("#IsCheckResHOurs").val("");

                                });
                                return false;
                            }
                        }

                    }
                })

            }
            <%}%>
        }

        <%if (!(thisTask != null && thisTask.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE))
    {%>
        if (status_id == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE %>') {
            // 系统设置
            <%var thisSet = new EMT.DoneNOW.BLL.SysSettingBLL().GetSetById(EMT.DoneNOW.DTO.SysSettingEnum.PRO_TASK_DONE_REASON);
    if (thisSet != null && thisSet.setting_value == "1")
    {%>
                $("#CompletionReasonDialog").show();
                $("#BackgroundOverLay").show();
    <%}
    %>
            return false;
            }
        <%}%>

    
                <%}%>


        return true;
    }
    // 校验主负责人是否在团队中出现
    function CheckPriResInTeam() {
        // resDepIdsHidden
        // owner_resource_idHidden
        var resource_id = $("#owner_resource_idHidden").val();
        var resDepIdsHidden = $("#resDepIdsHidden").val();
        if (resDepIdsHidden == "" || resource_id == "") {
            return false;
        }
        else {
            var isHas = "";
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=CheckPriResInTeam&resDepIds=" + resDepIdsHidden + "&resource_id=" + resource_id,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        if (data == "True") {
                            isHas = "1";
                        }

                    }

                }
            })
            if (isHas == "") {
                return false;
            } else {
                return true;
            }
        }
    }
    // 校验团队成员中是有重复员工
    function CheckTeamRes() {
        var resDepIdsHidden = $("#resDepIdsHidden").val();
        if (resDepIdsHidden == "") {
            return false;
        }
        else {
            var isHas = "";
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=CheckTeamRes&resDepIds=" + resDepIdsHidden,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        if (data == "True") {
                            isHas = "1";
                        }

                    }

                }
            })
            if (isHas == "") {
                return false;
            } else {
                return true;
            }
        }
    }

</script>
<%--ss --%>
<script>

    $(".IsShowDivLi").click(function () {
        debugger;
        var thisId = $(this).attr("id");
        $(".IsShowDivLi").removeClass("boders");
        $(this).addClass("boders");
        $(".IsShowDiv").hide();
        $("#" + thisId + "Div").show();
    })
    $(".CheckMile").click(function () {
        CanAss();
        CanDisAss();
        CanBillReady();
    })
    // 是否满足关联的条件（选择的checkbox均未关联）
    function CanAss() {

        var isHas = "";
        $(".CheckMile").each(function () {
            if ($(this).is(":checked")) {
                if ($(this).hasClass("taskMile")) {
                    isHas = "";
                    return false;
                } else {
                    isHas += $(this).val() + ',';
                }
            }
        })
        if (isHas == "") {
            // 禁用关联按钮     color: rgba(95,95,95,0.4);
            // AssociateListButton
            $("#AssociateListButton").removeAttr("onclick");
            $("#AssociateListButton").css("color", "rgba(95,95,95,0.4)");
        } else {
            // 恢复关联按钮
            $("#AssociateListButton").unbind('click').click(function () {
                AssMile();
            });
            $("#AssociateListButton").css("color", "black");
        }
    }
    // 是否满足解除关联的条件  conMile
    function CanDisAss() {
        var isHas = "";
        $(".CheckMile").each(function () {
            if ($(this).is(":checked")) {
                if ($(this).hasClass("conMile")) {
                    isHas = "";
                    return false;
                } else {
                    isHas += $(this).val() + ',';
                }
            }
        })
        if (isHas == "") {
            $("#DisassociateListButton").removeAttr("onclick");
            $("#DisassociateListButton").css("color", "rgba(95,95,95,0.4)");
        } else {
            // 恢复关联按钮
            $("#DisassociateListButton").unbind('click').click(function () {
                DisAssMile();
            });
            $("#DisassociateListButton").css("color", "black");
        }
        // DisassociateListButton
    }
    // 是否满足标记为准备计费
    function CanBillReady() {
        debugger;
        var isHas = "";
        $(".CheckMile").each(function () {
            if ($(this).is(":checked")) {
                if (($(this).hasClass("<%=(int)EMT.DoneNOW.DTO.DicEnum.MILESTONE_STATUS.BILLED %>") || $(this).hasClass("<%=(int)EMT.DoneNOW.DTO.DicEnum.MILESTONE_STATUS.READY_TO_BILL %>"))) {
                    isHas = "";
                    return false;
                } else {
                    isHas += $(this).val() + ',';
                }
            }
        })
        if (isHas == "") {
            $("#ReadyForBillingListButton").removeAttr("onclick");
            $("#ReadyForBillingListButton").css("color", "rgba(95,95,95,0.4)");
        } else {
            // 恢复关联按钮
            $("#ReadyForBillingListButton").unbind('click').click(function () {
                BillMile();
            });
            $("#ReadyForBillingListButton").css("color", "black");
        }
    }
    // 关联事件
    function AssMile() {
        var ids = "";
        $(".CheckMile").each(function () {
            if ($(this).is(":checked")) {
                if ($(this).hasClass("taskMile")) {
                    ids = "";
                    return false;
                } else {
                    ids += $(this).val() + ',';
                }
            }
        })
        if (ids == "") {

        }
        else {
            ids = ids.substring(0, ids.length - 1);
            // 关联事件
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=AssMile&mileIds=" + ids +"&phaId=<%=thisTask!=null?thisTask.id.ToString():"" %>",
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        if (data == "True") {

                        }

                    }
                    history.go(0);
                }
            })
        }
    }

    function AssSingMile() {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=AssMile&mileIds=" + entityid +"&phaId=<%=thisTask!=null?thisTask.id.ToString():"" %>",
            async: false,
            success: function (data) {
                debugger;
                if (data != "") {
                    if (data == "True") {

                    }

                }
                history.go(0);
            }
        })
    }
    function DisAssSingMile() {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=DisAssMile&mileIds=" + entityid,
            async: false,
            success: function (data) {
                debugger;
                if (data != "") {
                    if (data == "True") {

                    }

                }
                history.go(0);
            }
        })
    }
    // 取消关联事件
    function DisAssMile() {
        var ids = "";
        $(".CheckMile").each(function () {
            if ($(this).is(":checked")) {
                if ($(this).hasClass("conMile")) {
                    ids = "";
                    return false;
                } else {
                    ids += $(this).val() + ',';
                }
            }
        })
        if (ids == "") {

        }
        else {
            ids = ids.substring(0, ids.length - 1);
            // 关联事件
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=DisAssMile&mileIds=" + ids,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        if (data == "True") {

                        }

                    }
                    history.go(0);
                }
            })
        }
    }
    // 标记为准备计费
    function BillMile() {
        var ids = "";
        $(".CheckMile").each(function () {
            if ($(this).is(":checked")) {
                if (($(this).hasClass("<%=(int)EMT.DoneNOW.DTO.DicEnum.MILESTONE_STATUS.BILLED %>") || $(this).hasClass("<%=(int)EMT.DoneNOW.DTO.DicEnum.MILESTONE_STATUS.READY_TO_BILL %>"))) {
                    ids = "";
                    return false;
                } else {
                    ids += $(this).val() + ',';
                }
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=ToReadyBill&mileIds=" + ids,
                async: false,
                success: function (data) {
                    debugger;
                    if (data != "") {
                        if (data == "True") {

                        }

                    }
                    history.go(0);
                }
            })
        }
    }
    // 取消任务
    function CancelTask() {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=CancelTask&task_id=<%=thisTask==null?"":thisTask.id.ToString() %>",
            async: false,
            success: function (data) {
                debugger;
                if (data != "") {
                    if (data == "True") {

                    }

                }
                history.go(0);
            }
        })
    }
    // 恢复任务
    function RecoveTask() {
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=RecoveTask&task_id=<%=thisTask==null?"":thisTask.id.ToString() %>",
            async: false,
            success: function (data) {
                debugger;
                if (data != "") {
                    if (data == "True") {

                    }

                }
                history.go(0);
            }
        })
    }

    function EditNote() {
        window.open("../Project/TaskNote.aspx?id=" + entityid, windowObj.notes + windowType.edit, 'left=200,top=200,width=1080,height=800', false);
    }
    function DeleteNote() {
        LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=DeleteNote&note_id=" + entityid,
                async: false,
                //dataType: json,
                success: function (data) {

                    if (data == "True") {
                        LayerMsg("删除成功");
                    } else {
                        LayerMsg("删除失败");
                    }

                    history.go(0);
                }
            })
        }, function () { });
    }

    function AddNote() {
        <%if (thisTask != null)
    { %>
        window.open("../Project/TaskNote.aspx?task_id=<%=thisTask.id %>", windowObj.notes + windowType.add, 'left=200,top=200,width=960,height=800', false);
        <%}%>
    }
</script>
<%--菜单事件 --%>
<script>
    // MileContextMenu
    var entityid = "";
    var Times = 0;
    $(".ContextMenu").bind("mouseover", function (event) {
        debugger;
        clearInterval(Times);
        //debugger;
        var oEvent = event;
        var menu = "";
        //var thisClassName = $(this).prop("className"); attachMenuS expTR
        if ($(this).hasClass("MileContextMenu")) {
            if ($(this).parent().prev().children().first().children().first().hasClass("conMile")) {
                menu = document.getElementById("AssMileMenu");
            } else {
                menu = document.getElementById("DisAssMileMenu");
            }

        }
        else if ($(this).hasClass("NoteContextMenu")) {
            menu = document.getElementById("NoteManageMenu");
        }
        // else if ($(this).hasClass("noteTR")) {  
        //    menu = document.getElementById("noteMenu");
        //} else if ($(this).hasClass("atachTR")) {
        //    menu = document.getElementById("attachMenu");
        //} else if ($(this).hasClass("expTR")) {
        //    menu = document.getElementById("expMenu");
        //}

        entityid = $(this).children().first().val(); // data("val");
        (function () {
            menu.style.display = "block";
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        }());
        menu.onmouseenter = function () {
            clearInterval(Times);
            menu.style.display = "block";
        };
        menu.onmouseleave = function () {
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        };
        var Left = $(document).scrollLeft() + oEvent.clientX;
        var Top = $(document).scrollTop() + oEvent.clientY;
        var winWidth = window.innerWidth;
        var winHeight = window.innerHeight;
        var menuWidth = menu.clientWidth;
        var menuHeight = menu.clientHeight;
        var scrLeft = $(document).scrollLeft();
        var scrTop = $(document).scrollTop();
        var clientWidth = Left + menuWidth;
        var clientHeight = Top + menuHeight;
        var rightWidth = winWidth - oEvent.clientX;
        var bottomHeight = winHeight - oEvent.clientY;
        if (winWidth < clientWidth && rightWidth < menuWidth) {
            menu.style.left = winWidth - menuWidth - 18 + 100 + scrLeft + "px";
        } else {
            menu.style.left = Left + "px";
        }
        if (winHeight < clientHeight && bottomHeight < menuHeight) {
            menu.style.top = winHeight - menuHeight - 18 + 100 + scrTop + "px";
        } else {
            menu.style.top = Top - 25 + "px";
        }
        document.onclick = function () {
            menu.style.display = "none";
        }
        return false;
    });
</script>
