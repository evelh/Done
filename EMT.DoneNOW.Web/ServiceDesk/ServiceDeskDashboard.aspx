<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServiceDeskDashboard.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.ServiceDeskDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/crmDashboard.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <div class="header">服务台仪表板-<%=LoginUser.name %>-<%=DateTime.Now.ToString("yyyy-MM-dd HH:mm") %></div>
    <div class="header-title" style="width: 480px;">
        <ul>
            <li style="list-style: none;height:22px;">
                <img src="../Images/print.png" /></li>
            <li style="border: 0px; background: linear-gradient(to bottom,#fff 0,#fff 100%);list-style: none;">
                <span>刷新：</span>
                <select id="queryType" style="height: 24px">
                    <option>不刷新</option>
                    <option value="5">5分钟</option>
                    <option value="10">10分钟</option>
                    <option value="30">30分钟</option>
                    <option value="60">60分钟</option>
                </select>
            </li>
        </ul>
    </div>
    <table style="width: 945px;" cellspacing="0" cellpadding="0" border="0">
        <tbody>
            <tr>
                <td colspan="3">
                    <div class="PageLevelInstructions" style="padding-left: 10px; padding-top: 10px;">
                        <span>下列数字不反映定期工单数量，除非另有说明
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="52%" valign="top">
                    <!-- THIS IS THE LEFT SIDE TABLES -->
                    <div class="DivSectionWithHeader">
                        <div class="Heading"><span class="Text">我的服务台摘要</span></div>
                        <div class="Content">

                            <table cellspacing="0" cellpadding="3" border="0">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td style="font-size: 0px;" width="1%" height="1">
                                                            <img src="/images/clearpixel.gif?v=49725" width="75" height="1"></td>
                                                        <td style="font-size: 0px;" width="1%" height="1">
                                                            <img src="/images/clearpixel.gif?v=49725" width="8" height="1"></td>
                                                        <td style="font-size: 0px;" height="1">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right; vertical-align: top;" class="FieldLabels">概述<p>
                                                            <img src="../Images/ico_service_dash_overview.png" />
                                                            </p>
                                                        </td>
                                                        <td></td>
                                                        <td width="98%">
                                                            <table width="100%" cellspacing="0" cellpadding="3" border="0" id="tblOverview">
                                                                <tbody>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%">工单截止日期<a class="PrimaryLink" href="#" onclick="Search('SearchTicketsDueToday')">今天</a> (0) | <a class="PrimaryLink" id="errorSmall" href="#" onclick="Search('SearchTicketsOverdue')">过期</a> (84)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%">已创建工单<a class="PrimaryLink" href="#" onclick="Search('SearchTicketsSubmittedToday')">今天</a> (1) | <a class="PrimaryLink" href="#" onclick="Search('SearchTicketsSubmittedYesterday')">昨天</a> (0)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%">已完成工单<a class="PrimaryLink" href="#" onclick="Search('SearchTicketsCompletedToday')">今天</a> (0) | <a class="PrimaryLink" href="#" onclick="Search('SearchTicketsCompletedYesterday')">昨天</a> (0)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%"><a class="PrimaryLink" href="#" onclick="Search('SearchUnassignedTickets')">未分配的工单</a> (32)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td align="right"></td>
                                                                        <td><a class="PrimaryLink" href="#" onclick="resUtilReport();">工作量报表</a></td>
                                                                    </tr>

                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td>

                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom;" class="FieldLabels">工单优先级分析  </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_priority.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap;">
                                                                            <br>
                                                                            优先级</td>
                                                                        <td style="white-space: nowrap;" align="center" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            新建</td>
                                                                        <td style="white-space: nowrap;" align="center" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            活动的</td>
                                                                        <td style="" align="center" class="FieldLabels">
                                                                            <br>
                                                                            平均持续时间</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4">
                                                                            <hr />
                                                                        </td>
                                                                    </tr>
                                                                    <% if (priorityList != null && priorityList.Count > 0 && allTicketList != null && allTicketList.Count > 0)
                                                                        {
                                                                            foreach (var priority in priorityList)
                                                                            {
                                                                                var thisNew = allTicketList.Where(_ => _.priority_type_id == priority.id && _.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).ToList();
                                                                                var thisOpen = allTicketList.Where(_ => _.priority_type_id == priority.id && _.status_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList();
                                                                                var thisDone = allTicketList.Where(_ => _.priority_type_id == priority.id && _.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList();
                                                                    %>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText"><%=priority.name %></span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=thisNew.Count %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=thisOpen.Count %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(thisDone) %></td>
                                                                    </tr>
                                                                    <%
                                                                            }
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom;" class="FieldLabels">工单状态分析</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_status.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" border="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap;">
                                                                            <br>
                                                                            状态</td>
                                                                        <td style="white-space: nowrap;" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            总数</td>
                                                                        <td style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            严重</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="3">
                                                                            <hr />
                                                                        </td>
                                                                    </tr>
                                                                    <% if (ticStaList != null && ticStaList.Count > 0 && allTicketList != null && allTicketList.Count > 0)
                                                                        {
                                                                            foreach (var status in ticStaList)
                                                                            {%>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color19 ColorText"><%=status.name %></span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=allTicketList.Where(_=>_.status_id==status.id).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=allTicketList.Where(_=>_.status_id==status.id&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                    </tr>
                                                                    <%}
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom;" class="FieldLabels">工单主负责人分析</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_resource.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap;">
                                                                            <br>
                                                                            主负责人姓名</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            新建</td>
                                                                        <td align=" center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            活动的</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            严重</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            平均持续时间</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <% if (allTicketList != null && allTicketList.Count > 0)
                                                                        {
                                                                    %>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><i>无</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search('')"><%=allTicketList.Where(_=>_.owner_resource_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search('')"><%=allTicketList.Where(_=>_.owner_resource_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search('')"><%=allTicketList.Where(_=>_.owner_resource_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.owner_resource_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%
                                                                        if (resList != null && resList.Count > 0)
                                                                        {
                                                                            foreach (var thisRes in resList)
                                                                            {%>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><%=thisRes.name %></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search('SearchNewTicketsByPrimaryResource?PrimaryResourceId=29682886')"><%=allTicketList.Where(_=>_.owner_resource_id==thisRes.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=allTicketList.Where(_=>_.owner_resource_id==thisRes.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=allTicketList.Where(_=>_.owner_resource_id==thisRes.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.owner_resource_id==thisRes.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%}
                                                                            }
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom;" class="FieldLabels">工单问题分析</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_issue_type.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap">
                                                                            <br>
                                                                            问题类型</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            新建</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            活动的</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            严重</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            平均持续时间</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <% if (allTicketList != null && allTicketList.Count > 0)
                                                                        {
                                                                    %>
                                                                    <tr>
                                                                        <td id="txtBlack8"><i>无</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.issue_type_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.issue_type_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.issue_type_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.issue_type_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%
                                                                        if (issueTypeList != null && issueTypeList.Count > 0)
                                                                        {


                                                                            foreach (var issueType in issueTypeList)
                                                                            {%>
                                                                    <tr>
                                                                        <td id="txtBlack8"><%=issueType.name %></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.issue_type_id==issueType.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.issue_type_id==issueType.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.issue_type_id==issueType.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.issue_type_id==issueType.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%}
                                                                            }
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom;" class="FieldLabels">工单来源分析</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_source.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap">
                                                                            <br>
                                                                            来源</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            新建</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            活动的</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            严重</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            平均持续时间</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>

                                                                    <% if (allTicketList != null && allTicketList.Count > 0)
                                                                        {
                                                                    %>
                                                                    <tr>
                                                                        <td id="txtBlack8"><i>无</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.source_type_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.source_type_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.source_type_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.source_type_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%
                                                                        if (sourceTypeList != null && sourceTypeList.Count > 0)
                                                                        {
                                                                            foreach (var sourceType in sourceTypeList)
                                                                            {%>
                                                                    <tr>
                                                                        <td id="txtBlack8"><%=sourceType.name %></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.source_type_id==sourceType.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.source_type_id==sourceType.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.source_type_id==sourceType.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.source_type_id==sourceType.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%}
                                                                            }
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">工单客户类别</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_classification.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap">
                                                                            <br>
                                                                            客户类别</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            新建</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            活动的</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            严重</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            平均持续时间</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>

                                                                    <% if (classTickDic != null && classTickDic.Count > 0 && classList != null && classList.Count > 0)
                                                                        {
                                                                    %>
                                                                    <tr>
                                                                        <td id="txtBlack8"><i>无</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList():null) %></td>
                                                                    </tr>
                                                                    <%
                                                                        foreach (var thisClass in classList)
                                                                        {
                                                                    %>
                                                                    <tr>
                                                                        <td id="txtBlack8">
                                                                            <%if (!string.IsNullOrEmpty(thisClass.icon_path))
                                                                                { %>
                                                                            <img src="<%=thisClass.icon_path %>" border="0" hspace="0" vspace="0" alt="" />
                                                                            <%} %>
                                                                            <%=thisClass.name %></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=classTickDic.ContainsKey(thisClass.id)?classTickDic[thisClass.id].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=classTickDic.ContainsKey(thisClass.id)?classTickDic[thisClass.id].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=classTickDic.ContainsKey(thisClass.id)?classTickDic[thisClass.id].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(classTickDic.ContainsKey(thisClass.id)?classTickDic[thisClass.id].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList():null) %></td>
                                                                    </tr>
                                                                    <%}
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom;" class="FieldLabels">工单产品分析</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_product.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap">
                                                                            <br>
                                                                            产品名称</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            新建</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            活动的</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            严重</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            平均持续时间</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <% if (productTickDic != null && productTickDic.Count > 0 && proList != null && proList.Count > 0)
                                                                        {
                                                                    %>
                                                                    <tr>
                                                                        <td id="txtBlack8"><i>无</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(classTickDic.ContainsKey(0)?classTickDic[0].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList():null) %></td>
                                                                    </tr>
                                                                    <%
                                                                        if (proList != null && proList.Count > 0)
                                                                        {
                                                                            foreach (var product in proList)
                                                                            {
                                                                                if (!classTickDic.ContainsKey(product.id))
                                                                                {
                                                                                    continue;
                                                                                }
                                                                    %>
                                                                    <tr>
                                                                        <td id="txtBlack8">
                                                                            <%=product.name %></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=classTickDic.ContainsKey(product.id)?classTickDic[product.id].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=classTickDic.ContainsKey(product.id)?classTickDic[product.id].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" onclick="Search()"><%=classTickDic.ContainsKey(product.id)?classTickDic[product.id].Where(_=>_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count():0 %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(classTickDic.ContainsKey(product.id)?classTickDic[product.id].Where(_=>_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList():null) %></td>
                                                                    </tr>
                                                                    <%}
                                                                            }
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td width="1%" id="txtBlack8">
                                                            <img src="/images/clearPixel.gif?v=49725" width="75" height="1"></td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td id="txtBlack8">&nbsp;</td>
                                                    </tr>
                                                    <tr valign="top">
                                                        <td style="" class="FieldLabels">
                                                            <table cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="text-align: right; vertical-align: bottom;" class="FieldLabels">工单队列分析</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_queue.png" />
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                        <td width="1%">
                                                            <img src="/images/clearPixel.gif?v=49725" width="12" height="1"></td>
                                                        <td width="98%">
                                                            <table cellspacing="0" width="100%" class="TicketCountTable">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="white-space: nowrap;">
                                                                            <br>
                                                                            队列名称</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            新建</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            活动的</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            严重</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            平均持续时间</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <% if (allTicketList != null && allTicketList.Count > 0)
                                                                        {
                                                                    %>
                                                                    <tr>
                                                                        <td id="txtBlack8"><i>无</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.department_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.department_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.department_id==null&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.department_id==null&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%
                                                                        if (depList != null && depList.Count > 0)
                                                                        {
                                                                            foreach (var queue in depList)
                                                                            {%>
                                                                    <tr>
                                                                        <td id="txtBlack8"><%=queue.name %></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.department_id==queue.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.department_id==queue.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search()"><%=allTicketList.Where(_=>_.department_id==queue.id&&_.status_id!=(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE&&_.priority_type_id==(int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious).Count() %></a></td>
                                                                        <td align="center" id="txtBlack8"><%=ticBll.DoneTicketAvgDay(allTicketList.Where(_=>_.department_id==queue.id&&_.status_id==(int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList()) %></td>
                                                                    </tr>
                                                                    <%}
                                                                            }
                                                                        } %>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="3">
                                                            <img src="/images/clearPixel.gif?v=49725" width="14" height="8"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p>
                                            </p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </td>

                <td width="1">
                    <img src="/images/clearPixel.gif?v=49725" width="1" height="1"></td>

                <td valign="top">

                    <div class="DivSectionWithHeader">
                        <div class="Heading"><span class="Text">我的工单解决绩效</span></div>
                        <div class="Content">
                            <table width="100%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <% if (ticSolPer != null && ticSolPer.Count > 0)
                                                {
                                                    ticSolPer = ticSolPer.OrderBy(_=>_.id).ToList();
                                                    foreach (var thisSet in ticSolPer)
                                                    {%>
                                            <table border="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3" class="FieldLabels"><%=thisSet.name %></td>
                                                        <%
                                                            int maxAvgDays = 0;    // 实际
                                                            int maxSetAvgDays = 0; // 设置
                                                            if (allTicketList != null && allTicketList.Count > 0)
                                                            {
                                                                if(thisSet.id== (int)EMT.DoneNOW.DTO.DicEnum.SYS_TICKET_RESOLUTION_METRICS.MAXIMUM_DEAL_DAY)
                                                                {
                                                                    maxAvgDays = ticBll.DoneTicketAvgDay(allTicketList.Where(_ => _.priority_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious && _.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).ToList());
                                                                }
                                                                else if(thisSet.id== (int)EMT.DoneNOW.DTO.DicEnum.SYS_TICKET_RESOLUTION_METRICS.MAXIMUM_OPEN_CRITICAL_TICKETS)
                                                                {
                                                                    maxAvgDays = allTicketList.Where(_ => _.priority_type_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_PRIORITY_TYPE.serious && _.status_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count();
                                                                }
                                                                else if(thisSet.id== (int)EMT.DoneNOW.DTO.DicEnum.SYS_TICKET_RESOLUTION_METRICS.MAXIMUM_OPEN_TICKETS)
                                                                {
                                                                    maxAvgDays = allTicketList.Where(_ => _.status_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE).Count();
                                                                }
                                                                else if(thisSet.id== (int)EMT.DoneNOW.DTO.DicEnum.SYS_TICKET_RESOLUTION_METRICS.MAXIMUM_NEW_TICKETS)
                                                                {
                                                                    maxAvgDays = allTicketList.Where(_ => _.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.NEW).Count();
                                                                }
                                                                else if(thisSet.id== (int)EMT.DoneNOW.DTO.DicEnum.SYS_TICKET_RESOLUTION_METRICS.MAXIMUM_AVERAGE_TICKETS_PER_RESOURCE)
                                                                {
                                                                    int resNum = 0;
                                                                    var hasResList = allTicketList.Where(_ => _.owner_resource_id != null).ToList();
                                                                    if (hasResList!=null&&hasResList.Count > 0)
                                                                    {
                                                                        resNum = hasResList.Select(_ => _.owner_resource_id).Distinct().Count();
                                                                    }
                                                                    maxAvgDays = hasResList.Count / (resNum==0?1:resNum);
                                                                }

                                                            }

                                                            if (!string.IsNullOrEmpty(thisSet.ext1))
                                                            {
                                                                maxSetAvgDays = int.Parse(thisSet.ext1);
                                                            }

                                                            var maxAvgColor = "#02A64F";
                                                            var maxAvgPercentage = (maxAvgDays * 100 / (maxSetAvgDays == 0 ? 1 : maxSetAvgDays));
                                                            if (maxAvgPercentage > 50 && maxAvgPercentage <= 75)
                                                            {
                                                                maxAvgColor = "#fff799";
                                                            }
                                                            else if (maxAvgPercentage > 75)
                                                            {
                                                                maxAvgColor = "#FF4863";
                                                            }
                                                        %>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" width="100%">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" id="txtBlack8" title="Current Performance">&nbsp;<b><%=maxAvgDays %></b>&nbsp;</td>
                                                                        <td width="50%">
                                                                            <table bgcolor="<%=maxAvgColor %>" width="<%=maxAvgPercentage>50?100:(maxAvgPercentage*100/50) %>%" height="16px">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title=""></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <%if (maxAvgPercentage > 50)
                                                                                { %>
                                                                            <table bgcolor="<%=maxAvgColor %>" width="<%=maxAvgPercentage>75?100:((maxAvgPercentage-50)*100/25) %>%" height="16px">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title=""></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                            <%} %>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <%if (maxAvgPercentage > 75)
                                                                                { %>
                                                                            <table bgcolor="<%=maxAvgColor %>" width="<%=maxAvgPercentage>100?100:((maxAvgPercentage-75)*100/25) %>%" height="16px">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title=""></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                            <%} %>
                                                                        </td>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" title="Performance Metric Goal">&nbsp;<b><%=maxSetAvgDays %></b>&nbsp;</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <%}
                                            %>

                                            <%} %>

                                           
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <p>
                    </p>
                    <div class="DivSectionWithHeader">
                        <div class="Heading"><span class="Text">定期工单</span></div>
                        <div class="Content">
                            <table width="100%" cellspacing="0" cellpadding="3" border="0" id="Table2">
                                <tbody>
                                    <tr valign="top">
                                        <td style="padding-bottom: 5px;">截止日期 <a class="PrimaryLink" href="#" onclick="ToRecurringTicket('1631','<%=DateTime.Now.ToString("yyyy-MM-dd") %>')">今天</a> (0) | <a class="PrimaryLink" id="errorSmall" href="#" onclick="ToRecurringTicket('1631','<%=DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") %>')">过期</a> (51)</td>
                                    </tr>
                                    <tr valign="top">
                                        <td>已完成的定期工单 <a class="PrimaryLink" href="#" onclick="ToRecurringTicket('1632','<%=DateTime.Now.ToString("yyyy-MM-dd") %>')">今天</a> (0) | <a class="PrimaryLink" href="#" onclick="ToRecurringTicket('1632','<%=DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") %>')">昨天</a> (0)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <p>
                    </p>
                    <div class="DivSectionWithHeader">
                        <div class="Heading"><span class="Text">我的服务台员工</span></div>
                        <div class="Content">
                            <table width="100%" cellspacing="2" cellpadding="0" border="0" class="ResourceTable">
                                <tbody>
                                    <tr>
                                        <td>ds, liude</td>
                                        <td class="ResourceOfficePhone">x</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" title="Click to Send E-Mail" style="padding-bottom: 3px;"><a href="mailto:397906180@qq.com">397906180@qq.com</a></td>
                                    </tr>
                                    <!-- display horizontal rule -->
                                    <tr>
                                        <td colspan="3"></td>
                                    </tr>

                                    <tr>
                                        <td>Li, Hong, xiaojie</td>
                                        <td class="ResourceOfficePhone">12345678 x1212</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" title="Click to Send E-Mail" style="padding-bottom: 3px;"><a href="mailto:hong.li@itcat.net.cn">hong.li@itcat.net.cn</a></td>
                                    </tr>
                                    <!-- display horizontal rule -->
                                    <tr>
                                        <td colspan="3"></td>
                                    </tr>

                                    <tr>
                                        <td>li, li</td>
                                        <td class="ResourceOfficePhone">x</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" title="Click to Send E-Mail" style="padding-bottom: 3px;"><a href="mailto:liude2@hotmail.com">liude2@hotmail.com</a></td>
                                    </tr>
                                    <!-- display horizontal rule -->
                                    <tr>
                                        <td colspan="3"></td>
                                    </tr>

                                    <tr>
                                        <td>liu, liu</td>
                                        <td class="ResourceOfficePhone">x</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" title="Click to Send E-Mail" style="padding-bottom: 3px;"><a href="mailto:liude2@hotmail.com">liude2@hotmail.com</a></td>
                                    </tr>
                                    <!-- display horizontal rule -->
                                    <tr>
                                        <td colspan="3"></td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>
                    </div>

                </td>
            </tr>
        </tbody>
    </table>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    function ToRecurringTicket(type, date) {
        location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_SEARCH %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TICKET_SEARCH %>&param1=" + type + "&param2=" + date +"&param3=SearchNow";
    }
</script>
