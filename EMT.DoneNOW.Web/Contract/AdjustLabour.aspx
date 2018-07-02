<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdjustLabour.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AdjustLabour" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>工时调整</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <style>
        .bold {
            display: inline-block;
            color: #151515;
            font-size: 14px;
            width: 170px;
            font-weight: 700;
            height: 30px;
            line-height: 30px;
            overflow: hidden;
        }
        .content input{
            margin-left:0px;
        }
        .content select{
            margin-left:0px;
        }
        .content textarea{
            margin-left:0px;
        }
        td{
            padding-left:35px;
            text-align:left;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">工时调整</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 110px;">
            <div class="content clear">
                <% if (deduction != null)
                    {%>
                <span>选择返还还是扣除，可以输入金额或小时。返还的数值不能大于原始值。如果扣除关联到预付时间/预付费用，则预付时间/预付费用调整后的余额不能小于0。</span>
                <div class="information clear">
                    <p class="informationTitle"><i></i>工时条目</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td style="width: 50%;">
                                    <span class="bold">客户</span>
                                    <div>
                                        <span><%=account?.name %></span>
                                    </div>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="bold">员工</span>
                                    <div>
                                        <span><%=resource?.name %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">工作时间</span>
                                    <div>
                                        <span><%=resource?.name %></span>
                                    </div>
                                </td>
                            </tr>
                            <%if (task != null)
                                {%>
                            <tr>
                                <td>
                                    <span class="bold">任务或工单标题</span>
                                    <div>
                                        <span><%=task.title %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">任务或工单编号</span>
                                    <div>
                                        <span><%=task.no %></span>
                                    </div>
                                </td>
                            </tr>
                            <%} %>
                            <tr>
                                <td>
                                    <span class="bold">已计费收入</span>
                                    <div>
                                        <span><%=vItem?.dollars!=null?vItem.dollars.ToString("#0.0000"):"" %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">已计费时间</span>
                                    <div>
                                        <span><%=vItem?.quantity!=null?((int)vItem?.quantity).ToString():"" %></span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="bold">毛利</span>
                                    <div>
                                        <span><%=vItem?.profit!=null?vItem.profit.ToString("#0.0000"):"" %></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">可计费</span>
                                    <div>
                                         <span><%=vItem?.is_billable==1?"计费":(vItem?.is_billable==0?"不计费":"") %></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="information clear">
                    <p class="informationTitle"><i></i>扣除信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <span class="bold">初始计费时间</span>
                                    <div>
                                          <span><%=vItem?.original_extended_price!=null?((decimal)vItem.original_extended_price).ToString("#0.0000"):"" %></span>
                                    </div>

                                </td>
                                <td>
                                    <span class="bold">初始计费金额</span>
                                    <div>
                                         <span><%=vItem?.original_hours_billed!=null?((decimal)vItem.original_hours_billed).ToString("#0.0000"):"" %></span>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <div class="information clear">
                    <p class="informationTitle"><i></i>合同信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                    <span class="bold">合同名称</span>
                                    <div>
                                        <span><%=contract?.name %></span>
                                    </div>

                                </td>
                                <td>
                                    <span class="bold">合同类型</span>
                                    <div>
                                        <span><%=contractType?.name %></span>
                                    </div>
                                </td>
                            </tr>
                                <%if (contract?.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                                { %>
                            <tr>
                                <td>
                                    <span class="bold">预付时间/预付费有效期</span>
                                    <div>
                                        <span>
                                            <% if (dedBlock != null) {%>
                <%=dedBlock.start_date.ToString("yyyy-MM-dd")+" - "+dedBlock.end_date.ToString("yyyy-MM-dd") %>
                                           <%  } %>
                                        </span>
                                    </div>
                                   
                                </td>
                                <td></td>
                            </tr>
                        
                            <tr>
                                <td>
                                     <span class="bold">购买数量</span>
                                    <div>
                                         <span><%=vItem?.contract_total_balance!=null?((decimal)vItem.contract_total_balance).ToString("#0.00"):"" %></span>
                                    </div>
                                </td>
                                <td>
                                     <span class="bold">剩余数量</span>
                                    <div>
                                         <span><%=vItem?.contract_current_balance!=null?((decimal)vItem.contract_current_balance).ToString("#0.00"):"" %></span>
                                    </div>
                                </td>
                            </tr>
                            <%} %>
                        </table>
                    </div>
                </div>

                <div class="information clear">
                    <p class="informationTitle"><i></i>调整信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                     <span class="bold">调整类型</span>
                                    <div>
                                        <select id="adjustType" name="adjustType">
                                            <option value="Add">返还</option>
                                            <option value="Reduce">扣除</option>
                                        </select>
                                    </div>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>
                                      <span class="bold">调整小时数<span style="color: red;">*</span></span>
                                    <div>
                                        <input type="text" class="Todec4" id="AdjustNum" name="AdjustNum" />
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">费率</span>
                                    <div>
                                        <input type="text" class="Todec4" disabled="disabled" value="<%=(rate??0).ToString("#0.0000") %>" />
                                        <input type="hidden"  id="rate" name="rate" value="<%=rate %>"/>

                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="bold">调整金额<span style="color: red;">*</span></span>
                                    <div>
                                        <input type="text" class="Todec4" id="AdjustMoney" name="AdjustMoney" />
                                    </div>
                                </td>
                                <td>
                                    <span class="bold">税<%=$"({(taxRate??0).ToString("#0.0000")})" %></span>
                                    <div>
                                        <input type="text" class="Todec4"  disabled="disabled" value="<%=(taxRate??0).ToString("#0.0000") %>"/>
                                        <input type="hidden" id="taxRate" name="taxRate" value="<%=taxRate %>" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="bold">调整的总金额</span>
                                    <div>
                                        <input type="text" class="Todec4" id="AdjustALLMoney" name="AdjustALLMoney" disabled="disabled" />
                                    </div>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                      <span class="bold">原因<span style="color: red;">*</span></span>
                                    <div>
                                        <textarea style="resize: vertical;" id="reason" name="reason" maxlength="500"></textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%} %>

                <% if (block != null)
                    {%>
                <div class="information clear">
                    <p class="informationTitle"><i></i>合同</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td style="width: 50%;">
                                    <span class="bold">合同</span>
                                    <div>
                                        <span><%=contract?.name %></span>
                                    </div>

                                </td>
                                <td>
                                    <span class="bold">合同类型</span>
                                    <div>
                                        <span><%=contractType?.name %></span>
                                    </div>
                                </td>
                            </tr>

                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle"><i></i>调整</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                            <tr>
                                <td>
                                     <span class="bold">调整类型</span>
                                    <div>
                                        <select id="adjustType" name="adjustType">
                                            <option value="Add">返还</option>
                                            <option value="Reduce">扣除</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                       <span class="bold"><%=contract?.type_id==(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS?"调整小时数":(contract?.type_id==(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER?"调整金额":"") %><span style="color: red;">*</span> </span>
                                    <div>
                                        <input type="text" class="Todec4" id="AdjustNum" name="AdjustNum" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="bold">原因<span style="color: red;">*</span> </span>
                                    <div>
                                        <textarea style="resize: vertical;" id="reason" name="reason"></textarea>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <%} %>
            </div>
        </div>
    </form>
</body>
</html>

<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/index.js"></script>
<script>
    $(".Todec4").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal4(thisValue));
        }
        else {
            $(this).val("");
        }
    })

    $("#save_close").click(function () {

        <%if (block != null)
    {%>
        var AdjustNum = $("#AdjustNum").val();
        if (AdjustNum == "") {
            LayerMsg("请填写调整数量！");
            return false;
        }
        var reason = $("#reason").val();
        if (reason == "") {
            LayerMsg("请填写调整原因！");
            return false;
        }
        <%} %>




        <%if (deduction!=null) {%>
        var AdjustNum = $("#AdjustNum").val();
        if (AdjustNum == "") {
            LayerMsg("请填写调整小时数！");
            return false;
        }
        if (Number(AdjustNum) >= 24 || Number(AdjustNum) <= 0) {
            LayerMsg("调整范围在0-24之间");
            return false;
        }
        var AdjustMoney = $("#AdjustMoney").val();
        if (AdjustMoney == "") {
            LayerMsg("请填写调整金额！");
            return false;
        }
        var reason = $("#reason").val();
        if (reason == "") {
            LayerMsg("请填写调整原因！");
            return false;
        }

        $("#AdjustMoney").prop("disabled", false);
        <%}%>

        return true;
    })

    <%if(deduction!=null){ %>
    $(function () {
        var rate = $("#rate").val();
        if (rate == "" || rate == "0" || Number(rate) == 0) {
            $("#AdjustMoney").prop("disabled", true);
        }
    })
    $("#AdjustNum").blur(function () {
        var AdjustNum = $(this).val();
        if (AdjustNum != "" && (!isNaN(AdjustNum))) {
            if (Number(AdjustNum) >= 24 || Number(AdjustNum) < 0)
            {
                LayerMsg("调整范围在0-24之间");
                $(this).val("0");
                AdjustNum = 0;
            }
            $(this).val(toDecimal4(AdjustNum));
        }
        else {
            $(this).val("0");
            AdjustNum = 0;
        }
        var rate = $("#rate").val();
        if (rate == "") {
            rate = 0;
        }
        var amount = Number(AdjustNum) * Number(rate);
        $("#AdjustMoney").val(toDecimal4(amount));

        var taxRate = $("#taxRate").val();
        if (taxRate == "") {
            taxRate = 0;
        }
        var totalAmount = Number(amount) + Number(amount * (taxRate / 100));

        $("#AdjustALLMoney").val(toDecimal4(totalAmount));
    })


    $("#AdjustMoney").blur(function () {
        var AdjustMoney = $(this).val();
        var rate = $("#rate").val();
        var AdjustNum = AdjustMoney / rate;
        $("#AdjustNum").val(toDecimal4(AdjustNum));
        var taxRate = $("#taxRate").val();
        if (taxRate == "") {
            taxRate = 0;
        }
        var totalAmount = Number(AdjustMoney) + Number(AdjustMoney * (taxRate / 100));
        $("#AdjustALLMoney").val(toDecimal4(totalAmount));
    })
    <%}%>

</script>
