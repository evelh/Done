<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteItemAddAndUpdate.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteItem.QuoteItemAddAndUpdate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"添加报价项":"修改报价项" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
       
        body {
            overflow: hidden;
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
                top: 0;
                height: 36px;
                left: 10px;
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
            background-image: url(../img/help.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 10px;
            top: 10px;
            width: 16px;
            border-radius: 50%;
        }

        .ButtonBar {
            font-size: 12px;
            padding: 0 10px 10px 10px;
            width: auto;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
                overflow: hidden;
            }

        .LiButton {
            float: left;
            background: #d7d7d7;
            background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
            background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
            border: 1px solid #bcbcbc;
            display: inline-block;
            color: #4F4F4F;
            cursor: pointer;
            padding: 0 5px 0 3px;
            position: relative;
            text-decoration: none;
            vertical-align: middle;
            height: 24px;
            margin-right: 5px;
        }

        .ButtonImg {
            margin: 4px 3px 0 3px;
        }

        .Text {
            font-size: 12px;
            font-weight: bold;
            line-height: 26px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        .DivSection {
            width: 84%;
            margin: 0 10px 10px 10px;
            padding: 12px 2px 4px 28px;
        }

        .DivSection1 {
            width: 100%;
            margin: 0 10px 10px 10px;
            padding: 12px 2px 4px 28px;
        }

        .DivSection > table {
            border: 0;
            margin: 0;
            border-collapse: collapse;
            padding-top: 5px;
            border-spacing: 0;
        }

        .DivSection td {
            padding: 0;
            text-align: left;
        }

        .FieldLabels {
            vertical-align: top;
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

        #errorSmall {
            font-size: 12px; 
            color: #E51937;
            margin-left: 3px;
            text-align: center;
        }

        .FieldLabels i {
            vertical-align: middle;
            cursor: pointer;
        }

        .FieldLabels div {
            margin-top: 1px;
            padding-bottom: 21px;
            font-weight: 100;
        }

        .DivSectionWithColor {
            background-color: #F0F5FB;
            padding-bottom: 12px;
            border: 1px solid #d3d3d3;
            margin: 0px 10px 10px 4px;
        }

        input[type=text], select, textarea {
            border: solid 1px #D7D7D7;
            font-size: 12px;
            color: #333;
            margin: 0;
        }

        blockquote, body, button, dd, dl, dt, fieldset, form, h1, h2, h3, h4, h5, h6, hr, input, legend, li, ol, p, pre, td, textarea, th, ul {
            padding: 0;
            margin-left: 0;
            margin-right: 0;
            margin-top: 0;
        }

        body, button, input, select, textarea {
            font: 12px/1.5 tahoma,arial,'Hiragansino S GB',\5b8b\4f53,sans-serif
        }

        h1, h2, h3, h4, h5, h6 {
            font-size: 100%
        }

        address, cite, dfn, em, var {
            font-style: normal
        }

        code, kbd, pre, samp {
            font-family: courier new,courier,monospace
        }

        small {
            font-size: 12px
        }

        ol, ul {
            list-style: none
        }

        a {
            text-decoration: none
        }

            a:hover {
                text-decoration: underline
            }

        sup {
            vertical-align: text-top
        }

        sub {
            vertical-align: text-bottom
        }

        legend {
            color: #000
        }

        fieldset, img {
            border: 0
        }

        button, input, select, textarea {
            font-size: 100%
        }

        table {
            border-collapse: collapse;
            border-spacing: 0
        }

        select {
            width: 150px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"添加报价项":"修改报价项" %>-<%=type %></div>
        <input type="hidden" id="ItemTypeId" value="" runat="server"/>
        <%--<input type="hidden" name="object_id" id="object_id"/>--%>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_new" runat="server" Text="保存并新增" BorderStyle="None" OnClick="save_new_Click" />
                </li>

                <li id="close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    关闭</li>
            </ul>
        </div>

        <div class="NewContain">
            <div class="DivSection">
                <input type="hidden" name="thisQuoteId" id="thisQuoteId" value="" runat="server"/>
                <table width="100%" border="0" callpadding="2" callspacing="0">
                    <tbody>
                        <tr>
                            <td class="NewLeft">
                                <table width="100%" border="0" callpadding="3" callspacing="0">
                                    <tbody>
                                        <tr class="serviceTr" style="display:none;">
                                            <td><input type="radio" name="11" id="service" checked="checked" />服务/服务集</td>
                                           
                                        </tr>
                                        <tr class="serviceTr" style="display:none;">
                                             <td><input type="radio" name="11" id="startCost" />合同初始费用</td></tr>
                                        <tr>
                                            <td class="FieldLabels">报价项名称
                                            <span id="errorSmall">*</span>
                                                <div>
                                                    <input type="text" name="name" id="name" value="<%=isAdd?"":quote_item.name %>" style="width: 17em;"/>
                                                    <i id="callBackChooseRole" onclick="chooseRole()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                    
                                                    <i id="callBackChooseProduct" onclick="chooseProduct()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                    <i id="callBackManyProduct" onclick="chooseManyProduct()" style="width: 20px; height: 20px; margin-left: 0px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -129px 0;display:none;">&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                    <i id="AddProduct" onclick="" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px;padding:1px; background: url(../Images/add.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                    <i id="callBackService" onclick="chooseService()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px;padding:1px; background: url(../Images/ServiceSelector.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                    <i id="callBackServiceBundle" onclick="chooseServiceBundle()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px;padding:1px; background: url(../Images/data-selector.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp</i>
                                                    <i id="callbackCost" onclick="chooseDegression()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px;padding:1px; background: url(../Images/data-selector.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                       <i id="callBackCharge" onclick="chooseCharge()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px;padding:1px; background: url(../Images/data-selector.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                       <i id="callBackShip" onclick="chooseShip()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px;padding:1px; background: url(../Images/data-selector.png) no-repeat;display:none;">&nbsp;&nbsp;&nbsp;&nbsp</i>
                                                    <input type="hidden" id="nameHidden" name="object_id" value="<%=quote_item==null?"":quote_item.object_id.ToString() %>"/>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">报价项描述
                                            <div>
                                                <textarea name="description" id="description" style="width: 17em;" rows="5"><%=(!isAdd)&&(!string.IsNullOrEmpty(quote_item.description))?quote_item.description:"" %></textarea>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr valign="middle" id="periodTypeTr">
                                            <td class="FieldLabels">期间类型
                                            <div>
                                                <asp:DropDownList ID="period_type_id" runat="server" style="width: 17em;"></asp:DropDownList>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr id="ByProjectTr" style="display:none;">
                                            <td class="FieldLabels">
                                                <input type="checkbox" name="ByProject" id="ByProject" />
                                                <span class="CheckBoxLabels">项目提案工时</span>
                                                <div>
                                                    <% EMT.DoneNOW.Core.pro_project project = null;
                                                        EMT.DoneNOW.Core.crm_quote thisQuote = null;
                                                        if (!string.IsNullOrEmpty(Request.QueryString["quote_id"]))
                                                        {
                                                            thisQuote = new EMT.DoneNOW.DAL.crm_quote_dal().FindNoDeleteById(long.Parse(Request.QueryString["quote_id"]));
                                                        }
                                                        else
                                                        {
                                                            if (quote_item != null&&quote_item.quote_id!=null)
                                                            {
                                                                   thisQuote = new EMT.DoneNOW.DAL.crm_quote_dal().FindNoDeleteById((long)quote_item.quote_id);
                                                            }
                                                        }

                                                        if (thisQuote != null && thisQuote.project_id != null)
                                                        {
                                                            project = new EMT.DoneNOW.DAL.pro_project_dal().FindNoDeleteById((long)thisQuote.project_id);
                                                        }
                                                        %>
                                                    <input type="text" name="" id="project_id" style="width: 17em;" value="<%=project==null?"":project.name %>"/>
                                                    <input type="hidden" name="project_id" id="project_idHidden" value="<%=project==null?"":project.id.ToString() %>"/>
                                                    <i onclick="ViewProject()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="taxCateTr">
                                            <td class="FieldLabels">税收种类
                                            <div>
                                                <asp:DropDownList ID="tax_cate_id" runat="server" style="width: 17em;"></asp:DropDownList>
                                            </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td class="NewRight">
                                <div class="DivSection1 DivSectionWithColor">
                                    <table width="100%" border="0" callpadding="0" callspacing="0">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabels">
                                                    <table width="100%" border="0" callpadding="2" callspacing="0">
                                                        <tbody>
                                                            <tr id="unitPriceTr">
                                                                <td class="FieldLabels" style="padding-top: 6px;">单价</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="unit_price" id="unit_price" value="<%=(!isAdd)&&(quote_item.unit_price!=null)?quote_item.unit_price.ToString():"" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="taxPriceTr" style="display:none;">
                                                                <td class="FieldLabels" style="padding-top: 6px;">单价（包含税）</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="" id="tax_unit_price" value="" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="gross_profit_marginTR">
                                                                <td class="FieldLabels" style="padding-top: 6px;">毛利率</td>
                                                                <td class="FieldLabels">
                                                                    <div>
                                                                        <input type="text" disabled style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="gross_profit_margin" id="gross_profit_margin" />&nbsp;%
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="unitCostTR">
                                                                <td class="FieldLabels" style="padding-top: 6px;">单元成本</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="unit_cost" id="unit_cost" value="<%=(!isAdd)&&(quote_item.unit_cost!=null)?quote_item.unit_cost.ToString():"" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="quantityTR">
                                                                <td class="FieldLabels" style="padding-top: 6px;">数量</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="quantity" id="quantity" value="<%=(!isAdd)&&(quote_item.quantity!=null)?quote_item.quantity.ToString():isAdd?"1.00":"" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="TotalPriceTR">
                                                                <td class="FieldLabels" style="padding-top: 6px;">总价</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" value="0.00" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="TotalPrice" id="TotalPrice" disabled="disabled" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="Gross_Profit_TR">
                                                                <td class="FieldLabels" style="padding-top: 6px;">毛利润</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" value="0.00" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="Gross_Profit" id="Gross_Profit" disabled="disabled" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="MSRP_tr" style="display:none;">
                                                                  <td class="FieldLabels" style="padding-top: 6px;">厂商建议零售价</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" value="0.00" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="MSRP" id="MSRP" disabled="disabled" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                                <td align="left" valign="top">
                                                    <table width="100%" border="0" callpadding="0" callspacing="0" style="margin-left: 28px;">
                                                        <tbody>
                                                            <tr>
                                                                <td class="FieldLabels" width="45%" style="padding-top: 6px;">
                                                                    <input type="radio" name="00" id="DiscountR1" checked="checked" />单元折扣 
                                                                </td>
                                                                <td class="FieldLabels" align="right">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="unit_discount" id="unit_discount" value="<%=(!isAdd)&&(quote_item.unit_discount!=null)?quote_item.unit_discount.ToString():"0.00" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr id="LineDiscountTR">
                                                                <td class="FieldLabels" width="45%" style="padding-top: 6px;">
                                                                    <input type="radio" name="00" id="DiscountR3"  />折扣数 
                                                                </td>
                                                                <td class="FieldLabels" align="right">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="Line_Discount" id="Line_Discount" disabled="disabled" class="Calculation" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" width="45%" style="padding-top: 6px;">
                                                                    <input type="radio" name="00" id="DiscountR2">折扣率
                                                                </td>
                                                                <td class="FieldLabels" align="right">
                                                                    <div style="margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="discount_percent" id="Discount" disabled="disabled" class="Calculation" maxlength="5" value="<%=quote_item!=null&&quote_item.discount_percent!=null?(quote_item.discount_percent*100).ToString():"" %>" />&nbsp;<span id="ShowBai">%</span> 
                                                                    </div> 
                                                                </td>
                                                            </tr>
                                                            <tr id="OptionTR">
                                                                <td class="FieldLabels" style="padding-top: 6px">
                                                                    <asp:CheckBox ID="_optional" runat="server" />可选的
                                                                <%--    <%if (!isAdd && quote_item.optional == 1)
                                                                        { %>
                                                                    <input type="checkbox" name="optional" data-val="1" value="1" checked="checked"/>可选的
                                                                    <%}
                                                                    else
                                                                    { %>
                                                                    <input type="checkbox" name="optional" data-val="1" value="1" />可选的
                                                                    <%} %>--%>
                                                                </td>
                                                                <td align="right">&nbsp;</td>
                                                            </tr>
                                                            <tr style="display:none;" id="productShow">
                                                                <td>
                                                                    <div style="margin-top: 108px;width: 120px;">平均值<span id="avgCost"></span>|最高值<span id="highCost"></span></div>
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
                    </tbody>
                </table>
                    <div style="display:none;" id="productListTable">
                        <table class="table table-bordered">
                            <tr style="background-color:#cbd9e4">
                                <th>库存位置</th>
                                <th>库存数</th>
                                <th>采购中</th>
                                <th>尚未接收</th>
                                <th>预留和拣货</th>
                                <th>可用数</th>
                                <th>为此报价预留</th>
                            </tr>
                            <tbody id="wareTbody">

                            </tbody>
                            
                        </table>
                    </div>
            </div>
        </div>
        <input type="hidden" id="wareIds" name="wareIds" value=""/>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script>

   

    $("#DiscountR2").on("click", function () {
        $("#Discount").attr("disabled", false);
        $("#unit_discount").attr("disabled", true);
        $("#Line_Discount").attr("disabled", true);
    });
    $("#DiscountR1").on("click", function () {
        $("#unit_discount").attr("disabled", false);
        $("#Discount").attr("disabled", true);
        $("#Line_Discount").attr("disabled", true);
    });
    $("#DiscountR3").on("click", function () {
        $("#Line_Discount").attr("disabled", false);
        $("#unit_discount").attr("disabled", true);
        $("#Discount").attr("disabled", true);
    });

    $("#Line_Discount").blur(function () {
        debugger;
        var line_discount = $("#Line_Discount").val(); // 折扣数        -- 单元折扣*数量
        var unit_discount = $("#unit_discount").val(); // 单元折扣
        var Discount = $("#Discount").val();           // 折扣率
        var quantity = $("#quantity").val();     //  数量
        var unit_price = $("#unit_price").val(); //  单价
        if (quantity != "" && (!isNaN(quantity)) && line_discount != "" && (!isNaN(line_discount))) {
            var unitDiscount =(Number(line_discount)) / Number(quantity);
            $("#unit_discount").val(toDecimal2(unitDiscount));   // 点击折扣数之后给单元折扣赋值
        }
        Markup();
    })

    $("#Discount").blur(function () {
        debugger;
        var line_discount = $("#Line_Discount").val(); // 折扣数        -- 单元折扣*数量
        var unit_discount = $("#unit_discount").val(); // 单元折扣
        var Discount = $("#Discount").val();           // 折扣率
        var quantity = $("#quantity").val();     //  数量
        var unit_price = $("#unit_price").val(); //  单价
        if (unit_price != "" && (!isNaN(unit_price)) && Discount != "" && (!isNaN(Discount))) {
            var unitDiscount = (Number(Discount) * Number(unit_price)) / 100 ;
            $("#unit_discount").val(toDecimal2(unitDiscount));   
        }
        Markup();
    })

    $("#ByProject").click(function () {
       $("#unit_price").val(0);    // 单价
       $("#unit_cost").val(0);      // 单元成本
       $("#quantity").val(1);        // 数量
       Markup();
       if ($(this).is(':checked')) {
           
           $('#callBackChooseRole').removeAttr('onclick');//去掉标签中的onclick事件 
       }
       else {
           $("#callBackChooseRole").attr("onclick", "chooseRole()");
       }
       
    })
    $("#Reserved").blur(function () {
        var quanity = $("#quantity").val(); // 库存，暂不处理
    })

    // startCost service tax_cate_id
    $("#startCost").click(function () {
        $("#ItemTypeId").val('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.START_COST %>');
        $("#name").prop("disabled", false);
        $("#callBackService").css("display", "none");
        $("#callBackServiceBundle").css("display", "none");
        $("#description").val("");
        $("#tax_cate_id").val("0");
        $("#tax_cate_id").prop("disabled", true);
        $(".Calculation").prop("disabled", true);
        $("#unit_price").prop("disabled", false);
        $("#DiscountR1").prop("disabled", true);
        $("#DiscountR2").prop("disabled", true);
        $("#DiscountR3").prop("disabled", true);
        $("#unit_discount").val("0.00");
        $("#Line_Discount").val("0.00");
        $("#Discount").val("0");
        $("#quantity").val("1");
        $("#unit_price").val("0");
        $("#unit_cost").val("0");
        $("#name").val("");
        $("#nameHidden").val("");
        $("#object_id").val("");
        //$("#taxPriceTr").hide();
    });

    $("#service").click(function () {
        $("#ItemTypeId").val('<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.SERVICE %>');
        // name quantity
        $("#name").prop("disabled", true);
        $("#callBackService").css("display", "");
        $("#callBackServiceBundle").css("display", "");
        $("#tax_cate_id").prop("disabled", false);
        $("#quantity").prop("disabled", false);
        $("#DiscountR1").prop("disabled", false);
        $("#unit_discount").prop("disabled", false);
        $("#DiscountR3").prop("disabled", false);
        //$("#Line_Discount").prop("disabled", false);
        $("#DiscountR2").prop("disabled", false);
        //$("#Discount").prop("disabled", false);
        //$("#quantity").prop("disabled", false);
        //$("#taxPriceTr").show();
    });

    $(function () {

        Markup();

        $(".Calculation").blur(function () {
            Markup();
            var value = $(this).val();
            if (!isNaN(value) && value != "") {
                $(this).val(toDecimal2(value));
            } else {
                $(this).val("");
            }

        });

        $("#save_close").click(function () {
            var typeValue = $("#ItemTypeId").val();
            if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT %>){
                if (!SubmitDiscountCheck())
                {
                    return false;
                }
                $("input").prop("disabled", false);
                $("select").prop("disabled", false);
                return true;
            }
            else {
                if (!SubmitCheck())
                {
                    return false;
                }// SubmitDiscountCheck
                $("#name").removeAttr("disabled");
                $("select").prop("disabled", false);
                $("input").prop("disabled", false);
                return true;
            }
            
        });
        $("#save_new").click(function () {
            var typeValue = $("#ItemTypeId").val();
            if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT %>){
                if (!SubmitDiscountCheck()) {
                    return false;
                }
                $("input").prop("disabled", false);
                $("select").prop("disabled", false);
                return true;
            }
            else {
                if (!SubmitCheck()) {
                    return false;
                }// SubmitDiscountCheck
                $("#name").removeAttr("disabled");
                $("input").prop("disabled", false);
                $("select").prop("disabled", false);
                return true;
            }
        });

        var typeValue = $("#ItemTypeId").val();
        if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.WORKING_HOURS %>) // 工时的处理
        {
            $("#period_type_id").attr("disabled", "disabled");
            $("#ByProjectTr").css("display","");
            $("#callBackChooseRole").css("display", "");
            //$("#taxPriceTr").show();
        }
        else if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT %>) // 产品的处理
        {
            debugger;
            $("#productShow").css("display", "");
            $("#callBackManyProduct").css("display", "");
            $("#MSRP_tr").css("display", "");
            $("#callBackManyRole").css("display", "");
            $("#AddRole").css("display", "");
            $("#callBackChooseRole").css("display", "none");
            $("#callBackChooseProduct").css("display", "");// callBackChooseProduct
            $("#AddProduct").css("display", "");
            //$("#taxPriceTr").show();

            var product_id = $("#nameHidden").val();
            if (product_id != "") {
                // 获取平均值和最大值
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/ProductAjax.ashx?act=GetProData&product_id=" + product_id,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        if (data != "") {
                            $("#avgCost").text(toDecimal2(data.avg));
                            $("#highCost").text(toDecimal2(data.max));
                        }
                    },
                });
                // 获取库存信息
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/ProductAjax.ashx?act=GetPageWare&product_id=" + product_id,
                    success: function (data) {
                        if (data != "") {
                            $("#productListTable").css("display", "");

                            var wareHtml = "";
                            for (var i = 0; i < data.length; i++) {
                                wareHtml += "<tr><td><span>" + data[i].wareName + "</span></td><td><span>" + data[i].onHand + "</span></td><td><span>" + data[i].onOrder + "</span></td><td><span>" + data[i].backOrder + "</span></td><td><span>" + data[i].picked + "</span></td><td><span>" + data[i].available + "</span></td><td><input type='text' class='CheckUse' name='" + data[i].ware_id + "_available' id='" + data[i].ware_id + "_available' value='0' /><input type='hidden' id='" + data[i].ware_id + "_use' name='" + data[i].ware_id + "_use' value='" + data[i].available + "'/><input type='hidden' id='" + data[i].ware_id + "_hand' name='" + data[i].ware_id + "_hand' value='" + data[i].onHand + "'/><input type='hidden' value='" + data[i].ware_id +"'/></td></tr>";
                            }

                            $("#wareTbody").html(wareHtml);
                        } else {
                            $("#productListTable").css("display", "none");
                            $("#wareTbody").html("");
                        }
                    },
                    error: function (data) {
                        $("#productListTable").css("display", "none");
                        $("#wareTbody").html("");
                    },
                });
                <%if (thisReserList != null && thisReserList.Count > 0){
                foreach (var thisReser in thisReserList)
                {%>
                $("#<%=thisReser.warehouse_id %>_available").val('<%=thisReser.quantity %>');
                $("#<%=thisReser.warehouse_id %>_hand").val('<%=thisReser.quantity %>');
                        <%
                }}%>
            }
        }
        else if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.SERVICE %>)  // 服务和初始费用
        {
            $("#name").attr("disabled", "disabled");
            $(".serviceTr").css("display", "");
            $("#callBackService").css("display", ""); 
            $("#callBackServiceBundle").css("display", "");
            $("#unit_cost").prop("disabled", true);
            $("#periodTypeTr").css("display", "none");
            $("#period_type_id").val("0");
            //$("#taxPriceTr").show();
            // 判断是否可以新增初始费用
            debugger;
            var quote_id = '<%=Request.QueryString["quote_id"] %>';
            if (quote_id != "")
            {
                // 判断是否有初始费用
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/QuoteAjax.ashx?act=isHasStart&quote_id=" + quote_id,
                    success: function (data) {
                        debugger;
                        if (data != "") {
                            $("#startCost").attr("disabled", true);
                            $("#startCost").removeAttr("onclick");
                        }
                    },
                });
            }
        }
        else if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.START_COST %>)
        {
            <%if (!isAdd)
             { %>
            $("#name").attr("disabled", "disabled");
            $(".serviceTr").css("display", "");
            $("#unit_cost").prop("disabled", true);
            $("#periodTypeTr").css("display", "none");
            $("#period_type_id").val("0");
            $("#startCost").attr("checked", true);
            <%}%>
        }
        else if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION %>) // 成本
        {
            $("#period_type_id").attr("disabled", "disabled");
            $("#callbackCost").css("display", "");
            //$("#taxPriceTr").show();
        }
        else if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.COST %>)  // 费用
        {
            $("#period_type_id").attr("disabled", "disabled");
            $("#callBackCharge").css("display", "");
            //$("#taxPriceTr").show();
        }
        else if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT %>) // 折扣
        {
            $("#periodTypeTr").css("display", "none");
            $("#taxCateTr").css("display", "none");
            $("#unitPriceTr").css("display", "none"); //gross_profit_marginTR
            $("#gross_profit_marginTR").css("display", "none");
            $("#unitCostTR").css("display", "none");
            $("#quantityTR").css("display", "none");
            $("#TotalPriceTR").css("display", "none");
            $("#Gross_Profit_TR").css("display", "none");
            $("#LineDiscountTR").css("display", "none");
            $("#OptionTR").css("display", "none");
            //$("#ShowBai").hide();
            $("#Discount").blur(function () {
                var discount = $(this).val();
                if (discount != "" && (!isNaN(discount))) {
                    $("#unit_discount").val("");
                }
            })
            $("#unit_discount").blur(function () {
                var unit_discount = $(this).val();
                if (unit_discount != "" && (!isNaN(unit_discount))) {
                    $("#Discount").val("");
                }
            })

            <%if (quote_item != null)
             {
        if (quote_item.discount_percent != null)
        { %>
            $("#DiscountR2").prop("checked", true);
            $("#Discount").prop("disabled", false);
            $("#unit_discount").prop("disabled", true);

            <% }}%>
               

        }
        else if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES %>)  // 配送
        {
            $("#taxCateTr").css("display", "none");
            $("#callBackShip").css("display", "");
        }

        

    })


    $("#tax_cate_id").change(function () {
        var tax_cate_id = $(this).val();
        var quote_id = '<%=quote_id %>';
        var typeValue = $("#ItemTypeId").val();
        if (tax_cate_id != "0") {
            GetTaxUnitPrice();
        }
        
    })

    // 显示相关包含税的单价
    $("#unit_price").blur(function () {
        GetTaxUnitPrice();
    })
    // 根据包含税的单价显示相关单价
    $("#tax_unit_price").blur(function () {
        var unit_price = $("#unit_price").val();   // 单价
        var quote_id = '<%=quote_id %>';            // 报价
        var tax_cate_id = $("#tax_cate_id").val();  // 税种
        var tax_unit_price = $("#tax_unit_price").val();  // 税后价
        var taxCate = "";
        $.ajax({
            type: "GET",
            async: false,
            //dataType: "json",
            url: "../Tools/QuoteAjax.ashx?act=GetTax&quote_id=" + quote_id + "&tax_cate_id=" + tax_cate_id,
            success: function (data) {
                if (data != "") {
                    taxCate = data;
                }
            },
        });
        if (taxCate != "") {
            if (tax_unit_price != null && tax_unit_price != "" && tax_unit_price != undefined) {
                unit_price = Number(tax_unit_price) * (1 / (1 + Number(taxCate)));
                $("#unit_price").val(toDecimal2(unit_price));
            }
        }
    })

    $("#quantity").blur(function () {
        var value = $(this).val();
        if (!isNaN(value) && value != "") {
            $(this).val(toDecimal2(Math.round(value)));
        } else {
            $(this).val("");
        }
    })

    // 计算单价的含税价 设置税区和税种之后进行计算 
    function GetTaxUnitPrice() {
        var unit_price = $("#unit_price").val();   // 单价
        var quote_id = '<%=quote_id %>';            // 报价
        var tax_cate_id = $("#tax_cate_id").val();  // 税种
        var tax_unit_price = $("#tax_unit_price").val();  // 税后价
        // 获取到相应的税区，获取不到提醒用户
        // 获取相应的税种，获取不到提醒用户
        // 获取相应单价，和含税价，根据价钱进行处理
        var taxCate = "";
        $.ajax({
            type: "GET",
            async: false,
            //dataType: "json",
            url: "../Tools/QuoteAjax.ashx?act=GetTax&quote_id=" + quote_id + "&tax_cate_id=" + tax_cate_id,
            success: function (data) {
                if (data != "") {
                    taxCate = data;
                }
            },
        });
        if (taxCate != "")
        {
            if (unit_price != "" && unit_price != null && unit_price != undefined)
            {
                var taxMoney = Number(unit_price) + Number(unit_price) * Number(taxCate);
                $("#tax_unit_price").val(toDecimal2(taxMoney));
            }
            else
            {
                if (tax_unit_price != null && tax_unit_price != "" && tax_unit_price != undefined)
                {
                    unit_price = Number(tax_unit_price) * (1 / (1 + Number(taxCate)));
                    $("#unit_price").val(toDecimal2(unit_price));
                }
            }
        }
        else
        {
            $("#tax_unit_price").val("");
        }
    }



    // 计算页面上的利，总价等
    function Markup() {
        var unit_price = $("#unit_price").val();    // 单价
        var unit_cost = $("#unit_cost").val();      // 单元成本
        var quantity = $("#quantity").val();        // 数量
        var unit_discount = $("#unit_discount").val();  // 单元折扣

        // 计算毛利率
        if (unit_price != "" && unit_cost != "") {
            if ((!isNaN(unit_price)) && (!isNaN(unit_cost))) // 两个都是数字开始执行
            {
                if (unit_cost != 0) {
                    var Markup = Math.round((Number(unit_price) - Number(unit_cost)) / Number(unit_cost) * 10000) / 100.00;  //gross_profit_margin
                    $("#gross_profit_margin").val(toDecimal2(Markup));
                }            
            }
        }

        // 计算总价
        if (unit_price != "" && unit_discount != "" && quantity != "") {
            if ((!isNaN(unit_price)) && (!isNaN(unit_discount)) && (!isNaN(quantity))) // 都是数字开始执行
            {
                var total_price = (Number(unit_price) - Number(unit_discount)) * quantity;
                $("#TotalPrice").val(toDecimal2(total_price));
            }
        }

        // 计算毛利润
        if (unit_price != "" && unit_discount != "" && quantity != "" && unit_cost != "") {
            if ((!isNaN(unit_price)) && (!isNaN(unit_discount)) && (!isNaN(quantity)) && (!isNaN(unit_cost))) // 都是数字开始执行
            {
                var Gross_Profit = (Number(unit_price) - Number(unit_discount) - Number(unit_cost)) * quantity;
                $("#Gross_Profit").val(toDecimal2(Gross_Profit));
            }
        }

        // 计算折扣数
        if (unit_discount != "" && quantity != "") {
            if ((!isNaN(unit_discount)) && (!isNaN(quantity))) // 都是数字开始执行
            {
                var Line_Discount = Number(unit_discount) * quantity;
                $("#Line_Discount").val(toDecimal2(Line_Discount));
            }
        }
        // 计算折扣率  Discount
        if (unit_discount != "" && unit_price != "") {
            if ((!isNaN(unit_discount)) && (!isNaN(unit_price))) // 都是数字开始执行
            {
                if (unit_price != 0) {
                    var Discount = Math.round(Number(unit_discount) / Number(unit_price) * 10000) / 100.00;
                    $("#Discount").val(toDecimal2(Discount));
                }
               
            }
        }



    }

    // 工时报价项提交校验
    function SubmitCheck() {
        var name = $("#name").val();
        if (name == "") {
            alert("请填写名称");
            return false;
        }
        // nameHidden
        var typeValue = $("#ItemTypeId").val();
        if (typeValue !=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.START_COST %>){
            var nameHidden = $("#nameHidden").val();
            if (nameHidden == "") {
                alert("请通过查找带回功能选择关联项");
                return false;
            }
            //var period_type_id = $("#period_type_id").val();
            //if (period_type_id == undefined || period_type_id == "" || period_type_id=="0") {
            //    alert("请");
            //    return false;
            //}
        }
      

        var unit_price = $("#unit_price").val();
        if (unit_price == "") {
            if (typeValue ==<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT %>){
                alert("请输入单价；您也可以输入含税单价、税种，并设置客户税区，以自动计算出单价");
            }
            else {
                alert("请填写单价");
            }
            
            return false;
        }
        var unit_cost = $("#unit_cost").val();
        if (unit_cost == "") {
            alert("请填写单元成本");
            return false;
        }
        var quantity = $("#quantity").val();
        if (quantity == "") {
            alert("请填写数量");
            return false;
        }
        var unit_discount = $("#unit_discount").val();
        if (unit_discount == "") {
            alert("请填写单元折扣");
            return false;
        }



        var typeValue = $("#ItemTypeId").val();
        if (typeValue =='<%=(int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT %>')
        {
            var isPass = "";
            var wareIds = "";
            $(".CheckUse").each(function () {
                var thisValue = $(this).val();
                var thisMax = $(this).next().val();
                // var num = $(this).next().next().val();
                var thisWareId = $(this).next().next().next().val();
                wareIds += thisWareId + ",";
                if (Number(thisValue) > Number(thisMax)) {
                    isPass = "1";
                    // return false;
                }
                if (Number(thisValue) > Number(quantity)) {
                    isPass = "1";
                    // return false;
                }
                if (Number(thisValue) < 0) {
                    isPass = "1";
                }
                <%if (!isAdd)
            { %>
                var oldValue = $(this).next().next().val();
                if (Number(thisValue) > (Number(oldValue) + Number(thisMax))) {
                    isPass = "1";
                }
                <%}%>
            })
            if (isPass != "")
            {
                alert("为此报价项预留不可超过可用数和数量，请检查后重新提交");
                return false;
            }
            if (wareIds != "")
            {
                wareIds = wareIds.substring(0, wareIds.length - 1);
                $("#wareIds").val(wareIds);
            }
            //var Reserved = $("#Reserved").val();
            //if (Reserved != "" && (!isNaN(quantity)) && (!isNaN(quantity))) {
            //    debugger;
            //    if (Number(quantity) > Number(Reserved)) {
            //        alert("数量要大于保留");
            //        return false;
            //    }
            //}
        }

        return true;
    }


 
     // 折扣报价项提交校验
    function SubmitDiscountCheck() {
        var name = $("#name").val();
        if (name == "") {
            alert("请填写名称");
            return false;
        }

        var unit_discount = $("#unit_discount").val();
        var Discount = $("#Discount").val();
        if (unit_discount == "" && Discount == "") {
            alert("单元折扣与折扣请选择其中一个进行填写");
            return false;
        }
        if (unit_discount != "" && Discount != "") {
            alert("请勿选择多项");
            return false;
        }
        return true;
    }
 



    function chooseRole() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.ROLL_CALLBACK %>&field=name&callBack=GetDataByRole", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.RoleSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByRole() {
        var role_id = $("#nameHidden").val();
        if (role_id != "") {
            $("#object_id").val(role_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json", 
                url: "../Tools/RoleAjax.ashx?act=role&role_id=" + role_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#name").val(data.name);
                        $("#description").text(data.description);
                        $("#unit_price").val(toDecimal2(data.hourly_rate));
                        Markup();
                    }
                },
            });
        }
    }

    function toDecimal2(x) {
        var f = parseFloat(x);
        if (isNaN(f)) {
            return "";
        }
        var f = Math.round(x * 100) / 100;
        var s = f.toString();
        var rs = s.indexOf('.');
        if (rs < 0) {
            rs = s.length;
            s += '.';
        }
        while (s.length <= rs + 2) {
            s += '0';
        }
        return s;
    }
    // 查找带回产品
    function chooseProduct() { //PRODUCT_CALLBACK
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=name&callBack=GetDaraByProduct", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDaraByProduct() {
        var product_id = $("#nameHidden").val();
        if (product_id != "") {
            $("#object_id").val(product_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=product&product_id=" + product_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        debugger;
                        $("#name").val(data.name);
                        $("#description").text(data.description);
                        $("#unit_price").val(data.unit_price); //unit_cost
                        $("#unit_cost").val(data.unit_cost);
                        $("#MSRP").val(data.msrp);
                        $("#Reserved").val(0);
                        Markup();
                    }
                },
            });

            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetProData&product_id=" + product_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#avgCost").text(toDecimal2(data.avg));  
                        $("#highCost").text(toDecimal2(data.max));
                    }
                },
            });
            // GetPageWare
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetPageWare&product_id=" + product_id,
                success: function (data) {
                    if (data != "") {
                        $("#productListTable").css("display", "");

                        var wareHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            wareHtml += "<tr><td><span>" + data[i].wareName + "</span></td><td><span>" + data[i].onHand + "</span></td><td><span>" + data[i].onOrder + "</span></td><td><span>" + data[i].backOrder + "</span></td><td><span>" + data[i].picked + "</span></td><td><span>" + data[i].available + "</span></td><td><input type='text' class='CheckUse' name='" + data[i].ware_id + "_available' value='0' /><input type='hidden' id='" + data[i].ware_id + "_use' name='" + data[i].ware_id + "_use' value='" + data[i].available + "'/><input type='hidden' id='" + data[i].ware_id + "_hand' name='" + data[i].ware_id + "_hand' value='" + data[i].onHand + "'/><input type='hidden' value='" + data[i].ware_id+"'/></td></tr>";
                        }

                        $("#wareTbody").html(wareHtml);
                    } else {
                        $("#productListTable").css("display", "none");
                        $("#wareTbody").html("");
                    }
                },
                error: function (data) {
                    $("#productListTable").css("display", "none");
                    $("#wareTbody").html("");
                },
            });

            // 新增时，获取成本信息，先进先出，或者先进后出等决定单位成本
            <%if (isAdd)
    { %>
            $.ajax({
                type: "GET",
                async: false,
                // dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetProductCost&product_id=" + product_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "" && data != null) {
                        $("#unit_cost").val(data);
                        Markup();
                    }
                },
            });
            <%}%>
        } else {
            $("#productListTable").css("display", "none");
            $("#wareTbody").html("");
        }
    }
    // 查找带回服务
    function chooseService() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALLBACK %>&field=name&callBack=GetDataByService", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ServiceSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByService() {
        var service_id = $("#nameHidden").val();
        if (service_id != "") {
            $("#object_id").val(service_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ServiceAjax.ashx?act=service&service_id=" + service_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        // $("#name").val(data.name);
                        $("#description").text(data.description);
                        $("#unit_price").val(toDecimal2(data.unit_price)); //unit_cost
                        $("#unit_cost").val(toDecimal2(data.unit_cost));
                        Markup();
                    }
                },
            });
        }
    }
    // 查找带回服务集
    function chooseServiceBundle() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_BUNDLE_CALLBACK %>&field=name&callBack=GetDataByServiceBundle", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ServiceBundleSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByServiceBundle() {
        var service_bundle_id = $("#nameHidden").val();
        if (service_bundle_id != "") {
            $("#object_id").val(service_bundle_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ServiceAjax.ashx?act=service_bundle&service_bundle_id=" + service_bundle_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        debugger;
                        // $("#name").val(data.name);
                        //$("#name").attr("disabled","disabled");
                        $("#description").text(data.description);
                        $("#unit_price").val(toDecimal2(data.unit_price)); 
                        $("#unit_cost").val(toDecimal2(data.unit_cost));
                        Markup();
                    }
                },
            });
        }
    }

    // 查找带回计费代码
    function chooseDegression() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COST_CALLBACK %>&field=name&callBack=GetDataByDegression", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByDegression() {
        
        var charge_id = $("#nameHidden").val();
        if (charge_id != "") {
            $("#object_id").val(charge_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/QuoteAjax.ashx?act=costCode&id=" + charge_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        // 填充数据
                        $("#name").val(data.name);
                        $("#unit_price").val(toDecimal2(data.unit_price)); //unit_cost
                        $("#unit_cost").val(toDecimal2(data.unit_cost));
                        // todo 税收种类
                        Markup();
                    }
                },
            });
        }
    }

    // 多选查找带回产品的时候--直接循环添加多个报价项

    function chooseManyProduct() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MANY_PRODUCT_CALLBACK %>&field=name&callBack=AddManyQuoteItem&muilt=1", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ManyProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function AddManyQuoteItem() {
        debugger;
        var productIds = $("#nameHidden").val();
        var quote_id = $("#thisQuoteId").val();
        if (productIds != "") {
            $.ajax({
                type: "GET",
                //async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=AddQuoteItems&ids=" + productIds + "&quote_id=" + quote_id,
                success: function (data) {
                    debugger;
                    if (data != "True") {
                        alert('批量添加产品报价项成功');
                      
                    } else {
                        alert('批量添加产品报价项失败');
                    }
                    window.close();
                    self.opener.location.reload();
                },
            });
          
        }
        
    
    }


    function chooseCharge() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CHARGE_CALLBACK %>&field=name&callBack=GetDataByCharge", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ManyProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function GetDataByCharge() {
        //  根据费用填充数据
        var charge_id = $("#nameHidden").val();
        if (charge_id != "") {
            $("#object_id").val(charge_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/QuoteAjax.ashx?act=costCode&id=" + charge_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        // 填充数据
                        $("#name").val(data.name);
                        $("#unit_price").val(toDecimal2(data.unit_price));
                        $("#unit_cost").val(toDecimal2(data.unit_cost));
                        $("#tax_category_id").val(data.tax_category_id);
                        Markup();
                    }
                },
            });
        }
    }

    function chooseShip() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SHIP_CALLBACK %>&field=name&callBack=GetDataByShip", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ManyProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function GetDataByShip() {
        // - todo 根据配送方式填充数据
        var ship_id = $("#nameHidden").val();
        if (ship_id != "") {
            $("#object_id").val(ship_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/GeneralAjax.ashx?act=general&id=" + ship_id,
                success: function (data) {
                    if (data != "") {
                        $("#name").val(data.name);
                        $("#description").text(data.remark);
                    }
                },
            });
        }
    }

    function ViewProject() {
        var project_idHidden = $("#project_idHidden").val();
        if (project_idHidden == "") {
            alert("该报价还未关联项目提案");
            return false;
        }
        if ($("#ByProject").is(":checked")) {
            alert("暂未开发呦");
            return false;

        } else {
            alert("您还未勾选项目提案工时");
            return false;
        }
    }

</script>
