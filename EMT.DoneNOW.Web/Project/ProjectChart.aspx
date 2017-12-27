<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectChart.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectChart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <title></title>
    <style>
        body {
            overflow: hidden;
        }

        .TitleBar {
            color: #fff;
            background-color: #346a95;
            display: block;
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            line-height: 38px;
            margin: 0 0 10px 0;
        }

            .TitleBar > .Title {
                top: 0;
                height: 36px;
                left: 10px;
                overflow: hidden;
                position: absolute;
                text-overflow: ellipsis;
                text-transform: uppercase;
                white-space: nowrap;
                width: 97%;
            }

        .text2 {
            margin-left: 5px;
            font-weight: normal;
        }

        .help {
            background-image: url(../Images/help.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 10px;
            top: 10px;
            width: 16px;
            border-radius: 50%;
        }
        /*æŒ‰é’®éƒ¨åˆ†*/
        .ButtonContainer {
            padding: 0 10px 10px 10px;
            width: auto;
            height: 26px;
        }

            .ButtonContainer ul li.Button {
                margin-right: 5px;
                vertical-align: top;
                z-index: 21;
            }

        li.Button, a.Button {
            -ms-flex-align: center;
            align-items: center;
            background: #f0f0f0;
            background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
            border: 1px solid #d7d7d7;
            display: -ms-inline-flexbox;
            display: inline-flex;
            color: #4f4f4f;
            cursor: pointer;
            height: 24px;
            padding: 0 3px;
            position: relative;
            text-decoration: none;
        }

            li.Button:hover {
                background: transparent;
            }

        .Button > .Icon {
            display: inline-block;
            flex: 0 0 auto;
            height: 16px;
            margin: 0 3px;
            width: 16px;
        }

        .Button > .Text {
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .Calendar {
            background: transparent url("../Images/calendar.png") no-repeat scroll;
        }

        .Export {
            background: transparent url("../Images/export.png") no-repeat scroll;
        }

        .ButtonContainer ul li.Button.SelectedState {
            background: #f5f5f5;
            box-shadow: inset 0 1px 3px 0 rgba(114,114,114,0.5);
        }
        /*ä¸»ä½“éƒ¨åˆ†*/
        .ScrollingContainer {
            -webkit-overflow-scrolling: touch;
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            padding: 0 10px 0 10px;
            position: absolute;
            right: 0;
        }
        /*ä¸Šå·¦*/
        .Gantt_divTable {
            display: block;
            position: relative;
            overflow: hidden;
        }

        #Gantt_container {
            float: left;
            height: 67px;
        }

        .Gantt_titleFont {
            cursor: default;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            color: #888;
        }

        .Gantt_divTableRowHeader {
            display: table-row;
            overflow: hidden;
            width: 50px;
            height: 67px;
        }

        .Gantt_headerTitle {
            font-weight: 700;
            vertical-align: middle;
            background-color: #ebebeb;
        }

        .Gantt_header {
            cursor: default;
            border-bottom-color: #B7B7B7;
        }

        .Gantt_idHeader {
            text-align: center;
        }

        #Gantt_headerTitle {
            height: 50px;
            width: 100%;
        }

       
        /*ä¸Šå³*/
        #Gantt_dateContainer {
            height: 67px;
        }

        .Gantt_date {
            text-transform: uppercase;
            background-repeat: repeat-x;
            background-color: #ebebeb;
            line-height: 15px;
        }

        .Gantt_titleFont {
            cursor: default;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            color: #888;
        }

        .Gantt_header {
            cursor: default;
            border-bottom-color: #B7B7B7;
        }

        .Gantt_divTableColumn {
            display: table-cell;
            overflow: hidden;
            min-width: 15px;
            max-width: 40px;
            border-right: 1px solid #d7d7d7;
            border-bottom: 1px solid #d7d7d7;
            border-top: 1px solid #d7d7d7;
            padding: 5px;
        }

            .Gantt_divTableColumn:last-child {
                border-right: none;
            }
        /*å‘¨è¡¨æ ¼æ ·å¼*/
        .Gantt_weekDateBox {
            height: 25px;
            white-space: nowrap;
            width: 42px;
        }

        .Gantt_divTableHeader, .Gantt_divWeekTableHeader {
            display: table-cell;
            overflow: hidden;
            min-width: 30px;
            width: 30px;
            border-top: 1px solid #d7d7d7;
            text-align: center;
            padding-top: 4px;
        }

        .Gantt_divWeekTableHeader {
            padding-top: 9px;
        }

        .Gantt_dateMonthYear {
            border-right: 1px solid #CCC;
            border-bottom: 1px solid #CCC;
            vertical-align: middle;
            padding-bottom: 4px;
        }

        .Gantt_monthHolder {
            padding-bottom: 5px;
        }
        /*æœˆè¡¨æ ¼æ ·å¼*/
        .Gantt_dateMonth {
            text-transform: uppercase;
            background-color: #ebebeb;
            max-width: 125px;
            min-width: 100px;
        }
        /*ä¸‹å·¦*/
        #Gantt_taskContainer {
            height: 100%;
            float: left;
        }

        .Gantt_projectTitleFont {
            padding-left: 2px;
        }

        .Gantt_divTableRow {
            display: table-row;
            overflow: hidden;
            width: 50px;
            height: 30px;
        }

        .Gantt_idFont {
            font-size: 11px;
            font-weight: 400;
            font-style: normal;
            text-decoration: none;
            color: #333;
            padding: 4px 0 4px 5px;
        }

        .Gantt_id {
            width: 30px;
            min-width: 30px;
            background-color: #ebebeb;
            border-bottom-color: #ccc;
            border-right-color: #ccc;
            border-top-color: #ccc;
        }

        .Gantt_divTableColumnMonth {
            display: table-cell;
            overflow: hidden;
            min-width: 25px;
            max-width: 350px;
            border-right: 1px solid #d7d7d7;
            border-bottom: 1px solid #d7d7d7;
            padding: 5px;
        }

      

        .Gantt_projectFont {
            font-size: 12px;
            font-weight: 700;
            font-style: normal;
            text-decoration: none;
            color: #666;
        }

        .Gantt_projectTitle {
            padding-bottom: 6px;
        }

        .Gantt_ToggleDiv {
            background: #d7d7d7;
            background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            border: 1px solid #c6c6c6;
            cursor: pointer;
            height: 14px;
            margin: 0 6px 0 0;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
            width: 14px;
            float: left;
            position: relative;
        }

            .Gantt_ToggleDiv .Vertical {
                background-color: #888;
                height: 8px;
                position: absolute;
                left: 6px;
                top: 3px;
                width: 2px;
            }

            .Gantt_ToggleDiv .Horizontal {
                background-color: #888;
                height: 2px;
                left: 3px;
                top: 6px;
                width: 8px;
                position: absolute;
            }

        .Gantt_taskFont {
            cursor: default;
            font-size: 11px;
            font-weight: 400;
            font-style: normal;
            text-decoration: none;
            color: #666;
        }

        .Gantt_blankItem {
            display: table-cell;
            overflow: hidden;
            min-width: 32px;
            max-width: 32px;
            border: transparent;
            padding: 5px;
        }
  

        .Gantt_TodayBar {
            position: absolute;
            height: 23px;
            z-index: 5;
            width: 3px;
        }

        .Gantt_projectBar {
            background-color: #E4E4E4;
            position: absolute;
            margin-top: 8px;
        }

            .Gantt_projectBar div {
                background-color: #666;
                height: 10px;
            }

        .Gantt_phaseBar {
            background-color: #EEEEF9;
            position: absolute;
            border-color: #D2D2F0;
            border-style: solid;
            border-width: 1px;
            margin-top: 8px;
        }

            .Gantt_phaseBar div {
                background-color: #D2D2F0;
                width: 70%;
                height: 10px;
            }

        .Gantt_leftCorner {
            background: url(../Images/ganttsprite.png);
            position: absolute;
            width: 9px;
            height: 16px;
            left: -1px;
            top: -1px;
        }

        .Gantt_rightCorner {
            background: url(../Images/ganttsprite.png);
            position: absolute;
            width: 9px;
            height: 16px;
            right: -1px;
            top: -1px;
        }

        .Gantt_taskBar {
            background-color: #E6EEF7;
            position: absolute;
            border-color: #C5D8EB;
            border-style: solid;
            border-width: 1px;
            margin-top: 8px;
        }

        .Gantt_overrun {
            background-color: #FFE8E8 !important;
            border-color: #ffb5b5 !important;
        }

            .Gantt_overrun div {
                border-color: #C00;
            }

        .Gantt_taskBar div {
            background-color: #C5D8EB;
            width: 70%;
            height: 10px;
        }

        .Gantt_overflow {
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .Gantt_userInfo {
            font-size: 11px;
            font-weight: 400;
            font-style: normal;
            text-decoration: none;
            color: #555;
            position: absolute;
            bottom: 4px;
            cursor: default;
            white-space: nowrap;
            z-index: 50;
            left: 100%;
            padding-left: 3px;
        }

        .Gantt_issueBar {
            background-color: #FFC;
            position: absolute;
            border-color: #FC0;
            border-style: solid;
            border-width: 1px;
            margin-top: 8px;
        }

            .Gantt_issueBar div {
                background-color: #FC0;
                width: 70%;
                height: 10px;
            }
        /*æ¨ªçº¿*/
        .Gantt_arrow {
            background-color: #999;
            height: 1px;
            top: 5px;
            left: 100%;
            position: absolute;
        }

        .Gantt_arrowDown {
            position: absolute;
            left: 100%;
            width: 1px;
            background-color: #999;
            z-index: 1000;
        }
        /*ç®­å¤´*/
        .Gantt_leftArrow {
            position: absolute;
            right: 0;
            bottom: 0;
        }

        .Gantt_rightArrow {
            position: absolute;
            left: 0;
            bottom: 0;
        }

        .Gantt_divTable {
            display: block;
            position: relative;
            overflow: hidden;
        }
         .Gantt_title {
            min-width: 250px;
        }
        .Gantt_titleFont {
            cursor: default;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            color: #64727a;
        }

        .Gantt_dateMonthYear {
            border-right: 1px solid #98b4ca;
            vertical-align: middle;
        }

        .Gantt_monthHolder {
            font-size: 13px;
            padding-bottom: 5px;
        }

        .Gantt_divTableHeader, .Gantt_divWeekTableHeader {
            display: table-cell;
            overflow: hidden;
            min-width: 17px;
            width: 17px;
            border-top: 1px solid #98b4ca;
            text-align: center;
            padding-top: 4px;
        }

        .Gantt_header {
            cursor: default;
            border-bottom-color: #98b4ca;
        }

        .Gantt_date {
            text-transform: uppercase;
            background-repeat: repeat-x;
        }
        /*周表格样式*/
        .Gantt_weekDateBox {
            height: 21px;
            white-space: nowrap;
            display: table-cell;
            overflow: hidden;
            min-width: 32px;
            max-width: 32px;
            border-right: 1px solid #98b4ca;
            border-bottom: 1px solid #98b4ca;
            border-top: 1px solid #98b4ca;
            padding: 5px;
        }
        /*月表格样式*/
        .Gantt_dateMonth {
            padding-top: 3px;
            text-transform: uppercase;
            background-color: #cbd9e4;
            max-width: 125px;
            min-width: 100px;
            border-bottom: 1px solid #98b4ca;
        }

        /*表格图形部分*/
        #Gantt_gridBodyContainer {
            overflow: scroll;
            position: fixed;
            top: 105px;
            bottom: 0;
            left: 301px;
            right: 0;
        }

        .Gantt_divTableRow {
            display: table-row;
            overflow: hidden;
            width: 50px;
            height: 30px;
            position: relative;
        }
        /*内部项目的颜色*/
        .InternalProjects {
            background-color: #cbd9e4;
            position: absolute;
            margin-top: 11px;
        }

            .InternalProjects div {
                background-color: #cbd9e4;
                height: 10px;
            }
        /*客户项目*/
        .ClientProjects {
            background-color: #336a95;
            position: absolute;
            margin-top: 11px;
        }

            .ClientProjects div {
                background-color: #336a95;
                height: 10px;
            }
        /*建议*/
        .Proposals {
            background-color: #fcf3e6;
            position: absolute;
            margin-top: 11px;
        }

            .Proposals div {
                background-color: #fcf3e6;
                height: 10px;
            }



        .TimelineSecondaryHeader {
            font-size: 12px;
        }

        .grid thead tr td {
            background-color: #ebebeb;
            border-color: #98b4ca;
            color: #64727a;
        }

        .TimelineGridHeader thead td {
            padding: 10px 0 10px 0;
        }

        .grid thead td {
            border-width: 1px;
            border-style: solid;
            font-size: 13px;
            font-weight: bold;
            height: 24px;
            padding: 4px 4px 4px 4px;
            word-wrap: break-word;
            vertical-align: top;
        }

        .TextUppercase {
            text-transform: uppercase;
        }

        .TimelineSecondaryHeader {
            font-size: 12px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="ButtonContainer">
            <ul>
                <!--报表切换按钮-->
                <li class="Button ButtonIcon" id="CalendarButton" tabindex="0" title="切换报表">
                    <span class="Icon Calendar" style="margin: 0;"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
                <li class="Button ButtonIcon" id="DailyButton" tabindex="0" title="按天显示">
                    <span class="Icon" style="margin: 0; width: 0;"></span>
                    <span class="Text">天</span>
                </li>
                <li class="Button ButtonIcon" id="WeeklyButton" tabindex="0" title="按周显示">
                    <span class="Icon" style="margin: 0; width: 0;"></span>
                    <span class="Text">周</span>
                </li>
                <li class="Button ButtonIcon" id="MonthlyButton" tabindex="0" title="按月显示">
                    <span class="Icon" style="margin: 0; width: 0;"></span>
                    <span class="Text">月</span>
                </li>
                <li class="Button ButtonIcon" id="ExportButton" tabindex="0" title="下载">
                    <span class="Icon Export" style="margin: 0;"></span>
                    <span class="Text" style="padding: 0;"></span>
                </li>
            </ul>
        </div>


        <div class="ScrollingContentContainer">
            <div style="padding: 0px;" class="ScrollingContainer">
                <!--上左-->
                <div class="Gantt_divTable" id="Gantt_container" style="width: 372px;max-width:300px;min-width:300px;">
                    <div class="Gantt_titleFont Gantt_divTableRowHeader">
                        <div class="Gantt_headerTitle Gantt_idHeader Gantt_divTableColumn Gantt_header">ID</div>
                        <div class="Gantt_headerTitle Gantt_title Gantt_divTableColumn Gantt_header" id="Gantt_headerTitle">
                            <div style="padding-left: 5px;">阶段/任务/问题</div>
                        </div>
                    </div>
                </div>
                <!--上右-->
                <div class="Gantt_divTable" id="Gantt_dateContainer" style="border-left: 1px solid #98b4ca;">
                    <asp:Literal ID="liCalendar" runat="server"></asp:Literal>

                </div>
                <!--下右-->
                <div class="Gantt_divTable" id="Gantt_taskContainer" style="height: 367px; min-height: 367px;width:300px;border-right: 1px solid #98b4ca;">
                    <asp:Literal ID="liLeftTable" runat="server"></asp:Literal>
                   <div class="Gantt_divTableRow" style="height: 17px;">
                        <div class="Gantt_blankItem"></div>
                        <div class="Gantt_blankItem"></div>
                        <div class="Gantt_idFont Gantt_id Gantt_divTableColumnMonth" style="display:none;"></div>
                    </div>
                </div>
                <!--下右-->
                <div class="Gantt_divTable" id="Gantt_gridBodyContainer" onscroll="Gantt_taskContainer.scrollTop = this.scrollTop;Gantt_dateContainer.scrollLeft = this.scrollLeft;" style="height: 367px; min-height: 367px;">
                    <% 
                        int left = 4;
                        if (start_date.DayOfWeek == DayOfWeek.Monday)
                        {
                            left += 42 * 5;
                        }
                        else  if (start_date.DayOfWeek == DayOfWeek.Tuesday)
                        {
                            left += 42 * 4;
                        }
                        else  if (start_date.DayOfWeek == DayOfWeek.Wednesday)
                        {
                            left += 42 * 3;
                        }
                        else  if (start_date.DayOfWeek == DayOfWeek.Thursday)
                        {
                            left += 42 * 2;
                        }
                         else  if (start_date.DayOfWeek == DayOfWeek.Friday)
                        {
                            left = 42 ;
                        }
                         else  if (start_date.DayOfWeek == DayOfWeek.Saturday)
                        {
                            left = 0 ;
                        }
                          else  if (start_date.DayOfWeek == DayOfWeek.Sunday)
                        {
                            left = -42 ;
                        }
                        %>
                    <div id="Gantt_gridContainer" style="background: url(../Images/dailyGridContainer.png) <%=left %>px 0%; width: 2967px;">
                        <asp:Literal ID="liRightImg" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>
        </div>

    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>

<script>
    function Style() {
        var Width1 = $("#Gantt_taskContainer").width();
        $("#Gantt_container").width(Width1);
        var WidthAll = 0;
        for (var i = 0; i < $('.Gantt_dateMonthYear').length; i++) {
            WidthAll += $('.Gantt_dateMonthYear').eq(i).outerWidth(true);
            $("#Gantt_gridContainer").width(WidthAll);
        }
        var Height = $(window).height() - $("#Gantt_dateContainer").height() - 82;
        $("#Gantt_taskContainer").height(Height).css("min-height", Height);
        $("#Gantt_gridBodyContainer").height(Height).css("min-height", Height);
    }
    $(window).resize(function () {
        Style();
    });
    Style();

    //缩小展开  左右关联
    $(document).ready(function () {
        $('.Gantt_parent').each(function (i) {
            var _this = $(this);
            var Txt = _this.find(".Gantt_idFont").html();
            var reg = new RegExp('[.]', 'g');
            var NewTxt = Txt.replace(reg, '_');
            _this.addClass(NewTxt);
            _this.attr('id', NewTxt);
            $("#Gantt_gridBodyContainer div.Gantt_divTableRow").eq(i + 1).attr('id', 'inner_' + NewTxt);
        });
    });
    
    $(".Gantt_ToggleDiv").on('click', function () {
        $(this).find('.Vertical').toggle();
        var _this = $(this).parent().parent();
        var str = _this.find('.Gantt_idFont').html().split(".").length - 1;
       // console.log(_this.find('.Gantt_idFont'))
        for (i in _this.nextAll()) {
            //console.log(i)
            var IndexIdAll = '#inner_' + _this.nextAll().eq(i).attr('id');
            //console.log(_this.nextAll().eq(i).find('.Gantt_idFont').html())
            if (str < _this.nextAll().eq(i).find('.Gantt_idFont').html().split(".").length - 1 && $(this).find('.Vertical').css('display') == 'block') {
                //console.log(_this.nextAll().eq(i).find('.Gantt_idFont').html())
                $(IndexIdAll).hide();
                $(IndexIdAll).prev().children('.Gantt_General').children('.line').hide()
                _this.nextAll().eq(i).hide();
                _this.nextAll().eq(i).find('.Vertical').show();
                Style();
                lineShow()
                if ($(IndexIdAll).prev().siblings('.Gantt_learnOver').css('display') == 'none') {
                    $(IndexIdAll).prev().siblings().children('.Gantt_General').children('.line').hide()
                }
            } else if (str < _this.nextAll().eq(i).find('.Gantt_idFont').html().split(".").length - 1 && $(this).find('.Vertical').css('display') == 'none') {
                $(IndexIdAll).show();
                $(IndexIdAll).prev().children('.Gantt_General').children('.line').show()
                _this.nextAll().eq(i).show();
                _this.nextAll().eq(i).find('.Vertical').hide();
                if ($(IndexIdAll).prev().siblings('.Gantt_learnOver').css('display  ') != 'none') {
                    $(IndexIdAll).prev().siblings().children('.Gantt_General').children('.line').show()
                }
                Style();
                lineShow()
            } else if (str >= _this.nextAll().eq(i).find('.Gantt_idFont').html().split(".").length - 1) {
                return false;
            }
        }
    });
</script>



<script>
    $(function () {
        <% if (type == "day")
    {%>
        $("#DailyButton").addClass("SelectedState");
            <% }
    else if (type == "week")
    {%>
        $("#WeeklyButton").addClass("SelectedState");
        <% }
    else if (type == "month")
    {%>
        $("#MonthlyButton").addClass("SelectedState");
        <%}%>

            //Xian();

    })

    $("#CalendarButton").click(function () {
        // 跳转到条目列表信息
        location.href = "ProjectSchedule?project_id=<%=thisProject.id %>";
    })
    $("#DailyButton").click(function () {
        location.href = "ProjectChart?project_id=<%=thisProject.id %>&dateType=day";
    })
    $("#WeeklyButton").click(function () {
        location.href = "ProjectChart?project_id=<%=thisProject.id %>&dateType=week";
    })
    $("#MonthlyButton").click(function () {
        location.href = "ProjectChart?project_id=<%=thisProject.id %>&dateType=month";
    })


    function Xian() {
     <% if (pageTaskList != null && pageTaskList.Count > 0)
    {
        var stpDal = new EMT.DoneNOW.DAL.sdk_task_predecessor_dal();
        foreach (var pageTask in pageTaskList)       // 按照顺序为页面上的task循环添加线
        {
            var thisTaskList = stpDal.GetTaskByPreId(pageTask.id);
            if (thisTaskList != null && thisTaskList.Count > 0)
            {
                foreach (var thisTask in thisTaskList)
                {
                    var thisXianNum = thisTaskList.Count;  // 这个前驱任务可能指向多条线平均排开
                    
                    var topPx = (thisTaskList.IndexOf(thisTask)+1) / (double)(thisTaskList.Count + 1);  // 线的开始位置在div的位置
                    // 分为两种线 ,前驱任务在任务之前，前驱任务在任务之后

                    // 计算前驱任务的结束时间与相关task的开始时间
                    var widthDiffDays = (double)GetDateDiffMonth((DateTime)pageTask.estimated_end_date,EMT.Tools.Date.DateHelper.ConvertStringToDateTime((long)thisTask.estimated_begin_time),"day");
                    widthDiffDays = (double)(widthDiffDays + (0.5)* thisTask.estimated_duration);
                    var xianWidth = widthDiffDays * DayWidth;
                    var heightDiff =pageTaskList.IndexOf(pageTaskList.FirstOrDefault(_=>_.id==thisTask.id))- pageTaskList.IndexOf(pageTask);
                         %>

        // 计算线距离前驱任务的divTop高度
        var thisHeight = $("#<%=pageTask.id %>").height();
        var thisTopPx = Number(thisHeight) * Number(<%=topPx %>);

        // 计算线距离的宽度

        var xianHeight = $("#<%=pageTask.id %>").parent().height();
        var thisXianHeight = xianHeight * Number(<%=heightDiff %>);

        // 计算线的高度


        var xianHtml = "<span class='line'>";
        // 计算宽和高
        xianHtml += "<span class='Gantt_arrow' style='width: <%=xianWidth %>px; display: block;top:" + thisTopPx + "px;'><span class='Gantt_arrowDown' style= 'height:" + thisXianHeight+"px; display: block;'><img src='../Images/LeftArrow.png' class='Gantt_leftArrow'><img src='../Images/RightArrow.png' class='Gantt_rightArrow'></span></span>";
        xianHtml += "</span>";
        $("#<%=pageTask.id %>").append(xianHtml);
                         <%
                }
            }

        }
    }%>

    }
    function lineShow() {
        //console.log(true)
        $.each($('#Gantt_gridBodyContainer .Gantt_divTableRow'), function (i) {
        console.log(i)
            //console.log($('#Gantt_gridBodyContainer .Gantt_divTableRow').eq(i).children('.Gantt_phaseBar').find('.line').length)
        if ($('#Gantt_gridBodyContainer .Gantt_divTableRow').eq(i).children('.Gantt_General').find('.line').length != 0) {
                var s1 = $('#Gantt_gridBodyContainer .Gantt_divTableRow').eq(i).offset().top
                var s2 = $('.Gantt_Completed').eq(2).offset().top;
              
                var as = $('#Gantt_gridBodyContainer .Gantt_divTableRow').eq(i).children('.Gantt_General').children('.line').children('.Gantt_arrow').children('.Gantt_arrowDown');
                console.log(as)

                $('#Gantt_gridBodyContainer .Gantt_divTableRow').eq(i).children('.Gantt_General').children('.line').eq(0).children('.Gantt_arrow').children('.Gantt_arrowDown').height(s2 - s1 - 5)

                var childrenDom = $('#Gantt_gridBodyContainer .Gantt_divTableRow').eq(i).children('.Gantt_General').children('.line').children('.Gantt_arrow').children('.Gantt_arrowDown')
                if (childrenDom.find('span').length != 0) {
                    //console.log(i)
                    $('#Gantt_gridBodyContainer .Gantt_divTableRow').eq(i).children('.Gantt_General').children('.line').children('.Gantt_arrow').children('.Gantt_arrowDown').height(s2 - s1 - 30)
                }

            }
        })
    }
    lineShow();
</script>

