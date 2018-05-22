<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SwapConfigItemWizard.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.SwapConfigItemWizard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/SwapConfigItem.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">配置项替换向导</div>
        <!--第一页-->
        <div class="Workspace Workspace1">
            <div class="PageInstructions">
                “配置项替换向导”允许您使用库存中的产品替换当前配置项，并将当前产品放回库存中。所有未审批并提交的订阅、关联的合同将被关联到新的配置项。当前配置项的活动工单是否与新的配置项关联可以指定
            </div>
            <div style="overflow: hidden;">

                <div id="generalDiv" style="overflow: hidden; width: 100%; height: 270px;">
                    <div class="DivSectionWithHeader">
                        <div class="HeaderRow">
                            <span>输出配置项配置</span><span style="font-size: 11px; color: #666666; padding-left: 0px; font-weight: normal; text-transform: none">(替换)</span>
                        </div>
                        <div class="Content">
                            <table id="installed_product_fieldstable" cellspacing="0" cellpadding="0">
                                <tbody>
                                    <tr>
                                        <td class="FieldLabel ip_general_label">名称&nbsp;</td>
                                        <td style="word-wrap: break-word; width: 200px">IBM XX01</td>
                                        <td rowspan="2">
                                            <span>
                                                <input type="checkbox" id="CkToWarehouse" name="CkToWarehouse" /></span><span>产品回收入库</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabel ip_general_label">序列号&nbsp;</td>
                                        <td style="word-wrap: break-word; width: 200px"><%=thisInsPro.serial_number %></td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabel ip_general_label">参考号 &nbsp;</td>
                                        <td style="word-wrap: break-word; width: 200px"><%=thisInsPro.reference_number %></td>
                                    </tr>
                                    <tr>
                                        <td class="FieldLabel ip_general_label">参考名 &nbsp;</td>
                                        <td style="word-wrap: break-word; width: 200px"><%=thisInsPro.reference_name %></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="DivSectionWithHeader">
                        <div class="HeaderRow">
                            <span>传入配置项</span><span style="font-size: 11px; color: #666666; padding-left: 0px; font-weight: normal; text-transform: none">(替换为)</span>
                        </div>
                        <div class="Content">
                            <table cellspacing="0" cellpadding="0" id="Table2">
                                <tbody>
                                    <tr>
                                        <td class="FieldLabel ip_general_label">目标产品</td>
                                        <td style="width: 270px">
                                            <div id="_ctl8_inventoryItemPanel" style="margin-right: 3px; padding-bottom: 0px; display: inherit;">
                                                <span id="_ctl8_selectorInventory" style="display: inline-block;">
                                                    <input name="" type="text" value="" id="ToTargetId" class="txtBlack8Class" style="width: 250px;" />
                                                    <input type="hidden" id="ToTargetIdHidden" name="ToTargetId" />
                                                </span>&nbsp;<a id="" class="DataSelectorLinkIcon" onclick="ToTargetSelect()"><img src="../Images/data-selector.png" align="top" border="0" style="cursor: pointer;" /></a>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="TargetSeriNumTr" style="display: none;">
                                        <td class="FieldLabel ip_general_label" style="padding-top: 10px;"><span id="serialspan1" style="">序列号<span style="color: red">*</span></span></td>
                                        <td style="width: 270px; padding-top: 10px;">
                                            <div id="_ctl8_serialNumberPanel" style="margin-right: 3px; display: inherit;">
                                                <span id="" style="display: inline-block;">
                                                    <input name="" type="text" id="ToTargetXuLie" class="txtBlack8Class" style="width: 250px;" />
                                                    <input type="hidden" id="ToTargetXuLieHidden" name="ToTargetXuLie" />
                                                </span>&nbsp;<a onclick="ToTargetSerNumSelect()" class="DataSelectorLinkIcon" align="top" border="0" style="cursor: pointer;"><img src="../Images/data-selector.png" align="top" border="0" style="cursor: pointer;" /></a>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>


            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 96%;">
                <ul>
                    <!--上一层-->
                    <li style="display: none;" id="a1">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png" />
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b1">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png" />
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第二页-->
        <div class="Workspace Workspace2" style="display: none;">
            <div class="PageInstructions">选中产品回收入库时，需要选择目标仓库和产品，或者创建新的库存产品。</div>
            <div style="overflow: hidden;">
                <div id="generalDiv" style="overflow-y: auto; width: 99%; height: 275px; margin-bottom: 10px;">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td>
                                    <div style="margin-left: 10px; margin-bottom: 10px;">
                                        <input id="ckExist" type="radio" name="ckInven" value="exist" checked="checked" /><label>选择已存在的库存产品 <span class="FieldLevelInstruction"></span></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 4px;">
                                    <table id="step1aSelectorInventoryTable" cellspacing="0" cellpadding="0" style="margin-bottom: 10px;">
                                        <tbody>
                                            <tr>
                                                <td class="wizardFieldLabel">库存产品<span id="exsitingInventoryAsteriskSpan" style="color: red">*</span>
                                                    <div>
                                                        <div style="margin-right: 3px">
                                                            <span id="_ctl12_selectorInventory" style="display: inline-block;">
                                                                <input name="" type="text" value="" id="ExistInvId" class="txtBlack8Class" autocomplete="off" style="width: 280px;" />
                                                                <input type="hidden" id="ExistInvIdHidden" name="ExistInvId" />
                                                            </span>&nbsp;<a id="AExiSelect" onclick="ExistSelect()" class="DataSelectorLinkIcon" style="display: inline;"><img src="../Images/data-selector.png" align="top" border="0" style="cursor: pointer;" /></a>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr id="ExistInvSeriNumTr" style="display: none;">
                                                <td class="wizardFieldLabel"><span id="exsitingSerialSpan1" style="">序列号<span id="exsitingSerialAsteriskSpan" style="color: red">*</span></span>
                                                    <div>
                                                        <span id="exsitingSerialSpan2" style=""><span id="_ctl12_existingSerialNumber" style="display: inline-block;">
                                                            <input type="hidden" id="ExistInvSeriNumHidden" />
                                                            <input name="ExistInvSeriNum" type="text" maxlength="100" id="ExistInvSeriNum" class="txtBlack8Class" style="width: 280px;" /></span></span><%--<a  onclick="ExistSerNumSelect()" class="DataSelectorLinkIcon" style="display: inline;"><img src="../Images/data-selector.png" align="top" border="0" style="cursor: pointer;" /></a>--%>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="margin-left: 10px; margin-bottom: 10px;">
                                        <input id="ckNew" type="radio" name="ckInven" value="new" />
                                        <label>创建新的库存产品<span class="FieldLevelInstruction"></span></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding-left: 4px;">
                                    <table id="installed_product_fieldstable" cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr>
                                                <td class="wizardFieldLabel" colspan="3">产品名称
							<div style="font-weight: normal;"><%=thisProduct!=null?thisProduct.name:"" %></div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wizardFieldLabel" colspan="3">仓库 <span id="newLocationAsteriskSpan" style="color: red;">*</span>
                                                    <div>
                                                        <span id="_ctl12_ddl_InventoryLocation" style="display: inline-block;">
                                                            <select name="newWareId" id="newWareId" class="txtBlack8Class web2New" style="width: 280px;">
                                                                <%if (wareList != null && wareList.Count > 0)
                                                                    {
                                                                        foreach (var ware in wareList)
                                                                        {%>
                                                                <option value="<%=ware.id %>"><%=ware.name %></option>
                                                                <%}
                                                                    } %>
                                                            </select></span>
                                                    </div>
                                                </td>
                                                <td class="wizardFieldLabel"><%if (thisProduct != null && thisProduct.is_serialized == 1)
                                                                                 { %> 序列号<span style="color:red;">*</span> <%} %></td>
                                                <td><%if (thisProduct != null && thisProduct.is_serialized == 1)
                                                        { %>
                                                    <input type="text" id="newSerNum" name="newSerNum" class="web2New" />
                                                    <%} %></td>
                                            </tr>
                                            <tr>
                                                <td class="wizardFieldLabel" colspan="3">参考号
							<div>
                                <span id="_ctl12_txt_ReferenceNumber" style="display: inline-block;">
                                    <input name="newRefNumber" type="text" maxlength="50" id="newRefNumber" class="txtBlack8Class web2New" style="width: 280px;" /></span>
                            </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wizardFieldLabel" colspan="3">仓位
							<div>
                                <span id="_ctl12_txt_Bin" style="display: inline-block;">
                                    <input name="newBin" type="text" maxlength="50" id="newBin" class="txtBlack8Class web2New" style="width: 280px;" /></span>
                            </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wizardFieldLabel">最小数<span id="newMinimumAsteriskSpan" style="color: red">*</span>
                                                    <div>
                                                        <span id="_ctl12_txt_Min" style="display: inline-block;">
                                                            <input name="newMin" type="text" id="newMin" class="txtBlack8Class web2New" style="width: 73px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" /></span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wizardFieldLabel">最大数<span id="newMaximumAsteriskSpan" style="color: red">*</span>
                                                    <div>
                                                        <span id="_ctl12_txt_Max" style="display: inline-block;">
                                                            <input name="newMax" type="text" id="newMax" class="txtBlack8Class web2New" style="width: 72px; text-align: right;" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                                        </span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wizardFieldLabel" colspan="3">库存数量
							<div>
                                <span id="_ctl12_txt_OnHand" style="display: inline-block;">
                                    <input name="newQuantity" type="text" disabled="disabled" value="1" maxlength="50" id="newQuantity" style="width: 73px; text-align: right;" /></span>
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

            <div class="ButtonBar WizardButtonBar" style="width: 96%;">
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
                            <img class="ButtonRightImg" src="../Images/cancel.png" />
                            <span class="Text">关闭</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第三页-->
        <div class="Workspace Workspace3" style="display: none;">
            <div class="PageInstructions">
                <div><span class="lblNormalClass" style="color: #666666; font-weight: normal;">当前配置项有一个或多个关联的活动工单。此步骤允许您选择如何处理这些工单。可以完成、可以关联到新的配置项，或者不采取任何措施。如果选择完成或关联到新的配置项，系统将向工单添加备注，说明相关配置项已被替换.</span></div>
            </div>
            <div style="overflow: hidden;">
                <table class="installed_product_general" cellspacing="0" cellpadding="0" align="center">
                    <tbody>
                        <tr>
                            <td>
                                <div style="overflow: hidden; height: 350px" class="grid">
                                    <span id="_ctl14_grdTix" style="display: inline-block; width: 100%;">
                                        <span></span>
                                        <div id="_ctl14_grdTix_grdTix_divgrid" class="GridContainer" style="height: 350px;">
                                            <div id="" style="width: 100%; overflow: auto; height: 350px; z-index: 0;">
                                                <table class="dataGridBody" cellspacing="0" border="1" id="" style="width: 100%; border-collapse: collapse;">
                                                    <tbody>
                                                        <tr class="dataGridHeader">
                                                            <td align="center">完成</td>
                                                            <td align="center">关联新的配置项</td>
                                                            <td align="center">不处理</td>
                                                            <td align="left">工单号</td>
                                                            <td align="left">工单标题</td>
                                                        </tr>
                                                        <% if (noCloseTicket != null && noCloseTicket.Count > 0)
                                                            {
                                                                foreach (var thisTicket in noCloseTicket)
                                                                {%>
                                                        <tr class="dataGridBody ticketTr" style="cursor: pointer;">
                                                            <td align="center"><span class="txtBlack8Class">
                                                                <input id="" type="radio" name="ck<%=thisTicket.id %>" value="complete" class="TicketCom" checked="checked" /></span></td>
                                                            <td align="center"><span class="txtBlack8Class">
                                                                <input id="" type="radio" name="ck<%=thisTicket.id %>" value="asgin" class="TicketAsgin" /></span></td>
                                                            <td align="center"><span class="txtBlack8Class">
                                                                <input id="" type="radio" name="ck<%=thisTicket.id %>" value="nothing" class="TicketNothing" /></span></td>
                                                            <td valign="middle" class="TicketNoTd"><span id=""><%=thisTicket.no %></span></td>
                                                            <td valign="middle" style="width: 300px;"><span id="" style="width: 300px;"><%=thisTicket.title %></span></td>
                                                        </tr>
                                                        <%}
                                                            } %>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </span>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 96%; margin-top: 10px;">
                <ul>
                    <!--上一层-->
                    <li id="a3">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png" />
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b3">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png" />
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第四页-->
        <div class="Workspace Workspace4" style="display: none;">
            <div class="PageInstructions">
                <div><span class="lblNormalClass" style="color: #666666; font-weight: normal;">选择您想要通知的人员。如果您有一个通知清单（例如：distribution@yourcompany.com），请使用“其他邮件地址”.</span></div>
            </div>
            <div style="overflow: hidden;">
                <div id="generalDiv" style="overflow: auto; width: 100%; height: 315px;">
                    <table class="installed_product_general" cellspacing="0" cellpadding="0" id="Table1">
                        <tbody>
                            <tr>
                                <td style="padding-left: 10px;">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <span id="_ctl16_lblAccountContact" class="lblNormalClass" style="font-weight: bold; color: #666;">联系人</span>
                                                </td>

                                            </tr>
                                        </tbody>
                                    </table>
                                    <div class="InnerGrid" style="background-color: White; border-right: 1px solid #D3D3D3; border-top: 1px solid #D3D3D3; border-left: 1px solid #D3D3D3; border-bottom: 1px solid #D3D3D3; height: 205px; width: 374px;">
                                        <span style="display: inline-block; height: 205px; width: 382px;">
                                            <div id="" class="GridContainer" style="margin-left: 0px;">
                                                <div id="" style="height: 200px; width: 100%; overflow: auto; z-index: 0;">
                                                    <div class="grid" style="overflow: auto; height: 200px;">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                                            <thead>
                                                                <tr>
                                                                    <td width="1%"></td>
                                                                    <td width="33%">联系人姓名</td>
                                                                    <td width="33%">邮箱地址</td>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="conhtml">
                                                                <%if (contactList != null && contactList.Count > 0)
                                                                    {
                                                                        foreach (var contact in contactList)
                                                                        {%>
                                                                <tr>
                                                                    <td>
                                                                        <input type="checkbox" value="<%=contact.id %>" class="checkCon" /></td>
                                                                    <td><%=contact.name %></td>
                                                                    <td><a href="mailto:<%=contact.email %>"><%=contact.email %></a></td>
                                                                </tr>
                                                                <%}
                                                                    } %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <table style="margin-top: -22px;">
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <span id="_ctl16_lblEmployee" class="lblNormalClass" style="font-weight: bold; color: #666;">员工</span>
                                                    <span class="txtBlack8Class" style="color: #666;">(<a onclick="LoadRes()">加载</a>)</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <div class="InnerGrid" style="background-color: White; height: 180px; margin-right: -11px;">
                                        <span id="ctrlNotification_dgEmployees" style="display: inline-block; height: 112px; width: 382px;"><span></span>
                                            <div id="reshtml" style="width: 350px; height: 205px; border: 1px solid #d7d7d7; margin-bottom: 20px;">
                                            </div>
                                        </span>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="padding-left: 12px;">
                                    <br>
                                    <table cellspacing="0" cellpadding="0">
                                        <tbody>
                                            <tr id="_ctl16_rowOtherEmail">
                                                <td>
                                                    <span id="_ctl16_lblOtherEmail" class="lblNormalClass" style="font-weight: bold; display: block; white-space: nowrap; color: #666;">其他邮件地址
                                                    </span>
                                                    <div>
                                                        <span id="_ctl16_txtOtherEmail" class="stretchTextBox" style="display: inline-block;">
                                                            <input name="otherMail" type="text" maxlength="2000" id="otherMail" class="txtBlack8Class" style="width: 758px;" /></span>
                                                    </div>
                                                </td>
                                            </tr>

                                            <tr id="_ctl16_Tr1" style="padding-top: 4px;">
                                                <td>
                                                    <span id="_ctl16_Atlabel1" class="FieldLevelInstruction" style="font-weight: normal; display: block; text-align: left; white-space: nowrap;">(使用分号分隔)</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="lblNormalClass" style="font-weight: bold; display: block; white-space: nowrap; color: #666;">主题
                                                    </span>
                                                    <div>
                                                        <span class="stretchTextBox" style="display: inline-block;">
                                                            <input name="subject" type="text" maxlength="2000" id="subject" class="txtBlack8Class" style="width: 758px;" value="配置项替换：<%=thisProduct!=null?thisProduct.name:"" %>(<%=thisAccount!=null?thisAccount.name:"" %>)" /></span>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <span class="lblNormalClass" style="font-weight: bold; display: block; white-space: nowrap; color: #666;">内容
                                                    </span>
                                                    <div>
                                                        <span class="stretchTextBox" style="display: inline-block;">
                                                            <textarea id="content" name="content" style="width: 758px; height: 40px; resize: vertical;">换出配置项：<%=thisProduct!=null?thisProduct.name:"" %>
                                                            序列号：<%=thisInsPro.serial_number %>
                                                            参考号：<%=thisInsPro.reference_number %>
                                                            参考名: <%=thisInsPro.reference_name %>
                                                        </textarea>
                                                        </span>
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
            <div class="ButtonBar WizardButtonBar" style="width: 96%; margin-top: 10px;">
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
                </ul>
            </div>
        </div>

        <!--第五页-->
        <div class="Workspace Workspace5" style="display: none;">
            <div class="PageInstructions">
                <div><span class="lblNormalClass" style="color: #666666; font-weight: normal;">请查看你所做的选择，确认后点击完成按钮，或者回到上一步进行修改.</span></div>
            </div>
            <div style="overflow: hidden;">

                <div id="generalDiv" style="overflow: auto; width: 100%; height: 295px;">
                    <table class="installed_product_general" cellspacing="0" cellpadding="0" id="Table1">
                        <tbody>
                            <tr>
                                <td style="padding-left: 10px;">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabel">
                                                    <span id="_ctl20_lblSummaryText" class="lblNormalClass" style="font-weight: bold; color: #666;">总结</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <textarea name="" id="Summary" rows="17" cols="92" style="width: 755px; height: 235px;resize:vertical;" readonly="yes"></textarea>
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
            <div class="ButtonBar WizardButtonBar" style="width: 96%;">
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
                            <span class="Text">完成</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                </ul>
            </div>
        </div>


        <div id="TicketMenu" class="menu">
            <ul style="width: 220px;">
                <li id="" onclick="TicketCompleteAll()"><i class="menu-i1"></i>全部完成</li>
                <li id="AsginAllLi" onclick="TicketAsginNewAll()"><i class="menu-i1"></i>全部关联新的配置项</li>
                <li id="" onclick="TicketNothingAll()"><i class="menu-i1"></i>全部不处理</li>
            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        $("#ckExist").trigger("click");
    })
    function TicketCompleteAll() {
        $(".TicketCom").prop("checked", true);
    }
    function TicketAsginNewAll() {
        $(".TicketAsgin").prop("checked", true);
    }
    function TicketNothingAll() {
        $(".TicketNothing").prop("checked", true);
    }

    function ToTargetSelect() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.WAREHOUSE_PRODUCT_CALLBACK %>&field=ToTargetId&callBack=ToTargetCallBack", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function ToTargetCallBack() {
        var ToTargetId = $("#ToTargetIdHidden").val();
        if (ToTargetId != "") {
            var productId = "";
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/WareHouseAjax.ashx?act=WarehouseProductInfo&id=" + ToTargetId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        productId = data.product_id;
                    }
                },
            });
            if (productId != "") {
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/ProductAjax.ashx?act=product&product_id=" + productId,
                    success: function (data) {
                        if (data != "") {
                            if (data.is_serialized) {
                                $("#TargetSeriNumTr").show();
                            } else {
                                $("#TargetSeriNumTr").hide();
                            }
                        }

                    },
                });
            }
            else {
                $("#TargetSeriNumTr").hide();
                $("#ToTargetXuLie").val("");
                $("#ToTargetXuLieHidden").val("");
            }
        }
        else {
            $("#TargetSeriNumTr").hide();
            $("#ToTargetXuLie").val("");
            $("#ToTargetXuLieHidden").val("");
        }
    }


    function ToTargetSerNumSelect() {
        var ToTargetId = $("#ToTargetIdHidden").val();
        if (ToTargetId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.WAREHOUSEPRODUCTSN %>&field=ToTargetXuLie&con1121=" + ToTargetId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择目标产品！");
        }

    }


    function ExistSelect() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.WAREHOUSE_PRODUCT_CALLBACK %>&field=ExistInvId&callBack=ExistCallBack", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    function ExistCallBack() {
        var ToTargetId = $("#ExistInvIdHidden").val();
        if (ToTargetId != "") {
            var productId = "";
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/WareHouseAjax.ashx?act=WarehouseProductInfo&id=" + ToTargetId,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        productId = data.product_id;
                    }
                },
            });
            if (productId != "") {
                $.ajax({
                    type: "GET",
                    async: false,
                    dataType: "json",
                    url: "../Tools/ProductAjax.ashx?act=product&product_id=" + productId,
                    success: function (data) {
                        if (data != "") {
                            if (data.is_serialized) {
                                $("#ExistInvSeriNumTr").show();
                            } else {
                                $("#ExistInvSeriNumTr").hide();
                            }
                        }

                    },
                });
            }
            else {
                $("#ExistInvSeriNumTr").hide();
                $("#ExistInvSeriNum").val("");
                $("#ExistInvSeriNumHidden").val("");
            }
        }
        else {
            $("#ExistInvSeriNumTr").hide();
            $("#ExistInvSeriNum").val("");
            $("#ExistInvSeriNumHidden").val("");
        }
    }


    function ExistSerNumSelect() {
        var ToTargetId = $("#ExistInvIdHidden").val();
        if (ToTargetId != "") {
            window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.WAREHOUSEPRODUCTSN %>&field=ExistInvSeriNum&con1121=" + ToTargetId, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
        }
        else {
            LayerMsg("请先选择库存产品！");
        }

    }

    $("#ckExist").click(function () {
        $(".web2New").prop("disabled", true);
        $("#AExiSelect").show();
        $("#ExistInvId").prop("disabled", false);
        $("#exsitingInventoryAsteriskSpan").css("color", "red");
        $("#newMaximumAsteriskSpan").css("color", "grey");
        $("#newMinimumAsteriskSpan").css("color", "grey");
        $("#newLocationAsteriskSpan").css("color", "grey");

    })
    $("#ckNew").click(function () {
        $(".web2New").prop("disabled", false);
        $("#AExiSelect").hide();
        $("#ExistInvId").prop("disabled", true);
        $("#exsitingInventoryAsteriskSpan").css("color", "grey");
        $("#newMaximumAsteriskSpan").css("color", "red");
        $("#newMinimumAsteriskSpan").css("color", "red");
        $("#newLocationAsteriskSpan").css("color", "red");

    })
    function LoadRes() {
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/ResourceAjax.ashx?act=GetResAndWorkGroup",
            success: function (data) {
                if (data != "") {
                    var resList = JSON.parse(data);
                    var resHtml = "";
                    resHtml += "<div class='grid' style='overflow: auto;height: 202px;'><table width='100%' border='0' cellspacing='0' cellpadding='3'><thead><tr><td width='1%'></td><td width='33%'>员工姓名</td ><td width='33%'>邮箱地址</td></tr ></thead ><tbody>";// <input type='checkbox' id='checkAll'/>
                    for (var i = 0; i < resList.length; i++) {
                        resHtml += "<tr><td><input type='checkbox' value='" + resList[i].id + "' class='" + resList[i].type + "' /></td><td>" + resList[i].name + "</td><td><a href='mailto:" + resList[i].email + "'>" + resList[i].email + "</a></td></tr>";
                    }
                    resHtml += "</tbody></table></div>";

                    $("#reshtml").html(resHtml);
                }
            },
        });
    }

    function GetConIds() {
        var ids = "";
        $(".checkCon").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ','
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyConIds").val(ids);
    }

    function GetResIds() {
        var ids = "";
        $(".checkRes").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ','
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#notifyResIds").val(ids);
    }

