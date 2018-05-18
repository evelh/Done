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
    <div class="header">服务台仪表板-<%=LoginUser.name %></div>
     <div class="header-title" style="width: 480px;">
         <ul>
             <li><img src="../Images/print.png"/></li>
             <li style="border: 0px;background: linear-gradient(to bottom,#fff 0,#fff 100%);">
                 <span>刷新：</span>
                    <select id="queryType" style="height:24px">
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
                        <span>*Note - the numbers on this page do not reflect recurring tickets unless otherwise noted
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <td width="52%" valign="top">
                    <!-- THIS IS THE LEFT SIDE TABLES -->
                    <div class="DivSectionWithHeader">
                        <div class="Heading"><span class="Text">My Service Desk Summary</span></div>
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
                                                        <td style="text-align: right; vertical-align: top;" class="FieldLabels">Overview<p>
                                                            <img src="../Images/ico_service_dash_overview.png" /></p>
                                                        </td>
                                                        <td></td>
                                                        <td width="98%">
                                                            <table width="100%" cellspacing="0" cellpadding="3" border="0" id="tblOverview">
                                                                <tbody>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%">Tickets Due <a class="PrimaryLink" href="#" onclick="Search('SearchTicketsDueToday')">Today</a> (0) | <a class="PrimaryLink" id="errorSmall" href="#" onclick="Search('SearchTicketsOverdue')">Overdue</a> (84)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%">Tickets Submitted <a class="PrimaryLink" href="#" onclick="Search('SearchTicketsSubmittedToday')">Today</a> (1) | <a class="PrimaryLink" href="#" onclick="Search('SearchTicketsSubmittedYesterday')">Yesterday</a> (0)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%">Tickets Completed <a class="PrimaryLink" href="#" onclick="Search('SearchTicketsCompletedToday')">Today</a> (0) | <a class="PrimaryLink" href="#" onclick="Search('SearchTicketsCompletedYesterday')">Yesterday</a> (0)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td width="1%" align="right"></td>
                                                                        <td width="99%"><a class="PrimaryLink" href="#" onclick="Search('SearchUnassignedTickets')">Unassigned Tickets</a> (32)</td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td align="right"></td>
                                                                        <td><a class="PrimaryLink" href="#" onclick="resUtilReport();">Workload Report</a></td>
                                                                    </tr>
                                                                    <tr valign="top">
                                                                        <td align="right"></td>
                                                                        <td><a class="PrimaryLink" href="#" onclick="openReportPage();">Other Reports</a></td>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Priority</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_priority.png" />                                                                                </p>
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
                                                                            Priority</td>
                                                                        <td style="white-space: nowrap;" align="center" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            New</td>
                                                                        <td style="white-space: nowrap;" align="center" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Open</td>
                                                                        <td style="" align="center" class="FieldLabels">
                                                                            <br>
                                                                            Average<br>
                                                                            Duration<br>
                                                                            (Days)</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color9 ColorText">Critical</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPriority?PriorityId=4')">28</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByPriority?PriorityId=4')">48</a></td>
                                                                        <td align="center" id="txtBlack8">25</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color13 ColorText">High</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPriority?PriorityId=1')">8</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByPriority?PriorityId=1')">26</a></td>
                                                                        <td align="center" id="txtBlack8">47</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color3 ColorText">Medium</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPriority?PriorityId=2')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByPriority?PriorityId=2')">5</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Low</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPriority?PriorityId=3')">6</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByPriority?PriorityId=3')">7</a></td>
                                                                        <td align="center" id="txtBlack8">1</td>
                                                                    </tr>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Status</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p><img src="../Images/ico_service_dash_ticket_status.png" />
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
                                                                            Status</td>
                                                                        <td style="white-space: nowrap;" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Total</td>
                                                                        <td style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Critical</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="3">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color19 ColorText">New</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=1')">43</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=1')">28</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Waiting Approval</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=13')">16</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=13')">8</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Dispatched</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=10')">17</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=10')">7</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Change Order</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=15')">3</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=15')">1</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color1 ColorText">In Progress</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=8')">3</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=8')">2</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Escalate</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=11')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=11')">0</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Waiting Materials</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=9')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=9')">0</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Waiting Customer</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=7')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=7')">0</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Waiting Vendor</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=12')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=12')">1</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Customer Note Added</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=19')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=19')">1</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">On Hold</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=17')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=17')">0</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color34 ColorText">Billed</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=14')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=14')">0</a></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><span class="ColorSwatch Color1 ColorText">Inactive</span></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchTotalTicketsByStatus?StatusId=16')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByStatus?StatusId=16')">0</a></td>
                                                                    </tr>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Primary Resource</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="text-align: right;">
                                                                            <p>
                                                                                <img src="../Images/ico_service_dash_ticket_resource.png" /                                                                                </p>
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
                                                                            Resource Name</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            New</td>
                                                                        <td align=" center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Open</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Critical</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Average<br>
                                                                            Duration<br>
                                                                            (Days)</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><i>none</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPrimaryResource?PrimaryResourceId=')">23</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByPrimaryResource?PrimaryResourceId=')">32</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByPrimaryResource?PrimaryResourceId=')">18</a></td>
                                                                        <td align="center" id="txtBlack8">4</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">ds, liude</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPrimaryResource?PrimaryResourceId=29682886')">5</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOPenTicketsByPrimaryResource?PrimaryResourceId=29682886')">6</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByPrimaryResource?PrimaryResourceId=29682886')">2</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Li, Hong, xiaojie</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPrimaryResource?PrimaryResourceId=29682885')">6</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOPenTicketsByPrimaryResource?PrimaryResourceId=29682885')">31</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByPrimaryResource?PrimaryResourceId=29682885')">15</a></td>
                                                                        <td align="center" id="txtBlack8">54</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">li, li</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPrimaryResource?PrimaryResourceId=29682887')">3</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOPenTicketsByPrimaryResource?PrimaryResourceId=29682887')">9</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByPrimaryResource?PrimaryResourceId=29682887')">7</a></td>
                                                                        <td align="center" id="txtBlack8">6</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">liu, liu</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByPrimaryResource?PrimaryResourceId=29682888')">6</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOPenTicketsByPrimaryResource?PrimaryResourceId=29682888')">8</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByPrimaryResource?PrimaryResourceId=29682888')">6</a></td>
                                                                        <td align="center" id="txtBlack8">149</td>
                                                                    </tr>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Issue Type</td>
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
                                                                            Issue Type</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            New</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Open</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Critical</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Average<br>
                                                                            Duration<br>
                                                                            (Days)</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8"><i>none</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByIssueType?IssueTypeId=')">10</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByIssueType?IssueTypeId=')">11</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByIssueType?IssueTypeId=')">11</a></td>
                                                                        <td align="center" id="txtBlack8">29</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8">Break/Fix</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByIssueType?IssueTypeId=12')">14</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByIssueType?IssueTypeId=12')">30</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByIssueType?IssueTypeId=12')">20</a></td>
                                                                        <td align="center" id="txtBlack8">28</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8">Computer</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByIssueType?IssueTypeId=10')">18</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByIssueType?IssueTypeId=10')">40</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByIssueType?IssueTypeId=10')">16</a></td>
                                                                        <td align="center" id="txtBlack8">27</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8">Maintenance</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByIssueType?IssueTypeId=13')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByIssueType?IssueTypeId=13')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByIssueType?IssueTypeId=13')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8">Network</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByIssueType?IssueTypeId=11')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByIssueType?IssueTypeId=11')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByIssueType?IssueTypeId=11')">0</a></td>
                                                                        <td align="center" id="txtBlack8">41</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8">New Install</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByIssueType?IssueTypeId=15')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByIssueType?IssueTypeId=15')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByIssueType?IssueTypeId=15')">1</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="txtBlack8">Upgrade</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByIssueType?IssueTypeId=4')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByIssueType?IssueTypeId=4')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByIssueType?IssueTypeId=4')">0</a></td>
                                                                        <td align="center" id="txtBlack8">17</td>
                                                                    </tr>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Source</td>
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
                                                                            Source</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            New</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Open</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Critical</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Average<br>
                                                                            Duration<br>
                                                                            (Days)</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><i>none (no sourceid)</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsBySource?SourceId=')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsBySource?SourceId=')">3</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsBySource?SourceId=')">3</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Client Portal</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsBySource?SourceId=-1')">5</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsBySource?SourceId=-1')">6</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsBySource?SourceId=-1')">2</a></td>
                                                                        <td align="center" id="txtBlack8">43</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Email</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsBySource?SourceId=4')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsBySource?SourceId=4')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsBySource?SourceId=4')">0</a></td>
                                                                        <td align="center" id="txtBlack8">17</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Insourced</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsBySource?SourceId=-2')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsBySource?SourceId=-2')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsBySource?SourceId=-2')">1</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Phone</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsBySource?SourceId=2')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsBySource?SourceId=2')">4</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsBySource?SourceId=2')">2</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Verbal</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsBySource?SourceId=11')">29</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsBySource?SourceId=11')">64</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsBySource?SourceId=11')">33</a></td>
                                                                        <td align="center" id="txtBlack8">14</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Voice Mail</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsBySource?SourceId=1')">6</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsBySource?SourceId=1')">7</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsBySource?SourceId=1')">7</a></td>
                                                                        <td align="center" id="txtBlack8">305</td>
                                                                    </tr>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Classification</td>
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
                                                                            Classification</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            New</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Open</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Critical</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Average<br>
                                                                            Duration<br>
                                                                            (Days)</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/custdata/701696/images/bronze_managed_service.jpg?v=49725" border="0" hspace="0" vspace="0" alt="Bronze" managed="" service="">&nbsp;&nbsp;Bronze Managed Service</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=16')">13</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=16')">28</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=16')">15</a></td>
                                                                        <td align="center" id="txtBlack8">11</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/custdata/701696/images/platinum_managed_service.jpg?v=49725" border="0" hspace="0" vspace="0" alt="Platinum" managed="" service="">&nbsp;&nbsp;Platinum Managed Service</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=18')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=18')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=18')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/custdata/701696/images/hosted_service.png?v=49725" border="0" hspace="0" vspace="0" alt="Hosted" service="">&nbsp;&nbsp;Hosted Service</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=19')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=19')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=19')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/custdata/701696/images/silver_managed_service.jpg?v=49725" border="0" hspace="0" vspace="0" alt="Silver" managed="" service="">&nbsp;&nbsp;Silver Managed Service</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=17')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=17')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=17')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/images/icons/classification/blockhour_icon.png?v=49725" border="0" hspace="0" vspace="0" alt="Block" hour="" client="">&nbsp;&nbsp;Block Hour Client</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=5')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=5')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=5')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/custdata/701696/images/gold_managed_service.jpg?v=49725" border="0" hspace="0" vspace="0" alt="Gold" managed="" service="">&nbsp;&nbsp;Gold Managed Service</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=15')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=15')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=15')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/images/icons/classification/target_icon.png?v=49725" border="0" hspace="0" vspace="0" alt="Target">&nbsp;&nbsp;Target</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=7')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=7')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=7')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/images/icons/classification/cancellation_icon.png?v=49725" border="0" hspace="0" vspace="0" alt="Canceled">&nbsp;&nbsp;Canceled</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=9')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=9')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=9')">0</a></td>
                                                                        <td align="center" id="txtBlack8">248</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/images/icons/classification/delinquent.png?v=49725" border="0" hspace="0" vspace="0" alt="Delinquent">&nbsp;&nbsp;Delinquent</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=10')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=10')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=10')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/images/icons/classification/tm.png?v=49725" border="0" hspace="0" vspace="0" alt="T&amp;M">&nbsp;&nbsp;T&amp;M</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=12')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=12')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=12')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/images/icons/classification/residential.png?v=49725" border="0" hspace="0" vspace="0" alt="Residential">&nbsp;&nbsp;Residential</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=13')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=13')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=13')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/images/icons/classification/jeopardyaccount.png?v=49725" border="0" hspace="0" vspace="0" alt="Jeopardy" company="">&nbsp;&nbsp;Jeopardy Company</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=14')">12</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=14')">33</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=14')">18</a></td>
                                                                        <td align="center" id="txtBlack8">30</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" align="left" id="txtBlack8">
                                                                            <img src="/CustData/701696/images/d2da1392684e4fe1bcb8e769af6a08a5.jpg?v=49725" border="0" hspace="0" vspace="0" alt="a">&nbsp;&nbsp;a</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByClassification?ClassificationId=200')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByClassification?ClassificationId=200')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByClassification?ClassificationId=200')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Product</td>
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
                                                                            Product Name</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            New</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Open</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Critical</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Average<br>
                                                                            Duration<br>
                                                                            (Days)</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><i>none</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByInstalledProduct?ProductId=')">39</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByInstalledProduct?ProductId=')">72</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByInstalledProduct?ProductId=')">41</a></td>
                                                                        <td align="center" id="txtBlack8">29</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">22+22</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByInstalledProduct?ProductId=29682884')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByInstalledProduct?ProductId=29682884')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByInstalledProduct?ProductId=29682884')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">AC</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByInstalledProduct?ProductId=29682887')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByInstalledProduct?ProductId=29682887')">3</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByInstalledProduct?ProductId=29682887')">2</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Clavister E7 Remote</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByInstalledProduct?ProductId=29682882')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByInstalledProduct?ProductId=29682882')">8</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByInstalledProduct?ProductId=29682882')">5</a></td>
                                                                        <td align="center" id="txtBlack8">6</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Hub</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByInstalledProduct?ProductId=29682878')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByInstalledProduct?ProductId=29682878')">1</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByInstalledProduct?ProductId=29682878')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
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
                                                                        <td style="text-align: right; vertical-align: bottom; height: 60px;" class="FieldLabels">Tickets by Queue</td>
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
                                                                            Queue Name</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            New</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Open</td>
                                                                        <td align="center" style="white-space: nowrap" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Critical</td>
                                                                        <td align="center" style="" class="FieldLabels">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="60" height="1"><br>
                                                                            Average<br>
                                                                            Duration<br>
                                                                            (Days)</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="5">
                                                                            <hr>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8"><i>none</i></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByQueue?QueueId=')">5</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByQueue?QueueId=')">10</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByQueue?QueueId=')">6</a></td>
                                                                        <td align="center" id="txtBlack8">104</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Administration</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByQueue?QueueId=29683378')">12</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByQueue?QueueId=29683378')">24</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByQueue?QueueId=29683378')">14</a></td>
                                                                        <td align="center" id="txtBlack8">38</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Client Portal</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByQueue?QueueId=5')">12</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByQueue?QueueId=5')">27</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByQueue?QueueId=5')">12</a></td>
                                                                        <td align="center" id="txtBlack8">29</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Level I Support</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByQueue?QueueId=29682833')">3</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByQueue?QueueId=29682833')">8</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByQueue?QueueId=29682833')">3</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Monitoring Alert</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByQueue?QueueId=8')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByQueue?QueueId=8')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByQueue?QueueId=8')">0</a></td>
                                                                        <td align="center" id="txtBlack8">5</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Post Sale</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByQueue?QueueId=6')">11</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByQueue?QueueId=6')">13</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByQueue?QueueId=6')">13</a></td>
                                                                        <td align="center" id="txtBlack8">29</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td style="padding-right: 10px;" id="txtBlack8">Recurring Tickets</td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchNewTicketsByQueue?QueueId=29683354')">0</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchOpenTicketsByQueue?QueueId=29683354')">2</a></td>
                                                                        <td align="center" id="txtBlack8"><a class="PrimaryLink" href="#" onclick="Search('SearchCriticalTicketsByQueue?QueueId=29683354')">0</a></td>
                                                                        <td align="center" id="txtBlack8">0</td>
                                                                    </tr>
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
                        <div class="Heading"><span class="Text">My Ticket Resolution Performance</span></div>
                        <div class="Content">
                            <table width="100%">
                                <tbody>
                                    <tr>
                                        <td>
                                            <table border="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3" class="FieldLabels">Maximum Average Age for Critical Tickets</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" width="100%">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" id="txtBlack8" title="Current Performance">&nbsp;<b>23</b>&nbsp;</td>
                                                                        <td width="50%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Average Age for Critical Tickets">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Average Age for Critical Tickets ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Average Age for Critical Tickets  ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" title="Performance Metric Goal">&nbsp;<b>3</b>&nbsp;</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table border="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3" class="FieldLabels">Maximum Open Critical Tickets</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" width="100%">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" id="txtBlack8" title="Current Performance">&nbsp;<b>48</b>&nbsp;</td>
                                                                        <td width="50%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Open Critical Tickets">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Open Critical Tickets ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Open Critical Tickets  ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" title="Performance Metric Goal">&nbsp;<b>12</b>&nbsp;</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table border="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3" class="FieldLabels">Maximum Open Tickets</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" width="100%">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" id="txtBlack8" title="Current Performance">&nbsp;<b>86</b>&nbsp;</td>
                                                                        <td width="50%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Open Tickets">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Open Tickets ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Open Tickets  ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" title="Performance Metric Goal">&nbsp;<b>35</b>&nbsp;</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table border="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3" class="FieldLabels">Maximum New Tickets</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" width="100%">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" id="txtBlack8" title="Current Performance">&nbsp;<b>43</b>&nbsp;</td>
                                                                        <td width="50%">
                                                                            <table bgcolor="#8DC63F" width="28.6666666666667%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum New Tickets">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="1"></td>
                                                                        <td width="25%">
                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="1"></td>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" title="Performance Metric Goal">&nbsp;<b>300</b>&nbsp;</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <p></p>
                                            <table border="0" width="100%">
                                                <tbody>
                                                    <tr>
                                                        <td colspan="3" class="FieldLabels">Maximum Average Tickets per Resource</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <table border="1" bordercolor="#CCCCCC" cellpadding="0" cellspacing="0" width="100%">
                                                                <tbody>
                                                                    <tr>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" id="txtBlack8" title="Current Performance">&nbsp;<b>13</b>&nbsp;</td>
                                                                        <td width="50%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Average Tickets per Resource">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="100%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Average Tickets per Resource ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td width="25%">
                                                                            <table bgcolor="#FF4863" width="46.6666666666667%">
                                                                                <tbody>
                                                                                    <tr>
                                                                                        <td title="Maximum Average Tickets per Resource  ">
                                                                                            <img src="/images/clearPixel.gif?v=49725" width="1" height="12"></td>
                                                                                    </tr>
                                                                                </tbody>
                                                                            </table>
                                                                        </td>
                                                                        <td bgcolor="#E9E9E9" style="color: #4F4F4F" align="center" width="1%" title="Performance Metric Goal">&nbsp;<b>15</b>&nbsp;</td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
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
                    <p>
                    </p>
                    <div class="DivSectionWithHeader">
                        <div class="Heading"><span class="Text">Recurring Tickets</span></div>
                        <div class="Content">
                            <table width="100%" cellspacing="0" cellpadding="3" border="0" id="Table2">
                                <tbody>
                                    <tr valign="top">
                                        <td style="padding-bottom: 5px;">Due <a class="PrimaryLink" href="#" onclick="Search('SearchRecurringTicketsDueToday')">Today</a> (0) | <a class="PrimaryLink" id="errorSmall" href="#" onclick="Search('SearchRecurringTicketsOverdue')">Overdue</a> (51)</td>
                                    </tr>
                                    <tr valign="top">
                                        <td>Completed <a class="PrimaryLink" href="#" onclick="Search('SearchRecurringTicketsCompletedToday')">Today</a> (0) | <a class="PrimaryLink" href="#" onclick="Search('SearchRecurringTicketsCompletedYesterday')">Yesterday</a> (0)</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <p>
                    </p>
                    <div class="DivSectionWithHeader">
                        <div class="Heading"><span class="Text">My Service Desk Resources</span></div>
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

</script>
