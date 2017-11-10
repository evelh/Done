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
    </style>
    <title></title>
</head>
<body>
    <form runat="server">



        <div class="ButtonContainer">
            <ul>
                <!--报表切换按钮-->
                <li class="Button ButtonIcon" id="TableButton" tabindex="0" title="切换报表">
                    <span class="Icon Table"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <li class="Button ButtonIcon" id="AddButton" tabindex="0" title="新建" style="margin-right: -5px;">
                    <span class="Icon Add"></span>
                    <span class="Text">新建</span>
                </li>
                <li class="Button ButtonIcon" id="DownButton" tabindex="0" style="padding: 0;">
                    <span class="Icon Down"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <!--第一个下拉-->
                <li class="DropDownButton" style="top: 27px; left: 49px;" id="Down1">
                    <div class="DropDownButtonDiv">
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">在下面打开</div>
                            </div>
                            <div class="Content">
                                <div class="Button1" id="NewTaskButton" tabindex="0">
                                    <span class="Text">任务</span>
                                </div>
                                <div class="Button1" id="NewPhaseButton" tabindex="0">
                                    <span class="Text">阶段</span>
                                </div>
                                <div class="Button1" id="NewIssueButton" tabindex="0">
                                    <span class="Text">问题</span>
                                </div>
                            </div>
                        </div>
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">在新的弹窗打开</div>
                            </div>
                            <div class="Content">
                                <div class="Button1" id="NewTaskInCurrentPageButton" tabindex="0" onclick="AddNewTask('<%=(int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_TASK %>')">
                                    <span class="Text">任务</span>
                                </div>
                                <div class="Button1" id="NewPhaseInCurrentPageButton" tabindex="0" onclick="AddNewTask('<%=(int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE %>')">
                                    <span class="Text">阶段</span>
                                </div>
                                <div class="Button1" id="NewIssueInCurrentPageButton" tabindex="0" onclick="AddNewTask('<%=(int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_ISSUE %>')">
                                    <span class="Text">问题</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
                <li class="Button ButtonIcon" id="ViewButton" tabindex="0">
                    <span class="Text">视图</span>
                    <span class="Icon Right"></span>
                </li>
                <!--第二个下拉-->
                <li class="DropDownButton" style="top: 27px; left: 141px;" id="Down2">
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
                                <div class="Button1" id="BaselineButton" tabindex="0" onclick="ChangeShowPage('<%=(int)EMT.DoneNOW.DTO.QueryType.PROJECT_BASELINE %>','phaseBudHours')">
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
                <li class="Button ButtonIcon" id="ToolsButton" tabindex="0">
                    <span class="Text">工具</span>
                    <span class="Icon Right"></span>
                </li>
                <!--第三个下拉-->
                <li class="DropDownButton" style="top: 27px; left: 210px;" id="Down3">
                    <div class="DropDownButtonDiv">
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">导入</div>
                            </div>
                            <div class="Content">
                                <div class="Button1" id="ImportFromExcelButton" tabindex="0">
                                    <span class="Text">.CSV文件</span>
                                </div>
                                <div class="Button1" id="ImportFromAutotaskTemplateButton" tabindex="0" onclick="ImportFromTemp()">
                                    <span class="Text">从模板导入</span>
                                </div>
                            </div>
                        </div>
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">将项目保存为……</div>
                            </div>
                            <div class="Content">
                                <div class="Button1" id="SaveAsBaselineButton" tabindex="0">
                                    <span class="Text">保存为基准</span>
                                </div>
                                <div class="Button1" id="SaveAsTemplateButton" tabindex="0" onclick="SaveAsTemp()">
                                    <span class="Text">保存为模板</span>
                                </div>
                            </div>
                        </div>
                        <div class="Group">
                            <div class="Heading">
                                <div class="Text">其他</div>
                            </div>
                            <div class="Content">
                                <div class="Button1" id="CompleteProjectButton" tabindex="0">
                                    <span class="Text">项目标记为完成</span>
                                </div>
                                <div class="Button1" id="WorkloadReport" tabindex="0">
                                    <span class="Text">查看工作报告</span>
                                </div>
                                <div class="Button1" id="RecalculateProjectScheduleButton" tabindex="0">
                                    <span class="Text">重新计算项目进度</span>
                                </div>
                                <div class="Button1" id="ScheduleSettingsButton" tabindex="0">
                                    <span class="Text">编辑项目设置</span>
                                </div>
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
                <li class="Button ButtonIcon" id="ExportButton" tabindex="0" title="导出">
                    <span class="Icon Export"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <li class="Button ButtonIcon" id="UseResourceCapacityForLevelingButton" tabindex="0">
                    <span class="Icon" style="margin: 0 0 3px 0; width: 12px;">
                        <input type="checkbox" style="vertical-align: middle;">
                    </span>
                    <span class="Text">使用容量来计算持续时间</span>
                </li>
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

                <div class="RowContainer" style="height: 600px; top: 30px;">
                    <table cellpadding="0">
                        <tbody id="Drap" class="Drap">
                            <%if (queryResult != null && queryResult.count > 0)
                                {
                                    var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);

                            %>
                            <tr class="HeadingRow">
                                <td class="FirstRowPrevent" width="60px">
                                    <div class="Standard">
                                        <div class="DropDownButtonContainer">
                                            <div class="Button ButtonIcon" tabindex="0" style="outline: none; z-index: 21; cursor: pointer;">
                                                <span class="Text">
                                                    <input type="checkbox" class="vm" id="LeftSelectButton">
                                                </span>
                                                <span class="Icon Right vm" id="TableDropButton"></span>
                                            </div>
                                            <!--下拉框-->
                                            <div class="DropDownButton" style="top: 53px; left: 10px; z-index: 20;" id="Down5">
                                                <div class="DropDownButtonDiv">
                                                    <div class="Group">
                                                        <div class="Content">
                                                            <div class="Button1" id="OutdentButton" tabindex="0">
                                                                <span class="Text">减少缩进</span>
                                                            </div>
                                                            <div class="Button1" id="IndentButton" tabindex="0">
                                                                <span class="Text">增加缩进</span>
                                                            </div>
                                                            <div class="Button1" id="ForwardModifyButton" tabindex="0">
                                                                <span class="Text">提出修改</span>
                                                            </div>
                                                            <div class="Button1" id="AddToMyWorkListButton" tabindex="0">
                                                                <span class="Text">添加到我的工作列表中</span>
                                                            </div>
                                                            <div class="Button1" id="SlideButton" tabindex="0">
                                                                <span class="Text">幻灯片</span>
                                                            </div>
                                                            <div class="Button1" id="TableCompleteButton" tabindex="0">
                                                                <span class="Text">完成</span>
                                                            </div>
                                                            <div class="Button1" id="TableDeleteButton" tabindex="0">
                                                                <span class="Text">删除</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
                                %>
                                <td width="<%=para.length * 32 %>px">
                                    <%=para.name %>
                                </td>
                                <%} %>

                                <%if (pageShowType == "phaseBudHours")
                                    { %>
                                <td width="100px">阶段预估时间</td>
                                <%} %>
                            </tr>
                            <%
                                foreach (var rslt in queryResult.result)
                                {
                                    bool IsContinue = false; // 对数据进行过滤
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
                                    //    switch (pageShowType)
                                    //    {
                                    //        case "phase":
                                    //            if (thisTask.type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                                    //            {
                                    //                IsContinue = true;
                                    //            }
                                    //            break;
                                    //        case "TaskComplete":
                                    //            if (thisTask.type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                                    //            {
                                    //                if (thisTask.status_id != (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE)
                                    //                {
                                    //                    IsContinue = true;
                                    //                }
                                    //            }
                                    //            break;
                                    //        case "TaskNoComplete":
                                    //            if (thisTask.type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                                    //            {
                                    //                if (thisTask.status_id == (int)EMT.DoneNOW.DTO.DicEnum.TICKET_STATUS.DONE)
                                    //                {
                                    //                    IsContinue = true;
                                    //                }
                                    //            }
                                    //            break;
                                    //        case "ExpiredTask":
                                    //            if (thisTask.type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                                    //            {
                                    //                if ((DateTime)thisTask.estimated_end_date < DateTime.Now)
                                    //                {
                                    //                    IsContinue = true;
                                    //                }
                                    //            }
                                    //            break;
                                    //        case "Issues":
                                    //            if (thisTask.type_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_TASK)
                                    //            {
                                    //                IsContinue = true;
                                    //            }
                                    //            break;
                                    //        case "phaseBudHours":
                                    //              if (thisTask.type_id != (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PROJECT_PHASE)
                                    //            {
                                    //                IsContinue = true;
                                    //            }
                                    //            break;
                                    //        default:
                                    //            break;
                                    //    }

                                    //}



                                    //if (IsContinue)
                                    //{
                                    //    continue;
                                    //}



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
                                <td class="Context  U1"><a class="ButtonIcon Button ContextMenu NormalState menu">
                                    <div class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -193px -97px; width: 15px;"></div>
                                </a></td>

                                <%}
                                    else if (para.name == "sort_order")
                                    { continue; }
                                    else if (para.name == "告警")
                                    {
                                        if (rslt[para.name].ToString() == "0")
                                        {
                                %>
                                <td></td>
                                <%
                                    }
                                    else if (rslt[para.name].ToString() == "1")
                                    {
                                %>
                                <td>
                                    <div><span class="Icon" style="background: url(../Images/ButtonBarIcons.png) no-repeat -80px -32px;"></span></div>
                                </td>
                                <%
                                    }
                                    else if (rslt[para.name].ToString() == "　")
                                    {
                                %>
                                <td>
                                    <div><span class="Icon" style="background: url(<%=rslt[para.name] %>)"></span></div>
                                </td>
                                <%
                                    }
                                    else
                                    {%>
                                <td></td>
                                <%}
                                    }
                                    else if (para.name == " ")
                                    {%>
                                <td>替换图标</td>
                                <%}
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
                    <div class="CancelDialogButton"></div>
                    <div class="TitleBar">
                        <div class="Title">
                            <span class="text">保存为模板</span>
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
                                <div style="width: 25%;" class="Item Current ChooseTempIcon">
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

                                <div style="width: 25%;" class="Item Previous GenInfo">
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
                                                                    <td class="Interaction">
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

                                <div style="width: 25%;" class="Item Current ChooseTempIcon">
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

                                <div style="width: 25%;" class="Item Previous GenInfo">
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
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<%--<script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>--%>
<%//弹窗相关的js %>
<script>
    $(function () {
        debugger;
        $("#Nav2").hide();
        $("#BackgroundOverLay").hide();
      <% if (isTransTemp)
    { %>
        SaveAsTemp();

      <%}%>


    })

    $(".CancelDialogButton").on("click", function () {
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
    // 修改task
    function EditTask() {

    }
</script>
<%// 页面相关js %>
<script>
    (function ($) {
        var dragging, placeholders = $();
        $.fn.sortable = function (options) {
            options = options || {};
            return this.each(function () {
                if (/^enable|disable|destroy$/.test(options)) {
                    var items = $(this).children($(this).data('items')).attr('draggable', options == 'enable');
                    options == 'destroy' && items.add(this)
                        .removeData('connectWith').removeData('items')
                        .unbind('dragstart.h5s dragend.h5s selectstart.h5s dragover.h5s dragenter.h5s drop.h5s');
                    return;
                }
                var index, items = $(this).children(options.items), connectWith = options.connectWith || false;
                var placeholder = $('<' + items[0].tagName + ' class="sortable-placeholder">');
                var handle = options.handle, isHandle;
                items.find(handle).mousedown(function () {
                    isHandle = true;
                }).mouseup(function () {
                    isHandle = false;
                });
                $(this).data('items', options.items)
                placeholders = placeholders.add(placeholder);
                if (connectWith) {
                    $(connectWith).add(this).data('connectWith', connectWith);
                }
                items.attr('draggable', 'true').bind('dragstart.h5s', function (e) {
                    if (handle && !isHandle) {
                        return false;
                    }
                    isHandle = false;
                    var dt = e.originalEvent.dataTransfer;
                    dt.effectAllowed = 'move';
                    dt.setData('Text', 'dummy');
                    dragging = $(this).addClass('sortable-dragging');
                    index = dragging.index();
                }).bind('dragend.h5s', function () {
                    dragging.removeClass('sortable-dragging').fadeIn();
                    placeholders.detach();
                    if (index != dragging.index()) {
                        items.parent().trigger('sortupdate');
                    }
                    dragging = null;
                }).not('a[href], img').bind('selectstart.h5s', function () {
                    this.dragDrop && this.dragDrop();
                    return false;
                }).end().add([this, placeholder]).bind('dragover.h5s dragenter.h5s drop.h5s', function (e) {
                    if (!items.is(dragging) && connectWith !== $(dragging).parent().data('connectWith')) {
                        return true;
                    }
                    if (e.type == 'drop') {
                        e.stopPropagation();
                        placeholders.filter(':visible').after(dragging);
                        return false;
                    }
                    e.preventDefault();
                    e.originalEvent.dataTransfer.dropEffect = 'move';
                    if (items.is(this)) {
                        dragging.hide();
                        $(this)[placeholder.index() < $(this).index() ? 'after' : 'before'](placeholder);
                        placeholders.not(placeholder).detach();
                    }
                    return false;
                });
            });
        };
    })(jQuery);
    $("#DownButton").on("mousemove", function () {
        $("#Down1").show();
        $(this).css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $("#Down1").hide();
        $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#Down1").on("mousemove", function () {
        $(this).show();
        $("#DownButton").css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $(this).hide();
        $("#DownButton").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#ViewButton").on("mousemove", function () {
        $("#Down2").show();
        $(this).css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $("#Down2").hide();
        $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#Down2").on("mousemove", function () {
        $(this).show();
        $("#ViewButton").css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $(this).hide();
        $("#ViewButton").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#ToolsButton").on("mousemove", function () {
        $("#Down3").show();
        $(this).css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $("#Down3").hide();
        $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#Down3").on("mousemove", function () {
        $(this).show();
        $("#ToolsButton").css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $(this).hide();
        $("#ToolsButton").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#LinksButton").on("mousemove", function () {
        $("#Down4").show();
        $(this).css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $("#Down4").hide();
        $(this).css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#Down4").on("mousemove", function () {
        $(this).show();
        $("#LinksButton").css("border-bottom", "1px solid white").css("background", "white");
    }).on("mouseout", function () {
        $(this).hide();
        $("#LinksButton").css("border-bottom", "1px solid #d7d7d7").css("background", "linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%)");
    });
    $("#TableDropButton").on("mousemove", function () {
        $("#Down5").show().css("border-top", "1px solid white");
        $(this).addClass('DropDownButtonCss');
    }).on("mouseout", function () {
        $("#Down5").hide();
        $(this).removeClass('DropDownButtonCss');
    });
    $("#Down5").on("mousemove", function () {
        $(this).show().css("border-top", "1px solid white");
        $("#TableDropButton").addClass('DropDownButtonCss');
    }).on("mouseout", function () {
        $(this).hide();
        $("#TableDropButton").removeClass('DropDownButtonCss');
    });

    //日历的弹框
    $(".calendar").on("click", function () {
        $(".AlertMessage").show();
        $("#BackgroundOverLay").show();
        $("#yes").on("click", function () {
            $(".AlertMessage").hide();
            $("#BackgroundOverLay").hide();


        });
        $("#no").on("click", function () {
            $(".AlertMessage").hide();
            $("#BackgroundOverLay").hide();
        });
        $(".CancelDialogButton").on("click", function () {
            $(".AlertMessage").hide();
            $("#BackgroundOverLay").hide();
        });
    });
    //第一级拖拽
    function changeNum() {
        $(".D").each(function () {
            var indexNum = $(".D").index(this);
            var a = indexNum + 1;
            $(this).find(".Num").text(a);
        });
    }
    $(function () {
        $('.Drap').sortable().bind('sortupdate', function () {
            //changeNum();
        });
    });

    //选中及其子集
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
    //缩进
    function Style() {
        for (i in $(".Spacer")) {
            var Width = $(".Spacer").eq(i).parent().attr('data-depth') * 22 + 'px';
            $(".Spacer").eq(i).width(Width).css('min-width', Width);
        }
    }
    Style();
    //缩小展开
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

    //点击全选全部选
    $("#LeftSelectButton").on("click", function () {
        var _this = $(this);
        if (_this.is(':checked')) {
            $(".D").addClass('Selected');
        } else {
            $(".D").removeClass('Selected');
        }
    });




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
        var ids = "";
        $("#HighImportance").each(function () {
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
    function ChangeShowPage(queryType,showType) {
        location.href = "ProjectSchedule?project_id=<%=thisProject.id %>&pageShowType=" + showType + "&QeryTypeId=" + queryType;
    }

    function AddNewTask(type_id) {
        // 获取页面选中
        var parent_id = GetLastChoosePhaseTask();

        window.open("TaskAddOrEdit.aspx?project_id=<%=thisProject.id %>&par_task_id=" + parent_id + "&type_id=" + type_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TASKADD %>', 'left=200,top=200,width=600,height=800', false);
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
        $("#BackgroundOverLay").show();
        $("#FirstStep2").hide();
        //$("#prev2_2").on("click", function () {


        //    $("#FirstStep2").show();
        //    $("#AddStep2").hide();
        //});
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
                    }, function () { });
                } else {
                    ids = ids.substring(0, ids.length - 1);
                    $("#SecondStep2").hide();
                    $("#ThirdStep2").show();
                    $("#TempChooseTaskids").val(ids);
                }


            });
            $("#AddStep2").hide();
            $("#SecondStep2").show();
        });
        $("#prev3_2").on("click", function () {
            $("#AddStep2").show();
            $("#SecondStep2").hide();
        });
   
        $("#prev4_2").on("click", function () {
            $("#SecondStep2").show();
            $("#ThirdStep2").hide();
        });

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
        $("#BackgroundOverLay").show();
        $("#AddStep2").hide();
        $("#FirstStep2").show();
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
                $("#FirstStep2").hide();
                $("#SecondStep2").show();
            } else {
                LayerMsg("请选择项目模板！");
            }

        })

        $("#prev3_2").on("click", function () {
            $("#FirstStep2").show();
            $("#SecondStep2").hide();
        });
      
        $("#prev4_2").on("click", function () {
            $("#SecondStep2").show();
            $("#ThirdStep2").hide();
        });
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
            LayerConfirm("项目基准已经存在，是否重新创建", "确定", "取消", function () { isAdd = "1"; }, function () { });
        }
        if (isAdd == "1") {
            // 新增基准
        }
    }

</script>
