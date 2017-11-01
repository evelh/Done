<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskAddOrEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskAddOrEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <title></title>
    <style>
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
                    <div class="DropDownButtonContainer">
                        <div class="Left"><a class="NormalState Button ButtonIcon Save" id="SaveDropDownButton_LeftButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">保存</span></a></div>
                        <div class="Right"><a class="NormalState Button ButtonIcon IconOnly DropDownArrow" id="SaveDropDownButton_RightButton" tabindex="0"><span class="Icon" style="    background: url(../Images/ButtonBarIcons.png) no-repeat -176px -48px;width: 15px;"></span><span class="Text"></span></a></div>
                    </div>
                    <div class="ContextOverlayContainer" id="SaveDropDownButton_ContextOverlay">
                        <div class="DropDownButton ContextOverlay">
                            <div class="Content">
                                <div class="Normal ContextOverlayColumn" data-contains-icons="true">
                                    <div>
                                        <div class="Group">
                                            <div class="Content"><a class="NormalState Button ButtonIcon Save" id="SaveAndCloseButton" tabindex="0"><span class="Icon"></span><span class="Text">保存并关闭</span></a><a class="NormalState Button ButtonIcon SaveAndView" id="SaveAndGoToTaskDetailButton" tabindex="0"><span class="Icon"></span><span class="Text">保存并查看<%=type %>详情 </span></a><a class="NormalState Button ButtonIcon SaveAndNew" id="SaveAndNewButton" tabindex="0"><span class="Icon"></span><span class="Text">保存并新建</span></a><a class="NormalState Button ButtonIcon Save" id="SaveButton" tabindex="0"><span class="Icon"></span><span class="Text">保存</span></a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <a class="NormalState Button ButtonIcon Cancel" id="CancelButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">关闭</span></a>
                </div>
            </div>
            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer" id="za7dce764d22b4572aaf851391e3b7f6f" style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:85px;">

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
                                        <input id="title" type="text" value="<%=isAdd?"":thisTask.title %>" name="title"  /><span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly ProjectTask" id="TaskLibraryButton" tabindex="0" title="Task Library" onclick=""><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -16px -79px;"></span><span class="Text"></span></a></span>
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="PhaseName">父阶段名称<span class="SecondaryText">(在此阶段内放置条目)</span></label>
                                    </div>
                                </div>
                                <div class="Editor TextBox" data-editor-id="PhaseName" data-rdp="PhaseName">
                                    <div class="InputField"><%
                                                                EMT.DoneNOW.Core.sdk_task parPhase = null;
                                                                if (thisTask != null && thisTask.parent_id != null)
                                                                {
                                                                    parPhase = sdDal.FindNoDeleteById((long)thisTask.parent_id);
                                                                }
                                                                %>
                                        <input id="PhaseName" type="text" value="<%=parPhase==null?"":parPhase.title %>" name="PhaseName" disabled="disabled" />
                                        <input type="hidden" name="parent_id" id="PhaseNameHidden" value="<%=parPhase == null ? "" : parPhase.id.ToString() %>" />
                                        <span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PhaseSelectorButton" tabindex="0" title="选择阶段" onclick="ChoosePhase()"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat ;"></span><span class="Text"></span></a><a class="NormalState Button ButtonIcon IconOnly Delete" id="PhaseDeleteButton" tabindex="0" title="Clear the selected phase"><span class="Icon"  style="background: url(../Images/ButtonBarIcons.png) no-repeat -64px 0px;"></span><span class="Text"></span></a><input id="PhaseId" name="PhaseId" type="hidden" value="" /></span>
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
                                                        EMT.DoneNOW.Core.crm_account  proAccount = new EMT.DoneNOW.DAL.crm_account_dal().FindNoDeleteById(thisProject.account_id);
                                                       
                                                        %>
                                                    <span class="ProjectInfo_TextBold">客户:</span>
                                                </td>
                                                <td>
                                                    <div>
                                                        <a class="ProjectInfo_Button" onclick="window.open('../Company/ViewCompany.aspx?id=<%=proAccount.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>','left=200,top=200,width=900,height=750', false);"><%=proAccount.name %></a>
                                                    </div>
                                                    <% var defaultLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocationByAccountId(proAccount.id); 
                                                        
                                                        
                                                        
                                                        %>
                                                    <div class="ProjectInfo_Text"><%=country.First(_=>_.val.ToString()==defaultLocation.country_id.ToString()).show  %>
                   <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.province_id.ToString()).show  %>
                  <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.city_id.ToString()).show  %>
                    <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.district_id.ToString()).show  %></div>
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
                                            <input id="priority" type="text" value="<%=isAdd?"":thisTask.priority.ToString() %>" name="priority"  maxlength="5" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  />
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
                                                <asp:RadioButton ID="DisplayInCapNone" runat="server" GroupName="DisplayInCap"/>
                                             
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
                                        <input id="IssueReportedBy_DisplayTextBox" type="text" value="" autocomplete="off" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="issue_report_contact_id" tabindex="0"><span class="Icon" style="background: url(../Images/data-selector.png) no-repeat ;"></span><span class="Text"></span></a><input id="issue_report_contact_idHidden" name="issue_report_contact_id" type="hidden" value="" /><div class="ContextOverlayContainer" id="IssueReportedBy_ContextOverlay">
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
                                        <select id="Predecessors" multiple="multiple" name="Predecessors"></select><span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PredecessorSelectButton" tabindex="0" onclick="ChoosePreTask()"><span class="Icon"  style="background: url(../Images/data-selector.png) no-repeat ;"></span><span class="Text"></span></a></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="Normal Section">
                        <div class="Heading">
                            <div class="Left"><span class="Text">Schedule</span><span class="SecondaryText"></span></div>
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
                                                <asp:RadioButton ID="TaskTypeFixedDuration" runat="server" GroupName="TaskType"/>
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
                                <div class="Editor DecimalBox" >
                                    <div class="InputField">
                                        <input id="estimated_hours" type="text" value="<%=isAdd?"0.00":thisTask.estimated_hours.ToString("#0.00") %>" name="estimated_hours"  maxlength="10" class="To2Input" />
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
                                        <input id="hours_per_resource" type="text" value="<%=isAdd?"0.00":thisTask.hours_per_resource.ToString("#0.00") %>" name="hours_per_resource"  maxlength="12" class="To2Input"/>
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
                                                <input id="estimated_begin_time" type="text" value="<%=isAdd?startDate.ToString("yyyy-MM-dd HH:mm:ss"):EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time).ToString("yyyy-MM-dd HH:mm:ss") %>" name="estimated_begin_time"  onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" style="width:150px" />
                                            </div>   
                                        </div>
                                    </div>
                                </div>
                         
                                <div class="Small Column" style="margin-left:50px;">
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="EndDate">结束时间</label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor DateBox" data-editor-id="EndDate" data-rdp="EndDate">
                                        <div class="InputField">
                                            <div class="Container">
                                                <input id="estimated_end_date" type="text" value="<%=isAdd?startDate.ToString("yyyy-MM-dd"):((DateTime)thisTask.estimated_end_date).ToString("yyyy-MM-dd") %>" name="estimated_end_date" onclick="WdatePicker()" style="width:100px;"/>
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
                                            <input id="start_no_earlier_than_date" type="text" value="<%=thisTask!=null&&thisTask.start_no_earlier_than_date!=null?((DateTime)thisTask.start_no_earlier_than_date).ToString("yyyy-MM-dd"):"" %>" name="start_no_earlier_than_date" onclick="WdatePicker()"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="Normal Section" id="AssignSectionHeader">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse">
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
                                            <input id="FilterResourcesByProjectBillingRoles" type="checkbox" value="true" name="FilterResourcesByProjectBillingRoles" />
                                        </div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="FilterResourcesByProjectBillingRoles">Filter resources by project billing roles</label>
                                            </div>
                                        </div>
                                        <input id="FilterResourcesByProjectBillingRoles_HiddenField" name="FilterResourcesByProjectBillingRoles" type="hidden" value="false" />
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="WorkType">Work Type<span class="SecondaryText">(Required when assigning a resource)</span></label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect" data-editor-id="WorkType" data-rdp="WorkType">
                                    <div class="InputField">
                                        <select id="WorkType" name="WorkType">
                                            <option value="" title=""></option>
                                            <option value="" title="----------------">----------------</option>
                                            <option value="29682802" title="Emergency/After Hours Support">Emergency/After Hours Support</option>
                                            <option value="29682808" title="General Administration">General Administration</option>
                                            <option value="29682804" title="Maintenance">Maintenance</option>
                                            <option value="29682861" title="Non Billable Support (non-billable)">Non Billable Support (non-billable)</option>
                                            <option value="29682800" title="Onsite Support">Onsite Support</option>
                                            <option value="29682801" title="Remote Support">Remote Support</option>
                                            <option value="29682860" title="Sales (non-billable)">Sales (non-billable)</option>
                                            <option value="29683328" title="Travel">Travel</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="PrimaryResource">Primary Resource</label>
                                    </div>
                                </div>
                                <div class="Editor DataSelector" data-editor-id="PrimaryResource" data-rdp="PrimaryResource">
                                    <div class="InputField">
                                        <input id="PrimaryResource_DisplayTextBox" type="text" value="" autocomplete="off" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="PrimaryResource_Button" tabindex="0"><span class="Icon"></span><span class="Text"></span></a><input id="PrimaryResource" name="PrimaryResource" type="hidden" value="" /><div class="ContextOverlayContainer" id="PrimaryResource_ContextOverlay">
                                            <div class="AutoComplete ContextOverlay">
                                                <div class="Active LoadingIndicator"></div>
                                                <div class="Content"></div>
                                            </div>
                                            <div class="AutoComplete ContextOverlay">
                                                <div class="Active LoadingIndicator"></div>
                                                <div class="Content"></div>
                                            </div>
                                        </div>
                                        <span class="CustomHtml"><a class="NormalState Button ButtonIcon IconOnly Search" id="FindResourceButton" tabindex="0" title="Find Resource"><span class="Icon"></span><span class="Text"></span></a><a class="NormalState Button ButtonIcon IconOnly MoveDown" id="DownArrow" tabindex="0" title="Make primary resource a secondary resource"><span class="Icon"></span><span class="Text"></span></a></span>
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="SecondaryResources">Secondary Resources</label>
                                    </div>
                                </div>
                                <div class="Editor DataSelector" data-editor-id="SecondaryResources" data-rdp="SecondaryResources">
                                    <div class="InputField">
                                        <input id="SecondaryResources_DisplayTextBox" type="text" value="" autocomplete="off" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="SecondaryResources_Button" tabindex="0"><span class="Icon"></span><span class="Text"></span></a><input id="SecondaryResources" name="SecondaryResources" type="hidden" value="" /><div class="ContextOverlayContainer" id="SecondaryResources_ContextOverlay">
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
                                            <select id="SecondaryResources_displayListBox" multiple="multiple"></select>
                                        </div>
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Contacts">Contacts</label>
                                    </div>
                                </div>
                                <div class="Editor DataSelector" data-editor-id="Contacts" data-rdp="Contacts">
                                    <div class="InputField">
                                        <input id="Contacts_DisplayTextBox" type="text" value="" autocomplete="off" /><a class="NormalState Button ButtonIcon IconOnly DataSelector" id="Contacts_Button" tabindex="0"><span class="Icon"></span><span class="Text"></span></a><input id="Contacts" name="Contacts" type="hidden" value="" /><div class="ContextOverlayContainer" id="Contacts_ContextOverlay">
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
                                            <select id="Contacts_displayListBox" multiple="multiple"></select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="Normal Section" id="UdfSectionHeader">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">User-Defined Fields</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="Udf EditorLabelContainer">
                                    <div class="Label">
                                        <label for="UserDefinedFields_0_">task_col1</label><span class="Required">*</span>
                                    </div>
                                </div>
                                <div class="Editor TextBox Udf" data-editor-id="UserDefinedFields_0_" data-rdp="UserDefinedFields_0_">
                                    <div class="InputField">
                                        <input id="UserDefinedFields_0_" type="text" value="aaa" name="UserDefinedFields[0]" data-val-required="Required" data-val-editor-id="UserDefinedFields_0_" data-val-position="1" />
                                    </div>
                                    <input id="z91365714133d4bcd95c4b1d2b64842e2" name="UserDefinedFields[0]_Id" type="hidden" value="29682908" /><input id="zc8f27f4f4d104d7c891765c5644364ab" name="UserDefinedFields[0]_Type" type="hidden" value="7" />
                                </div>
                                <div class="Udf EditorLabelContainer">
                                    <div class="Label">
                                        <label for="UserDefinedFields_2_">task_col3</label><span class="Required Off">*</span>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect Udf" data-editor-id="UserDefinedFields_2_" data-rdp="UserDefinedFields_2_">
                                    <div class="InputField">
                                        <select id="UserDefinedFields_2_" name="UserDefinedFields[2]">
                                            <option value="" title=""></option>
                                            <option value="29682863" title="AA">AA</option>
                                            <option value="29682864" title="BB">BB</option>
                                        </select>
                                    </div>
                                    <input id="z348fad983e5140c586a91d238aeb1464" name="UserDefinedFields[2]_Id" type="hidden" value="29682910" /><input id="zad561599b616411c80cfc2109b4b0ee6" name="UserDefinedFields[2]_Type" type="hidden" value="4" />
                                </div>
                            </div>
                            <div class="Normal Column">
                                <div class="Udf EditorLabelContainer">
                                    <div class="Label">
                                        <label for="UserDefinedFields_1_">task_col2</label><span class="Required Off">*</span>
                                    </div>
                                </div>
                                <div class="Editor DateBox Udf" data-editor-id="UserDefinedFields_1_" data-rdp="UserDefinedFields_1_">
                                    <div class="InputField">
                                        <div class="Container">
                                            <input id="UserDefinedFields_1_" type="text" value="" name="UserDefinedFields[1]" data-val-date="Invalid date" data-val-editor-id="UserDefinedFields_1_" data-val-position="1" /><a class="NormalState Button ButtonIcon IconOnly Date" id="UserDefinedFields_1__calendarButton" tabindex="0"><span class="Icon"></span><span class="Text"></span></a>
                                        </div>
                                    </div>
                                    <input id="zeb56f35527ca4321b154415954309ece" name="UserDefinedFields[1]_Id" type="hidden" value="29682909" /><input id="z361459c90d524046acd271690a3b7d21" name="UserDefinedFields[1]_Type" type="hidden" value="2" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="Normal Section" id="notificationHeader">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">Notification</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Notifications_NotificationTemplate">Notification Template</label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect" data-editor-id="Notifications_NotificationTemplate" data-rdp="Notifications_NotificationTemplate">
                                    <div class="InputField">
                                        <select id="Notifications_NotificationTemplate" name="Notifications.NotificationTemplate">
                                            <option value="24" title="Issue - Created" selected="selected">Issue - Created</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="Large Column">
                                <div class="CustomLayoutContainer">
                                    <div class="NotificationRecipients_fromLine">
                                        <span class="NotificationRecipients_text NotificationRecipients_label">From:&nbsp;&nbsp;</span>
                                        <span class="NotificationRecipients_text" id="FromEmail"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="Large Column">
                                <div class="CustomLayoutContainer">
                                    <div>
                                        <span class="NotificationRecipients_text">
                                            <a href="#" onclick="notificationRecipients.showCustomRecipientDataSelector('To')" class="NotificationRecipients_links">To</a>:
					&nbsp;
                                        </span>
                                        <span class="NotificationRecipients_text">
                                            <a href="#" onclick="$.proxy(notificationRecipients.addToMe(), notificationRecipients)" class="NotificationRecipients_links">Me</a>
                                            <a id="LinkButton1" href="#" onclick="$.proxy(notificationRecipients.linkButton1Clicked(), notificationRecipients)" class="NotificationRecipients_links NotificationRecipients_leftMargin"></a>
                                            <a id="LinkButton2" href="#" onclick="$.proxy(notificationRecipients.linkButton2Clicked(), notificationRecipients)" class="NotificationRecipients_links NotificationRecipients_leftMargin"></a>
                                        </span>
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Notifications_ToEmailDisplay"></label>
                                    </div>
                                </div>
                                <div class="Editor TextBox LabeledValue" data-editor-id="Notifications_ToEmailDisplay">
                                    <div class="InputField"><span class="Value"></span></div>
                                    <input id="Notifications_ToEmailDisplay" name="Notifications.ToEmailDisplay" type="hidden" value="" />
                                </div>
                                <input id="Notifications_ToEmailAddresses" name="Notifications.ToEmailAddresses" type="hidden" value="" /><input id="Notifications_ToContactEmailAddresses" name="Notifications.ToContactEmailAddresses" type="hidden" value="" /><input id="Notifications_ToDepartmentList" name="Notifications.ToDepartmentList" type="hidden" value="" /><input id="Notifications_ToResourceEmailAddresses" name="Notifications.ToResourceEmailAddresses" type="hidden" value="" /><input id="Notifications_ToWorkgroupList" name="Notifications.ToWorkgroupList" type="hidden" value="" /><input id="Notifications_ToTeamResourceList" name="Notifications.ToTeamResourceList" type="hidden" value="" /><input id="Notifications_ToTeamContactList" name="Notifications.ToTeamContactList" type="hidden" value="" />
                            </div>
                            <div class="Large Column">
                                <div class="CustomLayoutContainer">
                                    <div>
                                        <span class="NotificationRecipients_text">
                                            <a href="#" onclick="notificationRecipients.showCustomRecipientDataSelector('Cc')" class="NotificationRecipients_links">Cc</a>:
					&nbsp;
                                        </span>
                                        <span class="NotificationRecipients_text">
                                            <a href="#" onclick="$.proxy(notificationRecipients.addCcMe(), notificationRecipients)" class="NotificationRecipients_links">Me</a>
                                        </span>
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Notifications_CCEmailDisplay"></label>
                                    </div>
                                </div>
                                <div class="Editor TextBox LabeledValue" data-editor-id="Notifications_CCEmailDisplay">
                                    <div class="InputField"><span class="Value"></span></div>
                                    <input id="Notifications_CCEmailDisplay" name="Notifications.CCEmailDisplay" type="hidden" value="" />
                                </div>
                                <input id="Notifications_CCEmailAddresses" name="Notifications.CCEmailAddresses" type="hidden" value="" /><input id="Notifications_CCContactEmailAddresses" name="Notifications.CCContactEmailAddresses" type="hidden" value="" /><input id="Notifications_CCDepartmentList" name="Notifications.CCDepartmentList" type="hidden" value="" /><input id="Notifications_CCResourceEmailAddresses" name="Notifications.CCResourceEmailAddresses" type="hidden" value="" /><input id="Notifications_CCWorkgroupList" name="Notifications.CCWorkgroupList" type="hidden" value="" />
                            </div>
                            <div class="Large Column">
                                <div class="CustomLayoutContainer">
                                    <div>
                                        <span class="NotificationRecipients_text">
                                            <a href="#" onclick="notificationRecipients.showCustomRecipientDataSelector('Bcc')" class="NotificationRecipients_links">Bcc</a>:
					&nbsp;
                                        </span>
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
                                    <div class="InputField"><span class="Value"></span></div>
                                    <input id="Notifications_BccEmailDisplay" name="Notifications.BccEmailDisplay" type="hidden" value="" />
                                </div>
                                <input id="Notifications_BccEmailAddresses" name="Notifications.BccEmailAddresses" type="hidden" value="" /><input id="Notifications_BccContactEmailAddresses" name="Notifications.BccContactEmailAddresses" type="hidden" value="" /><input id="Notifications_BccDepartmentList" name="Notifications.BccDepartmentList" type="hidden" value="" /><input id="Notifications_BccResourceEmailAddresses" name="Notifications.BccResourceEmailAddresses" type="hidden" value="" /><input id="Notifications_BccWorkgroupList" name="Notifications.BccWorkgroupList" type="hidden" value="" /><div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Notifications_Subject">Subject</label>
                                    </div>
                                </div>
                                <div class="Editor TextBox" data-editor-id="Notifications_Subject" data-rdp="Notifications_Subject">
                                    <div class="InputField">
                                        <input id="Notifications_Subject" type="text" value="" name="Notifications.Subject" />
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Notifications_AdditionalEmailText">Additional Email Text</label>
                                    </div>
                                </div>
                                <div class="Editor TextArea" data-editor-id="Notifications_AdditionalEmailText" data-rdp="Notifications_AdditionalEmailText">
                                    <div class="InputField">
                                        <textarea class="Medium" id="Notifications_AdditionalEmailText" name="Notifications.AdditionalEmailText" placeholder=""></textarea>
                                    </div>
                                </div>
                                <div class="CustomLayoutContainer">
                                    <div class="NotificationRecipients_editDefaultSettingsContainer">
                                        <a href="#" onclick="notificationRecipients.openDefaultSettings();" class="NotificationRecipients_links">Edit Default Settings</a>:
				&nbsp;
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <div id="BackgroundOverlay"></div>
        <div id="LoadingIndicator"></div>
        <div id="DelayNotification">
            <div class="Title">Processing your request...</div>
            <div class="Description">This may take several seconds</div>
        </div>
        <div class="Normal Dialog" id="AlertDialog" style="height: 300px;">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="autotask.dialogManagement.__closeDialog(event);"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title"><span class="Text">Message</span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="DialogHeadingContainer"></div>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer" id="z0d5e53f8cb774ff2897858068dfb0df7">
                            <div class="Medium NoHeading Section">
                                <div class="Content">
                                    <div class="Normal Column">
                                        <div class="IconContainer">
                                            <div class="Icon Decoration"></div>
                                        </div>
                                        <div class="StandardText HighImportance"></div>
                                        <div class="StandardText"></div>
                                        <div class="Confirmation ButtonContainer"><a class="NormalState Button ButtonIcon" id="AlertDialogOkayButton" tabindex="0"><span class="Icon"></span><span class="Text">OK</span></a></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Normal Dialog" id="ConfirmationDialog" style="height: 300px;">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="autotask.dialogManagement.__closeDialog(event);"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title"><span class="Text">Message</span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="DialogHeadingContainer"></div>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer" id="z27be44e79b864a1fb58437207c4c377d">
                            <div class="Medium NoHeading Section">
                                <div class="Content">
                                    <div class="Normal Column">
                                        <div class="IconContainer">
                                            <div class="Icon Decoration"></div>
                                        </div>
                                        <div class="StandardText HighImportance"></div>
                                        <div class="StandardText"></div>
                                        <div class="Confirmation ButtonContainer"><a class="NormalState Button ButtonIcon" id="ConfirmationDialogYesButton" tabindex="0"><span class="Icon"></span><span class="Text">Yes</span></a><a class="NormalState Button ButtonIcon" id="ConfirmationDialogNoButton" tabindex="0"><span class="Icon"></span><span class="Text">No</span></a></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="VerticalXS Normal Dialog" id="ProgressBarDialog">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="autotask.dialogManagement.__closeDialog(event);"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title"><span class="Text"></span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="DialogHeadingContainer"></div>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer" id="z0239cd993ff04451b330607845cd2cd5">
                            <div class="Medium NoHeading Section">
                                <div class="Content">
                                    <div class="Normal Column">
                                        <div class="ProgressBarContainer">
                                            <div class="ProgressBar"></div>
                                        </div>
                                        <div class="ProgressBarDescription">
                                            <div class="StandardText"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Fixed CalculationContainer">
            <div></div>
        </div>
        <div class="Scrolling CalculationContainer">
            <div></div>
        </div>
        <a id="GlobalControlClickLink" target="_blank" style="display: none"></a>
        <div class="ContextOverlayContainer" id="calendarOverlay5D75D30D92504706A949DC4DD367328A">
            <div class="CalendarContextOverlay ContextOverlay">
                <div class="Outline Arrow"></div>
                <div class="Arrow"></div>
                <div class="Content">
                    <div class="CalendarContainer" id="calendar5D75D30D92504706A949DC4DD367328A">
                        <div class="Left Calendar">
                            <div class="CalendarNavigation">
                                <div class="Arrow Left"><span></span></div>
                                <span class="Text"></span>
                                <div class="Arrow Right"><span></span></div>
                            </div>
                            <table class="Header DateContainer">
                                <thead>
                                    <tr>
                                        <th>Mon</th>
                                        <th>Tue</th>
                                        <th>Wed</th>
                                        <th>Thu</th>
                                        <th>Fri</th>
                                        <th>Sat</th>
                                        <th>Sun</th>
                                    </tr>
                                </thead>
                            </table>
                            <table class="DateContainer">
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="Middle Calendar">
                            <div class="CalendarNavigation">
                                <div class="Arrow Left"><span></span></div>
                                <span class="Text"></span>
                                <div class="Arrow Right"><span></span></div>
                            </div>
                            <table class="Header DateContainer">
                                <thead>
                                    <tr>
                                        <th>Mon</th>
                                        <th>Tue</th>
                                        <th>Wed</th>
                                        <th>Thu</th>
                                        <th>Fri</th>
                                        <th>Sat</th>
                                        <th>Sun</th>
                                    </tr>
                                </thead>
                            </table>
                            <table class="DateContainer">
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="Right Calendar">
                            <div class="CalendarNavigation">
                                <div class="Arrow Left"><span></span></div>
                                <span class="Text"></span>
                                <div class="Arrow Right"><span></span></div>
                            </div>
                            <table class="Header DateContainer">
                                <thead>
                                    <tr>
                                        <th>Mon</th>
                                        <th>Tue</th>
                                        <th>Wed</th>
                                        <th>Thu</th>
                                        <th>Fri</th>
                                        <th>Sat</th>
                                        <th>Sun</th>
                                    </tr>
                                </thead>
                            </table>
                            <table class="DateContainer">
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="LoadingIndicator"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="ContextOverlayContainer" id="currencyTranslationOverlay5D75D30D92504706A949DC4DD367328A">
            <div class="CurrencyTranslationContextOverlay ContextOverlay">
                <div class="Outline Arrow"></div>
                <div class="Arrow"></div>
                <div class="Active LoadingIndicator"></div>
                <div class="Content"></div>
            </div>
            <div class="CurrencyTranslationContextOverlay ContextOverlay">
                <div class="Outline Arrow"></div>
                <div class="Arrow"></div>
                <div class="Active LoadingIndicator"></div>
                <div class="Content"></div>
            </div>
        </div>
        <div class="ContextOverlayContainer" id="validationOverlay5D75D30D92504706A949DC4DD367328A">
            <div class="ValidationContextOverlay ContextOverlay">
                <div class="Outline Arrow"></div>
                <div class="Arrow"></div>
                <div class="Content">
                    <div class="ValidationIcon"></div>
                    <div class="ValidationMessage"></div>
                    <div class="ValidationOverlayCloseButton"></div>
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

