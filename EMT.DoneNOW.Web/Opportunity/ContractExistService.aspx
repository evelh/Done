﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractExistService.aspx.cs" Inherits="EMT.DoneNOW.Web.Opportunity.ContractExistService" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
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

        .TitleBarNavigationButton {
            float: left;
            width: 26px;
            padding-right: 10px;
            font-size: 12px;
            line-height: 33px;
            margin-left: 10px;
        }

            .TitleBarNavigationButton > .buttons {
                padding: 0 4px 0 4px;
                background: #d7d7d7;
                background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                border: 1px solid #bcbcbc;
                display: inline-block;
                color: #4F4F4F;
                cursor: pointer;
                position: relative;
                text-decoration: none;
                vertical-align: middle;
                height: 24px;
                line-height: 24px;
            }

                .TitleBarNavigationButton > .buttons > img {
                    margin: 4px 0 0 0;
                }

        .text2 {
            margin-left: 5px;
            float: left;
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
            background-image: url("../img/save.png");
        }

        .Cancel {
            background-image: url("../img/cancel.png");
        }

        .New {
            background-image: url("../img/add.png");
        }

        .Ok {
            background-image: url("../img/ok.png");
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
        /*切换内容*/
        .DivSection {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 12px 28px 4px 28px;
        }

            .DivSection.Tab {
                margin-top: 10px;
            }

            .DivSection div, .DivSectionWithHeader .Content div {
                padding-bottom: 17px;
            }

            .DivSection > table {
                border: 0;
                margin: 0;
                border-collapse: collapse;
            }

            .DivSection .FieldLabels {
                padding-bottom: 0px;
            }

            .DivSection td {
                padding: 0;
                text-align: left;
            }

        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

        .errorSmall {
            font-size: 12px;
            color: #E51937;
            margin-left: 3px;
            text-align: center;
        }

        #txtBlack8 {
            font-size: 12px;
            color: #333;
            font-weight: 100;
        }

        input[type=checkbox] {
            vertical-align: middle;
            cursor: pointer;
            padding: 0;
            margin: 0 3px 0 0;
        }

        .DivSection .FieldLabels div, .DivSection td[class="fieldLabels"] div, .DivSectionWithHeader td[class="fieldLabels"] div {
            margin-top: 1px;
            padding-bottom: 21px;
            font-weight: 100;
        }

        .txtBlack8Class {
            font-size: 12px;
            color: #333;
            font-weight: normal;
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

        textarea {
            padding: 6px;
            resize: vertical;
        }

        select {
            height: 24px;
            padding: 0;
        }

        .lblNormalClass {
            font-weight: 700;
            font-size: 12px;
            color: #4F4F4F;
        }

        .grid {
            font-size: 12px;
            background-color: #FFF;
        }

            .grid table {
                border-bottom-color: #98b4ca;
            }

            .grid table {
                border-collapse: collapse;
                width: 100%;
                border-bottom-width: 1px;
                border-bottom-style: solid;
            }

            .grid thead {
                background-color: #cbd9e4;
            }

                .grid thead tr td {
                    background-color: #cbd9e4;
                    border-color: #98b4ca;
                    color: #64727a;
                }

                .grid thead td {
                    border-width: 1px;
                    border-style: solid;
                    font-size: 13px;
                    font-weight: bold;
                    height: 19px;
                    padding: 4px 4px 4px 4px;
                    word-wrap: break-word;
                    vertical-align: top;
                }

            .grid tbody tr td:first-child, .grid tfoot tr td:first-child {
                border-left-color: #98b4ca;
            }

            .grid tbody td {
                border-width: 1px;
                border-style: solid;
                border-left-color: #F8F8F8;
                border-right-color: #F8F8F8;
                border-top-color: #e8e8e8;
                border-bottom-width: 0;
                padding: 4px 4px 4px 4px;
                vertical-align: top;
                word-wrap: break-word;
                font-size: 12px;
                color: #333;
            }

        .GridContainer {
            margin: 0 10px 10px 10px;
        }

        .GridBottomBorder, .GridContainer {
            border-color: #98b4ca;
        }

        .ButtonCollectionBase, .datagrid .ButtonCollectionBase, .BlueberryMenuBar {
            height: 28px;
            background-color: #FFF;
            border: none;
            margin: 0;
            padding: 0 10px 10px 10px;
        }

        .dataGridBody, .dataGridAlternating, .dataGridGroupBreak, .dataGridBodyHighlight {
            background-color: white;
            border-left-width: 0;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            font-size: 12px;
            color: #333;
            text-decoration: none;
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

            .dataGridBody tr, .dataGridBodyHover tr, .dataGridAlternating tr, .dataGridAlternatingHover tr, .dataGridBodyHighlight tr, .dataGridGroupBreak tr {
                height: 22px;
            }

        .dataGridHeader {
            background-color: #cbd9e4;
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

        .dataGridHeader td, .dataGridHeader th, tr.dataGridHeader td, tr.dataGridHeader th {
            border-color: #98b4ca;
            background-color: #cbd9e4;
            color: #64727a;
            border-width: 1px;
            border-style: solid;
        }

            .dataGridHeader td span {
                font-weight: bold !important;
                font-size: 13px;
            }

        .dataGridBody td:first-child, .dataGridAlternating td:first-child, .dataGridBodyHover td:first-child, .dataGridAlternatingHover td:first-child, .dataGridDisabled td:first-child, .dataGridDisabledHover td:first-child {
            border-left-color: #98b4ca;
        }

        .dataGridBody td:last-child, .dataGridAlternating td:last-child, .dataGridBodyHover td:last-child, .dataGridAlternatingHover td:last-child, .dataGridDisabled td:last-child, .dataGridDisabledHover td:last-child {
            border-right-color: #98b4ca;
        }

        .dataGridBody td, .dataGridAlternating td, .dataGridBodyHover td, .dataGridAlternatingHover td, .dataGridDisabled td, .dataGridDisabledHover td {
            border-width: 1px;
            border-style: solid;
            border-left-color: #F8F8F8;
            border-right-color: #F8F8F8;
            border-top-color: #e8e8e8;
            border-bottom-width: 0;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: top;
            padding: 4px;
            word-wrap: break-word;
        }

        .QuickSearchButton {
            font-size: 12px;
            color: #C9C9C9;
            text-align: right;
            margin-right: 10px;
        }

            .QuickSearchButton a {
                font-size: 12px;
                color: #376597;
                line-height: 24px;
                padding: 0 3px;
            }

        .GridPager {
            border: none;
            color: #666;
            font-size: 12px;
            text-align: center;
            vertical-align: middle;
            margin: 0 auto;
        }

        .GridPageIndexStatus.Active {
            display: inline-block;
            line-height: 20px;
            cursor: default;
            margin: 0 2px;
            color: #666;
        }

        .GridPageIndexStatus.Active {
            line-height: 16px !important;
        }

        .GridPager a, .GridPageSize, .GridPager span {
            vertical-align: middle;
        }

        .GridPageIndexButton.Disabled {
            text-decoration: none;
            cursor: default;
            color: #999;
        }

        .GridPageIndexButton {
            line-height: 20px;
            cursor: pointer;
            margin: 0 2px;
            color: #666;
            margin-left: 4px;
            margin-right: 0;
            vertical-align: middle;
            height: 16px;
        }

        .GridPageSize {
            margin-left: 5px;
            font-size: 12px;
            color: #333;
            width: 130px;
            margin-left: 5px;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">已有服务</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon NormalState" id="OkButton" tabindex="0">
                    <span class="Icon Ok" style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></span>
                    <span class="Text">完成</span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <div class="DivSection" style="border: none; padding-left: 0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div style="font-weight: normal;">这些报价中包含的服务/包在合同中也有</div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div>
                                <ul>

                                
                                <%
                                    if (serviceList != null && serviceList.Count > 0)
                                    {
                                        foreach (var item in serviceList)
                                        {%>
                                <li style="font-weight: normal; margin-left: 20px;">
                                    <%=item.Value %>
                                </li>
                                <%}
                                    }
                                %>
                                    </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div style="font-weight: normal; padding-bottom: 10px;">请选择其中一项：</div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div style="padding-bottom: 10px;">
                                <input type="radio" name="options" id="NoDeal" style="vertical-align: middle; margin-left: 20px;" />
                                <span class="txtBlack8Class">忽略不做处理</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            <div style="padding-bottom: 10px;">
                                <input type="radio" name="options" id="AddService" style="vertical-align: middle; margin-left: 20px;">
                                <span class="txtBlack8Class">服务/包累加到现有服务/包中</span>
                            </div>
                            <div style="padding-bottom: 10px;">
                                <input type="checkbox" checked="checked" id="updatePrice" style="vertical-align: middle; margin-left: 40px;" />
                                <span class="txtBlack8Class">同时更新单价</span>
                            </div>
                            <div>
                                <input type="checkbox" checked="checked" id="updateCost" style="vertical-align: middle; margin-left: 40px;" />
                                <span class="txtBlack8Class">同时更新成本</span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $(function () {
        $("#AddService").prop("checked", true);
    })
    $("#OkButton").click(function () {
        debugger;
        if ($("#AddService").is(":checked")) {
            window.opener.document.getElementById("isAddService").value = "true";

            if ($("#updatePrice").is(":checked")) {
                window.opener.document.getElementById("isUpdatePrice").value = "true";
            }
            else {
                window.opener.document.getElementById("isUpdatePrice").value = "";
            }
            if ($("#updateCost").is(":checked")) {
                window.opener.document.getElementById("isUpdateCost").value = "true";
            } else {
                window.opener.document.getElementById("isUpdateCost").value = "";
            }
        }
        else {
            window.opener.document.getElementById("isAddService").value = "";
        }

        window.close();
    })
    // CancelButton
    $("#CancelButton").click(function () {

        window.close();
    })
    $("#NoDeal").click(function () {
        if ($(this).is(":checked")) {

        }
        else {

        }
    })
</script>