</script>
<!-- 上下页js 点击事件 -->
<script>
    var entityid = "";
    var Times = 0;
    $(".ticketTr").bind("contextmenu", function (event) {
        clearInterval(Times);
        //debugger;
        var oEvent = event;
        var menu = document.getElementById("TicketMenu");;
        entityid = $(this).data("val");
        (function () {
            menu.style.display = "block";
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        }());
        menu.onmouseenter = function () {
            clearInterval(Times);
            menu.style.display = "block";
        };
        menu.onmouseleave = function () {
            Times = setTimeout(function () {
                menu.style.display = "none";
            }, 600);
        };
        var Left = $(document).scrollLeft() + oEvent.clientX;
        var Top = $(document).scrollTop() + oEvent.clientY;
        var winWidth = window.innerWidth;
        var winHeight = window.innerHeight;
        var menuWidth = menu.clientWidth;
        var menuHeight = menu.clientHeight;
        var scrLeft = $(document).scrollLeft();
        var scrTop = $(document).scrollTop();
        var clientWidth = Left + menuWidth;
        var clientHeight = Top + menuHeight;
        var rightWidth = winWidth - oEvent.clientX;
        var bottomHeight = winHeight - oEvent.clientY;
        if (winWidth < clientWidth && rightWidth < menuWidth) {
            menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
        } else {
            menu.style.left = Left + "px";
        }
        if (winHeight < clientHeight && bottomHeight < menuHeight) {
            menu.style.top = winHeight - menuHeight - 18 - 25 + scrTop + "px";
        } else {
            menu.style.top = Top - 25 + "px";
        }
        document.onclick = function () {
            menu.style.display = "none";
        }
        return false;
    });
    $("#b1").click(function () {
        var ToTargetId = $("#ToTargetIdHidden").val();
        if (ToTargetId != "") {
            $(".TicketAsgin").prop("disabled", false);
            $("#AsginAllLi").show();
            var ToTargetXuLieHidden = $("#ToTargetXuLieHidden").val();
            if (!$("#TargetSeriNumTr").is(":hidden") && ToTargetXuLieHidden == "") {
                LayerMsg("请选择序列号！");
                return false;
            }
        } else {
            $(".TicketAsgin").prop("disabled", true);
            $("#AsginAllLi").hide();
        }

        $(".Workspace1").hide();
        if ($("#CkToWarehouse").is(":checked")) {
            $(".Workspace2").show();
        }
        else {
            <% if (noCloseTicket != null && noCloseTicket.Count > 0)
    { %>
            $(".Workspace3").show();
    <% }
    else
    { %>
            $(".Workspace4").show();
            <%} %>
        }

    })

    $("#b2").click(function () {
        if ($("#ckExist").is(":checked")) {
            var ExistInvId = $("#ExistInvIdHidden").val();
            if (ExistInvId == "") {
                LayerMsg("请通过查找带回选择库存产品！");
                return false;
            }
            var ExistInvSeriNum = $("#ExistInvSeriNum").val();
            if (!$("#ExistInvSeriNumTr").is(":hidden") && ExistInvSeriNum == "") {
                LayerMsg("请选择相关串号！");
                return false;
            }
        }
        else if ($("#ckNew").is(":checked")) {
            var newWareId = $("#newWareId").val();
            if (newWareId == "") {
                LayerMsg("请选择仓库！");
                return false;
            }
            var newSerNum = $("#newSerNum").val();
            if (newSerNum != undefined) {
                if (newSerNum == "") {
                    LayerMsg("请填写序列号！");
                    return false;
                }
            }
            var newMin = $("#newMin").val();
            if (newMin == "") {
                LayerMsg("请填写最小数！");
                return false;
            }
            var newMax = $("#newMax").val();
            if (newMax == "") {
                LayerMsg("请填写最大数！");
                return false;
            }
            if (Number(newMax) < Number(newMin)) {
                LayerMsg("最大值不能小于最小值！");
                return false;
            }
        }
        $(".Workspace2").hide();
          <% if (noCloseTicket != null && noCloseTicket.Count > 0)
    { %>
        $(".Workspace3").show();
    <% }
    else
    { %>
        $(".Workspace4").show();
            <%} %>
    })

    $("#a2").click(function () {
        $(".Workspace2").hide();
        $(".Workspace1").show();
    })
    $("#a3").click(function () {
        $(".Workspace3").hide();
        if ($("#CkToWarehouse").is(":checked")) {
            $(".Workspace2").show();
        }
        else {
            $(".Workspace1").show();
        }
    })
    $("#b3").click(function () {
        $(".Workspace3").hide();
        $(".Workspace4").show();
    })
    $("#a4").click(function () {
        $(".Workspace4").hide();
        <% if (noCloseTicket != null && noCloseTicket.Count > 0)
    { %>
        $(".Workspace3").show();
        <%}
    else
    { %>
        if ($("#CkToWarehouse").is(":checked")) {
            $(".Workspace2").show();
        }
        else {
            $(".Workspace1").show();
        }
        <%} %>
    })
    $("#b4").click(function () {
        var thisText = '当前配置项<%=thisProduct!=null?thisProduct.name:"" %>将停用';
        if ($("#CkToWarehouse").is(":checked")) {
            if ($("#ckExist").is(":checked")) {
                var ExistInvId = $("#ExistInvId").val();
                thisText += '\n\n库存产品' + ExistInvId+'数量将会加1';
            }
            else if ($("#ckNew").is(":checked")) {
                thisText += '\n\n新的配置项<%=thisProduct!=null?thisProduct.name:"" %>将被创建';
            }
        }
        <%if (thisContract != null)
    { %>
        var ToTargetId = $("#ToTargetId").val();
        var ToTargetIdHidden = $("#ToTargetIdHidden").val();
        if (ToTargetIdHidden != "") {
            thisText += '\n\n合同<%=thisContract!=null?thisContract.name:"" %>将关联到新的配置项' + ToTargetId; 
        }
        <%} %>

        <%if (thisSubList != null && thisSubList.Count > 0)
    { %>
        var ToTargetId = $("#ToTargetId").val();
        var ToTargetIdHidden = $("#ToTargetIdHidden").val();
        if (ToTargetIdHidden != "") {
            thisText += "\n\n以下订阅将会关联到新的配置项" + ToTargetId+"：<%=subNames %>";
        }
        <%} %>

        <%if (noCloseTicket != null && noCloseTicket.Count > 0){ %>
        var completeNo = "";
        $(".TicketCom").each(function () {
            if ($(this).is(":checked")) {
                // 
                var no = $(this).parent().parent().siblings(".TicketNoTd").eq(0).children().text();
                if (no != undefined && no != "") {
                    completeNo += no + ",";
                }
            }
        })
        if (completeNo != "") {
            completeNo = completeNo.substring(0, completeNo.length - 1);
            thisText += "\n\n以下工单将会被完成，并会生成一个系统备注:" + completeNo;
        }

        var asginNo = "";
        $(".TicketAsgin").each(function () {
            if ($(this).is(":checked")) {
                // 
                var no = $(this).parent().parent().siblings(".TicketNoTd").eq(0).children().text();
                if (no != undefined && no != "") {
                    asginNo += no + ",";
                }
            }
        })
        var ToTargetId = $("#ToTargetId").val();
        var ToTargetIdHidden = $("#ToTargetIdHidden").val();
        
        if (asginNo != "" && ToTargetIdHidden != "") {
            asginNo = asginNo.substring(0, asginNo.length - 1);
            thisText += "\n\n以下工单将会关联到新的配置项" + ToTargetId + "，并会生成一个系统备注：工单编号列表:" + asginNo;
        }
        <%} %>

        $("#Summary").html(thisText);
        // todo -统计
        $(".Workspace4").hide();
        $(".Workspace5").show();
    })
    $("#a6").click(function () {
        $(".Workspace4").show();
        $(".Workspace5").hide();
    })

    $("#b6").click(function () {
        $("#form1").submit();
    })




</script>
