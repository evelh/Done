<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteItemAddAndUpdate.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteItem.QuoteItemAddAndUpdate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"添加报价项":"修改报价项" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
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
                <table width="100%" border="0" callpadding="2" callspacing="0">
                    <tbody>
                        <tr>
                            <td class="NewLeft">
                                <table width="100%" border="0" callpadding="3" callspacing="0">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels">报价项名称
                                            <span id="errorSmall">*</span>
                                                <div>
                                                    <input type="text" name="name" id="name" value="<%=isAdd?"":quote_item.name %>" />
                                                    <i onclick="chooseRole()" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">报价项描述
                                            <div>
                                                <textarea name="description" id="description">
                                                        <%=(!isAdd)&&(!string.IsNullOrEmpty(quote_item.description))?quote_item.description:"" %>
                        </textarea>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr valign="middle">
                                            <td class="FieldLabels">期间类型
                                            <div>
                                                <asp:DropDownList ID="period_type_id" runat="server"></asp:DropDownList>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">
                                                <input type="checkbox" name="ByProject" />
                                                <span class="CheckBoxLabels">项目提案工时</span>
                                                <div>
                                                    <input type="text" name="project_id" id="project_id" />
                                                    <i onclick="" style="width: 20px; height: 20px; margin-left: 10px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">税收种类
                                            <div>
                                                <asp:DropDownList ID="tax_cate_id" runat="server"></asp:DropDownList>
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
                                                            <tr>
                                                                <td class="FieldLabels" style="padding-top: 6px;">单价</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="unit_price" id="unit_price" value="<%=(!isAdd)&&(quote_item.unit_price!=null)?quote_item.unit_price.ToString():"" %>" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" style="padding-top: 6px;">毛利率</td>
                                                                <td class="FieldLabels">
                                                                    <div>
                                                                        <input type="text" disabled style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="gross_profit_margin" id="gross_profit_margin" />&nbsp;%
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" style="padding-top: 6px;">单元成本</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="unit_cost" id="unit_cost" value="<%=(!isAdd)&&(quote_item.unit_cost!=null)?quote_item.unit_cost.ToString():"" %>" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" style="padding-top: 6px;">数量</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="quantity" id="quantity" value="<%=(!isAdd)&&(quote_item.quantity!=null)?quote_item.quantity.ToString():isAdd?"1":"" %>" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" style="padding-top: 6px;">总价</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" value="0.00" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="TotalPrice" id="TotalPrice" disabled="disabled" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" style="padding-top: 6px;">毛利润</td>
                                                                <td class="FieldLabels">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" value="0.00" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="Gross_Profit" id="Gross_Profit" disabled="disabled" />
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
                                                                    <input type="radio" id="DiscountR1" checked="checked" />单元折扣 
                                                                </td>
                                                                <td class="FieldLabels" align="right">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" class="Calculation" name="unit_discount" id="unit_discount" value="<%=(!isAdd)&&(quote_item.unit_discount!=null)?quote_item.unit_discount.ToString():"" %>" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" width="45%" style="padding-top: 6px;">
                                                                    <input type="radio" id="DiscountR3" />折扣数 
                                                                </td>
                                                                <td class="FieldLabels" align="right">
                                                                    <div style="width: 100px; margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="Line_Discount" id="Line_Discount" disabled="disabled" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" width="45%" style="padding-top: 6px;">
                                                                    <input type="radio" id="DiscountR2">折扣率
                                                                </td>
                                                                <td class="FieldLabels" align="right">
                                                                    <div style="margin: 0; padding: 0; padding-bottom: 21px;">
                                                                        <input type="text" style="text-align: right; width: 86px; height: 22px; padding: 0 6px;" name="Discount" id="Discount" disabled="disabled" />&nbsp;%
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td class="FieldLabels" style="padding-top: 6px">
                                                                    <input type="checkbox" name="optional" id="optional" data-val="1" value="1" />可选的
                                                                </td>
                                                                <td align="right">&nbsp;</td>
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
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {

        Markup();

        $(".Calculation").blur(function () {
            Markup();
        })

        $("#save_close").click(function () {
            if (!SubmitCheck) {
                return false;
            }
        })
        $("#save_new").click(function () {
            if (!SubmitCheck) {
                return false;
            }
        })
    })

    // 计算页面上的利，总价等
    function Markup() {
        var unit_price = $("#unit_price").val();    // 单价
        var unit_cost = $("#unit_cost").val();      // 单元成本
        var quantity = $("#quantity").val();       // 数量
        var unit_discount = $("#unit_discount").val();  // 单元折扣

        // 计算毛利率
        if (unit_price != "" && unit_cost != "") {
            if ((!isNaN(unit_price)) && (!isNaN(unit_cost))) // 两个都是数字开始执行
            {
                var Markup = Math.round((Number(unit_price) - Number(unit_cost)) / Number(unit_price) * 10000) / 100.00;  //gross_profit_margin
                $("#gross_profit_margin").val(Markup);
            }
        }

        // 计算总价
        if (unit_price != "" && unit_discount != "" && quantity != "") {
            if ((!isNaN(unit_price)) && (!isNaN(unit_discount)) && (!isNaN(quantity))) // 都是数字开始执行
            {
                var total_price = (Number(unit_price) - Number(unit_discount)) * quantity;
                $("#TotalPrice").val(total_price);
            }
        }

        // 计算毛利润
        if (unit_price != "" && unit_discount != "" && quantity != "" && unit_cost != "") {
            if ((!isNaN(unit_price)) && (!isNaN(unit_discount)) && (!isNaN(quantity)) && (!isNaN(unit_cost))) // 都是数字开始执行
            {
                var Gross_Profit = (Number(unit_price) - Number(unit_discount) - Number(unit_cost)) * quantity;
                $("#Gross_Profit").val(Gross_Profit);
            }
        }

        // 计算折扣数
        if (unit_discount != "" && quantity != "") {
            if ((!isNaN(unit_discount)) && (!isNaN(quantity))) // 都是数字开始执行
            {
                var Line_Discount = Number(unit_discount) * quantity;
                $("#Line_Discount").val(Line_Discount);
            }
        }
        // 计算折扣率  Discount
        if (unit_discount != "" && unit_price != "") {
            if ((!isNaN(unit_discount)) && (!isNaN(unit_price))) // 都是数字开始执行
            {
                var Discount = Math.round(Number(unit_discount) / Number(unit_price) * 10000) / 100.00;
                $("#Discount").val(Discount);
            }
        }



    }

    function SubmitCheck() {
        var name = $("#name").val();
        if (name == "") {
            alert("请填写名称");
            return false;
        }

        var unit_price = $("#unit_price").val();
        if (unit_price == "") {
            alert("请填写单价");
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

        return true;
    }

    function chooseRole() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=EMT.DoneNOW.DTO.OpenWindow.RoleSelect %>&field=name", 'new', 'left=200,top=200,width=600,height=800', false);
    }



</script>
