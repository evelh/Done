<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OutsourceTicket.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.OutsourceTicket" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" href="../Content/index.css" />
    <link rel="stylesheet" href="../Content/style.css" />
    <title>外包</title>
    <style>
        .content input {
            margin-left: 0px;
        }

        input[type="checkbox"], input[type="radio"] {
            width: 15px;
            height: 15px;
        }
        .content textarea{
            margin-left:0px;
        }
        .red{
            color:red;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">工单外包-<%=ticket?.no+" - "+ticket?.title+$"({account?.name})" %></div>
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 95px;">
            <div class="content clear" style="width: 100%;">
                <div class="information clear" style="min-height: 220px;">
                    <p class="informationTitle" style="font-weight: 800;">合作伙伴选择</p>
                    <div style="padding-left: 20px;">
                        <table border="none" cellspacing="" cellpadding="" style="width: 100%; max-width: 1000px; min-width: 400px;">
                            <tr>
                                <td style="width: 150px; text-align: left;">
                                    <span style="font-weight: 600;">合作伙伴名称<span class="red"></span></span>
                                    <div class="clear">
                                        <input type="text" name="name" id="name" value="" />
                                    </div>
                                </td>
                                <td style="width: 80px;">
                                    <span style="margin-top: 7px; display: inline-block;">最近的</span>
                                    <span>
                                        <input type="checkbox" name="isRecent" id="isRecent" /></span>
                                </td>
                                <td style="text-align: right;">
                                    <span style="border: 1px solid #CCCCCC; cursor: pointer; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 25px; width: 30px; margin: 5px; padding: 5px;" onclick="SearchPartner()">查询</span>
                                    <span style="border: 1px solid #CCCCCC; cursor: pointer; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 25px; width: 30px; margin: 5px; padding: 5px;" onclick="Reset()">重置</span>
                                </td>
                            </tr>
                            <tr style="height: 10px;">
                                <td colspan="3"></td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                                        <thead>
                                            <tr class="dataGridHeader">
                                                <td style="width: 20px;"></td>
                                                <td>名称</td>
                                                <td>省-市-区县</td>
                                                <td>地址</td>
                                                <td>邮编</td>
                                                <td>电话</td>
                                            </tr>
                                        </thead>
                                        <tbody id="partnerAccountTbody">
                                        </tbody>
                                    </table>

                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear" style="min-height: 100px;">
                    <p class="informationTitle" style="font-weight: 800;">合作伙伴</p>
                    <div style="padding-left: 20px;">
                        <span style="float: left;">自动拒绝</span><span>
                            <input style="margin: -3px 8px;" maxlength="3" type="text" id="RefuseTime" class="ToDec2" value="1.00" />
                            <input type="hidden" name="AdjustTimeHidden" id="AdjustHidden" value="<%=DateTime.Now.AddHours(1).ToString("yyyy-MM-dd HH:mm") %>"/>
                                                              </span>
                        <span>小时，将于</span><span id="AdjustText"><%=DateTime.Now.AddHours(1).ToString("yyyy-MM-dd HH:mm") %></span><span>自动拒绝</span>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle" style="font-weight: 800;">收费信息</p>
                    <div style="padding-left: 20px;">
                        <table border="none" cellspacing="" cellpadding="" style="width: 500px; max-width: 1000px; min-width: 400px;">
                            <tr>
                                <td colspan="3"></td>
                            </tr>
                            <tr>
                                <td style="width: 100px; text-align: left;">
                                    <span style="font-weight: 600;">收费类型</span><span class="red">*</span></td>
                                <td colspan="2" style="text-align: left;">
                                    <span>
                                        <%if (chargeTypeList != null && chargeTypeList.Count > 0)
                                            {
                                                foreach (var chargeType in chargeTypeList)
                                                {%>
                                        <span style="float: left; margin-left: 20px;">
                                            <input type="radio" id="rb<%=chargeType.id %>" name="chargeType" value="<%=chargeType.id %>" /></span><span style="float: left"><%=chargeType.name %></span>
                                        <% }
                                            } %>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:left;">
                                    <span style="font-weight: 600;">工时费率<span class="red">*</span></span>
                                    <div class="clear">
                                        <input type="text" name="rate" id="rate" class="ToDec2" style="width: 80px;" value="" />
                                    </div>
                                </td>
                                <td style="text-align:left;">
                                    <span style="font-weight: 600;margin-left: 13px;">工时计费代码<span class="red">*</span></span>
                                    <div class="clear">
                                        <select id="cost_cost_code_id" name="cost_cost_code_id">
                                            <option></option>
                                            <%if (billCodeList != null && billCodeList.Count > 0)
                                                {
                                                    foreach (var billCode in billCodeList)
                                                    {%>
                                            <option value="<%=billCode.id %>"><%=billCode.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                                <td style="text-align:left;">
                                    <div id="AmountDiv" style="display:none;">
                                    <span style="font-weight: 600;">向客户收费<span class="red">*</span></span>
                                    <div class="clear">
                                        <input type="text" name="flat_bill_amount" id="flat_bill_amount" class="ToDec2" style="width: 80px;" value="" />
                                    </div>
                                        </div>
                                       <div id="RoleDiv" >
                                    <span style="font-weight: 600;margin-left:15px;">以此角色费率向用户收费<span class="red">*</span></span>
                                    <div class="clear">
                                        <select id="default_role_id" name="default_role_id">
                                            <option></option>
                                            <%if (roleList != null && roleList.Count > 0) {
                                                    foreach (var role in roleList)
                                                    {%>
                                            <option value="<%=role.id %>"><%=role.name %></option>
                                                   <% }
                                                } %>
                                        </select>
                                    </div>
                                        </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="text-align: left;">
                                    <span style="font-weight: 600;">预估时间<span class="red">*</span></span>
                                    <div class="clear">
                                        <input type="text" name="authorized_hours" id="authorized_hours" class="ToDec2" style="width: 80px;" value="" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">
                                    <span style="font-weight: 600;">成本<span class="red"></span></span>
                                    <div class="clear">
                                        <input type="text" name="authorized_cost" id="authorized_cost" class="ToDec2" style="width: 80px;" value="" />
                                    </div>
                                </td>
                                <td colspan="2" style="text-align: left;">
                                    <span style="font-weight: 600;margin-left: 13px;">工时计费代码<span class="red">*</span></span>
                                    <div class="clear">
                                        <select id="labor_cost_code_id" name="labor_cost_code_id">
                                            <option></option>
                                            <%if (billCodeList != null && billCodeList.Count > 0)
                                                {
                                                    foreach (var billCode in billCodeList)
                                                    {%>
                                            <option value="<%=billCode.id %>"><%=billCode.name %></option>
                                            <% }
                                                } %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="text-align:left;"><span>汇总</span><span id="TotalMoney" style="margin-left: 20px;"></span></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle" style="font-weight: 800;">说明</p>
                    <div style="padding-left: 20px;">
                        <table border="none" cellspacing="" cellpadding="" style="width: 100%; max-width: 1000px; min-width: 400px;">
                            <tr>
                                <td style="text-align:left;font-weight: 600;">要求完成时间<span style="color:red;">*</span></td>
                                <td colspan="3"><input type="text" id="authorized_time" name ="authorizedTime" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })"/></td>
                            </tr>
                            <tr>
                                <td style="text-align:left;font-weight: 600;">点击添加</td>
                                <td><a class="AppTextA">需要现场支持	</a></td>
                                <td><a class="AppTextA">需要最终用户签名</a></td>
                                <td><a class="AppTextA">要求提供零件	</a></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><a class="AppTextA">着装要求休闲		</a></td>
                                <td><a class="AppTextA">着装要求商务休闲</a></td>
                                <td><a class="AppTextA">着装要求正装	</a></td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <textarea style="width:100%;resize: vertical;height:150px;min-height:150px;" id="instructions" name="instructions"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:left;" colspan="4">
                                    工单描述
                                </td>
                            </tr>
                             <tr>
                                <td colspan="4">
                                    <textarea style="width:100%;resize: vertical;height:150px;min-height:150px;" id="description" name="description"><%=ticket?.description %></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>

    $(function () {
        $("#rb3184").trigger("click");
    })

    function SearchPartner() {
        var name = $("#name").val();
        var html = "";
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/CompanyAjax.ashx?act=GetPartnerInfo&name=" + name,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    for (var i = 0; i < data.length; i++) {
                        html += "<tr><td><input type='radio' name='partnerAcc' value='" + data[i].id + "'/></td><td>" + data[i].name + "</td><td>" + data[i].address_name + "</td><td>" + data[i].address + "</td><td>" + (data[i].postal_code == null ? "" : data[i].postal_code) + "</td><td>" + data[i].phone + "</td></tr>";
                    }
                }

            },
        });
        $("#partnerAccountTbody").html(html);
    }

    function Reset() {

    }
    $(".AppTextA").click(function () {
        var text = $(this).text();
        var oldVal = $("#instructions").val();
        var newVal = text + "\n" + oldVal;
        $("#instructions").val(newVal);
    })

    $(".ToDec2").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }
    })

    $("#RefuseTime").blur(function () {
        var hours = $(this).val();
        if (hours == "" || isNaN(hours)) {
            hours = 1;
        }
        var todatDate = new Date().getTime();
        var addTime = todatDate+ Number(hours) * 60 * 60 * 1000;
        var ajustDate = new Date(addTime);
        var adjustText = ajustDate.getFullYear() + "-" + (ajustDate.getMonth() + 1) + "-" + ajustDate.getDate() + " " + ajustDate.getHours() + ":" + ajustDate.getMinutes();

        $("#AdjustText").text(adjustText);
        $("#AdjustHidden").val(adjustText);
    })

    $("#rb3184").click(function () {
        $("#rate").prop("disabled", false);
        $("#cost_cost_code_id").prop("disabled", false);
        $("#RoleDiv").show();
        $("#AmountDiv").hide();
        $("#authorized_hours").prop("disabled", false);
        CheckAmount();
    })
    $("#rb3185").click(function () {
        $("#rate").prop("disabled", false);
        $("#cost_cost_code_id").prop("disabled", false);
        $("#RoleDiv").hide();
        $("#AmountDiv").show();
        $("#authorized_hours").prop("disabled", true);
        $("#authorized_hours").val("");
        CheckAmount();
    })
    $("#rb3186").click(function () {
        $("#rate").prop("disabled", true);
        $("#rate").val("");
        $("#cost_cost_code_id").prop("disabled", true);
        $("#RoleDiv").show();
        $("#AmountDiv").hide();
        $("#authorized_hours").prop("disabled", true);
        $("#authorized_hours").val("");
        CheckAmount();
    })

    function CheckAmount() {
        var rate = $("#rate").val();
        if (rate == "" || rate == null || rate == undefined) {
            rate = 0;
        }
        var authorized_hours = $("#authorized_hours").val();
        if (authorized_hours == "" || authorized_hours == null || authorized_hours == undefined) {
            authorized_hours = 1;
        }
        var authorized_cost = $("#authorized_cost").val();
        if (authorized_cost == "" || authorized_cost == null || authorized_cost == undefined) {
            authorized_cost = 0;
        }

        var amount = Number(rate) * Number(authorized_hours) + Number(authorized_cost);
        $("#TotalMoney").text(toDecimal2(amount));

    }
    $("#rate").blur(function () {
        CheckAmount();
    });

    $("#authorized_hours").blur(function () {
        CheckAmount();
    });
    
    $("#authorized_cost").blur(function () {
        CheckAmount();
    });

    $("#save_close").click(function () {
        var accountId = $("input[name = 'partnerAcc']").eq(0).val();
        if (accountId == "" || accountId == null || accountId == undefined) {
            LayerMsg("请选择合作伙伴");
            return false;
        }
        var chargeType = $("input[name = 'chargeType']").eq(0).val();
        if (chargeType == "" || chargeType == null || chargeType == undefined) {
            LayerMsg("请选择计费类型");
            return false;
        }
        var rate = $("#rate").val();
        var cost_cost_code_id = $("#cost_cost_code_id").val();
        var default_role_id = $("#default_role_id").val();
        var flat_bill_amount = $("#flat_bill_amount").val(); 
        var authorized_hours = $("#authorized_hours").val();
        var authorized_cost = $("#authorized_cost").val();
        var labor_cost_code_id = $("#labor_cost_code_id").val();
        if (chargeType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.OUTSOURCE_RATE_TYPE.FLAT %>') {
            if (rate == "" || rate == null || rate == undefined) {
                LayerMsg("请填写工时费率");
                return false;
            }
            if (cost_cost_code_id == "" || cost_cost_code_id == null || cost_cost_code_id == undefined) {
                LayerMsg("请选择工时计费代码");
                return false;
            }
            if (default_role_id == "" || default_role_id == null || default_role_id == undefined) {
                LayerMsg("请选择相关角色");
                return false;
            }
            if (authorized_hours == "" || authorized_hours == null || authorized_hours == undefined) {
                LayerMsg("请填写预估时间");
                return false;
            }
            if (authorized_cost != "" && authorized_cost != null && authorized_cost != undefined) {
                if (labor_cost_code_id == "" || labor_cost_code_id == null || labor_cost_code_id == undefined) {
                    LayerMsg("请选择工时计费代码");
                    return false;
                }
            }
            
        }
        else if (chargeType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.OUTSOURCE_RATE_TYPE.HOURLY %>'){
            if (rate == "" || rate == null || rate == undefined) {
                LayerMsg("请填写工时费率");
                return false;
            }
            if (cost_cost_code_id == "" || cost_cost_code_id == null || cost_cost_code_id == undefined) {
                LayerMsg("请选择工时计费代码");
                return false;
            }
            if (flat_bill_amount == "" || flat_bill_amount == null || flat_bill_amount == undefined) {
                LayerMsg("请填写向客户收费");
                return false;
            }
            if (default_role_id == "" || default_role_id == null || default_role_id == undefined) {
                LayerMsg("请选择相关角色");
                return false;
            }
            
            if (authorized_cost != "" && authorized_cost != null && authorized_cost != undefined) {
                if (labor_cost_code_id == "" || labor_cost_code_id == null || labor_cost_code_id == undefined) {
                    LayerMsg("请选择工时计费代码");
                    return false;
                }
            }
        }
        else if (chargeType == '<%=(int)EMT.DoneNOW.DTO.DicEnum.OUTSOURCE_RATE_TYPE.NONE %>') {
            if (default_role_id == "" || default_role_id == null || default_role_id == undefined) {
                LayerMsg("请选择相关角色");
                return false;
            }
            if (authorized_cost != "" && authorized_cost != null && authorized_cost != undefined) {
                if (labor_cost_code_id == "" || labor_cost_code_id == null || labor_cost_code_id == undefined) {
                    LayerMsg("请选择工时计费代码");
                    return false;
                }
            }
        }

        var authorized_time = $("#authorized_time").val();
        if (authorized_time == "" || authorized_time == null || authorized_time == undefined) {
            LayerMsg("请填写要求完成时间！");
            return false;
        }
        
        return true;

    })



</script>
