<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskAddOrEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/NewConfigurationItem.css" rel="stylesheet" />
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <title></title>
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

                    <a class="NormalState Button ButtonIcon Cancel" id="CancelButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">关闭</span></a>
                </div>
            </div>
            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer" id="za7dce764d22b4572aaf851391e3b7f6f" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">

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
                                        <input id="title" type="text" value="<%=isAdd?"":thisTask.title %>" name="title" /><span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly ProjectTask" id="TaskLibraryButton" tabindex="0" title="Task Library" onclick=""><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -16px -79px;"></span><span class="Text"></span></a></span>
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="PhaseName">父阶段名称<span class="SecondaryText">(在此阶段内放置条目)</span></label>
                                    </div>
                                </div>
                                <div class="Editor TextBox" data-editor-id="PhaseName" data-rdp="PhaseName">
                                    <div class="InputField">
                                        <%
                                            EMT.DoneNOW.Core.sdk_task parPhase = null;
                                            if (thisTask != null && thisTask.parent_id != null)
                                            {
                                                parPhase = sdDal.FindNoDeleteById((long)thisTask.parent_id);
                                            }
                                        %>
                                        <input id="PhaseName" type="text" value="<%=parPhase==null?"":parPhase.title %>" name="PhaseName" disabled="disabled" />
                                        <input type="hidden" name="parent_id" id="PhaseNameHidden" value="<%=parPhase == null ? "" : parPhase.id.ToString() %>" />
                                        <span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PhaseSelectorButton" tabindex="0" title="选择阶段" onclick="ChoosePhase()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><a class="NormalState Button ButtonIcon IconOnly Delete" id="PhaseDeleteButton" tabindex="0" title="Clear the selected phase"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -64px 0px;"></span><span class="Text"></span></a>
                                            <input id="PhaseId" name="PhaseId" type="hidden" value="" /></span>
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
                                            <input id="priority" type="text" value="<%=isAdd?"":thisTask.priority.ToString() %>" name="priority" maxlength="5" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
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
                                            <input id="purchase_order_no" type="text" value="<%=isAdd?"":thisTask.purchase_order_no %>" name="purchase_order_no" maxlength="50" />
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
                                        <input id="IssueReportedBy_DisplayTextBox" type="text" value="" autocomplete="off" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="issue_report_contact_id" tabindex="0"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="issue_report_contact_idHidden" name="issue_report_contact_id" type="hidden" value="" /><div class="ContextOverlayContainer" id="IssueReportedBy_ContextOverlay">
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
                                        <select id="Predecessors" multiple="multiple" name="Predecessors"></select><span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PredecessorSelectButton" tabindex="0" onclick="ChoosePreTask()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

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
                                        <input id="estimated_hours" type="text" value="<%=isAdd?"0.00":thisTask.estimated_hours.ToString("#0.00") %>" name="estimated_hours" maxlength="10" class="To2Input" />
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Duration">持续时间</label>
                                    </div>
                                </div>
                                <div class="Editor IntegerBox" data-editor-id="Duration" data-rdp="Duration">
                                    <div class="InputField">
                                        <input id="estimated_duration" type="text" value="<%=isAdd?1:thisTask.estimated_duration %>" name="estimated_duration" maxlength="5" />
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="HoursPerResource">每个员工小时</label>
                                    </div>
                                </div>
                                <div class="Editor DecimalBox" data-editor-id="HoursPerResource" data-rdp="HoursPerResource">
                                    <div class="InputField">
                                        <input id="hours_per_resource" type="text" value="<%=isAdd?"0.00":thisTask.hours_per_resource.ToString("#0.00") %>" name="hours_per_resource" maxlength="12" class="To2Input" />
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
                                                <input id="estimated_beginTime" type="text" value="<%=isAdd?startDate.ToString("yyyy-MM-dd HH:mm:ss"):EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time).ToString("yyyy-MM-dd HH:mm:ss") %>" name="estimated_beginTime" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" style="width: 150px" />
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
                                                <input id="estimated_end_date" type="text" value="<%=isAdd?startDate.ToString("yyyy-MM-dd"):((DateTime)thisTask.estimated_end_date).ToString("yyyy-MM-dd") %>" name="estimated_end_date" onclick="WdatePicker()" style="width: 100px;" />
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
                                            <input id="start_no_earlier_than_date" type="text" value="<%=thisTask!=null&&thisTask.start_no_earlier_than_date!=null?((DateTime)thisTask.start_no_earlier_than_date).ToString("yyyy-MM-dd"):"" %>" name="start_no_earlier_than_date" onclick="WdatePicker()" />
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
                                <div class="Editor SingleSelect" data-editor-id="WorkType" data-rdp="WorkType">
                                    <div class="InputField">
                                        <select id="WorkType" name="WorkType">
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
                                            <input type="hidden" id="resDepIds" />
                                            <input type="hidden" id="resDepIdsHidden" name="resDepList" />
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
                                                <%
                                                    if (!isAdd)
                                                    {

                                                        var resList = new EMT.DoneNOW.DAL.sdk_task_resource_dal().GetResByTaskId(thisTask.id);
                                                        if (resList != null && resList.Count > 0)
                                                        {
                                                            var syDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                                            var srDal = new EMT.DoneNOW.DAL.sys_role_dal();
                                                            foreach (var res in resList)
                                                            {
                                                                if (res.resource_id != null && res.role_id != null)
                                                                {
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
                                                    }  %>
                                            </select>
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
                                        <input id="Contacts_DisplayTextBox" type="text" value="" autocomplete="off" style="width: 250px;" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="Contacts_Button" tabindex="0"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat;"></span><span class="Text"></span></a><input id="Contacts" name="Contacts" type="hidden" value="" /><div class="ContextOverlayContainer" id="Contacts_ContextOverlay">
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
                                            <input type="hidden" id="contactID" />
                                            <input type="hidden" id="contactIDHidden" name="conIds" />
                                            <select multiple="multiple" style="width: 264px; min-height: 80px;" id="conIds">
                                                <%
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
                                                                {%>
                                                <option><%=thisContact.name %></option>
                                                <%}
                                                            }
                                                        }
                                                    } %>
                                            </select>
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
                                    <span class="Value" id="To_Email"></span>
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
                                    <span class="Value" id="Cc_Email"></span>
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
                                    <span class="Value" id="Bcc_Email"></span>
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

                </div>
            </div>
        </div>

        <div class="Dialog Large" style="margin-left: -442px; margin-top: -340px; z-index: 100; height: 650px;" id="Nav2">
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
                                    <div class="Left"><span class="Text">Define Predecessors for Migrate Email Data</span><span class="SecondaryText"></span></div>
                                    <div class="Spacer"></div>
                                </div>
                                <div class="DescriptionText">To mark a schedule item as a predecessor, click on the ID column, and enter a Lag. You may specify one or more predecessors.</div>
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
                                                <div class="NoDataMessage">没有条目展示</div>
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
                                    <input type="hidden" name="tempPreIds" id="tempPreIds" />
                                    <input type="hidden" name="prereIds" id="preIds" />
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
        <div class="Dialog Large" style="margin-left: -442px; margin-top: -340px; z-index: 100; height: 650px; display: none;" id="CompletionReasonDialog">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" id="CloseStatusReson"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title"><span class="Text">Complete Task Reason</span><span class="SecondaryText"></span></div>
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
                            <a class="Button ButtonIcon Save NormalState" id="SaveAndCloseCompleteButton" tabindex="0"><span class="Icon"></span><span class="Text">
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


    </form>
