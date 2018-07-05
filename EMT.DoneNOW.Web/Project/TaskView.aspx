<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskView.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.TaskView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=taskType %>详情</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <link href="../Content/DynamicContent.css" rel="stylesheet" />
    <link rel="stylesheet" href="../Content/NewWorkType.css" />
    <style>
        body{
            background-color:white;
        }
        .empty_row {
            height: 8px;
            border-top: solid 1px #d3d3d3;
            line-height: 8px;
        }

        .link_area {
            background-color: #f0f5fb;
            border: solid 1px #D3D3D3;
            width: 261px;
        }

        .task_label {
            margin: 0;
            vertical-align: top;
            white-space: nowrap;
            color: #4f4f4f;
            font-size: 12px;
        }

        body {
            font-size: 9pt;
        }

        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
            border-right-width: 1px;
            border-right-style: solid;
            font-size: 12px;
            font-weight: bold;
            height: 19px;
            padding: 4px;
            vertical-align: top;
            word-wrap: break-word;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        .dataGridHeader {
            border-left: outset 1px;
            border-right: outset 1px;
            border-bottom: outset 1px;
            font-size: 9px;
            font-weight: bold;
            color: #555;
            text-decoration: none;
            height: 25px;
            background-color: #cbd9e4;
            vertical-align: top;
        }

        .dataGridBody td, .dataGridAlternating td, .dataGridBodyHover td, .dataGridAlternatingHover td, .dataGridDisabled td, .dataGridDisabledHover td {
            border-width: 1px;
            border-style: solid;
            border-left-color: #F8F8F8;
            border-right-color: #F8F8F8;
            border-top-color: #e8e8e8;
            border-bottom-width: 0;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: top;
            padding: 4px;
            word-wrap: break-word;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            background-color: white;
            border-left-width: 0;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: middle;
            padding: 10px 0 4px 0;
            vertical-align: top;
            word-wrap: break-word;
            border-right-width: 1px;
            border-right-style: solid;
        }

        .windowshade td {
            border-width: 1px;
            border-style: solid;
            border-left-color: white;
            border-right-color: white;
            border-top-color: white;
            border-bottom-width: 0;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: top;
            padding: 4px;
            word-wrap: break-word;
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
                .BookmarkButton {
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: relative;
            width: 16px;
            float: right;
            margin-top: 8px;
        }

            .BookmarkButton.Selected div {
                border-color: #f9d959;
            }

            .BookmarkButton > .LowerLeftPart {
                border-right-width: 8px;
                border-bottom-width: 6px;
                border-left-width: 8px;
                top: 5px;
                -moz-transform: rotate(35deg);
                -webkit-transform: rotate(35deg);
                -ms-transform: rotate(35deg);
                transform: rotate(35deg);
            }

            .BookmarkButton > .LowerRightPart {
                border-right-width: 8px;
                border-bottom-width: 6px;
                border-left-width: 8px;
                top: 5px;
                -moz-transform: rotate(-35deg);
                -webkit-transform: rotate(-35deg);
                -ms-transform: rotate(-35deg);
                transform: rotate(-35deg);
            }

            .BookmarkButton > div.LowerLeftPart, .BookmarkButton > div.LowerRightPart, .BookmarkButton > div.UpperPart {
                border-left-color: transparent;
                border-right-color: transparent;
                border-style: solid;
                border-top: none;
                height: 0;
                position: absolute;
                width: 0;
            }

            .BookmarkButton > .UpperPart {
                border-bottom-width: 6px;
                border-left-width: 3px;
                border-right-width: 3px;
                left: 5px;
                top: 1px;
            }
    </style>
</head>
<body>
    <div class="Active ThemePrimaryColor TitleBar">
        <div class="Title"><span class="Text"><%=taskType %>-<%=thisTask.no %>-<%=thisTask.title %>(<%=thisAccount.name %>)</span><span class="SecondaryText"></span> <div id="bookmark" class="BookmarkButton <%if (thisBookMark != null)
                { %>Selected<%} %> "
                onclick="ChangeBookMark()">
                <div class="LowerLeftPart"></div>
                <div class="LowerRightPart"></div>
                <div class="UpperPart"></div>
            </div></div>
        <div class="TitleBarButton Star" id="za129bcc0139b41ea8e2f627eb64b9cd3" title="Bookmark this page">
            <div class="TitleBarIcon Star"></div>
        </div>
        <div class="ContextHelpButton" onclick="window.open(&#39;/Help/default_csh.htm#1117&#39;, &#39;Projects_Task_New&#39;, &#39;height=650,width=960,top=100,left=100,status=0,toolBar=0,menubar=0,directories=0,resizable=1,scrollbars=1&#39;);"></div>
    </div>

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
                 <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_EDIT_TASK"))
                     { %>
                <a class="NormalState Button ButtonIcon Save" id="SaveDropDownButton_LeftButton" tabindex="0" onclick="EditTask()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">修改</span></a>
                <%} %>
                <a class="NormalState Button ButtonIcon Cancel" id="PrintButton" tabindex="0">
                    <%--<span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span>--%>
                    <span class="Text">打印</span>

                </a>
                 <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_SHOW_HISTORY"))
                     { %>
                <a class="NormalState Button ButtonIcon Cancel" id="TaskHistoryButton" tabindex="0" onclick="ShowHistory()">
                   <%-- <span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span>--%>
                    <span class="Text"><%=taskType %>历史</span>

                </a>
                 <%} %>
                <a class="NormalState Button ButtonIcon Cancel" id="CancelButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></span><span class="Text">关闭</span></a>
            </div>
        </div>
        <div class="ScrollingContentContainer">
            <div class="ScrollingContainer" id="za7dce764d22b4572aaf851391e3b7f6f" style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 85px;">
                <div class="DivSectionWithHeader">
                    <div class="HeaderRow">
                        <span id="TaskNameATLabel" class="lblNormalClass" style="font-weight: bold;"><%=thisTask.title %></span>
                    </div>
                    <div class="Content" style="padding-bottom: 19px;">
                        <%   var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
                            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                            var statusList = dic.FirstOrDefault(_ => _.Key == "ticket_status").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                            var sysResList = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                            var depList = dic.FirstOrDefault(_ => _.Key == "department").Value as List<EMT.DoneNOW.Core.sys_department>;
                            var rolList = dic.FirstOrDefault(_ => _.Key == "role").Value as List<EMT.DoneNOW.Core.sys_role>;
                        %>
                        <table id="taskInfoTable" cellpadding="0" cellspacing="0" class="info_table" width="100%" style="border-bottom-color: white;">
                            <tbody>
                                <tr>
                                    <td class="empty_titleRow" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td style="width: 600px;">
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td class="task_label_cell">
                                                        <span id="WhenATLabel" class="task_label" style="font-weight: bold;">起止时间: </span>
                                                    </td>
                                                    <td>
                                                        <span id="StartValueATLabel" class="task_label_value" style="font-weight: normal;"><%=(EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time)).ToString("yyyy-MM-dd HH:mm:ss") %></span>
                                                        -
						<span id="DueValueATLabel" class="task_label_value" style="font-weight: normal;"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_end_time).ToString("yyyy-MM-dd") %>(预估小时:<%=thisTask.estimated_hours.ToString("#0.00") %>) </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="StatusATLabel" class="task_label" style="font-weight: bold;">状态:</span>
                                                    </td>
                                                    <td>
                                                        <span id="StatusValueATLabel" class="task_label_value" style="font-weight: normal;"><% var thisStatus = statusList.FirstOrDefault(_ => _.val == thisTask.status_id.ToString());if (thisStatus != null){ %><%=thisStatus.show %><%} %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="PriorityATLabel" class="task_label" style="font-weight: bold;">优先级: </span>
                                                    </td>
                                                    <td>
                                                        <span id="PriorityValueATLabel" class="task_label_value" style="font-weight: normal;"><%=thisTask.priority %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="CreatedByATLabel" class="task_label" style="font-weight: bold;">创建人:</span>
                                                    </td>
                                                    <td>
                                                        <span id="CreatedByExpenditureNameATLabel" class="task_label_value" style="font-weight: normal;"><% var thisCreateRes = sysResList.FirstOrDefault(_ => _.val == thisTask.create_user_id.ToString());if (thisCreateRes != null) {%><%=thisCreateRes.show %><%}%></span>&nbsp;&nbsp;
							<span id="OnATLabel" class="task_label_value" style="font-weight: normal;"></span>&nbsp;&nbsp;&nbsp;
							<span id="DateValueATLabel" class="task_label_value" style="font-weight: normal;"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time).ToString("yyyy-MM-dd") %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="height: 8px; line-height: 8px;">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <span id="AssignedToATLabel" class="task_label" style="font-weight: bold;">负责人:</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" class="empty_row">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="AssignToEmployeeATLabel" class="task_label" style="font-weight: bold;">主负责人:</span>
                                                    </td>
                                                    <td>
                                                        <span id="AssignToEmplyeeNameATLabel" class="task_label_value" style="font-weight: normal;"><%if (thisTask.owner_resource_id != null)
                                                                                                                                                        {%> <%=sysResList.FirstOrDefault(_=>_.val==thisTask.owner_resource_id.ToString()).show %> <%} %>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="DepartmentATLabel" class="task_label" style="font-weight: bold;">部门:</span>
                                                    </td>
                                                    <td>
                                                        <span id="DepartmentValueATLabel" class="task_label_value" style="font-weight: normal;"><%if (thisTask.department_id != null)
                                                                                                                                                    {%> <%=depList.FirstOrDefault(_=>_.id==thisTask.department_id).name %> <%} %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="SecondaryResourceATLabel" class="task_label" style="font-weight: bold;">其他员工:</span>
                                                    </td>
                                                    <td>
                                                        <span id="SecondaryResourceValueATLabel" class="task_label_value" style="font-weight: normal;">
                                                            <%if (thisTaskResList != null && thisTaskResList.Count > 0)
                                                                {
                                                                    var resList = thisTaskResList.Where(_ => _.contact_id == null && _.resource_id != null && _.role_id != null).ToList();
                                                                    var conList = thisTaskResList.Where(_ => _.contact_id != null).ToList();
                                                                    if (resList != null && resList.Count > 0)
                                                                    {
                                                                        foreach (var thisRes in resList)
                                                                        {
                                                                            var res = sysResList.FirstOrDefault(_ => _.val == thisRes.resource_id.ToString());
                                                                            var role = rolList.FirstOrDefault(_ => _.id == thisRes.role_id);
                                                                            if (res != null && role != null)
                                                                            {%>
                                                            <%=res.show+"("+role.name+")" %>
                                                            <%if (conList != null && conList.Count > 0)
                                                                {%>
                                                            <br />
                                                            <%}
                                                                else
                                                                {
                                                                    if (resList.IndexOf(thisRes) != resList.Count - 1)
                                                                    {%>
                                                            <br />
                                                            <%}

                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                if (conList != null && conList.Count > 0)
                                                                {
                                                                    var ccDal = new EMT.DoneNOW.DAL.crm_contact_dal();
                                                                    foreach (var thisCon in conList)
                                                                    {
                                                                        var con = ccDal.FindNoDeleteById((long)thisCon.contact_id);
                                                                        if (con != null)
                                                                        {%>
                                                            <%=con.name %>
                                                            <% if (conList.IndexOf(thisCon) != conList.Count - 1)
                                                                {%>
                                                            <br />
                                                            <%}
                                                                            }
                                                                        }
                                                                    }

                                                                } %>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="WorkTypeATLabel" class="task_label" style="font-weight: bold;">工作类型:</span>
                                                    </td>
                                                    <td>
                                                        <span id="WorkTypeValueATLabel" class="task_label_value" style="font-weight: normal;">
                                                            <% if (thisTask.cost_code_id != null)
                                                                {
                                                                    var dccDal = new EMT.DoneNOW.DAL.d_cost_code_dal();
                                                                    var thisCostCode = dccDal.FindNoDeleteById((long)thisTask.cost_code_id);
                                                                    if (thisCostCode != null)
                                                                    {%>
                                                            <%=thisCostCode.name %>
                                                            <%}
                                                                }

                                                            %>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <span id="PONumberATLabel" class="task_label" style="font-weight: bold;">采购订单号:</span>
                                                    </td>
                                                    <td>
                                                        <span id="PONumberValueATLabel" class="task_label_value" style="font-weight: normal;"><%=thisTask.purchase_order_no %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="height: 8px; line-height: 8px;">&nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" class="empty_row">&nbsp;
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td align="right" valign="top">
                                        <table id="linkTable" cellpadding="0" cellspacing="0" class="link_area">
                                            <tbody>
                                                <tr>
                                                    <td class="link_area_cell" valign="top">
                                                        <span id="ProjectATLabel" class="task_label" style="font-weight: bold;">项目:</span>
                                                    </td>
                                                    <td valign="top">
                                                        <a onclick="OpenProject()"><%=thisProject.name %></a>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <span id="AccountATLabel" class="task_label" style="font-weight: bold;">客户:</span>
                                                    </td>
                                                    <td valign="top">
                                                        <a onclick="OpenAccount()"><%=thisAccount.name %></a>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top"></td>
                                                    <td valign="top">
                                                        <%    var defaultLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocationByAccountId(thisAccount.id); %>
                                                        <span class="task_label_value">
                                                            <%if (defaultLocation != null)
                                                                { %>
                                                            <%=country.First(_=>_.val.ToString()==defaultLocation.country_id.ToString()).show  %>
                                                            <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.province_id.ToString()).show  %>
                                                            <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.city_id.ToString()).show  %>
                                                            <%=addressdistrict.First(_=>_.val.ToString()==defaultLocation.district_id.ToString()).show  %>
                                                            <%=defaultLocation.address %><br>
                                                            <%=defaultLocation.additional_address %><br>
                                                            <%=defaultLocation.postal_code %>

                                                            <%} %>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top"></td>
                                                    <td valign="top">
                                                        <span class="task_label_value"><%=thisAccount.phone %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <span id="ContractATLabel" class="task_label" style="font-weight: bold;">合同:</span>
                                                    </td>
                                                    <td valign="top">
                                                        <%if (thisContract != null)
                                                            { %>
                                                        <a onclick="OpenContract()"><%=thisContract.name %></a>
                                                        <%} %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <span id="EstimatedHoursATLabel" class="task_label" style="font-weight: bold;">预估时间:</span>
                                                    </td>
                                                    <td valign="top">
                                                        <span class="task_label_value"><%=thisTask.estimated_hours.ToString("#0.00") %></span>

                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <span id="ActualHoursATLabel" class="task_label" style="font-weight: bold;">实际时间:</span>
                                                    </td>
                                                    <td valign="top">
                                                        <span class="actualHoursTextGreen"><%=v_task!=null?(v_task.worked_hours==null?"":((decimal)v_task.worked_hours).ToString("#0.00")):"" %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <span id="RemainingHoursATLabel" class="task_label" style="font-weight: bold;">剩余时间:</span>
                                                    </td>
                                                    <td valign="top">
                                                        <span class="task_label_value"><%=v_task!=null?(v_task.remain_hours==null?"":((decimal)v_task.remain_hours).ToString("#0.00")):"" %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">
                                                        <span id="ProjectedVarianceFromEstimatedATLabel" class="task_label" style="font-weight: bold;">预估差异:</span>
                                                    </td>
                                                    <td valign="top">
                                                        <br>
                                                        <span class="task_label_value"><%=v_task!=null?(v_task.projected_variance==null?"":((decimal)v_task.projected_variance).ToString("#0.00")):"" %></span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" height="10"></td>
                                                </tr>
                                            </tbody>
                                        </table>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="subTitle_label">
                                        <span id="DescriptionATLabel" class="task_label" style="font-weight: bold;">描述:</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <span id="DescriptionValueATLabel" class="task_label_value" style="font-weight: normal;"><%=thisTask.description %></span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="Normal Section" style="border: 1px solid #d3d3d3; margin: 0 10px 10px 10px; padding: 4px 0 4px 0;">
                    <div class="Heading" data-toggle-enabled="true">
                        <div class="Toggle Collapse Toggle1">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <div class="Left"><span class="Text">工时，备注，附件</span><span class="SecondaryText"></span></div>
                        <div class="Spacer"></div>
                    </div>
                    <div class="Content" style="padding: 0 28px 35px 18px;">
                        <div id="timeEntryContentPanel" class="Content">
                            <div class="ButtonContainer">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_ADD_ENTRY_NOTIME") || CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_ADD_ENTRY_TIME"))
                                    { %>
                                <a class="NormalState Button ButtonIcon Save" id="NewTimeEntry" tabindex="0" onclick="AddEntry()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">新增工时</span></a>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_NOTE_ADD"))
                                    { %>
                                <a class="NormalState Button ButtonIcon Save" id="NewNote" tabindex="0" onclick="AddNote()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">新增备注</span></a>
                                <%} %>
                                 <%if (CheckAuth("PRO_PROJECT_VIEW_ATTACH_ADD"))
                                    { %>
                                <a class="NormalState Button ButtonIcon Save" id="NewAttach" tabindex="0" onclick="AddAttach()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">新增附件</span></a>  <%} %>
                            </div>
                            <div id="timeEntryCheckBoxPanel" style="padding: 0px 0px 3px 10px; font-size: 12px; display: block;">
                                <span id="timeEntryWorkFlow"><span class="txtBlack8Class">
                                    <input id="sysNote" type="checkbox" style="vertical-align: middle;"><label for="timeEntryWorkFlow_ATCheckBox" style="vertical-align: middle;">系统备注</label></span></span><span id="timeEntryDetails" style="margin-left: 8px;"><span class="txtBlack8Class"><input id="tvbDetail" type="checkbox" style="clear: both; float: none; display: unset;" /><label for="timeEntryDetails_ATCheckBox" style="">详情</label></span></span>
                            </div>
                        </div>
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tbody>
                                <tr id="mainGridContainer">
                                    <td>
                                        <div id="timeEntryGrid_timeEntryGrid_divgrid" class="GridContainer">
                                            <div id="timeEntryGrid_timeEntryGrid_divdata" showheader="true" style="width: 100%;">
                                                <table class="dataGridBody" cellspacing="0" rules="all" border="1" id="timeEntryGrid_timeEntryGrid_datagrid" style="width: 100%; border-collapse: collapse; border-bottom-color: white;">
                                                    <tbody>
                                                        <tr class="dataGridHeader">
                                                            <td style="min-width: 20px;">
                                                                <input type="hidden" id="pageTvbOrder" value="<%=!string.IsNullOrEmpty(tvbOrder)?tvbOrder:"" %>" /></td>
                                                            <%
                                                                string[] orderThArr = null;
                                                                if (!string.IsNullOrEmpty(tvbOrder))
                                                                {
                                                                    orderThArr = tvbOrder.Split('_');
                                                                }
                                                            %>

                                                            <%
                                                                foreach (var tvbTH in tvbDto)
                                                                {%>
                                                            <td style="text-align: center" onclick="ChangeOrderTVB('<%=tvbTH.val %>')"><%=tvbTH.show %>
                                                                <% if (orderThArr != null && orderThArr[0] == tvbTH.val)
                                                                    {%>

                                                                <img src="../Images/sort-<%=tvbTH.select==1?"desc":"asc" %>.png" />

                                                                <%} %>
                                                            </td>
                                                            <%}%>
                                                        </tr>
                                                        <%if (tvdList != null && tvdList.Count > 0)
                                                            {
                                                                var conDal = new EMT.DoneNOW.DAL.ctt_contract_dal();
                                                                var ccDal = new EMT.DoneNOW.DAL.d_cost_code_dal();
                                                                var opBLl = new EMT.DoneNOW.BLL.OpportunityBLL();

                                                                foreach (var thisTvbValue in tvdList)
                                                                {%>

                                                        <%if (thisTvbValue.type != "atach")
                                                            { %>
                                                        <tr onclick="ShowTvbDetail('<%=thisTvbValue.id %>')" class="rightMenu <%=thisTvbValue.type == "note"?"noteTR":"entryTR" %>" data-val="<%=thisTvbValue.id %>">
                                                            <td>
                                                                <img src="../Images/MagnifyPlus.png" id="<%=thisTvbValue.id %>_img" />
                                                                <img src="../Images/imgGridEdit.png" onclick="EditThis('<%=thisTvbValue.type %>','<%=thisTvbValue.id %>')" />
                                                            </td>
                                                            <td>
                                                                <%if (thisTvbValue.type == "note")
                                                                    { %><img src="../Images/note.png" />
                                                                <%}
                                                                    else
                                                                    { %><img src="../Images/time.png" />
                                                                <%} %>
                                                            </td>
                                                            <td><%if (thisTvbValue.type == "entry")
                                                                    { %>
                                                                 <%=thisTvbValue.time.ToString("yyyy-MM-dd") %>
                                                                <%}
                                                                 else
                                                                 { %>
                                                                 <%=thisTvbValue.time.ToString("yyyy-MM-dd HH:mm:ss") %>
                                                                <%} %>
                                                               
                                                            </td>
                                                            <td>
                                                                <%=thisTvbValue.resouName %>
                                                            </td>
                                                            <td><%=thisTvbValue.workHours %></td>
                                                            <td><%=thisTvbValue.notTiltle %></td>
                                                            <td><%=thisTvbValue.billabled %></td>
                                                            <td><%=thisTvbValue.billed %></td>
                                                        </tr>
                                                        <tr id="<%=thisTvbValue.id %>_detail" class="tvbClass" style="display: none;">
                                                            <td colspan="8">
                                                                <div style="display: block">
                                                                    <%if (thisTvbValue.type == "entry")
                                                                        { %>
                                                                    <table class="windowshade" cellspacing="5" cellpadding="0" border="0">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td>
                                                                                    <table class="windowshade" cellspacing="5" cellpadding="0" border="0" style="margin-bottom: 0px;">
                                                                                        <tbody>
                                                                                            <tr>
                                                                                                <td class="label">工作时间:</td>
                                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"><%=thisTvbValue.startDate.ToString("yyyy-MM-dd HH:mm:ss") %> - <%=thisTvbValue.time.ToString("HH:mm:ss") %></span></td>
                                                                                                <td class="label">工作类型:</td>
                                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"><%if (thisTvbValue.workTypeId != null)
                                                                                                                                                                                     {
                                                                                                                                                                                         var wor = ccDal.FindNoDeleteById((long)thisTvbValue.workTypeId);
                                                                                                                                                                                         if (wor != null)
                                                                                                                                                                                         {%>
                                                                                                    <%=wor.name %>                                                                                                                                           <%  }
                                                                                                }%></span></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="label">合同:</td>
                                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"><%if (thisTvbValue.contractId != null)
                                                                                                                                                                                     {
                                                                                                                                                                                         var con = conDal.FindNoDeleteById((long)thisTvbValue.contractId);
                                                                                                                                                                                         if (con != null)
                                                                                                                                                                                         {%>
                                                                                                    <%=con.name %>                                                                                                                                           <%   }
                                                                                                                          }%></span></td>
                                                                                                <td class="label">显示在发票上:</td>
                                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"><%=thisTvbValue.showOnInv ? "是" : "否" %></span></td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td class="label">服务/服务包:</td>
                                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"><%if (thisTvbValue.serviceId != null)
                                                                                                                                                                                     {
                                                                                                                                                                                         var name = opBLl.ReturnServiceName((long)thisTvbValue.serviceId);
                                                                                                %><%=name %>
                                                                                                    <%                                                                                               
                                                                                                        }%></span></td>
                                                                                                <td class="label"></td>
                                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"></span></td>
                                                                                            </tr>
                                                                                        </tbody>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <table class="windowshade" cellspacing="5" cellpadding="0" border="0" style="margin-bottom: 0px;">
                                                                                        <tbody>
                                                                                            <tr>
                                                                                                <td class="label">工时说明:</td>
                                                                                                <td class="datanormal"><span class="normalnote" style="font-weight: normal;"><%=thisTvbValue.notTiltle %></span></td>
                                                                                            </tr>
                                                                                        </tbody>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <%}
                                                                        else
                                                                        { %>
                                                                    <table class="windowshade" cellspacing="5" cellpadding="0" border="0">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="label">标题:</td>
                                                                                <td class="datanormal"><span class="normalnote" style="font-weight: normal;"><%=thisTvbValue.notTiltle %></span></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="label">描述:</td>
                                                                                <td class="datanormal"><span class="normalnote" style="font-weight: normal;"><%=thisTvbValue.noteDescr %></span></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                    <%} %>
                                                                </div>
                                                            </td>

                                                        </tr>
                                                        <%}
                                                            else
                                                            { %>
                                                        <tr onclick="OpenAttach('<%=thisTvbValue.id %>')" class="rightMenu atachTR" data-val="<%=thisTvbValue.id %>">
                                                            <td></td>
                                                            <td>
                                                                <img src="../Images/attachment.png" />
                                                            </td>
                                                            <td>
                                                                <%=thisTvbValue.time.ToString("yyyy-MM-dd HH:mm:ss") %>
                                                            </td>
                                                            <td>
                                                                <%=thisTvbValue.resouName %>
                                                            </td>
                                                            <td><%=thisTvbValue.workHours %></td>
                                                            <td><%=thisTvbValue.notTiltle %></td>
                                                            <td><%=thisTvbValue.billabled %></td>
                                                            <td><%=thisTvbValue.billed %></td>
                                                        </tr>
                                                        <%} %>

                                                        <%
                                                                }
                                                            }
                                                            else
                                                            {%>
                                                        <tr>
                                                            <td colspan="8" style="text-align: center; color: red;">暂无数据</td>
                                                        </tr>
                                                        <%} %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                </div>
                <div class="Normal Section" style="border: 1px solid #d3d3d3; margin: 0 10px 10px 10px; padding: 4px 0 4px 0;">
                    <div class="Heading" data-toggle-enabled="true">
                        <div class="Toggle Collapse Toggle2">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <div class="Left"><span class="Text">费用</span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="Content" style="padding: 0 28px 35px 18px;">
                        <div id="ExpenseContentPanel" class="Content">
                            <div class="ButtonContainer">
                                  <%if (CheckAuth("PRO_PROJECT_VIEW_EXPENSES_ADD_EXPENSES"))
                                      { %>
                                <a class="NormalState Button ButtonIcon Save" id="NewExpense" tabindex="0" onclick="AddExpense()"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">新增费用</span></a>
                                <%} %>
                            </div>
                            <div id="ExpenseCheckBoxPanel" style="padding: 0px 0px 3px 0px; font-size: 12px; display: block;">
                                <span id="ExpenseDetails" style="margin-left: 1px;"><span class="txtBlack8Class">
                                    <input id="CkEpDetail" type="checkbox" style="clear: both; float: none; display: unset;" /><label for="timeEntryDetails_ATCheckBox" style="">详情</label></span></span>
                            </div>
                        </div>
                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tbody>
                                <tr id="">
                                    <td>
                                        <div id="" class="GridContainer">
                                            <div id="" style="width: 100%;">
                                                <table class="dataGridBody" cellspacing="0" rules="all" border="1" id="" style="width: 100%; border-collapse: collapse;">
                                                    <tbody>
                                                        <tr class="dataGridHeader">
                                                            <td style="min-width: 20px;">
                                                                <input type="hidden" id="pageExpOrder" value="<%=!string.IsNullOrEmpty(expOrder)?expOrder:"" %>" /></td>
                                                            <%
                                                                string[] expOrderThArr = null;
                                                                if (!string.IsNullOrEmpty(expOrder))
                                                                {
                                                                    expOrderThArr = expOrder.Split(',');
                                                                }
                                                            %>

                                                            <%
                                                                foreach (var expTH in expDto)
                                                                {%>
                                                            <td style="text-align: center" onclick="ChangeOrderExp('<%=expTH.val %>')"><%=expTH.show %>
                                                                <% if (orderThArr != null && orderThArr[0] == expTH.val)
                                                                    {%>

                                                                <img src="../Images/sort-<%=expTH.select==1?"desc":"asc" %>.png" />

                                                                <%} %>
                                                            </td>
                                                            <%}%>
                                                        </tr>
                                                        <%if (taskExpList != null && taskExpList.Count > 0)
                                                            {
                                                                var sysList = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
                                                                var cateList = new EMT.DoneNOW.DAL.d_general_dal().GetGeneralByTableId((long)EMT.DoneNOW.DTO.GeneralTableEnum.EXPENSE_TYPE);
                                                                var expCateList = new EMT.DoneNOW.DAL.d_cost_code_dal().GetListCostCode((int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY);
                                                                var workList = new EMT.DoneNOW.DAL.d_cost_code_dal().GetListCostCode((int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE);
                                                                var payList = new EMT.DoneNOW.DAL.d_general_dal().GetGeneralByTableId((long)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_TYPE);
                                                                foreach (var thisTaskExp in taskExpList)
                                                                {%>
                                                        <tr onclick="ShowTvbDetail('<%=thisTaskExp.id %>')" class="rightMenu expTR" data-val="<%=thisTaskExp.id %>">
                                                            <td>
                                                                <img src="../Images/MagnifyPlus.png" id="<%=thisTaskExp.id %>_img" />
                                                             
                                                                    <img src="../Images/imgGridEdit.png" onclick="EditTaskExp('<%=thisTaskExp.id %>')"/>
                                                              
                                                                
                                                                
                                                            </td>
                                                            <td>
                                                                <%switch (thisTaskExp.type_id)
                                                                    {
                                                                        case (int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_TYPE.ENTERTAINMENT_EXPENSES:
                                                                %>
                                                                <img src="../Images/coin_gold.png" />
                                                                <%--招待费用--%>
                                                                <%
                                                                        break;

                                                                    case (int)EMT.DoneNOW.DTO.DicEnum.EXPENSE_TYPE.TOTAL_MILEAGE:
                                                                %>
                                                                <img src="../Images/coin_gold.png" />
                                                                <%--总里程--%>
                                                                <%
                                                                        break;
                                                                    default:
                                                                %>
                                                                <img src="../Images/coin_gold.png" />
                                                                <%--标准--%>
                                                                <%
                                                                        break;
                                                                    }; %>
                                                             
                                                            </td>
                                                            <td><%=thisTaskExp.add_date.ToString("yyyy-MM-dd") %></td>
                                                            <td><%=sysList.FirstOrDefault(_=>_.val==thisTaskExp.create_user_id.ToString()).show %></td>

                                                            <td><%=expCateList.FirstOrDefault(_=>_.id==thisTaskExp.expense_cost_code_id).name  %></td>
                                                            <td><%=thisTaskExp.amount.ToString("#0.00") %></td>
                                                            <td><%=thisTaskExp.is_billable==1?"√":"" %></td>
                                                            <td><%=thisTaskExp.approve_and_post_user_id!=null?"√":"" %></td>
                                                        </tr>
                                                        <tr id="<%=thisTaskExp.id %>_detail" class="expClass" style="display: none;">
                                                            <td colspan="11">
                                                                <div id="dgCosts__ctl30" class="costswindowshade" style="display: block;">
                                                                    <table class="windowshade" cellspacing="5" cellpadding="0" border="0">
                                                                        <tbody>
                                                                            <tr>
                                                                                <td class="label">描述:</td>
                                                                                <td class="datanormal" colspan="3"><span class="normalnote" style="font-weight: normal;"><%=thisTaskExp.description %></span></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="label">工作类型:</td>
                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"><%=thisTaskExp.cost_code_id!=null?workList.FirstOrDefault(_=>_.id==thisTaskExp.cost_code_id).name:"" %></span></td>
                                                                                <td class="label">采购订单:</td>
                                                                                <td class="datasmall"><span class="smallnormalnote" style="font-weight: normal;"><%=thisTaskExp.purchase_order_no %></span></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="label">支付类型:</td>
                                                                                <td class="datanormal" colspan="3"><span class="normalnote" style="font-weight: normal;"><%=payList.FirstOrDefault(_=>_.id==thisTaskExp.payment_type_id).name %></span></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="label">有收据:</td>
                                                                                <td class="datanormal" colspan="3"><span class="normalnote" style="font-weight: normal;"><%=thisTaskExp.has_receipt==1?"有":"无" %></span></td>
                                                                            </tr>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <%}
                                                            } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>


                <div class="Normal Section" style="border: 1px solid #d3d3d3; margin: 0 10px 10px 10px; padding: 4px 0 4px 0;">
                    <div class="Heading">
                        <div class="Toggle Collapse Toggle3">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <div class="Left"><span class="Text">自定义字段</span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="Content" style="padding: 0 28px 35px 18px;">

                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                            <tbody>
                                <tr id="">
                                    <td>
                                        <div id="" class="GridContainer">
                                            <div id="" style="width: 100%;">
                                                <table class="info_table" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                    <tbody>
                                                        <% if (task_udfList != null && task_udfList.Count > 0)
                                                            {
                                                                foreach (var thisUdf in task_udfList)
                                                                {
                                                                    
                                                                    %>
                                                            <tr>
                                                            <td style="width: 50%;height: 30px;">
                                                                <table cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td class="leftTdArea"><span class="task__info_left_label"><%=thisUdf.col_name %>:</span></td>
                                                                            <%if (thisUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                                                                    {%>
                                                                                <td class="rightTdArea"><span class="value"><%=task_udfValueList != null && task_udfValueList.Count > 0 ? DateTime.Parse(task_udfValueList.FirstOrDefault(_ => _.id == thisUdf.id).value.ToString()).ToString("yyyy-MM-dd") : "" %></span></td>
                                                                               <% }
                                                                                    else
                                                                                    { %>
                                                                                                   <td class="rightTdArea"><span class="value"><%=task_udfValueList != null && task_udfValueList.Count > 0 ? task_udfValueList.FirstOrDefault(_ => _.id == thisUdf.id).value.ToString():"" %></span></td>
                                                                            <%} %>
                                                                        
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </td>
                                                           
                                                        </tr>

                                                        <%}
                                                          } %>
                                                    
                                                      
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>


    <div id="entryMenu" class="menu">
        <ul style="width: 220px;">
            <li id="" onclick="DeleteEntry()"><i class="menu-i1"></i>删除工时
            </li>
        </ul>
    </div>
    <div id="noteMenu" class="menu">
        <ul style="width: 220px;">
            <li id="" onclick="DeleteNote()"><i class="menu-i1"></i>删除备注
            </li>
        </ul>
    </div>
    <div id="attachMenu" class="menu">
        <ul style="width: 220px;">
            <li id="" onclick="DeleteAttach()"><i class="menu-i1"></i>删除附件
            </li>
        </ul>
    </div>
    <div id="expMenu" class="menu">
        <ul style="width: 220px;">
            <li id="" onclick="DeleteExp()"><i class="menu-i1"></i>删除费用
            </li>
        </ul>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
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
    var entityid = "";
    var Times = 0;
    $(".rightMenu").bind("contextmenu", function (event) {
        clearInterval(Times);
        //debugger;
        var oEvent = event;
        var menu = "";
        //var thisClassName = $(this).prop("className"); attachMenuS expTR
        if ($(this).hasClass("entryTR")) {
            menu = document.getElementById("entryMenu");
        } else if ($(this).hasClass("noteTR")) {
            menu = document.getElementById("noteMenu");
        } else if ($(this).hasClass("atachTR")) {
            menu = document.getElementById("attachMenu");
        } else if ($(this).hasClass("expTR")) {
            menu = document.getElementById("expMenu");
        }

        entityid = $(this).data("val");
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
            menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
        } else {
            menu.style.left = Left + "px";
        }
        if (winHeight < clientHeight && bottomHeight < menuHeight) {
            menu.style.top = winHeight - menuHeight - 18 - 25 + scrTop + "px";
        } else {
            menu.style.top = Top - 25 + "px";
        }
        document.onclick = function () {
            menu.style.display = "none";
        }
        return false;
    });

</script>
<script>
    function ChangeBookMark() {
        //$("#bookmark").removeAttr("click");
        var url = '<%=Request.Url.LocalPath %>?id=<%=thisTask?.id %>';
         var title = '查看任务:<%=thisProject?.name %>:<%=thisTask?.title %>';
        var isBook = $("#bookmark").hasClass("Selected");
        $.ajax({
            type: "GET",
            url: "../Tools/IndexAjax.ashx?act=BookMarkManage&url=" + url + "&title=" + title,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    if (isBook) {
                        $("#bookmark").removeClass("Selected");
                    } else {
                        $("#bookmark").addClass("Selected");
                    }
                }
            }
        })
    }

    function OpenProject() {
        window.open("ProjectView.aspx?id=<%=thisProject.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_VIEW %>', 'left=200,top=200,width=600,height=800', false);
    }
    function OpenAccount() {
        window.open("../Company/ViewCompany.aspx?id=<%=thisAccount.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>', 'left=200,top=200,width=600,height=800', false);
    }
    function OpenContract() {
        <% if (thisContract != null)
    {%>
        window.open("../Contract/ContractView.aspx?id=<%=thisContract.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>', 'left=200,top=200,width=600,height=800', false);
        <%}%>
    }
    function EditTask() {
        window.open("TaskAddOrEdit.aspx?id=<%=thisTask.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKEDIT %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 改变第一个表格的排序方式
    function ChangeOrderTVB(order) {
        var pageTvbOrder = $("#pageTvbOrder").val();
        if (pageTvbOrder == "") {
            order = order + "_asc";
        }
        else {
            var orderArr = pageTvbOrder.split("_");
            if (orderArr[0] == order) {
                if (orderArr[1] == "asc") {
                    order = order + "_desc";
                } else {
                    order = order + "_asc";
                }
            } else {
                order = order + "_asc";
            }
        }
        location.href = "TaskView?id=<%=thisTask.id %>&tvbOrder=" + order +"&expOrder=<%=expOrder %>&serOrder=<%=serOrder %>";
    }
    // 改变第二个表格（费用）的排序方式
    function ChangeOrderExp(order) {
        var pageExpOrder = $("#pageExpOrder").val();
        if (pageExpOrder == "") {
            order = order + ",asc";
        }
        else {
            var orderArr = pageExpOrder.split(",");
            if (orderArr[0] == order) {
                if (orderArr[1] == "asc") {
                    order = order + ",desc";
                } else {
                    order = order + ",asc";
                }
            } else {
                order = order + ",asc";
            }
        }
        location.href = "TaskView?id=<%=thisTask.id %>&expOrder=" + order +"&tvbOrder=<%=tvbOrder %>&serOrder=<%=serOrder %>";
    }
    // 控制第一个div tr的显示
    function ShowTvbDetail(val) {
        var display = $('#' + val + '_detail').css('display');
        if (display == 'none') {
            $('#' + val + '_detail').css('display', "");
            $("#" + val + "_img").attr("src", "../Images/MagnifyMinus.png");
        } else {
            $('#' + val + '_detail').css('display', "none");
            $("#" + val + "_img").attr("src", "../Images/MagnifyPlus.png");
        }
    }
    $("#tvbDetail").click(function () {
        if ($(this).is(":checked")) {
            $(".tvbClass").each(function () {
                $(this).show();
                $(this).prev().children().first().children().first().attr("src", "../Images/MagnifyMinus.png");
            })
        } else {
            $(".tvbClass").each(function () {
                $(this).hide();
                $(this).prev().children().first().children().first().attr("src", "../Images/MagnifyPlus.png");
            })
        }
    })
    $("#CkEpDetail").click(function () {
        if ($(this).is(":checked")) {
            $(".expClass").each(function () {
                $(this).show();
                $(this).prev().children().first().children().first().attr("src", "../Images/MagnifyMinus.png");
            })
        } else {
            $(".expClass").each(function () {
                $(this).hide();
                $(this).prev().children().first().children().first().attr("src", "../Images/MagnifyPlus.png");
            })
        }
    })
    //$(".EditExpense").click(function (event) {
    //    event.stopPropagation();
    //})
    // 修改工时和备注
    function EditThis(type, id) {
        if (type == "entry") {
            // 修改工时
            window.open("WorkEntry.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.WORK_ENTRY_EDIT %>', 'left=200,top=200,width=1080,height=800', false);
        } else if (type == "note") {
            // 修改备注
            window.open("TaskNote.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_NOTE_EDIT %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }
    // 新增工时
    function AddEntry() {
        window.open("WorkEntry.aspx?task_id=<%=thisTask.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.WORK_ENTRY_ADD %>', 'left=200,top=200,width=1080,height=800', false);
    }
    // 删除工时
    function DeleteEntry() {
        if (entityid != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=DeleteEntry&entry_id=" + entityid,
                async: false,
                dataType: 'json',
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            LayerMsg("删除成功");
                        } else {
                            LayerMsg("删除失败。" + data.reason);
                        }
                    }
                    history.go(0);
                }
            })
        }
    }
    // 新增备注
    function AddNote() {
        window.open("TaskNote.aspx?task_id=<%=thisTask.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_NOTE_ADD %>', 'left=200,top=200,width=1080,height=800', false);
    }
    function AddAttach() {
        window.open("../Activity/AddAttachment.aspx?objId=<%=thisTask.id %>&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.TASK %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_NOTE_ADD %>', 'left=200,top=200,width=1080,height=800', false);
    }

    function OpenAttach(attId) {
        window.open("../Activity/OpenAttachment.aspx?id=" + attId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=1080,height=800', false);

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
    function DeleteAttach() {
        LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/AttachmentAjax.ashx?act=DeleteAttachment&id=" + entityid,
                async: false,
                dataType: "json",
                success: function (data) {
                    history.go(0);
                }
            })
        }, function () { });
    }
    // 新增费用
    function AddExpense() {
        window.open("ExpenseManage.aspx?task_id=<%=thisTask.id %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_ADD %>', 'left=200,top=200,width=1080,height=800', false);
    }
    // 编辑费用
    function EditTaskExp(eid) {
        // 检验是否审批提交  expense_id  CheckExpenEdit
        $.ajax({
            type: "GET",
            url: "../Tools/ProjectAjax.ashx?act=CheckExpenEdit&expense_id=" + eid,
            async: false,
            //dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data == "True") {
                        window.open("ExpenseManage.aspx?id=" + eid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_EDIT %>', 'left=200,top=200,width=1080,height=800', false);
                    } else {
                        LayerMsg("该费用已经审批提交或者该费用报表状态不可以编辑");
                        // return false;
                    }
                }
               //  history.go(0);
            }
        })
      
    }
    function DeleteExp() {
        LayerConfirm("确认要删除吗？", "确认", "取消", function () {
            $.ajax({
                type: "GET",
                url: "../Tools/ProjectAjax.ashx?act=DeleteExpense&exp_id=" + entityid,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.result ) {
                            LayerMsg("删除成功");
                            history.go(0);
                        } else {
                            LayerMsg("删除失败。" + data.reason);
                        }
                    }
                   
                }
            })
        }, function () { });
    }
    $("#CancelButton").click(function () {
        window.close();
    })

    function EditTask() {
        window.open("TaskAddOrEdit.aspx?id=<%=thisTask==null?"":thisTask.id.ToString() %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKEDIT %>', 'left=200,top=200,width=1080,height=800', false);
    }

    function ShowHistory() {
        window.open("TaskHistory.aspx?task_id=<%=thisTask==null?"":thisTask.id.ToString() %>", '_blank', 'left=200,top=200,width=1080,height=800', false);
    }
</script>
