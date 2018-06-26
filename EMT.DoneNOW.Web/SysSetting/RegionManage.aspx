<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegionManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.RegionManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>区域</title>
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />

</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %>区域</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">常规</li>
                <%if (!isAdd)
                    { %>
                <li id="resourceLi">小时</li>
                <%} %>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 140px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>名称<span class="red">*</span></label>
                                        <input type="text" name="name" id="name" value="<%=location?.name %>" />

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>默认<span class="red"></span></label>
                                        <input type="checkbox" name="isDefault" id="isDefault" <%if (location?.is_default==1)
                                            {%>
                                            disabled="disabled" checked="checked" <%} %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>国家<span class=" red">*</span></label>
                                        <select name="country_id" id="country_id">
                                            <% if (counList != null && counList.Count > 0) {
                                                foreach (var coun in counList)
                                                {%>
                                            <option value="<%=coun.id %>" <%if (location?.country_id == coun.id) {%> selected="selected" <% } %>><%=coun.country_name_display %></option>
                                            <%}
                                            } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>省份<span class=" red"></span></label>
                                        <input id="province_idInit" value='<%=location?.province_id!=null?location?.province_id.ToString():"5" %>' type="hidden" />
                                        <select name="province_id" id="province_id">
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>城市<span class=" red"></span></label>
                                        <input id="city_idInit" value='<%=location?.city_id %>' type="hidden" />
                                        <select name="city_id" id="city_id">
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>区县<span class=" red"></span></label>
                                        <input id="district_idInit" value='<%=location?.district_id %>' type="hidden" />
                                        <select name="district_id" id="district_id">
                                        </select>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>详细地址<span class="red"></span></label>
                                        <input type="text" name="address" id="address" value="<%=location?.address %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>地址附加信息<span class="red"></span></label>
                                        <input type="text" name="additional_address" id="additional_address" value="<%=location?.additional_address %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>邮编<span class="red"></span></label>
                                        <input type="text" name="postal_code" id="postal_code" value="<%=location?.postal_code %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>假期设置<span class="red">*</span></label>
                                        <select name="holiday_set_id" id="holiday_set_id">
                                            <% if (holidayList != null && holidayList.Count > 0)
                                                {
                                                    foreach (var holiday in holidayList)
                                                    {  %>
                                            <option value="<%=holiday.id %>" <%if (location?.holiday_set_id == holiday.id)
                                                {%>
                                                selected="selected" <%} %>><%=holiday.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>

                        </table>
                    </div>
                </div>
            </div>
            <div class="content clear" style="display: none;" id="ResourceDiv">
                <%if (!isAdd)
                    { %>

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
                                <%if (hoursList != null && hoursList.Count > 0) {
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
                                <input type="radio" style="width: 15px; height: 15px;" name="HoursType" <% if (location?.holiday_hours_type_id == (int)EMT.DoneNOW.DTO.DicEnum.HOLIDAY_HOURS_TYPE.NO_WORK) {%> checked="checked" <% } %> value="no" />不上班</p>
                            <p>
                                <input type="radio" style="width: 15px; height: 15px;" name="HoursType" <% if (location?.holiday_hours_type_id == (int)EMT.DoneNOW.DTO.DicEnum.HOLIDAY_HOURS_TYPE.WORK) {%> checked="checked" <% } %> value="yes" />节假日正常上班</p>
                        </div>
                    </div>
                </div>
                <%} %>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        InitArea();
    });
    $("#resourceLi").click(function () {
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
</script>
<script>
    $(function () {

        <%if (Request.QueryString["type"] == "res")
    { %>
        $("#resourceLi").trigger("click");
        <%} %>

    })

    $("#save_close").click(function () {
        var name = $("#name").val();
        if (name == "" || $.trim(name) == "") {
            LayerMsg("请填写相关名称");
            return false;
        }

        var country_id = $("#country_id").val();
        if (country_id == "" || $.trim(country_id) == "") {
            LayerMsg("请选择相关国家");
            return false;
        }

        var holiday_set_id = $("#holiday_set_id").val();
        if (holiday_set_id == "") {
            LayerMsg("请选择节假日设置！");
            return false;
        }

        


        <%if(!isAdd){ %>
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
                    if (!CheckDate(thisEndTime,thisExtStartTime)) {
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
        if (isEmpty == "1") {
            LayerMsg("请填写完整相关开始结束时间!");
            return false;
        }
        if (isMore == "1") {
            LayerMsg("开始时间不可以大于结束时间！");
            return false;
        }
        if (isMoreTime == "1") {
            LayerMsg("延长时间不可以早于上班结束时间！");
            return false;
        }

        <%}%>

        return true;
    })
    // 校验时，分的大小
    function CheckDate(start, end) {
        if (start == "" || end == "") {
            return false;
        }
        var startArr = start.split(':');
        var endArr = end.split(':');
        if (startArr.length != 2 || endArr.length != 2) {
            return false;
        }
        if (Number(startArr[0] + startArr[1]) >= Number(endArr[0] + endArr[1])) {
            return false;
        }
        return true;
    }
</script>
