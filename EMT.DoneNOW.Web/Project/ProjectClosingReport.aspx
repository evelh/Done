<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectClosingReport.aspx.cs" Inherits="EMT.DoneNOW.Web.Project.ProjectClosingReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <style>
        #calDay {
            font-size: 12px;
            font-weight: 700;
            color: #666;
            border: 1px solid #F0F0F0;
            background-color: #FFF;
            text-align: center;
        }

        #calMonth {
            font-size: 13px;
            font-weight: 700;
            background-color: #626262;
            color: #FFF;
            text-transform: uppercase;
            text-align: center;
        }

        table {
            width: 100%;
            -webkit-border-horizontal-spacing: 0px;
            -webkit-border-vertical-spacing: 0px;
            border-top-width: 0px;
            border-right-width: 0px;
            border-bottom-width: 0px;
            border-left-width: 0px;
        }

        td {
            width: 20px;
            height: 20px;
        }

        td, th {
            display: table-cell;
            vertical-align: inherit;
        }

        .fieldLabels {
            color: #4f4f4f;
            font-weight: 700;
        }

      
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="ReportCriteriaSection" style="padding-top: 10px; width: 230px; float: left; margin-left: 10px;">
            <asp:Literal ID="calendar" runat="server"></asp:Literal>
            <table border="0" cellspacing="0" cellpadding="1" style="width: 100%; padding-top: 5px;">
                <tbody>
                    <tr>
                        <td class="fieldLabels" style="text-align: left">
                            <div>
                                <input type="radio" name="displayType" id="day" value="byDay" checked="" onclick="changeView();"><span style="cursor: pointer;" onclick="document.form1.displayType[0].checked=true;changeView();">每日试图</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="fieldLabels" style="text-align: left">
                            <div>
                                <input type="radio" name="displayType" id="week" value="byWeek" onclick="changeView();"><span style="cursor: pointer;" onclick="document.form1.displayType[1].checked=true;changeView();">未来七天视图</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="fieldLabels" style="text-align: left; padding-top: 10px">
                            <input type="checkbox" id="showDetail" value="1" onclick="changeView();"><span onclick="showSummaryNote();" style="cursor: pointer;">显示任务描述</span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="float: left; width: 1000px; position: fixed; margin-left: 240px; height: 100%;">
            <iframe id="TaskIframe" style="width: 100%; height: 100%;padding-left: 10px;" runat="server"></iframe>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>

    $(function () {

        var url = "ProjectReportDetail?isAll=<%=isAll?"1":"" %>&id=<%=thisProject!=null?thisProject.id.ToString():"" %>&chooseDate=<%=chooseDate.ToString("yyyy-MM-dd") %>"
        <%if (isSeven)
    { %>
        $("#week").prop("checked", true);
        $("#day").prop("checked", false);
        url += "&isSeven=1";
        <%}
    else
    { %>
        $("#week").prop("checked", false);
        $("#day").prop("checked", true);
         <%}%>

        <%if (isShowDetai)
    {%>
        $("#showDetail").prop("checked", true);
        url += "&isShowDetai=1";
        <%}
    else
    {%>
        $("#showDetail").prop("checked", false);
        <%}%>


        $("#TaskIframe").attr("src", url);
    })

    function changeView() {
        debugger;
        var url = "ProjectReportDetail?isAll=<%=isAll?"1":"" %>&id=<%=thisProject!=null?thisProject.id.ToString():"" %>&chooseDate=<%=chooseDate.ToString("yyyy-MM-dd") %>";
        var week = $("#week").is(":checked");
        if (week) {
            url += "&isSeven=1";
        }

        var isShowDetail = $("#showDetail").is(":checked");
        if (isShowDetail) {
            url += "&isShowDetai=1";
        }
        $("#TaskIframe").attr("src", url);
    }
    // 选择时间
    function ChooseDate(chooseDate) {
        var url = 'ProjectClosingReport?isAll=<%=isAll?"1":"" %>&id=<%=thisProject!=null?thisProject.id.ToString():"" %>&chooseDate=' + chooseDate + '&showDate=' + chooseDate;
        var week = $("#week").is(":checked");
        if (week) {
            url += "&isSeven=1";
        }

        var isShowDetail = $("#showDetail").is(":checked");
        if (isShowDetail) {
            url += "&isShowDetai=1";
        }

        location.href = url;

    }
    function ChooseNewDate(showDate) {
        var url = 'ProjectClosingReport?isAll=<%=isAll?"1":"" %>&id=<%=thisProject!=null?thisProject.id.ToString():"" %>&chooseDate=<%=chooseDate.ToString("yyyy-MM-dd") %>&showDate=' + showDate;
        var week = $("#week").is(":checked");
        if (week) {
            url += "&isSeven=1";
        }

        var isShowDetail = $("#showDetail").is(":checked");
        if (isShowDetail) {
            url += "&isShowDetai=1";
        }
        location.href = url;

    }
</script>
