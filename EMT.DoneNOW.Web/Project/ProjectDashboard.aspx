<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectDashboard.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/crmDashboard.css" rel="stylesheet" />
    <title></title>
    <style>
        a#link12 {
    color: #376597;
    font-size: 12px;
    text-decoration: none;
}
    </style>
</head>
<body>
    <div class="header">项目仪表板-<span id="SelectTypeSpan"><%=LoginUser.name %></span>-<%=DateTime.Now.ToString("yyyy-MM-dd") %> <%=weekName[(int)DateTime.Now.DayOfWeek] %></div>
    <table align="left" cellspacing="0" cellpadding="0" border="0" style="padding-left: 10px; padding-right: 10px; padding-top: 6px;" width="945">
        <tbody>
            <tr>
                <td width="50%" align="center" valign="top">
                    <div class="DivSectionWithHeader">
                        <div class="Heading" style="text-align: left;"><span class="Text">我的项目摘要</span></div>
                        <div class="Content">
                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                <tbody>
                                    <tr>
                                        <td valign="top" style="text-align: right;" width="30%">
                                            <table width="100%" cellspacing="0" cellpadding="3" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">团队最后期限</td>
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
                                                        <td id="linkTd">截止日期<a style="margin-left: 4px; margin-right: 4px;" id="link12" onclick="showWhatsDue('byday');">今天</a> | <a style="margin-left: 4px; margin-right: 4px;" id="link12" onclick="showWhatsDue('byweek');">这周</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" onclick="ShowOtherPage('overTask');">过期或可能超出预估时间的任务</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" onclick="showProjectProfitabilityForecastReport();">项目利润率预测报表</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" onclick="ShowOtherPage('myProject');">我是负责人的项目</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" onclick="ShowOtherPage('projectStatus');">项目组合状态报表</a></td>
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
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">员工</td>
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
                                                        <td id="linkTd">任务分配<a style="margin-left: 4px; margin-right: 4px;" id="link12" onclick="ShowOtherPage('againRes');">员工</a> | <a id="link12" style="margin-left: 4px; margin-right: 4px;" onclick="ShowOtherPage('againProject');">项目</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showWorkloadReport();">工作量报表</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" onclick="ShowOtherPage('moneyDate');">员工带薪休假日程</a></td>
                                                    </tr>
                                                    <tr style="display:none;">
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
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">已完成</td>
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
                                                        <td id="linkTd"><a id="link12" onclick="showDailyStatusReport();">每日状态报表</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" onclick="showWorktoApprove();">待审批的工作</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" onclick="ShowOtherPage('resAchievements');">员工绩效分析与评估</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showProjectSummaryReport();">项目利润率摘要报表</a></td>
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
                                                        <td id="txtblue10" style="text-align: right;" class="FieldLabels">管理</td>
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
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showTimesheetDueIn();">工时表还有<%=6-(int)DateTime.Now.DayOfWeek %>天截止</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showTimesheetstoApprove();">待审批的工时表</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showExpenseReportstoApprove();">待审批的费用报表</a></td>
                                                    </tr>
                                                    <tr>
                                                        <td id="linkTd"><a id="link12" href="#" onclick="showMissingTimesheets();">遗漏工时表</a></td>
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
                        <div class="Heading" style="text-align: left;"><span class="Text">我的项目问题</span></div>
                        <div class="Content" style="padding-left: 6px; padding-right: 20px;">

                            <table width="100%" cellspacing="3" cellpadding="0" border="0">
                                <tbody>
                                    <tr style="cursor: pointer;" onclick="showMyIssues();">
                                        <td width="22px">
                                            <img src="../Images/alert.png" /></td>
                                        <td style="border-bottom: 1px solid #d3d3d3;">打开问题</td>
                                        <td style="border-bottom: 1px solid #d3d3d3; text-align: right;">8</td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                    </div>

                    <div class="DivSectionWithHeader">
                        <div class="Heading" style="text-align: left;"><span class="Text">我的项目</span></div>
                        <div class="Content" style="padding-left: 6px; padding-right: 20px;">

                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="margin-top: 6px; margin-bottom: 6px">
                                <tbody>
                                    <tr>
                                        <td colspan="3" class="FieldLabels">负责人</td>
                                    </tr>
                                </tbody>
                            </table>
                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="padding-left: 22px">

                                <tbody>
                                    <tr>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px;">项目名称</td>
                                        <td width="20%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">剩余时间</td>
                                        <td width="25%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">完成百分比</td>
                                    </tr>

                                  <% if (myProjectList != null && myProjectList.Count > 0) {
                                          foreach (var myProject in myProjectList)
                                          {
                                              var thisVp = vpDal.GetById(myProject.id);
                                              if (thisVp == null)
                                                  continue;
                                              %>
                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a onclick="openProject('<%=myProject.id %>')"><%=myProject.name %></a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall"><%=(thisVp.remain_days??0) %></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;"><%=proBll.CompleteTaskPercent(myProject.id).ToString("#0.00") %>%</td>
                                    </tr>
                                         <% }
                                      } %>

                                    

                                    <tr height="10">
                                        <td colspan="3"></td>
                                    </tr>
                                </tbody>
                            </table>

                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="margin-top: 6px; margin-bottom: 6px">
                                <tbody>
                                    <tr>

                                        <td colspan="3" class="FieldLabels">团队成员</td>

                                    </tr>
                                </tbody>
                            </table>
                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="padding-left: 22px">

                                <tbody>
                                     <tr>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px;">项目名称</td>
                                        <td width="20%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">剩余时间</td>
                                        <td width="25%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">完成百分比</td>
                                    </tr>

                                  <% if (myTeamProjectList != null && myTeamProjectList.Count > 0) {
                                          foreach (var myProject in myTeamProjectList)
                                          {
                                              var thisVp = vpDal.GetById(myProject.id);
                                              if (thisVp == null)
                                                  continue;
                                              %>
                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a  onclick="openProject('<%=myProject.id %>')"><%=myProject.name %></a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall"><%=(thisVp.remain_days??0) %></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;"><%=proBll.CompleteTaskPercent(myProject.id).ToString("#0.00") %>%</td>
                                    </tr>
                                         <% }
                                      } %>


                                    <tr height="10">
                                        <td colspan="3"></td>
                                    </tr>
                                </tbody>
                            </table>

                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="margin-top: 6px; margin-bottom: 6px">
                                <tbody>
                                    <tr>

                                        <td colspan="3" class="FieldLabels">部门</td>

                                    </tr>
                                </tbody>
                            </table>
                            <table width="100%" cellspacing="3" cellpadding="0" border="0" style="padding-left: 22px">
                                <tbody>
                                    <tr>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px;">项目名称</td>
                                        <td width="20%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">剩余时间</td>
                                        <td width="25%" valign="bottom" class="FieldLabels" style="text-align: right; padding-bottom: 2px;">完成百分比</td>
                                    </tr>
                                    
                                  <% if (myDepProjectList != null && myDepProjectList.Count > 0) {
                                          foreach (var myProject in myDepProjectList)
                                          {
                                              var thisVp = vpDal.GetById(myProject.id);
                                              if (thisVp == null)
                                                  continue;
                                              %>
                                    <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;"><a onclick="openProject('<%=myProject.id %>')"><%=myProject.name %></a></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;" id="errorSmall"><%=(thisVp.remain_days??0) %></td>
                                        <td style="border-top: 1px solid #d3d3d3; text-align: right; padding-top: 3px; padding-bottom: 2px;"><%=proBll.CompleteTaskPercent(myProject.id).ToString("#0.00") %>%</td>
                                    </tr>
                                         <% }
                                      } %>
                                    <tr height="10">
                                        <td colspan="3"></td>
                                    </tr>
                                </tbody>
                            </table>

                        </div>
                    </div>

                    <div class="DivSectionWithHeader">
                        <div class="Heading" style="text-align: left;"><span class="Text">我的项目员工</span></div>
                        <div class="Content" style="padding-right: 20px;">
                            <table width="100%" cellspacing="2" cellpadding="0" border="0">
                                <tbody>
                                    <tr>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px;">员工姓名</td>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px; padding-left: 10px;">办公电话</td>
                                        <td valign="bottom" class="FieldLabels" style="padding-bottom: 2px; padding-left: 10px;">邮件地址</td>
                                    </tr>
                                    <%if (resList != null && resList.Count > 0) {
                                            foreach (var res in resList)
                                            {%>
                                     <tr>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; word-break: break-all;" title="Click for Resource Properties"><a id="link12" href="#" onclick="javascript:openResource('4');"><%=res.name %></a></td>
                                        <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;"><%=res.office_phone %></td>
                                         <td style="border-top: 1px solid #d3d3d3; padding-top: 3px; padding-bottom: 2px; padding-left: 10px;" title="Click to Send E-Mail"><a id="link12" href="mailto:<%=res.email %>">
                                            <img style="vertical-align: middle;" src="../Images/email.png" width="16" height="16" border="0" alt="Click to Send E-Mail">&nbsp;&nbsp;<%=res.email %></a></td>
                                    </tr>
                                           <% }
                                        } %>
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
    function openProject(projectId) {
        window.open("../Project/ProjectView.aspx?id=" + projectId, '_blank', 'left=200,top=200,width=900,height=800', false);
    }
    function showWhatsDue(type) {
        var url = "ProjectClosingReport?isAll=1";
        if (type == "byweek") {
            url += "&isSeven=1";
        }
        location.href = url;
    }

    function ShowOtherPage(type) {
        if (type == "overTask") {
            location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_OVER_TASK %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_DASHBOARD_OVER_TASK %>";
        }
        else if (type == "myProject"){
            location.href = "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_MY_PROJECT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_DASHBOARD_MY_PROJECT %>&con3989=<%=LoginUserId %>";
        }
        else if (type == "projectStatus") {
            location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_PROJECT_STATUS %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_DASHBOARD_PROJECT_STATUS %>";
        }
        else if (type == "againRes") {
            location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_AGAIN_RESOURCE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_DASHBOARD_AGAIN_RESOURCE %>";
        }
        else if (type == "againProject") {
            location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_AGAIN_PROJECT %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_DASHBOARD_AGAIN_PROJECT %>";
        }
        else if (type == "moneyDate") {
            location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PROJECT_DASHBOARD_MONEY_DATE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_DASHBOARD_MONEY_DATE %>";
        }
        else if (type == "resAchievements") {
            location.href = "../Common/SearchFrameSet?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_TASK_RES_ACHIEVEMENTS %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.REPORT_PROJECT_TASK_RES_ACHIEVEMENTS %>";
        }
        else if (type == "") {

        }
        else if (type == "") {

        }
        else if (type == "") {


        }
        else if (type == "") {

        }
        
    }

</script>
