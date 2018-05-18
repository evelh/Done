<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectDashboard.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/crmDashboard.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <div class="header">项目仪表板-<span id="SelectTypeSpan"><%=LoginUser.name %></span>-<%=DateTime.Now.ToString("yyyy-MM-dd") %> <%=weekName[(int)DateTime.Now.DayOfWeek] %></div>
    <table align="left" cellspacing="0" cellpadding="0" border="0" style="padding-left: 10px; padding-right: 10px; padding-top: 6px;" width="945">
        <tbody>
            <tr>
                <td width="50%" align="center" valign="top">
                    <div class="DivSectionWithHeader">
                        <div class="Heading" style="text-align: left;"><span class="Text">My Projects Summary</span></div>
                        <div class="Content">
                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                <tbody>
                                    <tr>
                                        <td valign="top" style="text-align: right;" width="30%">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">Team Deadlines &amp; Due Dates</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right; padding-top: 11px;">
                                                            <img src="../Images/dashboard_deadline.png" /></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td valign="top" width="70%" style="padding-left: 15px">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="linkTd">What's Due <a style="margin-left: 4px; margin-right: 4px;" id="link12" href="#" onclick="showWhatsDue('byday');">Today</a> | <a style="margin-left: 4px; margin-right: 4px;" id="link12" href="#" onclick="showWhatsDue('byweek');">This Week</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showAtRiskTasks();">Overdue Tasks or At-Risk of Exceeding Estimate</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showProjectProfitabilityForecastReport();">Project Profitability Forecast</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showMyLeadProjects();">Projects Where I Am the Project Lead</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showProjectPortfolioReport();">Project Portfolio Status</a></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- this begins the next set -->
                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                <!-- this is just a spacer -->
                                <tbody>
                                    <tr height="10">
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" style="text-align: right;" width="30%">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">Resources</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right;">
                                                              <img src="../Images/dashboard_assignments.png" />
                                                            </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                        <td valign="top" width="70%" style="padding-left: 15px">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="linkTd">Assignments by <a style="margin-left: 4px; margin-right: 4px;" id="link12" href="#" onclick="showAssignmentsBy('resource');">Resource</a> | <a id="link12" style="margin-left: 4px; margin-right: 4px;" href="#" onclick="showAssignmentsBy('project');">Project</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showWorkloadReport();">Workload Report</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showResourceUtilizationReport();">Resource Utilization Detail Report (retired)</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showVacationSchedule();">Vacation Schedule for My Resources</a></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- this begins the next set -->
                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                <!-- this is just a spacer -->
                                <tbody>
                                    <tr height="10">
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" style="text-align: right;" width="30%">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">Completed</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right; padding-top: 5px;">
                                                            <img src="../Images/dashboard_completed.png" />
                                                            </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>

                                        <td valign="top" width="70%" style="padding-left: 15px">

                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showDailyStatusReport();">Daily Status Report</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showWorktoApprove();">Work Ready to Approve</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showResourcePerformanceReport();">Analyze Individual Performance vs Estimate</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showProjectSummaryReport();">Project Profitability Summary Report</a></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- this begins the next set -->
                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                <!-- this is just a spacer -->
                                <tbody>
                                    <tr height="10">
                                        <td colspan="2"></td>
                                    </tr>
                                    <tr>
                                        <td valign="top" style="text-align: right;" width="30%">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">Administration</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right; padding-top: 5px;">
                                                            <img src="../Images/dashboard_administration.png" />
                                                            </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>

                                        <td valign="top" width="70%" style="padding-left: 15px">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">

                                                <tbody>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showTimesheetDueIn();">Timesheet Due in 4 Day(s)</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showTimesheetstoApprove();">Timesheets to Approve</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showExpenseReportstoApprove();">Expense Reports to Approve</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showMissingTimesheets();">Unsubmitted / Missing Timesheets</a></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </td>

                <!-- this is the right side bar tables -->
                <td width="50%" align="center" valign="top">

                    <div class="DivSectionWithHeader">
                        <div class="Heading" style="text-align: left;"><span class="Text">My Project Issues</span></div>
                        <div class="Content" style="padding-left: 6px; padding-right: 20px;">

                            <table width="100%" cellspacing="3" cellpadding="0" border="0">
                                <tbody>
                                    <tr style="cursor: pointer;" onclick="showMyIssues();">
                                        <td width="22px">
                                            <img src="/images/icons/icn_issue.png?v=49725"></td>
                                        <td style="border-bottom: 1px solid #d3d3d3;">Open Issues</td>
                                        <td style="border-bottom: 1px solid #d3d3d3; text-align: right;">8</td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                    </div>

                    <div class="DivSectionWithHeader">
                        <div class="Heading" style="text-align: left;"><span class="Text">My Projects</span></div>
                        <div class="Content" style="padding-left: 6px; padding-right: 20px;">

                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="margin-top: 6px; margin-bottom: 6px">
                                <tbody>
                                    <tr>

                                        <td colspan="3" class="FieldLabels">Lead</td>

                                    </tr>
                                </tbody>
                            </table>
                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="padding-left: 22px">

                                <tbody>
                                    <tr>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px;">Project Name</td>
                                        <td width="20%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">Remaining Days</td>
                                        <td width="25%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">% Complete - Tasks</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="">????? (SDDDDDD)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-121</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="">0105test (111111)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-125</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="">1222ProTesr (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-143</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('72')">13112 (test01)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-138</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('68')">20171205Test (02170918)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-155</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('64')">myTest1113 (02170918)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-182</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('53')">project_abc_sub-110601 (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-189</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('66')">project_abc_sub-1115 (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-180</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('70')">proporal (02170918)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-150</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('77')">tmpl_20180306 (chaho)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-45</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('78')">tmpl_20180306-2 (Burberry)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-41</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr height="10">
                                        <td colspan="3"></td>
                                    </tr>
                                </tbody>
                            </table>

                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="margin-top: 6px; margin-bottom: 6px">
                                <tbody>
                                    <tr>

                                        <td colspan="3" class="FieldLabels">Team Member</td>

                                    </tr>
                                </tbody>
                            </table>
                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="padding-left: 22px">

                                <tbody>
                                    <tr>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px;">Project Name</td>
                                        <td width="20%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">Remaining Days</td>
                                        <td width="25%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">% Complete - Tasks</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('74')">????? (SDDDDDD)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-121</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('73')">0105test (111111)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-125</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('71')">1222ProTesr (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-143</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('72')">13112 (test01)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-138</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('68')">20171205Test (02170918)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-155</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('64')">myTest1113 (02170918)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-182</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('19')">p_abc_01 (abcdefg)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-152</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">24%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('28')">p_abc_sub_01 (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-405</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">6%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('33')">p_abc_sub_02 (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-110</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">71%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('53')">project_abc_sub-110601 (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-189</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('66')">project_abc_sub-1115 (abc_sub)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-180</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('70')">proporal (02170918)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-150</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('77')">tmpl_20180306 (chaho)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-45</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a id="link12" href="#" onclick="javascript:openProject('78')">tmpl_20180306-2 (Burberry)</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall">-41</td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;">0%</td>
                                    </tr>

                                    <tr height="10">
                                        <td colspan="3"></td>
                                    </tr>
                                </tbody>
                            </table>

                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="margin-top: 6px; margin-bottom: 6px">
                                <tbody>
                                    <tr>

                                        <td colspan="3" class="FieldLabels">Department</td>

                                    </tr>
                                </tbody>
                            </table>
                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="padding-left: 22px">

                                <tbody>
                                    <tr>

                                        <td id="errorSmall" colspan="3">No Department Projects Available.</td>

                                    </tr>

                                    <tr height="10">
                                        <td colspan="3"></td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                    </div>

                    <div class="DivSectionWithHeader">
                        <div class="Heading" style="text-align: left;"><span class="Text">My Project Resources</span></div>
                        <div class="Content" style="padding-right: 20px;">

                            <table width="100%" cellspacing="2" cellpadding="0" border="0">

                                <tbody>
                                    <tr>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px;">Resource Name</td>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px; padding-left: 10px;">Office Phone</td>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px; padding-left: 10px;">E-Mail Address</td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;" title="Click for Resource Properties"><a id="link12" href="#" onclick="javascript:openResource('4');">Administrator, Autotask</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;">(518) 720-3500 x</td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;" title="Click to Send E-Mail"><a id="link12" href="mailto:">
                                            <img style="vertical-align: middle;" src="/graphics/icons/menus/email.png?v=49725" width="16" height="16" border="0" alt="Click to Send E-Mail">&nbsp;&nbsp;</a></td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;" title="Click for Resource Properties"><a id="link12" href="#" onclick="javascript:openResource('29682886');">ds, liude</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;">x</td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;" title="Click to Send E-Mail"><a id="link12" href="mailto:397906180@qq.com">
                                            <img style="vertical-align: middle;" src="/graphics/icons/menus/email.png?v=49725" width="16" height="16" border="0" alt="Click to Send E-Mail">&nbsp;&nbsp;397906180@qq.com</a></td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;" title="Click for Resource Properties"><a id="link12" href="#" onclick="javascript:openResource('29682885');">Li, Hong, xiaojie</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;">12345678 x1212</td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;" title="Click to Send E-Mail"><a id="link12" href="mailto:hong.li@itcat.net.cn">
                                            <img style="vertical-align: middle;" src="/graphics/icons/menus/email.png?v=49725" width="16" height="16" border="0" alt="Click to Send E-Mail">&nbsp;&nbsp;hong.li@itcat.net.cn</a></td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;" title="Click for Resource Properties"><a id="link12" href="#" onclick="javascript:openResource('29682887');">li, li</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;">x</td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;" title="Click to Send E-Mail"><a id="link12" href="mailto:liude2@hotmail.com">
                                            <img style="vertical-align: middle;" src="/graphics/icons/menus/email.png?v=49725" width="16" height="16" border="0" alt="Click to Send E-Mail">&nbsp;&nbsp;liude2@hotmail.com</a></td>
                                    </tr>

                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;" title="Click for Resource Properties"><a id="link12" href="#" onclick="javascript:openResource('29682888');">liu, liu</a></td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;">x</td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;" title="Click to Send E-Mail"><a id="link12" href="mailto:liude2@hotmail.com">
                                            <img style="vertical-align: middle;" src="/graphics/icons/menus/email.png?v=49725" width="16" height="16" border="0" alt="Click to Send E-Mail">&nbsp;&nbsp;liude2@hotmail.com</a></td>
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
