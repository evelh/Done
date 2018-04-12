<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyTimeSummary.aspx.cs" Inherits="EMT.DoneNOW.Web.TimeSheet.MyTimeSummary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>我的工时汇总</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        .description{font-size:12px;color:#666;padding:6px 12px 8px 12px;text-align:left;}
        .description tr{height:24px;}
        .description td{border-bottom:1px solid #838383;text-align:left;}
    </style>
    <style>
        .time {
        width: 260px;
        height: 280px;
        border: 1px solid #ccc;
        float: left;
		margin: 3px 6px 3px 0;
    }

    .time .title {
        width: 100%;
        height: 40px;
        text-align: center;
        line-height: 40px;
        font-weight: bold;
        background: #626262;
        color: white;
    }

    .time .table {
        width: 100%;
        height: 240px;
        display: table;
        font-size: 12px;
        border: none;
        vertical-align: middle;
        text-align: center;
        border-spacing:0;

        
    }

    .time .table th {
        background: #E3E3E3;
        color: #626262;
        border: none;
        height: 30px;
    }

    .time .table td {
        background: #fff;
        border: 1px solid #ccc;
        color: #333;
        font-size: 12px;
        font-weight: bold;
        width: 37px;
        height: 32px;
    }
    </style>
</head>
<body style="overflow:auto;">
    <div class="header">我的工时汇总</div>
    <div class="header-title" style="min-width: 400px;">
        <ul>
            <li id="NewRequest">
                <i style="background:url(../Images/add.png);" class="icon-1"></i>
                <input type="button" value="新增休假请求" />
            </li>
        </ul>
        <div>
            <select id="year" style="width:76px;height:27px;margin:1px 10px 1px 10px;">
                <%for (int y = startYear; y <= DateTime.Now.Year + 1; y++) { %>
                <option value="<%=y %>" <%if (y == year) { %> selected="selected" <%} %>><%=y %></option>
                <%} %>
            </select>
            <select id="resource" style="width:118px;height:27px;margin:1px 10px 1px 4px; <%if(resList==null||resList.Count==0) {%> display:none; <%}%>">
                <%if (resList != null) {
                        foreach (var res in resList) { %>
                <option value="<%=res.val %>" <%if (res.val==resourceId.ToString()) { %> selected="selected" <%} %>><%=res.show %></option>
                <%}} %>
            </select>
        </div>
    </div>
    <div style="margin:10px;width:1085px;">
        <table>
            <tr>
                <td style="vertical-align:top;">
                    <div style="border:1px solid #d3d3d3;margin:4px 8px 12px 0;width:527px;">
                        <div>
                            <label class="description" style="font-weight:bold;width:100%;margin-bottom:0;">汇总</label>
                        </div>
                        <div>
                            <label class="description" style="padding-left:30px;width:100%;margin-bottom:0;">距离当前工时表结束：</label>
                        </div>
                    </div>
                    <div style="border:1px solid #d3d3d3;margin:4px 8px 12px 0;width:527px;">
                        <div>
                            <label class="description" style="font-weight:bold;width:100%;margin-bottom:0;">最近10个工时表</label>
                        </div>
                        <div class="description">
                            <table>
                                <tr>
                                    <th>周期</th>
                                    <th>状态</th>
                                    <th>说明</th>
                                </tr>
                                <%foreach (var report in reportList) { 
                                    string status="";
                                    if (report.status_id == (int)EMT.DoneNOW.DTO.DicEnum.WORK_ENTRY_REPORT_STATUS.HAVE_IN_HAND)
                                        status = "进行中";
                                    else if (report.status_id == (int)EMT.DoneNOW.DTO.DicEnum.WORK_ENTRY_REPORT_STATUS.WAITING_FOR_APPROVAL)
                                        status = "等待审批";
                                    else if (report.status_id == (int)EMT.DoneNOW.DTO.DicEnum.WORK_ENTRY_REPORT_STATUS.PAYMENT_BEEN_APPROVED)
                                        status = "已审批";
                                    else if (report.status_id == (int)EMT.DoneNOW.DTO.DicEnum.WORK_ENTRY_REPORT_STATUS.REJECTED)
                                        status = "已拒绝";
                                        %>
                                <tr>
                                    <td><%=report.start_date.Value.ToString("yyyy-MM-dd") %>至<%=report.end_date.Value.ToString("yyyy-MM-dd") %></td>
                                    <td><%=status %></td>
                                    <td><%=report.rejection_reason %></td>
                                </tr>
                                <%} %>
                            </table>
                        </div>
                    </div>
                </td>
                <td style="vertical-align:top;">
                    <div style="border:1px solid #d3d3d3;margin:4px 4px 12px 4px;width:542px;">
                        <div>
                            <label class="description" style="font-weight:bold;width:100%;margin-bottom:0;">可用假期余额</label>
                        </div>
                        <div>
                            <label class="description" style="padding-left:30px;width:100%;margin-bottom:0;">已使用包括今天和更早的休假请求。已批准未使用包括将来的休假请假。</label>
                        </div>
                        <div class="description">
                            <table>
                                <tr style="border:1px solid #838383;">
                                    <th></th>
                                    <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Vacation)) { %><th style="width:110px;text-align:left;">带薪休假</th><%} %>
                                    <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Personal)) { %><th style="width:110px;text-align:left;">私人时间</th><%} %>
                                    <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Sick)) { %><th style="width:110px;text-align:left;">病假</th><%} %>
                                    <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Floating)) { %><th style="width:110px;text-align:left;">浮动假期</th><%} %>
                                </tr>
                                <%EMT.DoneNOW.Core.v_timeoff_total tmoffYear,tmoffPerson,tmoffSick,tmoffFloat; %>
                                <%
                                    tmoffYear = timeoffSummary.Find(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Vacation);
                                    tmoffPerson = timeoffSummary.Find(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Personal);
                                    tmoffSick = timeoffSummary.Find(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Sick);
                                    tmoffFloat = timeoffSummary.Find(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Floating);%>
                                <tr>
                                    <td>本年总休假</td>
                                    <%if (tmoffYear!=null) { %>
                                    <td><%=tmoffYear.annual_hours %></td>
                                    <%} %>
                                    <%if (tmoffPerson!=null) { %>
                                    <td><%=tmoffPerson.annual_hours %></td>
                                    <%} %>
                                    <%if (tmoffSick!=null) { %>
                                    <td><%=tmoffSick.annual_hours %></td>
                                    <%} %>
                                    <%if (tmoffFloat!=null) { %>
                                    <td><%=tmoffFloat.annual_hours %></td>
                                    <%} %>
                                </tr>
                                <tr>
                                    <td>本年目前可用休假</td>
                                    <%if (tmoffYear!=null) { %>
                                    <td><%=tmoffYear.earned_to_date %></td>
                                    <%} %>
                                    <%if (tmoffPerson!=null) { %>
                                    <td><%=tmoffPerson.earned_to_date %></td>
                                    <%} %>
                                    <%if (tmoffSick!=null) { %>
                                    <td><%=tmoffSick.earned_to_date %></td>
                                    <%} %>
                                    <%if (tmoffFloat!=null) { %>
                                    <td><%=tmoffFloat.earned_to_date %></td>
                                    <%} %>
                                </tr>
                                <tr>
                                    <td>已使用</td>
                                    <%if (tmoffYear!=null) { %>
                                    <td><%=tmoffYear.used_time_before_and_including_today %></td>
                                    <%} %>
                                    <%if (tmoffPerson!=null) { %>
                                    <td><%=tmoffPerson.used_time_before_and_including_today %></td>
                                    <%} %>
                                    <%if (tmoffSick!=null) { %>
                                    <td><%=tmoffSick.used_time_before_and_including_today %></td>
                                    <%} %>
                                    <%if (tmoffFloat!=null) { %>
                                    <td><%=tmoffFloat.used_time_before_and_including_today %></td>
                                    <%} %>
                                </tr>
                                <tr>
                                    <td>已批准未使用</td>
                                    <%if (tmoffYear!=null) { %>
                                    <td><%=tmoffYear.used_time_after_today %></td>
                                    <%} %>
                                    <%if (tmoffPerson!=null) { %>
                                    <td><%=tmoffPerson.used_time_after_today %></td>
                                    <%} %>
                                    <%if (tmoffSick!=null) { %>
                                    <td><%=tmoffSick.used_time_after_today %></td>
                                    <%} %>
                                    <%if (tmoffFloat!=null) { %>
                                    <td><%=tmoffFloat.used_time_after_today %></td>
                                    <%} %>
                                </tr>
                                <tr>
                                    <td>待审批</td>
                                    <%if (tmoffYear!=null) { %>
                                    <td><%=tmoffYear.waiting_approval_time %></td>
                                    <%} %>
                                    <%if (tmoffPerson!=null) { %>
                                    <td><%=tmoffPerson.waiting_approval_time %></td>
                                    <%} %>
                                    <%if (tmoffSick!=null) { %>
                                    <td><%=tmoffSick.waiting_approval_time %></td>
                                    <%} %>
                                    <%if (tmoffFloat!=null) { %>
                                    <td><%=tmoffFloat.waiting_approval_time %></td>
                                    <%} %>
                                </tr>
                                <tr style="height:32px;font-weight:bold;">
                                    <td>可用时间</td>
                                    <%if (tmoffYear!=null) { %>
                                    <td><%=tmoffYear.current_balance %></td>
                                    <%} %>
                                    <%if (tmoffPerson!=null) { %>
                                    <td><%=tmoffPerson.current_balance %></td>
                                    <%} %>
                                    <%if (tmoffSick!=null) { %>
                                    <td><%=tmoffSick.current_balance %></td>
                                    <%} %>
                                    <%if (tmoffFloat!=null) { %>
                                    <td><%=tmoffFloat.current_balance %></td>
                                    <%} %>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div style="width:1200px;margin-left:10px;">
        <div id="calDiv" style="width:100%;overflow:hidden;"></div>
        <div style="width:1060px;margin:12px 0 20px 0;">
            <table>
                <tr>
                    <td><label style="border:solid 1px #D3D3D3;background-color:#8DC63F;width:20px;height:20px;float:right;"></label></td><td><label style="float:left;">已审批</label></td>
                    <td><label style="border:solid 1px #D3D3D3;background-color:#D7D7D7;width:20px;height:20px;float:right;"></label></td><td><label style="float:left;">已取消</label></td>
                    <td><label style="border:solid 1px #D3D3D3;background-color:#FFAEB9;width:20px;height:20px;float:right;"></label></td><td><label style="float:left;">已拒绝</label></td>
                    <td><label style="border:solid 1px #D3D3D3;background-color:#FFF799;width:20px;height:20px;float:right;"></label></td><td><label style="float:left;">已提交</label></td>
                </tr>
            </table>
        </div>
    </div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script>
        $("#NewRequest").click(function () {
            window.open('../TimeSheet/TimeoffRequestAdd', windowObj.timeoffRequest + windowType.add, 'left=0,top=0,location=no,status=no,width=825,height=679', false);
        })
        $("#year").change(function () {
            window.location.href = "MyTimeSummary?year=" + $("#year").val() + "&resId=" + $("#resource").val();
        })
        $("#resource").change(function () {
            window.location.href = "MyTimeSummary?year=" + $("#year").val() + "&resId=" + $("#resource").val();
        })
    </script>
    <script>
        function is_leap(year) {
            return (year % 100 == 0 ? res = (year % 400 == 0 ? 1 : 0) : res = (year % 4 == 0 ? 1 : 0));
        }
        function mGetDate(year, month) {
            var d = new Date(year, month, 0);
            return d.getDate();
        }
        function getDays(year, month) {
            var d = new Date(year, month, 1);
            return d.getDay() == 0 ? 7 : d.getDay();
        }
        var week = new Array("星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日");
        function GetDate(year, month) {
            //创建容器
            var timebox = document.createElement('div');
            timebox.classList.add('time');
            document.body.appendChild(timebox)
            var title = document.createElement('div');
            title.classList.add('title');
            title.innerHTML = year + '年' + "&nbsp;&nbsp;" + month + "月";
            timebox.appendChild(title)
            var table = document.createElement('table');
            table.classList.add('table');
            table.cellspacing = 0;
            table.cellPadding = 0;
            table.border = 0;

            timebox.appendChild(table);
            var x = 1;
            for (var i = 0; i < 7; i++) {
                var tr = document.createElement('tr');
                table.appendChild(tr);
                for (var j = 1; j <= 7; j++) {
                    if (i == 0) {
                        var th = document.createElement('th');
                        th.innerHTML = week[j - 1]
                        tr.appendChild(th)
                    } else {
                        //判断闰年  星期几  这个月多少天
                        var TotalDays, FirstWeek;
                        if (is_leap(year) == 1 && month == 2) {
                            TotalDays = 29;
                        } else {
                            TotalDays = mGetDate(year, month);
                        }
                        FirstWeek = getDays(year, month - 1);
                        
                        var td = document.createElement('td');
                        
                        //第一行从星期几开始
                        if (i == 1 && j == FirstWeek) {
                            td.innerHTML = x;
                            td.id = month + '' + x;
                        } else if (i == 1 && j < FirstWeek) {
                            td.innerHTML = "";
                        } else {
                            x++;
                            if (x <= TotalDays) {
                                td.innerHTML = x;
                                td.id = month + '' + x;
                            }
                        }
                        tr.appendChild(td);
                    }
                }
            }
            document.getElementById("calDiv").appendChild(timebox);
        }
        for (var i = 1; i < 13; i++) {
            GetDate(<%=year%>, i);
        }
        var statusList = {
            i2196: '#8DC63F',
            i2198: '#D7D7D7',
            i2197: '#FFAEB9',
            i2195: '#FFF799',
        }
        <%foreach (var tf in timeoffList) { %>
        $("#<%=tf.timeoffDate.ToString("Mdd")%>").css({ background: statusList.<%="i"+tf.status_id.ToString()%> });
        $("#<%=tf.timeoffDate.ToString("Mdd")%>").attr('title','<%=tf.tooltip.Replace("<br />", "\\r")%>');
        <%}%>
    </script>
</body>
</html>
