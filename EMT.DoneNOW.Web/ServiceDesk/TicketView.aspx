<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketView.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.TicketView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/Ticket.css" rel="stylesheet" />
    <title>查看工单</title>
    <style>
        .clickBtn {
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            font-size: 12px;
            font-weight: bold;
            line-height: 24px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        .AddNoteIcon {
            background: url(../Images/SmallIcon.png) no-repeat -1px -1px;
            height: 14px;
            width: 14px;
            float: left;
            margin-left: 10px;
            margin-top: 2px;
        }

        .ImgLink {
            background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);
        }

        .TitleBarIcon {
        }
    </style>

</head>
<body>
    <input id="ticket_id" type="hidden" value="<%=thisTicket.id.ToString() %>" />
    <input type="hidden" id="toTicketId" />
    <input type="hidden" id="toTicketIdHidden" />
    <input type="hidden" id="AbsorbTicketIds" />
    <input type="hidden" id="AbsorbTicketIdsHidden" />
    <!--标记为事故并关联其他工单使用 -->
    <input type="hidden" id="RelationId" />
    <input type="hidden" id="RelationIdHidden" />
    <!--标记为事故并关联其他变更请求工单使用 -->
    <input type="hidden" id="RequestServiceId" />
    <input type="hidden" id="RequestServiceIdHidden" />
    <!--关联其他问题工单使用 -->
    <input type="hidden" id="ProblemId" />
    <input type="hidden" id="ProblemIdHidden" />
    <!--事故清单 关联使用 -->
    <input type="hidden" id="IncidentsId" />
    <input type="hidden" id="IncidentsIdHidden" />
    <!--审批页面 员工的查找带回使用 -->
    <input type="hidden" id="OtherResId" />
    <input type="hidden" id="OtherResIdHidden" />
    <!-- 上方 标题 按钮等 -->
    <div class="PageHeadingContainer" style="z-index: 2;">
        <div class="HeaderRow">
            <table>
                <tbody>
                    <tr>
                        <td><span>工单-<%=thisTicket.no %> - <%=thisTicket.title %><%=$"({thisAccount.name})" %></span></td>

                        <%if (pageTicketList != null && pageTicketList.Count > 0)
                            {
                                var pageTicket = pageTicketList.FirstOrDefault(_ => _.id == thisTicket.id);
                                var thisIndex = pageTicketList.IndexOf(pageTicket);
                        %>
                        <td>
                            <div class="TitleBarItem TitleBarToolbar" style="float: right;">
                                <div class="TitleBarButton NavigateLeft NormalState" style="margin-top: 9px; margin-left: -19px;" onclick="ViewTicket('<%=thisIndex != 0 ? pageTicketList[thisIndex - 1].id : pageTicketList[pageTicketList.Count - 1].id %>')">
                                    <div class="TitleBarIcon NavigateLeft"></div>
                                </div>
                                <span class="Text" style="width: 53px; max-width: 66px;"><%=thisIndex + 1 %> of <%=pageTicketList.Count %></span>
                                <div class="TitleBarButton NavigateRight NormalState" style="margin-top: -16px; margin-left: 53px;" onclick="ViewTicket('<%=thisIndex != (pageTicketList.Count - 1) ? pageTicketList[thisIndex + 1].id : pageTicketList[0].id %>')">
                                    <div class="TitleBarIcon NavigateRight"></div>
                                </div>
                            </div>
                        </td>
                        <%} %>
                        <td align="right" class="helpLink"><a class="HelperLinkIcon" title=""></a></td>
                        <!--todo 上一工单，下一工单的显示 跳转 --->
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="ButtonBar">
            <ul>
                <li style="margin-left: 14px;">
                    <a class="ImgLink" onclick="EditTicket()" style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -23px 1px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">修改</span>
                    </a>
                </li>

                <li>
                    <a class="ImgLink" onclick="<%=thisTicket.owner_resource_id == null ? "AcceptTicket()" : "" %>" style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -86px -144px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px; <%=thisTicket.owner_resource_id!=null?"color: rgba(95,95,95,0.4);": "" %>">接受</span>
                    </a>
                </li>

                <li>
                    <a class="ImgLink" onclick="" style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -277px 0px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">转发</span>
                    </a>
                </li>

                <li id="ToolLi">
                    <a class="ImgLink" onclick="" style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -198px -144px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">工具</span>

                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -182px -48px; width: 15px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                    </a>
                </li>
                <li class="DropDownButton" style="top: 72px; left: 214px; display: none;" id="Down2">
                    <div class="DropDownButtonDiv">
                        <div class="Group">
                            <div class="Content">
                                <div class="Button1" id="CopyButton" tabindex="0" onclick="CopyTicket()">
                                    <span class="Icon"></span>
                                    <span class="Text">复制</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="<%=thisTicket.parent_id == null ? "MergeOtherTicketCallBack()" : "" %>">
                                    <span class="Icon"></span>
                                    <span class="Text">合并到其他工单</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="AbsorbCallBack()">
                                    <span class="Icon"></span>
                                    <span class="Text">吸收合并其他工单</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">复制到项目</span>
                                </div>
                                <%--<div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Text">发送问卷</span>
                                </div> ViewButton--%>
                                <div class="Button1" id="" tabindex="0" onclick="DisRelationProject()">
                                    <span class="Icon"></span>
                                    <span class="Text">取消与项目的关联关系</span>
                                </div>
                                <% if (thisTicket.ticket_type_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.CHANGE_REQUEST)
                                    { %>
                                <% if (thisTicket.ticket_type_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM)
                                    { %>
                                <div class="Button1" id="" tabindex="0" onclick="SignAsIssue()">
                                    <span class="Icon"></span>
                                    <span class="Text">标记为问题</span>
                                </div>
                                <%} %>
                                <div class="Button1" id="" tabindex="0" onclick="SignAsIncident()">
                                    <span class="Icon"></span>
                                    <span class="Text"><% if (thisTicket.ticket_type_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.INCIDENT)
                                                           {%>标记为<%} %>事故并关联其他工单</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="SignInclidentNewIssueOpen()">
                                    <span class="Icon"></span>
                                    <span class="Text"><% if (thisTicket.ticket_type_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.INCIDENT)
                                                           {%>标记为<%} %>事故并关联新的问题</span>
                                </div>
                                <% if (thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.SERVICE_REQUEST)
                                    { %>
                                <div class="Button1" id="" tabindex="0" onclick="RelaRequests()">
                                    <span class="Icon"></span>
                                    <span class="Text">标记为事故并关联其他变更申请单</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="SignInclidentNewRequestOpen()">
                                    <span class="Icon"></span>
                                    <span class="Text">标记为事故并关联新的变更申请单</span>
                                </div>
                                <%} %>
                                <%} %>
                                <div class="Button1" id="" tabindex="0" onclick="ProcessInvoice()">
                                    <span class="Icon"></span>
                                    <span class="Text">生成发票</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">查看报表</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="ShowTicketHistory()">
                                    <span class="Icon"></span>
                                    <span class="Text">工单历史</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="">
                                    <span class="Icon"></span>
                                    <span class="Text">客户服务详情</span>
                                </div>
                                <div class="Button1" id="" tabindex="0" onclick="DeleteTicket()">
                                    <span class="Icon"></span>
                                    <span class="Text">删除</span>
                                </div>

                            </div>
                        </div>


                    </div>
                </li>

                <li>
                    <a class="ImgLink" onclick="CompleteEntry()" style="background: linear-gradient(to bottom,#fff 0,#fdfdfd 100%);">
                        <span class="icon" style="background: url(../Images/Icons.png) no-repeat -6px -64px; width: 16px; height: 16px; display: inline-block; margin: -2px 3px; margin-top: 3px;"></span>
                        <span class="Text" style="line-height: 24px;">完成</span>
                    </a>
                </li>
            </ul>
        </div>
    </div>

    <!-- 下左 快捷添加相应操作（编辑 查看会触发相应事件） -->
    <div class="QuickLaunchBar" style="top: 82px;">
        <div class="QuickLaunchButton TimeEntry DisabledState" id="" onclick="AddTimeEntry()">
            <div class="Text">工时<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -15px;"></div>
        </div>
        <div class="QuickLaunchButton Note DisabledState" onclick="AddTicketNote('')">
            <div class="Text">备注<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -64px;"></div>
        </div>
        <div class="QuickLaunchButton Attachment DisabledState" onclick="AddTicketAttachment()">
            <div class="Text">附件<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -113px;"></div>
        </div>
        <div class="QuickLaunchButton Charge DisabledState" onclick="AddTicketCharge()">
            <div class="Text">成本<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -163px;"></div>
        </div>
        <div class="QuickLaunchButton Expense DisabledState" onclick="AddTicketExpense()">
            <div class="Text">费用<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -212px;"></div>
        </div>
        <div class="QuickLaunchButton ServiceCall DisabledState">
            <div class="Text">服务<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -260px;"></div>
        </div>
        <div class="QuickLaunchButton ToDo DisabledState" onclick="AddTicketTodo()">
            <div class="Text">待办<span class="KeyCode"></span></div>
            <div class="Icon" style="background: url(../Images/TicketIcon.png) no-repeat -14px -309px;"></div>
        </div>
    </div>

    <div class="MessageBarContainer" style="margin-left: 45px; margin-top: 66px;">
        <div class="MessageBar Alert" id="AccountAlert">
            <div class="IconContainer">
                <div class="MessageBarIcon Alert" style="background-position: -1px -1px;"></div>
            </div>
            <% var alert = new EMT.DoneNOW.DAL.crm_account_alert_dal().FindAlert(thisAccount.id, EMT.DoneNOW.DTO.DicEnum.ACCOUNT_ALERT_TYPE.COMPANY_DETAIL_ALERT);%>
            <div class="Content FormatPreservation Left"><%=alert == null ? "" : alert.alert_text %></div>
        </div>
    </div>

    <div class="MainContainer InsightsEnabled" style="margin-left: 45px;">
        <div class="SecondaryContainer Left Active" id="">
            <div class="TabButtonContainer">
                <div>
                    <div class="TabButton EntityPageTabIcon Details Active">
                        <div class="Icon"></div>
                        <div class="Text">Details</div>
                    </div>
                </div>
                <div>
                    <div class="TabButton EntityPageTabIcon Insights">
                        <div class="Icon"></div>
                        <div class="Text">Insights</div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection">
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label" onclick="">客户</span></div>
                        <div class="Value"><a class="Button ButtonIcon Link NormalState" tabindex="0" onclick="OpenAccount('<%=thisAccount == null ? "" : thisAccount.id.ToString() %>')"><%=thisAccount == null ? "" : thisAccount.name %></a></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">联系人</span></div>
                        <div class="Value">
                            <a class="Button ButtonIcon Link NormalState" style="float: left;" tabindex="0" onclick="OpenContact('<%=thisContact == null ? "" : thisContact.id.ToString() %>')"><%=thisContact == null ? "" : thisContact.name %></a><div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon" onclick="AddTicketNote('ckContact')"></div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">状态</span></div>
                        <div class="Value">
                            <div class="ColorBand ColorSwatch Color34">
                                <div class="Left ColorSample">
                                    <div class="TicketStatusIcon General"></div>
                                </div>
                                <div class="Right">
                                    <div class="BackgroundPatch ColorSample"></div>
                                    <% var ticketStatu = ticStaList.FirstOrDefault(_ => _.id == thisTicket.status_id); %>
                                    <div class="Text ColorSample"><%=ticketStatu == null ? "" : ticketStatu.name %></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label" id="z6bf29468ce3e490c94294ea8fc13ee02" onclick="">优先级</span></div>
                        <div class="Value">
                            <div class="ColorBand ColorSwatch Color9">
                                <div class="Left ColorSample">
                                    <div class="PriorityIcon General"></div>
                                </div>
                                <div class="Right">
                                    <div class="BackgroundPatch ColorSample"></div>
                                    <div class="Text ColorSample">
                                        <% if (thisTicket.priority != null)
                                            {
                                                var ticketPrior = priorityList.FirstOrDefault(_ => _.id == thisTicket.priority); %><%=ticketPrior == null ? "" : ticketPrior.name %> <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection" id="z5855ad44526e4f5f847e31f3eb891274">
                <div class="Title Title1">
                    <div class="Text">工单信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">问题类型</span></div>
                        <div class="Value">
                            <% if (thisTicket.issue_type_id != null)
                                {
                                    var ticketIssue = issueTypeList.FirstOrDefault(_ => _.id == thisTicket.issue_type_id); %><%=ticketIssue == null ? "" : ticketIssue.name %> <%}%>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">子问题类型</span></div>
                        <div class="Value">
                            <% if (thisTicket.sub_issue_type_id != null)
                                {
                                    var ticketSubIssue = issueTypeList.FirstOrDefault(_ => _.id == thisTicket.sub_issue_type_id); %><%=ticketSubIssue == null ? "" : ticketSubIssue.name %> <%}%>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">工单来源</span></div>
                        <div class="Value">
                            <% if (thisTicket.source_type_id != null)
                                {
                                    var ticketSource = issueTypeList.FirstOrDefault(_ => _.id == thisTicket.source_type_id); %><%=ticketSource == null ? "" : ticketSource.name %> <%}%>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">截止日期</span></div>
                        <div class="Value"><%=thisTicket.estimated_end_time != null ? EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.estimated_end_time).ToString("yyyy-MM-dd HH:mm:ss") : "" %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">预估时间</span></div>
                        <div class="Value"><%=thisTicket.estimated_hours.ToString("#0.00") + 'h' %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">服务等级协议</span></div>
                        <div class="Value">
                            <% if (thisTicket.sla_id != null)
                                {
                                    var ticketSla = slaList.FirstOrDefault(_ => _.id == thisTicket.sla_id); %><%=ticketSla == null ? "" : ticketSla.name %> <%}%>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection" id="z9fcc61f1a21d45f885647146cbd64097">
                <div class="Title Title2">
                    <div class="Text">分配信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">队列</span></div>
                        <div class="Value">
                            <div class="ColorBand ColorSwatch Color34">
                                <div class="Left ColorSample">
                                    <div class="ClientPortalVisibilityIcon Visible"></div>
                                </div>
                                <div class="Right">
                                    <div class="BackgroundPatch ColorSample"></div>
                                    <div class="Text ColorSample">
                                        <% if (thisTicket.department_id != null)
                                            {
                                                var ticketDep = depList.FirstOrDefault(_ => _.id == thisTicket.department_id); %><%=ticketDep == null ? "" : ticketDep.name %> <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">主负责人</span></div>
                        <div class="Value">
                            <div class="PrimaryResource">
                                <div class="Left" style="float: left;">
                                    <img src="<%=priRes != null && priRes.avatar != null ? priRes.avatar : "" %>" style="width: 45px;" />
                                </div>
                                <div class="Right">
                                    <div class="Name"><a class="Button ButtonIcon Link NormalState" style="float: left;" tabindex="0"><%=priRes == null ? "" : priRes.name %></a></div>
                                    <div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon" onclick="AddTicketNote('priRes')"></div>
                                    <% EMT.DoneNOW.Core.sys_role ticketRole = null;
                                        if (thisTicket.role_id != null)
                                        {
                                            ticketRole = new EMT.DoneNOW.DAL.sys_role_dal().FindNoDeleteById((long)thisTicket.role_id);
                                        }
                                    %>
                                    <br />
                                    <div class="Support"><span class="Text"><%=ticketRole == null ? "" : $"({ticketRole.name})" %></span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled" style="clear: both;">
                        <div class="LabelContainer">
                            <span class="Label">其他负责人</span><div class="InlineIconButton InlineIcon Note NormalState"></div>
                        </div>
                        <div class="Value">
                            <div class="ExpandableDataContainer">
                                <% if (ticketResList != null && ticketResList.Count > 0)
                                    {
                                        var srDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                        var srolDal = new EMT.DoneNOW.DAL.sys_role_dal();
                                        foreach (var ticketRes in ticketResList)
                                        {
                                            var thisRes = srDal.FindNoDeleteById((long)ticketRes.resource_id);
                                            var thisRole = srolDal.FindNoDeleteById((long)ticketRes.role_id);
                                            if (thisRes != null && thisRole != null)
                                            {
                                %>
                                <div class="SecondaryResource">
                                    <a class="Button ButtonIcon Link NormalState" style="float: left;" tabindex="0"><%=thisRes.name %></a><span class="RoleName" style="float: left;"><%=$"({thisRole.name})" %></span><div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon" onclick="AddTicketNote('otherRes')"></div>
                                </div>
                                <br />
                                <%}
                                        }
                                    } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection" id="z7bbc9c27ae944f6fb150de7254c6e830">
                <div class="Title Title3">
                    <div class="Text">配置项信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">配置项</span></div>
                        <div class="Value">
                            <a class="Button ButtonIcon Link NormalState" tabindex="0" onclick="EditInsPro('<%=insPro == null ? "" : insPro.id.ToString() %>')">
                                <% EMT.DoneNOW.Core.ivt_product thisProduct = null;
                                    if (insPro != null)
                                    {
                                        thisProduct = new EMT.DoneNOW.DAL.ivt_product_dal().FindNoDeleteById(insPro.product_id);
                                    }
                                %>
                                <%=thisProduct == null ? "" : thisProduct.name %> </a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection">
                <div class="Title Title4">
                    <div class="Text">计费信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">合同</span></div>
                        <div class="Value"><a class="Button ButtonIcon Link NormalState" tabindex="0" onclick="ViewContract('<%=thisContract == null ? "" : thisContract.id.ToString() %>')"><%=thisContract == null ? "" : thisContract.name %></a></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">服务/服务包</span></div>
                        <div class="Value"><%=thisService != null ? thisService.name : (thisServiceBun != null ? thisServiceBun.name : "") %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">工作类型</span></div>
                        <div class="Value"><%=thisCostCode == null ? "" : thisCostCode.name %></div>
                    </div>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label">采购订单号</span></div>
                        <div class="Value"><%=thisTicket.purchase_order_no %></div>
                    </div>
                </div>
            </div>
            <div class="DetailsSection Collapsed">
                <div class="Title Title5">
                    <div class="Text">自定义信息</div>
                    <div class="Toggle">
                        <div class="InlineIcon ArrowUp"></div>
                    </div>
                </div>
                <div class="Content">
                    <% if (tickUdfList != null && tickUdfList.Count > 0)
                        {
                            foreach (var tickUdf in tickUdfList)
                            {
                    %>
                    <div class="ReadOnlyData QuickEditEnabled">
                        <div class="LabelContainer"><span class="Label"><%=tickUdf.col_name %></span></div>
                        <div class="Value">
                            <%
                                EMT.DoneNOW.DTO.UserDefinedFieldValue thisValue = null;
                                if (ticketUdfValueList != null && ticketUdfValueList.Count > 0)
                                {
                                    thisValue = ticketUdfValueList.FirstOrDefault(_ => _.id == tickUdf.id);
                                }
                                if (tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT || tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT || tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)
                                { %>
                            <%=thisValue == null ? "" : thisValue.value.ToString() %>
                            <%}
                                else if (tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)
                                { %>
                            <%=thisValue == null ? "" : ((DateTime)thisValue.value).ToString("yyyy-MM-dd") %>
                            <%}
                                else if (tickUdf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)
                                {
                                    if (tickUdf.value_list != null && tickUdf.value_list.Count > 0 && thisValue != null && !string.IsNullOrEmpty(thisValue.ToString()))
                                    {
                                        var selectValue = tickUdf.value_list.FirstOrDefault(_ => _.val == thisValue.ToString());
                            %>
                            <%=selectValue == null ? "" : selectValue.show %>
                            <%
                                    }
                                } %>
                        </div>
                    </div>
                    <%
                            }
                        } %>
                </div>
            </div>
        </div>
        <div class="PrimaryContainer">
            <div>
                <div class="HeadingContainer" style="padding: 15px;">
                    <div class="IdentificationContainer ReadOnly">
                        <div class="Left" style="float: left;">
                            <div class="CategoryName ColorSwatch Color19 ColorSample">
                                <% if (thisTicket.cate_id != null)
                                    {
                                        var ticketCate = ticketCateList.FirstOrDefault(_ => _.id == thisTicket.cate_id); %><%=ticketCate == null ? "" : ticketCate.name %> <%}%>
                            </div>
                            <div class="TypeName">
                                <% if (thisTicket.ticket_type_id != null)
                                    {
                                        var ticketType = ticketTypeList.FirstOrDefault(_ => _.id == thisTicket.ticket_type_id); %><%=ticketType == null ? "" : ticketType.name %> <%}%>
                            </div>
                            <div class="IdentificationTextContainer">
                                <div class="IdentificationText"><%=thisTicket.no %></div>
                                <div class="CopyTextButton ButtonIcon CopyToClipboard NormalState CopyText">
                                    <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -22px -145px;"></div>
                                    <div class="SourceText"><%=thisTicket.no %></div>
                                </div>
                                <div class="CopyTextButton ButtonIcon CopyLinkToClipboard NormalState">
                                    <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -6px -145px;"></div>
                                    <div class="SourceText">
                                        <!--需要复制的链接 -->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="Right" style="padding-top: 20px; margin-right: 10px;">
                            <div class="StopwatchContainer">
                                <div class="StopwatchTime"><span id="ShowWatchTime">00:00:00</span></div>
                                <div class="StopwatchButton StopwatchIcon Normal noplay Pause" id="PlayTimeDiv"></div>
                                <div class="StopwatchButton StopwatchIcon Normal Record" onclick="AddTimeEntry()" style="background: url(../Images/play.png) no-repeat -66px -1px;"></div>
                                <div class="StopwatchButton StopwatchIcon Normal Stop" onclick="Reset()" style="background: url(../Images/play.png) no-repeat -101px -1px;"></div>
                            </div>
                        </div>
                    </div>
                    <div class="Title">
                        <div class="Text"><%=thisTicket.title %></div>
                        <div class="CopyTextButton ButtonIcon CopyToClipboard NormalState" id="zc9d87df7327f4372b4b2fb9cf512f940" title="Copy “ticket number – ticket title” to clipboard">
                            <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -22px -145px;"></div>
                            <div class="SourceText"><%=thisTicket.no %>-<%=thisTicket.title %></div>
                        </div>
                    </div>
                    <div class="Bundle" style="display: flex;">
                        <div>
                            <div class="Text Label">创建时间：</div>
                        </div>
                        <div>
                            <div class="Text"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisTicket.create_time).ToString("yyyy-MM-dd") %> <%=GetDiffDate(EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisTicket.create_time), DateTime.Now) %></div>
                        </div>
                        <div>
                            <div class="Text">-</div>
                        </div>
                        <div>
                            <div class="Text"><%=createRes == null ? "" : createRes.name %></div>
                        </div>
                        <div>
                            <div class="EntityHeadingIconButton">
                                <div class="InlineIconButton InlineIcon Note NormalState AddNoteIcon"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="Divider">
                    <div class="Line"></div>
                </div>
                <div class="BodyContainer">
                    <div class="Normal Section" id="z322039fc73d54e369d92b9bab8ea4bcf">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle1">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">描述</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="EntityBodyEnhancedText"><span class="Content"><%=thisTicket.description %></span></div>
                        </div>
                    </div>
                    <div class="Normal Section Timeline">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle2">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">时间轴</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="Timeline">
                                <div class="Bar Top VerticalSize3">
                                    <%if (thisTicket.first_activity_time != null)
                                        { %>
                                    <div class="Dot" style="left: calc(0% - 6px);">
                                        <div class="Pole VerticalSize3">
                                            <div class="Flag TargetAchieved Normal" id="z79439d23ded94c029599a3d7dd28627f">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">初次响应</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer">
                                        <div class="TimelineContextOverlay ContextOverlay" style="left: calc(0% - 6px); top: -103px; position: absolute;">
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet" style="background-position: -101px -1px;"></div>
                                                    <div class="Text Achieved">初次响应</div>
                                                </div>
                                                <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.first_activity_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>
                                    <%if (thisTicket.resolution_plan_actual_time != null)
                                        { %>
                                    <div class="Dot" style="left: calc(79% - 6px);">
                                        <div class="Pole VerticalSize2">
                                            <div class="Flag TargetAchieved Reverse" id="z084300357f8a4995a1d13e2ae0a6220b">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">解决方案提供时间</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z7efe3f18ca5b4d3c83ca253200492b48">
                                        <div class="TimelineContextOverlay ContextOverlay" style="left: calc(79% - 6px); top: -65px; position: absolute;">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet"></div>
                                                    <div class="Text Achieved">解决方案提供时间</div>
                                                </div>
                                                <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.resolution_plan_actual_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>
                                    <%if (thisTicket.resolution_actual_time != null)
                                        { %>
                                    <div class="Dot" style="left: calc(79% - 6px);">
                                        <div class="Pole VerticalSize1">
                                            <div class="Flag TargetAchieved Reverse">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">解决时间</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer">
                                        <div class="TimelineContextOverlay ContextOverlay" style="left: calc(79% - 6px); top: -65px; position: absolute;">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet"></div>
                                                    <div class="Text Achieved">解决时间</div>
                                                </div>
                                                <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.resolution_actual_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>

                                    <%if (thisTicket.date_completed != null)
                                        { %>
                                    <div class="Dot" style="left: calc(79% - 6px);">
                                        <div class="Pole VerticalSize0">
                                            <div class="Flag TargetAchieved Reverse">
                                                <div class="Banner">
                                                    <div class="Triangle"></div>
                                                </div>
                                                <div class="Text">完成时间</div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="ContextOverlayContainer">
                                        <div class="TimelineContextOverlay ContextOverlay" style="left: calc(79% - 6px); top: -65px; position: absolute;">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label">
                                                    <div class="TimelineIcon OverlayEventMet"></div>
                                                    <div class="Text Achieved">完成时间</div>
                                                </div>
                                                <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTicket.date_completed).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>

                                    <div class="OccurrenceProgress" style="width: 79%;"></div>
                                    <div class="SlaBarIndicator" style="width: 0%;"></div>
                                </div>
                                <div class="Divider"></div>
                                <%if (slaDic != null && slaDic.Count > 0)
                                    {
                                        var slaFirstResponse = slaDic.FirstOrDefault(_ => _.Key == "响应时间");
                                        var slaComplete = slaDic.FirstOrDefault(_ => _.Key == "完成时间");
                                        var resolution = slaDic.FirstOrDefault(_ => _.Key == "解决时间");
                                        var resolutionPlan = slaDic.FirstOrDefault(_ => _.Key == "解决方案提供时间");
                                %>
                                <div class="Bar Bottom">
                                    <%if (!default(KeyValuePair<string, object>).Equals(slaFirstResponse))
                                        { %>
                                    <div class="TimelineIcon TargetPointer" style="left: calc(81% - 3px);">
                                        <div class="TimelineIcon Target" id="z85414a86487245f1b11077ad0e2efce0"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="zf27d5431cf07427691d3372edca92c29">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label" style="margin-left: 20px;">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved"><%=slaFirstResponse.Key %></div>
                                                </div>
                                                <div class="DateTime"><%=slaFirstResponse.Value.ToString() %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>
                                    <%if (!default(KeyValuePair<string, object>).Equals(resolutionPlan))
                                        { %>
                                    <div class="TimelineIcon TargetPointer" style="left: calc(89% - 3px);">
                                        <div class="TimelineIcon Target" id="z554f2ecf460e4b6797ee7b5b38bebf80"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z18fc40437a9e4a3cad5bc80e461c37f8">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label" style="margin-left: 20px;">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved"><%=resolutionPlan.Key %></div>
                                                </div>
                                                <div class="DateTime"><%=resolutionPlan.Value.ToString() %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>
                                    <%if (!default(KeyValuePair<string, object>).Equals(resolution))
                                        { %>
                                    <div class="TimelineIcon TargetPointer" style="left: calc(98% - 3px);">
                                        <div class="TimelineIcon Target" id="z1c4c3ca136d0466c8582986c7eb839a5"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="z22fcaf4e90e24ddab5975b2bee67ea0f">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label" style="margin-left: 20px;">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved"><%=resolution.Key %></div>
                                                </div>
                                                <div class="DateTime"><%=resolution.Value.ToString() %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>
                                    <%if (!default(KeyValuePair<string, object>).Equals(slaComplete))
                                        { %>
                                    <div class="TimelineIcon TargetPointer" style="left: calc(100% - 3px);">
                                        <div class="TimelineIcon Target" id="z4b018c06499842449f9c2f0a5cdbb24b"></div>
                                    </div>
                                    <div class="ContextOverlayContainer" id="zf8d2cfcad1fd4700817f7fd7fedebb41">
                                        <div class="TimelineContextOverlay ContextOverlay">
                                            <div class="Outline Arrow"></div>
                                            <div class="Arrow"></div>
                                            <div class="Content">
                                                <div class="Label" style="margin-left: 20px;">
                                                    <div class="TimelineIcon OverlayTargetMet"></div>
                                                    <div class="Text Achieved"><%=slaComplete.Key %></div>
                                                </div>
                                                <div class="DateTime"><%=slaComplete.Value.ToString() %></div>
                                            </div>
                                        </div>
                                    </div>
                                    <%} %>
                                    <div class="TargetProgress" style="width: 100%;"></div>
                                </div>
                                <%} %>
                                <div class="TicketSlaTimelineStart">
                                    <div class="TimelineIcon SlaStartLabel" style="background-position: -166px -1px; height: 15px; width: 15px;"></div>
                                </div>
                                <div class="ContextOverlayContainer">
                                    <div class="TimelineContextOverlay ContextOverlay">
                                        <div class="Outline Arrow"></div>
                                        <div class="Arrow"></div>
                                        <div class="Content">
                                            <div class="Label">
                                                <div class="TimelineIcon OverlayTicketStart" style=""></div>
                                                <div class="Text Normal">工单创建</div>
                                            </div>
                                            <% if (thisTicket.sla_start_time != null && thisTicket.sla_start_time == thisTicket.create_time)
                                                { %>
                                            <div class="Label">
                                                <div class="TimelineIcon OverlaySla"></div>
                                                <div class="Text OverlaySla">SLA Start</div>
                                            </div>
                                            <%} %>
                                            <div class="DateTime"><%=EMT.Tools.Date.DateHelper.ConvertStringToDateTime(thisTicket.create_time).ToString("yyyy-MM-dd HH:mm:ss") %></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Section" id="z73ac32bdeec24f0e9d95588ae8919340">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle3">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">检查单</span></div>
                            <% if (ticketCheckList != null && ticketCheckList.Count > 0)
                                { %>
                            <div class="Middle"><span class="Text ItemCount"><span>(</span><span id="CompletedCount"><%=ticketCheckList.Where(_ => _.is_competed == 1).ToList().Count %></span><span>/<%=ticketCheckList.Count %>)</span></span><a class="Button ButtonIcon Link NormalState" id="CheckMange" onclick="HideItem()" tabindex="0">隐藏完成条目</a></div>
                            <%} %>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <div class="Checklist">
                                <% if (ticketCheckList != null && ticketCheckList.Count > 0)
                                    {
                                        var srDal = new EMT.DoneNOW.DAL.sys_resource_dal();
                                        ticketCheckList = ticketCheckList.OrderBy(_ => _.sort_order).ToList();
                                        foreach (var ticketCheck in ticketCheckList)
                                        {
                                            var thisCreate = srDal.FindNoDeleteById(ticketCheck.create_user_id);
                                %>
                                <div class="ChecklistItem <%=ticketCheck.is_competed == 1 ? "Completed" : "" %>" data-val="<%=ticketCheck.id %>">
                                    <div class="ChecklistIcon CheckBox <%=ticketCheck.is_competed == 1 ? "Checked" : "Empty" %>">
                                        <div class="Icon" tabindex="0"></div>
                                    </div>
                                    <div class="Description"><span class="Title"><%=ticketCheck.item_name %></span><span class="Important"><%=ticketCheck.is_important == 1 ? "!" : "" %></span><span class="CompletedBy"><%=ticketCheck.is_competed == 1 ? EMT.Tools.Date.DateHelper.ConvertStringToDateTime(ticketCheck.create_time).ToString("yyyy-MM-dd") + (thisCreate == null ? "" : thisCreate.name) : "" %></span></div>
                                </div>
                                <%
                                        }
                                    } %>
                                <div class="AllItemsCompleted Hidden"></div>
                            </div>
                        </div>
                    </div>
                    <div class="Normal Section" id="zceee7ec547874037add9b9a8c87c44dd">
                        <div class="Heading" data-toggle-enabled="true">
                            <div class="Toggle Collapse Toggle4">
                                <div class="Vertical"></div>
                                <div class="Horizontal"></div>
                            </div>
                            <div class="Left"><span class="Text">解决方案</span></div>
                            <div class="Middle"></div>
                            <div class="Spacer"></div>
                            <div class="Right"></div>
                        </div>
                        <div class="Content">
                            <% var showResolu = (thisTicket.resolution ?? "").Replace("\r\n", "<br />").Replace("\n", "<br />"); %>
                            <div class="EntityBodyEnhancedText"><span class="Content"><%=showResolu %></span></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="AccessoryTabButtonBar">
                <div class="Button TicketButton SelectedState" id="TicketViewActivityDiv">
                    <div class="Text">活动</div>
                </div>
                <div class="Button TicketButton NormalState" id="TicketViewCostDiv">
                    <div class="Text">成本和费用</div>
                </div>
                <div class="Button TicketButton NormalState" id="TicketViewServiceDiv">
                    <div class="Text">服务预定和待办</div>
                </div>
                <% if (thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM || thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.INCIDENT)
                    { %>
                <div class="Button TicketButton NormalState" id="TicketViewChangeDiv">
                    <div class="Text">变更请求</div>
                </div>
                <%} %>
                <% if (thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM || thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.CHANGE_REQUEST)
                    { %>
                <div class="Button TicketButton NormalState" id="TicketViewIncidentsDiv">
                    <div class="Text">事故</div>
                </div>
                <%} %>
                <% if (thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.CHANGE_REQUEST)
                    { %>
                <div class="Button TicketButton NormalState" id="TicketViewProblemDiv">
                    <div class="Text">问题</div>
                </div>
                <%} %>
                <% if (thisTicket.ticket_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.CHANGE_REQUEST)
                    { %>
                <div class="Button TicketButton NormalState" id="TicketViewApprovalsDiv">
                    <div class="Text">审批</div>
                </div>
                <%} %>
                <div class="Spacer Small"></div>
            </div>
            <div class="TabContainer Active ActivityTabContainer" id="ShowActivityDiv" style="padding-left: 25px;">
                <div class="ActivityTabShell">
                    <div class="LoadingIndicator"></div>
                    <div class="Content">
                        <div class="ToolBar">
                            <div class="ToolBarItem Left ButtonGroupStart"><a class="Button ButtonIcon Time NormalState" tabindex="0" onclick="AddTimeEntry()"><span class="Icon" style="width: 17px; background: url(../Images/Icons.png) no-repeat -310px 0px;"></span><span class="Text">新增工时</span></a></div>
                            <div class="ToolBarItem Left"><a class="Button ButtonIcon Note Navigation NormalState" tabindex="0" onclick="AddTicketNote('')"><span class="Icon" style="width: 17px; background: url(../Images/Icons.png) no-repeat -229px -16px;"></span><span class="Text">新增备注</span></a></div>
                            <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon Attachment Navigation NormalState" tabindex="0" onclick="AddTicketAttachment()"><span class="Icon" style="width: 17px; background: url(../Images/Icons.png) no-repeat -21px -64px;"></span><span class="Text">新增附件</span></a></div>
                            <div class="ButtonGroupDivider"></div>
                            <div class="ToolBarItem Left ButtonGroupStart ButtonGroupEnd LockedWidth" style="margin-left: 15px;"><a class="Button ButtonIcon IconOnly Refresh NormalState" id="" tabindex="0"><span class="Icon" style="width: 17px; height: 17px; background: url(../Images/Icons.png) no-repeat -293px 1px;"></span><span class="Text"></span></a></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="QuickNote Starter">
                            <div class="Avatar" style="float: left;">
                                <div class="Initials ColorSwatch ColorSample Color4">ll</div>
                            </div>
                            <div class="Details" style="float: left;">
                                <div class="Editor TextArea">
                                    <div class="InputField">
                                        <textarea class="Medium" id="Note" name="Note" placeholder="添加一个备注.." style="margin-top: 0px; margin-bottom: 0px; height: 80px; width: 550px;"></textarea>
                                    </div>
                                    <div class="CharacterInformation"><span class="CurrentCount" id="WordNumber">0</span>/<span class="Maximum">2000</span></div>
                                    <input type="hidden" id="isShowSave" value="" />
                                </div>
                                <div class="ButtonBar" style="display: none; width: 560px;">
                                    <div class="Editor SingleSelect">
                                        <div class="InputField">
                                            <select name="NoteTypes" id="NoteTypes" style="float: right;">
                                                <%if (ticketNoteTypeList != null && ticketNoteTypeList.Count > 0)
                                                    {
                                                        foreach (var ticketNoteType in ticketNoteTypeList)
                                                        {
                                                %>
                                                <option value="<%=ticketNoteType.id %>"><%=ticketNoteType.name %></option>
                                                <% }
                                                    } %>
                                            </select>
                                        </div>
                                    </div>
                                    <a class="Button ButtonIcon SuggestiveBackground DisabledState" id="SaveTicketNoteAdd" tabindex="0"><span class="Icon"></span><span class="Text" style="color: white;">保存</span></a><a class="Button ButtonIcon NormalState" id="CancelTicketNoteAdd" tabindex="0"><span class="Icon"></span><span class="Text">取消</span></a>
                                </div>
                                <div class="OptionBar" style="display: none;">
                                    <div class="OptionBarRow">
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="punlishInter" type="checkbox" value="true" name="IsInternal" />
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label>发布对象为内部用户</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="TicketNoteNotiContact" type="checkbox" value="true" name="IsNotifyingContact" />
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label>通知工单联系人<span class="SecondaryText"><%=thisContact == null ? "" : thisContact.name %></span></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="OptionBarRow">
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="TicketNoteNotiPriRes" type="checkbox" value="true" name="IsNotifyingPrimaryResource" />
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label>通知主负责人<span class="SecondaryText"><%=priRes == null ? "" : priRes.name %></span></label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="OptionBarHalf">
                                            <div class="Editor CheckBox">
                                                <div class="InputField">
                                                    <div>
                                                        <input id="TicketNoteNotiInterAll" type="checkbox" value="true" name="IsNotifyingInternalContributors" />
                                                    </div>
                                                    <div class="EditorLabelContainer">
                                                        <div class="Label">
                                                            <label>通知工单内部相关人</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ActivityFilterBar">
                            <div class="FilterBarRow">
                                <div class="FilterBarHalf">
                                    <div class="Editor CheckBox">
                                        <div class="InputField">
                                            <div>
                                                <input id="CkShowSysNote" type="checkbox" value="" name="AreSystemNotesVisible" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label>显示系统备注</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="FilterBarHalf">
                                    <div class="Editor CheckBox">
                                        <div class="InputField">
                                            <div>
                                                <input id="CkShowBillData" type="checkbox" value="" name="IsBillingDataVisible" />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label>显示计费信息</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="ActivityAdvancedOptions">
                            <a class="Button ButtonIcon Filter" style="padding-top: 3px;" id="filter">
                                <span class="Icon" style="width: 17px; background: url(../Images/Icons.png) no-repeat -166px -32px; height: 17px;"></span>
                                <span class="Text">过滤器</span>
                            </a>
                            <div style="display: none; width: 220px; position: absolute; background-color: #fff; border: 1px solid #dee0e7; margin-top: -1px; padding-left: 10px; padding-top: 10px; padding-bottom: 10px;" id="FilterDiv">
                                <div class="">
                                    <div class="Content">
                                        <div class="Group" style="float: left; min-width: 100px;">
                                            <div class="Heading">
                                                <div class="Text" style="font-weight: bold;">发布对象</div>
                                            </div>
                                            <div class="Content">
                                                <div class="Button1" tabindex="0">
                                                    <input type="checkbox" id="CkPublic" />
                                                    <span class="Text">全部用户<span class="TicketItemCount" id="pubUser"></span></span>
                                                </div>
                                                <div class="Button1" tabindex="0">
                                                    <input type="checkbox" id="CkInter" />
                                                    <span class="Text">内部用户<span class="TicketItemCount" id="intUser"></span></span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="Group" style="float: left; min-width: 100px;">
                                            <div class="Heading">
                                                <div class="Text" style="font-weight: bold;">负责人</div>
                                            </div>
                                            <div class="Content">
                                                <div class="Button1" tabindex="0">
                                                    <input type="checkbox" id="CkMe" />
                                                    <span class="Text">我<span class="TicketItemCount" id="ItemMe"></span></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Group" style="clear: both; float: left; min-width: 100px;">
                                            <div class="Heading">
                                                <div class="Text" style="font-weight: bold;">对象类型</div>
                                            </div>
                                            <div class="Content">
                                                <div class="Button1" tabindex="0">
                                                    <input type="checkbox" id="CkLabour" />
                                                    <span class="Text">工时<span class="TicketItemCount" id="ItemLabour"></span></span>
                                                </div>
                                                <div class="Button1" tabindex="0">
                                                    <input type="checkbox" id="CkNote" />
                                                    <span class="Text">备注<span class="TicketItemCount" id="ItemNote"></span></span>
                                                </div>
                                                <div class="Button1" tabindex="0">
                                                    <input type="checkbox" id="CkAtt" />
                                                    <span class="Text">附件<span class="TicketItemCount" id="ItemAtt"></span></span>
                                                </div>
                                            </div>
                                        </div>
                                        <div style="clear: both;">
                                            <input type="button" onclick="ApplyFilter('1')" style="color: white; background-color: #3872b2; width: 110px; height: 20px;" value="应用过滤器" />
                                            <input type="hidden" id="isAppFilter" value="" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <a class="Button ButtonIcon IconOnly Cancel DisabledState" tabindex="0" title="清除过滤器" style="width: 20px; height: 27px; top: 0px;" onclick="ApplyFilter('0')">
                                <span class="Icon" style="width: 15px; background: url(../Images/Icons.png) no-repeat -102px 3px; height: 19px; display: block;"></span>
                                <span class="Text"></span>
                            </a>
                            <input id="ActivitySeachText" type="text" value="" placeholder="查询..." style="/*width: 180px; */width: 50%;" />
                            <select id="orderBy" style="width: 180px; float: right; margin-right: 25px;">
                                <option value="Old">修改时间倒序</option>
                                <option value="New">修改时间升序</option>
                                <%-- <option value="NFE" title="根据本身以及所有子对象的修改时间排序" selected="selected">修改时间（子对象）倒序</option>--%>
                            </select>
                        </div>
                        <div id="ShowTicketActivity">
                        </div>
                    </div>
                </div>
            </div>
            <div class="TabContainer AccessoryTabContainer" id="ShowIframeDiv">
                <div class="AccessoryTabShell">
                    <div class="LoadingIndicator"></div>
                    <div class="TransitionContainer"></div>
                    <div class="Content" id="">
                        <iframe src="" id="TicketShowIframe" style="height: 360px; width: 100%; border-width: 0px;"></iframe>
                    </div>
                </div>
            </div>
            <div class="TabContainer AccessoryTabContainer" id="ShowApprovalDiv" style="display: none;">
                <div class="AccessoryTabShell">
                    <div class="LoadingIndicator"></div>
                    <div class="TransitionContainer"></div>
                    <input type="hidden" id="is_add_other" value="<%=ticketOther != null ? "" : "1" %>"/>
                    <div class="Content" id="" style="padding-left: 18px;padding-top: 10px;">
                        <div class="ToolBar">
                            <div class="ToolBarItem Left ButtonGroupStart" style="margin-left:0px;"><a class="Button ButtonIcon Save " id="" onclick="SaveTicketOther()"><span class="Icon"></span><span class="Text">保存</span></a></div>
                            <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon Cancel " id="" onclick="CancelTicketOther()"><span class="Icon"></span><span class="Text">取消</span></a></div>
                            <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon " id="" onclick="OtherResCallBack()"><span class="Icon"></span><span class="Text">添加</span></a></div>
                            <% if (ticketOther != null)
                                {  %>
                                  <%if (ticketOther.approve_status_id == (int)EMT.DoneNOW.DTO.DicEnum.CHANGE_APPROVE_STATUS.ASSIGNED)
                                      {  %>
                                   <div class="ToolBarItem Left ButtonGroupEnd"><a class="Button ButtonIcon " id="" onclick="AppOther()"><span class="Icon"></span><span    class="Text">审批</span></a></div>
                                  <%} %>
                            <%if (ticketOther.approve_status_id != (int)EMT.DoneNOW.DTO.DicEnum.CHANGE_APPROVE_STATUS.ASSIGNED && ticketOther.approve_status_id != (int)EMT.DoneNOW.DTO.DicEnum.CHANGE_APPROVE_STATUS.NOT_ASSIGNED)
                                {  %>
                                   <div class="ToolBarItem Left ButtonGroupEnd" style="width:50px;"><a class="Button ButtonIcon " id="" onclick="RevokeAppOther()"><span class="Icon"></span><span class="Text">撤销审批</span></a></div>
                                  <%} %>
                            
                            <%} %>
                            <div class="Spacer"></div>
                           <%-- <div class="ToolBarItem Right">
                                <div class="ApprovalStatus NotAssigned">Not Assigned</div>
                            </div>--%>
                        </div>
                        <div class="AccessoryTabColumnBlock Double">
                            <div class="Column">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label>变更委员会</label>
                                    </div>
                                </div>
                                <div class="Editor SingleSelect">
                                    <div class="InputField">
                                        <select id="bord_id" name="ChangeAdvisoryBoard">
                                            <option value="" title=""></option>
                                            <%if (changeList != null && changeList.Count > 0)
                                                {
                                                    foreach (var change in changeList)
                                                    {%>
                                            <option value="<%=change.id %>" <%=ticketOther != null && ticketOther.change_board_id == change.id ? "selected='selected'" : "" %><%=change.name %></option>
                                            <%}
                                                } %>
                                        </select>
                                    </div>
                                </div>
                                <div class="RadioButtonGroupContainer">
                                    <div class="RadioButtonGroupLabel">
                                        <div></div>
                                        <div class="Description">审批通过原则</div>
                                    </div>
                                    <div class="Editor RadioButton">
                                        <div class="InputField">
                                            <div>
                                                <input id="AllPass" type="radio" value="" name="ApprovalType" <%if (ticketOther == null || ticketOther.approval_type_id == (int)EMT.DoneNOW.DTO.DicEnum.APPROVAL_TYPE.ALL_APPROVERS_MUST_APPROVE){ %> checked="checked" <%} %>/>
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label>全部通过</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Editor RadioButton">
                                        <div class="InputField">
                                            <div>
                                                <input id="OtherOnePass" type="radio" value="Oneapprovermustapprove" name="ApprovalType" <%if (ticketOther != null && ticketOther.approval_type_id == (int)EMT.DoneNOW.DTO.DicEnum.APPROVAL_TYPE.ONE_APPROVER_MUST_APPROVE){ %> checked="checked" <%} %> />
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label>任意一个通过</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="">
                                <div class="Grid Small" id="ApprovalsTabGrid">
                                    <div class="HeaderContainer">
                                        <table cellpadding="0">
                                            <tbody>
                                                <tr class="HeadingRow">
                                                    <td style="width: 21px;max-width: 21px;">

                                                    </td>
                                                    <td class="Image" style="width:50px;">
                                                        <div class="Standard">
                                                            <div></div>
                                                        </div>
                                                    </td>
                                                    <td class="Normal Text">
                                                        <div class="Standard">
                                                            <div class="Heading">成员</div>
                                                        </div>
                                                    </td>
                                                    <td class="Image" style="width: 21px;max-width: 21px;">
                                                        <div class="Standard">
                                                            <div class="Check ButtonIcon">
                                                                <div class="Icon"></div>
                                                                ✔
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td class=" DateTime">
                                                        <div class="Standard">
                                                            <div class="Heading">审批日期</div>
                                                        </div>
                                                    </td>
                                                    <td class=" Text Dynamic">
                                                        <div class="Standard">
                                                            <div class="Heading">审批说明</div>
                                                        </div>
                                                    </td>
                                                    <td class="ScrollBarSpacer" style="width: 17px;"></td>
                                                </tr>
                                            </tbody>
                                            <tbody id="ticketOtherOldTbody">
                                                    <%if (ticketOtherList != null && ticketOtherList.Count > 0)
                                                        {

                                                            foreach (var ticketOther in ticketOtherList)
                                                            {
                                                                EMT.DoneNOW.Core.crm_contact otherCon = null;
                                                                EMT.DoneNOW.Core.sys_resource otherRes = null;
                                                                if (ticketOther.contact_id != null)
                                                                    otherCon = ccDal.FindNoDeleteById((long)ticketOther.contact_id);
                                                                else if (ticketOther.resource_id != null)
                                                                    otherRes = srDal.FindNoDeleteById((long)ticketOther.resource_id);
                                                                %>
                                                    <tr class="D OldOther" data-val="<%=ticketOther.id %>" id="other_<%=ticketOther.id %>" data-resid="<%=ticketOther.resource_id %>">
                                                        <td>
                                                            <a onclick="RemoveResOther('<%=ticketOther.id %>')"><span class="DeleteIcon"></span></a>
                                                        </td>
                                                        <td class="Avatar  U0">
                                                            <div class="Initials ColorSwatch ColorSample Color5" style="background-color: #f4b900;">ll</div>
                                                        </td>
                                                        <td class="Text Normal U1"><%=otherCon!=null?otherCon.name:(otherRes!=null?otherRes.name:"") %></td>
                                                        <td class=" U2">
                                                            <% if (ticketOther.approve_status_id == (int)EMT.DoneNOW.DTO.DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED)
                                                                { %>
                                                              <a><span class="DeleteIcon" style="background: url(../Images/Icons.png) no-repeat -70px -30px;"></span></a>
                                                            <%}
    else if (ticketOther.approve_status_id == (int)EMT.DoneNOW.DTO.DicEnum.CHANGE_APPROVE_STATUS_PERSON.REJECTED)
    { %>  <a><span class="DeleteIcon"  style="background: url(../Images/Icons.png) no-repeat -150px -32px;"></span></a>  <%} %>
                                                        </td>
                                                        <td class="DateTime  U3"><%=ticketOther.oper_time != null ? EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)ticketOther.oper_time).ToString("yyyy-MM-dd HH:mm:ss"):"" %></td>
                                                        <td class="Text  U4">
                                                            <% if (ticketOther.resource_id == LoginUserId)
                                                                { %>
                                                            <a onclick="ToAppOtherPage()" style="cursor: pointer;">审批信息管理</a>
                                                            <%}
    else
    { %>
                                                            <%=ticketOther.description %>
                                                            <%} %>

                                                        </td>
                                                        <td></td>
                                                    </tr>
                                                    <%
                                                            }
                                                           } %>
                                                </tbody>
                                                <tbody id="ticketOtherNewTbody">

                                                </tbody>
                                        </table>
                                    </div>
                                    <div class="ScrollingContentContainer">
                                       <%-- <div class="RowContainer BodyContainer">
                                            <table cellpadding="0">
                                                
                                            </table>
                                            <div class="ContextOverlayContainer" id="ApprovalsTabGrid_ContextOverlay">
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
                                        </div>--%>
                                    </div>
                                    <div class="FooterContainer"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="SecondaryContainer Right">
            <div class="TabButtonContainer">
                <div>
                    <div class="TabButton EntityPageTabIcon Details" onclick="">
                        <div class="Icon"></div>
                        <div class="Text">Details</div>
                    </div>
                </div>
                <div>
                    <div class="TabButton EntityPageTabIcon Insights Active">
                        <div class="Icon"></div>
                        <div class="Text">Insights</div>
                    </div>
                </div>
            </div>
            <div class="InsightContainer" id="z2f17c82a79b54ecf86b9d5d2999110b6">
                <div class="LoadingIndicator Transition Fade">
                    <div class="Icon"></div>
                </div>
                <div class="InsightShell Collapsed" id="za732b4150b1147c19e730b3785638172">
                    <div class="Title Title5">
                        <div class="Text">客户/联系人 </div>
                        <%--<div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>--%>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer Transition"></div>
                        <div class="Content">
                            <div class="LinkButton HighImportance ShowAccInfo"><a class="Button ButtonIcon Link NormalState" id="TranAccount"></a></div>
                            <div class="Bundle ShowAccInfo">
                                <div class="LinkButton ShowAccInfo">
                                    <a class="Button ButtonIcon Link NormalState" id="TranAccSit"></a>

                                </div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text Address ShowAccInfo" id="ShowAccAddress">

                                <div class="InsightIconButton">
                                    <div class="InlineIconButton InlineIcon Map NormalState"></div>
                                </div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text ShowAccInfo" id="AccPhone"></div>
                            <div class="Text ShowAccInfo"></div>
                            <div class="Text ShowAccInfo"></div>
                            <div class="NormalSpacer"></div>
                            <div class="LinkButton ShowAccInfo"><a class="Button ButtonIcon Link NormalState" id="AccTicketHref" tabindex="0"></a></div>
                            <div class="LinkButton ShowAccInfo">
                                <a class="Button ButtonIcon Link NormalState" id="ShowLastTicket" tabindex="0"></a>
                            </div>
                            <div class="Divider">
                                <div class="Line"></div>
                            </div>
                            <div class="Bundle">
                                <div class="LinkButton HighImportance ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="TranContact" tabindex="0"></a></div>
                                <div class="InsightIconButton" style="display: none;">
                                    <div class="InlineIconButton InlineIcon Note NormalState" id="zc52f76470ea54233a6c504a044665bef" title="Notify Contact: "></div>
                                </div>
                            </div>
                            <div class="Text"></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text ShowContactInfo" id="ContactPhone"></div>
                            <div class="LinkButton ShowContactInfo"><a class="Button Mailto Link" href="mailto:"></a></div>
                            <div class="NormalSpacer"></div>
                            <div class="LinkButton ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="TranContactTicket" tabindex="0">All Open Tickets (11)</a></div>
                            <div class="LinkButton ShowContactInfo"><a class="Button ButtonIcon Link NormalState" id="z5e2301fad3194aebac208b89873bb85d" tabindex="0">Last 30 Days (2)</a></div>
                        </div>
                    </div>
                </div>
                <div class="InsightShell Collapsed">
                    <div class="Title Title6">
                        <div class="Text">工时汇总</div>
                        <%-- <div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>--%>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer"></div>
                        <div class="Content" id="z9ac8e203dc7e4dfab0d0a982b4afeece">
                            <table class="Table" cellpadding="0">
                                <tbody>
                                    <tr class="TableRow">
                                        <td>
                                            <div class="Text LowImportance">实际工时</div>
                                        </td>
                                        <td>
                                            <div class="Text LowImportance">预估工时</div>
                                        </td>
                                    </tr>
                                    <tr class="TableRow">
                                        <td>
                                            <div class="Text HighImportance">
                                                <%
                                                    decimal entryHours = 0;
                                                    if (entryList != null && entryList.Count > 0)
                                                    {
                                                        entryHours = entryList.Sum(_ => _.hours_worked ?? 0);
                                                    }
                                                %>
                                                <%=entryHours.ToString("#0.00")+"h" %>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="Text HighImportance"><%=thisTicket.estimated_hours.ToString("#0.00")+'h' %></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <% var overHours = thisTicket.estimated_hours - entryHours;  %>
                            <div class="NormalSpacer"></div>
                            <div class="ProgressBar">
                                <div class="Bar">
                                    <div class="Progress IsGreaterThanZero <%=overHours<0?"Critical":"" %>" style="width: <%=overHours<0?100:(entryHours*100/(thisTicket.estimated_hours==0?1:thisTicket.estimated_hours)) %>%;"></div>
                                </div>
                                <div class="Text <%=overHours<0?"CriticalImportance":"" %>">
                                    <div class="Text" style="display: inline;">

                                        <% if (overHours < 0)
                                            {
                                                overHours = 0 - overHours;
                                            } %>
                                        <%=overHours.ToString("#0.00")+"h" %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="InsightShell Collapsed" id="z48d3540e2e584765910e8058b1be991f">
                    <div class="Title Title7">
                        <div class="Text">配置项</div>
                        <%-- <div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>--%>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer Transition"></div>
                        <div class="Content" id="InsProInfoDiv">
                            <div class="Text LowImportance">名称</div>
                            <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProName" tabindex="0"></a></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">联系人</div>
                            <div class="Bundle">
                                <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProContact" tabindex="0"></a></div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">安装</div>
                            <div class="Text HighImportance" id="InsProInstallTime"></div>
                            <div class="Bundle">
                                <div class="Text HighImportance" id="InsProInstallUser"></div>
                            </div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">保修期</div>
                            <div class="Text HighImportance" id="InsProWarnTime"></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">供应商</div>
                            <div class="LinkButton HighImportance"><a class="Button ButtonIcon Link NormalState" id="InsProVendor" tabindex="0"></a></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">服务水平协议</div>
                            <div class="Text CriticalImportance" id="InsProService"></div>
                            <div class="NormalSpacer"></div>
                            <div class="Text LowImportance">相关配置项</div>
                            <div class="Text HighImportance" id="InsProRelated">0</div>
                            <div class="NormalSpacer"></div>
                            <div class="Text">All Open Tickets (0)</div>
                            <div class="Text">Total Tickets (0)</div>
                        </div>
                        <div class="Content" id="NoInsProShow">
                            <div class="Text NoData VeryLowImportance">暂无配置项信息</div>
                        </div>
                    </div>
                </div>
                <div class="InsightShell Invisible" id="za4e05a3de99042b09d62b550b4b766bf" style="display: none;">
                    <div class="Title">
                        <div class="Text">商机</div>
                        <%-- <div class="Toggle">
                            <div class="InlineIcon ArrowUpSmall"></div>
                        </div>--%>
                    </div>
                    <div class="ContentContainer">
                        <div class="LoadingIndicator"></div>
                        <div class="TransitionContainer"></div>
                        <div class="Content" id="z9f356c8974c1409b855378914d4caef6"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="BackgroundOverLay"></div>
    <div class="Dialog Large" style="margin-left: 400px; margin-top: -1100px; z-index: 100; height: 350px; width: 350px; display: none;" id="DeleteTicketDialog">
        <div>
            <div class="CancelDialogButton" id="CloseDeleteTicketReson"></div>
            <div class="Active ThemePrimaryColor TitleBar">
                <div class="Title"><span class="Text">消息</span><span class="SecondaryText"></span></div>
            </div>
            <div class="DialogHeadingContainer">
                <div class="ValidationSummary" id="">
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
                    <a class="Button ButtonIcon Save NormalState" id="SaveAndCloseRepeatButton" tabindex="0"><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span><span class="Text">OK</span></a>
                </div>
            </div>

            <div class="ScrollingContentContainer">
                <div class="ScrollingContainer" id="" style="position: unset;">
                    <div class="Instructions">
                        <div class="InstructionItem">工单不能删除，原因参见以下说明：:</div>
                    </div>

                    <div class="Medium Section">
                        <div class="Heading">
                            <div class="Left"><span class="Text">Deletion Failed</span><span class="SecondaryText"></span></div>
                            <div class="Spacer"></div>
                        </div>
                        <div class="Content">
                            <div class="Normal Column">
                                <div class="StandardText">
                                    <%=thisTicket.no %> - <%=thisTicket.title %> (<%=thisAccount==null?"":thisAccount.name %>)						
                                </div>
                                <div class="CustomLayoutContainer">
                                    <div class="TicketDeletionDialog_Container">
                                        <ul class="TicketDeletionDialog_UnorderedList" id="DeletTicketReasonUl">
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Ticket.js"></script>
<!--页面常规信息js操作 -->
<script>

    function GetAccountInfo() {
        var account_id = '<%=thisAccount==null?"":thisAccount.id.ToString() %>';
        if (account_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=GetAccDetail&account_id=" + account_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $(".ShowAccInfo").show();

                        $("#TranAccount").click(function () {
                            OpenAccount(account_id);
                        })
                        $("#TranAccount").text(data.name);

                        $("#TranAccSit").click(function () {
                            OpenAccountSite(account_id);
                        });
                        $("#TranAccSit").text("站点配置");
                        $("#ShowAccAddress").html(data.address2 + "<br />" + data.provice + "&nbsp;" + data.city + "&nbsp;" + data.quXian + "&nbsp;" + "<br />" + data.address1);
                        $("#AccPhone").text(data.phone);
                        if (data.ticketNum != "" && Number(data.ticketNum) > 0) {
                            $("#AccTicketHref").click(function () {
                                OpenAccountTicket(account_id);
                            });

                        }
                        $("#AccTicketHref").text("打开工单（" + data.ticketNum + "）");
                        if (data.monthNum != "" && Number(monthNum) > 0) {
                            $("#ShowLastTicket").click(function () {
                                // OpenAccountTicket(account_idHidden);
                            });
                        }
                        // 

                    } else {
                        $(".ShowAccInfo").hide();
                        $("#TranAccount").removeAttr("onclcik");
                        $("#TranAccount").text("");
                        $("#TranAccSit").removeAttr("onclcik");
                        $("#AccPhone").text("");
                        $("#AccTicketHref").removeAttr("onclcik");
                        $("#ShowLastTicket").removeAttr("onclcik");
                    }
                },
            });
        }
        else {
            $(".ShowAccInfo").hide();
            $("#TranAccount").removeAttr("onclcik");
            $("#TranAccount").text("");
            $("#TranAccSit").removeAttr("onclcik");
            $("#AccPhone").text("");
            $("#AccTicketHref").removeAttr("onclcik");
            $("#ShowLastTicket").removeAttr("onclcik");
        }
    }
    // 获取到联系人信息
    function GetContactInfo() {
        var contact_id = '<%=thisContact==null?"":thisContact.id.ToString() %>';
        if (contact_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContactAjax.ashx?act=GetContactDetail&contact_id=" + contact_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $(".ShowContactInfo").show();

                        $("#TranContact").click(function () {
                            OpenContact(contact_id);
                        })
                        $("#TranContact").text(data.name);

                        $("#ContactPhone").text(data.phone);

                        if (data.ticketNum != "" && Number(data.ticketNum) > 0) {
                            $("#TranContactTicket").click(function () {
                                OpenContactTicket(contact_id);
                            });
                        }
                        $("#TranContactTicket").text("打开工单（" + data.ticketNum + "）");
                        if (data.monthNum != "" && Number(monthNum) > 0) {

                        }
                        // 

                    } else {
                        $(".ShowContactInfo").hide();
                        $("#ContactPhone").text("");

                        $("#TranContactTicket").removeAttr("onclcik");

                    }
                },
            });
        }
        else {
            // 隐藏联系人相关信息
            $(".ShowContactInfo").hide();
        }
    }
    // 获取到配置项信息
    function GetInsProInfo() {
        var installed_product_id = '<%=insPro==null?"":insPro.id.ToString() %>';
        if (installed_product_id != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ProductAjax.ashx?act=GetInsProDetail&insProId=" + installed_product_id,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        $("#InsProInfoDiv").show();
                        $("#NoInsProShow").hide();
                        $("#InsProName").text(data.name);
                        $("#InsProName").click(function () {
                            EditInsPro(installed_product_id);
                        })

                        $("#InsProContact").text(data.contactName);
                        $("#InsProContact").click(function () {
                            OpenContact(data.contactId);
                        })
                        $("#InsProInstallTime").val(data.insTime);
                        $("#InsProInstallUser").val(data.insUser);
                        $("#InsProWarnTime").val(data.insWarnTime);
                        // InsProVendor
                        $("#InsProVendor").text(data.vendorName);
                        $("#InsProVendor").click(function () {
                            OpenAccount(data.vendorId);
                        })

                    }
                    else {
                        $("#InsProInfoDiv").hide();
                        $("#NoInsProShow").show();
                        $("#InsProName").removeAttr("onclick");
                        $("#InsProContact").removeAttr("onclick");
                        $("#InsProName").text("");
                        $("#InsProContact").text("");
                        $("#InsProInstallTime").val("");
                        $("#InsProInstallUser").val("");
                        $("#InsProWarnTime").val("");
                        $("#InsProVendor").removeAttr("onclick");
                        $("#InsProVendor").text("");
                    }
                }
            })
        }
        else {
            $("#InsProInfoDiv").hide();
            $("#NoInsProShow").show();
            $("#InsProName").removeAttr("onclick");
            $("#InsProContact").removeAttr("onclick");
            $("#InsProName").text("");
            $("#InsProContact").text("");
            $("#InsProInstallTime").val("");
            $("#InsProInstallUser").val("");
            $("#InsProWarnTime").val("");
            $("#InsProVendor").removeAttr("onclick");
            $("#InsProVendor").text("");
        }
    }
    // 显示工单的告警信息
    function ShowTicketAlert() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/TicketAjax.ashx?act=GetTicketAlert&ticket_id=<%=thisTicket==null?"":thisTicket.id.ToString() %>",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.accountAlert != "") {
                        $("#AccountAlert").show();
                        $("#AccountAlert").children().first().next().text(data.accountAlert);
                    }
                    else {
                        $("#AccountAlert").hide();
                    }

                }
            },
        });


    }

