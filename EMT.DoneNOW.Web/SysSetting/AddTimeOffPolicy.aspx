<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddTimeOffPolicy.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.AddTimeOffPolicy" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%if (isAdd)
               { %>新增<%}
                         else
                         { %>编辑<%} %>休假策略</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <div class="header">
        <%if (isAdd)
            { %>新增<%}
                      else
                      { %>编辑<%} %>休假策略
    </div>
    <div class="header-title" style="min-width: 700px;">
        <ul>
            <li id="SaveClose">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <input type="button" value="保存并关闭" />
            </li>
            <li id="SaveNew">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                <input type="button" value="保存并新建" />
            </li>
            <li id="Cancle">
                <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <input type="button" value="取消" />
            </li>
        </ul>
    </div>
    <form id="form1" runat="server">
        <div class="nav-title">
            <ul class="clear">
                <li class="boders">常规</li>
                <%if (policyItems.Exists(_ => _.cate_id == 35)) { %>
                <li>私人时间</li>
                <%} %>
                <%if (policyItems.Exists(_ => _.cate_id == 25)) { %>
                <li>年假</li>
                <%} %>
                <%if (policyItems.Exists(_ => _.cate_id == 23)) { %>
                <li>病假</li>
                <%} %>
                <%if (policyItems.Exists(_ => _.cate_id == 27)) { %>
                <li>浮动假期</li>
                <%} %>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 136px;">
            <div class="content clear" style="width:900px;">
                <div class="text">定义此休假方案的名称和描述，然后依次到休假类别选项卡设置每种休假类别的概述信息和级别。最后为此休假方案关联员工。请确保每种休假类别里的级别都是正确的。因为一旦关联员工，只能更新假期方案里的概述信息。</div>

                <div class="information clear">
                    <p class="informationTitle">常规信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>名称<span style="color: red;">*</span></label>
                                        <input type="hidden" id="subAct" name="subAct" />
                                        <input type="text" id="policyName" name="policyName" <%if (!isAdd)
                                            { %> value="<%=policy.name %>" <%} %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>描述</label>
                                        <input type="text" id="description" name="description" <%if (!isAdd)
                                            { %> value="<%=policy.description %>" <%} %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label for="active">激活</label>
                                        <input type="checkbox" id="active" <%if (isAdd || policy.is_active == 1) { %> checked="checked" <%} %> name="active" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label for="setDft">默认（针对新员工）</label>
                                        <input type="checkbox" <%if (!isAdd && policy.is_default == 1) { %> checked="checked" <%} %> id="setDft" name="setDft" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear" style="height:480px;">
                    <p class="informationTitle">关联员工</p>
                    <div class="text">请调整员工的生效开始日期，编辑关联。不能编辑生效截止日期。</div>
                    <div class="text clear">
                        <input type="button" value="关联员工" id="assRes" style="margin-left:0px;" />
                    </div>
                    <div id="showResource" style="width:100%;height:380px;margin-top:3px;border-top:1px solid #e8e8fa">
                        <iframe id="resourceFrame" src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_POLICY_RESOURCE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TimeoffPolicyResource %>&con2467=<%=isAdd?0:policy.id %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                    </div>
                </div>

            </div>
            <%foreach (var item in policyItems) { %>
            <div class="content clear" style="width:900px;display:none;">
                <div class="text">设置此休假类别的级别。累计分配的时间将在每个累计增长周期的最后一天获得（累计增长量=年小时数/当年的总累计增长周期数）：统一分配的时间在1月1日获得。如果员工关联的新休假方案在1月1日之后，也不会丢失累计增长或统一分配的时间。</div>

                <div class="information clear">
                    <p class="informationTitle">常规信息</p>
                    <input type="hidden" id="itemid<%=item.cate_id %>" name="itemid<%=item.cate_id %>" value="<%=item.id %>" />
                    <div>
                        <div class="text">如果时间为累计分配，请为此休假方案选择累计增长周期。一旦此假期方案关联了一个或多个员工，关联词休假类别的类型、累计增长周期和级别都不能修改。</div>
                        <table border="none" cellspacing="" cellpadding="" style="width:400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label style="font-weight:normal;">分配类型</label>
                                        <input type="radio" value="1" class="itemTierCheck" <%if (isAdd || item.accrual_period_type_id == null) { %> checked="checked" <%} %> name="periodType<%=item.cate_id %>" onclick="ChangeType(<%=item.cate_id %>,1);" style="width:16px;height:16px;" />统一分配
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label></label>
                                        <input type="radio" value="2" class="itemTierCheck" <%if (!isAdd && item.accrual_period_type_id != null) { %> checked="checked" <%} %> name="periodType<%=item.cate_id %>" onclick="ChangeType(<%=item.cate_id %>,2);" style="width:16px;height:16px;" />累计分配
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table border="none" cellspacing="" cellpadding="">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label style="font-weight:normal;">增长周期</label>
                                        <select id="period<%=item.cate_id %>" name="period<%=item.cate_id %>" class="itemTierCheck" <%if (isAdd || item.accrual_period_type_id == null) { %> disabled="disabled" <%} %>>
                                            <%foreach (var period in periodList) { %>
                                            <option value="<%=period.val %>" <%if ((isAdd&&period.show.Equals("半月"))||(!isAdd&&item.accrual_period_type_id!=null&&item.accrual_period_type_id.Value.ToString()==period.val)) { %> selected="selected" <%} %> ><%=period.show %></option>
                                            <%} %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear" style="height:460px;">
                    <p class="informationTitle">休假策略级别</p>
                    <div class="text clear">
                        <input type="button" value="新增" style="margin-left:0;" onclick="AddPolicyTier(<%=item.cate_id %>)" />
                    </div>
                    <div id="showTier" style="width:100%;margin-top:3px;border-top:1px solid #e8e8fa;height:390px;">
                        <iframe id="tierFrame<%=item.cate_id %>" src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_POLICY_TIER %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TimeoffPolicyTier %>&con2468=<%=item.id==0?0:item.id %>&cate=<%=item.cate_id %>&cateType=<%=(isAdd || item.accrual_period_type_id == null) ? 1 : 2 %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
                    </div>
                </div>

            </div>
            <%} %>
        </div>

    </form>
    <div id="background" style="left: 0px; top: 0px; opacity: 0.6; z-index: 300; width: 100%; height: 100%; position: fixed; display: none; background-color: rgb(27,27,27); overflow: hidden;"></div>
    <div id="memo" style="display: none; z-index: 301; position: absolute; top: 220px; left: 260px; width: 430px; height: 450px; background-color: white;">
        <div class="header" style="height: 32px;">关联员工</div>
        <div id="CancleMemo" style="position: absolute; height: 32px; width: 32px; top: 0px; right: 0px; background: url(../Images/cancel1.png);"></div>
        <div class="header-title">
            <ul>
                <li id="SaveRes">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" value="保存并关闭" />
                </li>
            </ul>
            <label style="display:none;">在关联员工之前，确保休假策略、类别、级别设置是正确的。 一旦资源关联，您就无法更新策略相关信息。 注意：员工与此策略的关联可能需要几分钟时间（这取决于关联给此策略的员工数量，此策略的类别定义以及与这些员工关联的其他策略情况）。</label>
        </div>
        <div style="padding: 0 10px 0 10px;">
            <label style="font-weight: normal;">在关联员工之前，确保休假策略、类别、级别设置是正确的。 一旦资源关联，您就无法更新策略相关信息。 注意：员工与此策略的关联可能需要几分钟时间（这取决于关联给此策略的员工数量，此策略的类别定义以及与这些员工关联的其他策略情况）。</label><br />
            <label style="margin-top: 6px;">员工</label><i class="icon-dh" onclick="SelectResource()"></i><br />
            <input type="hidden" id="resourceSelectHidden" />
            <input type="hidden" id="resourceSelect" />
            <textarea style="width: 260px; height: 100px;" readonly="readonly" id="tierResource"></textarea>
            <br />
            <label style="margin-top: 6px;">生效日期</label><br />
            <input type="text" class="Wdate" onclick="WdatePicker()" id="effectDate" />
        </div>
    </div>
    <div id="newTier" style="display: none; z-index: 302; position: absolute; top: 220px; left: 100px; width: 670px; height: 390px; background-color: white;">
        <div class="header" style="height: 32px;">新增策略级别</div>
        <div id="CancleTier" style="position: absolute; height: 32px; width: 32px; top: 0px; right: 0px; background: url(../Images/cancel1.png);"></div>
        <div class="header-title">
            <ul>
                <li id="SaveTier">
                    <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <input type="button" value="保存并关闭" />
                    <input type="hidden" id="tierCate" />
                </li>
            </ul>
        </div>
        <div style="width:650px;border:1px solid #d3d3d3;margin:0 10px 10px 10px;padding:10px;">
            <label>年度时间和限额</label>
            <label style="font-weight: normal;margin-bottom:12px;">指定资源在1月1日可能收到的总数小时数或全年累计的小时数。 另外，可以为应计“累计限额”或将“滚存限额”延续到下一年的小时指定一个上限。</label><br />
            <label style="font-weight: normal;width:100px;">每年假期时间<span style="color: red;">*</span></label>
            <input type="text" style="width:80px;" id="annualHours" onchange="ChangeHours()" />
            <label style="font-weight: normal;width:36px;">小时</label>
            <select id="annualMinutes" onchange="ChangeHours()" style="width:80px;">
                <option value="0">00</option>
                <option value="0.25">15</option>
                <option value="0.5">30</option>
                <option value="0.75">45</option>
            </select>
            <label style="font-weight: normal;width:36px;">分钟</label>
            <label style="font-weight: normal;width:120px;text-align:right;" id="prdRateLabel">每周期假期时间</label>
            <label style="font-weight: normal;margin-left:6px;" id="prdRate">0.0000小时</label>
            <br />
            <label style="font-weight: normal;width:100px;" id="capName">滚存限额</label>
            <input type="text" style="width:80px;" id="accrualHours" />
            <label style="font-weight: normal;width:36px;">小时</label>
            <select id="accrualMinutes" style="width:80px;">
                <option value=""></option>
                <option value="0">00</option>
                <option value="0.25">15</option>
                <option value="0.5">30</option>
                <option value="0.75">45</option>
            </select>
            <label style="font-weight: normal;width:36px;">分钟</label>
        </div>
        <div style="width:650px;border:1px solid #d3d3d3;margin:0 10px 10px 10px;padding:10px;">
            <label>员工何时适用这种情况</label>
            <label style="font-weight: normal;margin-bottom:12px;">使用员工的聘用日期来确定他们的服务时间（以月为单位）以及适用于他们的级别。</label><br />
            <label style="font-weight: normal;width:100px;">最低工作年限</label>
            <input type="text" style="width:80px;" id="minMonths" />
            <label style="font-weight: normal;">月</label>
        </div>
    </div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script>
        $.each($(".nav-title li"), function (i) {
            $(this).click(function () {
                $(this).addClass("boders").siblings("li").removeClass("boders");
                $(".content").eq(i).show().siblings(".content").hide();
            })
        });
        $("#SaveClose").click(function () {
            $("#subAct").val("SaveClose");
            if ($("#policyName").val() == "") {
                LayerMsg("请输入名称");
                return;
            }
            <%if (isAdd) { %>
            LayerLoad();
        <%}%>
            $(".itemTierCheck").each(function () {
                $(this).removeAttr("disabled");
            });
            $("#form1").submit();
        })
        $("#Cancle").click(function () {
            window.close();
        })
        $("#SaveNew").click(function () {
            $("#subAct").val("SaveNew");
            if ($("#policyName").val() == "") {
                LayerMsg("请输入名称");
                return;
            }
            <%if (isAdd) { %>
            LayerLoad();
        <%}%>
            $(".itemTierCheck").each(function () {
                $(this).removeAttr("disabled");
            });
            $("#form1").submit();
        })
        $("#active").change(function () {
            if ($("#active").is(':checked') == true) {
                $("#assRes").removeAttr("disabled");
            } else {
                $("#assRes").attr("disabled", "disabled");
            }
        })
        $("#setDft").change(function () {
            if ($("#setDft").is(':checked') == true) {
                $("#active").prop("checked", true);
                $("#active").attr("disabled", "disabled");
                $("#assRes").removeAttr("disabled");
            } else {
                $("#active").removeAttr("disabled");
            }
        })
    </script>
    <script>
        <%if (tierResCnt > 0) { %> 
        var tierCnt = 1;
        $(".itemTierCheck").each(function () {
            $(this).attr("disabled", "disabled");
        });
        <%} else { %> var tierCnt = 0; <%} %>
        function GetTierCnt() {
            return tierCnt;
        }
        function SelectResource() {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.RESOURCE_CALLBACK %>&muilt=1&field=resourceSelect&callBack=GetResource", windowType.blank, 'left=200,top=200,width=600,height=800', false);
        }
        function GetResource() {
            var res = $("#resourceSelect").val();
            if (res == "") {
                $("#tierResource").text("");
                return;
            }
            var resList = res.split(',');
            var restext = "";
            for (var i = 0; i < resList.length; i++) {
                restext = restext + resList[i] + "\n";
            }
            $("#tierResource").text(restext);
        }
        $("#SaveRes").click(function () {
            if ($("#resourceSelectHidden").val() == "") {
                LayerMsg("请选择员工");
                return;
            }
            if ($("#effectDate").val() == "") {
                LayerMsg("请选择生效日期");
                return;
            }
            requestData("/Tools/TimeoffPolicyAjax.ashx?act=checkResourceAss&resIds=" + $("#resourceSelectHidden").val() + "&beginDate=" + $("#effectDate").val(), null, function (data) {
                if (data == "") {
                    SaveRes();
                } else {
                    LayerConfirmOk(data, "确定", "取消关联", function () {
                        SaveRes();
                    })
                }
            })
        })
        function SaveRes() {
            <%if (!isAdd) { %>
            LayerLoad();
        <%}%>
            requestData("/Tools/TimeoffPolicyAjax.ashx?act=associateResource&resIds=" + $("#resourceSelectHidden").val() + "&resNames=" + $("#resourceSelect").val() + "&beginDate=" + $("#effectDate").val() + "&policyId=<%=isAdd?0:policy.id %>", null, function (data) {
                if (data == true) {
                    tierCnt = 1;
                    $(".itemTierCheck").each(function () {
                        $(this).attr("disabled", "disabled");
                    });
                    $("#resourceFrame").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_POLICY_RESOURCE %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TimeoffPolicyResource %>&con2467=<%=isAdd?0:policy.id %>");
                }
                <%if (!isAdd) { %>
                LayerLoadClose();
            <%}%>
                $("#background").hide();
                $("#memo").hide();
            })
        }
        $("#CancleMemo").click(function () {
            $("#background").hide();
            $("#memo").hide();
        })
        $("#assRes").click(function () {
            $("#resourceSelect").val("");
            $("#resourceSelectHidden").val("");
            $("#tierResource").text("");
            $("#effectDate").val("");
            $("#background").show();
            $("#memo").show();
        })
        function DisAssResource(id) {
            LayerConfirm("您确定要解除此策略的员工吗？\r将此员工与该策略分离将导致系统重新计算员工姓名目前的假期余额（根据参加工作时间计算）。 你确定你要这么做吗？", "确定", "取消", function () {
                LayerLoad();
                requestData("/Tools/TimeoffPolicyAjax.ashx?act=disassociateResource&id=" + id, null, function (data) {
                    LayerLoadClose();
                    if (data == true) {
                        window.location.reload();
                    }
                })
            }, function () { })
        }
    </script>
    <script>
        var itemId = 0;
        $("#CancleTier").click(function () {
            $("#background").hide();
            $("#newTier").hide();
        })
        $("#SaveTier").click(function () {
            if ($("#annualHours").val() == "") {
                LayerMsg("请输入每年假期时间");
                return;
            }
            if ($("#minMonths").val() == "") {
                LayerMsg("请输入最低工作年限");
                return;
            }
            var cate = $("#tierCate").val();
            var annual = parseInt($("#annualHours").val()) + parseFloat($("#annualMinutes").val());
            var cap = "";
            if ($("#accrualHours").val() != "" && $("#accrualMinutes").val() != "") {
                cap = parseInt($("#accrualHours").val()) + parseFloat($("#accrualMinutes").val());
            } else if ($("#accrualHours").val() != "") {
                cap = parseInt($("#accrualHours").val());
            } else if ($("#accrualMinutes").val() != "") {
                cap = parseFloat($("#accrualMinutes").val());
            }
            var cateType = $('input:radio[name="periodType' + cate + '"]:checked').val();
            requestData("/Tools/TimeoffPolicyAjax.ashx?act=editPolicyTier&tierId=" + itemId + "&cate=" + cate + "&itemid=" + $("#itemid" + cate).val() + "&annual=" + annual + "&cap=" + cap + "&months=" + $("#minMonths").val() + "&policyId=<%=isAdd?0:policy.id %>", null, function (data) {
                if (data == true) {
                    $("#tierFrame" + cate).attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_POLICY_TIER %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TimeoffPolicyTier %>&con2468=" + $("#itemid" + cate).val() + "&cate=" + cate + "&cateType=" + cateType);
                }
                $("#background").hide();
                $("#newTier").hide();
            })
        })
        function AddPolicyTier(idx) {
            if (tierCnt > 0) {
                LayerMsg("关联员工后不能修改休假策略级别");
                return;
            }
            itemId = 0;
            $("#tierCate").val(idx);
            $("#annualHours").val("");
            $("#annualMinutes").val("0");
            $("#accrualHours").val("");
            $("#accrualMinutes").val("");
            $("#minMonths").val("");
            if ($("input[name='periodType" + idx + "']:checked").val() == 1) {
                $("#prdRateLabel").hide();
                $("#prdRate").hide();
            } else {
                $("#prdRateLabel").show();
                $("#prdRate").show();
                $("#prdRate").text("0.0000小时");
            }
            $("#background").show();
            $("#newTier").show();
        }
        function ChangeType(cate, idx) {
            if (idx == 1) {
                $("#period" + cate).attr("disabled", "disabled");
                $("#prdRateLabel").hide();
                $("#prdRate").hide();
                $("#capName").text("滚存限额");
                $("#tierFrame" + cate).attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_POLICY_TIER %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TimeoffPolicyTier %>&con2468=" + $("#itemid" + cate).val() + "&cate=" + cate + "&cateType=" + idx);
            } else {
                $("#period" + cate).removeAttr("disabled");
                $("#prdRateLabel").show();
                $("#prdRate").show();
                $("#capName").text("累计增长限额");
                $("#tierFrame" + cate).attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TIMEOFF_POLICY_TIER %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.TimeoffPolicyTier %>&con2468=" + $("#itemid" + cate).val() + "&cate=" + cate + "&cateType=" + idx);
            }
        }
        function ChangeHours() {
            if ($("input[name='periodType" + $("#tierCate").val() + "']:checked").val() == 1) { return; }
            var hours = parseFloat($("#annualMinutes").val());
            if ($("#annualHours").val() != "" && parseFloat($("#annualHours").val()) != NaN) {
                hours = parseFloat($("#annualHours").val()) + hours;
            }
            var prdType = $("#period" + $("#tierCate").val()).val();
            if (prdType == 667) {
                hours = toDecimal4(hours / 365);
            } else if (prdType == 668) {
                hours = toDecimal4(hours / 52);
            } else if (prdType == 669) {
                hours = toDecimal4(hours / 26);
            } else if (prdType == 670) {
                hours = toDecimal4(hours / 24);
            } else if (prdType == 671) {
                hours = toDecimal4(hours / 12);
            }
            $("#prdRate").text(hours + "小时"); 
        }
        function editTier(id) {
            if (tierCnt > 0) {
                LayerMsg("关联员工后不能修改休假策略级别");
                return;
            }
            itemId = id;
            requestData("/Tools/TimeoffPolicyAjax.ashx?act=getItemTierInfo&id=" + id, null, function (data) {
                if (data != null) {
                    $("#tierCate").val(data.cate);
                    $("#annualHours").val(parseInt(data.annualHours));
                    $("#annualMinutes").val(parseFloat(data.annualHours) - parseInt(data.annualHours));
                    if (data.capHours != null) {
                        $("#accrualHours").val(parseInt(data.capHours));
                        $("#accrualMinutes").val(parseFloat(data.capHours) - parseInt(data.capHours));
                    } else {
                        $("#accrualHours").val("");
                        $("#accrualMinutes").val("");
                    }
                    $("#minMonths").val(data.eligibleMonths);
                    if ($("input[name='periodType" + data.cate + "']:checked").val() == 1) {
                        $("#prdRateLabel").hide();
                        $("#prdRate").hide();
                    } else {
                        $("#prdRateLabel").show();
                        $("#prdRate").show();
                        $("#prdRate").text(data.hoursPerPeriod + "小时");
                    }
                    $("#background").show();
                    $("#newTier").show();
                }
            })
        }
    </script>
</body>
</html>
