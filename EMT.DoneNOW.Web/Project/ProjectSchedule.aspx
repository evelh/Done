<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSchedule.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSchedule" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/NewConfigurationItem.css" rel="stylesheet" />
    <link href="../Content/Project.css" rel="stylesheet" />
    <style>
        #useResource_daily_hours, #excludeHoliday, #excludeWeekend {
            vertical-align: middle;
        }

        #warnTime_off {
            vertical-align: middle;
            cursor: pointer;
        }

        .searchcontent {
            width: 100%;
            height: 100%;
            min-width: 2200px;
        }

            .searchcontent table th {
                background-color: #cbd9e4;
                border-color: #98b4ca;
                color: #64727a;
                height: 28px;
                line-height: 28px;
                text-align: center;
            }

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
        /*加载的css样式*/
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

        #LoadingIndicator {
            width: 100px;
            height: 100px;
            background-image: url(../Images/Loading.gif);
            background-repeat: no-repeat;
            background-position: center center;
            z-index: 30;
            margin: auto;
            position: absolute;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
            display: none;
        }
        /*加载的css样式(结尾)*/
        .HeadingRow {
            background-color: #98b4ca;
            border-bottom-style: solid;
            border-bottom-width: 1px;
            border-right-style: solid;
            border-right-width: 1px;
            font-size: 12px;
            font-weight: bold;
            height: 15px;
            padding: 3px 5px 3px 5px;
            word-wrap: break-word;
            border-bottom-color: #98b4ca;
            border-right-color: #98b4ca;
            color: #64727a;
        }

        .menu {
            border: 0px solid #d7d7d7;
        }

        a.Button {
            border: 0px solid #d7d7d7;
        }

        li.Button, a.Button {
            border: 0px solid #d7d7d7;
        }

        .issueTr td {
            background-color: #ffffff;
        }

        .taskTr td {
            background-color: #ffffff;
        }

        .phaseTr td {
            background-color: #f8f8f8;
        }

        .Section {
            border: 1px solid #d3d3d3;
            margin: 0 0 12px 0;
            padding: 4px 0 4px 0;
            width: 836px;
        }

        .cover {
            position: absolute;
            width: auto;
            height: auto;
            padding: 8px;
            border-radius: 3px;
            background: #eee;
            border: 1px solid #ccc;
            z-index: 999;
            display: none;
        }

        .border_left {
            width: 0;
            height: 0;
            border-width: 8px 0 8px 8px;
            border-style: solid;
            border-color: transparent transparent transparent #346a95; /*透明 透明 透明 灰*/
            position: absolute;
            display: none;
            left: 0;
            top: 0;
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

        .cover {
            position: absolute;
            width: auto;
            height: auto;
            padding: 8px;
            border-radius: 3px;
            background: #eee;
            border: 1px solid #ccc;
            z-index: 999;
            display: none;
        }

        .border_left {
            width: 0;
            height: 0;
            border-width: 8px 0 8px 8px;
            border-style: solid;
            border-color: transparent transparent transparent #346a95; /*透明 透明 透明 灰*/
            position: absolute;
            left: 0;
            top: 0;
            display: none;
        }

        .border_right {
            width: 0;
            height: 0;
            border-width: 8px 0 8px 8px;
            border-style: solid;
            transform: rotate(180deg);
            border-color: transparent transparent transparent #346a95; /*透明 透明 透明 灰*/
            position: absolute;
            right: 0;
            top: 0;
            display: none;
        }

        .border-line {
            width: 99.5%;
            margin: 0 auto;
            height: 3px;
            background: #346a95;
            display: none;
            position: absolute;
            left: 5px;
        }

        .NoClickNow { /* 现在不实现的功能，变灰标识。 */
            color: grey;
        }

        .InstructionItem {
            font-weight: bold;
        }
    </style>
    <title></title>
</head>
<body>
    <form runat="server">
        <div class="ButtonContainer">
            <ul>
                <!--报表切换按钮-->
                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_GANTT_CHART"))
                    { %>
                <li class="Button ButtonIcon" id="TableButton" tabindex="0" title="切换报表">
                    <span class="Icon Table" style="background: url(../Images/Icons.png) no-repeat -6px -113px;"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <%} %>
                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ADD"))
                    { %>
                <li class="Button ButtonIcon" id="AddButton" tabindex="0" title="新建" style="margin-right: -5px;">
                    <span class="Icon Add"></span>
                    <span class="Text">新建</span>
                </li>
                <li class="Button ButtonIcon" id="DownButton" tabindex="0" style="padding: 0;">
                    <span class="Icon Down"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <%} %>
                <!--第一个下拉-->
                <li class="DropDownButton" style="top: 25px; left: 47px;" id="Down1">
                    <div class="DropDownButtonDiv">
                        <%-- <div class="Group">
                            <div class="Heading">
                                <div class="Text">在下面打开</div>
                            </div>
                            <div class="Content">
                                 <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ADD_TASK_IN")) { %>
                                <div class="Button1" id="NewTaskButton" tabindex="0">
                                    <span class="Text">任务</span>
                                </div> <%} %>
                                 <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ADD_PHASE_IN")) { %>
                                <div class="Button1" id="NewPhaseButton" tabindex="0">
                                    <span class="Text">阶段</span>
                                </div><%} %>
                                   <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ADD_ISSUE_IN")) { %>
                                <div class="Button1" id="NewIssueButton" tabindex="0">
                                    <span class="Text">问题</span>
                                </div><%} %>
                            </div>
                        </div>--%>
                        <div class="Group">
                            <%-- <div class="Heading">
                                <div class="Text">在新的弹窗打开</div>
                            </div>--%>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ADD_TASK"))
                                    { %>
                                <div class="Button1" id="NewTaskInCurrentPageButton" tabindex="0" onclick="AddNewTask('<%=(int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_TASK %>')">
                                    <span class="Text">任务</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ADD_PHASE"))
                                    { %>
                                <div class="Button1" id="NewPhaseInCurrentPageButton" tabindex="0" onclick="AddNewTask('<%=(int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE %>')">
                                    <span class="Text">阶段</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ADD_ISSUE"))
                                    { %>
                                <div class="Button1" id="NewIssueInCurrentPageButton" tabindex="0" onclick="AddNewTask('<%=(int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE %>')">
                                    <span class="Text">问题</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                    </div>
                </li>
                <li class="Button ButtonIcon" id="ViewButton" tabindex="0">
                    <span class="Text">视图</span>
                    <span class="Icon Right"></span>
                </li>
                <!--第二个下拉-->
                <li class="DropDownButton" style="top: 25px; left: 141px;" id="Down2">
                    <div class="DropDownButtonDiv">
                        <div class="Group">
                            <div class="Content">
                                <div class="Button1" id="OutlineButton" tabindex="0" onclick="ChangeShowPage('','')">
                                    <span class="Text">概要</span>
                                </div>
                                <div class="Button1" id="PhasesButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_PHASE %>','phase')">
                                    <span class="Text">阶段</span>
                                </div>
                                <div class="Button1" id="PhaseBudgetsButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_PHASE_BUDGET %>','phaseBudHours')">
                                    <span class="Text">阶段预算</span>
                                </div>
                                <div class="Button1" id="BaselineButton" tabindex="0" onclick="ShowBusLine()">
                                    <span class="Text">基准</span>
                                </div>
                            </div>
                        </div>
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">任务和问题</div>
                            </div>
                            <div class="Content">
                                <div class="Button1" id="OverdueButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_TASK_OVERDUE %>','ExpiredTask')">
                                    <span class="Text">过期</span>
                                </div>
                                <div class="Button1" id="CompleteButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_TASK_COMPLETE %>','TaskComplete')">
                                    <span class="Text">完成</span>
                                </div>
                                <div class="Button1" id="IncompleteButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_TASK_INCOMPLETE %>','TaskNoComplete')">
                                    <span class="Text">未完成</span>
                                </div>

                                <div class="Button1" id="RunningOverButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_TASK_NOTNOTIME %>','Issues')">
                                    <span class="Text">不能按时完成</span>
                                </div>
                                <div class="Button1" id="IssuesButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_ISSUE %>','Issues')">
                                    <span class="Text">问题</span>
                                </div>
                            </div>
                        </div>
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">展开/折叠所有</div>
                            </div>
                            <div class="Content">
                                <div class="Button1" id="ExpandAllButton" tabindex="0" onclick="ExpandAll()">
                                    <span class="Text">全部展开</span>
                                </div>
                                <div class="Button1" id="CollapseAllButton" tabindex="0" onclick="CollapseAll()">
                                    <span class="Text">全部折叠</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL"))
                    { %>
                <li class="Button ButtonIcon" id="ToolsButton" tabindex="0">
                    <span class="Text">工具</span>
                    <span class="Icon Right"></span>
                </li>
                <%} %>
                <!--第三个下拉-->
                <li class="DropDownButton" style="top: 25px; left: 210px;" id="Down3">
                    <div class="DropDownButtonDiv">
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">导入</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL_IMPORT_CSV"))
                                    { %>
                                <div class="Button1" id="ImportFromExcelButton" tabindex="0">
                                    <span class="Text">.CSV文件</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL_IMPORT_TEMP"))
                                    { %>
                                <div class="Button1" id="ImportFromAutotaskTemplateButton" tabindex="0" onclick="ImportFromTemp()">
                                    <span class="Text">从模板导入</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">将项目保存为……</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL_SAVE_BASELINE"))
                                    { %>
                                <div class="Button1" id="SaveAsBaselineButton" tabindex="0" onclick="SaveAsBusiLine()">
                                    <span class="Text">保存为基准</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SUMMARY_SAVE_TEMP"))
                                    { %>
                                <div class="Button1" id="SaveAsTemplateButton" tabindex="0" onclick="SaveAsTemp()">
                                    <span class="Text">保存为模板</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">其他</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL_COMPLETE"))
                                    { %>
                                <div class="Button1" id="CompleteProjectButton" tabindex="0" onclick="CompleteProject()">
                                    <span class="Text">项目标记为完成</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL_VIEW_REPORT"))
                                    { %>
                                <div class="Button1" id="WorkloadReport" tabindex="0">
                                    <span class="Text">查看工作报告</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL_RECALCULATE"))
                                    { %>
                                <div class="Button1" id="RecalculateProjectScheduleButton" tabindex="0" onclick="RecalculateProject()">
                                    <span class="Text">重新计算项目进度</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_TOOL_EDIT_SET"))
                                    { %>
                                <div class="Button1" id="ScheduleSettingsButton" tabindex="0" onclick="ProjectSet()">
                                    <span class="Text">编辑项目设置</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                    </div>
                </li>
                <li class="Button ButtonIcon" id="LinksButton" tabindex="0">
                    <span class="Text">链接</span>
                    <span class="Icon Right"></span>
                </li>
                <!--第四个下拉-->
                <li class="DropDownButton" style="top: 27px; left: 279px;" id="Down4">
                    <div>
                        <div class="DropDownButtonDiv">
                            <div class="Group">
                                <div class="Content">
                                    <div class="Button2" id="NoLiveLinksButton" tabindex="0">
                                        <span class="Text">没有可用的链接</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
                <!--下载按钮-->
                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_OTHER_EXPORT"))
                    { %>
                <li class="Button ButtonIcon" id="ExportButton" tabindex="0" title="导出">
                    <span class="Icon Export"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <%} %>
                <%--      <li class="Button ButtonIcon" id="UseResourceCapacityForLevelingButton" tabindex="0">
                    <span class="Icon" style="margin: 0 0 3px 0; width: 12px;">
                        <input type="checkbox" style="vertical-align: middle;">
                    </span>
                    <span class="Text">使用容量来计算持续时间</span>
                </li>--%>
                <!--控制表头按钮-->
                <li class="Button ButtonIcon" id="ColumnChooserButton" tabindex="0" title="列选择器" onclick="javascript:window.open('../Common/ColumnSelector.aspx?type=<%=queryTypeId %>&group=<%=paraGroupId %>', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);">
                    <span class="Icon ColumnChooser"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <!--刷新按钮-->
                <li class="Button ButtonIcon" id="RefreshButton" tabindex="0" title="刷新表格" onclick="javascript:self.location.reload();">
                    <span class="Icon Refresh"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
            </ul>
        </div>


        <div class="ScrollingContainer ContainsGrid" style="top: -1px; bottom: 0; z-index: -1;">

            <div class="Grid Small" id="OutlineScheduleGrid">
                <%--     <div class="HeaderContainer">
                <%if (queryResult != null)
                    { %>


                <table border="" cellspacing="0" cellpadding="0" style="overflow: scroll; width: 100%; height: 100%;">
                    <tbody>
                    </tbody>
                </table>
                <%} %>
            </div>--%>

                <div class="RowContainer" style="height: 90%; top: 30px;">
                    <table cellpadding="0">
                        <tr class="HeadingRow">
                            <td class="FirstRowPrevent" width="60px">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_OTHER_EXPORT"))
                                    { %>
                                <div class="Standard">
                                    <div class="DropDownButtonContainer">
                                        <div class="Button ButtonIcon" tabindex="0" style="outline: none; z-index: 21; cursor: pointer;">
                                            <span class="Text">
                                                <input type="checkbox" class="vm" id="LeftSelectButton" />
                                            </span>
                                            <span class="Icon Right vm" id="TableDropButton"></span>
                                        </div>
                                        <!--下拉框-->
                                        <div class="DropDownButton" style="top: 50px; left: 10px; z-index: 20;" id="Down5">
                                            <div class="DropDownButtonDiv">
                                                <div class="Group">
                                                    <div class="Content">
                                                        <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_OUTDENT"))
                                                            { %>
                                                        <div class="Button1" id="OutdentButton" tabindex="0" onclick="Outdent()">
                                                            <span class="Text">减少缩进</span>
                                                        </div>
                                                        <%} %>
                                                        <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_INDENT"))
                                                            { %>
                                                        <div class="Button1" id="IndentButton" tabindex="0" onclick="Indent()">
                                                            <span class="Text">增加缩进</span>
                                                        </div>
                                                        <%} %>
                                                        <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_MODIFY"))
                                                            { %>
                                                        <div class="Button1" id="ForwardModifyButton" tabindex="0" onclick="ModifyManyTask()">
                                                            <span class="Text">转发/修改</span>
                                                        </div>
                                                        <%} %>
                                                        <%--  <div class="Button1" id="AddToMyWorkListButton" tabindex="0">
                                                                <span class="Text">添加到我的工作列表中</span>
                                                            </div>--%>
                                                        <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_SLIDE"))
                                                            { %>
                                                        <div class="Button1" id="SlideButton" tabindex="0" onclick="Slide()">
                                                            <span class="Text">滑动</span>
                                                        </div>
                                                        <%} %>
                                                        <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_COMPLETE"))
                                                            { %>
                                                        <div class="Button1" id="TableCompleteButton" tabindex="0" onclick="ShowReason()">
                                                            <span class="Text">完成</span>
                                                        </div>
                                                        <%} %>
                                                        <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_DELETE"))
                                                            { %>
                                                        <div class="Button1" id="TableDeleteButton" tabindex="0" onclick="DeieteTask()">
                                                            <span class="Text">删除</span>
                                                        </div>
                                                        <%} %>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%} %>
                            </td>
                            <td width="40px"></td>
                            <%foreach (var para in resultPara)
                                {
                                    if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                        continue;
                                    string orderby = null;
                                    string order = null;
                                    if (!string.IsNullOrEmpty(queryResult.order_by))
                                    {
                                        var strs = queryResult.order_by.Split(' ');
                                        orderby = strs[0];
                                        order = strs[1].ToLower();
                                    }
                                    if (para.name == "'#'" || para.name == "sort_order")
                                    {
                                        continue;
                                    }
                                    if (para.name == "告警")
                                    {
                                        if (!CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ALARM"))
                                        {
                                            continue;
                                        }
                                    }

                            %>
                            <td width="<%=para.length * 32 %>px">
                                <%=para.name %>
                            </td>
                            <%} %>
                        </tr>
                        <div class="cover"></div>
                        <tbody id="Drap" class="Drap">
                            <div class="border_left">
                            </div>
                            <div class="border_right">
                            </div>
                            <div class="border-line"></div>
                            <%if (queryResult != null && queryResult.count > 0)
                                {
                                    var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);

                            %>

                            <%
                                foreach (var rslt in queryResult.result)
                                {

                                    var thisTask = stDal.FindNoDeleteById(long.Parse(rslt["任务id"].ToString()));
                                    var thisType = "";
                                    if (thisTask != null)
                                    {
                                        if (thisTask.type_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                                        {
                                            thisType = "phaseTr";
                                        }
                                        else if (thisTask.type_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE)
                                        {
                                            thisType = "issueTr";
                                        }
                                        else if (thisTask.type_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_TASK)
                                        {
                                            thisType = "taskTr";
                                        }
                                    }

                                    string id = "0";
                                    if (idPara != null)
                                    {
                                        id = rslt[idPara.name].ToString();
                                    }

                            %>
                            <tr data-val="<%=id %>" class="<%=queryResult.result.IndexOf(rslt)!=0?"HighImportance D "+thisType:"" %>" draggable="true">


                                <%foreach (var para in resultPara)
                                    {


                                        if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                            continue;
                                        string tooltip = null;
                                        if (resultPara.Exists(_ => _.name.Equals(para.name + "tooltip")))
                                            tooltip = para.name + "tooltip";
                                %>
                                <%if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.PIC)
                                    { %>
                                <td <%if (tooltip != null)
                                    { %>title="<%=rslt[tooltip] %>"
                                    <%} %> style="background: url(..<%=rslt[para.name] %>) no-repeat center; min-width=<%=para.length * 32 %>px"></td>
                                <%}
                                    else
                                    {
                                        if (para.name == "'#'")
                                        {
                                %><td class="<%=queryResult.result.IndexOf(rslt)!=0?"Interaction":"" %>" width="<%=para.length * 32 %>px">
                                    <div>
                                        <div class="Decoration"></div>
                                        <%var fisrtKey = rslt.FirstOrDefault(_ => _.Key == "#"); %>
                                        <div class="Num"><%=fisrtKey.Value %></div>
                                    </div>
                                </td>
                                <td class="Context  U1"><a class="ButtonIcon Button ContextMenu NormalState">
                                    <input type="hidden" id="<%=id %>" value="<%=id %>" />
                                    <input type="hidden" id="<%=id %>_sort_no" value="<%=fisrtKey.Value %>" />
                                    <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px;"></div>
                                </a></td>

                                <%}
                                    else if (para.name == "sort_order")
                                    { continue; }
                                    else if (para.name == "告警")
                                    {
                                        if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_ALARM"))
                                        {


                                            if (rslt[para.name].ToString() == "0")
                                            {
                                %>
                                <td>
                                    <%--      <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -86px -32px; height: 16px; width: 16px;" onclick="ShowAlarm('<%=id %>')"></div>--%>
                                </td>
                                <%
                                    }
                                    else if (rslt[para.name].ToString() == "1" || rslt[para.name].ToString() == "2")
                                    {
                                %>
                                <td>
                                    <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -86px -32px; height: 16px; width: 16px;" onclick="ShowAlarm('<%=id %>')"></div>
                                    <%--     <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -70px -112px; height: 16px; width: 16px;" onclick="ShowAlarm('<%=id %>')"></div>--%>
                                </td>
                                <%
                                    }
                                    else if (rslt[para.name].ToString() == "3")
                                    {
                                %>
                                <td>
                                    <div class="Icon" style="background: url(../Images/Icons.png) no-repeat -70px -112px; height: 16px; width: 16px;" onclick="ShowAlarm('<%=id %>')"></div>
                                </td>
                                <%
                                    }
                                    else if (rslt[para.name].ToString() == "　")
                                    {
                                %>
                                <td>
                                    <%--<div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px -32px;"></div>--%>
                                </td>
                                <%
                                    }
                                    else
                                    {%>
                                <td></td>
                                <%}
                                    }
                                    else
                                    {%><td></td>
                                <%}
                                    }
                                    else if (para.name == " ")
                                    {%>
                                <td>替换图标</td>
                                <%}
                                    else if (para.name == "里程碑数")
                                    {
                                        var thisArr = rslt["里程碑数"] as byte[];
                                        var licheng = "";
                                        if (thisArr != null && thisArr.Count() > 0)
                                        {
                                            licheng = System.Text.Encoding.Default.GetString(thisArr);
                                        }

                                %>
                                <td><%=licheng %></td>
                                <%
                                    }
                                    else if (para.name == "预算时间")
                                    {
                                        var thisArr = rslt["预算时间"] as byte[];
                                        var yusuan = "";
                                        if (thisArr != null && thisArr.Count() > 0)
                                        {
                                            yusuan = System.Text.Encoding.Default.GetString(thisArr);
                                        }

                                %>
                                <td><%=yusuan %></td>
                                <%
                                    }
                                    else if (para.name == "标题")
                                    {
                                        var thisDepth = 0;
                                        if (rslt["#"] != null)
                                        {
                                            var thisTaskNo = rslt["#"].ToString();
                                            thisDepth = thisTaskNo.Split('.').Count() - 1;
                                        }
                                %>
                                <td class="Nesting E">
                                    <div data-depth="<%=thisDepth %>" class="DataDepth">
                                        <!--第一个div是缩进-->
                                        <div class="Spacer" style="width: <%=thisDepth*22 %>px; min-width: <%=thisDepth*22 %>px;"></div>
                                        <% if (IsHasSubTask(long.Parse(rslt["任务id"].ToString())))
                                            { %>
                                        <div class="IconContainer">
                                            <div class="Toggle Collapse">
                                                <div class="Vertical"></div>
                                                <div class="Horizontal"></div>
                                            </div>
                                        </div>
                                        <%} %>
                                        <div class="Value"><%=rslt[para.name] %></div>
                                    </div>
                                </td>
                                <%}
                                    else
                                    {
                                %>
                                <td style="min-width=<%=para.length * 32 %>px"><%=rslt[para.name] %></td>
                                <%
                                        }
                                    } %>
                                <%}%>
                                <%if (pageShowType == "phaseBudHours")
                                    { %>
                                <td width="100px"><%=tBll.ReturnPhaBugHours(long.Parse(rslt["任务id"].ToString())).ToString("#0.00") %></td>
                                <%} %>
                            </tr>
                            <%}
                                } %>
                        </tbody>
                    </table>
                    <%if (queryResult == null || queryResult.count <= 0)
                        { %>
                    <div style="color: red; text-align: center; padding: 10px 0; font-size: 14px; font-weight: bold;">选定的条件未查找到结果</div>
                    <%} %>
                </div>
            </div>
        </div>
        <div id="D1">
        </div>
        <div class="ContextOverlayContainer" id="OutlineScheduleGrid_ContextOverlay">
            <div class="ContextOverlay" style="left: 74px; top: 110px;">
                <div class="Top Arrow Outline" style="left: 1px;"></div>
                <div class="Top Arrow" style="left: 1px;"></div>
                <div class="LoadingIndicator"></div>
                <div class="Content"></div>
            </div>
            <div class="ContextOverlay" style="left: 74px; top: 291px;">
                <div class="Bottom Arrow Outline" style="left: 1px;"></div>
                <div class="Bottom Arrow" style="left: 1px;"></div>
                <div class="LoadingIndicator"></div>
                <div class="Content"></div>
            </div>
        </div>
        <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100;" id="Nav2">
            <div>
                <input type="hidden" id="DivChooseTaskIds" />
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" id="CloseNav2"></div>
                    <div class="TitleBar">
                        <div class="Title">
                            <span class="text" id="SaveTempTitle">从模板导入</span>
                        </div>
                    </div>
                    <%
                        var lineBusiness = dic.FirstOrDefault(_ => _.Key == "project_line_of_business").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;

                        var departList = dic.FirstOrDefault(_ => _.Key == "department").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;

                        var resList = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;


                    %>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer" style="height: 394px;" id="FirstStep2">

                            <div class="WizardProgressBar">
                                <div style="width: 25%;" class="Item Current ChooseTempIcon" id="firstChooseTempIcon">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>

                                <div style="width: 25%;" class="Item GenInfo" id="firstGenInfo">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>

                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择模板</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">选择要从其导入日程表条目的模板 </div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div>
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">项目模板
                                                                <div>
                                                                    <span style="display: inline-block;">
                                                                        <asp:DropDownList ID="project_temp" runat="server" Width="320px"></asp:DropDownList>
                                                                    </span>
                                                                </div>
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

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="down1_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!--通过模板新增-->
                        <div class="ScrollingContainer" style="height: 394px;" id="AddStep2">

                            <div class="WizardProgressBar">
                                <div style="width: 25%;" class="Item Current ChooseTempIcon" id="secondChooseTempIcon">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>
                                <div style="width: 25%;" class="Item Previous GenInfo" id="secondGenInfo">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>

                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">常规信息</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">此页面上值为当前项目的常规信息，您可以修改。</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div style="height: 180px; overflow-y: auto;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">标题<span style="color: Red;">*</span>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="text" style="width: 250px;" id="temp_name" value="<%=thisProject.name %>" /></span>
                                                                        </div>
                                                                    </td>
                                                                    <td class="FieldLabel">类型
                                                                        <div>

                                                                            <select style="width: 264px;" id="temp_type_id">
                                                                                <option value="<%=(int)EMT.DoneNOW.DTO.DicEnum.PROJECT_TYPE.TEMP %>">模板</option>
                                                                            </select>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">
                                                                        <span>开始日期<span style="color: Red;">*</span></span>
                                                                        <span style="margin-left: 31px;">结束日期<span style="color: Red;">*</span></span>
                                                                        <span style="margin-left: 29px;">持续时间<span style="color: Red;">*</span></span>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="temp_start_date" value="<%=((DateTime)thisProject.start_date).ToString("yyyy-MM-dd") %>" />
                                                                                <input type="text" style="width: 72px;" onclick="WdatePicker()" class="Wdate" id="temp_end_date" value="<%=((DateTime)thisProject.end_date).ToString("yyyy-MM-dd") %>" />
                                                                                <input type="text" style="width: 70px;" id="temp_duration" value="<%=thisProject.duration %>" />

                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                    <td class="FieldLabel">业务范围
                                                                        <div>
                                                                            <span style="display: inline-block;">

                                                                                <select class="txtBlack8Class" style="width: 264px" id="line_of_business_id">
                                                                                    <option value="0"></option>
                                                                                    <% if (lineBusiness != null && lineBusiness.Count > 0)
                                                                                        {
                                                                                            foreach (var lb in lineBusiness)
                                                                                            {%>
                                                                                    <option value="<%=lb.val %>"><%=lb.show %></option>
                                                                                    <%  }

                                                                                        } %>
                                                                                </select>

                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">项目主管
                                                                            <div>
                                                                                <span style="display: inline-block;">
                                                                                    <select class="txtBlack8Class" style="width: 264px" id="owner_resource_id" name="owner_resource_id">
                                                                                        <option value="0"></option>
                                                                                        <% if (resList != null && resList.Count > 0)
                                                                                            {
                                                                                                foreach (var res in resList)
                                                                                                {%>
                                                                                        <option value="<%=res.val %>"><%=res.show %></option>
                                                                                        <%  }

                                                                                            } %>
                                                                                    </select>

                                                                                </span>
                                                                            </div>
                                                                    </td>
                                                                    <td class="FieldLabel" width="50%">部门
                                                    <div>
                                                        <span style="display: inline-block;">
                                                            <select class="txtBlack8Class" style="width: 264px" id="department_id" name="department_id">
                                                                <option value="0"></option>
                                                                <% if (departList != null && departList.Count > 0)
                                                                    {
                                                                        foreach (var de in departList)
                                                                        {%>
                                                                <option value="<%=de.val %>"><%=de.show %></option>
                                                                <%  }

                                                                    } %>
                                                            </select>
                                                        </span>
                                                    </div>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="4" class="FieldLabel">描述
                                                                        <div>
                                                                            <textarea style="min-height: 100px; width: 625px;" id="temp_description"><%=thisProject.description %></textarea>
                                                                        </div>
                                                                        <div class="CharacterInformation"><span class="CurrentCount" id="tempTextNum"><%=(!string.IsNullOrEmpty(thisProject.description))?thisProject.description.Length:0 %></span>/<span class="Maximum">1000</span></div>
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
                            <input type="hidden" id="temp_resource_daily_hours" />
                            <input type="hidden" id="temp_useResource_daily_hours" />
                            <input type="hidden" id="temp_excludeWeekend" />
                            <input type="hidden" id="temp_excludeHoliday" />
                            <input type="hidden" id="temp_organization_location_id" />
                            <input type="hidden" id="temp_warnTime_off" />
                            <div class="ButtonContainer Footer Wizard">
                                <ul>

                                    <li class="Button ButtonIcon MoveRight PushRight" id="down2_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>


                        <div class="ScrollingContainer" style="height: 394px; display: none;" id="SecondStep2">

                            <div class="WizardProgressBar">
                                <div style="width: 25%;" class="Item Current ChooseTempIcon" id="ShowTemp2">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>

                                <div style="width: 25%;" class="Item Previous GenInfo" id="ShowInfo2">
                                    <div class="Full">
                                        <div class="Left">

                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>

                                <div style="width: 25%;" class="Item Current">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择日程表条目</span>
                                </div>
                                <div class="Content" style="padding-bottom: 12px;">
                                    <div class="DescriptionText">选择您要添加到此项目的任务/阶段</div>
                                    <table class="Neweditsubsection Drap" style="width: 770px;" cellpadding="0" cellspacing="0" id="">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="HeaderContainer" style="padding-bottom: 0;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <colgroup>
                                                                <col class="Interaction">
                                                                <col class="Nesting">
                                                                <col class="Text">
                                                            </colgroup>
                                                            <tbody>
                                                                <tr class="HeadingRow">
                                                                    <td class="">
                                                                        <input type="checkbox" style="vertical-align: middle;" id="CheckAll_2">
                                                                    </td>
                                                                    <td class="Nesting">
                                                                        <span>任务/阶段/问题</span>
                                                                    </td>
                                                                    <td class="Text">
                                                                        <span>前置条件</span>
                                                                    </td>
                                                                    <td style="width: 7px; border-right: none;"></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                    <div class="RowContainer" style="padding-bottom: 0;">
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <colgroup>
                                                                <col class="Interaction">
                                                                <col class="Nesting">
                                                                <col class="Text">
                                                            </colgroup>
                                                            <tbody id="choProTaskList" class="Drap">
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushLeft" id="prev3_2">
                                        <span class="Icon Prev"></span>
                                        <span class="Text">上一步</span>
                                    </li>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="down3_2">
                                        <span class="Icon Next"></span>
                                        <span class="Text">下一步</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <input type="hidden" id="TempChooseTaskids" />
                        <div class="ScrollingContainer" style="height: 394px; display: none;" id="ThirdStep2">

                            <div class="WizardProgressBar">

                                <div style="width: 25%;" class="Item Current ChooseTempIcon" id="ShowTemp3">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择模板</div>
                                </div>

                                <div style="width: 25%;" class="Item Previous GenInfo" id="ShowInfo3">
                                    <div class="Full">
                                        <div class="Left">

                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">常规信息</div>
                                </div>

                                <div style="width: 25%;" class="Item Previous">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择日程表条目</div>
                                </div>
                                <div style="width: 25%;" class="Item Current">
                                    <div class="Full">
                                        <div class="Left">
                                            <div class="ConnectorContainer">
                                                <div class="Connector"></div>
                                            </div>
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                        <div class="Right">
                                            <div class="Indicator">
                                                <div class="IndicatorCore"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Label">选择附加条目</div>
                                </div>
                            </div>
                            <div class="DivSectionWithHeader">
                                <div class="HeaderRow">
                                    <span class="lblNormalClass">选择日程表条目</span>
                                </div>
                                <div class="Content">
                                    <div class="DescriptionText">您可以存储日历条目、项目成本、项目成员信息到模板中。</div>
                                    <table class="Neweditsubsection" style="width: 770px;" cellpadding="0" cellspacing="0">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div>
                                                        <table cellpadding="0" cellspacing="0" style="width: 100%;">
                                                            <tbody>
                                                                <tr>
                                                                    <td class="FieldLabel" width="50%">从项目模板复制:
                                                                <div>
                                                                    <span style="display: inline-block;">
                                                                        <input type="checkbox" style="vertical-align: middle;" id="temp_CalendarItems" />
                                                                        <label for="CalendarItems">日历条目</label>
                                                                    </span>
                                                                </div>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="checkbox" style="vertical-align: middle;" id="temp_ProjectCharges" />
                                                                                <label for="ProjectCharges">项目成本</label>
                                                                            </span>
                                                                        </div>
                                                                        <div>
                                                                            <span style="display: inline-block;">
                                                                                <input type="checkbox" style="vertical-align: middle;" id="temp_TeamMembers" />
                                                                                <label for="TeamMembers">项目成员</label>
                                                                            </span>
                                                                        </div>

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

                            <div class="ButtonContainer Footer Wizard">
                                <ul>
                                    <li class="Button ButtonIcon MoveRight PushLeft" id="prev4_2">
                                        <span class="Icon Prev"></span>
                                        <span class="Text">上一步</span>
                                    </li>
                                    <li class="Button ButtonIcon MoveRight PushRight" id="Finish_2">
                                        <span class="Icon" style="width: 0; margin: 0;"></span>
                                        <span class="Text">完成</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--黑色幕布-->
        <div id="BackgroundOverLay"></div>
        <div class="Dialog Large" style="margin-left: -370px; margin-top: -229px; z-index: 100; display: none; max-width: 500px;" id="ShowReason">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" id="CloseReason()"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title">
                            <span class="text">完成任务原因</span>
                        </div>
                    </div>
                    <div class="DialogHeadingContainer">
                        <div class="ValidationSummary" id="z5491229e838c41c9ae2302dc9c39f757">
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
                        <div class="ButtonContainer"><a class="Button ButtonIcon Save NormalState" id="SaveAndCloseButton" tabindex="0"><span class="Icon"></span><span class="Text">保存并关闭</span></a></div>
                    </div>
                    <div class="ScrollingContentContainer" style="position: unset">
                        <div class="ScrollingContainer" id="" style="top: 80px;">
                            <div class="Medium NoHeading Section">
                                <div class="Content">
                                    <div class="Normal Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="ajax303a00d30ad844dcb3e55c4b5a88de3c_0_Reason">原因</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor TextArea" data-editor-id="" data-rdp="" style="top: 80px;">
                                            <div class="InputField">
                                                <textarea class="Medium" id="taskReason" name="" placeholder="" style="border: solid 1px #D7D7D7; padding: 0px 0 5px 0; max-width: 330px; min-height: 175px;"></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Dialog Large" style="margin-left: -442px; margin-top: -290px; z-index: 100; display: none; height: 500px;" id="ProjectSetting">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" id="CloseSet"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title"><span class="Text">项目设置</span><span class="SecondaryText"></span></div>
                    </div>
                    <div class="ButtonContainer"><a class="Button ButtonIcon Save NormalState" id="SaveButton" tabindex="0"><span class="Icon"></span><span class="Text">保存</span></a></div>
                    <div class="ScrollingContentContainer" style="position: unset;">
                        <div class="ScrollingContainer" id="zb3a4c9a6d38b4a6d81d1b7fd82d088c2" style="top: 85px;">
                            <div class="Instructions">
                                <div class="InstructionItem">对这些设置的任何更改将立即应用到项目进度表上。</div>
                            </div>
                            <div class="Normal Section">
                                <div class="Heading">
                                    <div class="Left"><span class="Text">日程表设置</span><span class="SecondaryText"></span></div>
                                    <div class="Spacer"></div>
                                </div>
                                <div class="DescriptionText" style="margin-left: 15px;">启用“非工作日/节假日”可能会改变任务/问题的开始/结束日期。当“非工作日/节假日”启用时，任务/问题只会被安排在工作日。对于没有主负责人的任务/问题，非工作日和节假日将取决于已选区域，一旦为任务/问题分配了主负责人，非工作日和节假日将取决于主负责人所在区域。</div>
                                <div class="Content" style="margin-left: 20px">
                                    <div class="Large Column">
                                        <div class="CheckBoxGroupContainer">
                                            <div class="CheckBoxGroupLabel">
                                                <div><span class="Label">当调整任务/问题时不包括：</span></div>
                                                <div>
                                                    <span style="display: inline-block;">
                                                        <asp:CheckBox ID="excludeWeekend" runat="server" />

                                                        <label for="excludeWeekend">非工作日</label>
                                                        <span>(星期六和星期天)</span>
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="Editor CheckBox" data-editor-id="" data-rdp="">
                                                <div>
                                                    <span style="display: inline-block;">
                                                        <asp:CheckBox ID="excludeHoliday" runat="server" />

                                                        <label for="excludeHoliday">节假日</label>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label for="">区域<span class="SecondaryText">(决定节假日和非工作日)</span></label><span class="Required">*</span>
                                        </div>
                                    </div>
                                    <div class="Editor SingleSelect" data-editor-id="" data-rdp="">
                                        <div class="InputField">
                                            <asp:DropDownList ID="organization_location_id" runat="server" Width="264px"></asp:DropDownList>

                                        </div>
                                    </div>
                                    <div class="Editor CheckBox" data-editor-id="" data-rdp="">
                                        <div class="InputField">
                                            <div>
                                                <asp:CheckBox ID="warnTime_off" runat="server" />
                                                <label for="warnTime_off">当用户试图分配一个任务/问题时，如果主负责人已经审批的休假请求会影响工作按时完成，则显示一个警告</label>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Section">
                                <div class="Heading">
                                    <div class="Left"><span class="Text">项目成员日工作量</span><span class="SecondaryText"></span></div>
                                    <div class="Spacer"></div>
                                </div>
                                <div class="DescriptionText" style="margin-left: 15px;">设置项目成员期望每天工作的小时数，他可以根据团队成员进行调整。如果此任务没有主负责人，该值用于计算任务截止日期/时间.</div>
                                <div class="Content" style="margin-left: 20px;">
                                    <div class="Medium Column">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="">总时间</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor DecimalBox" data-editor-id="" data-rdp="">
                                            <div class="InputField">
                                                <input type="text" style="width: 250px;" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" id="resource_daily_hours" name="resource_daily_hours" value="<%=((decimal)thisProject.resource_daily_hours).ToString("#0.00") %>" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Medium Column"></div>
                                    <div class="Normal Column">
                                        <div class="Editor CheckBox" data-editor-id="" data-rdp="">
                                            <div class="InputField">
                                                <div style="width: 310px;">
                                                    <asp:CheckBox ID="useResource_daily_hours" runat="server" />

                                                    <label for="CapacityCalculation">
                                                        用工作量为固定工作任务计算时间
                                                            <span style="color: #666;">（当不启用此设置时，您能够手动调整固定工作任务的持续时间，持续时间不会自动计算）
                                                            </span>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; display: none;" id="SildeDays">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="CloseSileDay()"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title">
                            <span class="text">滑动条目</span>
                        </div>
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
                        <div class="ButtonContainer"><a class="Button ButtonIcon Save NormalState" id="SaveSildeDays" tabindex="0"><span class="Icon"></span><span class="Text">保存</span></a></div>
                        <div class="Instructions" style="margin-left: 35px;">
                            <div class="InstructionItem">选中条目的开始和结束日期将前平移（负整数）或后平移（正整数）若干天。 请参照您的项目<a class="Button ButtonIcon Link NormalState" id="z62ce5bfd687c4d1281624df07fb2f3ff" tabindex="0" onclick="ShowSetting()">条目设置</a>.</div>
                        </div>
                    </div>
                    <div class="ScrollingContentContainer" style="position: unset">
                        <div class="ScrollingContainer" id="" style="top: 80px;">
                            <div class="Medium NoHeading Section">
                                <div class="Content">
                                    <div class="Normal Column" style="margin-top: 25px;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="ajax303a00d30ad844dcb3e55c4b5a88de3c_0_Reason">滑动</label><span class="Required">*</span>
                                            </div>
                                        </div>
                                        <div class="Editor IntegerBox" data-editor-id="" data-rdp="" style="top: 80px;">
                                            <div class="InputField">
                                                <input type="text" id="SildeDaysNum" value="0" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /><span class="CustomHtml">天</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; display: none;" id="deleteTask">
            <div>
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="CloseDeleteTask()"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title">
                            <span class="text">删除阶段告警</span>
                        </div>
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
                        <div class="Instructions" style="margin-left: 35px;">
                            <div class="InstructionItem">您将删除选定的阶段及其所有子阶段和任务。如果您希望保留除阶段之外的所有内容，请选择下面的复选框。</div>
                        </div>
                    </div>
                    <div class="ScrollingContentContainer" style="position: unset">
                        <div class="ScrollingContainer" id="" style="top: 80px;">
                            <div class="Medium NoHeading Section">
                                <div class="Content">
                                    <div class="Normal Column" style="margin-top: 25px;">
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="ajax303a00d30ad844dcb3e55c4b5a88de3c_0_Reason">确定要删除这些阶段吗</label>
                                            </div>
                                        </div>
                                        <div class="Editor IntegerBox" data-editor-id="" data-rdp="" style="top: 80px;">
                                            <div class="InputField">
                                                <div>
                                                    <input type="checkbox" id="ckIsCheck" />
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label for="">保留所有任务和子阶段</label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="Confirmation ButtonContainer">
                                            <a class="Button ButtonIcon NormalState" id="YesButton" tabindex="0"><span class="Icon"></span><span class="Text">是</span></a><a class="Button ButtonIcon NormalState" id="NoButton" tabindex="0"><span class="Icon"></span><span class="Text">否</span></a>

                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; display: none; width: 650px;" id="ShowTaslAlarm">
            <div>
                <input type="hidden" id="ShowAlertTaskId" value="" />
                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="CloseTaskAlarm()"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title">
                            <span class="text">项目条目告警</span>
                        </div>
                    </div>
                    <div id="qianquAlarm" style="display: none;" class="ShowAlarm">
                        <!--前驱任务预警 -->
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
                            <div class="Instructions" style="margin-left: 35px;">
                                <div class="InstructionItem">此任务在其一个或多个前驱任务之前完成。其开始和结束日期仍会根据前驱任务的修改而调整。如果此任务是其他任务的前驱，则对其结束日期的调整将影响关联的后继任务的开始日期。 要结束这些联动，请删除任务的关联。</div>
                                <div>
                                    <span style="display: block; margin: 10px 0px;">
                                        <input type="checkbox" id="DisBeforTask" />将此任务与未完成的前驱任务脱离关系</span>
                                    <span style="display: block; margin: 10px 0px;">
                                        <input type="checkbox" id="DisAfterTask" />将此任务与后续任务脱离关系</span>
                                </div>
                                <div>
                                    <input class="Button" type="button" id="ChangePreTask" value="确认更改" style="width: 65px; height: 30px;" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="clearEarilyThan" style="display: none;" class="ShowAlarm">
                        <!--清除任务的开始时间不早于字段 -->
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
                            <div class="Instructions" style="margin-left: 35px;">
                                <div class="InstructionItem">任务设置了开始时间不早于日期</div>
                                <div>
                                    该任务开始日期不能早于开始时间不早于<span id="taskStratThanSpan"></span>。
                                </div>
                                <div>
                                    <input class="Button" type="button" id="ClearStartThanButton" value="清除开始日期不早于" style="width: 144px; height: 28px; margin-top: 14px;" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="dateNotInWeek" style="display: none; margin: 15px 0px;" class="ShowAlarm">
                        <div class="Instructions" style="margin-left: 35px;">
                            <div class="InstructionItem">任务的开始或者结束时间不在工作日内</div>
                            <div>
                            </div>
                            <div>
                            </div>
                        </div>
                    </div>
                    <div id="NoDoneOnTimeDiv" style="display: none; margin: 15px 0px;" class="ShowAlarm">
                        <!--前驱任务未能及时完成 将会影响一个或多个任务开始 -->
                        <div class="Instructions" style="margin-left: 35px;">
                            <div class="InstructionItem"></div>
                            <div>
                                此任务会影响一个或多个任务（任务编号如<span id="TaskIdsSpan"></span>）的开始，并且可能无法及时完成。 预期结束日期是根据此任务的剩余时间（估计小时数 - 实际小时数）和项目设置计算的。 如果估计的小时数等于0，系统将根据持续时间和分配的资源计算估计的小时数。
                            <p>预计开始/结束日期：<span id="thisTaskStartSpan"></span> - <span id="thisTaskEndSpan"></span></p>

                            </div>
                            <div>
                            </div>
                        </div>
                    </div>
                    <div id="resTimeOffDiv" style="display: none; margin: 15px 0px;" class="ShowAlarm">
                        <div class="Instructions" style="margin-left: 35px;">
                            <div class="InstructionItem"></div>
                            <div>
                                任务或者问题不能及时完成
                            </div>
                            <div>
                                任务的主负责人在此期间有请假，且已审批通过（<span id="timeOffSpan"></span>），任务可能无法在<span id="doneTimeSpan"></span>完成。
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="Dialog Large" style="margin-left: -442px; margin-top: -229px; z-index: 100; display: none; width: 650px;" id="ShowAddOtherDiv">
            <div>

                <div class="DialogContentContainer">
                    <div class="CancelDialogButton" onclick="CloseDigAddOtherDiv()"></div>
                    <div class="Active ThemePrimaryColor TitleBar">
                        <div class="Title">
                            <span class="text">添加到员工的工作列表-</span><span id="ToOtherTaskNo"></span>
                        </div>
                    </div>
                    <div class="DialogHeadingContainer">
                        <div class="ButtonContainer"><a class="Button ButtonIcon Save NormalState" tabindex="0"><span class="Icon"></span><span class="Text">保存并关闭</span></a><a class="Button ButtonIcon Cancel NormalState" id="CancelButton" onclick="CloseDigAddOtherDiv()"><span class="Icon"></span><span class="Text">取消</span></a></div>
                    </div>
                    <div class="ScrollingContentContainer">
                        <div class="ScrollingContainer">
                                <div class="Medium NoHeading Section">
                                    <div class="Content">
                                        <div class="Normal Column">
                                            <div class="Instructions">
                                                <div class="InstructionItem">你想将这个任务添加到谁的工作列表中?</div>
                                            </div>
                                            <div class="EditorLabelContainer">
                                                <div class="Label">
                                                    <label>员工</label><span class="Required">*</span></div>
                                            </div>
                                            <div class="Editor DataSelector">
                                                <div class="InputField">
                                                    <input id="" type="text" value="" />
                                                    <a class="Button ButtonIcon IconOnly DataSelector NormalState" id="" ><span class="Icon"></span><span class="Text"></span></a>
                                                    <input id="ToOtherResIds" name="" type="hidden" value="" />
                                                    <input id="ToOtherResIdsHidden" name="" type="hidden" value="" />
                                                    <div class="ContextOverlayContainer">
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
                                                        <select id="ResManySelect" multiple="multiple"></select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="menu" id="projectMenu" style="background-color: white;">
            <%--margin-left:115px;margin-top:6px;--%>
            <%--菜单--%>
            <ul>
                <li class="" style="top: 27px; left: 49px; height: 100px; background-color: white;" id="">
                    <div class="DropDownButtonDiv">
                        <div class="Group" style="float: left;">
                            <div class="Heading">
                                <div class="Text" style="font-weight: bold;">常规</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("SEARCH_PROJECT_EDIT_PROJECT"))
                                    { %>
                                <div class="Button1" id="" tabindex="0" onclick="EditObject('projetc')">
                                    <span class="Text">修改</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SUMMARY_COMPLETE"))
                                    { %>
                                <div class="Button1" id="" tabindex="0" onclick="CompleteProject()">
                                    <span class="Text">完成</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_DELETE"))
                                    { %>
                                <div class="Button1" id="" tabindex="0" onclick="DeleteProject()">
                                    <span class="Text">删除</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                        <div class="Group" style="float: left;">
                            <div class="Heading">
                                <div class="Text" style="font-weight: bold;">新建</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_NOTE_ADD"))
                                    { %>
                                <div class="Button1" id="ProNoteButton" tabindex="0" onclick="NewAddNote('projetc')">
                                    <span class="Text">备注</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_ATTACH_ADD"))
                                    { %>
                                <div class="Button1" id="ProAttButton" tabindex="0" onclick="NewAddProjectAtt()">
                                    <span class="Text">附件</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_EXPENSES_ADD_CHANGE"))
                                    { %>
                                <div class="Button1" id="ProCostButton" tabindex="0" onclick="NewAddCharge()">
                                    <span class="Text">成本</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_EXPENSES_ADD_EXPENSES"))
                                    { %>
                                <div class="Button1" id="ProExpButton" tabindex="0" onclick="NewAddExpense('projetc')">
                                    <span class="Text">费用</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                    </div>
                </li>

            </ul>
        </div>

        <div class="menu" id="taskMenu" style="background-color: white;">
            <%--菜单--%>
            <ul>
                <li class="" style="top: 27px; left: 49px; height: 350px; background-color: white; width: 600px;" id="">
                    <div class="DropDownButtonDiv" style="width: 500px; max-width: 600px;">
                        <div class="Group" style="float: left; min-width: 100px;">
                            <div class="Heading">
                                <div class="Text" style="font-weight: bold;">常规</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_DETAILS"))
                                    { %>
                                <div class="Button1 TaskMenu OnlyTaskMenu OnlyIssMenu" id="TaskViewDetails" tabindex="0" onclick="TaskViewDetails()">
                                    <span class="Text">查看详情</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_SHOW_HISTORY"))
                                    { %>
                                <div class="Button1 TaskMenu OnlyTaskMenu OnlyIssMenu" id="TaskViewHistory" tabindex="0" onclick="TaskViewHistory()">
                                    <span class="Text" id="ShowHistory">查看任务历史</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_EDIT_PHASE") || CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_EDIT_TASK"))
                                    { %>
                                <div class="Button1 TaskMenu OnlyTaskMenu OnlyIssMenu OnlyPharseMenu" id="" tabindex="0" onclick="EditObject('task')">
                                    <span class="Text">修改</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_COMPLETE"))
                                    { %>
                                <div class="Button1 TaskMenu OnlyTaskMenu OnlyIssMenu OnlyPharseMenu" id="CompleteTask" tabindex="0" onclick="CompleteSingTask()">
                                    <span class="Text">完成</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_MODIFY"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="" tabindex="0" onclick="ModifySingTask()">
                                    <span class="Text">转发/修改</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_ADD_WORK_LIST"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="" tabindex="0" onclick="AddToMyWorkList()">
                                    <span class="Text">添加到我的工作清单</span>
                                </div>
                                <%} %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="" tabindex="0" onclick="AddToPriResWorkList()">
                                    <span class="Text">添加到主负责人的工作列表</span>
                                </div>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="" tabindex="0" onclick="AddToOtherResWorkList()">
                                    <span class="Text">添加到其它成员的工作列表</span>
                                </div>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_DELETE"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu OnlyPharseMenu" id="" tabindex="0" onclick="DeleteTask()">
                                    <span class="Text">删除</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                        <div class="Group" style="float: left; min-width: 100px;">
                            <div class="Heading">
                                <div class="Text" style="font-weight: bold;">新建</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_ADD_ENTRY_NOTIME"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="AddNoTimeEntryId" tabindex="0" onclick="NewAddWorkEntry('1')">
                                    <span class="Text">工时</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_ADD_ENTRY_TIME"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="" tabindex="0" onclick="NewAddWorkEntry('')">
                                    <span class="Text">工时（输入开始/结束时间）</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_NOTE_ADD"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu OnlyPharseMenu" id="TaskNoteButton" tabindex="0" onclick="NewAddNote('task')">
                                    <span class="Text">备注</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_ATTACH_ADD"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="TaskAttButton" tabindex="0" onclick="NewAddTaskAtt()">
                                    <span class="Text">附件</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_EXPENSES_ADD_EXPENSES"))
                                    { %>
                                <div class="Button1 TaskMenu  OnlyTaskMenu OnlyIssMenu" id="TaskExpButton" tabindex="0" onclick="NewAddExpense('task')">
                                    <span class="Text">费用</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_ADD_CHANGE_ORDER"))
                                    { %>
                                <div class="Button1  TaskMenu  OnlyTaskMenu" id="" tabindex="0" onclick="AddChangeOrder()">
                                    <span class="Text">变更单（成本）</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_COPY_TASK"))
                                    { %>
                                <div class="Button1 TaskMenu OnlyTaskMenu" id="" tabindex="0" onclick="CopThisTask()">
                                    <span class="Text">任务副本</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_CONTEXT_ADD_TASK_TO_LIBARY"))
                                    { %>
                                <div class="Button1 TaskMenu OnlyTaskMenu OnlyIssMenu" id="" tabindex="0" onclick="AddToLibary()">
                                    <span class="Text">添加到任务库</span>
                                </div>
                                <%} %>
                                <div class="Button1 TaskMenu OnlyTaskMenu OnlyIssMenu" id="" tabindex="0" onclick="">
                                    <span class="Text">服务预定</span>
                                </div>
                            </div>
                        </div>
                        <div class="Group" style="float: left; min-width: 100px;">
                            <div class="Heading">
                                <div class="Text" style="font-weight: bold;">移动</div>
                            </div>
                            <div class="Content">
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_OUTDENT"))
                                    { %>
                                <div class="Button1" id="" tabindex="0" onclick="OutSingTask()">
                                    <span class="Text">减少缩进</span>
                                </div>
                                <%} %>
                                <%if (CheckAuth("PRO_PROJECT_VIEW_SCHEDULE_SERIAL_INDENT"))
                                    { %>
                                <div class="Button1" id="" tabindex="0" onclick="InSingTask()">
                                    <span class="Text">增加缩进</span>
                                </div>
                                <%} %>
                            </div>
                        </div>
                    </div>
                </li>

            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/Project.js"></script>
<%--<script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>--%>
<%//弹窗相关的js %>
<script>
    $(function () {

        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
      <% if (isTransTemp)
    { %>
        SaveAsTemp();

      <%}%>


    })

    $("#CloseNav2").on("click", function () {
        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
        $("#AddStep2").show();
        $("#SecondStep2").hide();
        $("#ThirdStep2").hide();
    });


    $("#TableButton").click(function () {
        // 跳转到图形列表
        location.href = "ProjectChart?project_id=<%=thisProject.id %>";
    })


    // 时间够的情况下可以尝试快速新增修改操作，暂不处理
    $("#IncompleteTasksScheduleGrid_inlineEditingCancelButton").click(function () {
        // 新增取消
        // 修改
    })
    // 在页面新增task
    function AddTask() {
        // 已经有在新增/变价 校验新增/编辑 条件，满足条件则提交相关请求新增，不满足关闭新增
        if ($("#AddHtml").length > 0) {
            // 新增提交并关闭
        } else if ($("#EditHtml").length > 0) {
            // 修改提交并关闭
        }

        var addHtml = "<tr id='AddHtml'><td class='EditingInteraction DropDownButtonEnabled'><span></span></td><td></td>";
        // 新增三个tr，根据设置判断添加哪些td
       <%if (queryResult != null)
    {
        foreach (var para in resultPara)
        {
            switch (para.name)
            {
                case "":
                    break;
                default:
                    break;
            }


            %> 

        <%}%>
        addHtml += "</tr>";
        addHtml += "<tr class='ValidationResultRow' style=''><td></td><td></td><td class='Error' colspan='<%=resultPara.Count%>'></td></tr>";
        addHtml += "<tr class='EditingButtonRow'><td></td><td></td><td colspan='<%=resultPara.Count%>'><div><a class='Button ButtonIcon Save SelectedState' id='IncompleteTasksScheduleGrid_inlineEditingSaveButton' tabindex='0'><span class='Icon'></span><span class='Text'>Save</span></a><a class='Button ButtonIcon Cancel NormalState' id='IncompleteTasksScheduleGrid_inlineEditingCancelButton' tabindex='0'><span class='Icon'></span><span class='Text'>Cancel</span></a></div></td></tr>";

        // 获取新增的位置，判断是否选中
    <%}%>


    }
</script>
<%// 页面相关js %>
<script>

    $(".Context").on("mouseover", function () {

        $("#OutlineScheduleGrid_ContextOverlay").show();
        $("#OutlineScheduleGrid_ContextOverlay").children().first().addClass("Active Right GridContextMenu")
        $("#OutlineScheduleGrid_ContextOverlay").children().first().css("left", "97px");
        $("#OutlineScheduleGrid_ContextOverlay").children().first().css("top", "47px");
    });
    $(".Context").on("mouseout", function () {
        $("#OutlineScheduleGrid_ContextOverlay").hide();
        $("#OutlineScheduleGrid_ContextOverlay").children().first().removeClass("Active Right GridContextMenu")
        $("#OutlineScheduleGrid_ContextOverlay").children().first().css("left", "");
        $("#OutlineScheduleGrid_ContextOverlay").children().first().css("top", "");
    });
    $("#OutlineScheduleGrid_ContextOverlay").on("mouseover", function () {
        $(this).show();
    });
    $("#OutlineScheduleGrid_ContextOverlay").on("mouseout", function () {
        $(this).hide();
    });
</script>

<script>

    // 获取到但前页面中选中的task
    function GetChooseTaskId() {
        debugger;
        var ids = "";
        $(".HighImportance").each(function () {
            if ($(this).hasClass("Selected")) {
                ids += $(this).data("val") + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        return ids;
    }
    // 获取到界面上选择的最后的阶段--没有返回""
    function GetLastChoosePhaseTask() {
        var lastPhaseId = "";
        var ids = GetChooseTaskId();
        if (ids != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetLastPhaseId&ids=" + ids,
                success: function (data) {
                    if (data != "") {
                        lastPhaseId = data;
                    }
                },
            });
        }

        return lastPhaseId;
    }


    // 根据选择的条件过滤页面上的数据
    function ChangeShowPage(queryType, showType) {
        location.href = "ProjectSchedule?project_id=<%=thisProject.id %>&pageShowType=" + showType + "&QeryTypeId=" + queryType;
    }

    function AddNewTask(type_id) {
        // 获取页面选中
        var parent_id = GetLastChoosePhaseTask();

        window.open("TaskAddOrEdit.aspx?project_id=<%=thisProject.id %>&par_task_id=" + parent_id + "&type_id=" + type_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKADD %>', 'left=200,top=200,width=1080,height=800', false);
    }
    // 全部展开
    function ExpandAll() {
        $(".IconContainer").each(function () {
            $(this).find('.Vertical').hide();
            var _this = $(this).parent().parent().parent();
            var str = _this.find('.DataDepth').attr('data-depth');
            for (i in _this.nextAll()) {
                if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'block') {
                    _this.nextAll().eq(i).hide();
                    _this.nextAll().eq(i).find('.Vertical').show();
                } else if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'none') {
                    _this.nextAll().eq(i).show();
                    _this.nextAll().eq(i).find('.Vertical').hide();
                } else if (str >= _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
                    return false;
                }
            }
        });
    }
    // 全部折叠
    function CollapseAll() {
        $(".IconContainer").each(function () {
            $(this).find('.Vertical').show();
            var _this = $(this).parent().parent().parent();
            var str = _this.find('.DataDepth').attr('data-depth');
            for (i in _this.nextAll()) {
                if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'block') {
                    _this.nextAll().eq(i).hide();
                    _this.nextAll().eq(i).find('.Vertical').show();
                } else if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'none') {
                    _this.nextAll().eq(i).show();
                    _this.nextAll().eq(i).find('.Vertical').hide();
                } else if (str >= _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
                    return false;
                }
            }
        });
    }

    // 保存为模板
    function SaveAsTemp() {
        $(".ChooseTempIcon").hide();
        $("#Nav2").show();
        $("#AddStep2").show();
        $("#secondGenInfo").show();
        $("#FirstStep2").hide();
        $("#SaveTempTitle").html("保存为模板");
        $("#BackgroundOverLay").show();
        //$("#FirstStep2").hide();
        //$("#prev2_2").on("click", function () {


        //    $("#FirstStep2").show();
        //    $("#AddStep2").hide();
        //});
        $("#down2_2").unbind("click", function () { });
        $("#down2_2").on("click", function () {

            var temp_name = $("#temp_name").val();
            if (temp_name == "") {
                LayerMsg("请填写标题！");
                return false;
            }
            var temp_start_date = $("#temp_start_date").val();
            if (temp_start_date == "") {
                LayerMsg("请填写开始时间！");
                return false;
            }
            var temp_end_date = $("#temp_end_date").val();
            if (temp_end_date == "") {
                LayerMsg("请填写结束时间！");
                return false;
            }
            var temp_duration = $("#temp_duration").val();
            if (temp_duration == "") {
                LayerMsg("请填写持续时间！");
                return false;
            }
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=GetTaskList&project_id=<%=thisProject.id %>",
                success: function (data) {
                    if (data != "") {
                        $("#choProTaskList").html(data);
                    }
                },
            });

            $("#down3_2").unbind("click", function () { });
            $("#down3_2").on("click", function () {
                // SecondStep2
                debugger;
                var ids = "";
                $("#choProTaskList tr").each(function () {
                    if ($(this).hasClass("Selected")) {
                        ids += $(this).data('val') + ",";
                    }
                })
                if (ids == "") {
                    LayerConfirm("未选择任何条目，是否继续", "确认", "取消", function () {
                        debugger;

                        $("#SecondStep2").hide();
                        $("#ThirdStep2").show();
                        $("#TempChooseTaskids").val("");
                        $("#ShowInfo3").show();
                    }, function () { });
                } else {
                    ids = ids.substring(0, ids.length - 1);
                    $("#SecondStep2").hide();
                    $("#ThirdStep2").show();
                    $("#TempChooseTaskids").val(ids);
                    $("#ShowInfo3").show();
                }


            });
            $("#AddStep2").hide();
            $("#SecondStep2").show();
            $("#ShowInfo2").show();
        });
        //$("#prev3_2").removeAttr("click");
        $("#prev3_2").unbind("click", function () { });
        $("#prev3_2").on("click", function () {
            $("#AddStep2").show();
            $("#SecondStep2").hide();
            $("#FirstStep2").hide();
        });

        $("#prev4_2").unbind("click", function () { });
        $("#prev4_2").on("click", function () {
            $("#SecondStep2").show();
            $("#ThirdStep2").hide();
        });

        $("#Finish_2").unbind("click", function () { });
        $("#Finish_2").on("click", function () {
            var temp_name = $("#temp_name").val();
            if (temp_name == "") {
                LayerMsg("请填写标题！");
                return false;
            }
            var temp_start_date = $("#temp_start_date").val();
            if (temp_start_date == "") {
                LayerMsg("请填写开始时间！");
                return false;
            }
            var temp_end_date = $("#temp_end_date").val();
            if (temp_end_date == "") {
                LayerMsg("请填写结束时间！");
                return false;
            }
            var temp_duration = $("#temp_duration").val();
            if (temp_duration == "") {
                LayerMsg("请填写持续时间！");
                return false;
            }
            var temp_type_id = $("#temp_type_id").val();
            var line_of_business_id = $("#line_of_business_id").val();
            var owner_resource_id = $("#owner_resource_id").val();
            var department_id = $("#department_id").val();
            var temp_description = $("#temp_description").val();
            var TempChooseTaskids = $("#TempChooseTaskids").val();
            var copyCalItem = $("#temp_CalendarItems").is(":checked");
            var copyProCha = $("#temp_ProjectCharges").is(":checked");
            var copyProTeam = $("#temp_TeamMembers").is(":checked");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=SaveTemp&TranProjectId=<%=thisProject.id %>&name=" + temp_name + "&startDate=" + temp_start_date + "&endDate=" + temp_end_date + "&duration=" + temp_duration + "&lineBuss=" + line_of_business_id + "&department_id=" + department_id + "&proLead=" + owner_resource_id + "&description=" + temp_description + "&TempChooseTaskids=" + TempChooseTaskids + "&copyCalItem=" + copyCalItem + "&copyProCha=" + copyProCha + "&copyProTeam=" + copyProTeam,
                success: function (data) {
                    if (data != "") {

                    }
                    $("#Nav2").hide();
                    $("#BackgroundOverLay").hide();
                },
            });
        })
    }
    // 从模板导入
    function ImportFromTemp() {
        $(".GenInfo").hide();
        $("#Nav2").show();
        $("#SaveTempTitle").html("从模板导入");
        $("#BackgroundOverLay").show();
        $("#AddStep2").hide();
        //$("#AddStep2").show();
        $("#FirstStep2").show();
        $("#firstChooseTempIcon").show();


        $("#down1_2").unbind("click", function () { });
        $("#down1_2").click(function () {
            var project_temp = $("#project_temp").val();
            if (project_temp != undefined && project_temp != "" && project_temp != "0") {
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ProjectAjax.ashx?act=GetTaskList&showType=Precondition&project_id=" + project_temp,
                    success: function (data) {
                        if (data != "") {
                            $("#choProTaskList").html(data);
                        } else {
                            $("#choProTaskList").html("");
                        }
                    },
                });
                $(".Drap tr>.Interaction").on("click", function () {
                    var _this = $(this).parent();
                    _this.siblings().removeClass('Selected');
                    _this.addClass('Selected');
                    var _thisDataDepth = _this.find('.DataDepth').attr('data-depth');
                    $("#OutdentButton").on("click", function () {
                        if (_thisDataDepth > 1) {
                            var _thisDataDepthDec = _this.find('.DataDepth').attr('data-depth') - 1;
                            _this.find('.DataDepth').attr('data-depth', _thisDataDepthDec);
                            Style();
                        }
                    });
                    var str = _this.find('.DataDepth').attr('data-depth');
                    for (i in _this.nextAll()) {
                        if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
                            _this.addClass('Selected');
                            _this.nextAll().eq(i).addClass('Selected');

                            $("#OutdentButton").on("click", function () {
                                for (j in _this.nextAll()) {
                                    var DataDepth = _this.nextAll().eq(j).find('.DataDepth').attr('data-depth');
                                    var DataDepthDec = DataDepth - 1;
                                    _this.nextAll().eq(j).find('.DataDepth').attr('data-depth', DataDepthDec);
                                    Style();
                                }
                            });
                        } else {
                            return false;
                        }
                    }
                    Style();
                });
                $(".IconContainer").on('click', function () {
                    $(this).find('.Vertical').toggle();
                    var _this = $(this).parent().parent().parent();
                    var str = _this.find('.DataDepth').attr('data-depth');
                    for (i in _this.nextAll()) {
                        if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'block') {
                            _this.nextAll().eq(i).hide();
                            _this.nextAll().eq(i).find('.Vertical').show();
                        } else if (str < _this.nextAll().eq(i).find('.DataDepth').attr('data-depth') && $(this).find('.Vertical').css('display') == 'none') {
                            _this.nextAll().eq(i).show();
                            _this.nextAll().eq(i).find('.Vertical').hide();
                        } else if (str >= _this.nextAll().eq(i).find('.DataDepth').attr('data-depth')) {
                            return false;
                        }
                    }
                });
                $("#LeftSelectButton").on("click", function () {
                    var _this = $(this);
                    if (_this.is(':checked')) {
                        $(".D").addClass('Selected');
                    } else {
                        $(".D").removeClass('Selected');
                    }
                });
                //$("#down3_2").removeAttr("click");
                $("#down3_2").unbind("click", function () { });
                $("#down3_2").on("click", function () {
                    // SecondStep2
                    var ids = "";
                    $("#choProTaskList tr").each(function () {
                        if ($(this).hasClass("Selected")) {
                            ids += $(this).data('val') + ",";
                        }
                    })
                    debugger;
                    if (ids == "") {
                        LayerConfirm("未选择任何条目，是否继续", "确认", "取消", function () {
                            debugger;

                            $("#SecondStep2").hide();
                            $("#ThirdStep2").show();
                            $("#TempChooseTaskids").val("");
                        }, function () { });
                    } else {
                        ids = ids.substring(0, ids.length - 1);
                        $("#SecondStep2").hide();
                        $("#ThirdStep2").show();
                        $("#TempChooseTaskids").val(ids);

                    }


                });
                $("#ShowTemp3").show();
                $("#ShowTemp2").show();
                $("#FirstStep2").hide();
                $("#SecondStep2").show();
            } else {
                LayerMsg("请选择项目模板！");
            }

        })

        //$("#prev3_2").removeAttr("click");
        //down2_2

        $("#prev3_2").unbind("click", function () { });
        $("#prev3_2").on("click", function () {
            $("#FirstStep2").show();
            $("#SecondStep2").hide();
            $("#AddStep2").hide();
        });

        $("#prev4_2").unbind("click", function () { });
        $("#prev4_2").on("click", function () {
            $("#SecondStep2").show();
            $("#ThirdStep2").hide();
        });

        $("#Finish_2").unbind("click", function () { });
        $("#Finish_2").on("click", function () {
            debugger;
            var project_temp = $("#project_temp").val();
            if (project_temp == undefined || project_temp == "" || project_temp == "0") {
                LayerMsg("请选择模板");
                return false;
            }
            var choIds = $("#TempChooseTaskids").val();
            var copyCalItem = $("#temp_CalendarItems").is(":checked");
            var copyProCha = $("#temp_ProjectCharges").is(":checked");
            var copyProTeam = $("#temp_TeamMembers").is(":checked");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=ImportFromTemp&project_temp_id=" + project_temp + "&copyCalItem=" + copyCalItem + "&copyProCha=" + copyProCha + "&copyProTeam=" + copyProTeam + "&thisProjetcId=<%=thisProject.id %>&choIds=" + choIds,
                success: function (data) {
                    $("#Nav2").hide();
                    $("#BackgroundOverLay").hide();
                    history.go(0);
                },
            });

            return true;
        });
    }
    // 保存为基准
    function SaveAsBusiLine() {
        // 如果有则提醒已存在，是否重新创建
        // 成功之后不提示
        var jiZhunID = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetSinProject&project_id=<%=thisProject.id %>",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    jiZhunID = data.baseline_project_id;
                }
            },
        });
        var isAdd = "";
        if (jiZhunID == null || jiZhunID == "") {
            isAdd = "1";
        } else {
            LayerConfirm("项目基准已经存在，是否重新创建", "确定", "取消", function () {
                isAdd = "0"; $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ProjectAjax.ashx?act=SaveAsBaseline&project_id=<%=thisProject.id %>",
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            LayerMsg("创建基准成功");
                        }
                        history.go(0);
                    },
                });
            }, function () { });
        }
        debugger;
        if (isAdd == "1") {
            // 新增基准
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=SaveAsBaseline&project_id=<%=thisProject.id %>",
                dataType: "json",
                success: function (data) {
                    if (data != "") {

                    }
                    history.go(0);
                },
            });
        }
    }
    // 将项目设为完成
    function CompleteProject() {
        // 提示1 是否有未完成的task
        // 提示2 根据系统设置是否显示必填原因
        var isHas = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=IsHasNoDoneTask&project_id=<%=thisProject.id %>",
            success: function (data) {
                if (data == "True") {
                    isHas = "1";
                }
            },
        });
        if (isHas != "") {
            LayerConfirm("该项目包含未完成的任务/问题。单击“是”将所有任务和问题标记为完成。点击“否”保持当前状态，停止操作", "是", "否", function () {
        <% var isDoneSet = new EMT.DoneNOW.BLL.SysSettingBLL().GetSetById(EMT.DoneNOW.DTO.SysSettingEnum.PRO_TASK_DONE_REASON);
    if (isDoneSet != null && isDoneSet.setting_value == "1")   // 代表设置为填写原因
    {%>
                $("#ShowReason").show();
                $("#BackgroundOverLay").show();
                $("#SaveAndCloseButton").click(function () {
                    var reason = $("#taskReason").val();
                    if (reason == "") {
                        LayerMsg("请填写任务完成原因");
                    } else {
                        ComPro(reason);
                    }
                })
    <%}
    else
    {%>
                ComPro('');
    <%}
    %>
            }, function () { });
        }


    }
    $("#CloseReason").click(function () {
        $("#ShowReason").hide();
        $("#BackgroundOverLay").hide();
    })
    //// 任务的完成操作--
    //$("#SaveAndCloseButton").click(function () {
    //    var reason = $("#taskReason").val();
    //    if (reason == "") {
    //        LayerMsg("请填写任务完成原因");
    //    } else {
    //        ComPro(reason);
    //    }
    //})

    // 完成项目
    function ComPro(reason) {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=CompleteProject&project_id=<%=thisProject.id %>&reason=" + reason,
            success: function (data) {
                if (data == "True") {

                }
                history.go(0);
            },
        });
    }

    function ProjectSet() {
        $("#ProjectSetting").show();
        $("#BackgroundOverLay").show();
    }
    $("#CloseSet").click(function () {
        $("#ProjectSetting").hide();
        $("#BackgroundOverLay").hide();
    })

    $("#SaveButton").click(function () {
        var resource_daily_hours = $("#resource_daily_hours").val();
        if (resource_daily_hours == "") {
            LayerMsg("请填写总时间");
            return false;
        }
        var useResource_daily_hours = $("#useResource_daily_hours").is(":checked");
        var excludeWeekend = $("#excludeWeekend").is(":checked");
        var excludeHoliday = $("#excludeHoliday").is(":checked");
        var organization_location_id = $("#organization_location_id").val();
        if (organization_location_id == "" || organization_location_id == "0") {
            LayerMsg("请选择区域！");
            return false;
        }
        var warnTime_off = $("#warnTime_off").is(":checked");

        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=UpdateProSet&project_id=<%=thisProject.id %>&resource_daily_hours=" + resource_daily_hours + "&useResource_daily_hours=" + useResource_daily_hours + "&excludeWeekend=" + excludeWeekend + "&excludeHoliday=" + excludeHoliday + "&organization_location_id=" + organization_location_id + "&warnTime_off=" + warnTime_off,
            success: function (data) {
                if (data == "True") {

                }
                history.go(0);
            },
        });
    })

    function RecalculateProject() {
        LayerConfirm("重新计算项目日程可能会改变任务、阶段、问题的开始日期/结束日期。 如果您在项目设置中,指定在日程安排中排除非工作日和节假日，则在重新计算日程时，将会遵守这些设置。你确定要这样做吗？", "是", "否", function () {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=RecalculateProject&project_id=<%=thisProject.id %>",
                success: function (data) {
                    history.go(0);
                },
            });

        }, function () { });
    }
    // 跳转到基准相关界面
    function ShowBusLine() {
        location.href = "ProjectBaseLine?project_id=<%=thisProject.id %>&pageShowType=1&QeryTypeId=<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_BASELINE %>";
    }
    // 滑动操作--批量更改开始时间和结束时间
    function Slide() {
        $("#SildeDays").show();
        $("#BackgroundOverLay").show();
    }
    function CloseSileDay() {
        $("#SildeDays").hide();
        $("#BackgroundOverLay").hide();
    }
    $("#SaveSildeDays").click(function () {
        var ids = GetChooseTaskId(); // SildeDaysNum
        var sildays = $("#SildeDaysNum").val();

        if (ids == "") {
            LayerMsg("前选择任务");
            return false;
        }
        if (sildays == "" || isNaN(sildays)) {
            LayerMsg("请填写滑动天数");
            return false;
        }
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=ChangeTaskTime&ids=" + ids + "&days=" + sildays,
            success: function (data) {
                $("#SildeDays").hide();
                $("#BackgroundOverLay").hide();
                history.go(0);
            },
        });
    })
    function ShowSetting() {
        $("#SildeDays").hide();
        ProjectSet();
    }
    function ShowReason() {
        $("#ShowReason").show();
        $("#BackgroundOverLay").show();
        $("#SaveAndCloseButton").unbind("click").click(function () {
            var ids = GetChooseTaskId();
            if (ids == "") {
                LayerMsg("请选择任务");
                return false;
            }
            var reason = $("#taskReason").val();
            if (reason == "") {
                LayerMsg("请填写任务完成原因");
                return false;
            }

            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=CompleteTask&ids=" + ids + "&reason=" + reason,
                success: function (data) {
                    if (data == "True") {

                    }
                    history.go(0);
                },
            });

        })
    }

    function DeieteTask() {
        var phaseId = GetLastChoosePhaseTask();   // 判断有无阶段
        var ids = GetChooseTaskId();
        if (phaseId == "") {
            LayerConfirm("删除不能恢复，是否继续？", "是", "否", function () {

                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ProjectAjax.ashx?act=DeleteTasks&taskIds=" + ids,
                    success: function (data) {
                        if (data == "True") {

                        }
                        history.go(0);
                    },
                });
            }, function () { });
        } else {
            // todo 展示确认信息
            $("#deleteTask").show();
            $("#BackgroundOverLay").show();
        }
    }
    $("#YesButton").click(function () {
        var ids = GetChooseTaskId();
        if (ids == "") {
            LayerMsg("请选择任务");
            return false;
        }
        var thisUrl = "../Tools/ProjectAjax.ashx?act=DeleteTasks&taskIds=" + ids;
        if ($("#ckIsCheck").is(":checked")) {
            thisUrl += "&delSub=1";
        }
        $.ajax({
            type: "GET",
            async: false,
            url: thisUrl,
            success: function (data) {
                if (data == "True") {

                }
                history.go(0);
            },
        });
    })

    $("#NoButton").click(function () {
        $("#deleteTask").hide();
        $("#BackgroundOverLay").hide();
    })
    // 减少缩进
    function Outdent() {
        debugger;
        var firTaskId = GetFirstChooseId();
        if (firTaskId != "") {
            var firstSortNum = "";
            $(".HighImportance.Selected").each(function () {
                firstSortNum = $(this).children().first().children().first().children().first().next().html();
                if (firstSortNum != "") {
                    return false;
                }
            })
            if (firstSortNum != "") {
                var firArr = firstSortNum.split('.');
                if (Number(firArr.length) > Number(1)) {
                    debugger;
                    // requestData("../Tools/ProjectAjax.ashx?act=Outdent&taskId=" + firTaskId, null, function () { })
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: "../Tools/ProjectAjax.ashx?act=Outdend&taskId=" + firTaskId,
                        success: function (data) {
                            history.go(0);
                        },
                    });
                }
            }
        } else {
            LayerMsg("请选择相关任务");
        }
    }
    function GetFirstChooseId() {
        var firstTask = "";
        $(".HighImportance.Selected").each(function () {
            firstTask = $(this).data("val");
            if (firstTask != "") {
                return false;
            }
        })
        return firstTask;
    }
    // 增加缩进
    function Indent() {
        // 判断第一个选中是否满足增加缩进条件（末位不等于1 ）
        debugger;
        var ids = GetChooseTaskId();
        if (ids != "") {
            var idsArr = ids.split(',');
            var firstSortNum = "";
            $(".HighImportance.Selected").each(function () {

                firstSortNum = $(this).children().first().children().first().children().first().next().html();
                if (firstSortNum != "") {
                    return false;
                }
            })
            if (firstSortNum != "") {
                var firArr = firstSortNum.split('.');
                if (Number(firArr[firArr.length - 1]) > 1) {
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: "../Tools/ProjectAjax.ashx?act=Indend&taskId=" + idsArr[0],
                        success: function (data) {
                            if (data == "True") {

                            }
                            history.go(0);
                        },
                    });
                }
            }

        }
    }
