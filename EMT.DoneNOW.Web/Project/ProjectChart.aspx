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
        /*é¡¶éƒ¨å†…å®¹å’Œå¸®åŠ©*/
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
            background-image: url(../img/help.png);
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
            background: transparent url("../img/calendar.png") no-repeat scroll;
        }

        .Export {
            background: transparent url("../img/export.png") no-repeat scroll;
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

        .Gantt_divTableColumn {
            display: table-cell;
            overflow: hidden;
            min-width: 32px;
            max-width: 32px;
            border-right: 1px solid #d7d7d7;
            border-bottom: 1px solid #d7d7d7;
            border-top: 1px solid #d7d7d7;
            padding: 5px;
        }

        #Gantt_headerTitle {
            height: 50px;
            width: 100%;
        }

        .Gantt_title {
            min-width: 150px;
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
            min-width: 32px;
            max-width: 32px;
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

        .Gantt_title {
            min-width: 150px;
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
            border-right: 1px solid #d7d7d7;
            border-bottom: 1px solid #d7d7d7;
            padding: 5px;
        }
        /*å³ä¸‹*/
        #Gantt_gridBodyContainer {
            overflow: scroll;
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
            background: url(../img/ganttsprite.png);
            position: absolute;
            width: 9px;
            height: 16px;
            left: -1px;
            top: -1px;
        }

        .Gantt_rightCorner {
            background: url(../img/ganttsprite.png);
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
                <li class="Button ButtonIcon SelectedState" id="DailyButton" tabindex="0" title="按天显示">
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
                <div class="Gantt_divTable" id="Gantt_container" style="width: 372px;">
                    <div class="Gantt_titleFont Gantt_divTableRowHeader">
                        <div class="Gantt_headerTitle Gantt_idHeader Gantt_divTableColumn Gantt_header">ID</div>
                        <div class="Gantt_headerTitle Gantt_title Gantt_divTableColumn Gantt_header" id="Gantt_headerTitle">
                            <div style="padding-left: 5px;">阶段/任务/问题</div>
                        </div>
                    </div>
                </div>
                <!--上右-->
                <div class="Gantt_divTable" id="Gantt_dateContainer">
                    <asp:Literal ID="liCalendar" runat="server"></asp:Literal>
                </div>
                <!--下右-->
                <div class="Gantt_divTable" id="Gantt_taskContainer" style="height: 367px; min-height: 367px;">
                    <asp:Literal ID="liLeftTable" runat="server"></asp:Literal>
                </div>
                <!--下右-->
                <div class="Gantt_divTable" id="Gantt_gridBodyContainer" onscroll="Gantt_taskContainer.scrollTop = this.scrollTop;Gantt_dateContainer.scrollLeft = this.scrollLeft;" style="height: 367px; min-height: 367px;">
                    <asp:Literal ID="liRightImg" runat="server"></asp:Literal>
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
            console.log(WidthAll);
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
        for (i in _this.nextAll()) {
            var IndexIdAll = '#inner_' + _this.nextAll().eq(i).attr('id');
            if (str < _this.nextAll().eq(i).find('.Gantt_idFont').html().split(".").length - 1 && $(this).find('.Vertical').css('display') == 'block') {
                $(IndexIdAll).hide();
                _this.nextAll().eq(i).hide();
                _this.nextAll().eq(i).find('.Vertical').show();
                Style();
            } else if (str < _this.nextAll().eq(i).find('.Gantt_idFont').html().split(".").length - 1 && $(this).find('.Vertical').css('display') == 'none') {
                $(IndexIdAll).show();
                _this.nextAll().eq(i).show();
                _this.nextAll().eq(i).find('.Vertical').hide();
                Style();
            } else if (str >= _this.nextAll().eq(i).find('.Gantt_idFont').html().split(".").length - 1) {
                return false;
            }
        }
    });


    //跳转
    $("#DailyButton").on("click", function () {
        window.location.href = "ProjectChart1.html";
    });
    $("#WeeklyButton").on("click", function () {
        window.location.href = "ProjectChart2.html";
    });
    $("#MonthlyButton").on("click", function () {
        window.location.href = "ProjectChart3.html";
    });
</script>
