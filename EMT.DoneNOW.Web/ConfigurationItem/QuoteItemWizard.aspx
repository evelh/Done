<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteItemWizard.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigurationItem.QuoteItemWizard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>配置项向导</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/LostOpp.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">配置项目向导</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--第一页-->
        <div class="Workspace Workspace1">
            <div class="PageInstructions">
                请为正在安装的产品输入默认的安装日期和质保日期.
            </div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td width="100%" valign="top">
                                <!--第一页主体-->
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td width="100%" class="FieldLabels">
                                                <div style="padding-bottom: 19px;">
                                                    安装日期设置
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="padding-bottom: 10px;">
                                                    <%-- <input type="radio" name="installChoice" checked style="margin-left: 10px;">--%><asp:RadioButton ID="rbBuyDate" runat="server" GroupName="installChoice" />
                                                    <span>购买日期</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="padding-bottom: 19px;">
                                                    <%--        <input type="radio" name="installChoice" style="margin-left: 10px;">--%>
                                                    <asp:RadioButton ID="rbInstallDate" runat="server" GroupName="installChoice" />
                                                    <span>安装日期</span>
                                                    <input type="text" onclick="WdatePicker()" id="chooseInsDate" class="Wdate">
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="100%" class="FieldLabels">
                                                <div style="padding-bottom: 19px;">
                                                    质保日期
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="padding-bottom: 10px;">
                                                    <%--<input type="radio" name="warChoice" checked style="margin-left:10px;">--%>
                                                    <asp:RadioButton ID="rbNo" GroupName="warChoice" runat="server" Checked="true" />
                                                    <span>无质保</span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="padding-bottom: 10px;">
                                                    <%--       <input type="radio" id="expiration" name="warChoice" style="margin-left: 10px;">--%>
                                                    <asp:RadioButton ID="rbThrDate" GroupName="warChoice" runat="server" />
                                                    <span>质保到期时间</span>
                                                    <input type="text" onclick="WdatePicker()" class="Wdate" id="throuEndDate" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="padding-bottom: 19px;">
                                                    <%--<input type="radio" name="warChoice" style="margin-left: 10px;">--%>
                                                    <asp:RadioButton ID="rbEffDate" GroupName="warChoice" runat="server" />
                                                    <span>质保有效期</span>
                                                    <input type="text" style="width: 66px;" id="DateSum" maxlength="3" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" />
                                                    <select style="width: 68px;" id="chooseDatetype">
                                                        <option value="day">天</option>
                                                        <option value="month">月</option>
                                                        <option value="year">年</option>
                                                    </select>
                                                    <span>距离今天</span>
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
            <div class="PageInstructions">选择以下产品作为配置项。相关信息可以修改，但不会修改成本。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td colspan="9" valign="top">
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td colspan="1" id="txtBlack8">
                                                <div class="DivScrollingContainer" style="top: 1px; margin-right: 10px;">
                                                    <div class="grid" style="overflow: auto;">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                                            <thead>
                                                                <tr>
                                                                    <td align="center" style="width: 20px;">
                                                                        <input type="checkbox" style="margin: 0;" id="CheckAllProduct" />
                                                                    </td>
                                                                    <td style="width: 150px;">产品名称</td>
                                                                    <td align="center">安装日期</td>
                                                                    <td align="center">质保截止日期 </td>
                                                                    <td>序列号</td>
                                                                    <td>参考号</td>
                                                                    <td>参考名</td>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (ExistProductItemList != null && ExistProductItemList.Count > 0)
                                                                    {
                                                                        foreach (var item in ExistProductItemList)
                                                                        {
                                                                            var product = new EMT.DoneNOW.DAL.ivt_product_dal().FindNoDeleteById((long)item.object_id);
                                                                %>
                                                                <tr>
                                                                    <td align="center"></td>
                                                                    <td style="width: 150px;">
                                                                        <span style="display: inline-block; width: 79%; vertical-align: top; font-size: 12px;">
                                                                            <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color: transparent; text-align: left" id="<%=item.id %>_product_id" value="<%=product==null?"":product.name %>" />
                                                                        </span>
                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate " name="<%=item.id %>_start_date" id="<%=item.id %>_start_date" value="" />
                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate" name="<%=item.id %>_through_date" id="<%=item.id %>_through_date" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" name="<%=item.id %>_serial_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" name="<%=item.id %>_reference_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" style="width: 60px;" name="<%=item.id %>_reference_name" value="" />
                                                                    </td>
                                                                </tr>
                                                                <%}
                                                                %>

                                                                <%} %>

                                                                <% int num = 0;
                                                                    if (productItemList != null && productItemList.Count > 0)
                                                                    {

                                                                        foreach (var item in productItemList)
                                                                        {
                                                                            num++;
                                                                            var product = new EMT.DoneNOW.DAL.ivt_product_dal().FindNoDeleteById((long)item.object_id);
                                                                %>
                                                                <tr>
                                                                    <td align="center">
                                                                        <input type="checkbox" id="<%=item.id+"_"+num %>_check_product" value="<%=item.id+"_"+num %>" class="CheckProduct" checked="checked" />
                                                                    </td>
                                                                    <td style="width: 150px;">
                                                                        <span style="display: inline-block; width: 79%; vertical-align: top; font-size: 12px;">
                                                                            <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color: transparent; text-align: left" id="<%=item.id+"_"+num %>_product_id" value="<%=product==null?"":product.name %>" />

                                                                        </span>
                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate start_date" name="<%=item.id+"_"+num %>_start_date" id="<%=item.id+"_"+num %>_start_date" value="" />
                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate through_date" name="<%=item.id+"_"+num %>_through_date" id="<%=item.id+"_"+num %>_through_date" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" id="<%=item.id+"_"+num %>_serial_number" name="<%=item.id+"_"+num %>_serial_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" id="<%=item.id+"_"+num %>_reference_number" name="<%=item.id+"_"+num %>_reference_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" style="width: 60px;" name="<%=item.id+"_"+num %>_reference_name" id="<%=item.id+"_"+num %>_reference_name" value="" />
                                                                    </td>
                                                                </tr>
                                                                <%}
                                                                %>

                                                                <%} %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <input type="hidden" id="ChooseProductIds" name="ChooseProductIds" />
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
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d2">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png">
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第三页 订阅-->
        <div class="Workspace Workspace3" style="display: none;">
            <div class="PageInstructions">订阅以下产品。相关信息可以修改，但不会修改报价项。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td colspan="9" valign="top">
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td colspan="1" id="txtBlack8">
                                                <div class="DivScrollingContainer" style="top: 1px; margin-right: 10px;">
                                                    <div class="grid" style="overflow: auto;">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                                            <thead>
                                                                <tr>
                                                                    <td align="center" style="width: 20px;">
                                                                        <input type="checkbox" style="margin: 0;" id="CheckAllSub" />
                                                                    </td>
                                                                    <td style="width: 150px;">产品名称</td>
                                                                    <td>序列号</td>
                                                                    <td>订阅名称</td>
                                                                    <td>订阅描述</td>
                                                                    <td>订阅期间类型</td>
                                                                    <td align="center">有效日期</td>
                                                                    <td align="center">到期日<span style="color:red;">*</span> </td>
                                                                    <td>价格<span style="color:red;">*</span></td>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="SubHtml">
                                                            </tbody>

                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <input type="hidden" id="ChooseSubIds" name="ChooseSubIds" />
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
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
                    <!--完成-->
                    <li class="right" style="display: none;" id="c3">
                        <a class="ImgLink">
                            <span class="Text">Finish</span>
                        </a>
                    </li>
                    <!--关闭-->
                    <li class="right" style="display: none;" id="d3">
                        <a class="ImgLink">
                            <img class="ButtonRightImg" src="../Images/cancel.png" />
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第四页 成本-->
        <div class="Workspace Workspace4" style="display: none;">
            <div class="PageInstructions">选择以下成本作为配置项。相关信息可以修改，但不会修改报价项。</div>
      <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr>
                            <td colspan="9" valign="top">
                                <table cellspacing="0" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td colspan="1" id="txtBlack8">
                                                <div class="DivScrollingContainer" style="top: 1px; margin-right: 10px;">
                                                    <div class="grid" style="overflow: auto;">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-collapse: collapse;">
                                                            <thead>
                                                                <tr>
                                                                    <td align="center" style="width: 20px;">
                                                                        <input type="checkbox" style="margin: 0;" id="CheckAllCharge" />
                                                                    </td>
                                                                    <td>计费代码名称</td>
                                                                    <td style="width: 150px;">产品名称</td>
                                                                    <td align="center">安装日期</td>
                                                                    <td align="center">质保截止日期 </td>
                                                                    <td>序列号</td>
                                                                    <td>参考号</td>
                                                                    <td>参考名</td>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (ExistProductItemList != null && ExistProductItemList.Count > 0)
                                                                    {
                                                                        foreach (var item in ExistProductItemList)
                                                                        {
                                                                            EMT.DoneNOW.Core.d_cost_code costCode = new EMT.DoneNOW.DAL.d_cost_code_dal().FindNoDeleteById((long)item.object_id);
                                                                %>
                                                                <tr>
                                                                    <td align="center"></td>
                                                                    <td style="width: 150px;">
                                                                        <span style="display: inline-block; width: 79%; vertical-align: top; font-size: 12px;">
                                                                            <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color: transparent; text-align: left" id="<%=item.id %>_charge_id" value="<%=costCode==null?"":costCode.name %>" />
                                                                        </span>
                                                                    </td>
                                                                    <td>

                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate " name="<%=item.id %>_charge_start_date" id="<%=item.id %>_charge_start_date" value="" />
                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate" name="<%=item.id %>_charge_through_date" id="<%=item.id %>_charge_through_date" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" name="<%=item.id %>_charge_serial_number" id="<%=item.id %>_charge_serial_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" id="<%=item.id %>_charge_reference_number" name="<%=item.id %>_charge_reference_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" style="width: 60px;" name="<%=item.id %>_charge_reference_name" id="<%=item.id %>_charge_reference_name" value="" />
                                                                    </td>
                                                                </tr>
                                                                <%}
                                                                %>

                                                                <%} %>

                                                                <% if (productItemList != null && productItemList.Count > 0)
                                                                    {

                                                                        foreach (var item in productItemList)
                                                                        {
                                                                            num++;
                                                                            EMT.DoneNOW.Core.d_cost_code costCode = new EMT.DoneNOW.DAL.d_cost_code_dal().FindNoDeleteById((long)item.object_id);
                                                                %>
                                                                <tr>
                                                                    <td align="center">
                                                                        <input type="checkbox" id="<%=item.id+"_"+num %>_check_charge" value="<%=item.id+"_"+num %>" class="ckCharge" checked="checked" />
                                                                    </td>
                                                                    <td style="width: 150px;">
                                                                        <span style="display: inline-block; width: 79%; vertical-align: top; font-size: 12px;">
                                                                            <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color: transparent; text-align: left" id="<%=item.id+"_"+num %>_charge_id" value="<%=costCode==null?"":costCode.name %>" />

                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        
                                                                        <span style="display: inline-block; width: 79%; vertical-align: top; font-size: 12px;">
                                                                            <input type="text" style="padding-left: 0px; border: 0px; font: bold; background-color: transparent; text-align: left" id="<%=item.id+"_"+num %>_product_id"  value="<%=defaultPro==null?"":defaultPro.name %>" />
                                                                            <input type="hidden" name="<%=item.id+"_"+num %>_product_id" id="<%=item.id+"_"+num %>_product_idHidden"/>
                                                                            </span>
                                                                        <img src="../Images/data-selector.png" style="vertical-align: middle;" onclick="CallBackPro('<%=item.id+"_"+num %>')" />
                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate start_date" name="<%=item.id+"_"+num %>_charge_start_date" id="<%=item.id+"_"+num %>_charge_start_date" value="" />
                                                                    </td>
                                                                    <td align="center">
                                                                        <input type="text" style="width: 80px;" onclick="WdatePicker()" class="Wdate through_date" name="<%=item.id+"_"+num %>_charge_through_date" id="<%=item.id+"_"+num %>_charge_through_date" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" id="<%=item.id+"_"+num %>_charge_serial_number" name="<%=item.id+"_"+num %>_charge_serial_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" id="<%=item.id+"_"+num %>_charge_reference_number" name="<%=item.id+"_"+num %>_charge_reference_number" style="width: 60px;" />
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" style="width: 60px;" name="<%=item.id+"_"+num %>_charge_reference_name" id="<%=item.id+"_"+num %>_charge_reference_name" value="" />
                                                                    </td>
                                                                </tr>
                                                                <%}
                                                                %>

                                                                <%} %>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <input type="hidden" id="ChooseChargeIds" name="ChooseChargeIds" />
            </div>
            <div class="ButtonBar WizardButtonBar" style="width: 97%;">
                <ul>
                    <!--上一层-->
                    <li id="a4">
                        <a class="ImgLink">
                            <img class="ButtonImg" src="../Images/move-left.png" />
                            <span class="Text">上一页</span>
                        </a>
                    </li>
                    <!--下一层-->
                    <li class="right" id="b4">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png" />
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
                            <img class="ButtonRightImg" src="../Images/cancel.png" />
                            <span class="Text">Close</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <!--第五页 相关操作确认-->
        <div class="Workspace Workspace5" style="display: none;">
            <div class="PageInstructions">以下操作将被执行。</div>
            <div class="WizardSection">
                <table cellspacing="0" cellpadding="0" width="100%">
                    <tbody>
                        <tr height="85%">
                            <td width="90%">
                                <table cellspacing="1" cellpadding="0" width="100%">
                                    <tbody>
                                        <tr>
                                            <td class="FieldLabels">
                                                <div>
                                                    <span style="display: inline-block;">
                                                        <img src="../Images/check.png" style="vertical-align: middle;" />
                                                    </span>
                                                <span style="color: #333333; font-weight: normal;">
                                                    根据产品型报价项创建(<span id="ProSum">0</span>)个配置项
                                                </span>
                                                </div>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td class="FieldLabels">
                                                <div>
                                                    <span style="display: inline-block;">
                                                        <img src="../Images/check.png" style="vertical-align: middle;" />
                                                    </span>
                                                <span style="color: #333333; font-weight: normal;">
                                                    创建(<span id="SubSum">0</span>)个订阅
                                                </span>
                                                </div>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td class="FieldLabels">
                                                <div>
                                                    <span style="display: inline-block;">
                                                        <img src="../Images/check.png" style="vertical-align: middle;" />
                                                    </span>
                                                <span style="color: #333333; font-weight: normal;">
                                                    根据成本性报价项创建(<span id="ChaSum">0</span>)个配置项

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
                    <li class="right" style="display: none;" id="b5">
                        <a class="ImgLink">
                            <span class="Text">下一页</span>
                            <img class="ButtonRightImg" src="../Images/move-right.png">
                        </a>
                    </li>
                    <!--完成-->
                    <li class="right" id="c5">
                        <a class="ImgLink">
                            <span class="Text">
                                <asp:Button ID="btnFinish" runat="server" Text="完成"  BorderStyle="None" OnClick="btnFinish_Click" /></span>
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
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(function () {
        $("#rbInstallDate").prop("checked", true);
    })
    Date.prototype.format = function (fmt) {
        var o = {
            "M+": this.getMonth() + 1,                 //月份 
            "d+": this.getDate(),                    //日 
            "h+": this.getHours(),                   //小时 
            "m+": this.getMinutes(),                 //分 
            "s+": this.getSeconds(),                 //秒 
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
            "S": this.getMilliseconds()             //毫秒 
        };
        if (/(y+)/.test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        }
        for (var k in o) {
            if (new RegExp("(" + k + ")").test(fmt)) {
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            }
        }
        return fmt;
    }
    $("#CheckAllProduct").click(function () {
        if ($(this).is(":checked")) {
            $(".CheckProduct").prop("checked",true);
        }
        else {
            $(".CheckProduct").prop("checked", false);
        }
    })
    $("#CheckAllSub").click(function () {
        if ($(this).is(":checked")) {
            $(".ckProSub").prop("checked", true);
        }
        else {
            $(".ckProSub").prop("checked", false);
        }
    })

    $("#CheckAllCharge").click(function () {
        if ($(this).is(":checked")) {
            $(".ckCharge").prop("checked", true);
        }
        else {
            $(".ckCharge").prop("checked", false);
        }
    })
    
    
    
    

    $("#b1").on("click", function () {
        var installDate = $("#chooseInsDate").val();
        if (installDate == "") {
            alert("请填写安装日期！");
            return false;
        } else {
            $(".start_date").val(installDate); 
        }
        if ($("#rbNo").is(":checked")) {
            $("#through_date").val("");
        }

        if ($("#rbThrDate").is(":checked")) {
            var throuEndDate = $("#throuEndDate").val();
            if (throuEndDate == "") {
                alert("请选择质保到期时间");
                return false;
            }
            else {
                $(".through_date").val(throuEndDate);
            }

        }

        if ($("#rbEffDate").is(":checked")) {
            var DateSum = $("#DateSum").val();
            if (DateSum == "") {
                alert("请填写质保有效期距今时间");
                return false;
            }
            else {
                debugger;
                var todayDate = new Date();
                var dateType = $("#chooseDatetype").val();
                var thrDate = dateAdd(todayDate, dateType, DateSum);
                if (thrDate != undefined && thrDate != "") {
                    thrDate = thrDate.format("yyyy-MM-dd");
                    $("#through_date").val(thrDate);
                }

            }
        }
        $(".Workspace1").hide();
        <% if (isShowProduct)
    {%>
        $(".Workspace2").show();
        <%}
        else
        {%>
         <%if (isShowCharge)
        { %>
        $(".Workspace4").show();
        <%}else{%>
        $(".Workspace5").show();
        <%}%>
        <%}%>
    })

    $("#b2").on("click", function () {
        var chooseProductIds = "";
        $(".CheckProduct").each(function () {
            if ($(this).is(":checked")) {
                chooseProductIds += $(this).val() + ',';
            }
        })
        if (chooseProductIds != "") {
            chooseProductIds = chooseProductIds.substring(0, chooseProductIds.length - 1);
        }
        $("#ChooseProductIds").val(chooseProductIds);
        $(".Workspace2").hide();
        if (chooseProductIds != "") {
            $(".Workspace3").show();
            GetSubByProIds();
            var chooseProArr = chooseProductIds.split(',');
            $("#ProSum").html(chooseProArr.length);
        } else {
            $("#ProSum").html('0');
            <%if (isShowCharge)
    { %>
            $(".Workspace4").show();
            <%}
    else
    {%>
            $(".Workspace5").show();
            <%}%>
        }
    })
    $("#a2").on("click", function () {
        $(".Workspace1").show();
        $(".Workspace2").hide();
    });

    $("#a3").on("click", function () {
        $(".Workspace2").show();
        $(".Workspace3").hide();
    });


    $("#b3").on("click", function () {

        var isHasNulPrice = "";

        $(".subPrice").each(function () {
            var isCheck = $(this).parent().parent().children().first().children().first().is(":checked");
            if (isCheck) {
                var thisValue = $(this).val();
                if (thisValue == "" || $.trim(thisValue) == "" || isNaN(thisValue)) {
                    isHasNulPrice += "1";
                }
            }
            
        })
        if (isHasNulPrice != "") {
            alert("请填写相关价格");
            return false;
        }
        var sub_start_date = "";
        $(".sub_start_date").each(function () {
            var isCheck = $(this).parent().parent().children().first().children().first().is(":checked");
            if (isCheck) {
                var thisValue = $(this).val();
                if (thisValue == "" || $.trim(thisValue) == "") {
                    sub_start_date += "1";
                }
            }
           
        })
        if (sub_start_date != "") {
            alert("请填写有效日期，并且要早于订阅的有效日期");
            return false;
        }
        var sub_thr_date = "";
        $(".sub_thr_date").each(function () {
            var isCheck = $(this).parent().parent().children().first().children().first().is(":checked");
            if (isCheck) {
                var thisValue = $(this).val();
                var srateDate = $(this).parent().prev().children().first().val();
                if (thisValue == "" || $.trim(thisValue) == "" || compareTime(srateDate, thisValue)) {
                    sub_thr_date += "1";
                }
            }
            
        })
        if (sub_thr_date != "") {
            alert("请填写订阅到期日期，并且要晚于订阅的有效日期");
            return false;
        }
        //if (compareTime(estimated_beginTime, estimated_end_time)) {
        //    LayerMsg("结束时间不能早于开始时间");
        //    return false;
        //}

        var chooseSubIds = "";
        $(".ckProSub").each(function () {
            if ($(this).is(":checked")) {
                chooseSubIds += $(this).val() + ',';
            }
        })
        if (chooseSubIds != "") {
            chooseSubIds = chooseSubIds.substring(0, chooseSubIds.length - 1);
            var subIdArr = chooseSubIds.split(',');
            $("#SubSum").html(subIdArr.length);
        }
        else {
            $("#SubSum").html('0');
        }
        $("#ChooseSubIds").val(chooseSubIds);
        $(".Workspace3").hide();
         <%if (isShowCharge)
    { %>
        $(".Workspace4").show();
            <%}
    else
    {%>
            $(".Workspace5").show();
            <%}%>

    });

    $("#b4").on("click", function () {
        var chooseChargeIds = "";
        $(".ckCharge").each(function () {
            if ($(this).is(":checked")) {
                chooseChargeIds += $(this).val() + ',';
            }
        })
        if (chooseChargeIds != "") {
            chooseChargeIds = chooseChargeIds.substring(0, chooseChargeIds.length - 1);
            var chaIdArr = chooseChargeIds.split(',');
            $("#ChaSum").html(chaIdArr.length);
        }
        else {
            $("#ChaSum").html('0');
        }
        $("#ChooseChargeIds").val(chooseChargeIds);

        $(".Workspace4").hide();
        $(".Workspace5").show();

    });
    $("#a4").on("click", function () {
       
        $(".Workspace4").hide();
        <%if (isShowProduct)
    { %>
        var subIds = $("#ChooseSubIds").val();
        if (subIds != "") {
            $(".Workspace3").show();
        } else {
            $(".Workspace2").show();
        }
        <%}
    else
    {%>
        $(".Workspace1").show();
        <%}%>
        

    });


    $("#a5").click(function () {
        $(".Workspace5").hide();
           <%if (isShowCharge)
    { %>
        $(".Workspace4").show();
        <%}
    else
    {%>
        var subIds = $("#ChooseSubIds").val();
        if (subIds != "") {
            $(".Workspace3").show();
        }
        else {
            <% if (isShowProduct)
            {%>
            $(".Workspace2").show();
            <%}
            else
            {%>
            $(".Workspace1").show();
            <%}%>
            
        }
        <%}%>
    })

    $("#btnFinish").click(function () {
        var installDate = $("#chooseInsDate").val();
        if (installDate == "") {
            alert("请填写安装日期！");
            return false;
        }
        if ($("#rbThrDate").is(":checked")) {
            var throuEndDate = $("#throuEndDate").val();
            if (throuEndDate == "") {
                alert("请选择质保到期时间");
                return false;
            }
        }
        if ($("#rbEffDate").is(":checked")) {
            var DateSum = $("#DateSum").val();
            if (DateSum == "")
            {
                alert("请填写质保有效期距今时间");
                return false;
            }
        }
        return true;
    })

    function dateAdd(date, strInterval, dateNumber) {  //参数分别为日期对象，增加的类型，增加的数量 
        debugger;
        var dtTmp = date;
        switch (strInterval) {
            case 'second':
            case 's':
                return new Date(Date.parse(dtTmp) + (1000 * dateNumber));
            case 'minute':
            case 'n':
                return new Date(Date.parse(dtTmp) + (60000 * dateNumber));
            case 'hour':
            case 'h':
                return new Date(Date.parse(dtTmp) + (3600000 * dateNumber));
            case 'day':
            case 'd':
                return new Date(Date.parse(dtTmp) + (86400000 * dateNumber));
            case 'week':
            case 'w':
                return new Date(Date.parse(dtTmp) + ((86400000 * 7) * dateNumber));
            case 'month':
            case 'm':
                return new Date(dtTmp.getFullYear(), Number(dtTmp.getMonth()) + Number(dateNumber), dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
            case 'year':
            case 'y':
                return new Date((Number(dtTmp.getFullYear()) + Number(dateNumber)), dtTmp.getMonth(), dtTmp.getDate(), dtTmp.getHours(), dtTmp.getMinutes(), dtTmp.getSeconds());
        }
    }

    // 根据第二页选择的产品 填充第三页的订阅信息
    function GetSubByProIds() {
        debugger;
        var SubHtml = "";
        var ChooseProductIds = $("#ChooseProductIds").val();
        if (ChooseProductIds != "") {
            var periodHtml = "";
            // GetGenListByTableId
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/GeneralAjax.ashx?act=GetGenListByTableId&table_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE %>",
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            periodHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },

            });

            var proIdArr = ChooseProductIds.split(',');
            for (var i = 0; i < proIdArr.length; i++) {
                SubHtml += "<tr>";
                SubHtml += "<td><input type='checkBox' id='" + proIdArr[i] + "_sub' class='ckProSub' value='" + proIdArr[i] + "_sub' checked='checked' /></td>";
                SubHtml += "<td>" + $("#" + proIdArr[i] + "_product_id").val() + "</td>";
                SubHtml += "<td>" + $("#" + proIdArr[i] + "_serial_number").val() + "</td>";
                SubHtml += "<td><input type='text' id='" + proIdArr[i] + "_name' name='" + proIdArr[i] + "_name' value='" + $("#" + proIdArr[i] + "_product_id").val() + "'/></td>";
                SubHtml += "<td><input type='text' id='" + proIdArr[i] + "_des' name='" + proIdArr[i] + "_des' value=''/></td>";
                SubHtml += "<td><select id='" + proIdArr[i] + "_period' name='" + proIdArr[i] + "_period'>" + periodHtml + "</select></td>";
                SubHtml += "<td><input type='text' style='width: 80px;' onclick='WdatePicker()' class='Wdate sub_start_date' name='" + proIdArr[i] + "_sub_start_date' id='" + proIdArr[i] + "_sub_start_date' value='" + $("#" + proIdArr[i] + "_start_date").val() + "' /></td>";
                SubHtml += "<td><input type='text' style='width: 80px;' onclick='WdatePicker()' class='Wdate sub_thr_date' name='" + proIdArr[i] + "_sub_through_date' id='" + proIdArr[i] + "_sub_through_date' value='" + $("#" + proIdArr[i] + "_through_date").val() + "' /></td>";
                SubHtml += "<td><input type='text' style='width: 80px;' name='" + proIdArr[i] + "_sub_per_price' id='" + proIdArr[i] + "_sub_per_price' value='' class='subPrice'/></td>";
                SubHtml += "</tr>";
            }
        }
        $("#SubHtml").html(SubHtml);
    }
    function CallBackPro(pageProId) {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CALLBACK %>&field=" + pageProId + "_product_id", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
</script>
