<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCharges.aspx.cs" Inherits="EMT.DoneNOW.Web.Contract.AddCharges"   ValidateRequest="false"%>

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
                top: 1px;
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

        #isbillable {
            vertical-align: middle;
        }

        #AddConfigItem {
            vertical-align: middle;
        }

        .Section {
            border: 1px solid #d3d3d3;
            margin: 0 0 12px 0;
            padding: 4px 0 4px 0;
            width: 836px;
        }

            .Section > .Heading {
                align-items: center;
                display: flex;
                overflow: hidden;
                padding: 2px 4px 8px 6px;
                position: relative;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

                .Section > .Heading > .Toggle {
                    background: #d7d7d7;
                    background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                    background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                    background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                    background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                    border: 1px solid #c6c6c6;
                    cursor: pointer;
                    flex: 0 0 auto;
                    height: 14px;
                    margin: 0 6px 0 0;
                    -webkit-user-select: none;
                    -moz-user-select: none;
                    -ms-user-select: none;
                    user-select: none;
                    width: 14px;
                }

                .Section > .Heading > div, .Section > .Heading > span {
                    display: inline-block;
                    position: relative;
                }

                .Section > .Heading > .Toggle.Collapse > .Vertical {
                    display: none;
                }

                .Section > .Heading > .Toggle > .Vertical {
                    background-color: #888;
                    height: 8px;
                    left: 6px;
                    position: absolute;
                    top: 3px;
                    width: 2px;
                }

                .Section > .Heading > .Toggle > .Horizontal {
                    background-color: #888;
                    height: 2px;
                    left: 3px;
                    position: absolute;
                    top: 6px;
                    width: 8px;
                }

                .Section > .Heading > .Left {
                    flex: 0 1 auto;
                }

                .Section > .Heading > div, .Section > .Heading > span {
                    display: inline-block;
                    position: relative;
                }

                .Section > .Heading[data-toggle-enabled="true"] > .Left > .Text {
                    cursor: pointer;
                }

                .Section > .Heading > .Left > .Text, .Section > .Heading > .Middle > .Text {
                    color: #666;
                    font-size: 12px;
                    font-weight: bold;
                    line-height: normal;
                    text-transform: uppercase;
                }

                .Section > .Heading > .Spacer {
                    flex: 1 1 auto;
                }

                .Section > .Heading > div, .Section > .Heading > span {
                    display: inline-block;
                    position: relative;
                }

            .Section > .Content {
                padding-top: 12px;
            }

            .Section > .DescriptionText, .Section > .Content {
                padding-left: 28px;
                padding-right: 28px;
            }

            .Section .Column.Normal, .Section .Column.Normal > .Editor, .Section .Column.Normal > .CheckBoxGroupContainer > .Editor, .Section .Column.Normal > .RadioButtonGroupContainer > .Editor, .Section .Column.Normal > .Attachment_TypeContainer > .Editor {
                width: 390px;
            }

        .Column, .ReplaceableColumnContainer {
            display: inline-block;
            vertical-align: top;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            background-color: white;
            border-left-width: 0;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: middle;
            padding: 10px 0 4px 0;
            vertical-align: top;
            word-wrap: break-word;
            border-right-width: 1px;
            border-right-style: solid;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            border-bottom-color: #98b4ca;
            border-right-color: #98b4ca;
        }

            .dataGridBody tr, .dataGridBodyHover tr {
                height: 22px;
            }

       

        .dataGridHeader {
            border-left: outset 1px;
            border-right: outset 1px;
            border-bottom: outset 1px;
            font-size: 9px;
            font-weight: bold;
            color: white;
            text-decoration: none;
            height: 25px;
            background-color: #356995;
            vertical-align: top;
        }

        .dataGridBody .dataGridHeader td {
            border-bottom-style: solid;
            border-bottom-width: 1px;
        }

        .dataGridBody td:first-child, .dataGridAlternating td:first-child, .dataGridBodyHover td:first-child, .dataGridAlternatingHover td:first-child, .dataGridDisabled td:first-child, .dataGridDisabledHover td:first-child {
            border-left-color: #98b4ca;
        }

        .dataGridBody .dataGridHeader td {
            border-bottom-color: #98b4ca;
        }

        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
            border-right-width: 1px;
            border-right-style: solid;
            font-size: 13px;
            font-weight: bold;
            height: 19px;
            padding: 4px;
            vertical-align: top;
            word-wrap: break-word;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 25;
            position: absolute;
            top: 0;
            left: 0;
            display: none;
        }

        .Dialog.Large {
            position: fixed;
            background-color: #ffffff;
            border: solid 4px #b9b9b9;
            display: none;
        }

        .column {
            padding: 0px 3px 13px 10px;
        }

        .columnTextBox {
            padding: 0px 3px 19px 10px;
        }

        .dataSelectorLabelColumn {
            padding-right: 3px;
            padding-left: 10px;
            padding-top: 0px;
        }

        .dataSelectorColumn {
            padding: 0px 3px 20px 10px;
        }

        .radioColumn {
            padding-right: 3px;
            padding-left: 10px;
            padding-bottom: 8px;
        }
        .DivSection {
    padding: 0px !important;
}
        .DivSection, .DivSectionOnly {
    border: 1px solid #d3d3d3;
    margin: 0 10px 10px 10px;
    padding: 12px 28px 4px 28px;
}
        #LoadingIndicator {
    width: 100px;
    height:100px;
    background-image: url(../Images/Loading.gif);
    background-repeat: no-repeat;
    background-position: center center;
    z-index: 30;
    margin:auto;
    position: absolute;
    top:0;
    left:0;
    bottom:0;
    right: 0;
    display: none;
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
                        <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                    <span class="Icon Save"></span>
                    <span class="Text">
                        <asp:Button ID="save" runat="server" Text="保存" OnClick="save_Click" BorderStyle="None" /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                    <span class="Icon SaveAndNew"></span>
                    <span class="Text">
                        <asp:Button ID="save_add" runat="server" Text="保存并新建" OnClick="save_add_Click" BorderStyle="None" /></span>
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
                                                        <input type="text" id="product_id" style="width: 294px;" value="<%=product!=null?product.name:"" %>" />
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

                                                        <input type="hidden" name="cost_code_id" id="costIdHidden" value="<%=costCode!=null?costCode.id.ToString():"" %>" />
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

                                <%  EMT.DoneNOW.Core.ctt_contract_cost_default defCost = null;
                                    if (contract != null)
                                    {
                                        defCost = new EMT.DoneNOW.DAL.ctt_contract_cost_default_dal().GetSinCostDef(contract.id);
                                    }  %>
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
                                                                            <input type="text" style="width: 65px; text-align: right;" name="quantity" id="quantity" value="<%=conCost!=null&&conCost.quantity!=null?((decimal)conCost.quantity).ToString("#0.0000"):"1.0000" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                        </span>
                                                                    </td>
                                                                    <td align="center" style="width: 20px;">
                                                                        <span class="FieldLabel" style="font-weight: bold;">x</span>
                                                                    </td>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 160px; text-align: right;" name="unit_cost" id="unit_cost" value="<%=conCost!=null&&conCost.unit_cost!=null?((decimal)conCost.unit_cost).ToString("#0.0000"):defCost!=null&&defCost.unit_cost!=null?((decimal)defCost.unit_cost).ToString("#0.0000"):"0.0000" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                                        </span>
                                                                    </td>
                                                                    <td align="center" style="width: 20px;">
                                                                        <span class="FieldLabel" style="font-weight: bold;">=</span>
                                                                    </td>
                                                                    <td>
                                                                        <span style="display: inline-block;">
                                                                            <input type="text" style="width: 160px; text-align: right;" id="extendedCost" value="" />
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
                                                                            <input type="text" style="width: 160px; text-align: right;" name="unit_price" id="unit_price" value="<%=conCost!=null&&conCost.unit_price!=null?((decimal)conCost.unit_price).ToString("#0.0000"):defCost!=null&&defCost.unit_cost!=null?((decimal)defCost.unit_cost).ToString("#0.0000"):"0.0000" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
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
                                                <%if (thisTask != null)
                                                    { %>
                                                <tr>
                                                    <td style="text-align: right;">
                                                        <span class="FieldLabel" style="font-weight: bold;">变更单时间
                                        <span class="errorSmallClass">*</span>
                                                        </span>
                                                        <div>
                                                            <input type="text" name="change_order_hours" id="change_order_hours" style="width: 294px;" value="<%=conCost!=null&&conCost.change_order_hours!=null?((decimal)conCost.change_order_hours).ToString("#0.000"):"0.0000" %>" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                                        </div>
                                                    </td>
                                                </tr>
                                                <%} %>
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
                                                        <select <%if (!CheckAuth("SEARCH_CONTRACT_CHARGE_ADD_CHANGE_SERVICE"))
                                                            { %>
                                                            disabled="disabled" <%} %> style="width: 150px;" name="service_id" id="service_id">
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
            <div class="Normal Section" id="AssignSectionHeader" style="margin-left: 11px; display: none; padding-bottom: 30px;">
                <div class="Heading" data-toggle-enabled="true">
                    <div class="Toggle Collapse Toggle1">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <div class="Left"><span class="Text">仍需数量：</span><span id="NeedNum"><%=conCost!=null&&conCost.quantity!=null?((decimal)conCost.quantity).ToString("#0"):"" %></span> <span class="SecondaryText"></span></div>
                    <div class="Spacer"></div>
                </div>
                <div class="Content">
                    <table class="dataGridBody" border="1" id="ucCostEdit_dgItemsNeeded_dgItemsNeeded_datagrid" style="width: 100%; border-collapse: collapse; border-top-width: 0px;">
                        <tr class="dataGridHeader">
                            <td align="left">库存位置</td>
                            <td align="left">库存数</td>
                            <td align="left">预留和拣货</td>
                            <td align="left">可用数</td>
                            <% if (!isAdd && conCost.quantity != 0)
                                { %>
                            <td>拣货</td>
                            <%} %>
                        </tr>
                        <tbody id="StillNeedNumber">
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="Normal Section" id="ShowPiecedDiv" style="margin-left: 11px; display: none; padding-bottom: 30px;">
                <div class="Heading" data-toggle-enabled="true">
                    <div class="Toggle Collapse Toggle2">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <div class="Left"><span class="Text">已拣货、已接收、采购中：</span><span id="pickedNum"></span> <span class="SecondaryText"></span></div>
                    <div class="Spacer"></div>
                </div>
                <div class="Content">
                    <table class="dataGridBody" border="1" id="" style="width: 100%; border-collapse: collapse; border-top-width: 0px;">
                        <tr class="dataGridHeader">
                            <td align="left">转运仓库</td>
                            <td align="right">序列号</td>
                            <td align="right">数量</td>
                            <td align="right">供应商编号</td>
                            <td align="left">状态</td>
                            <td align="center">取消拣货</td>
                            <td align="center">库存转移</td>
                            <td align="center">配送</td>
                            <td align="center">配送状态</td>
                        </tr>
                        <tbody id="PickedTbody">
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
        <input type="hidden" id="ShowCostProId"/>
        <div id="BackgroundOverLay"></div>
        <div class="Dialog Large" style="margin-left: 200px; margin-top: 100px; z-index: 100; height: 425px; width: 350px; display: none;" id="ShoePickPageDialog">
            <div style="background-color: #346a95; color: #fff; height: 35px;"><span id="_ctl4" class="TitleContainer" style="font-weight: bold; top: 7px; left: 10px; display: block; width: 85%; position: absolute; text-transform: uppercase; font-size: 15px; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-transform: uppercase;">拣货</span></div>
            <div class="BlueberryMenuBar" style="margin-bottom: -5px;">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="PickItem()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -131px -33px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">保存</span></div>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="HiddenPickDiv()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -102px -1px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">关闭</span></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <table cellspacing="0" cellpadding="0" width="100%" border="0" style="margin-left: 10px;">
                <tbody>
                    <tr>
                        <td class="column" nowrap="" align="left" colspan="2">
                            <span id="lblPickFrom" class="lblNormalClass" style="font-weight: bold;">仓库</span>
                            <span id="lblFromLocation" class="lblNormalClass" style="font-weight: normal; display: block; margin-top: -3px; font-size: 12px; color: #333333;"></span>
                            <input type="hidden" id="pickWareId" />
                        </td>
                    </tr>
                    <tr>
                        <td class="columnTextBox" nowrap="" align="left" colspan="2">
                            <span id="lblQuantityToPick" class="lblNormalClass" style="font-weight: bold;">拣货数量<font style="color: Red;"> *</font></span>
                            <br>
                            <span id="txtQuantityToPick" style="display: inline-block;">
                                <input name="PickNum" type="text" value="1" maxlength="10" id="PickNum" class="txtBlack8Class" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />

                            </span>
                        </td>
                    </tr>
                    <tr class="HasSeraliNum">
                        <td class="dataSelectorLabelColumn" colspan="2" style="display: flex;"><span class="lblNormalClass" style="font-weight: bold;">序列号<font style="color: Red;"> *</font></span></td>
                    </tr>
                    <tr class="HasSeraliNum">
                        <td class="dataSelectorColumn" colspan="2" style="display: flex;">
                            <span id="selectorSerialNumbers" style="display: inline-block;">
                                <select size="4" name="selectorSerialNumbers:ATListBox" id="SnSelect" class="txtBlack8Class" style="height: 88px; width: 256px;" multiple="multiple">
                                </select>
                            </span>&nbsp;
                            <a href="#" id="selectorSerialNumbers_anchor" class="DataSelectorLinkIcon Multiple">
                                <img src="../Images/data-selector.png" style="vertical-align: middle;" id="ChoSerNum" onclick="ChooseSerNum()" />
                            </a>
                            <input type="hidden" name="serNumIds" id="serNumIds" />
                            <input type="hidden" name="serNumIdsHidden" id="serNumIdsHidden" />

                        </td>
                    </tr>
                    <tr>
                        <td class="radioColumn" align="left" colspan="2">
                            <span class="lblNormalClass" style="font-weight: 100">
                                <input id="chkTransferToMe" type="radio" name="Transfer" value="ToMe"><label for="chkTransferToMe">库存转移给我</label></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="radioColumn" align="left" colspan="2">
                            <span class="lblNormalClass" style="font-weight: 100">
                                <input id="chkDeliverShipItems" type="radio" name="Transfer" value="ToShipItem"><label for="chkDeliverShipItems">配送给客户</label></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="Dialog Large" style="margin-left: 200px; margin-top: 100px; z-index: 100; height: 425px; width: 350px; display: none;" id="ShowUnPickPageDialog">
            <div style="background-color: #346a95; color: #fff; height: 35px;"><span id="_ctl4" class="TitleContainer" style="font-weight: bold; top: 7px; left: 10px; display: block; width: 85%; position: absolute; text-transform: uppercase; font-size: 15px; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-transform: uppercase;">取消拣货</span></div>
            <div class="BlueberryMenuBar" style="margin-bottom: -5px;">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="UnPickItem()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -131px -33px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">保存</span></div>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="HiddenUnPickDiv()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -102px -1px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">关闭</span></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <table cellspacing="0" cellpadding="0" width="100%" border="0" style="margin-left: 10px;">
                <tbody>
                    <tr>
                        <td class="column" nowrap="" align="left" colspan="2">
                            <span id="" class="lblNormalClass" style="font-weight: bold;">仓库</span>
                            <span id="unPickWareName" class="lblNormalClass" style="font-weight: normal; display: block; margin-top: -3px; font-size: 12px; color: #333333;"></span>
                            <input type="hidden" id="UnPickWareId" />
                            <input type="hidden" id="UnPickMaxNumber" />
                        </td>
                    </tr>
                    <tr>
                        <td class="columnTextBox" nowrap="" align="left" colspan="2">
                            <span id="" class="lblNormalClass" style="font-weight: bold;">取消拣货数量<font style="color: Red;"> *</font></span>
                            <br />
                            <span id="" style="display: inline-block;">
                                <input name="PickNum" type="text" value="1" maxlength="10" id="UnPickNum" class="txtBlack8Class" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />

                            </span>
                        </td>
                    </tr>
                    <tr class="HasSeraliNum">
                        <td class="dataSelectorLabelColumn" colspan="2" style="display: flex;"><span class="lblNormalClass" style="font-weight: bold;">序列号<font style="color: Red;"> *</font></span></td>
                    </tr>
                    <tr class="HasSeraliNum">
                        <td class="dataSelectorColumn" colspan="2" style="display: flex;">
                            <span id="" style="display: inline-block;">
                                <select size="4" name="selectorSerialNumbers:ATListBox" id="UnPickSnSelect" class="txtBlack8Class" style="height: 88px; width: 256px;" multiple="multiple">
                                </select>
                            </span>&nbsp;
                            <a href="#" id="" class="DataSelectorLinkIcon Multiple">
                                <img src="../Images/data-selector.png" style="vertical-align: middle;" id="" onclick="ChooseInPickSerNum()" />
                            </a>
                            <input type="hidden" id="UnPickSerNumIds" />
                            <input type="hidden" id="UnPickSerNumIdsHidden" />
                            <input type="hidden" id="ShowSerSelect" />

                        </td>
                    </tr>

                </tbody>
            </table>
        </div>

        <div class="Dialog Large" style="margin-left: 200px; margin-top: 100px; z-index: 100; height: 460px; width: 350px; display: none;" id="ShowTranPageDialog">
            <div style="background-color: #346a95; color: #fff; height: 35px;"><span id="_ctl4" class="TitleContainer" style="font-weight: bold; top: 7px; left: 10px; display: block; width: 85%; position: absolute; text-transform: uppercase; font-size: 15px; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-transform: uppercase;">库存转运</span></div>
            <div class="BlueberryMenuBar" style="margin-bottom: -5px;">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="TranItem()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -131px -33px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">保存</span></div>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="HiddenTranDiv()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -102px -1px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">关闭</span></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <table cellspacing="0" cellpadding="0" width="100%" border="0" style="margin-left: 10px;">
                <tbody>
                    <tr>
                        <td class="column" nowrap="" align="left" colspan="2">
                            <span id="lblPickFrom" class="lblNormalClass" style="font-weight: bold;">转运仓库：</span>
                            <span id="lblTranLocation" class="lblNormalClass" style="font-weight: normal; display: block; margin-top: -3px; font-size: 12px; color: #333333;"></span>
                            <input type="hidden" id="TranWareId" />
                        </td>
                    </tr>
                    <tr>
                        <td class="columnTextBox" nowrap="" align="left" colspan="2">
                            <span id="lblQuantityToPick" class="lblNormalClass" style="font-weight: bold;">拣货数量<font style="color: Red;"> *</font></span>
                            <br>
                            <span id="txtQuantityToPick" style="display: inline-block;">
                                <input name="TranNum" type="text" value="1" maxlength="10" id="TranNum" class="txtBlack8Class" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                <input type="hidden" id="TranMaxNum" />
                            </span>
                        </td>
                    </tr>
                    <tr class="HasSeraliNum">
                        <td class="dataSelectorLabelColumn" colspan="2" style="display: flex;"><span class="lblNormalClass" style="font-weight: bold;">序列号<font style="color: Red;"> *</font></span></td>
                    </tr>
                    <tr class="HasSeraliNum">
                        <td class="dataSelectorColumn" colspan="2" style="display: flex;">
                            <span id="selectorSerialNumbers" style="display: inline-block;">
                                <select size="4" name="selectorSerialNumbers:ATListBox" id="TranSnSelect" class="txtBlack8Class" style="height: 88px; width: 256px;" multiple="multiple">
                                </select>
                            </span>&nbsp;
                            <a href="#" id="" class="DataSelectorLinkIcon Multiple">
                                <img src="../Images/data-selector.png" style="vertical-align: middle;" id="ChoTranSerNum" onclick="ChooseTranSerNum()" />
                            </a>
                            <input type="hidden" name="serNumIds" id="TranSerNumIds" />
                            <input type="hidden" name="serNumIdsHidden" id="TranSerNumIdsHidden" />

                        </td>
                    </tr>
                    <tr>

                        <td class="dataSelectorLabelColumn" colspan="2" style="display: flex;"><span class="lblNormalClass" style="font-weight: bold;">转移这些库存到：</span></td>

                    </tr>
                    <tr>
                        <td class="radioColumn" align="left" colspan="2">
                            <span class="lblNormalClass" style="font-weight: 100">
                                <input id="chkTransforAccount" type="radio" name="Transfer" value="ToAccount"><label id="account_name"></label></span>
                            <input type="hidden" id="account_id" />
                        </td>
                    </tr>
                    <tr>
                        <td class="radioColumn" align="left" colspan="2">
                            <span class="lblNormalClass" style="font-weight: 100">
                                <input id="chkTransforMe" type="radio" name="Transfer" value="ToShipItem"><label for="chkDeliverShipItems">我</label></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="radioColumn" align="left" colspan="2">
                            <span class="lblNormalClass" style="font-weight: 100; display: flex;">
                                <input id="chkToLocation" type="radio" name="Transfer" value="ToShipItem" /><label for="chkDeliverShipItems">仓库</label></span>
                            <select id="tranLocation">
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="Dialog Large" style="margin-left: 200px; margin-top: 100px; z-index: 100; height: 580px; width: 350px; display: none;" id="ShowShipPageDialog">
            <div style="background-color: #346a95; color: #fff; height: 35px;"><span id="_ctl4" class="TitleContainer" style="font-weight: bold; top: 7px; left: 10px; display: block; width: 85%; position: absolute; text-transform: uppercase; font-size: 15px; font-weight: bold; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; text-transform: uppercase;">配送</span></div>
            <div class="BlueberryMenuBar" style="margin-bottom: -5px;">
                <table cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="ShipItem()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -131px -33px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">保存</span></div>
                                <div style="float: left; margin: 10px; min-width: 65px; background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%); height: 24px; padding-top: 5px;" onclick="HiddenShipDiv()"><span class="Icon" style="background: url(../Images/Icons.png) no-repeat -102px -1px; margin: 0px 5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span class="Text">关闭</span></div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div style="height: 500px; overflow-y: auto;">
                <div class="DivSection">
                    <table cellspacing="0" cellpadding="0" width="100%" border="0" style="margin-left: 10px;">
                        <tbody>
                            <tr>
                                <td class="column" nowrap="" align="left" colspan="2">
                                    <span id="lblPickFrom" class="lblNormalClass" style="font-weight: bold;">配送仓库：</span>
                                    <span id="lblShipLocation" class="lblNormalClass" style="font-weight: normal; display: block; margin-top: -3px; font-size: 12px; color: #333333;"></span>
                                    <input type="hidden" id="ShipWareId" />
                                </td>
                            </tr>
                            <tr>
                                <td class="columnTextBox" nowrap="" align="left" colspan="2">
                                    <span id="lblQuantityToPick" class="lblNormalClass" style="font-weight: bold;">配送数量<font style="color: Red;"> *</font></span>
                                    <br>
                                    <span id="txtQuantityToPick" style="display: inline-block;">
                                        <input name="ShipNum" type="text" value="1" maxlength="10" id="ShipNum" class="txtBlack8Class" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                        <input type="hidden" id="ShipMaxNum" />
                                    </span>
                                </td>
                            </tr>
                            <tr class="HasSeraliNum">
                                <td class="dataSelectorLabelColumn" colspan="2" style="display: flex;"><span class="lblNormalClass" style="font-weight: bold;">序列号<font style="color: Red;"> *</font></span></td>
                            </tr>
                            <tr class="HasSeraliNum">
                                <td class="dataSelectorColumn" colspan="2" style="display: flex;">
                                    <span id="selectorSerialNumbers" style="display: inline-block;">
                                        <select size="4" name="selectorSerialNumbers:ATListBox" id="ShipSnSelect" class="txtBlack8Class" style="height: 88px; width: 256px;" multiple="multiple">
                                        </select>
                                    </span>&nbsp;
                            <a href="#" id="" class="DataSelectorLinkIcon Multiple">
                                <img src="../Images/data-selector.png" style="vertical-align: middle;" id="ChoShipSerNum" onclick="ChooseShipSerNum()" />
                            </a>
                                    <input type="hidden" id="ShipSerNumIds" />
                                    <input type="hidden" id="ShipSerNumIdsHidden" />

                                </td>
                            </tr>
                            <tr>
                                <td valign="bottom" style="padding-left: 10px; padding-bottom: 16px; width: 190px">
                                    <span id="lblDeliverShipDate" class="lblNormalClass" style="font-weight: bold;">配送时间<font style="color: Red;"> *</font></span>
                                    <br />
                                    <span id="dtDeliverShipDate" style="display: inline-block;">
                                        <input name="ShipDate" type="text" value="" id="ShipDate" class="txtBlack8Class" style="width: 100px;" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm' })" /></span>
                                </td>
                                <td valign="bottom" style="width: 149px; padding-bottom: 16px;"></td>
                            </tr>
                            <tr>
                                <td class="columnTextBox" align="left" style="padding-bottom: 16px;" colspan="2">
                                    <span id="lblShippingType" class="lblNormalClass" style="font-weight: bold;">配送类型</span>
                                    <br />
                                    <span id="ddlShippingType" style="display: inline-block;">
                                        <select name="shipping_type_id" id="shipping_type_id" class="txtBlack8Class" style="width: 250px;">
                                        </select>

                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="columnTextBox" align="left" style="padding-bottom: 22px;" colspan="2">
                                    <span id="lblShippingReferenceNumber" class="lblNormalClass" style="font-weight: bold;">配送参考号</span>
                                    <br />
                                    <span id="txtShippingReferenceNumber" style="display: inline-block;">
                                        <input name="shipping_reference_number" type="text" maxlength="50" id="shipping_reference_number" class="txtBlack8Class" style="width: 250px;" />

                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="DivSection">
                    <table cellspacing="0" cellpadding="0" width="100%" border="0" style="margin-left: 10px;">
                        <tbody>
                            <tr>
                                <td class="column" align="left" colspan="2" style="padding-top: 7px;">
                                    <span id="lblShippingOptional" class="SectionLevelInstruction span" style="font-weight: normal;">为运输创建成本（可选）</span>
                                </td>
                            </tr>
                            <tr>
                                <td class="column" align="left" colspan="2">
                                    <span id="lblMaterialCostCode" class="lblNormalClass" style="font-weight: bold;">物料代码</span>
                                    <br />
                                    <span id="ddlMaterialCostCode" style="display: inline-block;">
                                        <select name="ShiCostCodeId" id="ShiCostCodeId" class="txtBlack8Class" style="width: 250px;">
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="column" align="left" colspan="2">
                                    <span id="lblBillableAmount" class="lblNormalClass" style="font-weight: bold;">计费金额</span>
                                    <br />
                                    <span id="txtBillableAmount" style="display: inline-block;">
                                        <input name="" type="text" value="0.00" maxlength="10" id="BillMoney" class="txtBlack8Class" style="width: 80px; text-align: right;"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />

                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 0px 3px 22px 10px;" align="left" colspan="2">
                                    <span id="lblOurCost" class="lblNormalClass" style="font-weight: bold;">成本</span>
                                    <br />
                                    <span id="txtOurCost" style="display: inline-block;">
                                        <input name="BillCost" type="text" value="0.00" maxlength="10" id="BillCost" class="txtBlack8Class" style="width: 80px; text-align: right;"  maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />

                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                </div>
            </div>

        </div>

        <div id="LoadingIndicator"></div>
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
    var colors = ["#efefef", "white"];
    var index1 = 0; var index2 = 0; var index3 = 0;
    $(".Toggle1").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index1 % 2]);
        index1++;
    });
    $(".Toggle2").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index2 % 2]);
        index2++;
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

        <%if ((!isAdd) && (conCost.status_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.IN_PURCHASING || conCost.status_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.PENDING_DELIVERY || conCost.status_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.ALREADY_DELIVERED))
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
        <%if ((!isAdd) && conCost.bill_status != null && conCost.bill_status == 1)
    { %>
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
        <%if (!isAdd && conCost.product_id != null)
    { %>
        GetStillNeed();
        ShowProductPickInfo();

        $.ajax({
            type: "GET",
            async: false,
            dataType: "json",
            url: "../Tools/ProductAjax.ashx?act=product&product_id=<%=conCost!=null&&conCost.product_id!=null?conCost.product_id.ToString():"" %>",
            success: function (data) {
                if (data != "") {
                    if (data.is_serialized == "0") {
                        $(".HasSeraliNum").hide();
                        $("#ShowSerSelect").val("");
                    } else {
                        $(".HasSeraliNum").show();
                        $("#ShowSerSelect").val("1");
                    }
                }
            },
        });

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
    $("#change_order_hours").blur(function () {
        var change_order_hours = $(this).val();
        if (change_order_hours != "" && (!isNaN(change_order_hours))) {
            change_order_hours = toDecimal4(change_order_hours);
            $(this).val(change_order_hours);

        }
        else {
            $(this).val("0.0000");
        }

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
    $("#save_close").click(function () {
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
                        $("#name").val(data.name);
                        GetSumCost();
                        GetSumAmount();
                        $("#status_id").val(<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_STATUS.PENDING_PURCHASE %>);
                        // 
                        if (data.is_serialized == "0") {
                            $(".HasSeraliNum").hide();
                        } else {
                            $(".HasSeraliNum").show();
                        }
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
            // 展示库存信息
            GetStillNeed();
            
            // 获取单元成本
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
                        $("#unit_cost").val(toDecimal4(data));
                        // $("#unit_cost").val(data);
                        // Markup();
                        GetSumCost();
                    }
                },
            });
            <%}%>



        }
    }
    // costIdHidden  costId

    function ChooseCostCode() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE %>&field=costId&callBack=GetDataByCostCode", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CostCodeSelect %>', 'left=200,top=200,width=600,height=800', false);
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
        debugger;
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
        <%if (thisTask != null)
    { %>
        //var change_order_hours = $("#change_order_hours").val();
        //if (change_order_hours == "") {
        //    alert("请填写变更时间！");
        //    return false;
        //}

        <%}%>
        return true;
    }
    // 根据产品Id 获取仍需数量
    function GetStillNeed() {

        var product_id = $("#product_idHidden").val();
        if (product_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetPageWare&product_id=" + product_id,
                success: function (data) {
                    if (data != "") {
                        var pageHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            pageHtml += "<tr><td>" + data[i].wareName + "</td><td>" + data[i].onHand + "</td><td>" + data[i].picked + "</td><td>" + data[i].available + "</td>";
                             <% if (!isAdd && conCost.quantity != 0)
                             { %>
                            pageHtml += "<td>";
                            if (Number(data[i].available) > 0) {
                                pageHtml += "<a onclick=\"ShowPickedPage('" + data[i].ware_id + "','" + data[i].wareName + "','" + data[i].available+"')\">拣货</a>";
                                pageHtml += "<input type='hidden' id='" + data[i].ware_id + "_pick_avail' value='" + data[i].available + "'/>";
                            }

                            pageHtml += "</td>";
                             <%} %>
                            pageHtml += "</tr>";
                        }
                        $("#StillNeedNumber").html(pageHtml);
                        $("#AssignSectionHeader").show();
                    } else {
                        $("#AssignSectionHeader").hide();
                    }
                },
                error: function (data) {
                    $("#AssignSectionHeader").hide();
                },
            });
        } else {
            $("#AssignSectionHeader").hide();
        }
    }
    // 展示拣货弹出框
    function ShowPickedPage(ware_id, ware_name, available) {
          <%if (isAdd)
    { %>
        LayerMsg("请先进行保存");
        <%}
    else
    {%>
        var quantity = $("#quantity").val();
        var oldQuan = '<%=conCost!=null&&conCost.quantity!=null?((decimal)conCost.quantity).ToString():"" %>';
        if (oldQuan != quantity) {
            LayerMsg("数量发生变更，请先进行保存再拣货");
            return false;
        }
        else {
            var needNum = $("#NeedNum").html();
            if (Number(quantity) < Number(needNum)) {
                $("#PickNum").val(parseInt(quantity));
            }
            else {
                $("#PickNum").val(parseInt(needNum));
            }
            
            $("#BackgroundOverLay").show();
            $("#ShoePickPageDialog").show();
            $("#lblFromLocation").html(ware_name);
            $("#pickWareId").val(ware_id);
        // $("#ShoePickPageDialog").show();
        }
        
        <%}%>

    }
    function HiddenPickDiv() {
        $("#BackgroundOverLay").hide();
        $("#ShoePickPageDialog").hide();
        $("#lblFromLocation").html("");
        $("#pickWareId").val("");
    }

    // 产品序列号查找带回
    function ChooseSerNum() {
        // serNumIds
        var wareId = $("#pickWareId").val();
        var productId = $("#product_idHidden").val();
        if (wareId != "" && productId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERNUM_CALLBACK %>&muilt=1&field=serNumIds&con1172=" + productId + "&con1173=" + wareId + "&callBack=GetDataBySerNumIds", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SERNUM_CALLBACK %>', 'left=200,top=200,width=600,height=800', false);
        } else {
            LayerMsg("未找到仓库或产品相关信息");
        }
    }
    // 根据序列号Id获取序列号相关信息
    function GetDataBySerNumIds() {
        // GetSnListByIds
        var serNumIds = $("#serNumIdsHidden").val();
        if (serNumIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetSnListByIds&snIds=" + serNumIds,
                success: function (data) {
                    if (data != "") {
                        var selSnHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            selSnHtml += "<option value='" + data[i].id + "'>" + data[i].sn + "</option>";
                        }
                        $("#SnSelect").html(selSnHtml);
                        $("#SnSelect option").dblclick(function () {
                            RemoveSn(this);
                        })
                    } else {
                        $("#SnSelect").html("");
                    }
                },
            });
        }
    }
    //  拣货操作
    function PickItem() {
        var wareId = $("#pickWareId").val();
        var productId = $("#product_idHidden").val();
        if (wareId != "") {
            debugger;
            var pickNum = $("#PickNum").val();
            var thisWareUserNum = $("#" + wareId + "_pick_avail").val();
            if (pickNum == "") {
                LayerMsg("请填写拣货数量");
                return false;
            }
            if (Number(pickNum) > Number(thisWareUserNum)) {
                LayerMsg("拣货数量不能大于可用数量");
                return false;
            }
            if (Number(pickNum) <= 0) {
                LayerMsg("拣货数量要大于0");
                return false;
            }
            var serNumIds = "";
            var isShow = $("#ShowSerSelect").val();
            if (isShow == "") {

            } else {
                serNumIds = $("#serNumIdsHidden").val();
                if (serNumIds == "") {
                    LayerMsg("请选择产品相关序列号");
                    return false;
                }
                var serNumArr = serNumIds.split(',');
                if (serNumArr.length != pickNum) {
                    LayerMsg("查找带回的序列号数量要与拣货数量相等");
                    return false;
                }
            }
            var tranType = "wareHouse";
            if ($("#chkTransferToMe").is(":checked")) {
                tranType = "toMe";
            }
            else if ($("#chkDeliverShipItems").is(":checked")) {
                tranType = "toItem";
            }
            var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
            if (costId == "") {
                LayerMsg("请保存之后进行操作");
                return false;
            }
            //var costProId = $("#ShowCostProId").val();
           // $("#BackgroundOverLay").show();
            $("#LoadingIndicator").show();
            $("#ShoePickPageDialog").hide();
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=PickProduct&product_id=" + productId + "&ware_id=" + wareId + "&pickNum=" + pickNum + "&serNumIds=" + serNumIds + "&tranType=" + tranType + "&cost_id=" + costId ,
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            if (data.reason) {
                                LayerConfirm("是否将销售订单状态改为已完成", "是", "否", function () { ChangeSaleStatus(); }, function () {
                                    LayerMsg("拣货成功");
                                    history.go(0); });

                            } else {
                                LayerMsg("拣货成功");
                                history.go(0);
                            }
                        }
                        else {
                            LayerMsg("拣货失败");
                            history.go(0);
                        }
                    }
                  
                },
            });


            // return true;
        }
    }
    function ChangeSaleStatusDone()
    {
        var costId = "<%=conCost==null?"":conCost.id.ToString() %>";
        $.ajax({
            type: "GET",
            async: false,
           //  dataType: "json",
            url: "../Tools/ProductAjax.ashx?act=DoneCostSale&&costId=" + costId,
            success: function (data) {
                if (data != "") {
                    if (data == "True") {
                        LayerMsg("修改销售订单状态成功");
                    }
                    else {
                        LayerMsg("修改销售订单状态成功");
                    }
                    history.go(0);
                }

            },
        });
    }

    function RemoveSn(val) {
        $(val).remove();
        var ids = "";
        $("#SnSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#serNumIdsHidden").val(ids);
    }
    // 取消拣货 - 保存操作
    function UnPickItem() {
        // UnPickSerNumIdsHidden
        var UnPickNum = $("#UnPickNum").val();
        if (UnPickNum == "") {
            LayerMsg("请填写取消拣货数量");
            return false;
        }
        var maxNumber = $("#UnPickMaxNumber").val();
        if (Number(UnPickNum) <= 0 || Number(UnPickNum) > Number(maxNumber)) {
            LayerMsg("取消拣货数量超出指定范围");
            return false;
        }
        var unPickIds = "";
        var isShow = $("#ShowSerSelect").val();
        if (isShow == "") {
           
        }
        else {
            unPickIds = $("#UnPickSerNumIdsHidden").val();
            var unPickArr = unPickIds.split(',');
            if (Number(UnPickNum) != unPickArr.length) {
                LayerMsg("取消拣货数量需要与选择的序列号数量一致");
                return false;
            }

        }
        var ware_id = $("#UnPickWareId").val();
        var productId = $("#product_idHidden").val();
        var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
        var costProId = $("#ShowCostProId").val();
        // $("#BackgroundOverLay").show();
        $("#LoadingIndicator").show();
        $("#ShowUnPickPageDialog").hide();
        $.ajax({
            type: "GET",
            async: false,
           // dataType: "json",
            url: "../Tools/ProductAjax.ashx?act=UnPickProduct&product_id=" + productId + "&ware_id=" + ware_id + "&unPickNum=" + UnPickNum + "&SerSnIds=" + unPickIds + "&costId=" + costId + "&costProId=" + costProId,
            success: function (data) {
                if (data != "") {
                    if (data == "True") {
                        LayerMsg("取消拣货成功");
                    } else {
                        LayerMsg("取消拣货失败");
                    }
                }
                history.go(0);
            },
        });



        // return true;
    }
    function HiddenUnPickDiv() {
        $("#BackgroundOverLay").hide();
        $("#ShowUnPickPageDialog").hide();
    }
    // 显示取消拣货 div
    function ShowUnPickDiv(ware_id, wareName, quantity, cost_pro_id) {
        var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
        if (costId != "" && ware_id != "") {
            $("#BackgroundOverLay").show();
            $("#ShowUnPickPageDialog").show();
            $("#UnPickWareId").val(ware_id);
            $("#unPickWareName").html(wareName);
            $("#UnPickNum").val(quantity);
            $("#UnPickMaxNumber").val(quantity);
            // 根据仓库和成本id 获取选择的序列号信息
            $("#ShowCostProId").val(cost_pro_id);
            // GetWareSnByCostWare
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetWareSnByCostWare&cost_pro_id=" + cost_pro_id,
                success: function (data) {
                    if (data != "") {
                        var ids = "";
                        var selSnHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            ids += data[i].id + ",";
                            selSnHtml += "<option value='" + data[i].id + "'>" + data[i].sn + "</option>";
                        }
                        if (ids != "") {
                            ids = ids.substring(0, ids.length - 1);
                            $("#UnPickSerNumIdsHidden").val(ids);
                        }
                        $("#UnPickSnSelect").html(selSnHtml);
                        $("#UnPickSnSelect option").dblclick(function () {
                            RemoveInPickSn(this);
                        })

                    }
                },
            });
        }

    }
    // 显示库存转运的Div
    function ShowTransDiv(ware_id, wareName, quantity, cost_pro_id) {
        var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
        if (costId != "" && ware_id != "") {
            // ShowTranPageDialog
            $("#BackgroundOverLay").show();
            $("#ShowTranPageDialog").show();
            $("#TranWareId").val(ware_id);
            $("#lblTranLocation").html(wareName);
            $("#TranNum").val(quantity);
            $("#TranMaxNum").val(quantity);
            $("#chkTransforAccount").prop("checked", true);
            $("#tranLocation").prop("disabled", true);
            $("#ShowCostProId").val(cost_pro_id);
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetWareSnByCostWare&cost_pro_id=" + cost_pro_id,
                success: function (data) {
                    if (data != "") {
                        var ids = "";
                        var selSnHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            ids += data[i].id + ",";
                            selSnHtml += "<option value='" + data[i].id + "'>" + data[i].sn + "</option>";
                        }
                        if (ids != "") {
                            ids = ids.substring(0, ids.length - 1);
                            $("#TranSerNumIdsHidden").val(ids);
                        }
                        $("#TranSnSelect").html(selSnHtml);
                        $("#TranSnSelect option").dblclick(function () {
                            RemoveTranSn(this);
                        })

                    }
                },
            });

            // GetCostAccount
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ContractAjax.ashx?act=GetCostAccount&cost_id=" + costId,
                success: function (data) {
                    if (data != "") {
                        $("#account_id").val(data.id);
                        $("#account_name").html(data.name);
                    }
                },
            });

            // GetLocationList
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/InventoryLocationAjax.ashx?act=GetLocationList&ware_id=" + ware_id,
                success: function (data) {
                    if (data != "") {
                        var loHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            loHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                        $("#tranLocation").html(loHtml);
                    }
                    else {
                        $("#tranLocation").html(loHtml);
                    }
                },
                error: function (data) {
                    $("#tranLocation").html(loHtml);
                },
            });
        }
    }

    function ShowShipDiv(ware_id, wareName, quantity, cost_pro_id) {
        var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
        if (costId != "" && ware_id != "") {
            $("#ShowShipPageDialog").show();
            $("#BackgroundOverLay").show();
            $("#ShipWareId").val(ware_id);
            $("#lblShipLocation").html(wareName);
            $("#ShipNum").val(quantity);
            $("#ShipMaxNum").val(quantity);
            $("#ShowCostProId").val(cost_pro_id);
            $("#ShipDate").val(getDate24Hours());

            // 物料代码  配送类型赋值
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/GeneralAjax.ashx?act=GetCostCodeByType&type_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.MATERIAL_COST_CODE %>",
                success: function (data) {
                    var shipHtml = "<option value=''></option>";
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            shipHtml += "<option value='" + data[i].id + "'>" + data[i].name+"</option>";
                        }
                    }
                    $("#ShiCostCodeId").html(shipHtml);
                },
                error: function (data) {
                    $("#ShiCostCodeId").html("<option value=''></option>");
                },
            });

            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/GeneralAjax.ashx?act=GetGenListByTableId&table_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.PAYMENT_SHIP_TYPE %>",
                success: function (data) {
                    var shipHtml = "<option value=''></option>";
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            shipHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                    $("#shipping_type_id").html(shipHtml);
                },
                error: function (data) {
                    $("#shipping_type_id").html("<option value=''></option>");
                },
            });

            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetWareSnByCostWare&cost_pro_id=" + cost_pro_id,
                success: function (data) {
                    if (data != "") {
                        var ids = "";
                        var selSnHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            ids += data[i].id + ",";
                            selSnHtml += "<option value='" + data[i].id + "'>" + data[i].sn + "</option>";
                        }
                        if (ids != "") {
                            ids = ids.substring(0, ids.length - 1);
                            $("#ShipSerNumIdsHidden").val(ids);
                        }
                        $("#ShipSnSelect").html(selSnHtml);
                        $("#ShipSnSelect option").dblclick(function () {
                            RemoveShipSn(this);
                        })

                    }
                },
            });
        }

    }
    // 返回当前时间（yyyy-MM-dd HH:mm）
    function getDate24Hours() {
        var myDate = new Date();
        var years = myDate.getFullYear();
        var month = myDate.getMonth();
        var day = myDate.getDay();
        var hours = myDate.getHours();
        var minutes = myDate.getMinutes();
        var seconds = myDate.getSeconds();
        if (month < 10) {
            month = "0" + month;
        }
        if (day < 10) {
            day = "0" + day;
        }
        if (hours < 10) {
            hours = "0" + hours;
        }
        if (minutes < 10) {
            minutes = "0" + minutes;
        }
        if (seconds < 10) {
            seconds = "0" + seconds;
        }
        var time = years + '-' + month + '-' + day + ' ' + hours + ':' + minutes;
        //console.log("24-hours:" + time);
        return time;
    }
    function RemoveTranSn(val) {
        $(val).remove();
        var ids = "";
        $("#TranSnSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#TranSerNumIdsHidden").val(ids);
    }
    // 取消拣货的多选查找带回
    function ChooseInPickSerNum() {
        // UnPickSerNumIds
        var wareId = $("#UnPickWareId").val();
        var productId = $("#product_idHidden").val();
        if (wareId != "" && productId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERNUM_CALLBACK %>&muilt=1&field=UnPickSerNumIds&con1172=" + productId + "&con1173=" + wareId + "&callBack=GetUnPickDataBySerNumIds", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SERNUM_CALLBACK %>', 'left=200,top=200,width=600,height=800', false);
        } else {
            LayerMsg("未找到仓库或产品相关信息");
        }
    }

    function ChooseTranSerNum() {
        var wareId = $("#TranWareId").val();
        var productId = $("#product_idHidden").val();
        if (wareId != "" && productId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERNUM_CALLBACK %>&muilt=1&field=UnPickSerNumIds&con1172=" + productId + "&con1173=" + wareId + "&callBack=GetTranDataBySerNumIds", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SERNUM_CALLBACK %>', 'left=200,top=200,width=600,height=800', false);
        } else {
            LayerMsg("未找到仓库或产品相关信息");
        }
    }
    function ChooseShipSerNum() {
        // ShipSerNumIdsHidden
        var wareId = $("#TranWareId").val();
        var productId = $("#product_idHidden").val();
        if (wareId != "" && productId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERNUM_CALLBACK %>&muilt=1&field=ShipSerNumIds&con1172=" + productId + "&con1173=" + wareId + "&callBack=GetShipDataBySerNumIds", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SERNUM_CALLBACK %>', 'left=200,top=200,width=600,height=800', false);
        } else {
            LayerMsg("未找到仓库或产品相关信息");
        }
    }

    function GetShipDataBySerNumIds() {
        var serNumIds = $("#ShipSerNumIdsHidden").val();
        if (serNumIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetSnListByIds&snIds=" + serNumIds,
                success: function (data) {
                    if (data != "") {
                        var selSnHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            selSnHtml += "<option value='" + data[i].id + "'>" + data[i].sn + "</option>";
                        }
                        $("#ShipSnSelect").html(selSnHtml);
                        $("#ShipSnSelect option").dblclick(function () {
                            RemoveShipSn(this);
                        })
                    } else {
                        $("#ShipSnSelect").html("");
                    }
                },
            });
        }
    }

    function GetUnPickDataBySerNumIds() {
        var serNumIds = $("#UnPickSerNumIdsHidden").val();
        if (serNumIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetSnListByIds&snIds=" + serNumIds,
                success: function (data) {
                    if (data != "") {
                        var selSnHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            selSnHtml += "<option value='" + data[i].id + "'>" + data[i].sn + "</option>";
                        }
                        $("#UnPickSnSelect").html(selSnHtml);
                        $("#UnPickSnSelect option").dblclick(function () {
                            RemoveInPickSn(this);
                        })
                    } else {
                        $("#UnPickSnSelect").html("");
                    }
                },
            });
        }
    }
    function GetTranDataBySerNumIds() {
        var serNumIds = $("#TranSerNumIdsHidden").val();
        if (serNumIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=GetSnListByIds&snIds=" + serNumIds,
                success: function (data) {
                    if (data != "") {
                        var selSnHtml = "";
                        for (var i = 0; i < data.length; i++) {
                            selSnHtml += "<option value='" + data[i].id + "'>" + data[i].sn + "</option>";
                        }
                        $("#TranSnSelect").html(selSnHtml);
                        $("#TranSnSelect option").dblclick(function () {
                            RemoveTranSn(this);
                        })
                    } else {
                        $("#TranSnSelect").html("");
                    }
                },
            });
        }
    }
    function RemoveInPickSn(val) {
        $(val).remove();
        var ids = "";
        $("#UnPickSnSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#UnPickSerNumIdsHidden").val(ids);
    }
    function RemoveShipSn(val) {
        $(val).remove();
        var ids = "";
        $("#ShipSnSelect option").each(function () {
            ids += $(this).val() + ',';
        })
        if (ids != "") {
            ids = ids.substr(0, ids.length - 1);
        }
        $("#ShipSerNumIdsHidden").val(ids);
    }

    function TranItem() {
        var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
        if (costId == "") {
            LayerMsg("请保存后进行操作");
            return false;
        }
        var wareId = $("#TranWareId").val();
        if (wareId == "") {
            LayerMsg("未找到仓库信息，请重新打开");
        }
        var TranNum = $("#TranNum").val();
        if (TranNum == "") {
            LayerMsg("请填写库存转运数量");
            return false;
        }
        var maxNumber = $("#TranMaxNum").val();
        if (Number(TranNum) <= 0 || Number(TranNum) > Number(maxNumber)) {
            LayerMsg("库存转运数量超出指定范围");
            return false;
        }
        var tranSerIds = "";
        var isShow = $("#ShowSerSelect").val();
        if (isShow == "") {

        } else {
            tranSerIds = $("#TranSerNumIdsHidden").val();
            var tranSerArr = tranSerIds.split(',');
            if (Number(TranNum) != tranSerArr.length) {
                LayerMsg("库存转运数量需要与选择的序列号数量一致");
                return false;
            }

        }
        var tranType = "";
        var account_id = $("#account_id").val();
        var tranLocation = $("#tranLocation").val();
        if ($("#chkTransforAccount").is(":checked")) {
            if (account_id == "") {
                LayerMsg("客户信息丢失");
                return false;
            }
            tranType = "ToAccount";
        } else if ($("#chkTransforMe").is(":checked")) {
            tranType = "ToMe";
        } else if ($("#chkToLocation").is(":checked")) {
            if (tranLocation == "" || tranLocation == null || tranLocation == undefined) {
                LayerMsg("请选择需要转移的仓库");
                return false;
            }
            tranType = "ToLocation";
        }
        if (tranType == "") {
            LayerMsg("请选择转运方式");
            return false;
        }
        var productId = $("#product_idHidden").val();
        if (productId == "") {
            LayerMsg("请通过查找带回选择产品");
            return false;
        }
        var costProId = $("#ShowCostProId").val();
        // $("#BackgroundOverLay").show();
        $("#LoadingIndicator").show();
        $("#ShowTranPageDialog").hide();
        $.ajax({
            type: "GET",
            async: false,
            // dataType: "json",
            url: "../Tools/ProductAjax.ashx?act=TransferPro&product_id=" + productId + "&ware_id=" + wareId + "&tranNum=" + TranNum + "&SerSnIds=" + tranSerIds + "&costId=" + costId + "&account_id=" + account_id + "&location_id=" + tranLocation + "&tranType=" + tranType + "&costProId=" + costProId,
            success: function (data) {
                if (data != "") {
                    if (data == "True") {
                        LayerMsg("库存转运成功");
                    }
                    else {
                        LayerMsg("库存转运失败");
                    }
                }
                history.go(0);
            },
        });
    }
    $("#chkTransforAccount").click(function () {
        if ($(this).is(":checked")) {
            $("#tranLocation").prop("disabled", true);
        }
    })
    $("#chkTransforMe").click(function () {
        if ($(this).is(":checked")) {
            $("#tranLocation").prop("disabled", true);
        }
    })

    $("#chkToLocation").click(function () {
        if ($(this).is(":checked")) {
            $("#tranLocation").prop("disabled", false);
        }
    })
    function HiddenTranDiv() {
        $("#ShowTranPageDialog").hide();
        $("#BackgroundOverLay").hide();
        $("#TranWareId").val("");
    }


    // 显示改成本的已拣货相关信息
    function ShowProductPickInfo() {
        // PickedTbody
        // GetCostPickedInfo
        var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
        if (costId == "") {
            LayerMsg("请保存之后进行操作");
            return false;
        }
        $.ajax({
            type: "GET",
            async: false,
            dataType: "json",
            url: "../Tools/ProductAjax.ashx?act=GetCostPickedInfo&cost_id=" + costId,
            success: function (data) {
                if (data != "") {
                    var pickHtml = "";
                    var shipNum = 0;
                    for (var i = 0; i < data.length; i++) {
                        shipNum += Number(data[i].quantity);
                        pickHtml += "<tr><td>" + data[i].wareName + "</td><td>" + (data[i].sn == null ? "" : data[i].sn) + "</td><td>" + data[i].quantity + "</td><td>" + (data[i].vendorNo == null ? "" : data[i].vendorNo) + "</td><td>" + data[i].statusName + "</td>";

                        <%--if (data[i].statusId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_COST_PRODUCT_STATUS.PICKED %>' || data[i].statusId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER %>')--%>
                        if (data[i].statusId != '<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION %>')
                        {
                            pickHtml += "<td><a onclick=\"ShowUnPickDiv('" + data[i].ware_id + "','" + data[i].wareName + "','" + data[i].quantity + "','" + data[i].cost_pro_id +"')\">取消拣货</a></td>";
                        } else {
                            pickHtml += "<td></td>";
                        }
                    <%--    //if (data[i].statusId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_COST_PRODUCT_STATUS.PICKED %>' || data[i].statusId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER %>')--%>
                            if (data[i].statusId != '<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION %>'){
                            pickHtml += "<td><a onclick=\"ShowTransDiv('" + data[i].ware_id + "','" + data[i].wareName + "','" + data[i].quantity + "','" + data[i].cost_pro_id +"')\">库存转移</a></td>";
                        } else {
                            pickHtml += "<td></td>";
                        }
                        if (data[i].statusId == '<%=(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION %>') {
                            pickHtml += "<td><a onclick=\"UnShipItem('" + data[i].cost_pro_id +"')\">取消配送</a></td>"; 
                        } else {
                            pickHtml += "<td><a  onclick=\"ShowShipDiv('" + data[i].ware_id + "','" + data[i].wareName + "','" + data[i].quantity + "','" + data[i].cost_pro_id +"')\">配送</a></td>";
                        }
                        // 
                        pickHtml += "<td></td></tr>";
                    }
                    var NeedNum = $("#NeedNum").html();
                    if (NeedNum != "")
                    {
                        if (Number(shipNum) == Number(NeedNum)) {
                            $("#AssignSectionHeader").hide();
                        } else {
                            $("#NeedNum").html((Number(NeedNum) - Number(shipNum)));
                        }
                        $("#pickedNum").html(Number(shipNum));
                    }
                    if (Number(shipNum) == 0) {
                        $("#ShowPiecedDiv").hide();
                    }
                    if ((Number(NeedNum) - Number(shipNum)) == 0) {
                        $("#AssignSectionHeader").hide();
                    }

                    $("#PickedTbody").html(pickHtml);
                    $("#ShowPiecedDiv").show();
                }
                else {
                    $("#ShowPiecedDiv").hide();
                }
            },
            error: function (data) {
                $("#ShowPiecedDiv").hide();
            },
        });

    }
    function ShipItem() {
        var wareId = $("#ShipWareId").val();
        var costId = '<%=conCost==null?"":conCost.id.ToString() %>';
        var productId = $("#product_idHidden").val();
        if (productId == "") {
            LayerMsg("请通过查找带回选择产品");
            return false;
        }
        var ShipNum = $("#ShipNum").val();
        if (ShipNum == "") {
            LayerMsg("请填写配送数量");
            return false;
        }
        var maxNumber = $("#ShipMaxNum").val();
        if (Number(ShipNum) <= 0 || Number(ShipNum) > Number(maxNumber)) {
            LayerMsg("配送数量超出指定范围");
            return false;
        }
        var shipSerIds = "";
        var isShow = $("#ShowSerSelect").val();
        if (isShow == "") {

        } else {
            shipSerIds = $("#ShipSerNumIdsHidden").val();
            var shipSerArr = shipSerIds.split(',');
            if (Number(ShipNum) != shipSerArr.length) {
                LayerMsg("配送数量需要与选择的序列号数量一致");
                return false;
            }
        }

        var ShipDate = $("#ShipDate").val();
        if (ShipDate == "") {
            LayerMsg("请填写配送时间");
            return false;
        }
        var shipping_type_id = $("#shipping_type_id").val();
        var shipping_reference_number = $("#shipping_reference_number").val();
        var ShipCostCodeId = $("#ShiCostCodeId").val();
        var BillMoney = $("#BillMoney").val();
        var BillCost = $("#BillCost").val();
        var costProId = $("#ShowCostProId").val();
        // $("#BackgroundOverLay").show();
        $("#LoadingIndicator").show();
        $("#ShowShipPageDialog").hide();
        $.ajax({
            type: "GET",
            async: false,
            // dataType: "json",
            url: "../Tools/ProductAjax.ashx?act=ShipItem&cost_id=" + costId + "&wareId=" + wareId + "&productId=" + productId + "&ShipNum=" + ShipNum + "&shipSerIds=" + shipSerIds + "&ShipDate=" + ShipDate + "&shipping_type_id=" + shipping_type_id + "&shipping_reference_number=" + shipping_reference_number + "&ShipCostCodeId=" + ShipCostCodeId + "&BillMoney=" + BillMoney + "&BillCost=" + BillCost + "&costProId=" + costProId,
            success: function (data) {
                if (data == "True") {
                    LayerMsg("配送成功");
                   
                } else {
                    LayerMsg("配送失败");
                }
                history.go(0);
            },
        });



    }
    function HiddenShipDiv() {
        $("#BackgroundOverLay").hide();
        $("#ShowShipPageDialog").hide();
    }

    function UnShipItem(costPro) {

        LayerConfirm("确定要取消配送这些条目吗？", "是", "否", function () {
            $("#BackgroundOverLay").show();
            $("#LoadingIndicator").show();
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ProductAjax.ashx?act=UnShipItem&costProId=" + costPro,
                success: function (data) {
                    if (data != "") {
                        if (data.result) {
                            if (!data.reason) {
                                LayerMsg("相关运费成本已经审批，无法删除");
                            }
                            else {
                                LayerMsg("取消配送成功");
                            }
                        }
                        history.go(0);
                    }

                },
            }); }, function () { });

    

    }


</script>