<script src="../Scripts/common.js"></script>
<script>

    $(function () {
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
        } else if ($("#TaskTypeFixedDuration").is(":checked")) {
            $("#estimated_hours").val("0.00");
            $("#estimated_hours").prop("disabled", true);
            $("#hours_per_resource").prop("disabled", false);
        } else {

        }
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
        var startDateVal = $("#estimated_begin_time").val();
        if (thanDateVal != "" && startDateVal != "") {
           // thanDateVal = thanDateVal.replace(/-/g, "/");
            var startDateArr = startDateVal.split(' ');
            startDateVal = startDateArr[0];
            //startDateVal = startDateVal.replace(/-/g, "/");
           // var thanDate = new Date(thanDateVal);
           // var startDate = new Date(startDateVal);
            //  startDate = TranDate(startDate);
            if (compareTime(thanDateVal, startDateVal)) {
                LayerMsg("不早于开始时间要早于开始时间");
                $(this).val("");
            }
        }
    })
    $("#estimated_begin_time").blur(function () {
        var thanDateVal = $("#start_no_earlier_than_date").val();
        var startDateVal = $("#estimated_begin_time").val();
        if (thanDateVal != "" && startDateVal != "") {
            // thanDateVal = thanDateVal.replace(/-/g, "/");
            var startDateArr = startDateVal.split(' ');
            startDateVal = startDateArr[0];
            //startDateVal = startDateVal.replace(/-/g, "/");
            // var thanDate = new Date(thanDateVal);
            // var startDate = new Date(startDateVal);
            //  startDate = TranDate(startDate);
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

    }
</script>
