<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectSearchImg.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectSearchImg" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <title></title>
    <style>
        html, body {
            -ms-overflow-style: scrollbar;
        }
        @-ms-viewport {
  width: device-width;
}

        .Gantt_divTable {
            display: block;
            position: relative;
            overflow: hidden;
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
            /*line-height:55px;*/
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
            background-color: #cbd9e4;
            line-height: 20px;
        }

        .Gantt_divTableColumn {
            display: table-cell;
            overflow: hidden;
            min-width: 17px;
            max-width: 17px;
            border-right: 1px solid #98b4ca;
            border-bottom: 1px solid #98b4ca;
            border-top: 1px solid #98b4ca;
            padding: 5px;
        }

            .Gantt_divTableColumn:last-child {
                border-right: none;
            }

        .Gantt_blankItem {
            display: table-cell;
            overflow: hidden;
            border: transparent;
            border-right: 1px solid #98b4ca;
            border-bottom: 1px solid #98b4ca;
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
            top: 62px;
            bottom: 0;
            left: 0;
            right: 0;
            background-image: url(../Images/dailyGridContainer.png);
        }
        /*#BigDiv{
             overflow: scroll;
        }*/

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

        .grid thead tr td {
            background-color: #cbd9e4;
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
            height: 19px;
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

        .grid thead tr td {
            background-color: #cbd9e4;
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
            height: 19px;
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
        <div class="Gantt_divTable" id="Gantt_dateContainer">
            <asp:Literal ID="headText" runat="server"></asp:Literal>
        </div>
        <div class="Gantt_divTable" id="Gantt_gridBodyContainer" onscroll="Gantt_dateContainer.scrollLeft = this.scrollLeft;">
            <asp:Literal ID="bodyText" runat="server"></asp:Literal>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    function Style() {
        var WidthAll = 0;
        for (var i = 0; i < $('.Gantt_dateMonthYear').length; i++) {
            WidthAll += $('.Gantt_dateMonthYear').eq(i).outerWidth(true);
            $("#Gantt_gridContainer").width(WidthAll);
        }
    }
    Style();
</script>
