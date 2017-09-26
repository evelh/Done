<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SaleOrderEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.SaleOrder.SaleOrderEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑销售订单</title>
       <link rel="stylesheet" href="../Content/reset.css" />
    <style>
        body{
    overflow: hidden;
}
/*顶部内容和帮助*/
.TitleBar{
    color: #fff;
    background-color: #346a95;
    display: block;
    font-size: 15px;
    font-weight: bold;
    height: 36px;
    line-height: 38px;
    margin: 0 0 10px 0;
}
.TitleBar>.Title{
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
.text2{
    margin-left: 5px;
}
.help{
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
.ButtonContainer{
    padding: 0 10px 10px 10px;
    width: auto;
    height: 26px;
}
.ButtonContainer ul li .Button{
    margin-right: 5px;
    vertical-align: top;
}
li.Button{
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
.Button>.Icon{
    display: inline-block;
    flex: 0 0 auto;
    height: 16px;
    margin: 0 3px;
    width: 16px;
}
.Save,.SaveAndClone,.SaveAndNew{
    background-image: url("../Images/save.png");
}
.Cancel{
    background-image: url("../Images/cancel.png");
}
.Button>.Text{
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
    color:black;
}
.TabBar a.Button {
    background: #eaeaea;
    border: solid 1px #dfdfdf;
    border-bottom-color: #adadad;
    color: #858585;
    height: 24px;
    padding: 0;
    margin: 0 0 -1px 5px;
    width:100px;
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
a.Button>.Text {
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
.DivSectionWithHeader>.HeaderRow>span {
    display: inline-block;
    vertical-align: middle;
    position: relative;
}
.DivSectionWithHeader>.HeaderRow>span {
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
.Section>.Content .Editor .CustomHtml a.Button.Link {
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
.eee{
    width:114px;display: inline-block;float: left;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="TitleBar">
            <div class="Title">
                <span class="text1">编辑销售订单</span>
                <a href="###" class="help"></a>
            </div>
        </div>
        <!--按钮-->
        <div class="ButtonContainer">
            <ul>
                <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                    <span class="Icon SaveAndClone"></span>
                    <span class="Text">
                        <asp:Button ID="save_close" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="save_close_Click"  /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="SaveAndOpenButton" tabindex="0">
                    <span class="Icon SaveAndClone"></span>
                    <span class="Text">
                        <asp:Button ID="save_open" runat="server" Text="保存并打开销售订单" BorderStyle="None" OnClick="save_open_Click" /></span>
                </li>
                <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                    <span class="Icon Cancel"></span>
                    <span class="Text">取消</span>
                </li>
            </ul>
        </div>
        <!--切换按钮-->
        <div class="TabBar">
            <a class="Button ButtonIcon SelectedState">
                <span class="Text">常规</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">自定义</span>
            </a>
            <a class="Button ButtonIcon">
                <span class="Text">通知</span>
            </a>
        </div>
        <!--切换项-->
        <div class="TabContainer">
            <div class="DivScrollingContainer" style="top: 120px;">
                <div class="DivSectionWithHeader">
                    <div class="HeaderRow">
                        <span>常规信息</span>
                    </div>
                    <div class="Content">
                        <table width="100%">
                            <tbody>
                                <tr>
                                    <td>
                                        <span class="lblNormalClass">客户名称</span>
                                        <div>
                                            <%
                                                var account = new EMT.DoneNOW.BLL.CompanyBLL().GetCompany(opportunity.account_id);
                                                %>
                                            <span><%=account==null?"":account.name %></span>
                                         <%--   <input type="hidden" name=""/>--%>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span class="lblNormalClass">销售订单名称</span>
                                        <div>
                                            <span><%=opportunity.name %></span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 120px">
                                        <span class="lblNormalClass">状态</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <asp:DropDownList ID="status_id" runat="server" CssClass="txtBlack8Class" Width="314px"></asp:DropDownList>
                                                
                                            </span>
                                        </div>
                                    </td>
                                    <td align="left" style="padding-left: 50px;">
                                        <span class="lblNormalClass">开始日期</span>
                                        <span class="errorSmallClass">*</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input id="begin_date" name="begin_date" type="text" onclick="WdatePicker()" class="Wdate txtBlack8Class" value="<%=sale_order.begin_date.ToString("yyyy-MM-dd") %>">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="lblNormalClass">联系人</span>
                                        <span class="errorSmallClass">*</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input type="hidden" name="oldContactId" id="oldContactId" value="<%=sale_order.contact_id==null?"":sale_order.contact_id.ToString() %>"/>
                                                <asp:DropDownList ID="contact_id" runat="server" CssClass="txtBlack8Class" Width="314px"></asp:DropDownList>

                                              
                                            </span>
                                        </div>
                                    </td>
                                    <td align="left" style="padding-left: 50px;">
                                        <span class="lblNormalClass">截止日期</span>
                                        <span class="errorSmallClass">*</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input id="end_date" name="end_date" type="text" onclick="WdatePicker()" class="Wdate txtBlack8Class" value="<%=sale_order.end_date==null?"":((DateTime)sale_order.end_date).ToString("yyyy-MM-dd") %>" />
                                            </span>
                                            <span class="CustomHtml">
                                                <a class="Button ButtonIcon Link NormalState" onclick="AddTime(0)">Today</a>
                                                <span>|</span>
                                                <a class="Button ButtonIcon Link NormalState" onclick="AddTime(7)")>7</a>
                                                <span>|</span>
                                                <a class="Button ButtonIcon Link NormalState" onclick="AddTime(30)">30</a>
                                                <span>|</span>
                                                <a class="Button ButtonIcon Link NormalState" onclick="AddTime(60)">60</a>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="lblNormalClass">负责人</span>
                                        <span class="errorSmallClass">*</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <asp:DropDownList ID="owner_resource_id" runat="server" CssClass="txtBlack8Class" Width="314px"></asp:DropDownList>
                                              
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <%
                    // dLocaition 是客户的默认地址
                    EMT.DoneNOW.Core.crm_location dLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocationByAccountId(account.id);
                    EMT.DoneNOW.Core.crm_location bill_to_location = null;
                    EMT.DoneNOW.Core.crm_location ship_to_location = null;
                    if (sale_order.bill_to_location_id != null)
                    {
                         bill_to_location = new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)sale_order.bill_to_location_id);
                    }
                    if (sale_order.ship_to_location_id != null)
                    {
                         ship_to_location = new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)sale_order.ship_to_location_id);
                    }
                    %>

                <input type="hidden" name="location_id" id="location_id" value="<%=dLocation.id %>"/>
                <input type="hidden" name="country_id" id="country_id" value="<%=dLocation.country_id %>"/>
                <input type="hidden" name="province_id" id="province_id" value="<%=dLocation.province_id %>"/>
                <input type="hidden" name="city_id" id="city_id" value="<%=dLocation.city_id %>"/>
                <input type="hidden" name="district_id" id="district_id" value="<%=dLocation.district_id %>"/>
                <input type="hidden" name="address" id="address" value="<%=dLocation.address %>"/>
                <input type="hidden" name="additional_address" id="additional_address" value="<%=dLocation.additional_address %>"/>
                <input type="hidden" name="postal_code" id="postal_code" value="<%=dLocation.postal_code %>"/>





                <div class="DivSectionWithHeader">
                    <div class="HeaderRow">
                        <span>账单地址 </span>
                    </div>
                    <div class="Content">
                        <table width="100%">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <span class="FieldLabel">
                                                <span class="txtBlack8Class">
                                                    <asp:CheckBox ID="billTo_use_account_address" runat="server" />
                                                    <%--<input type="checkbox" style="vertical-align: middle;" />--%>
                                                    <label style="vertical-align: middle;">与客户地址相同</label>
                                                    <input type="hidden" name="billLocationId" value="<%=sale_order.bill_to_location_id==null?"":sale_order.bill_to_location_id.ToString() %>"/>
                                                </span>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 120px">
                                        <span class="lblNormalClass">地址</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input type="text" id="bill_address" name="bill_address"  style="width: 300px;" class="txtBlack8Class" value="<%=bill_to_location!=null?bill_to_location.address:"" %>">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 120px">
                                        <span class="lblNormalClass">补充地址</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input type="text" id="bill_address2" name="bill_address2" style="width: 300px;" class="txtBlack8Class" value="<%=bill_to_location!=null?bill_to_location.additional_address:"" %>">
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="eee">
                                        <span class="lblNormalClass">省份</span>
                                        <div style="width: 80px;">
                                            <span style="display: inline-block">
                                                  <input id="bill_province_idInit" value="<%=bill_to_location==null?"":bill_to_location.province_id.ToString() %>" type="hidden"  />
                                                <select id="bill_province_id" name="bill_province_id" style="width: 85px;">
                                                </select>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="eee">
                                        <span class="lblNormalClass">城市</span>
                                        <div style="width: 80px;">
                                            <span style="display: inline-block">
                                                 <input id="bill_city_idInit" value="<%=bill_to_location==null?"":bill_to_location.city_id.ToString() %>" type="hidden"  />
                                                <select id="bill_city_id" name="bill_city_id" style="width: 85px;">
                                                </select>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="eee">
                                        <span class="lblNormalClass">区县</span>
                                        <div style="width: 80px;">
                                            <span style="display: inline-block">
                                                 <input id="bill_district_idInit" value="<%=bill_to_location==null?"":bill_to_location.district_id.ToString() %>" type="hidden"  />
                                                <select  name="bill_district_id" id="bill_district_id"  style="width: 85px;">
                                             
                                                </select>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="lblNormalClass">国家</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <asp:DropDownList ID="bill_country_id" CssClass="txtBlack8Class" runat="server" Width="314px"></asp:DropDownList>
                                            
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 120px">
                                        <span class="lblNormalClass">邮编</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input type="text" name="bill_postcode" id="bill_postcode" style="width: 300px;" class="txtBlack8Class" value="<%=bill_to_location==null?"":bill_to_location.postal_code %>" />
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="DivSectionWithHeader">
                    <div class="HeaderRow">
                        <span>配送地址</span>
                        <input type="hidden" id="shipLocationId" name="shipLocationId" value="<%=ship_to_location==null?"":ship_to_location.id.ToString() %>"/>
                    </div>
                    <div class="Content">
                        <table width="100%">
                            <tbody>
                                <tr>
                                    <td>
                                        <div>
                                            <span class="FieldLabel">
                                                <span class="txtBlack8Class">
                                                    <asp:CheckBox ID="shipTo_use_account_address" runat="server" />
                                                    <%--<input type="checkbox" style="vertical-align: middle;">--%>
                                                    <label style="vertical-align: middle;">与客户地址相同</label>
                                                </span>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>
                                            <span class="FieldLabel">
                                                <span class="txtBlack8Class">
                                                    <asp:CheckBox ID="shipTo_use_bill_to_address" runat="server" />
                                                    <%--<input type="checkbox" style="vertical-align: middle;">--%>
                                                    <label style="vertical-align: middle;">与账单地址相同</label>
                                                </span>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 120px">
                                        <span class="lblNormalClass">地址</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input name="ship_address" id="ship_address" type="text" style="width: 300px;" class="txtBlack8Class" value="<%=ship_to_location==null?"":ship_to_location.address %>" />
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 120px">
                                        <span class="lblNormalClass">补充地址</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input type="text" style="width: 300px;" class="txtBlack8Class" name="ship_address2" id="ship_address2" value="<%=ship_to_location==null?"":ship_to_location.additional_address %>" >
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="eee">
                                        <span class="lblNormalClass">省份</span>
                                        <div style="width: 80px;">
                                            <span style="display: inline-block">
                                                 <input id="ship_province_idInit" value="<%=ship_to_location==null?"":ship_to_location.province_id.ToString() %>" type="hidden"  />
                                                <select  name="ship_province_id" id="ship_province_id"  style="width: 85px;">
                                                  
                                                </select>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="eee">
                                        <span class="lblNormalClass">城市</span>
                                        <div style="width: 80px;">
                                            <span style="display: inline-block">
                                                  <input id="ship_city_idInit" value="<%=ship_to_location==null?"":ship_to_location.city_id.ToString() %>" type="hidden"  />
                                                <select name="ship_city_id" id="ship_city_id" style="width: 85px;">
                                                 
                                                </select>
                                            </span>
                                        </div>
                                    </td>
                                    <td class="eee">
                                        <span class="lblNormalClass">区县</span>
                                          <input id="ship_district_idInit" value="<%=ship_to_location==null?"":ship_to_location.district_id.ToString() %>" type="hidden"  />
                                        <div style="width: 80px;">
                                            <span style="display: inline-block">
                                                <select name="ship_district_id" id="ship_district_id"  style="width: 85px;">
                                                   
                                                </select>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <span class="lblNormalClass">国家</span>
                                        <div>
                                            <span style="display: inline-block">
                                                  <asp:DropDownList ID="ship_country_id" CssClass="txtBlack8Class" runat="server" Width="314px"></asp:DropDownList>
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" style="width: 120px">
                                        <span class="lblNormalClass">邮编</span>
                                        <div>
                                            <span style="display: inline-block">
                                                <input type="text"  name="ship_postcode" id="ship_postcode"  style="width: 300px;" class="txtBlack8Class" value="<%=ship_to_location==null?"":ship_to_location.postal_code %>" />
                                            </span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="TabContainer" style="display: none;">
                  <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">


                <% if (sale_udfList != null && sale_udfList.Count > 0)
                    {

                        foreach (var udf in sale_udfList)
                        {
                            if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                            {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=sale_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <textarea id="<%=udf.id %>" rows="2" cols="20"><%=sale_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %></textarea>

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=sale_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" />

                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                    {%>
                <tr>
                    <td>
                        <div class="clear">
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" value="<%=sale_udfValueList.FirstOrDefault(_=>_.id==udf.id).value %>" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" ondblclick="" />
                        </div>
                    </td>
                </tr>
                <%}
                    else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                    {%>

                <%}
                        }
                    } %>
            </table>
        </div>
        <div class="TabContainer" style="display: none;">
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
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
    var s2 = ["ship_province_id", "ship_city_id", "ship_district_id"];
    var s3 = ["bill_province_id", "bill_city_id", "bill_district_id"];
    $(function () {
        //var s1 = ["province_id", "city_id", "district_id"];
     
       //  InitArea(s1);  // 地址下拉框
        InitArea(s2);  // 地址下拉框
        InitArea(s3);  // 地址下拉框
    })


    $("#billTo_use_account_address").click(function () {
        if ($(this).is(":checked")) {
            // 代表选中的时候给地址相关信息赋值
            $("#bill_address").val($("#address").val());
            $("#bill_address2").val($("#additional_address").val());
            //$("#bill_province_id").val($("#province_id").val());
            //$("#bill_city_id").val($("#city_id").val());
            //$("#bill_district_id").val($("#district_id").val());
            $("#bill_province_idInit").val($("#province_id").val());
            $("#bill_city_idInit").val($("#city_id").val());
            $("#bill_district_idInit").val($("#district_id").val());
            $("#bill_country_id").val($("#country_id").val());
            $("#bill_postcode").val($("#postal_code").val());
            InitArea(s3);
        }
    })

    $("#shipTo_use_account_address").click(function () {
        if ($(this).is(":checked")) {
            // 代表选中的时候给地址相关信息赋值
            $("#ship_address").val($("#address").val());
            $("#ship_address2").val($("#additional_address").val());
            //$("#ship_province_id").val($("#province_id").val());
            //$("#ship_city_id").val($("#city_id").val());
            //$("#ship_district_id").val($("#district_id").val());
            //$("#ship_country_id").val($("#country_id").val());
            $("#ship_province_idInit").val($("#province_id").val());
            $("#ship_city_idInit").val($("#city_id").val());
            $("#ship_district_idInit").val($("#district_id").val());
            $("#ship_country_id").val($("#country_id").val());
            $("#ship_postcode").val($("#postal_code").val());
            InitArea(s2);
        }
    })

    $("#shipTo_use_bill_to_address").click(function () {
        if ($(this).is(":checked")) {
            // 代表选中的时候给地址相关信息赋值
            $("#ship_address").val($("#bill_address").val());
            $("#ship_address2").val($("#bill_address2").val());
            $("#ship_province_idInit").val($("#bill_province_id").val());
            $("#ship_city_idInit").val($("#bill_city_id").val());
            $("#ship_district_idInit").val($("#bill_district_id").val());
            $("#ship_country_id").val($("#bill_country_id").val());
            //$("#ship_province_id").val($("#bill_province_id").val());
            //$("#ship_city_id").val($("#bill_city_id").val());
            //$("#ship_district_id").val($("#bill_district_id").val());
            //$("#ship_country_id").val($("#bill_country_id").val());
            $("#ship_postcode").val($("#bill_postcode").val());
            InitArea(s2);
        }
    })


    $("#save_close").click(function () {
        if (!submitCheck()) {
            return false;
        }
        return true;
    })
    $("#save_open").click(function () {
        if (!submitCheck()) {
            return false;
        }
        return true;
    })
    function submitCheck() {
        var status_id = $("#status_id").val();
        if (status_id == 0) {
            alert('请选择状态！');
            return false;
        }
        var contact_id = $("#contact_id").val();
        if (contact_id == 0) {
            alert('请选择联系人！');
            return false;
        }
        var owner_resource_id = $("#owner_resource_id").val();
        if (owner_resource_id == 0) {
            alert('请选择负责人！');
            return false;
        }
        var begin_date = $("#begin_date").val();
        if (begin_date == "") {
            alert('请填写开始时间！');
            return false;
        }
        var end_date = $("#end_date").val();
        if (end_date == "") {
            alert('请填写截止时间！');
            return false;
        }
        if (new Date(begin_date) > new Date(end_date)) {
            alert('开始时间要早于截止时间!');
            return false;
        }
        return true;

    }
    function AddTime(time) {
        var date = new Date();
        date.setDate(Number(date.getDate()) + Number(time));
        var newDate = date.getFullYear() + '-' + returnNumber((date.getMonth() + 1)) + '-' + returnNumber(date.getDate());
        $("#end_date").val(newDate);
            
    }
    function InitArea(s) {
        debugger;
        document.getElementById(s[0]).onchange = new Function('change(0,["' + s[0] + '","' + s[1] + '","' + s[2] + '"])');
        document.getElementById(s[1]).onchange = new Function('change(1,["' + s[0] + '","' + s[1] + '","' + s[2] + '"])');
        $("#" + s[0]).empty();
        $("#" + s[1]).empty();
        $("#" + s[2]).empty();
        $("#" + s[0]).append($("<option>").val("").text("请选择"));
        $("#" + s[1]).append($("<option>").val("").text("请选择"));
        $("#" + s[2]).append($("<option>").val("").text("请选择"));



        $.ajax({
            type: "POST",
            url: "../Tools/AddressAjax.ashx?act=district",
            //data: data,
            dataType: "JSON",
            timeout: 20000,
            async: false,
            beforeSend: function () {
                //$("body").append(loadDialog);
            },
            success: function (data) {
                if (data.code !== 0) {
                    show_alert(data.msg);
                } else {
                    for (i = 0; i < data.data.length; i++) {
                        var option = $("<option>").val(data.data[i].val).text(data.data[i].show);
                        $("#" + s[0]).append(option);
                    }

                    var initVal = $("#" + s[0] + "Init") ? $("#" + s[0] + "Init").val() : 0;
                    if (initVal != undefined && initVal != 0) {
                        $("#" + s[0]).val(initVal);
                        $("#" + s[0] + "Init").val(0);

                        change(0, s);
                    }
                }
            },
            error: function (XMLHttpRequest) {
                //$("#LoadingDialog").remove();
                //console.log(XMLHttpRequest);
                alert('请检查网络');
            }
        });
    }
    function change(index, s) {


        var sel = $("#" + s[index]).val();

        var url = "Tools/AddressAjax.ashx?act=district&pid=" + sel;
        var initVal = $("#" + s[index + 1] + "Init") ? $("#" + s[index + 1] + "Init").val() : 0;
        if (index == 0) {
            $("#" + s[1]).empty();
            $("#" + s[1]).append($("<option>").val("").text("请选择"));
        }
        $("#" + s[2]).empty();
        $("#" + s[2]).append($("<option>").val("").text("请选择"));


        $.ajax({
            type: "POST",
            url: "../Tools/AddressAjax.ashx?act=district&pid=" + sel,
            //data: data,
            dataType: "JSON",
            timeout: 20000,
            async: false,
            beforeSend: function () {
                //$("body").append(loadDialog);
            },
            success: function (data) {

                if (data.code !== 0) {
                    show_alert(data.msg);
                } else {

                    for (i = 0; i < data.data.length; i++) {
                        var option = $("<option>").val(data.data[i].val).text(data.data[i].show);
                        $("#" + s[index + 1]).append(option);
                    }
                    if (initVal != undefined && initVal != 0) {
                        $("#" + s[index + 1]).val(initVal);
                        $("#" + s[index + 1] + "Init").val(0);
                        if (index < 1)
                            change(1, s);
                    }
                }
            },
            error: function (XMLHttpRequest) {
                //$("#LoadingDialog").remove();
                //console.log(XMLHttpRequest);
                alert('请检查网络');
            }
        });



    }
    // 获取到联系人列表
    //function GetContact()
    //{
    //    // oldContactId
    //    var oldContactId = $("#oldContactId").val();
    //    $("#contact_id").html("");
    //    $.ajax({
    //        type: "GET",
    //        async: false,
    //        // 如果使用父客户的联系人 可以加入 &userParentContact=true 即可使用父客户联系人
    //        url: "../Tools/CompanyAjax.ashx?act=contact&account_id=" + account_id,
    //        // data: { CompanyName: companyName },
    //        success: function (data) {
    //            if (data != "") {
    //                $("#contact_id").html(data);
    //                if (oldContactId != "") {
    //                    $("#contact_id").val(oldContactId);
    //                }
    //            }
    //        },
    //    });

    //}


    // 根据客户ID填充联系人下拉框 -- todo 
    // 地址选中后地址相关信息赋值 --todo
</script>
