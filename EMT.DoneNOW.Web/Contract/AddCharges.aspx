<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCharges.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AddCharges" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"添加":"修改" %>成本</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <style>
        body {
            /* overflow: hidden; */
        }
        /*顶部内容和帮助*/
        .TitleBar {
            color: #fff;
            background-color: #346a95;
            display: block;
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            line-height: 38px;
            margin: 0 0 10px 0;
        }

            .TitleBar > .Title {
                top: 93px;
                height: 36px;
                left: -1px;
                overflow: hidden;
                position: absolute;
                text-overflow: ellipsis;
                text-transform: uppercase;
                white-space: nowrap;
                width: 97%;
            }

        .text2 {
            margin-left: 5px;
        }

        .help {
            background-image: url(../Images/help.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 10px;
            top: 10px;
            width: 16px;
            border-radius: 50%;
        }
        /*保存按钮*/
        .ButtonContainer {
            padding: 0 10px 10px 10px;
            width: auto;
            height: 26px;
        }

            .ButtonContainer ul li .Button {
                margin-right: 5px;
                vertical-align: top;
            }

        li.Button {
            -ms-flex-align: center;
            align-items: center;
            background: #f0f0f0;
            background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
            border: 1px solid #d7d7d7;
            display: -ms-inline-flexbox;
            display: inline-flex;
            color: #4f4f4f;
            cursor: pointer;
            height: 24px;
            padding: 0 3px;
            position: relative;
            text-decoration: none;
        }

        .Button > .Icon {
            display: inline-block;
            flex: 0 0 auto;
            height: 16px;
            margin: 0 3px;
            width: 16px;
        }

        .Save, .SaveAndClone, .SaveAndNew {
            background-image: url("../Images/save.png");
        }

        .Cancel {
            background-image: url("../Images/cancel.png");
        }

        .Button > .Text {
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        /*切换按钮*/
        .TabBar {
            border-bottom: solid 1px #adadad;
            font-size: 0;
            margin: 0 0 10px 0;
            padding: 0 0 0 5px;
        }

            .TabBar a.Button.SelectedState {
                background: #fff;
                border-color: #adadad;
                border-bottom-color: #fff;
                color: black;
            }

            .TabBar a.Button {
                background: #eaeaea;
                border: solid 1px #dfdfdf;
                border-bottom-color: #adadad;
                color: #858585;
                height: 24px;
                padding: 0;
                margin: 0 0 -1px 5px;
                width: 100px;
            }

        a.Button {
            -ms-flex-align: center;
            align-items: center;
            background: #f0f0f0;
            background: -moz-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -webkit-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: -ms-linear-gradient(top,#fbfbfb 0,#f0f0f0 100%);
            background: linear-gradient(to bottom,#fbfbfb 0,#f0f0f0 100%);
            border: 1px solid #d7d7d7;
            display: -ms-inline-flexbox;
            display: inline-flex;
            color: #4f4f4f;
            cursor: pointer;
            height: 24px;
            padding: 0 3px;
            position: relative;
            text-decoration: none;
        }

        .TabBar a.Button span.Text {
            padding: 0 6px 0 6px;
            margin: 0 auto;
        }

        a.Button > .Text {
            -ms-flex: 0 1 auto;
            flex: 0 1 auto;
            font-size: 12px;
            font-weight: bold;
            overflow: hidden;
            padding: 0 3px;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        /*内容*/
        .DivScrollingContainer.General {
            top: 82px;
        }

        .DivScrollingContainer {
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            position: fixed;
            right: 0;
            bottom: 0;
        }

        .DivSectionWithHeader {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 4px 0 4px 0;
        }

            .DivSectionWithHeader .HeaderRow {
                position: relative;
                padding-bottom: 3px;
            }

            .DivSectionWithHeader > .HeaderRow > span {
                display: inline-block;
                vertical-align: middle;
                position: relative;
            }

            .DivSectionWithHeader > .HeaderRow > span {
                padding: 2px 4px 6px 6px;
                color: #666;
                height: 16px;
                font-size: 12px;
                font-weight: bold;
                line-height: 17px;
                text-transform: uppercase;
            }

            .DivSectionWithHeader .Content {
                padding: 0 28px 4px 28px;
            }

        .lblNormalClass {
            font-weight: 700;
            font-size: 12px;
            color: #4F4F4F;
        }

        .errorSmallClass, .errorsmallClass {
            font-size: 12px;
            color: #f00;
            margin-left: 3px;
        }

        .DivSection div, .DivSectionWithHeader .Content div {
            padding-bottom: 17px;
        }

        #nameTextBox {
            margin-right: 2px;
        }

        input[type=text], select, textarea, input[type=password] {
            border: solid 1px #D7D7D7;
            font-size: 12px;
            color: #333;
            margin: 0;
        }

        input[type=text], input[type=password] {
            height: 24px;
            padding: 0 6px;
        }

        .txtBlack8Class {
            font-size: 12px;
            color: #333;
            font-weight: normal;
        }

        .FieldLabel, .workspace .FieldLabel, TABLE.FieldLabel TD, span.fieldlabel span label {
            font-size: 12px;
            color: #4F4F4F;
        }

        input[type=checkbox] {
            margin: 0 3px 0 0;
            padding-top: 1px;
        }

        select {
            height: 26px;
            padding: 0;
        }

        input[type=radio] {
            margin-right: 3px;
            vertical-align: middle;
            margin-top: 0;
        }

        .BillableRadioList table {
            border-spacing: 0px;
        }

        .BillableRadioList tr {
            height: 28px;
        }

        .BillableRadioList td {
            padding: 0px;
        }

        .Editor .CustomHtml {
            line-height: 17px;
            vertical-align: top;
        }

        .Editor .CustomHtml {
            color: #666;
            display: inline-block;
            padding-left: 4px;
        }

        .Section > .Content .Editor .CustomHtml a.Button.Link {
            display: inline;
            margin: 0;
            vertical-align: middle;
        }

        a.Button.Link {
            background: none;
            border: none;
            color: #376597;
            font-size: 12px;
            height: auto;
            padding: 0;
            vertical-align: inherit;
        }

        .eee {
            width: 114px;
            display: inline-block;
            float: left;
        }
        #isbillable{
            vertical-align: middle;
        }
        #AddConfigItem{
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1"><%=isAdd?"添加":"修改" %>成本</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                    <span class="Icon SaveAndClone"></span>
                    <span class="Text">
                        <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click"/></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                    <span class="Icon Save"></span>
                    <span class="Text">
                        <asp:Button ID="save" runat="server" Text="保存" OnClick="save_Click" BorderStyle="None"  /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                    <span class="Icon SaveAndNew"></span>
                    <span class="Text">
                        <asp:Button ID="save_add" runat="server" Text="保存并新建" OnClick="save_add_Click" BorderStyle="None"  /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <!--内容-->
        <div class="DivScrollingContainer General">
            <div class="DivSectionWithHeader">
                <div class="Content">
                    <table style="width: 825px; border-collapse: collapse;" cellspacing="0" cellpadding="0" border="0">
                        <tbody>
                            <tr>
                                <td colspan="2" style="color: red;">
                                    <div id="ShowMessage" style="display: none;">
                                        This contract charge is associated with a recurring purchase. You can only edit some of the fields on this page. If you need to edit Quantity, Unit Price, or Date Purchased, you will need to edit the associated recurring purchase.
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 50%">
                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                        <tbody>
                                            <tr>
                                                <td align="left">
                                                    <span class="FieldLabel" style="font-weight: bold;">产品</span>
                                                    <div>
                                                        <%
                                                            EMT.DoneNOW.Core.ivt_product product = null;
                                                            if ((!isAdd) && conCost.product_id != null)
                                                            {
                                                                product = new EMT.DoneNOW.DAL.ivt_product_dal().FindNoDeleteById((long)conCost.product_id);
                                                            }
                                                        %>
                                                        <input type="text" id="product_id" style="width: 294px;" value="<%=product!=null?product.product_name:"" %>" />
                                                        <input type="hidden" name="product_id" id="product_idHidden" value="<%=product!=null?product.id.ToString():"" %>" />
                                                        <img src="../Images/data-selector.png" style="vertical-align: middle;" id="ChoosethisProduct" onclick="ChooseProduct()" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left">
                                                    <span class="FieldLabel" style="font-weight: bold;">物料代码
                                        <span class="errorSmallClass">*</span>
                                                    </span>
                                                    <div>
                                                        <%
                                                            EMT.DoneNOW.Core.d_cost_code costCode = null;
                                                            if (!isAdd)
                                                            {
                                                                costCode = new EMT.DoneNOW.DAL.d_cost_code_dal().FindNoDeleteById(conCost.cost_code_id);
                                                            }
                                                            %>
                                                        <input type="text" name="costName" id="costId" style="width: 294px;" value="<%=costCode!=null?costCode.name:"" %>">
                                                       
                                                        <input type="hidden" name="cost_code_id" id="costIdHidden" value="<%=costCode!=null?costCode.id.ToString():"" %>"/>
                                                        <img src="../Images/data-selector.png" style="vertical-align: middle;" id="ChoosethisCostCode" onclick="ChooseCostCode()">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left">
                                                    <span class="FieldLabel" style="font-weight: bold;">成本名称
                                        <span class="errorSmallClass">*</span>
                                                    </span>
                                                    <div>
                                                        <input type="text" name="name" id="name" style="width: 294px;" value="<%=isAdd?"":conCost.name %>" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left">
                                                    <span class="FieldLabel" style="font-weight: bold;">描述
                                                    </span>
                                                    <div>
                                                        <textarea name="description" id="description" style="height: 70px; width: 306px; max-width: 306px; margin-top: 0px; margin-bottom: 0px;"><%=isAdd?"":conCost.description %></textarea>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                                <td align="right" style="vertical-align: top;">
                                    <div class="DivSectionWithHeader" style="padding: 12px; background-color: #F0F5FB; margin-right: 0px;">
                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td style="padding-bottom: 11px;">
                                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="left" colspan="2">
                                                                        <span class="FieldLabel" style="font-weight: bold;">数量<span class="errorSmallClass">*</span>
                                                                        </span>
                                                                    </td>
                                                                    <td align="left" colspan="2">
                                                                        <span class="FieldLabel" style="font-weight: bold;">单元成本
                                                                        </span>
                                                                    </td>
                                                                    <td align="left">
                                                                        <span class="FieldLabel" style="font-weight: bold;">总成本
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 65px; text-align: right;" name="quantity" id="quantity" value="<%=conCost!=null&&conCost.quantity!=null?((decimal)conCost.quantity).ToString("#0.0000"):"1.0000" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                        </span>
                                                                    </td>
                                                                    <td align="center" style="width: 20px;">
                                                                        <span class="FieldLabel" style="font-weight: bold;">x</span>
                                                                    </td>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 160px; text-align: right;" name="unit_cost" id="unit_cost" value="<%=conCost!=null&&conCost.unit_cost!=null?((decimal)conCost.unit_cost).ToString("#0.0000"):"0.0000" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                        </span>
                                                                    </td>
                                                                    <td align="center" style="width: 20px;">
                                                                        <span class="FieldLabel" style="font-weight: bold;">=</span>
                                                                    </td>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 160px; text-align: right;" id="extendedCost" value=""  />
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 11px;">
                                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                            <tbody>
                                                                <tr>
                                                                    <td align="left" colspan="2">
                                                                        <span class="FieldLabel" style="font-weight: bold;">数量</span>
                                                                    </td>
                                                                    <td align="left" colspan="2">
                                                                        <span class="FieldLabel" style="font-weight: bold;">单价
                                                                        </span>
                                                                    </td>
                                                                    <td align="left">
                                                                        <span class="FieldLabel" style="font-weight: bold;">计费总额<span class="errorSmallClass">*</span>
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 65px; text-align: right;" name="pricequantity" id="pricequantity" value="<%=conCost!=null&&conCost.quantity!=null?((decimal)conCost.quantity).ToString("#0.0000"):"1.0000" %>" disabled>
                                                                        </span>
                                                                    </td>
                                                                    <td align="center" style="width: 20px;">
                                                                        <span class="FieldLabel" style="font-weight: bold;">x</span>
                                                                    </td>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 160px; text-align: right;" name="unit_price" id="unit_price" value="<%=conCost!=null&&conCost.unit_price!=null?((decimal)conCost.unit_price).ToString("#0.0000"):"0.0000" %>"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                        </span>
                                                                    </td>
                                                                    <td align="center" style="width: 20px;">
                                                                        <span class="FieldLabel" style="font-weight: bold;">=</span>
                                                                    </td>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 160px; text-align: right;" id="billableAmount" value="" />
                                                                        </span>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="width: 100%;">
                                    <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; border-collapse: collapse;">
                                        <tbody>
                                            <tr>
                                                <td style="width: 180px;">
                                                    <span class="FieldLabel" style="font-weight: bold;">购买日期<span class="errorSmallClass">*</span>
                                                    </span>
                                                    <div>
                                                        <input type="text" onclick="WdatePicker()" class="Wdate" name="date_purchased" id="date_purchased" style="width: 100px;" value="<%=isAdd?DateTime.Now.ToString("yyyy-MM-dd"):conCost.date_purchased.ToString("yyyy-MM-dd") %>" />
                                                    </div>
                                                </td>
                                                <td style="padding-top: 16px;">
                                                    <div>
                                                        <asp:CheckBox ID="isbillable" runat="server" />
                                                        <span class="txtBlack8Class">计费的</span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="FieldLabel" style="font-weight: bold;">服务/包
                                                    </span>
                                                    <div>
                                                        <select style="width: 150px;" name="service_id" id="service_id">
                                                         
                                                        </select>
                                                    </div>
                                                </td>
                                                <td style="padding-top: 16px;">
                                                    <div>
                                                        <asp:CheckBox ID="AddConfigItem" runat="server" />
                                                        <span class="txtBlack8Class">创建配置项</span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="FieldLabel" style="font-weight: bold;">成本类型
                                                    </span>
                                                    <div>
                                                        <asp:DropDownList ID="cost_type_id" runat="server" Width="150px"></asp:DropDownList>
                                                       
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="FieldLabel" style="font-weight: bold;">采购订单号 
                                                    </span>
                                                    <div>
                                                        <input type="text" style="width: 136px;" name="purchase_order_no" id="purchase_order_no" value="<%=isAdd?"":conCost.purchase_order_no %>" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="FieldLabel" style="font-weight: bold;">内部订单号码  
                                                    </span>
                                                    <div>
                                                        <input type="text" style="width: 136px;" name="internal_po_no" id="internal_po_no" value="<%=isAdd?"":conCost.internal_po_no
 %>" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="FieldLabel" style="font-weight: bold;">内部发票号码  
                                                    </span>
                                                    <div>
                                                        <input type="text" style="width: 136px;" name="invoice_no" id="invoice_no" value="<%=isAdd?"":conCost.invoice_no %>" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="FieldLabel" style="font-weight: bold;">状态
                                                    </span>
                                                    <div>
                                                        <asp:DropDownList ID="status_id" runat="server" Width="150px"></asp:DropDownList>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $("#SaveAndCloneButton").on("mouseover", function () {
        $("#SaveAndCloneButton").css("background", "#fff");
    });
    $("#SaveAndCloneButton").on("mouseout", function () {
        $("#SaveAndCloneButton").css("background", "#f0f0f0");
    });
    $("#SaveAndNewButton").on("mouseover", function () {
        $("#SaveAndNewButton").css("background", "#fff");
    });
    $("#SaveAndNewButton").on("mouseout", function () {
        $("#SaveAndNewButton").css("background", "#f0f0f0");
    });
    $("#CancelButton").on("mouseover", function () {
        $("#CancelButton").css("background", "#fff");
    });
    $("#CancelButton").on("mouseout", function () {
        $("#CancelButton").css("background", "#f0f0f0");
    });
    $("input[name='BillingMethod']").on("click", function () {
        $(this).parent().parent().parent().parent().siblings().find("input[type='text']").attr("disabled", true);
        $(this).parent().parent().parent().next().find("input[type='text']").attr("disabled", false);
    });
    $("input[name='neverBillLessThanCheckBox:ATCheckBox']").on("click", function () {
        if ($(this).is(':checked')) {
            $(this).parent().parent().parent().next().find("input[type='text']").attr("disabled", false);
        } else {
            $(this).parent().parent().parent().next().find("input[type='text']").attr("disabled", true);
        }
    });

    $.each($(".TabBar a"), function (i) {
        $(this).click(function () {
            $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
        })
    });
</script>
<script>
    $(function () {
        debugger;
        GetSumCost();
        GetSumAmount();
        
         <%if ((!isAdd) && conCost.create_ci == 1)
        { %>
        $("#AddConfigItem").prop("disabled", true);
        <%}%>

        <%if ((!isAdd) && (conCost.status_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.IN_PURCHASING ||conCost.status_id==(int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.PENDING_DELIVERY||conCost.status_id==(int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.ALREADY_DELIVERED))
        {%>

        $("#ChoosethisProduct").removeAttr("onclick");
        $("#product_id").prop("disabled", true);
        <%}%>

        <%if (!isAdd)
    { %>
        var costCodeId = <%=conCost.cost_code_id %>;  // 根据数据类型禁用页面上的部分控件
        if (costCodeId != undefined && costCodeId != "") {
            var cate_Id = "";
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=costCode&cost_code_id=" + costCodeId,
                success: function (data) {
                    if (data != "") {
                        cate_Id = data.cate_Id;
                    }
                },
            });
            if (cate_Id ==<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.BLOCK_PURCHASE %>||cate_Id ==<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RETAINER_PURCHASE %>||cate_Id ==<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.TICKET_PURCHASE %>)
            {
                $("#ChoosethisProduct").removeAttr("onclick");
                $("#product_id").prop("disabled", true);
                $("#ChoosethisCostCode").removeAttr("onclick");
                $("#costId").prop("disabled", true);
            }
        }
     
        <%}%>
        <%if ((!isAdd)&&conCost.bill_status!=null&&conCost.bill_status==1) { %>
        // 禁用全部控件，只可以修改状态，可以勾选创建配置项
        $("input").each(function () {
            $(this).prop("disabled", true);
            //$(this).removeAttr("onclick");
        })
        $("select").each(function () {
            $(this).prop("disabled", true);
        })
        $("#ChoosethisProduct").removeAttr("onclick");
        $("#ChoosethisCostCode").removeAttr("onclick");

        $("#status_id").removeAttr("disabled");
        $("#AddConfigItem").prop("disabled", false);
        <%}%>
    })

    $("#CancelButton").click(function () {
        window.close();
    })

    $("#quantity").blur(function () {
        var quantity = $(this).val();
        if (quantity != "" && (!isNaN(quantity))) {
            quantity = toDecimal4(quantity);
            $(this).val(quantity);
            GetSumCost();
            $("#pricequantity").val(quantity);
            GetSumAmount();
        }
        else {
            $(this).val("1.0000");
        }
    })

    $("#unit_cost").blur(function () {
        var unit_cost = $(this).val();
        if (unit_cost != "" && (!isNaN(unit_cost))) {
            unit_cost = toDecimal4(unit_cost);
            $(this).val(unit_cost);
          
        }
        else {
            $(this).val("0.0000");
        }
        GetSumCost();
    })


    $("#unit_price").blur(function () {
        var unit_price = $(this).val();
        if (unit_price != "" && (!isNaN(unit_price))) {
            unit_price = toDecimal4(unit_price);
            $(this).val(unit_price);
         
        }
        else {
            $(this).val("0.0000");
        }
        GetSumAmount();
    })

    $("#extendedCost").blur(function () {
        var extendedCost = $(this).val();
        if (extendedCost != "" && (!isNaN(extendedCost))) {
            extendedCost = toDecimal2(extendedCost);
            $(this).val(extendedCost);
            var quantity = $("#quantity").val();
            if (quantity != "" && quantity != "0.0000") {
                var cost = Number(extendedCost) / Number(quantity);
                cost = toDecimal4(cost);
                $("#unit_cost").val(cost);
            }
            else {
                $("#unit_cost").val("0.0000");
            }
        }
        else {
            $(this).val("0.0000");
        }
    })

    $("#billableAmount").blur(function () {
        var billableAmount = $(this).val();
        if (billableAmount != "" && (!isNaN(billableAmount))) {
            billableAmount = toDecimal2(billableAmount);
            $(this).val(billableAmount);
            var quantity = $("#quantity").val();
            if (quantity != "" && quantity != "0.0000") {
                var price = Number(billableAmount) / Number(quantity);
                price = toDecimal4(price);
                $("#unit_price").val(price);
            }
            else {
                $("#unit_price").val("0.0000");
            }
        }
        else {
            $(this).val("0.0000");
        }
    })

    $("#save").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    });
    $("#save_close_Click").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    });
    $("#save_add").click(function () {
        if (!SubmitCheck()) {
            return false;
        }
        return true;
    });



    function toDecimal4(x) {
        var f = parseFloat(x);
        if (isNaN(f)) {
            return "";
        }
        var f = Math.round(x * 10000) / 10000;
        var s = f.toString();
        var rs = s.indexOf('.');
        if (rs < 0) {
            rs = s.length;
            s += '.';
        }
        while (s.length <= rs + 4) {
            s += '0';
        }
        return s;
    }
    //  Math.round(12.5)
    function GetSumCost() {
        var quantity = $("#quantity").val();
        var unit_cost = $("#unit_cost").val();
        if (quantity != "" && (!isNaN(quantity)) && unit_cost != "" && (!isNaN(unit_cost))) {
            var sum = quantity * unit_cost;
            $("#extendedCost").val(toDecimal2(sum));
        }
    }
    function GetSumAmount() {
        var quantity = $("#pricequantity").val();
        var unit_price = $("#unit_price").val();
        if (quantity != "" && (!isNaN(quantity)) && unit_price != "" && (!isNaN(unit_price))) {
            var sum = quantity * unit_price;
            $("#billableAmount").val(toDecimal2(sum));
        }
    }


    function ChooseProduct() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=product_id&callBack=GetDataByProduct", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByProduct() {
        //product_idHidden
        var product_id = $("#product_idHidden").val();
        if (product_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=product&product_id=" + product_id,
                success: function (data) {
                    if (data != "") {
                        $("#costIdHidden").val(data.cost_code_id);
                        if (data.unit_price != undefined && data.unit_price != "") {
                            $("#unit_price").val(toDecimal4(data.unit_price));
                        }
                        if (data.unit_cost != undefined && data.unit_cost != "") {
                            $("#unit_cost").val(toDecimal4(data.unit_cost));
                        }
                        $("#name").val(data.product_name);
                        GetSumCost();
                        GetSumAmount();
                        $("#status_id").val(<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.PENDING_PURCHASE %>);
                    }
                },
            });

            var costId = $("#costIdHidden").val();
            if (costId != "") {
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/ProductAjax.ashx?act=costCode&cost_code_id=" + costId,
                    success: function (data) {
                        if (data != "") {
                            $("#costId").val(data.name);
                        }
                    },
                });
            }
        }
    }
    // costIdHidden  costId

    function ChooseCostCode() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=costId&callBack=GetDataByCostCode", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByCostCode() {
        var costId = $("#costIdHidden").val();
        var product_id = $("#product_idHidden").val(); 
        if (costId != "" && product_id == "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=costCode&cost_code_id=" + costId,
                success: function (data) {
                    if (data != "") {
                        debugger;
                        
                        if (data.unit_price != undefined && data.unit_price != "") {
                            $("#unit_price").val(toDecimal4(data.unit_price));
                        }
                        if (data.unit_cost != undefined && data.unit_cost != "") {
                            $("#unit_cost").val(toDecimal4(data.unit_cost));
                        }
                        GetSumCost();
                        GetSumAmount();
                    }
                },
            });
        }
    }


    function SubmitCheck() {
        var costId = $("#costIdHidden").val();
        if (costId == "") {
            alert("请通过查找带回选择物料代码！");
            return false;
        }
        var name = $("#name").val();
        if (name == "") {
            alert("请填写成本名称！");
            return false;
        }
        var date_purchased = $("#date_purchased").val();
        if (date_purchased == "") {
            alert("请填写购买日期！");
            return false;
        }
        var status_id = $("#status_id").val();
        if (status_id == "") {
            alert("请选择状态！");
            return false;
        }
        // unit_cost
        var quantity = $("#quantity").val();
        if (quantity == "") {
            alert("请填写数量！");
            return false;
        }
        var unit_cost = $("#unit_cost").val();
        if (unit_cost == "") {
            alert("请填写单元成本！");
            return false;
        }
        //unit_price
        var pricequantity = $("#pricequantity").val();
        if (pricequantity == "") {
            alert("数量不能为空！");
            return false;
        }
        var unit_price = $("#unit_price").val();
        if (unit_price == "") {
            alert("请填写单价！");
            return false;
        }

        return true;
    }
</script>