</body>
</html>
<%--<script src="../Scripts/jquery-3.2.1.min.js"></script>--%>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
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
        if ($("#isProject_issue").is(":checked")) {
            $("#issue_report_contact_id").prop("disabled", false);
            $("#issue_report_contact_idHidden").click(function () { ChooseReportBy(); });
        }
        else {
            $("#issue_report_contact_id").prop("disabled", true);
            $("#issue_report_contact_idHidden").removeAttr("click");
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
    })
    $("#CancelButton").click(function () {
        window.close();
    })

    $("#isProject_issue").click(function () {
        if ($(this).is(":checked")) {
            $("#issue_report_contact_id").prop("disabled", false);
            $("#issue_report_contact_idHidden").click(function () { ChooseReportBy(); });
        } else {
            $("#issue_report_contact_id").prop("disabled", true);
            $("#issue_report_contact_idHidden").removeAttr("click");
        }
    })
    $("#TaskTypeFixedWork").click(function () {
        if ($(this).is(":checked")) {
            $("#hours_per_resource").val("0.00");
            $("#hours_per_resource").prop("disabled", true);
            $("#estimated_hours").prop("disabled", false);
        }
    })
    $("#TaskTypeFixedDuration").click(function () {
        if ($(this).is(":checked")) {
            $("#estimated_hours").val("0.00");
            $("#estimated_hours").prop("disabled", true);
            $("#hours_per_resource").prop("disabled", false);
        }
    })

    $("#start_no_earlier_than_date").blur(function () {
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
    })

    $(".To2Input").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && (!isNaN(thisValue))) {
            $(this).val(toDecimal2(thisValue))
        } else {
            $(this).val("");
        }
    })


    $("#department_id").change(function () {
        GetWorkTypeByDepId(); // 过滤工作类型
        // 判断主负责人是否在该部门中


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


    $("#SaveAndCloseDialogButton").click(function () {  // 前驱任务的选择
        var tempPreIds = $("#tempPreIds").val();   // 选择的前驱任务的Id赋值到界面
        $("#preIds").val(tempPreIds);
    })
    $("#CloseStatusReson").click(function () {
        $("#CompletionReasonDialog").hide();
        $("#BackgroundOverLay").hide();
    })
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
    }
    // 清除阶段的查找带回
    function CancelPhase() {
        $("#PhaseName").val("");
        $("#PhaseNameHidden").val("");
    }
    // 问题提出人查找带回 // 从客户的联系人中选择
    function ChooseReportBy() {
        // issue_report_contact_id
    }

    // 前驱任务的选择 -- todo
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
                            var test = $(this).parent().data("val");
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
                                            var appHtml = "<tr id='" + data.id + "_temp'><td class='PredecessorItemsSelectDialog_OutlineId PredecessorItemsSelectDialog_Text'>" + thisNo + "</td><td class='PredecessorItemsSelectDialog_Context' style='width: 30px;'><a class='PredecessorItemsSelectDialog_Delete PredecessorItemsSelectDialog_Button' onclick='RemoveThis(" + data.id + ")'><div class='PredecessorItemsSelectDialog_Icon'><span class='Icon' style='background: url(../Images/ButtonBarIcons.png) no-repeat -66px -2px;'>&nbsp;&nbsp;&nbsp;&nbsp;</span></div></a></td><td class='PredecessorItemsSelectDialog_Title PredecessorItemsSelectDialog_Text'>" + data.title + "</td><td class='PredecessorItemsSelectDialog_Date'>" + StartDate + "</td><td class='PredecessorItemsSelectDialog_Date'>" + endDa + "</td><td class='PredecessorItemsSelectDialog_Text'><input class='LagInput' placeholder='Lag (days)' type='text' id='" + data.id + "_lagDays' value='0'></td><td class='PredecessorItemsSelectDialog_SizingSpacer' width='0'></td></tr>";
                                            var thisHtml = $("#PredecessorItemsSelectedTable").html();
                                            $("#PredecessorItemsSelectedTable").html(thisHtml + appHtml);
                                        }
                                    },
                                });
                                // 

                            }
                        })
                    })
                }
            },
        });


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
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralAjax.ashx?act=GetNotiTempEmail&temp_id=" + template_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    debugger;
                    if (data != "") {
                        $("#From_Email").html(data.from_other_email);
                        $("#subject").val(data.subject);
                    }
                }

            })
        }
    }
    var ToMeSum = 0;
    function ToMe() {
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
            var owner_resource_id = $("#owner_resource_id").val();
            var leadEma = "";
            if (owner_resource_id != "") {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ResourceAjax.ashx?act=GetInfo&id=" + owner_resource_id,
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

    function SubmitCheck() {
        var title = $("#title").val();
        if (title == "") {
            LayerMsg("请填写任务标题！");
            return false;
        }
        // status_id
        var status_id = $("#status_id").val();
        if (status_id == "" || status_id == "0" || status_id == undefined) {
            LayerMsg("请选择状态！");
            return false;
        }
        var DisplayInCapYes = $("#DisplayInCapYes").is(":checked");
        var DisplayInCapYesNoComplete = $("#DisplayInCapYesNoComplete").is(":checked");
        var DisplayInCapNone = $("#DisplayInCapNone").is(":checked");
        if ((!DisplayInCapYes) && (!DisplayInCapYes) && (!DisplayInCapYes)) {
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

        if (status_id == '<%=EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE %>') {
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

        // todo 状态是完成则弹窗填写理由

        return true;
    }

</script>
