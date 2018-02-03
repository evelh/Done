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
                <%if (policyItems.Exists(_ => _.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PERSONAL_TIME)) { %>
                <li>私人时间</li>
                <%} %>
                <%if (policyItems.Exists(_ => _.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.VACATION_TIME)) { %>
                <li>年休假</li>
                <%} %>
                <%if (policyItems.Exists(_ => _.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.SICK_TIME)) { %>
                <li>病假</li>
                <%} %>
                <%if (policyItems.Exists(_ => _.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.TASK_TYPE.PAID_TIME_OFF)) { %>
                <li>浮动假期</li>
                <%} %>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 136px;">
            <div class="content clear" style="width: 100%;">
                <div class="text">定义此休假方案的名称和描述，然后依次到休假类别选项卡设置每种休假类别的概述信息和级别。最后为此休假方案关联员工。请确保每种休假类别里的级别都是正确的。因为一旦关联员工，只能更新假期方案里的概述信息。</div>

                <div class="information clear">
                    <p class="informationTitle">常规信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>名称</label>
                                        <input type="text" name="vendor_invoice_no" <%if (!isAdd)
                                            { %> value="" <%} %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>描述</label>
                                        <input type="text" name="vendor_invoice_no" <%if (!isAdd)
                                            { %> value="" <%} %> />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>激活</label>
                                        <input type="checkbox" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>默认（针对新员工）</label>
                                        <input type="checkbox" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle">关联员工</p>
                    <div class="text">请调整员工的生效开始日期，编辑关联。不能编辑生效截止日期。</div>
                    <div class="text">
                        <input type="button" value="关联员工" id="assRes" />
                    </div>
                    <div>
                        <table border="none" cellspacing="" cellpadding="">
                            <tr>
                                <th>员工</th>
                                <th>生效开始日期</th>
                                <th>生效结束日期</th>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
            <%foreach (var item in policyItems) { %>
            <div class="content clear" style="width: 100%;display:none;">
                <div class="text">设置此休假类别的级别。累计分配的时间将在每个累计增长周期的最后一天获得（累计增长量=年小时数/当年的总累计增长周期数）：统一分配的时间在1月1日获得。如果员工关联的新休假方案在1月1日之后，也不会丢失累计增长或统一分配的时间。</div>

                <div class="information clear">
                    <p class="informationTitle">常规信息</p>
                    <div>
                        <div class="text">如果时间为累计分配，请为此休假方案选择累计增长周期。一旦此假期方案关联了一个或多个员工，关联词休假类别的类型、累计增长周期和级别都不能修改。</div>
                        <table border="none" cellspacing="" cellpadding="" style="width:400px;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label style="font-weight:normal;">分配类型</label>
                                        <input type="radio" value="11" checked="checked" name="periodType<%=item.cate_id %>" style="width:16px;height:16px;" />统一分配
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label></label>
                                        <input type="radio" value="2" name="periodType<%=item.cate_id %>" style="width:16px;height:16px;" />累计分配
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table border="none" cellspacing="" cellpadding="">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label style="font-weight:normal;">增长周期</label>
                                        <select id="period<%=item.cate_id %>" name="period<%=item.cate_id %>" disabled="disabled">
                                            <%foreach (var period in periodList) { %>
                                            <option value="<%=period.val %>" <%if (period.show.Equals("半月")) { %> selected="selected" <%} %> ><%=period.show %></option>
                                            <%} %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle">关联员工</p>
                    <div class="text">请调整员工的生效开始日期，编辑关联。不能编辑生效截止日期。</div>
                    <div class="text">
                        <input type="button" value="新增"  />
                    </div>
                    <div>
                        <table border="none" cellspacing="" cellpadding="">
                            <tr>
                                <th>工作年限（月）</th>
                                <th>每年假期时间（小时）</th>
                                <th>滚存限额（统一分配用）</th>
                            </tr>
                            <tr>
                                <td>满0个月</td>
                                <td>0.0000</td>
                                <td>0.0000</td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>
            <%} %>
            <div class="content clear" style="display: none">
                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                    <tr>
                        <td>
                            <div class="clear">
                                <label>微博地址</label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content clear" style="display: none">
                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                    <tr>
                        <td>
                            <div class="clear">
                                <label>微博地址</label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content clear" style="display: none">
                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                    <tr>
                        <td>
                            <div class="clear">
                                <label>微博地址</label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="content clear" style="display: none">
                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                    <tr>
                        <td>
                            <div class="clear">
                                <label>微博地址</label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
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
            <label style="margin-top: 6px;">员工</label><i class="icon-dh" onclick="OpenWindowCompany()"></i><br />
            <input type="hidden" id="resourceSelectHidden" />
            <textarea style="width: 260px; height: 100px;" readonly="readonly" id="resourceSelect"></textarea>
            <br />
            <label style="margin-top: 6px;">生效日期</label><br />
            <input type="text" class="Wdate" onclick="WdatePicker()" id="effectDate" />
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

        $("#SaveRes").click(function () {
            $("#background").hide();
            $("#memo").hide();
            //requestData("/Tools/PurchaseOrderAjax.ashx?act=setItemMemo&id=" + itemId + "&memo=" + $("#itemMemo").val() + "&date=" + $("#itemArrDate").val(), null, function (data) {
            //})
        })
        $("#CancleMemo").click(function () {
            $("#background").hide();
            $("#memo").hide();
        })

        $("#assRes").click(function () {
            $("#background").show();
            $("#memo").show();
        })
    </script>
</body>
</html>