</script>
<script>
    $(function () {
        start();
        GetAccountInfo();
        GetContactInfo();
        GetInsProInfo();
        ShowTicketAlert();
        ApplyFilter('0');
    })

    // 打开客户
    function OpenAccount(id) {
        if (id != "") {
            window.open("../Company/ViewCompany.aspx?id=" + id, "_blank", 'left=200,top=200,width=800,height=800', false);
        }

    }
    // 打开客户站点
    function OpenAccountSite(id) {
        window.open("../Company/CompanySiteManage.aspx?id=" + id, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySiteConfiguration %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 打开客户的工单
    function OpenAccountTicket(id) {

    }
    // 打开联系人
    function OpenContact(id) {
        if (id != "") {
            window.open("../Contact/ViewContact.aspx?id=" + id, "_blank", 'left=200,top=200,width=600,height=800', false);
        }

    }
    // 添加工单的备注
    // 
    function AddTicketNote(type) {
        window.open("../Project/TaskNote.aspx?ticket_id=<%=thisTicket.id %>&notifi_type=" + type + "&noFunc=ApplyFilter", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_NOTE %>", 'left=200,top=200,width=1080,height=800', false);
    }
    // 跳转到修改工单相关功能
    function EditTicket() {
        location.href = "TicketManage?id=<%=thisTicket.id %>";
    }
    // 添加工时
    function AddTimeEntry() {
        // 已完成工单是否可以新增工时
        <%if (thisTicket.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE)
    { %>
        $.ajax({
            type: "GET",
            url: "../Tools/GeneralAjax.ashx?act=GetSysSetting&sys_id=<%=(int)EMT.DoneNOW.DTO.SysSettingEnum.SDK_TICKET_ADD_LABOUR %>",
            async: false,
            success: function (data) {
                if (data != "") {
                    if (data.setting_value == "1") {
                        window.open("../ServiceDesk/TicketLabour.aspx?noFunc=ApplyFilter&ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=1000,height=800', false);
                    }
                    else {
                        LayerMsg("已完成工单不可添加工时！");
                    }
                }
            }
        })
        <%}
    else
    {%>
        window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=1000,height=800', false);
        <%}%>
    }
    // 完成工单--添加工时，默认工单状态为完成
    function CompleteEntry() {
        window.open("../ServiceDesk/TicketLabour.aspx?ticket_id=<%=thisTicket.id %>&is_complete=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=600,height=800', false);
    }

    // 新增工单附件
    function AddTicketAttachment() {
        window.open("../Activity/AddAttachment.aspx?objId=<%=thisTicket.id %>&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.TASK %>&noFunc=ApplyFilter", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_NOTE %>", 'left=200,top=200,width=800,height=800', false);
    }
    // 新增工单费用
    function AddTicketExpense() {
        window.open("../Project/ExpenseManage.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_EXPENSE %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 添加工单成本
    function AddTicketCharge() {
        window.open("../Contract/AddCharges.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeAdd %>", 'left=200,top=200,width=800,height=800', false);
    }
    // 添加工单待办
    function AddTicketTodo() {
        window.open("../Activity/Todos.aspx?ticketId=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.TodoAdd %>", 'left=200,top=200,width=800,height=800', false);
    }

    // 跳转到编辑配置项相关页面
    function EditInsPro(id) {
        if (id != "") {
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + id, "<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>", 'left=200,top=200,width=600,height=800', false);
        }
    }
    // 查看合同
    function ViewContract(contract_id) {
        if (contract_id != "") {
            window.open("../Contract/ContractView.aspx?id=" + contract_id, "_blank", 'left=200,top=200,width=600,height=800', false);
        }
    }

    // 删除工单
    function DeleteTicket() {
        LayerConfirm("确认删除该工单吗？", "是", "否", function () {
            $("#BackgroundOverLay").show();
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=DeleteTicket&ticket_id=<%=thisTicket.id %>",
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            LayerMsg("删除成功！");
                            window.close();
                        }
                        else {
                            // todo 展示删除失败原因弹窗，为失败原因赋值
                            // DeletTicketReasonUl
                            // DeleteTicketDialog
                            if (data.reason != "") {
                                var failHtml = "";
                                var failArr = data.reason.split(';');
                                for (var i = 0; i < failArr.length; i++) {
                                    if (failArr[i] != "") {
                                        failHtml += "<li>" + failArr[i] + "</li>";
                                    }
                                }
                                $("#DeletTicketReasonUl").html(failHtml);
                                $("#DeleteTicketDialog").show();
                            }
                        }
                    }
                }
            })

        }, function () {

        });
    }
    $("#SaveAndCloseRepeatButton").click(function () {
        $("#DeleteTicketDialog").hide();
        $("#BackgroundOverLay").hide();
    })

    $("#CloseDeleteTicketReson").click(function () {
        $("#DeleteTicketDialog").hide();
        $("#BackgroundOverLay").hide();
    })
    // 打开工单历史页面
    function ShowTicketHistory() {
        window.open("../ServiceDesk/TicketHistory.aspx?ticket_id=<%=thisTicket.id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.ADD_TICKET_LABOUR %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 跳转到查看工单
    function ViewTicket(ticket_id) {
        location.href = "../ServiceDesk/TicketView?ids=<%=Request.QueryString["ids"] %>&id=" + ticket_id;
    }
</script>

<script>

    $("#TicketViewActivityDiv").click(function () {
        $("#ShowActivityDiv").show();
        $("#ShowIframeDiv").hide();
        $("#ShowApprovalDiv").hide();
    })

    $("#TicketViewCostDiv").click(function () {
        $("#ShowActivityDiv").hide();
        $("#ShowApprovalDiv").hide();
        $("#ShowIframeDiv").show();

        $("#TicketShowIframe").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_COST_EXPENSE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_COST_EXPENSE %>&con1762=<%=thisTicket==null?"":thisTicket.id.ToString() %>");
    })

    $("#TicketViewServiceDiv").click(function () {
        $("#ShowActivityDiv").hide();
        $("#ShowApprovalDiv").hide();
        $("#ShowIframeDiv").show();
        $("#TicketShowIframe").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SERVICE_LIST %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_SERVICE_LIST %>&con1761=<%=thisTicket==null?"":thisTicket.id.ToString() %>");
    })
    $("#TicketViewChangeDiv").click(function () {
        $("#ShowActivityDiv").hide();
        $("#ShowApprovalDiv")
        $("#ShowIframeDiv").show();
        $("#TicketShowIframe").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_REQUEST %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_REQUEST %>&con2259=<%=thisTicket==null?"":thisTicket.id.ToString() %>&con2260=<%=LoginUserId %>");
    })
    $("#TicketViewIncidentsDiv").click(function () {
        $("#ShowActivityDiv").hide();
        $("#ShowApprovalDiv")
        $("#ShowIframeDiv").show();
        $("#TicketShowIframe").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_INCIDENT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_INCIDENT %>&con2464=<%=thisTicket==null?"":thisTicket.id.ToString() %>");
    })
    $("#TicketViewProblemDiv").click(function () {
        $("#ShowActivityDiv").hide();
        $("#ShowApprovalDiv").hide();
        $("#ShowIframeDiv").show();
        $("#TicketShowIframe").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_PROBLEM %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_PROBLEM %>&con2465=<%=thisTicket==null?"":thisTicket.id.ToString() %>");
    })

    $("#TicketViewApprovalsDiv").click(function () {
        $("#ShowActivityDiv").hide();
        $("#ShowIframeDiv").hide();
        $("#ShowApprovalDiv").show();

    })
</script>
<%--// 工具中的事件处理--%>
<script>
    function MergeOtherTicketCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_MERGE %>&field=toTicketId&callBack=MergeTicket&con2252=<%=thisTicket.account_id %>&con2253=<%=thisTicket.id %>&con2262=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    function MergeTicket() {
        var ticketId = $("#ticket_id").val();
        var toTicketId = $("#toTicketIdHidden").val();
        if (ticketId != "" && toTicketId != "") {
            LayerConfirm("您将要将此工单合并到另一工单中，此工单的状态将被设置为完成。\其备注、工时、成本、服务预定、待办、费用等仍将与此工单保持关联。此工单的联系人和其他联系人，将作为另一个工单上的其他联系人。此外，您正在合并工单与合并目标的工单有不同的联系人。工单变更时，正在合并的工单的联系人将不再会收到相关通知。你确定要合并此工单吗？", "确定", "取消", function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/TicketAjax.ashx?act=MergeTicket&from_ticket_id=" + ticketId + "&to_ticket_id=" + toTicketId,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            if (data.result) {
                                LayerMsg("合并成功！");
                            }
                            else {
                                LayerMsg("合并失败！" + data.reason);
                            }
                        }
                    }
                })
                setTimeout(function () { history.go(0); }, 1000);
            }, function () { });
        }
    }
    // 吸收工单-查找带回
    function AbsorbCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_MERGE %>&field=AbsorbTicketIds&callBack=AbsorbTicket&con2252=<%=thisTicket.account_id %>&con2253=<%=thisTicket.id %>&muilt=1&&con2262=2", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 吸收工单-事件处理
    function AbsorbTicket() {
        var AbsorbTicketIds = $("#AbsorbTicketIdsHidden").val();
        var ticketId = $("#ticket_id").val();
        if (AbsorbTicketIds != null && AbsorbTicketIds != "" && ticketId != "") {
            var absIdsArr = AbsorbTicketIds.split(',');
            LayerConfirm("您将要吸收合并其他" + absIdsArr.length + "个工单。 如果您这样做，被吸收合并的工单的状态将被设置为完成，其备注、工时、成本、服务预定、待办、费用等仍将与此工单保持关联，其联系人和其他联系人，将作为当前工单上的其他联系人。你确定要吸收合并这些工单吗", "确定", "取消", function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/TicketAjax.ashx?act=AbsorbTicket&to_ticket_id=" + ticketId + "&from_ticket_ids=" + AbsorbTicketIds,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            LayerMsg("吸收其他工单成功！");
                        }
                        else {
                            LayerMsg("吸收其他工单失败！");
                        }
                    }
                })
                setTimeout(function () { history.go(0); }, 1000);
            }, function () { });
        }
    }

    function DisRelationProject() {
        var ticketId = $("#ticket_id").val();
        if (ticketId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=DisRelationProject&ticket_id=" + ticketId,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        LayerMsg("取消成功！");
                    }
                    else {
                        LayerMsg("取消失败！");
                        history.go(0);
                    }
                }
            })
        }
    }
    // 发票设置
    function ProcessInvoice() {
        window.open("../Invoice/ProcessInvoice?account_ids=<%=thisTicket.account_id %>", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PROCESS %>", 'left=200,top=200,width=960,height=800', false);
    }
    // 复制工单
    function CopyTicket() {
        window.open("../ServiceDesk/TicketManage?id=<%=thisTicket.id %>&isCopy=1", windowObj.ticket + windowType.add, 'left=200,top=200,width=960,height=800', false)
    }
    // 标记为问题
    function SignAsIssue() {
        var ticketId = $("#ticket_id").val();
        if (ticketId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=SignAsIssue&ticket_id=" + ticketId,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data.result) {
                        LayerMsg("标记成功！");
                    }
                    else {
                        LayerMsg("标记失败！" + data.reason);

                    }
                    setTimeout(function () { history.go(0); }, 800);
                }
            })
        }
    }

    // 标记为事故- 查找带回
    function SignAsIncident() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_INCLIDENT_RELATION %>&field=RelationId&callBack=SignInclidentCheck&con2471=<%=thisTicket.id %>&con2477=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 标记为事故-并关联其他工单的提交校验
    function SignInclidentCheck() {
        var RelationId = $("#RelationIdHidden").val();
        var ticketId = $("#ticket_id").val();
        if (RelationId == "" || ticketId == "") {
            return;
        }
        var relaType = "";   // 关联的工单的类型
        var relaProId = "";  // 关联的工单的问题工单ID
        var relaAccount = "";// 关联的工单的客户ID
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=GetTicket&ticket_id=" + RelationId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    relaType = data.ticket_type_id;
                    relaProId = data.problem_ticket_id;
                    relaAccount = data.account_id;
                }
            }
        })

        if (relaType == "<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.INCIDENT %>" && relaProId != "") {
            LayerMsg("当前事故已关联其他问题，不能转为问题！");
            $("#RelationIdHidden").val("");
            $("#RelationId").val("");
            return;
        }

        var thisType = '<%=thisTicket.ticket_type_id %>';
        var thisAccountId = '<%=thisTicket.account_id %>';

        if (thisType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_TYPE.PROBLEM %>') {
            var thisProCount = 0;
            $.ajax({
                type: "GET",
                url: "../Tools/TicketAjax.ashx?act=GetProCount&ticket_id=" + ticketId,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        thisProCount = data;
                    }
                }
            })
        }
        if (!isNaN(thisProCount) && Number(thisProCount) > 0) {
            LayerConfirm("将该工单记为事故，首先会解除所有的事故关联关系，然后将该工单和它原有的故障关联到另一个问题。 所有其他工单（变更申请单）与此工单的关联关系依旧保留。是否继续？", "是", "否", function () {
                if (relaAccount != thisAccountId) {
                    LayerConfirm("当前工单（一个或多个）与所选工单属于不同的客户。 为确保获得准确的盈利报告，建议将问题工单与您的公司联系起来。 你是否想为自己的公司创建一个新的问题工单，并将当前的问题工单（及其所有事故）与新的问题工单相关联？ 如果您单击否，则不会为您自己的公司创建新的问题工单（现有的问题/事故关系将保持不变）。", "是", "否", function () {
                        $.ajax({
                            type: "GET",
                            url: "../Tools/TicketAjax.ashx?act=SinAsIncident&ticket_id=" + ticketId + "&rela_ticket_id=" + RelationId + "&change_account=1",
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                if (data) {
                                    LayerMsg("标记成功！");
                                }
                                else {
                                    LayerMsg("标记失败！");
                                }
                                setTimeout(function () { history.go(0); }, 800);
                            }
                        })
                    }, function () {
                        $.ajax({
                            type: "GET",
                            url: "../Tools/TicketAjax.ashx?act=SinAsIncident&ticket_id=" + ticketId + "&rela_ticket_id=" + RelationId,
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                if (data) {
                                    LayerMsg("标记成功！");
                                }
                                else {
                                    LayerMsg("标记失败！");
                                }
                                setTimeout(function () { history.go(0); }, 800);
                            }
                        })
                    });
                    return;
                }

            }, function () { });
            return;
        }

        if (relaAccount != thisAccountId) {
            LayerConfirm("当前工单（一个或多个）与所选工单属于不同的客户。 为确保获得准确的盈利报告，建议将问题工单与您的公司联系起来。 你是否想为自己的公司创建一个新的问题工单，并将当前的问题工单（及其所有事故）与新的问题工单相关联？ 如果您单击否，则不会为您自己的公司创建新的问题工单（现有的问题/事故关系将保持不变）。", "是", "否", function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/TicketAjax.ashx?act=SinAsIncident&ticket_id=" + ticketId + "&rela_ticket_id=" + RelationId + "&change_account=1",
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            LayerMsg("标记成功！");
                        }
                        else {
                            LayerMsg("标记失败！");
                        }
                        setTimeout(function () { history.go(0); }, 800);
                    }
                })
            }, function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/TicketAjax.ashx?act=SinAsIncident&ticket_id=" + ticketId + "&rela_ticket_id=" + RelationId,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            LayerMsg("标记成功！");
                        }
                        else {
                            LayerMsg("标记失败！");
                        }
                        setTimeout(function () { history.go(0); }, 800);
                    }
                })
            });
            return;
        }

        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=SinAsIncident&ticket_id=" + ticketId + "&rela_ticket_id=" + RelationId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("标记成功！");
                }
                else {
                    LayerMsg("标记失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        })
    }
    // 标记为事故并关联新的问题 - 打开新增工单页面
    function SignInclidentNewIssueOpen() {
        window.open("../ServiceDesk/TicketManage?id=<%=thisTicket.id %>&isCopy=1&IsIssue=1&CallBack=SignInclidentNewIssue", windowObj.ticket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
    }
    // 标记为事故并关联新的问题
    function SignInclidentNewIssue(issueTicketId) {
        var ticketId = $("#ticket_id").val();
        if (ticketId == "")
            return;
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=RelaNewProblem&ticket_id=" + ticketId + "&rela_ticket_id=" + issueTicketId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("关联成功！");
                }
                else {
                    LayerMsg("关联失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        })
    }
    // 关联服务请求
    function RelaRequests() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_INCLIDENT_RELATION %>&field=RequestServiceId&callBack=GetDataByRequests&con2471=<%=thisTicket.id %>&con2477=2&muilt=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    // 关联选择的服务请求工单
    function GetDataByRequests() {
        var RequestServiceId = $("#RequestServiceIdHidden").val();
        if (RequestServiceId == "")
            return;
        var ticketId = $("#ticket_id").val();
        if (ticketId == "")
            return;
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=RelaNewRequests&ticket_id=" + ticketId + "&rela_ticket_ids=" + RequestServiceId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("关联成功！");
                }
                else {
                    LayerMsg("关联失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        })
    }

    // 标记为事故并关联其他变更申请单 - 打开新增工单页面
    function SignInclidentNewRequestOpen() {
        window.open("../ServiceDesk/TicketManage?id=<%=thisTicket.id %>&isCopy=1&IsRequest=1&CallBack=SignInclidentNewRequest", windowObj.ticket + windowType.add, 'left=200,top=200,width=1280,height=800', false);
    }
    // 标记为事故并关联其他变更申请单
    function SignInclidentNewRequest(requestId) {
        var ticketId = $("#ticket_id").val();
        if (ticketId == "")
            return;
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=RelaNewRequests&ticket_id=" + ticketId + "&rela_ticket_ids=" + requestId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("关联成功！");
                }
                else {
                    LayerMsg("关联失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        })
    }
    // 关联其他问题工单
    function RelaManyProblemTicket() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_INCLIDENT_RELATION %>&field=ProblemId&callBack=GetDataByProblem&con2471=<%=thisTicket.id %>&con2477=3&muilt=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByProblem() {
        var ProblemId = $("#ProblemIdHidden").val();
        if (ProblemId == "")
            return;
        var ticketId = $("#ticket_id").val();
        if (ticketId == "")
            return;

        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=RelaProblem&ticket_id=" + ticketId + "&rela_ticket_ids=" + ProblemId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("关联成功！");
                }
                else {
                    LayerMsg("关联失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        })
    }
    function AddProId(proId) {
        var ticketId = $("#ticket_id").val();
        if (ticketId == "")
            return;
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=RelaProblem&ticket_id=" + ticketId + "&rela_ticket_ids=" + proId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("关联成功！");
                }
                else {
                    LayerMsg("关联失败！");
                }
                setTimeout(function () { history.go(0); }, 800);
            }
        })
    }

    function SignManyAsIncident() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_INCLIDENT_RELATION %>&field=IncidentsId&callBack=SignManyIncCheck&con2471=<%=thisTicket.id %>&con2477=1&muilt=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }

    function SignManyIncCheck() {
        var IncidentsId = $("#IncidentsIdHidden").val();
        var ticketId = $("#ticket_id").val();
        if (IncidentsId == "" || ticketId == "")
            return;

        var isHasDiffAcc = false;
        var isHasPro = false;
        var isSginInd = false;
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=CheckRelaTicket&ticket_id=" + ticketId + "&rela_ticket_ids=" + IncidentsId,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    isHasDiffAcc = data.diffAcc;
                    isHasPro = data.isHasPro;
                    isSginInd = data.isSginInd;
                }


            }
        })
        if (isHasPro) {
            LayerMsg("选择工单已关联其他工单，不能关联！")
        }
        if (isSginInd) {
            LayerConfirm("将该工单记为事故，首先会解除所有的事故关联关系，然后将该工单和它原有的故障关联到另一个问题。 所有其他工单（变更申请单）与此工单的关联关系依旧保留。是否继续", "是", "否", function () {
                if (isHasDiffAcc) {
                    LayerConfirm("当前工单（一个或多个）与所选工单属于不同的客户。 为确保获得准确的盈利报告，建议将问题工单与您的公司联系起来。 你是否想为自己的公司创建一个新的问题工单，并将当前的问题工单（及其所有事故）与新的问题工单相关联？ 如果您单击否，则不会为您自己的公司创建新的问题工单（现有的问题/事故关系将保持不变）。", "是", "否", function () {
                        $.ajax({
                            type: "GET",
                            url: "../Tools/TicketAjax.ashx?act=RelaIncident&ticket_id=" + ticketId + "&rela_ticket_ids=" + IncidentsId + "&change_account=1",
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                if (data) {
                                    LayerMsg("标记成功！");
                                }
                                else {
                                    LayerMsg("标记失败！");
                                }
                                setTimeout(function () { history.go(0); }, 800);
                            }
                        })
                    }, function () {
                        $.ajax({
                            type: "GET",
                            url: "../Tools/TicketAjax.ashx?act=RelaIncident&ticket_id=" + ticketId + "&rela_ticket_ids=" + IncidentsId,
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                if (data) {
                                    LayerMsg("标记成功！");
                                }
                                else {
                                    LayerMsg("标记失败！");
                                }
                                setTimeout(function () { history.go(0); }, 800);
                            }
                        })
                    });
                    return;
                }

            }, function () { });
            return;
        } else {

        }

        if (isHasDiffAcc) {
            LayerConfirm("当前工单（一个或多个）与所选工单属于不同的客户。 为确保获得准确的盈利报告，建议将问题工单与您的公司联系起来。 你是否想为自己的公司创建一个新的问题工单，并将当前的问题工单（及其所有事故）与新的问题工单相关联？ 如果您单击否，则不会为您自己的公司创建新的问题工单（现有的问题/事故关系将保持不变）。", "是", "否", function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/TicketAjax.ashx?act=RelaIncident&ticket_id=" + ticketId + "&rela_ticket_ids=" + IncidentsId + "&change_account=1",
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            LayerMsg("标记成功！");
                        }
                        else {
                            LayerMsg("标记失败！");
                        }
                        setTimeout(function () { history.go(0); }, 800);
                    }
                })
            }, function () {
                $.ajax({
                    type: "GET",
                    url: "../Tools/TicketAjax.ashx?act=RelaIncident&ticket_id=" + ticketId + "&rela_ticket_ids=" + IncidentsId,
                    async: false,
                    dataType: "json",
                    success: function (data) {
                        if (data) {
                            LayerMsg("标记成功！");
                        }
                        else {
                            LayerMsg("标记失败！");
                        }
                        setTimeout(function () { history.go(0); }, 800);
                    }
                })
            });
            return;
        }

    }

    function AddIndId(IndId) {
        $("#IncidentsIdHidden").val(IndId);
        SignManyIncCheck();
    }
    // 审批负责人的查找带回
    function OtherResCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&field=OtherResId&callBack=GetDataByOther&muilt=1", "<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>", 'left=200,top=200,width=600,height=800', false);
    }

    function GetDataByOther() {
        var oldResIds = "";// 获取到旧的员工Id 防止重复
        $(".OldOther").each(function () {
            var thisRes = $(this).data("resid");
            if (thisRes != "") {
                oldResIds = thisRes + ",";
            }
        })
        if (oldResIds != "") {
            oldResIds = oldResIds.substring(0, oldResIds.length-1);
        }
        var OtherResId = $("#OtherResIdHidden").val();
        var otherHtml = "";
        if (OtherResId != "") {
            $.ajax({
                type: "GET",
                url: "../Tools/ResourceAjax.ashx?act=GetResInfo&resIds=" + OtherResId + "&oldResIds=" + oldResIds,
                async: false,
                dataType: "json",
                success: function (data) {
                    if (data!="") {
                        for (var i = 0; i < data.length; i++) {
                            otherHtml += "<tr class='D NewOther' data-val='" + data[i].id+"' id='other_" + data[i].id + "'><td><a onclick='RemoveResOther(\"" + data[i].id +"\")'><span class='DeleteIcon'></span></a></td><td class='Avatar U0'><div class='Initials ColorSwatch ColorSample Color5'>ll</div></td><td class='Text Normal U1'>" + data[i].name + "</td><td class='U2'></td><td class='DateTime U3'></td><td class='Text  U4'></td><td></td></tr>";
                        }
                    }
                }
            })
        }

        $("#ticketOtherNewTbody").html(otherHtml);
    }

    function SaveTicketOther() {
        var ticketId = $("#ticket_id").val();
        // 新的员工和旧的员工 使用不同的Class 旧的取id ，新的取 员工Id ，方便后台处理
       

        var newOtherIds = "";
        $(".NewOther").each(function () {
            var thisId = $(this).data("val");
            if (thisId != "" && thisId != undefined && thisId != null) {
                newOtherIds += thisId + ',';
            }
        })
        if (newOtherIds != "") {
            newOtherIds = newOtherIds.substring(0, newOtherIds.length-1);
        }

        var oldOtherIds = "";
        $(".OldOther").each(function () {
            var thisId = $(this).data("val");
            if (thisId != "" && thisId != undefined && thisId != null) {
                oldOtherIds += thisId + ',';
            }
        })
        if (oldOtherIds != "") {
            oldOtherIds = oldOtherIds.substring(0, oldOtherIds.length - 1);
        }
        var bord_id = $("#bord_id").val();
        if (bord_id == "" && newOtherIds == "" && oldOtherIds == "") {
            LayerMsg("请至少指派一个审批人！");
            return;
        }
        var isAllPass = "1";
        if ($("#OtherOnePass").is(":checked")) {
            isAllPass = "";
        }
        var isAdd = $("#is_add_other").val();
        var isEditBord = false;
        var isEditRule = false;
        if (isAdd != "1") {
            var oldBord = "<%=ticketOther!=null&&ticketOther.change_board_id!=null?ticketOther.change_board_id.ToString():"" %>";
            var oldRule = "<%=ticketOther!=null&&ticketOther.approval_type_id==(int)EMT.DoneNOW.DTO.DicEnum.APPROVAL_TYPE.ALL_APPROVERS_MUST_APPROVE?"1":"" %>";
            var isOneApp = false; // 是否有人批准
            <%if(ticketOtherList!=null&&ticketOtherList.Count>0&&ticketOtherList.Any(_=>_.approve_status_id==(int)EMT.DoneNOW.DTO.DicEnum.CHANGE_APPROVE_STATUS_PERSON.APPROVED)){ %>
            isOneApp = true;
            <%}%>
            if (isOneApp && oldBord != bord_id) {
                LayerConfirm("您即将更改更改变更委员会， 如果继续，所有现有的批准和拒绝将被删除（您仍然可以在工单历史记录中看到此数据），审批状态将设置为“已指派”。 是否继续？", "是", "否", function () {
                    if (isOneApp && oldRule != isAllPass) {
                        if (isAllPass == "1") {
                            LayerConfirm("改为需全部匹配，且已有人批准——您将要将审批通过原则更改为“所有审批者必须批准”，但是某些审批者尚未批准。 此变更单的状态将更改为“部分批准”。是否继续？", "是", "否", function () {
                                $.ajax({
                                    type: "GET",
                                    url: "../Tools/TicketAjax.ashx?act=TicketOtherManage&ticket_id=" + ticketId + "&board_id=" + bord_id + "&app_type_id=" + isAllPass + "&old_res_ids=" + oldOtherIds + "&new_res_ids=" + newOtherIds + "&is_add=" + isAdd,
                                    async: false,
                                    dataType: "json",
                                    success: function (data) {
                                        if (data) {
                                            LayerMsg("保存成功！");
                                            setTimeout(function () { history.go(0); }, 800)
                                        }
                                    }
                                })
                            }, function () { });
                            return;
                        }
                        else {
                            LayerConfirm("改为任何人批准，且一有人批准——您将要将审批通过原则更改为“任何一个审批者批准即可”，由于已经有审批者已批准。 此变更单的状态将更改为“已批准”。是否继续？", "是", "否", function () {
                                $.ajax({
                                    type: "GET",
                                    url: "../Tools/TicketAjax.ashx?act=TicketOtherManage&ticket_id=" + ticketId + "&board_id=" + bord_id + "&app_type_id=" + isAllPass + "&old_res_ids=" + oldOtherIds + "&new_res_ids=" + newOtherIds + "&is_add=" + isAdd,
                                    async: false,
                                    dataType: "json",
                                    success: function (data) {
                                        if (data) {
                                            LayerMsg("保存成功！");
                                            setTimeout(function () { history.go(0); }, 800)
                                        }
                                    }
                                })
                            }, function () { });
                            return;
                        }

                    }
                }, function () { });
                return;
            }
            if (isOneApp && oldRule != isAllPass) {
                if (isAllPass == "1") {
                    LayerConfirm("改为需全部匹配，且已有人批准——您将要将审批通过原则更改为“所有审批者必须批准”，但是某些审批者尚未批准。 此变更单的状态将更改为“部分批准”。是否继续？", "是", "否", function () {
                        $.ajax({
                            type: "GET",
                            url: "../Tools/TicketAjax.ashx?act=TicketOtherManage&ticket_id=" + ticketId + "&board_id=" + bord_id + "&app_type_id=" + isAllPass + "&old_res_ids=" + oldOtherIds + "&new_res_ids=" + newOtherIds + "&is_add=" + isAdd,
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                if (data) {
                                    LayerMsg("保存成功！");
                                    setTimeout(function () { history.go(0); }, 800)
                                }
                            }
                        })
                    }, function () { });
                    return;
                }
                else {
                    LayerConfirm("改为任何人批准，且一有人批准——您将要将审批通过原则更改为“任何一个审批者批准即可”，由于已经有审批者已批准。 此变更单的状态将更改为“已批准”。是否继续？", "是", "否", function () {
                        $.ajax({
                            type: "GET",
                            url: "../Tools/TicketAjax.ashx?act=TicketOtherManage&ticket_id=" + ticketId + "&board_id=" + bord_id + "&app_type_id=" + isAllPass + "&old_res_ids=" + oldOtherIds + "&new_res_ids=" + newOtherIds + "&is_add=" + isAdd,
                            async: false,
                            dataType: "json",
                            success: function (data) {
                                if (data) {
                                    LayerMsg("保存成功！");
                                    setTimeout(function () { history.go(0); }, 800)
                                }
                            }
                        })
                    }, function () { });
                    return;
                }
                
            }
        }
       
       
        $.ajax({
            type: "GET",
            url: "../Tools/TicketAjax.ashx?act=TicketOtherManage&ticket_id=" + ticketId + "&board_id=" + bord_id + "&app_type_id=" + isAllPass + "&old_res_ids=" + oldOtherIds + "&new_res_ids=" + newOtherIds + "&is_add=" + isAdd,
            async: false,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("保存成功！");
                    setTimeout(function () { history.go(0); },800)
                }
            }
        })
    }
</script>
