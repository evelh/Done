<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TimeoffRequestAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.TimeSheet.TimeoffRequestAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>新增休假请求</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        .description{font-size:12px;color:#666;padding:6px 12px 8px 12px;}
        .description tr{height:24px;}
        .description td{border:1px solid #838383;}
        .requestTable{font-size:13px;color:#666;font-weight:bold;margin:16px 8px 8px 8px;width:782px;}
        .requestTable tr{height:32px;}
        .requestTable td{width:391px;}
        .requestTable label{width:120px;float:left;text-align:right;}
        .requestText{margin-left:35px;width:180px;height:20px;}
    </style>
</head>
<body>
    <div class="header">新增休假请求--<%=resourceName %></div>
    <div class="header-title" style="min-width: 700px;">
        <ul>
            <li id="SaveClose">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <input type="button" value="保存并关闭" />
            </li>
            <li id="Cancle">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <input type="button" value="取消" />
            </li>
        </ul>
    </div>
    <form id="form1" runat="server">
        <div style="margin:10px;width:800px;">
            <div style="border:1px solid #d3d3d3;margin-bottom:12px;padding:4px 0 4px 0;width:100%;">
                <div>
                    <span class="description" style="font-weight:bold;">可用休假余额(小时)</span>
                </div>
                <div>
                    <span class="description" style="padding-left:30px;">已使用包括今天和更早的休假请求。已批准未使用包括将来的休假请假。</span>
                </div>
                <div class="description">
                    <table>
                        <tr style="border:1px solid #838383;">
                            <th></th>
                            <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Vacation)) { %><th style="width:140px;text-align:center;">带薪休假</th><%} %>
                            <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Personal)) { %><th style="width:140px;text-align:center;">私人时间</th><%} %>
                            <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Sick)) { %><th style="width:140px;text-align:center;">病假</th><%} %>
                            <%if (timeoffSummary.Exists(_ => _.task_id == (int)EMT.DoneNOW.DTO.CostCode.Floating)) { %><th style="width:140px;text-align:center;">浮动假期</th><%} %>
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
            <div style="border:1px solid #d3d3d3;margin-bottom:12px;padding:4px 0 4px 0;width:100%;">
                <div>
                    <span class="description" style="font-weight:bold;">休假请求</span>
                </div>
                <div>
                    <span class="description" style="padding-left:30px;">选择休假请求的开始日期和结束日期。</span>
                </div>
                <div>
                    <table class="requestTable">
                        <tr>
                            <td>
                                <div>
                                    <label>类型<span style="color: red;position:absolute;">*</span></label>
                                    <select id="task_id" name="task_id" class="requestText">
                                        <option></option>
                                        <%if (tmoffYear != null) { %>
                                        <option value="25">带薪休假</option>
                                        <%}%>
                                        <%if (tmoffSick != null) { %>
                                        <option value="23">病假</option>
                                        <%}%>
                                        <%if (tmoffPerson != null) { %>
                                        <option value="35">私人时间</option>
                                        <%}%>
                                        <option value="28">节假日</option>
                                        <%if (tmoffFloat != null) { %>
                                        <option value="27">浮动假期</option>
                                        <%}%>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <label>开始日期<span style="color: red;position:absolute;">*</span></label>
                                    <input type="text" id="startDate" name="startDate" class="requestText Wdate calcHoursDate" onclick="WdatePicker()" />
                                </div>
                            </td>
                            <td>
                                <div>
                                    <label>结束日期</label>
                                    <input type="text" id="endDate" name="endDate" class="requestText Wdate calcHoursDate" onclick="WdatePicker()" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <label>每天小时数<span style="color: red;position:absolute;">*</span></label>
                                    <input type="text" id="request_hours" name="request_hours" class="requestText calcHours" />
                                </div>
                            </td>
                            <td>
                                <div>
                                    <label>休假时间</label>
                                    <label class="requestText" id="hours" style="text-align:left;margin-left:62px;">小时</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label for="onlyWorkday">排除周末</label><input type="checkbox" id="onlyWorkday" name="onlyWorkday" disabled="disabled" class="calcHours" style="margin-left:62px;" checked="checked" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <label>事由</label>
                                <textarea style="width:572px;height:112px;resize:none;" name="request_reason" class="requestText"></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $("#SaveClose").click(function () {
            if ($("#task_id").val() == "") {
                LayerMsg("请选择休假类型！");
                return;
            }
            if ($("#startDate").val() == "") {
                LayerMsg("请输入休假开始日期！");
                return;
            }
            if ($("#request_hours").val() == "") {
                LayerMsg("请输入每天小时数！");
                return;
            }
            $("#form1").submit();
        })
        $("#Cancle").click(function () {
            window.close();
        })
        $(".calcHoursDate").blur(function () {
            CalcHours();
        })
        $(".calcHours").change(function () {
            CalcHours();
        })
        function CalcHours() {
            var dayCnt = 0;
            if ($("#startDate").val() == "") {
                $("#hours").text("0.00");
                $("#onlyWorkday").attr("disabled", "disabled");
                return;
            }
            if ($("#endDate").val() == "") {
                $("#onlyWorkday").attr("disabled", "disabled");
                var start = GetDateFromString($("#startDate").val());
                var end = GetDateFromString($("#startDate").val());
                end.setDate(end.getDate() + 1);
                dayCnt = GetWorkdayCnt(start, end);
                if (dayCnt == 0 && (!$("#onlyWorkday").is(":checked"))) {
                    dayCnt = 1;
                }
            } else {
                var start = GetDateFromString($("#startDate").val());
                var end = GetDateFromString($("#endDate").val());
                end.setDate(end.getDate() + 1);
                dayCnt = GetDayCnt(start, end);
                if (dayCnt <= 0) {
                    $("#hours").text("0.00");
                    $("#onlyWorkday").attr("disabled", "disabled");
                    LayerMsg("结束日期不能小于开始日期！");
                    return;
                }
                var workDayCnt = GetWorkdayCnt(start, end);
                if (dayCnt != workDayCnt) {
                    $("#onlyWorkday").removeAttr("disabled");
                    if ($("#onlyWorkday").is(":checked")) {
                        dayCnt = workDayCnt;
                    }
                }
            }
            if ($("#request_hours").val() == "") {
                $("#hours").text("0.00");
                return;
            }
            var hours = toDecimal2($("#request_hours").val());
            if (hours == "") {
                $("#request_hours").val("");
                LayerMsg("小时数格式错误！");
                return;
            }
            $("#request_hours").val(hours);
            $("#hours").text(toDecimal2(dayCnt * hours));
        }
        function GetDayCnt(startDate, endDate) {
            return Math.floor((endDate.getTime() - startDate.getTime()) / (24 * 3600 * 1000));
        }
        function GetWorkdayCnt(startDate, endDate) {
            var dayAll = GetDayCnt(startDate, endDate);
            var cnt = Math.floor(dayAll / 7) * 5;
            for (var i = 0; i < dayAll % 7; i++) {
                if (startDate.getDay() % 6 != 0) {
                    cnt++;
                }
                startDate.setDate(startDate.getDate() + 1);
            }
            return cnt;
        }
    </script>
</body>
</html>