</script>

<%--菜单事件相关--%>
<script>
    // MileContextMenu
    var entityid = "";
    var Times = 0;
    $(".ContextMenu").bind("click", function (event) {
        //debugger;
        clearInterval(Times);
        //debugger;
        var oEvent = event;
        entityid = $(this).children().first().val(); // data("val");
        var menu = "";
        //var thisClassName = $(this).prop("className"); attachMenuS expTR
        $(".menu").hide();
        if (!($(this).parent().parent().hasClass("HighImportance")))  // 代表是项目
        {
            menu = document.getElementById("projectMenu");
        }
        else {
            $(".TaskMenu").hide();
            if ($(this).parent().parent().hasClass("phaseTr")) {
                // 修改 完成 删除
                // 备注
                $(".OnlyPharseMenu").show();
            }
            else if ($(this).parent().parent().hasClass("issueTr")) {
                $(".OnlyIssMenu").show();
                $("#ShowHistory").html("查看问题历史");
            }
            else if ($(this).parent().parent().hasClass("taskTr")) {
                $(".OnlyTaskMenu").show();
                $("#ShowHistory").html("查看任务历史");
            }
            menu = document.getElementById("taskMenu");
        }

        // 是否需要输入开始结束时间相关

        var noTimeSetValue = '<%=(new EMT.DoneNOW.BLL.SysSettingBLL().GetSetById(EMT.DoneNOW.DTO.SysSettingEnum.SDK_ENTRY_REQUIRED).setting_value) %>';
        if (noTimeSetValue == '0') {
            $("#AddNoTimeEntryId").css("color", "black");
            $("#AddNoTimeEntryId").click(function () {
                NewAddWorkEntry('1');
            })
            <% if (thisProject.contract_id != null)
    {
        var thisContract = new EMT.DoneNOW.DAL.ctt_contract_dal().FindNoDeleteById((long)thisProject.contract_id);
        if (thisContract != null && thisContract.timeentry_need_begin_end == 1)  // 合同中设置需要输入开始结束时间，则必须输入
        {
%>
            $("#AddNoTimeEntryId").removeAttr("onclick");
            $("#AddNoTimeEntryId").css("color", "grey");

            <%
        }
    }%>

        }
        else if (noTimeSetValue == '1') {
            $("#AddNoTimeEntryId").removeAttr("onclick");
            $("#AddNoTimeEntryId").css("color", "grey");
        }



        // else if ($(this).hasClass("noteTR")) {
        //    menu = document.getElementById("noteMenu");
        //} else if ($(this).hasClass("atachTR")) {
        //    menu = document.getElementById("attachMenu");
        //} else if ($(this).hasClass("expTR")) {
        //    menu = document.getElementById("expMenu");
        //}


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

    function DeleteProject() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=DisProject&project_id=<%=thisProject.id %>",
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result == "True") {

                    } else {
                        LayerMsg(data.reason);
                    }
                }

                history.go(0);
            },
        });
    }
    function NewAddNote(type) {
        if (entityid != "" && entityid != undefined) {
            if (type == "projetc") {
                window.open("TaskNote.aspx?project_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_NOTE_ADD %>', 'left=200,top=200,width=1080,height=800', false);
            } else {
                window.open("TaskNote.aspx?task_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_NOTE_ADD %>', 'left=200,top=200,width=1080,height=800', false);
            }

        }
    }
    function NewAddTaskAtt() {
        if (entityid != "" && entityid != undefined) {
            window.open("../Activity/AddAttachment.aspx?objId=" + entityid +"&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.TASK %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_ATTACH %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }
    function NewAddProjectAtt() {
        if (entityid != "" && entityid != undefined) {
            window.open("../Activity/AddAttachment.aspx?objId=" + entityid +"&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.PROJECT %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJETC_ATTACH %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }
    function NewAddCharge() {
        if (entityid != "" && entityid != undefined) {
            LayerMsg('待添加');
        }
    }
    function NewAddExpense(type) {
        if (entityid != "" && entityid != undefined) {
            if (type == "projetc") {
                window.open("ExpenseManage.aspx?project_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_ADD %>', 'left=200,top=200,width=1080,height=800', false);
            } else {
                window.open("ExpenseManage.aspx?task_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_EXPENSE_ADD %>', 'left=200,top=200,width=1080,height=800', false);
            }
        }
    }
    // 修改
    function EditObject(type) {
        if (entityid != "" && entityid != undefined) {
            if (type == "projetc") {
                window.open("ProjectAddOrEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.PROJECT_EDIT %>', 'left=200,top=200,width=1080,height=800', false);
            } else {
                window.open("TaskAddOrEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKEDIT %>', 'left=200,top=200,width=1080,height=800', false);
            }
        }
    }
    // 查看任务详情
    function TaskViewDetails() {
        if (entityid != "" && entityid != undefined) {
            window.open("TaskView.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKVIEW %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }
    // 查看任务历史
    function TaskViewHistory() {
        if (entityid != "" && entityid != undefined) {
            window.open("TaskHistory.aspx?task_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKVIEW %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }
    // 新增工时 是否需要输入时间
    function NewAddWorkEntry(NoTime) {
        if (entityid != "" && entityid != undefined) {
            window.open("WorkEntry.aspx?task_id=" + entityid + "&NoTime=" + NoTime, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKVIEW %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }

    // 复制任务
    function CopThisTask() {
        if (entityid != "" && entityid != undefined) {
            window.open("TaskAddOrEdit.aspx?id=" + entityid + "&IsCopy=1", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKEDIT %>', 'left=200,top=200,width=1080,height=800', false);
        }

    }

    // 添加到任务库 
    function AddToLibary() {
        if (entityid != "" && entityid != undefined) {
            window.open("TaskToLibrary.aspx?task_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_TO_LIBARY %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }

    function DeleteTask() {
        if (entityid != "" && entityid != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=DeleteTasks&taskIds=" + entityid,
                success: function (data) {
                    if (data == "True") {

                    }
                    history.go(0);
                },
            });
        }
    }
    // 获取选中的task 批量修改
    function ModifyManyTask() {
        var ids = GetChooseTaskId();
        if (ids != "") {
            window.open("TaskModify.aspx?taskIds=" + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_MODIFY %>', 'left=200,top=200,width=1080,height=800', false);
        } else {
            LayerMsg("请选择任务");
        }
    }
    // 单个任务修改
    function ModifySingTask() {
        if (entityid != "" && entityid != undefined) {
            window.open("TaskModify.aspx?taskIds=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASK_MODIFY %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }
    function CompleteSingTask() {
        $("#ShowReason").show();
        $("#BackgroundOverLay").show();
        $("#SaveAndCloseButton").unbind("click").click(function () {

            if (entityid == "" || entityid == undefined) {
                LayerMsg("前选择任务");
                return false;
            }
            var reason = $("#taskReason").val();
            if (reason == "") {
                LayerMsg("请填写任务完成原因");
                return false;
            }

            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=CompleteTask&ids=" + entityid + "&reason=" + reason,
                success: function (data) {
                    if (data == "True") {

                    }
                    history.go(0);
                },
            });

        })
    }
    // 单个task减少缩进
    function OutSingTask() {
        if (entityid != "" && entityid != undefined) {
            var firstSortNum = $("#" + entityid + "_sort_no").val();
            if (firstSortNum != "") {
                var firArr = firstSortNum.split('.');
                if (Number(firArr.length) > Number(1)) {
                    debugger;
                    // requestData("../Tools/ProjectAjax.ashx?act=Outdent&taskId=" + firTaskId, null, function () { })
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: "../Tools/ProjectAjax.ashx?act=Outdend&taskId=" + entityid,
                        success: function (data) {
                            history.go(0);
                        },
                    });
                } else {
                    LayerMsg("不满足减少缩进条件");
                }
            }
        }
    }
    // 单个task增加缩进
    function InSingTask() {
        if (entityid != "" && entityid != undefined) {
            var firstSortNum = $("#" + entityid + "_sort_no").val();
            if (firstSortNum != "") {
                var firArr = firstSortNum.split('.');
                if (Number(firArr[firArr.length - 1]) > 1) {
                    $.ajax({
                        type: "GET",
                        async: false,
                        url: "../Tools/ProjectAjax.ashx?act=Indend&taskId=" + entityid,
                        success: function (data) {
                            if (data == "True") {

                            }
                            history.go(0);
                        },
                    });
                } else {
                    LayerMsg("不满足增加缩进条件");
                }
            }
        }

    }

    function AddChangeOrder() {
        if (entityid != "" && entityid != undefined) {
            // cost_code_id
            window.open("../Contract/AddCharges.aspx?task_id=" + entityid +"&cost_code_id=<%=(int)EMT.DoneNOW.DTO.CostCode.CHANGEORDER %>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeAdd %>', 'left=200,top=200,width=1080,height=800', false);
        }
    }

</script>
<%--拖拽相关js--%>
<script>
    function DragTask() {

        var fromId = GetFirstChooseId();
        debugger;
        if (fromId != "" && toId != "" && type != "" && fromId != toId && toId != null && toId != undefined) {

            var chooseId = GetChooseTaskId();  // 如果 toId 在选中的taskID中，则不进行操作

            var choIdArr = chooseId.split(',');
            var isHas = "";
            for (var i = 0; i < choIdArr.length; i++) {
                if (choIdArr[i] == toId) {
                    isHas = "1";
                    return false;
                }
            }
            // alert(toId);
            if (isHas == "") {
                var checkNumUrl = "../Tools/ProjectAjax.ashx?act=GetTaskSubNum&task_id=" + toId;
                if (type != "") {
                    checkNumUrl += "&is_sub=1";
                }
                $.ajax({
                    type: "GET",
                    async: false,
                    url: checkNumUrl,
                    success: function (data) {
                        if (data == "99") {
                            LayerMsg("所选任务子任务过多，请选择其他任务！");
                            return;
                        }
                    },
                });


                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/ProjectAjax.ashx?act=ChangeTaskParent&fromId=" + fromId + "&location=" + type + "&toId=" + toId +"&project_id=<%=thisProject.id %>",
                    success: function (data) {
                        if (data == "True") {

                        }
                        history.go(0);
                    },
                });
            }
            //alert(fromId);
            //alert(toId);
            //alert(type);
        }

    }
    // 显示进度预警
    function ShowAlarm(task_id) {

        var isShow = 0;
        debugger;
        // 在前驱任务之前完成
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=DoneBeforePro&task_id=" + task_id,
            success: function (data) {
                if (data == "1") {
                    isShow += 1;
                    $("#qianquAlarm").show();
                }
            },
        });
        // 任务有开始时间不早于 字段
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetSinTask&task_id=" + task_id,
            dataType: "json",
            success: function (data) {
                if (data != "" && data.start_no_earlier_than_date != null && data.start_no_earlier_than_date != "") {
                    var thisDate = new Date(data.start_no_earlier_than_date);
                    $("#taskStratThanSpan").html(thisDate.getFullYear() + "-" + Number(thisDate.getMonth() + 1) + "-" + thisDate.getDate());
                    isShow += 1;
                    $("#clearEarilyThan").show();
                }

            },

        });
        // 检查任务的开始结束时间是否在节假日和周末时间内
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=CheckTask&task_id=" + task_id,
            dataType: "json",
            success: function (data) {
                debugger;
                if (data != "") {
                    debugger;
                    if (data.staInWeek) {
                        $("#dateNotInWeek").show();
                        isShow += 1;
                    }
                    if (data.hasIds) {
                        $("#NoDoneOnTimeDiv").show();
                        $("#thisTaskStartSpan").html(data.start);
                        $("#thisTaskEndSpan").html(data.end);
                        $("#TaskIdsSpan").html(data.ids);
                        isShow += 1;
                    }

                }

            },

        });
        // 任务计划范围内 负责人有请假记录
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=CheckResTimeOff&task_id=" + task_id,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    isShow += 1;
                    $("#resTimeOffDiv").show();
                    $("#timeOffSpan").html(data.time);
                    $("#doneTimeSpan").html(data.doneTime);
                }
            }
        });
        if (Number(isShow) >= 1) {
            $("#ShowTaslAlarm").show();
            $("#BackgroundOverLay").show();
            $("#ShowAlertTaskId").val(task_id);
        }



    }
    function CloseTaskAlarm() {
        $("#ShowTaslAlarm").hide();
        $("#BackgroundOverLay").hide();
        $("#ShowAlertTaskId").val("");
        $("#qianquAlarm").hide();
        $("#clearEarilyThan").hide();
        $(".ShowAlarm").hide();
    }
    $("#ChangePreTask").click(function () {
        var ShowAlertTaskId = $("#ShowAlertTaskId").val();
        if (ShowAlertTaskId != "") {
            var disBef = $("#DisBeforTask").is(":checked");
            var disAft = $("#DisAfterTask").is(":checked");
            if (disBef || disAft) {
                var ChangeUrl = "../Tools/ProjectAjax.ashx?act=DisPreTask&task_id=" + ShowAlertTaskId;
                if (disBef) {
                    ChangeUrl += "&dis_bef=1";
                }
                if (disAft) {
                    ChangeUrl += "&dis_aft=1";
                }
                $.ajax({
                    type: "GET",
                    async: false,
                    url: ChangeUrl,
                    dataType: "json",
                    success: function (data) {

                        $("#ShowTaslAlarm").hide();
                        $("#BackgroundOverLay").hide();
                        $("#ShowAlertTaskId").val("");
                        $("#qianquAlarm").hide();
                        $("#clearEarilyThan").hide();

                        history.go(0);
                    },
                });
            }
        }

        // CloseTaskAlarm();
    })

    $("#ClearStartThanButton").click(function () {
        var ShowAlertTaskId = $("#ShowAlertTaskId").val();
        if (ShowAlertTaskId != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ProjectAjax.ashx?act=ClearStartThan&task_id=" + ShowAlertTaskId,
                //dataType: "json",
                success: function (data) {

                    $("#ShowTaslAlarm").hide();
                    $("#BackgroundOverLay").hide();
                    $("#ShowAlertTaskId").val("");
                    $("#qianquAlarm").hide();
                    $("#clearEarilyThan").hide();
                    LayerMsg("清除成功");
                    setTimeout(function () { history.go(); }, 1500)

                },
            });
        }
        // CloseTaskAlarm();
    })



    $("#CheckAll_2").click(function () {
        if ($(this).is(":checked")) {
            $("#choProTaskList>.HighImportance").each(function () {
                var thisValue = $(this).data("val");
                if (thisValue != "" && thisValue != null && thisValue != undefined) {
                    if (!$(this).hasClass("Selected")) {
                        $(this).addClass("Selected");
                    }
                }
            })
        }
        else {
            $("#choProTaskList>.HighImportance").each(function () {
                var thisValue = $(this).data("val");
                if (thisValue != "" && thisValue != null && thisValue != undefined) {
                    if ($(this).hasClass("Selected")) {
                        $(this).removeClass("Selected");
                    }
                }
            })
        }
    })

    function AddToWorkList(resIds, taskId) {
        if (resIds == "" || taskId == "") {
            return;
        }
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/IndexAjax.ashx?act=AddWorkList&resIds=" + resIds + "&taskId=" + taskId,
            dataType: "json",
            success: function (data) {
                if (data) {
                    LayerMsg("添加成功！");
                } else {
                    LayerMsg("添加失败！");
                }
            },
        });
    }
    //entityid
    // 添加到我的工作列表
    function AddToMyWorkList() {
        if (entityid != "") {
            AddToWorkList('<%=LoginUserId %>', entityid);
        }
    }
    // 添加到主负责人的工作列表
    function AddToPriResWorkList() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetSinTask&task_id=" + entityid,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.owner_resource_id != "" && data.owner_resource_id != null && data.owner_resource_id != undefined) {
                        AddToWorkList(data.owner_resource_id, entityid);
                    } else {
                        LayerMsg("暂无主负责人");
                    }
                }
            },
        });
    }
    // 添加到其他负责人的工作列表
    function AddToOtherResWorkList() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ProjectAjax.ashx?act=GetSinTask&task_id=" + entityid,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    $("#ToOtherTaskNo").text(data.no);
                }
            },
        });

        $("#BackgroundOverLay").show();
        $("#ShowAddOtherDiv").show();
    }

    function CloseDigAddOtherDiv() {
        $("#BackgroundOverLay").hide();
        $("#ShowAddOtherDiv").hide();
    }
</script>
