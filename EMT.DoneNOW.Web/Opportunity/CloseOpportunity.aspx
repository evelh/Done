<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CloseOpportunity.aspx.cs" Inherits="EMT.DoneNOW.Web.Opportunity.CloseOpportunity" ValidateRequest="false" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>赢得商机向导</title>
    <link rel="stylesheet" href="../Content/reset.css" />
    <style>
        body {
            /*overflow: hidden;*/
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

        .Ok {
            background-image: url("../Images/ok.png");
        }

        .Cancel {
            background-image: url("../Images/cancel.png");
        }

        .Tools {
            background-image: url("../Images/dropdown.png");
        }

        .Add {
            background-image: url("../Images/add.png");
        }

        .Print {
            background-image: url("../Images/print.png");
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
        /*每一页*/
        .PageInstructions {
            font-size: 12px;
            color: #666;
            padding: 0 16px 12px 16px;
            margin-top: -1px;
            line-height: 16px;
        }

        .WizardSection {
            padding-left: 16px;
            padding-right: 16px;
        }

        .Workspace table {
            border-right: 0;
            padding-right: 0;
            border-top: 0;
            padding-left: 0;
            margin: 0;
            border-left: 0;
            border-bottom: 0;
        }

        td {
            font-size: 12px;
        }

        .FieldLabels, .workspace .FieldLabels {
            font-size: 12px;
            color: #4F4F4F;
            font-weight: bold;
            line-height: 15px;
        }

            .FieldLabels img {
                cursor: pointer;
            }

        .errorSmall {
            font-size: 12px;
            color: #E51937;
            margin-left: 3px;
            text-align: center;
        }

        input[type=text] {
            height: 22px;
            padding: 0 6px;
        }

        input[type="text"]:disabled, select:disabled, textarea:disabled {
            background-color: #f0f0f0;
            color: #6d6d6d;
            margin-right: 1px;
        }

        input[type=text], select, textarea {
            border: solid 1px #D7D7D7;
            font-size: 12px;
            color: #333;
            margin: 0;
        }

        input[type=checkbox] {
            vertical-align: middle;
            cursor: pointer;
            padding: 0;
            margin: 0 3px 0 0;
        }

        .txtBlack8 {
            font-size: 12px;
            color: #333;
            font-weight: 100;
        }

        .step2LeftSelectWidth {
            width: 292px;
        }

        .WizardSection td[class="FieldLabels"] select {
            margin-right: 1px;
        }

        select {
            height: 24px;
            padding: 0;
        }

        textarea {
            padding: 6px;
            resize: vertical;
        }

        .WizardButtonBar {
            padding: 0 16px 12px 16px;
            position: absolute;
            bottom: 10px;
        }
        /*下面按钮*/
        .ButtonBar {
            font-size: 12px;
            padding: 0 16px 10px 16px;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
            }

                .ButtonBar ul li {
                    float: left;
                }

        .contentButton {
            line-height: 22px;
        }

            .ButtonBar ul li a, .ButtonBar ul li a:visited, .contentButton a, .contentButton a:link, .contentButton a:visited, a.buttons, input.button, .ButtonBar ul li a:visited {
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
            }

            div.ButtonBar img.ButtonImg, .contentButton img.ButtonImg {
                margin: 4px 3px 0 3px;
            }

        .ButtonBar ul li img {
            border: 0;
        }

        .ButtonBar ul li a span.Text, .contentButton a span.Text, a.buttons span.Text, input.button span.Text {
            font-size: 12px;
            font-weight: bold;
            line-height: 26px;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }

        div.ButtonBar li.right {
            float: right;
        }

        div.ButtonBar img.ButtonRightImg {
            margin: 4px 1px 0 2px;
        }

        .DivSection td[class="fieldLabels"] input[type=radio], .DivSection td[class="FieldLabels"] input[type=radio], .DivSection td[class="fieldLabels"] input[type=checkbox], .DivSection td[class="FieldLabels"] input[type=checkbox], .WizardSection td[class="fieldLabels"] input[type=radio], .WizardSection td[class="FieldLabels"] input[type=radio], .WizardSection td[class="fieldLabels"] input[type=checkbox], .WizardSection td[class="FieldLabels"] input[type=checkbox] {
            margin-right: 0;
            vertical-align: middle;
            margin-top: -2px;
            margin-bottom: 1px;
        }

        a:link, a:visited, .dataGridBody a:link, .dataGridBody a:visited {
            color: #376597;
            font-size: 12px;
            text-decoration: none;
        }

        .grid {
            font-size: 12px;
            background-color: #FFF;
        }

            .grid table {
                border-bottom-color: #98b4ca;
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
                }

            .grid .selected {
                background-color: #e9eeee;
            }

            .grid tbody tr td:first-child, .grid tfoot tr td:first-child {
                border-left-color: #98b4ca;
            }

            .grid tbody tr td:last-child, .grid tfoot tr td:last-child {
                border-right-color: #98b4ca;
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

        .Workspace div {
            padding-bottom: 21px;
        }

        .sectionBluebg {
            color: #4F4F4F;
            font-weight: bold;
            padding-left: 0;
            height: 20px;
            vertical-align: middle;
            width: auto;
            margin-bottom: 0;
            font-size: 12px;
        }

        a.PrimaryLink {
            color: #376597;
            text-decoration: none;
            font-size: 12px;
            cursor: pointer;
        }
        /*第二页*/
        .DivSectionWithHeader {
            border: 1px solid #d3d3d3;
            margin: 0 10px 10px 10px;
            padding: 4px 0 4px 0;
        }

            .DivSectionWithHeader > .Heading {
                overflow: hidden;
                padding: 2px 4px 8px 6px;
                position: relative;
                text-overflow: ellipsis;
                white-space: nowrap;
            }

                .DivSectionWithHeader > .Heading > .Text {
                    color: #666;
                    height: 16px;
                    font-size: 12px;
                    font-weight: bold;
                    line-height: 17px;
                    text-transform: uppercase;
                }

            .DivSectionWithHeader .Content {
                padding: 12px 28px 4px 28px;
            }

            .DivSectionWithHeader td {
                padding: 0;
                text-align: left;
            }

        .CheckboxLabels, .workspace .CheckboxLabels, div[class="checkbox"] span, div[class="radio"] span {
            font-size: 12px;
            color: #333;
            font-weight: normal;
            vertical-align: middle;
        }

        .NoSection {
            padding-left: 10px;
        }

            .NoSection div {
                padding-bottom: 21px;
            }

        .FieldLevelInstructions {
            font-size: 11px;
            color: #666;
            line-height: 16px;
            font-weight: normal;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">赢得商机</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--第一页-->
        <div class="Workspace Workspace1">
            <div class="PageInstructions">
                此向导用来关闭商机。会将商机的状态设置为已关闭。将客户类型设置为客户，并创建一条客户备注。此外还可以创建工单，激活项目，将已报价产品转化为工单或项目成本，并通知相关人员商机已关闭。选择商机商机、阶段、商机所有人和关闭日期。你也可以选择主要竞争对手和实际的主要产品，输入赢得商机的原因。
            </div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%" valign="top">
                                <!--第一页主体-->
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>

                                            <td width="55%" class="FieldLabels">客户<span class="errorSmall">*</span>
                                                <div>
                                                    <input type="text" disabled="disabled" style="width: 278px; margin-right: 4px;" value="<%=account.name%>">
                                                    <input type="hidden" name="account_id" id="account_id" value="<%=account.id %>" />
                                                    <img src="../Images/data-selector.png" style="vertical-align: middle;">
                                                </div>
                                            </td>
                                            <td width="45%" class="FieldLabels">总收入 
                                            <div>
                                                <input type="text" style="width: 278px;" id="total_revneue" value="<%=new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoRevenue(opportunity.id).ToString("0.00") %>" />
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">商机<span class="errorSmall">*</span>
                                                <div>
                                                    <asp:DropDownList ID="opportunity_id" runat="server" CssClass="step2LeftSelectWidth txtBlack8"></asp:DropDownList>
                                                    <%--  <select disabled="disabled" id="" class="">
                            <option value=""><%=opportunity.name %></option>
                          </select>--%>
                                                </div>
                                            </td>
                                            <td class="FieldLabels">关闭日期
                                            <div>
                                                <input name="projected_close_date" id="projected_close_date" type="text" onclick="WdatePicker()" class="Wdate" value="<%=opportunity.projected_close_date!=null?((DateTime)opportunity.projected_close_date).ToString("yyyy-MM-dd"):"" %>" />
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">阶段
                                            <div>
                                                <asp:DropDownList ID="stage_id" runat="server" CssClass="step2LeftSelectWidth"></asp:DropDownList>

                                            </div>
                                            </td>
                                            <td class="FieldLabels">赢得商机原因<span class="errorSmall">*</span>
                                                <div>
                                                    <asp:DropDownList ID="win_reason_type_id" runat="server" CssClass="step2LeftSelectWidth"></asp:DropDownList>

                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">商机负责人 
                                            <div>
                                                <asp:DropDownList ID="resource_id" runat="server" CssClass="step2LeftSelectWidth"></asp:DropDownList>

                                            </div>
                                            </td>
                                            <td rowspan="3" class="FieldLabels" style="vertical-align: top;">原因描述  <span class="errorSmall">*</span>
                                                <div>
                                                    <textarea style="width: 278px; height: 160px;" name="win_reason" id="win_reason"><%=opportunity.win_reason %></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">主要产品
                                            <div>
                                                <% EMT.DoneNOW.Core.ivt_product priProduct = null;
                                                    if (opportunity.primary_product_id != null)
                                                    {
                                                        priProduct = new EMT.DoneNOW.BLL.ProductBLL().GetProduct((long)opportunity.primary_product_id);
                                                    }
                                                %>

                                                <input type="text" style="width: 278px; margin-right: 4px;" id="primary_product_id" value="<%=priProduct==null?"":priProduct.name %>">
                                                <input type="hidden" name="primary_product_id" id="primary_product_idHidden" value="<%=priProduct==null?"":priProduct.id.ToString() %>" />
                                                <img src="../Images/data-selector.png" style="vertical-align: middle;" onclick="callBackProduct()">
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">主要竞争对手
                                            <div>
                                                <asp:DropDownList ID="competitor_id" runat="server" CssClass="step2LeftSelectWidth"></asp:DropDownList>

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
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li style="display: none;" id="a1">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b1">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c1">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d1">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第二页-->
        <div class="Workspace Workspace2" style="display: none;">
            <div class="PageInstructions">请选择该向导即将进行的操作</div>
            <div>
                <div class="DivSectionWithHeader">
                    <div class="Heading">
                        <span class="Text">激活/创建</span>
                    </div>
                    <div class="Content">
                        <table width="100%" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr height="85%">
                                    <td valign="top">
                                        <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                            <tbody>
                                                <tr>
                                                    <td style="padding-bottom: 8px;">
                                                        <span class="CheckboxLabels">
                                                            <asp:CheckBox ID="activeproject" runat="server" />
                                                            <label id="activeprojectText">从报价激活项目提案</label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 8px;">
                                                        <span class="CheckboxLabels">
                                                            <asp:CheckBox ID="addContractRequest" runat="server" />
                                                            <label id="addContractRequestText">创建定期服务合同</label>
                                                        </span>
                                                        <input type="hidden" id="isAddContractRequest" value="" runat="server" />
                                                        <input type="hidden" id="isactiveproject" value="" runat="server" />

                                                        <input type="hidden" id="isaddContractServices" value="" runat="server" />
                                                        <input type="hidden" id="isaddRequest" value="" runat="server" />
                                                        <input type="hidden" id="IncludePO" value="" runat="server" />
                                                        <input type="hidden" id="IncludeShip" value="" runat="server" />
                                                        <input type="hidden" id="IncludeCharges" value="" runat="server" />

                                                        <input type="hidden" id="isPass" value="false" />
                                                        <input type="hidden" id="codeSelect" runat="server" />
                                                        <input type="hidden" id="disCodeSelct" runat="server" />

                                                        <input type="hidden" id="jqueryCode" runat="server" />
                                                        <!-- -->
                                                        <input type="hidden" name="isAddService" id="isAddService" />
                                                        <input type="hidden" name="isUpdatePrice" id="isUpdatePrice" />
                                                        <input type="hidden" name="isUpdateCost" id="isUpdateCost" />
                                                    </td>
                                                </tr>
                                                <tr id="trCreateContract" style="display: none;">
                                                    <td>
                                                        <div class="NoSection">
                                                            <table style="margin-left: 10px; width: 550px;" cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" colspan="2" width="100%">合同名称<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <input type="text" style="width: 510px;" name="contract_name" id="contract_name" value="<%=opportunity.name %>">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="padding-right: 0px; margin-right: 0px; width: 270px;">开始日期<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <input type="text" style="width: 95px;" name="start_date" id="start_date" onclick="WdatePicker()" class="Wdate" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                                                                            </div>
                                                                        </td>
                                                                        <td class="FieldLabels">合同周期类型
                                                                        <div>
                                                                            <asp:DropDownList ID="period_type" runat="server" Width="227px"></asp:DropDownList>

                                                                        </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" align="left" style="color: #333333; padding-right: 0px; margin-right: 0px; width: 75px;">
                                                                            <div>
                                                                                <input type="radio" name="RadioBtnEndDate" checked id="RadioBtnEndDate">
                                                                                <label>结束日期</label>
                                                                                <span class="errorSmall" id="errorSmallDate">*</span>
                                                                                <input type="text" style="width: 95px;" id="TextBtnEndDate" name="end_date" onclick="WdatePicker()" class="Wdate">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" align="left" style="color: #333333; padding-right: 0px; margin-right: 0px; width: 75px;">
                                                                            <div style="margin: 0; padding: 0;">
                                                                                <input type="radio" name="RadioBtnEndAfter" id="RadioBtnEndAfter">
                                                                                <label>结束于</label>
                                                                                <span class="errorSmall" style="display: none;" id="errorSmallAfter">*</span>
                                                                                <input type="text" style="width: 60px;" id="TextBtnEndAfter" name="occurrences" disabled>
                                                                                重复次数
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 8px;">
                                                        <span class="CheckboxLabels">
                                                            <asp:CheckBox ID="addContractServices" runat="server" />
                                                            <label id="addContractServicesText">将服务加入已存在的定期服务合同</label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr id="trAddContractServicesInfo" style="display: none;">
                                                    <td>
                                                        <div class="NoSection">
                                                            <table style="margin-left: 10px; width: 550px;" cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td class="FieldLabels" style="width: 404px;">合同<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <input type="text" name="" id="contract_id" style="width: 232px;" />
                                                                                <input type="hidden" name="contract_id" id="contract_idHidden" />

                                                                                <img src="../Images/data-selector.png" style="vertical-align: middle;" onclick="callBackContract()">
                                                                            </div>
                                                                        </td>
                                                                        <td class="FieldLabels">生效日期<span class="errorSmall">*</span>
                                                                            <div style="margin: 0; padding: 0;">
                                                                                <input type="text" style="width: 95px;" name="effective_date " id="effective_date" onclick="WdatePicker()" class="Wdate" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" />
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-bottom: 8px;">
                                                        <span class="CheckboxLabels">
                                                            <asp:CheckBox ID="addRequest" runat="server" />
                                                            <label id="addRequestText">创建服务台工单售后队列</label>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr id="trCreateTicket" style="display: none;">
                                                    <td>
                                                        <div class="NoSection">
                                                            <table style="margin-left: 10px; width: 550px;" cellspacing="0" cellpadding="0" border="0">
                                                                <tbody>
                                                                    <tr>
                                                                        <td style="width: 570px;" class="FieldLabels">截止日期<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <input type="text" style="width: 95px;" onclick="WdatePicker()" class="Wdate">
                                                                            </div>
                                                                        </td>
                                                                        <td style="width: 204px;" class="FieldLabels">截止时间<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <input type="text" style="width: 95px;">
                                                                                <img src="../Images/time.png" style="vertical-align: middle;">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" class="FieldLabels">标题<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <input type="text" style="width: 500px;">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" class="FieldLabels">描述<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <textarea rows="4" style="width: 500px;"></textarea>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2" class="FieldLabels">工作类型<span class="errorSmall">*</span>
                                                                            <div>
                                                                                <input type="text" id="workType_id" style="width: 500px;" />
                                                                                <input type="hidden" name="workType_id" id="workType_idHidden" />
                                                                                <img src="../Images/data-selector.png" style="vertical-align: middle;">
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="2">
                                                                            <div style="margin: 0; padding: 0;">
                                                                                <span class="CheckboxLabels">
                                                                                    <input type="checkbox" checked style="height: 13px; width: 13px; clear: left; padding: 0; margin: 0px 5px 0px 0px; vertical-align: bottom;">
                                                                                    <label style="cursor: pointer;">将此工单与商机相关联</label>
                                                                                </span>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
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
                <div class="DivSectionWithHeader">
                    <div class="Heading">
                        <span class="Text">转换</span>
                    </div>
                    <div class="Content">
                        <table width="100%" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr class="fieldLabels">
                                    <td class="FieldLabels" width="50%">转化下列报价项:</td>
                                    <td class="FieldLabels" width="50%">转换为:</td>
                                </tr>
                                <tr valign="top">
                                    <td>
                                        <br>
                                        <div class="CheckboxLabels">
                                            <div class="Checkbox" style="padding-bottom: 8px;">
                                                <span>
                                                    <asp:CheckBox ID="isIncludePO" runat="server" CssClass="isDisabled" />

                                                    <label style="cursor: pointer;" id="IncludePOText">产品 & 一次性折扣</label>
                                                </span>
                                            </div>
                                            <div class="Checkbox" style="padding-bottom: 8px;">
                                                <span>
                                                    <asp:CheckBox ID="isIncludeShip" runat="server" CssClass="isDisabled" />

                                                    <label id="IncludeShipText">配送</label>
                                                </span>
                                            </div>
                                            <div class="Checkbox" style="padding-bottom: 8px;">
                                                <span>
                                                    <asp:CheckBox ID="isIncludeCharges" runat="server" CssClass="isDisabled" />

                                                    <label id="IncludeChargesText" style="cursor: pointer;">成本</label>
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td rowspan="4">
                                        <br>
                                        <div class="RadioList">
                                            <div style="padding-bottom: 10px;">
                                                <span>
                                                    <asp:RadioButton ID="rbProjectCost" GroupName="optProject" runat="server" CssClass="convertRb" />
                                                    <label id="rbProjectCostText" class="convertText">服务台工单成本</label>
                                                </span>
                                            </div>
                                            <div style="padding-bottom: 10px;">
                                                <span>
                                                    <%-- <input type="radio" name="optProject" checked id="RadioPC">--%>
                                                    <asp:RadioButton ID="RadioPC" GroupName="optProject" runat="server" CssClass="convertRb" />
                                                    <label id="RadioPCText" class="convertText">项目成本</label>
                                                </span>
                                            </div>
                                            <div style="padding-bottom: 10px;">
                                                <span>
                                                    <asp:RadioButton ID="rbContractCost" GroupName="optProject" runat="server" CssClass="convertRb" />
                                                    <%--<input type="radio" disabled name="optProject">--%>
                                                    <label id="rbContractCostText" class="convertText">合同成本（新合同）</label>
                                                </span>
                                            </div>
                                            <div style="padding-bottom: 10px;">
                                                <span>
                                                    <asp:RadioButton ID="RadioCCEx" GroupName="optProject" runat="server" CssClass="convertRb" />
                                                    <%--   <input type="radio" name="optProject" id="RadioCCEx">--%>
                                                    <label id="RadioCCExText" class="convertText">合同成本（已存在合同）</label>
                                                </span>
                                                <div id="ccexDiv" style="position: relative; display: none; padding-bottom: 0px; padding-top: 5px; padding-left: 17px;">
                                                    <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                                        <tbody>
                                                            <tr>
                                                                <td class="FieldLabels" valign="middle">
                                                                    <div>
                                                                        <input type="text" style="width: 200px;" name="ConvertContract" id="ConvertContractId" />
                                                                        <input type="hidden" name="ConvertContractId" id="ConvertContractIdHidden" />
                                                                        <img src="../Images/data-selector.png" alt="" onclick="callBackContractNoDeal()" />
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div style="padding-bottom: 10px;">
                                                <span>
                                                    <asp:RadioButton ID="RadioBI" GroupName="optProject" runat="server" CssClass="convertRb" />
                                                    <%--<input type="radio" name="optProject" id="RadioBI">--%>
                                                    <label id="RadioBIText" class="convertText">工单成本（创建一个状态为已完成的工单）</label>
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a2">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b2">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c2">
                        <a class="ImgLink">
                            <span class="Text">完成</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d2">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">关闭</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第三页-->
        <div class="Workspace Workspace3" style="display: none;">
            <%--      <div class="PageInstructions">You are about to close an opportunity for a(n) company that may have incomplete address information. If necessary, please update this company's address below.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <table cellspacing="1" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels">Address 1
                                            <div>
                                                <input type="text" style="width: 547px;" value="ds">
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">Address 2
                                            <div>
                                                <input type="text" style="width: 547px;" value="6516asdfsda">
                                            </div>
                                            </td>
                                        </tr>
                                        <tr style="overflow: hidden;">
                                            <td class="FieldLabels" style="float: left;">City
                                            <div>
                                                <input type="text" style="width: 140px;" value="6516asdfsda">
                                            </div>
                                            </td>
                                            <td class="FieldLabels" style="float: left; margin-left: 49px;">State
                                            <div>
                                                <input type="text" style="width: 140px;" value="6516asdfsda">
                                            </div>
                                            </td>
                                            <td class="FieldLabels" style="float: left; margin-left: 49px;">Post Code
                                            <div>
                                                <input type="text" style="width: 140px;" value="6516asdfsda">
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">Country
                                            <div>
                                                <select style="width: 560px;">
                                                    <option value="">sdgsgsgd</option>
                                                    <option value="">sadsadaqweqeqwr</option>
                                                </select>
                                            </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>--%>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a3">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b3">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c3">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d3">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第四页-->
        <div class="Workspace Workspace4" style="display: none;">
            <div class="PageInstructions">Please match these items to the appropriate Material Codes below.</div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td>
                                <div class="grid">
                                    <table width="100%" cellspacing="0" cellpadding="0">
                                        <thead>

                                            <tr>
                                                <td>报价项名称</td>
                                                <td width="80px" align="right">数量</td>
                                                <td style="padding-left: 8px;" align="left">物料代码</td>
                                            </tr>
                                        </thead>
                                        <tbody id="thisBody">
                                            <%  if (proAndOneTimeItem != null && proAndOneTimeItem.Count > 0)
                                                {
                                                    foreach (var item in proAndOneTimeItem)
                                                    {%>
                                            <tr class="proAndOneTr">
                                                <td class="txtBlack8" style="vertical-align: middle;" nowrap><%=item.name %></td>
                                                <td class="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=item.quantity %></td>
                                                <td nowrap align="left">
                                                    <span class="errorSmall">*</span>
                                                    <% if (item.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT)
                                                        {%>
                                                    <select class="ChooseCostCoseSelect" name="<%=item.id %>_select" id="<%=item.id %>_select" style="width: 90%;">
                                                    </select>
                                                    <%}
                                                        else
                                                        { %>
                                                    <select class="ChooseDiscountCostCoseSelect" name="<%=item.id %>_select" id="<%=item.id %>_select" style="width: 90%;">
                                                    </select>
                                                    <%} %>
                                                </td>
                                            </tr>
                                            <%}

                                                }

                                                if (shipItem != null && shipItem.Count > 0)
                                                {
  foreach (var item in shipItem)
                                                    {%>
                                            <tr class="shipTr">
                                                <td class="txtBlack8" style="vertical-align: middle;" nowrap><%=item.name %></td>
                                                <td class="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=item.quantity %></td>
                                                <td nowrap align="left">
                                                    <span class="errorSmall">*</span>
                                                    <select class="ChooseCostCoseSelect" name="<%=item.id %>_select" id="<%=item.id %>_select" style="width: 90%;">
                                                    </select>
                                                </td>
                                            </tr>
                                            <%}
                                                }
                                                if (degressionItem != null && degressionItem.Count > 0)
                                                {
                                                    foreach (var item in degressionItem)
                                                    {
                                                        if (item.object_id != null)
                                                        {
                                                            continue;
                                                        }
                                            %>
                                            <tr class="degressionTr">
                                                <td class="txtBlack8" style="vertical-align: middle;" nowrap><%=item.name %></td>
                                                <td class="txtBlack8" style="vertical-align: middle;" nowrap align="right"><%=item.quantity %></td>
                                                <td nowrap align="left">
                                                    <span class="errorSmall">*</span>
                                                    <select class="ChooseCostCoseSelect" name="<%=item.id %>_select" id="<%=item.id %>_select" style="width: 90%;">
                                                    </select>
                                                </td>
                                            </tr>
                                            <%}

                                                }


                                            %>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a4">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b4">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c4">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d4">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第五页-->
        <div class="Workspace Workspace5" style="display: none;">
            <div class="PageInstructions">Select the person(s) you would like to notify. Use "Other Email(s)" if you have a distribution list. Ex. distribution@yourcompany.com</div>
            <div class="WizardSection">
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <tbody>
                        <tr>
                            <td class="FieldLabels">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tbody>
                                        <tr>
                                            <td width="50%">
                                                <div>
                                                    <span class="CheckboxLabels">
                                                        <input type="checkbox">
                                                        Creator
                                                    </span>
                                                    <span><b>Li, Hong</b></span>
                                                </div>
                                            </td>
                                            <td width="50%">
                                                <div>
                                                    <input type="checkbox">
                                                    <span style="font-weight: 100;">Territory Team</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">Resources
                                            <span class="FieldLevelInstructions">(<a style="color: #376597; cursor: pointer;">Load</a>)</span>
                                                <div>
                                                    <textarea style="width: 646px; height: 135px; border: 1px solid silver;"></textarea>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">Other Email(s)
                                            <div>
                                                <input type="text" style="width: 646px;">
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="FieldLabels">Notification Template
                                            <div>
                                                <select style="width: 660px;">
                                                    <option value="">safsaf</option>
                                                </select>
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
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a5">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b5">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c5">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d5">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第六页-->
        <div class="Workspace Workspace6" style="display: none;">
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a6">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b6">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" style="display: none;" id="c6">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d6">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第七页-->
        <div class="Workspace Workspace7" style="display: none;">
            <div class="PageInstructions">请查看你所做的选择，确认后点击完成按钮，或者回到上一步进行修改</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <table cellspacing="1" cellpadding="0" width="100%">
                                    <tr>
                                        <td class="FieldLabels">内容如下：
                                        <div>
                                            <textarea id="ShowInfo" rows="20" style="overflow-x: hidden; overflow-y: auto; width: 98%; height: 480px; resize: none"></textarea>
                                        </div>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a7">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li style="display: none;" class="right" id="b7">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" id="c7">
                        <a class="ImgLink">
                            <span class="Text">
                                <asp:Button ID="Finish" runat="server" Text="完成" BorderStyle="None" OnClick="Finish_Click" /></span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d7">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第八页-->
        <div class="Workspace Workspace8" style="display: none;">
            <div class="PageInstructions">The Wizard has been finished. Please make a selection from below or close this window.</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <div id="openTicket" style="display: none;">
                                    <a onclick="openTicket()">打开新工单</a>
                                    <input type="hidden" id="newTicketId" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="90%">
                                <div id="openSaleOrder" style="display: none;">
                                    <a onclick="openSaleOrder()">打开新的销售订单</a>
                                    <input type="hidden" id="newSaleOrderId" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="90%">
                                <div>
                                    <a>运行关闭商机向导，关闭下一个商机</a>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li style="display: none;" id="a8">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png">
                            <span class="Text">Back</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li style="display: none;" class="right" id="b8">
                        <a class="ImgLink">
                            <span class="Text">Next</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li style="display: none;" class="right" id="c8">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" id="d8">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">关闭</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>

<%--    <%if (opportunity == null)
    { %>
    $("#opportunity_id").prop("disabled", false);
    <%}
    else
    { %>
    $("#opportunity_id").prop("disabled", true);
    <%}%>--%>

    $("#opportunity_id").change(function () {
        var oid = $(this).val();
        var account_id = '<%=Request.QueryString["account_id"] %>';
        location.href = "CloseOpportunity?account_id=" + account_id + "&id=" + oid;
    });

    $("#b1").on("click", function () {
        // stage_id
        var stage_id = $("#stage_id").val();
        if (stage_id == 0) {
            alert("请选择一个商机阶段");
            return false;
        }
        // resource_id
        var resource_id = $("#resource_id").val();
        if (resource_id == 0) {
            alert("请选择一个商机负责人");
            return false;
        }

        if (<%=wonSetting.setting_value %> == <%=(int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE_DETAIL %>) // 根据系统设置决定是否校验
        {

            var win_reason_type_id = $("#win_reason_type_id").val();
            if (win_reason_type_id == 0) {
                alert("请选择关闭商机原因");
                return false;
            }

            var win_reason = $("#win_reason").val();
            if (win_reason == "") {
                alert("请填写关闭商机描述");
                return false;
            }
        }
        else if (<%=wonSetting.setting_value %> == <%=(int)EMT.DoneNOW.DTO.DicEnum.SYS_CLOSE_OPPORTUNITY.NEED_TYPE %>){
            var win_reason_type_id = $("#win_reason_type_id").val();
            if (win_reason_type_id == 0) {
                alert("请选择关闭商机原因");
                return false;
            }
        }

        $(".Workspace1").hide();
        $(".Workspace2").show();
    });
    $("#a2").on("click", function () {
        $(".Workspace1").show();
        $(".Workspace2").hide();
    });
    $("#b2").on("click", function () {
        // 必填校验
        // 选中创建定期服务合同后进行的验证
        var addContractRequest = $("#addContractRequest").is(":checked");
        if (addContractRequest) {
            debugger;
            var contract_name = $("#contract_name").val();
            if (contract_name == "") {
                alert("请填写合同名称");
                return false;
            }
            // start_date
            var start_date = $("#start_date").val();
            if (start_date == "") {
                alert("请填写开始日期");
                return false;
            }
            // period_type
            var period_type = $("#period_type").val();
            if (period_type == "0") {
                alert("请选择周期类型");
                return false;
            }
            // end_date
            var end_date = $("#TextBtnEndDate").val();
            var TextBtnEndAfter = $("#TextBtnEndAfter").val();
            if (end_date == "" && TextBtnEndAfter == "") {
                alert("结束日期和重复次数请选择其中的一个");
                return false;
            }
        }
        // 选中将服务加入已存在的定期服务合同后进行的验证

        var addContractServices = $("#addContractServices").is(":checked");
        if (addContractServices) {
            // contract_idHidden
            var contract_idHidden = $("#contract_idHidden").val();
            if (contract_idHidden == "") {
                alert("请填写查找带回选择合同");
                return false;
            }
            // effective_date
            var effective_date = $("#effective_date").val();
            if (effective_date == "") {
                alert("请填写生效日期");
                return false;
            }
        }

        // 选中创建服务台工单售后队列的验证
        var addRequest = $("#addRequest").is(":checked");
        if (addRequest) {
            // 新建工单必填信息，暂时先不管吧
        }

        var isIncludePO = $("#isIncludePO").is(":checked"); //isIncludeCharges
        var isIncludeShip = $("#isIncludeShip").is(":checked");
        var isIncludeCharges = $("#isIncludeCharges").is(":checked");

        if ((!isIncludePO) && (!isIncludeShip) && (!isIncludeCharges)) {
            $(".Workspace2").hide();
            $(".Workspace5").show();
            $("#isPass").val("true");
        }
        else {
            $(".proAndOneTr").hide();
            $(".degressionTr").hide();
            $(".shipTr").hide();

            // 产品和一次性折扣
            if (isIncludePO) {
                $(".proAndOneTr").show();
            }
            // 配送shipTr
            if (isIncludeShip) {
                $(".shipTr").show();
            }
            // 成本的配置项
            if (isIncludeCharges) {
                $(".degressionTr").show();
            }
            $("#isPass").val("false");
            $(".Workspace2").hide();
            $(".Workspace4").show();
        }



    });
    $("#a3").on("click", function () {
        $(".Workspace2").show();
        $(".Workspace3").hide();
    });
    $("#b3").on("click", function () {
        $(".Workspace3").hide();
        $(".Workspace4").show();
    });
    $("#a4").on("click", function () {

        $(".Workspace2").show();
        $(".Workspace4").hide();
    });
    $("#b4").on("click", function () {
        var isTrans = "";
        $(".ChooseCostCoseSelect").each(function () {
            debugger;
            if ($(this).parent().parent().css('display') == 'none') {
                return true;
            }
            var thisValue = $(this).val();
            if (thisValue == undefined || thisValue == null || thisValue == 0) {
                isTrans += thisValue;
                return false;
            } 
        })
        if (isTrans != "") {
            alert("你还有报价项未选择物料代码");

            return false;
        }

        $(".ChooseDiscountCostCoseSelect").each(function () {
            debugger;
            if ($(this).parent().parent().css('display') == 'none') {
                return true;
            }
            var thisValue = $(this).val();
            if (thisValue == undefined || thisValue == null || thisValue == 0) {
                isTrans += thisValue;
                return false;
            } 
        })

        if (isTrans != "") {
            alert("你还有报价项未选择物料代码");

            return false;
        }
        // ChooseDiscountCostCoseSelect




        $(".Workspace4").hide();
        $(".Workspace5").show();
    });
    $("#a5").on("click", function () {
        if ($("#isPass").val() == "true") {
            $(".Workspace2").show();
            $(".Workspace5").hide();
        } else {
            $(".Workspace4").show();
            $(".Workspace5").hide();
        }


    });
    $("#b5").on("click", function () {
        // 显示前边的信息
        //   var ShowInformation = "丢失商机时间:" + $("#lostTime").val() + "\r\n商机名称：" + $("#opportunity_id").find("option:selected").text() + "\r\n设置商机状态：" + $("#stage_id").find("option:selected").text() + "\r\n设置商机负责人：" + $("#resource_id").find("option:selected").text() + "\r\n设置主要产品：" + $("#productName").val() + "\r\n设置主要竞争对手：" + $("#competitor_id").find("option:selected").text() + "\r\n设计预计总收入：" + $("#total_revneue").val() + "\r\n商机状态设置为丢失\r\n通知对象：" ;
        //  $("#ShowInformation").html(ShowInformation);
        var ShowInformation = "关闭商机时间:" + $("#projected_close_date").val() + "\r\n商机名称:" + $("#opportunity_id").find("option:selected").text() + "\r\n设置商机阶段：" + $("#stage_id").find("option:selected").text() + "\r\n设置商机负责人：" + $("#resource_id").find("option:selected").text() + "\r\n设置主要产品：" + $("#primary_product_id").val() + "\r\n设置主要竞争对手：" + $("#competitor_id").find("option:selected").text() + "\r\n设计预计总收入：" + $("#total_revneue").val() + "\r\n设置关闭商机原因：" + $("#win_reason_type_id").find("option:selected").text();
        // todo 根据前边打勾的状态显示将要新增的操作

        $("#ShowInfo").html(ShowInformation);
        // win_reason_type_id
        $(".Workspace5").hide();
        $(".Workspace7").show();
    });

    $("#a7").on("click", function () {
        $(".Workspace5").show();
        $(".Workspace7").hide();
    });
    $("#c7").on("click", function () {
        //$(".Workspace7").hide();
        //$(".Workspace8").show();
    });
    $("#d8").on("click", function () {
        window.close();
    });
    $("#load111").on("click", function () {
        $(".grid").show();
    });
    $("#all").on("click", function () {
        if ($(this).is(":checked")) {
            $(".grid input[type=checkbox]").prop('checked', true);
        } else {
            $(".grid input[type=checkbox]").prop('checked', false);
        }
    });

    $("#addContractRequest").on("click", function () {
        if ($(this).is(":checked")) {
            $("#trCreateContract").show();
            $("#trAddContractServicesInfo").hide();
            $("#addContractServices").prop('checked', false);
            if (isChooseItem()) {
                // rbContractCost
                $("#rbContractCost").prop('disabled', false);
                $("#rbContractCost").prop('checked', true);
                $("#rbContractCostText").css("color", "");
            }
        } else {
            $("#trCreateContract").hide();
            $("#rbContractCost").prop('disabled', true);
            $("#rbContractCost").prop('checked', false);
            $("#rbContractCostText").css("color", "rgb(176, 176, 176)");
            NoDisabledText();
        }
    });
    $("#addContractServices").on("click", function () {
        if ($(this).is(":checked")) {
            $("#trAddContractServicesInfo").show();
            $("#trCreateContract").hide();
            $("#addContractRequest").prop('checked', false);

            if (isChooseItem()) {
                // rbContractCost
                $("#rbContractCost").prop('disabled', false);
                $("#rbContractCost").prop('checked', true);
                $("#rbContractCostText").css("color", "");
            }
        } else {
            $("#trAddContractServicesInfo").hide();
            $("#rbContractCost").prop('disabled', true);
            $("#rbContractCost").prop('checked', false);
            $("#rbContractCostText").css("color", "rgb(176, 176, 176)");
            NoDisabledText();
        }
    });
    $("#RadioBtnEndDate").on("click", function () {
        $("#RadioBtnEndAfter").prop("checked", false);
        $("#TextBtnEndDate").prop('disabled', false);
        $("#errorSmallDate").show();
        $("#TextBtnEndAfter").prop('disabled', true);
        $("#errorSmallAfter").hide();
    });
    $("#RadioBtnEndAfter").on("click", function () {
        $("#RadioBtnEndDate").prop("checked", false);
        $("#TextBtnEndAfter").prop('disabled', false);
        $("#errorSmallAfter").show();
        $("#TextBtnEndDate").prop('disabled', true);
        $("#errorSmallDate").hide();
    });

    $("#addRequest").on("click", function () {
        if ($(this).is(":checked")) {
            $("#trCreateTicket").show();
            if (isChooseItem()) {
                $("#rbProjectCost").prop('disabled', false);
                $("#rbProjectCost").prop('checked', true);
                $("#rbProjectCostText").css("color", "");
                $("#RadioBI").prop('disabled', true);
                $("#RadioBI").prop('checked', false);
                $("#RadioBIText").css("color", "rgb(176, 176, 176)");
            }
        } else {
            $("#trCreateTicket").hide();
            $("#rbProjectCost").prop('disabled', true);
            $("#rbProjectCost").prop('checked', false);
            $("#rbProjectCostText").css("color", "rgb(176, 176, 176)");
            $("#RadioBI").prop('disabled', false);
            $("#RadioBI").prop('checked', true);
            $("#RadioBIText").css("color", "");
        }
    });
    $("#RadioCCEx").on("click", function () {
        if ($(this).is(":checked")) {
            $("#ccexDiv").show();
        }
    });
    $("#activeproject").on("click", function () {
        if ($(this).is(":checked")) {
            if (isChooseItem()) {
                $("#RadioPC").prop('disabled', false);
                $("#RadioPC").prop('checked', true);
                $("#RadioPCText").css("color", "");
            }
            $("#ccexDiv").hide();
        } else {
            $("#RadioBI").prop('checked', true);
            $("#ccexDiv").hide();
            $("#RadioPC").prop('disabled', true);
            $("#RadioPC").prop('checked', false);
            $("#RadioPCText").css("color", "rgb(176, 176, 176)");

            NoDisabledText();
        }
    });
    $("#RadioPC").on("click", function () {
        $("#ccexDiv").hide();
    });
    $("#RadioBI").on("click", function () {
        $("#ccexDiv").hide();
    });

</script>

<script>
    $(function () {
        var isAddContractRequest = $("#isAddContractRequest").val();
        if (isAddContractRequest != "") {
            $("#addContractRequestText").css("color", "rgb(176, 176, 176)");
        }

        var isactiveproject = $("#isactiveproject").val();
        if (isactiveproject != "") {
            $("#activeprojectText").css("color", "rgb(176, 176, 176)");
        }

        var isaddContractServices = $("#isaddContractServices").val();
        if (isaddContractServices != "") {
            $("#addContractServicesText").css("color", "rgb(176, 176, 176)");
        }

        var isaddRequest = $("#isaddRequest").val();
        if (isaddRequest != "") {
            $("#addRequestText").css("color", "rgb(176, 176, 176)");
        }

        var IncludePO = $("#IncludePO").val();
        if (IncludePO != "") {
            $("#IncludePOText").css("color", "rgb(176, 176, 176)");
        }
        var IncludeShip = $("#IncludeShip").val();
        if (IncludeShip != "") {
            $("#IncludeShipText").css("color", "rgb(176, 176, 176)");
        }
        var IncludeCharges = $("#IncludeCharges").val();
        if (IncludeCharges != "") {
            $("#IncludeChargesText").css("color", "rgb(176, 176, 176)");
        }
        if (IncludePO != "" && IncludeShip != "" && IncludeCharges != "") {
            DisabledText();
        }
        // checkFirstRb();
        NoDisabledText();

        $(".ChooseCostCoseSelect").html($("#codeSelect").val());
        eval($("#jqueryCode").val());

        // ChooseDiscountCostCoseSelect
        // disCodeSelct
        $(".ChooseDiscountCostCoseSelect").html($("#disCodeSelct").val());
    })

    $(".isDisabled").click(function () {
        debugger;
        var isIncludePO = $("#isIncludePO").is(":checked");
        var isIncludeShip = $("#isIncludeShip").is(":checked"); //
        var isIncludeCharges = $("#isIncludeCharges").is(":checked"); //

        if ((!isIncludePO) && (!isIncludeShip) && (!isIncludeCharges)) {
            DisabledText();
        }
        else {
            NoDisabledText();
        }
    })
    // 禁用转换
    function DisabledText() {
        $("#ccexDiv").hide();
        $(".convertText").css("color", "rgb(176, 176, 176)");
        $(".convertRb").prop("disabled", true);
        $("#RadioBI").prop("checked", true);
    }
    // 解除禁用转换
    function NoDisabledText() {
        var isactiveproject = $("#activeproject").is(":checked");
        var isaddContractRequest = $("#addContractRequest").is(":checked");
        var isaddContractServices = $("#addContractServices").is(":checked");
        var isaddRequest = $("#addRequest").is(":checked");
        debugger;
        if (isactiveproject) {
            $("#RadioPC").prop("disabled", false);// RadioPCText
            $("#RadioPCText").css("color", "");
            $("#RadioPC").prop("checked", true);
        }
        else {
            $("#RadioPC").prop("disabled", true);// RadioPCText
            $("#RadioPC").prop("checked", false);
            $("#RadioPCText").css("color", "rgb(176, 176, 176)");
        }
        if (isaddContractRequest) {
            $("#rbContractCost").prop("disabled", false);
            $("#rbContractCostText").css("color", "");
            $("#rbContractCost").prop("checked", true);
        }
        else {
            $("#rbContractCost").prop("disabled", true);// RadioPCText
            $("#rbContractCost").prop("checked", false);
            $("#rbContractCostText").css("color", "rgb(176, 176, 176)");
        }
        if (isaddContractServices) {
            $("#rbContractCost").prop("disabled", false);
            $("#rbContractCostText").css("color", "");
            $("#rbContractCost").prop("checked", true);
        }
        else {
            $("#rbContractCost").prop("disabled", true);// RadioPCText
            $("#rbContractCost").prop("checked", false);
            $("#rbContractCostText").css("color", "rgb(176, 176, 176)");
        }
        if (isaddRequest) {
            $("#rbProjectCost").prop("disabled", false);
            $("#rbProjectCostText").css("color", "");
            $("#rbProjectCost").prop("checked", true);
            $("#RadioBI").prop("disabled", true);
            $("#RadioBIText").css("color", "rgb(176, 176, 176)");
        }
        else {
            $("#rbProjectCost").prop("disabled", true);// RadioPCText
            $("#rbProjectCost").prop("checked", false);
            $("#rbProjectCostText").css("color", "rgb(176, 176, 176)");

        }
        if ((!isactiveproject) && (!isaddContractRequest) && (!isaddContractServices) && (!isaddRequest)) {
            $("#RadioCCEx").prop("disabled", false);
            $("#RadioCCExText").css("color", "");
            $("#RadioBI").prop("disabled", false);
            $("#RadioBIText").css("color", "");
            $("#RadioBI").prop("checked", true);
        }
        if (!isChooseItem()) {
            DisabledText();
        }
    }
    // 判断有没有点击的报价项
    function isChooseItem() {
        var isIncludePO = $("#isIncludePO").is(":checked");
        var isIncludeShip = $("#isIncludeShip").is(":checked"); //
        var isIncludeCharges = $("#isIncludeCharges").is(":checked");
        if ((!isIncludePO) && (!isIncludeShip) && (!isIncludeCharges)) {
            return false;
        }
        return true;
    }

    // 主要产品的查找带回
    function callBackProduct() {
        // primary_product_id
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=primary_product_id", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    // 合同查找带回（包括带回事件）
    function callBackContract() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_CALLBACK %>&field=contract_id&callBack=GetDataByContract", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>', 'left=200,top=200,width=600,height=800', false);
    }
    //  合同查找带回（不包括带回事件）
    function callBackContractNoDeal() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.CONTRACT_CALLBACK %>&field=ConvertContractId", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractSelectCallBack %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 根据查找带回的合同进行的处理
    function GetDataByContract() {
        // 需要做的处理

        var contract_idHidden = $("#contract_idHidden").val();
        var contractName = $("#contract_id").val();
        if (contract_idHidden != "") {
            // 1.将添加的同和信息赋值给转换的合同信息
            // ConvertContractId   ConvertContractIdHidden
            $("#ConvertContractId").val(contractName);
            $("#ConvertContractIdHidden").val(contract_idHidden);
            // 2.检查报价中包含初始费用且合同中也有，此时会提示“报价中初始费用不会替换已有初始费用
            var quote_id = <%=primaryQuote==null?"":primaryQuote.id.ToString() %>
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/QuoteAjax.ashx?act=compareSetupFee&quote_id=" + quote_id + "&contract_id" + contract_idHidden,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        if (data != "True") {
                            alert("报价中初始费用不会替换已有初始费用");
                        }
                    },
                });

            // 3.报价中包含的服务/包在合同中也有，此时会给出两个选择，提示“方案1：将服务/包累加到现有服务/包中，价格和成本替换为新的价格/成本；方案2：忽略不做处理
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/QuoteAjax.ashx?act=compareService&quote_id=" + quote_id + "&contract_id" + contract_idHidden,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "True") {
                        // todo -- 弹出新窗口，确认是否累加服务包
                    }
                    else {

                    }
                },
            });

            // 记录合同的开始时间和结束时间 ，生效日期必须在开始时间和结束日期之间
        }
    }

    function openTicket() {
        var newTicketId = $("#newTicketId").val();
        if (newTicketId != "") {

        }
    }
    function openSaleOrder() {
        var newSaleOrderId = $("#newSaleOrderId").val();
        if (newSaleOrderId != "") {
            window.open("../SaleOrder/SaleOrderView.aspx?id=" + newSaleOrderId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SaleOrderView %>', 'left=200,top=200,width=600,height=800', false);
        }
    }

</script>
