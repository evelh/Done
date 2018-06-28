<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SLAManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SLA.SLAManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %> 服务等级管理</title>
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        td {
            text-align: left;
            padding-left: 30px;
        }

        .red {
            color: red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="SLAId" value="<%=sla?.id %>"/>
        <div class="header"><%=isAdd?"新增":"编辑" %> 服务等级管理</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 110px;">
            <div class="information clear">
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 800px; border: 0px;">
                        <tr>
                            <td style="width: 50%;">
                                <label>名称<span class="red">*</span></label>
                                <div class="clear">

                                    <input type="text" name="name" id="name" value="<%=sla?.name %>" />
                                </div>
                            </td>
                            <td style="width: 50%;">
                                <label>响应时间目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text" maxlength="3" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" name="first_response_goal_percentage" id="first_response_goal_percentage" value="<%=sla!=null?((int)sla.first_response_goal_percentage).ToString():"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>描述<span class="red"></span></label>
                                <div class="clear">
                                    <textarea id="description" name="description" style=""><%=sla?.description %></textarea>
                                </div>
                            </td>
                            <td style="width: 50%;">
                                <label>解决方案提供时间目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text"  maxlength="3" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" name="resolution_plan_goal_percentage" id="resolution_plan_goal_percentage" value="<%=sla!=null?((int)sla.resolution_plan_goal_percentage).ToString():"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>区域<span class="red"></span></label>
                                <div class="clear">
                                    <select id="location_id" name="location_id">
                                        <option value="">自定义信息</option>
                                        <% if (locaList != null && locaList.Count > 0)
                                            {
                                                foreach (var loca in locaList)
                                                {  %>
                                        <option value="<%=loca.id %>" <%if (sla?.location_id == loca.id)
                                            {%>
                                            selected="selected" <%} %>><%=loca.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                            <td style="width: 50%;">
                                <label>解决时间目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text"  maxlength="3" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" name="resolution_goal_percentage" id="resolution_goal_percentage" value="<%=sla!=null?((int)sla.resolution_goal_percentage).ToString():"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                             <td>
                                <label>假期设置<span class="red">*</span></label>
                                <div class="clear">
                                    <select name="holiday_set_id" id="holiday_set_id">
                                        <% if (holidayList != null && holidayList.Count > 0)
                                            {
                                                foreach (var holiday in holidayList)
                                                {  %>
                                        <option value="<%=holiday.id %>" <%if (sla?.holiday_set_id == holiday.id)
                                            {%>
                                            selected="selected" <%} %>><%=holiday.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                            <td>

                                <div class="clear">
                                    <label>根据sla设置工单结束时间<span class="red"></span></label>
                                    <input type="checkbox" style="margin-top: 3px;" name="isSetEnd" id="isSetEnd" <%if (sla?.set_ticket_due_date == 1)
                                        {%>
                                        disabled="disabled" checked="checked" <%} %> />
                                </div>
                            </td>
                           
                        </tr>
                    </table>
                </div>
            </div>
            <%if (!isAdd)
                { %>
            <div class="nav-title">
                <ul class="clear">
                    <li class="boders" id="general">目标</li>

                    <li id="resourceLi">小时</li>

                </ul>
            </div>
            <div>
                <div class="content clear" id="GeneralDiv">
                    <iframe style="width: 100%; height: 100%;min-height:330px; border: 0px;" src="../Common/SearchBodyFrame.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SYSTEM_SLA_ITEM %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.SYSTEM_SLA_ITEM %>&con5058=<%=sla?.id %>"></iframe>
                </div>
                <div class="content clear" style="display: none;" id="ResourceDiv">
                    <div class="GridContainer">
                        <div style="height: 832px; width: 100%; overflow: auto; z-index: 0; min-width: 900px;">
                            <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                                <tbody>
                                    <tr class="dataGridHeader">
                                        <td style="width: 20%;">星期几</td>
                                        <td style="width: 20%;">正常上班时间-开始</td>
                                        <td style="width: 20%;">正常上班时间-结束</td>
                                        <td style="width: 20%;">延长时间-开始</td>
                                        <td style="width: 20%;">延长时间-结束</td>
                                    </tr>
                                    <%if (hoursList != null && hoursList.Count > 0)
                                        {
                                            foreach (var hours in hoursList)
                                            {%>
                                    <tr>
                                        <td><%=weekArr[hours.weekday] %></td>
                                        <td>
                                            <input type="text" class="start_time" id="<%=hours.weekday %>_start_time" name="<%=hours.id %>_start_time" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=hours.start_time %>" /></td>
                                        <td>
                                            <input type="text" class="end_time" id="<%=hours.weekday %>_end_time" name="<%=hours.id %>_end_time" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=hours.end_time %>" /></td>
                                        <td>
                                            <input type="text" class="extended_start_time" id="<%=hours.weekday %>_extended_start_time" name="<%=hours.id %>_extended_start_time" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=hours.extended_start_time %>" /></td>
                                        <td>
                                            <input type="text" class="extended_end_time" id="<%=hours.weekday %>_extended_end_time" name="<%=hours.id %>_extended_end_time" onclick="WdatePicker({ dateFmt: 'HH:mm' })" value="<%=hours.extended_end_time %>" /></td>
                                    </tr>
                                    <% }
                                        } %>
                                </tbody>
                            </table>
                            <div class="clear" style="width: 100%; height: 100px;">
                                <p>
                                    <input type="radio" style="width: 15px; height: 15px;" name="HoursType" <% if (sla?.holiday_hours_type_id == (int)EMT.DoneNOW.DTO.DicEnum.HOLIDAY_HOURS_TYPE.NO_WORK)
                                        {%> checked="checked" <% } %> value="no" />不上班
                                </p>
                                <p>
                                    <input type="radio" style="width: 15px; height: 15px;" name="HoursType" <% if (sla?.holiday_hours_type_id == (int)EMT.DoneNOW.DTO.DicEnum.HOLIDAY_HOURS_TYPE.WORK)
                                        {%> checked="checked" <% } %> value="yes" />节假日正常上班
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <%} %>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#resourceLi").click(function () {
        var location_id = $("#location_id").val();
        if (location_id != "") {
            return;
        }
        $("#GeneralDiv").hide();
        $("#ResourceDiv").show();
        if (!$(this).hasClass("boders")) {
            $(this).addClass("boders");
        }
        $("#general").removeClass("boders");
    })
    $("#general").click(function () {
        $("#GeneralDiv").show();
        $("#ResourceDiv").hide();
        if (!$(this).hasClass("boders")) {
            $(this).addClass("boders");
        }
        $("#resourceLi").removeClass("boders");
    })

    $("#save_close").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称！");
            return false;
        }
        var isRepeat = "";
        $.ajax({
            type: "GET",
            async: false,
            dataType: "json",
            url: "../Tools/SLAAjax.ashx?act=CheckSLAName&name=" + name + "&id=<%=sla?.id %>",
            success: function (data) {
                if (!data) {
                    isRepeat = "1";
                }
            }
        });
        if (isRepeat == "1") {
            LayerMsg("名称已经使用，请重新填写！");
            return false;
        }
        var locationId = $("#location_id").val();

        if (locationId == "") {
            var isEmpty = "";   // 周一至周五，开始结束时间是否为空
            var isMore = "";     // 上班结束时间是否早于上班开始时间
            var isMoreTime = "";     // 延长时间结束时间是否早于上班时间
            for (var i = 1; i < 8; i++) {
                var thisStartTime = $("#" + i + "_start_time").val();
                var thisEndTime = $("#" + i + "_end_time").val();
                var thisExtStartTime = $("#" + i + "_extended_start_time").val();
                var thisExtEndTime = $("#" + i + "_extended_end_time").val();

                if (i <= 5) {
                    if (thisStartTime == "" || thisEndTime == "") {
                        isEmpty = "1";
                        LayerMsg("请填写完整相关开始结束时间!");
                        return false;
                    }
                }
                else {
                    if (!((thisStartTime == "" && thisEndTime == "") || (thisStartTime != "" && thisEndTime != ""))) {
                        isEmpty = "1";
                        LayerMsg("请填写完整相关开始结束时间!");
                        return false;
                    }
                }
                if (thisStartTime != "" && thisEndTime != "") {
                    if (!CheckDate(thisStartTime, thisEndTime)) {
                        isMore = "1";
                        LayerMsg("开始时间不可以大于结束时间！");
                        return false;
                    }

                    if (!((thisExtStartTime == "" && thisExtEndTime == "") || (thisExtStartTime != "" && thisExtEndTime != ""))) {
                        isEmpty = "1";
                        LayerMsg("请填写完整相关开始结束时间!");
                        return false;
                    }
                    if (thisExtStartTime != "" && thisExtEndTime != "") {
                        if (!CheckDate(thisExtStartTime, thisExtEndTime)) {
                            isMore = "1";
                            LayerMsg("延长时间开始时间不可以大于结束时间！");
                            return false;
                        }
                        if (!CheckDate(thisEndTime, thisExtStartTime)) {
                            isMoreTime = "1";
                            LayerMsg("延长时间不可以早于上班结束时间！");
                            return false;
                        }
                    }
                }
                else {
                    if (thisExtStartTime != "" || thisExtEndTime != "") {
                        LayerMsg("请先选择上班时间，在选择延长时间！");
                        return false;
                    }
                }
            }
        }



        return true;
    })

    $("#location_id").change(function () {
        var thisValue = $(this).val();
        if (thisValue != "") {
            $("#general").trigger("click");
        }
    })
</script>
