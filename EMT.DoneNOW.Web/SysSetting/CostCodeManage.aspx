<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CostCodeManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.CostCodeManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
      <link href="../Content/index.css" rel="stylesheet" />
  <style>
       input[type="radio"]{
           width:14px;
       }
       .RoleTable input[type="text"]{
           height:20px;
       }
       .content input[type=checkbox]{
           margin-top:0px;
       }
  </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"新增":"编辑" %><%=cateGeneral!=null?cateGeneral.name:"" %></span>
                <a href="###" class="help"></a>
            </div>
        </div>
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
             <% if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY)
                         { %>
         <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="general">常规</li>
                <%if (!isAdd)
                    { %>
                <li id="ruleLi">规则</li>
                <%} %>
            </ul>
        </div>
        <%} %>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 133px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;">名称</span><span style="color: red;">*</span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="name" name="name" style="width: 220px;" maxlength="11" value="<%=code!=null?code.name:"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                   <% if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE)
                                       { %>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">部门</span>
                                        <div>
                                            <select name="department_id" id="department_id" style="width: 232px;">
                                                <option></option>
                                                <%if (depList != null && depList.Count > 0)
    {
        foreach (var cate in depList)
        {%>
                                                <option value="<%=cate.id %>" <%if (code != null && code.department_id == cate.id)
    {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
    } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <%} %>
                                  <% if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE)
                                      { %>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;">成本</span><span style="color: red;"></span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="unit_cost" name="unit_cost" class="ToDec2" style="width: 220px;" maxlength="11" value="<%=code!=null&&code.unit_cost!=null?((decimal)code.unit_cost).ToString("#0.00"):"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;">单价</span><span style="color: red;"></span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="unit_price" name="unit_price" class="ToDec2" style="width: 220px;" maxlength="11" value="<%=code!=null&&code.unit_price!=null?((decimal)code.unit_price).ToString("#0.00"):"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                 <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;">利润率</span><span style="color: red;"></span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="markUp" name="markUp" class="ToDec2" style="width: 220px;" maxlength="11" value="<%=code!=null&&code.unit_price!=null&&code.unit_cost!=null?((decimal)(((code.unit_price??0)-(code.unit_cost??0))/(code.unit_cost==0?1:code.unit_cost))*100).ToString("#0.00"):"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;"></span><span style="color: red;"></span>
                                        <span class="errorSmall"></span>
                                        <div>
                                                   <span style="margin-left:15px;"> 快速新增成本</span>  <input type="checkbox" id="isQuickAddCharge" name="isQuickAddCharge" <%if (isAdd || (code != null && code.is_quick_cost == 1))
    {%> checked="checked"  <%} %> /> 
                                        </div>
                                    </td>
                                </tr>
                                <%} %>
                                 <%if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE )
                                    { %>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left:15px;">
                                        <span>显示代码：</span>
                                        <div>
                                             <span style="margin-left:15px;"> 休假请求</span>  <input type="checkbox" id="isTimeOff" name="isTimeOff" <%if ((code != null && code.is_timeoff == 1))
    {%> checked="checked"  <%} %> />
                                        </div>

                                        <div>
                                             <span style="margin-left:15px;"> 常规 工时/工时表</span>  <input type="checkbox" id="isRegTime" name="isRegTime" <%if ((code != null && code.is_regular_time == 1))
    {%> checked="checked"  <%} %> />
                                        </div>
                                    </td>
                                </tr>

                                  <%} %>
                                <%if (cateId != (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE )
                                    { %>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <div>
                                             <span style="margin-left:15px;"> 激活</span>  <input type="checkbox" id="isActive" name="isActive" <%if (isAdd || (code != null && code.is_active == 1))
    {%> checked="checked"  <%} %> />
                                        </div>
                                    </td>
                                </tr>
                                <%} %>
                            </tbody>
                        </table>
                    </div>
                </div>
                   <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels"><span style="margin-left:15px;"><%=cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY?"编号":"外部代码" %></span>
                                        <span class="errorSmall"></span>
                                        <div>
                                            <input type="text" id="external_id" name="external_id" style="width: 220px;" maxlength="11" value="<%=code!=null?code.external_id:"" %>" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">总账代码</span>
                                        <div>
                                            <select name="general_ledger_id" id="general_ledger_id" style="width: 232px;">
                                                <option></option>
                                                <%if (ledgerList != null && ledgerList.Count > 0)
                                                    {
                                                        foreach (var cate in ledgerList)
                                                        {%>
                                                <option value="<%=cate.id %>" <%if (code != null && code.general_ledger_id == cate.id)
                                                    {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
                                                    } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <%if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE || cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE||cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE||cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MILESTONE_CODE||cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY)
                                    { %>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">税种</span>
                                        <div>
                                            <select name="tax_category_id" id="tax_category_id" style="width: 232px;">
                                                <option></option>
                                                <%if (taxCateList != null && taxCateList.Count > 0)
                                                                                                                       {
                                                                                                                           foreach (var cate in taxCateList)
                                                                                                                           {%>
                                                <option value="<%=cate.id %>" <%if (code != null && code.tax_category_id == cate.id)
                                                                                                                       {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
                                                                                                                       } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <%} %>
          <% if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY)
                         { %>
 <tr>
                                    <td width="30%" class="FieldLabels">
                                        <span style="margin-left:15px;">费用类型</span>
                                        <div>
                                            <select name="expense_type_id" id="expense_type_id" style="width: 232px;">
                                                <option></option>
                                                <%if (expTypeList != null && expTypeList.Count > 0)
                                                                                                                       {
                                                                                                                           foreach (var cate in expTypeList)
                                                                                                                           {%>
                                                <option value="<%=cate.id %>" <%if (code != null && code.expense_type_id == cate.id)
                                                                                                                       {%> selected="selected" <%} %>><%=cate.name %></option>
                                                <% }
                                                                                                                       } %>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <%} %>
                                    <% if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE)
                         { %>
                                <tr>
                                    <td width="30%" class="FieldLabels">
                                        <div>
                                              <span style="margin-left:15px;">包括新合同</span>  <input type="checkbox" id="isIncludeContract" name="isIncludeContract" <%if ((code != null && code.excluded_new_contract == 1))
    {%> checked="checked"  <%} %> />
                                        </div>
                                    </td>
                                </tr>
                                   <%} %>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.GENERAL_ALLOCATION_CODE)
                         { %>
                 <div class="information clear">
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="RoleTable">
                            <tbody>
                                <tr>
                                    <td width="30%" class="FieldLabels" style="padding-left:10px;">帐单费率和小时修改
                                    
                                        <div>
                                            
                                        </div>
                                    </td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdRole" name="RateTypeGroup" value="rdRole"  class="RateTypeGroup" /> <span style="display:block;margin-top:5px;">使用角色费率</span></td>
                                    <td></td>
                                </tr>


                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdAdjust" name="RateTypeGroup" value="rdAdjust" class="RateTypeGroup" /> <span style="display:block;margin-top:5px;">角色费率上下浮动</span></td>
                                    <td><input type="text" id="txtrdAdjust" name="txtAdjust" class="RateTextGroup ToDec2" value="<%=code != null && code.rate_adjustment != null ? ((decimal)code.rate_adjustment).ToString("#0.00") : "" %>"/></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdMulti" name="RateTypeGroup" value="rdMulti" class="RateTypeGroup" /> <span style="display:block;margin-top:5px;">角色费率乘数</span></td>
                                    <td><input type="text" id="txtrdMulti" name="txtMulti"  class="RateTextGroup ToDec2"  value="<%=code != null && code.rate_multiplier != null ? ((decimal)code.rate_multiplier).ToString("#0.00") : "" %>"/></td>
                                </tr>
                                <tr><td colspan="2" style="padding-left:35px;">注意：这个乘数也将用于小时计算</td></tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdUdf" name="RateTypeGroup" value="rdUdf"  class="RateTypeGroup"/> <span style="display:block;margin-top:5px;">自定义费率</span></td>
                                    <td><input type="text" id="txtrdUdf" name="txtUdf" class="RateTextGroup ToDec2" value="<%=code != null && code.custom_rate != null ? ((decimal)code.custom_rate).ToString("#0.00") : "" %>"/></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdFix" name="RateTypeGroup" value="rdFix" class="RateTypeGroup" /> <span style="display:block;margin-top:5px;">固定费率（按次收费）</span></td>
                                    <td><input type="text" id="txtrdFix" name="txtFix" class="RateTextGroup ToDec2" value="<%=code != null && code.flat_rate != null ? ((decimal)code.flat_rate).ToString("#0.00") : "" %>"/></td>
                                </tr>
                                <tr style="height:20px;"><td colspan="2"></td></tr>
                                <tr>
                                    <td style="padding-left:5px;"> <input type="checkbox" id="ckLess" name="ckLess" value="rdLess" /> <span style="display:block;margin-top:0px;">工时不小于</span></td>
                                    <td><input type="text" id="txtLess" name="txtLess" class="ToDec2" disabled="disabled" value="<%=code != null && code.min_hours != null ? ((decimal)code.min_hours).ToString("#0.00") : "" %>"/></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:5px;"> <input type="checkbox" id="ckMore" name="ckMore" value="rdMore" /> <span style="display:block;margin-top:0px;">工时不大于</span></td>
                                    <td><input type="text" id="txtMore" name="txtMore" class="ToDec2"  disabled="disabled" value="<%=code != null && code.max_hours != null ? ((decimal)code.max_hours).ToString("#0.00") : "" %>"/></td>
                                </tr>
                                <tr style="height:20px;"><td colspan="2"></td></tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdNoBillNoShow" name="BillTypeGroup" value="rdNoBillNoShow" /> <span style="display:block;margin-top:5px;">不计费-不在发票上显示</span></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdNoBillShow" name="BillTypeGroup" value="rdNoBillShow" /> <span style="display:block;margin-top:5px;">不计费-在发票上显示”不收费“</span></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left:20px;"> <input type="radio" id="rdBill" name="BillTypeGroup" value="rdBill" checked="checked"/> <span style="display:block;margin-top:5px;">计费</span></td>
                                    <td></td>
                                </tr>

                         
                            </tbody>
                        </table>
                    </div>
                </div>
                <%} %>
            </div>
  <% if (cateId == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.EXPENSE_CATEGORY&&!isAdd)
                         { %>
               <div class="content clear" style="display: none;" id="RuleDiv">
                     <div class="header-title">
                    <input type="hidden" id="codeId" />
                    <input type="hidden" id="codeIdHidden" />
                    <ul>
                        <li onclick="AddCodeRule()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>新增</li>
                    </ul>
                </div>
                <div class="GridContainer">
                    <div style="height: 832px; width: 100%; overflow: auto; z-index: 0;">
                        <table class="dataGridBody" style="width: 100%; border-collapse: collapse;">
                            <tbody>
                                <tr class="dataGridHeader">

                                    <td align="center" style="width: 15%;">规则名称</td>
                                    <td align="center" style="width: 15%;">部门</td>
                                    <td align="center" style="width: 15%;">员工</td>
                                    <td align="center" style="width: 30%;">客户</td>
                                    <td align="center" style="width: 15%;">超支政策</td>
                                    <td align="center" style="width: 10%;">限制</td>
                                </tr>

                                <% if (ruleList != null && ruleList.Count > 0)
                                    {
                                        foreach (var rule in ruleList)
                                        {
                                            var thisDep = depList?.FirstOrDefault(_ => _.id == rule.department_id);
                                            var thisRes = resList?.FirstOrDefault(_ => _.id == rule.resource_id);
                                            var thisPolicy = policyList?.FirstOrDefault(_ => _.id == rule.overdraft_policy_id);
                                %>
                                <tr class="dataGridBody" style="cursor: pointer;" data-val="<%=rule.id %>" onclick="ShowCodeRule('<%=rule.id %>')" >
                                    <td align="center"><%=code!=null?code.name:"" %></td>
                                    <td align="center"><%=thisDep!=null?thisDep.name:"" %></td>
                                    <td align="center"><%=thisRes!=null?thisRes.name:"" %></td>
                                    <td align="center"><%=!string.IsNullOrEmpty(rule.account_ids)?accBll.GetNames(rule.account_ids):"" %></td>
                                    <td align="center"><%=thisPolicy!=null?thisPolicy.name:"" %></td>
                                    <td align="center"><%=rule.max!=null?((decimal)rule.max).ToString("#0.00"):"" %></td>

                                </tr>
                                <% }
                                    } %>
                            </tbody>
                        </table>
                    </div>
                </div>
               </div>
            <%} %>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        <%if (isAdd)
    {%>
        $("#rdRole").trigger("click");
        $("#markUp").prop("disabled", true);
         <%}
    else {
        if (cateId != (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.INTERNAL_ALLOCATION_CODE)
        {

        if (code.billing_method_id == (int)EMT.DoneNOW.DTO.DicEnum.WORKTYPE_BILLING_METHOD.USE_ROLE_RATE) {%>
        $("#rdRole").trigger("click");
        <%}else if (code.billing_method_id == (int)EMT.DoneNOW.DTO.DicEnum.WORKTYPE_BILLING_METHOD.FLOAT_ROLE_RATE) {
            %>
        $("#rdAdjust").trigger("click");
        <%
        } else if (code.billing_method_id == (int)EMT.DoneNOW.DTO.DicEnum.WORKTYPE_BILLING_METHOD.RIDE_ROLE_RATE) {
            %>
        $("#rdMulti").trigger("click");
        <%
        } else if (code.billing_method_id == (int)EMT.DoneNOW.DTO.DicEnum.WORKTYPE_BILLING_METHOD.USE_UDF_ROLE_RATE) {
            %>
        $("#rdUdf").trigger("click");
        <%
        } else if (code.billing_method_id == (int)EMT.DoneNOW.DTO.DicEnum.WORKTYPE_BILLING_METHOD.BY_TIMES) {
            %>
        $("#rdFix").trigger("click");
        <%
        }
        if (code.show_on_invoice == (int)EMT.DoneNOW.DTO.DicEnum.SHOW_ON_INVOICE.NO_SHOW_ONINCOICE) {
            %>
        $("#rdNoBillNoShow").trigger("click");
        <%
        }
        else if (code.show_on_invoice == (int)EMT.DoneNOW.DTO.DicEnum.SHOW_ON_INVOICE.SHOW_DISBILLED) {
            %>
        $("#rdNoBillShow").trigger("click");
        <%
        }
         else if (code.show_on_invoice == (int)EMT.DoneNOW.DTO.DicEnum.SHOW_ON_INVOICE.BILLED) {
            %>
        $("#rdBill").trigger("click");
        <%
        }
        if (code.min_hours != null)
        {%>
        $("#ckLess").trigger("click");
        <%}
        if (code.max_hours != null)
        {%>
        $("#ckMore").trigger("click");
       <% }
        }

    } %>
    })
    $("#ruleLi").click(function () {
        $("#GeneralDiv").hide();
        $("#RuleDiv").show();
        if (!$(this).hasClass("boders")) {
            $(this).addClass("boders");
        }
        $("#general").removeClass("boders");
    })
    $("#general").click(function () {
        $("#GeneralDiv").show();
        $("#RuleDiv").hide();
        if (!$(this).hasClass("boders")) {
            $(this).addClass("boders");
        }
        $("#ruleLi").removeClass("boders");
    })
    $(".RateTypeGroup").click(function () {
        $(".RateTextGroup").prop("disabled", true);
        var thisValue = $(this).val();
        $("#txt" + thisValue).prop("disabled", false);
        if (thisValue != "rdFix") {
            $("#ckLess").prop("disabled", false);
            if ($("#ckLess").is(":checked")) {
                $("#txtLess").prop("disabled", false);
            }
            $("#ckMore").prop("disabled", false);
            if ($("#ckMore").is(":checked")) {
                $("#txtMore").prop("disabled", false);
            }
        }
        else {
            $("#ckLess").prop("disabled", true);
            $("#txtLess").prop("disabled", true);
            $("#ckMore").prop("disabled", true);
            $("#txtMore").prop("disabled", true);
        }
    })
    $("#ckLess").click(function () {
        if ($(this).is(":checked")) {
            $("#txtLess").prop("disabled", false);
        }
        else {
            $("#txtLess").prop("disabled", true);
        }
    })

    $("#ckMore").click(function () {
        if ($(this).is(":checked")) {
            $("#txtMore").prop("disabled", false);
        }
        else {
            $("#txtMore").prop("disabled", true);
        }
    })
    $(".ToDec2").blur(function () {
        var thisValue = $(this).val();
        if (!isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue));
        }
        else {
            $(this).val("");
        }
    })

    $("#markUp").blur(function () {
        var thisValue = $(this).val();
        var unit_cost = $("#unit_cost").val();
        if (!isNaN(unit_cost) && !isNaN(thisValue)) {
            var price = unit_cost * Number(1 + Number(thisValue)/100);
            $("#unit_price").val(toDecimal2(price));
        }
    })

    $("#SaveClose").click(function () {
        var name = $("#name").val();
        if (name == "") {
            LayerMsg("请填写名称");
            return false;
        }
        var isRepeat = "";
        $.ajax({
            type: "GET",
            url: "../Tools/CostCodeAjax.ashx?act=CheckName&name=" + name + "&cateId=<%=cateId.ToString() %>&id=<%=code!=null?code.id.ToString():"" %>",
            async: false,
            dataType: "json",
            success: function (data) {
                if (!data) {
                    isRepeat = '1';
                }
            }
        })
        if (isRepeat == "1") {
            LayerMsg("名称已存在，请更换名称！");
            return false;
        }

        return true;

    })


    function AddCodeRule() {
        <%if (code != null) {%>
        window.open("../SysSetting/CodeRuleManage.aspx?codeId=<%=code.id.ToString() %>", "codeRuleAdd", 'left=0,top=0,location=no,status=no,width=700,height=500', false);
    <%} %>
      
    }
    function ShowCodeRule(id) {
        window.open("../SysSetting/CodeRuleManage.aspx?id=" + id, "codeRuleEdit", 'left=0,top=0,location=no,status=no,width=700,height=500', false);
    }
    
</script>
