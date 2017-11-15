<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectBaseLine.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectBaseLine" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/NewConfigurationItem.css" rel="stylesheet" />
     <link href="../Content/Project.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
         <div class="ButtonContainer">
            <ul>
                <!--报表切换按钮-->
                <li class="Button ButtonIcon" id="TableButton" tabindex="0" title="切换报表">
                    <span class="Icon Table"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <li class="Button ButtonIcon" id="ViewButton" tabindex="0">
                    <span class="Text">视图</span>
                    <span class="Icon Right"></span>
                </li>
                <!--第二个下拉-->
                <li class="DropDownButton" style="top: 27px; left: 48px;" id="Down2">
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
  
                <li class="Button ButtonIcon" id="LinksButton" tabindex="0">
                    <span class="Text">链接</span>
                    <span class="Icon Right"></span>
                </li>
                <!--第四个下拉-->
                <li class="DropDownButton" style="top: 27px; left: 118px;" id="Down4">
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
                            <tr class="HeadingRow" style="background-color: #96b4cb;">
                              
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
                                        if (para.name == "'#'" || para.name == "sort_order"||para.name == "告警")
                                        {
                                            continue;
                                        }
                                %>
                                <td width="<%=para.length * 32 %>px">
                                    <%=para.name %>
                                </td>
                                <%} %>
                            </tr>
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
                                            continue;
                                %>

                                <%}
                                    else if (para.name == "sort_order")
                                    { continue; }
                                    else if (para.name == "告警")
                                    {
                                        continue;
                                    }
                                    else if (para.name == "里程碑数")
                                    {
                                        var thisArr = rslt["里程碑数"] as byte[];
                                        %>
                                <td><%=thisArr==null?"":thisArr.Count().ToString() %></td>
                                <%
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
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
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
</script>
<script>
    // 根据选择的条件过滤页面上的数据
    function ChangeShowPage(queryType, showType) {
        location.href = "ProjectSchedule?project_id=<%=thisProject.id %>&pageShowType=" + showType + "&QeryTypeId=" + queryType;
    }

    $("#TableButton").click(function () {
        // 跳转到图形列表
        location.href = "ProjectChart?project_id=<%=thisProject.id %>";
    })

</script>
