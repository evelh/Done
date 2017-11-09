<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SaleOrderView.aspx.cs" Inherits="EMT.DoneNOW.Web.SaleOrder.SaleOrderView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
  <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>查看销售订单</title>
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
.collection{
    background-image: url(../Images/collection.png);
    cursor: pointer;
    display: inline-block;
    height: 16px;
    position: absolute;
    right: 38px;
    top: 10px;
    width: 16px;
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
.Tools{
    background-image: url("../Images/dropdown.png");
}
.Add{
    background-image: url("../Images/add.png");
}
.Print{
    background-image: url("../Images/print.png");
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
/*工具*/
.RightClickMenu,.LeftClickMenu {
    padding: 16px;
    background-color: #FFF;
    border: solid 1px #CCC;
    cursor: pointer;
    z-index: 999;
    position: absolute;
    box-shadow: 1px 1px 4px rgba(0,0,0,0.33);
}
.RightClickMenuItem {
    min-height: 24px;
    min-width: 100px;
}
.RightClickMenuItemIcon {
    padding: 1px 5px 1px 5px;
    width: 16px;
}
.RightClickMenuItemTable tr:first-child td:last-child {
    white-space: nowrap;
}
.RightClickMenuItemLiveLinks>span, .RightClickMenuItemText>span {
    font-size: 12px;
    font-weight: normal;
    color: #4F4F4F;
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
/*切换内容*/
/*头*/
.DivSectionWithHeader {
    border: 1px solid #d3d3d3;
    margin: 0 10px 10px 10px;
    padding: 4px 0 0 0;
}
.DivSectionWithHeader .HeaderRow {
    position: relative;
    padding-bottom: 3px;
}
.DivSectionWithHeader>.HeaderRow>.Toggle {
    background: #d7d7d7;
    background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
    background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
    background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
    background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
    border: 1px solid #c6c6c6;
    cursor: pointer;
    height: 14px;
    margin: 2px 6px 0 6px;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    width: 14px;
    float: left;
}
.DivSectionWithHeader>.HeaderRow>.Toggle.Collapse>.Vertical {
    display: none;
}
.DivSectionWithHeader>.HeaderRow>.Toggle>.Vertical {
    background-color: #888;
    height: 8px;
    left: 13px;
    position: absolute;
    top: 6px;
    width: 2px;
}
.DivSectionWithHeader>.HeaderRow>.Toggle>.Horizontal {
    background-color: #888;
    height: 2px;
    left: 10px;
    position: absolute;
    top: 9px;
    width: 8px;
}
.DivSectionWithHeader>.HeaderRow>.Toggle+span {
    padding-left: 0;
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
/*内容*/
.DivSectionWithHeader .Content {
    padding: 0 28px 0 28px;
}
.FieldLabel {
    font-weight: bold;
    font-size: 12px;
    color: #4F4F4F;
    background-color: transparent;
}
.DivSection div, .DivSectionWithHeader .Content div {
    font-weight: normal;
    padding-bottom: 10px;
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
.DataSelectorLinkIcon img {
    vertical-align: middle;
    margin-top: -2px;
    margin-left: 1px;
}
.txtBlack8Class {
    font-size: 12px;
    color: #333;
    font-weight: normal;
}
select {
    height: 24px;
    padding: 0;
}
textarea {
    padding: 6px;
    resize: vertical;
}
.ip_general_label_udf {
    width: 120px;
    padding-right: 3px;
    height: 22px;
    padding-left: 2px;
}
.ip_general_ctrl {
    text-align: left;
}
.tabTwo{
    height: 22px;
}
.DivSection, .DivSectionOnly {
    border: 1px solid #d3d3d3;
    margin: 0 10px 10px 10px;
    padding: 12px 28px 4px 28px;
}
.NoneBorder {
    border: none;
}
.SubtitleDiv {
    margin: 0 10px;
    display: block;
    font-size: 15px;
    font-weight: bolder;
    color: #4F4F4F;
    padding-bottom: 10px;
}
a.HyperLink {
    cursor: pointer;
    color: #376597;
}
.DivSectionWithHeader .Content td.tableCell {
    width: 50%!important;
    padding-bottom: 12px;
}
.labelBlack, .tableCell {
    color: #333;
    font-size: 12px;
    vertical-align: top;
}
.tableCell span.labelText {
    font-size: 12px;
    vertical-align: top;
    padding-right: 5px;
    color: #4F4F4F;
    width: 105px;
    display: block;
    font-weight: bold;
}
.labelText {
    color: #4f4f4f;
    font-weight: 700;
    font-size: 12px;
    margin: 0;
    padding: 0;
}
.label {
    color: #4F4F4F;
    font-size: 12px;
}
a {
    text-decoration: none;
    color: #376597;
}
a:hover {
    text-decoration: underline;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
       <div class="TitleBar">
        <div class="Title">
                <span class="nav" style="display: inline-block;width:36px;height:26px;cursor: pointer;background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);vertical-align: middle;">
                <img src="../Images/ico_page_menu.png" style="padding:0 0 4px 7px;">
            </span>
            <span class="text1">销售订单详情</span>
            <a href="###" class="collection"></a>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="EditButton" tabindex="0">
                <span class="Icon" style="width: 0;margin: 0;"></span>
                <span class="Text"><a onclick="window.open('../SaleOrder/SaleOrderEdit.aspx?id=<%=sale_order.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.SaleOrderEdit %>','left=200,top=200,width=900,height=750', false);" class="HyperLink">编辑</a> </span>
            </li>
            <li class="Button ButtonIcon NormalState" id="ToolsButton" tabindex="0">
                <span class="Icon Add"></span>
                <span class="Text">新增</span>
                <span class="Icon Tools"></span>
            </li>
<%--            <li class="Button ButtonIcon Appendix NormalState" id="PrintButton" tabindex="0">
                <span class="Icon Print">打印</span>
            </li>--%>
        </ul>
    </div>
           <div class="LeftClickMenu" style="left: 10px;top:34px;display: none;">
        <div class="RightClickMenuItem">
            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                <tbody>
                <tr>
                    <td class="RightClickMenuItemText">
                        <span class="lblNormalClass"><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=activity"></a> 活动</span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="RightClickMenuItem">
            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                <tbody>
                <tr>
                    <td class="RightClickMenuItemText">
                        <span class="lblNormalClass"><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=todo"></a>待办</span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="RightClickMenuItem">
            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                <tbody>
                <tr>
                    <td class="RightClickMenuItemText">
                        <span class="lblNormalClass"><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=note"></a>备注</span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="RightClickMenuItem">
            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                <tbody>
                <tr>
                    <td class="RightClickMenuItemText">
                        <span class="lblNormalClass"><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=ticket"></a>工单</span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="RightClickMenuItem">
            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                <tbody>
                <tr>
                    <td class="RightClickMenuItemText">
                        <span class="lblNormalClass"><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=attachment"></a>附件</span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="RightClickMenuItem">
            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                <tbody>
                <tr>
                    <td class="RightClickMenuItemText">
                        <span class="lblNormalClass"><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=entry">报价项</a></span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <div class="RightClickMenuItem">
            <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                <tbody>
                <tr>
                    <td class="RightClickMenuItemText">
                        <span class="lblNormalClass"><a href="SaleOrderView.aspx?id=<%=sale_order.id %>&type=purchaseOrder"></a>采购订单</span>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <!--工具的下拉框-->
    <div class="RightClickMenu" style="left: 52px;top: 71px;display: none;">
        <div class="RightClickMenuItem" onclick="window.open('../Activity/Todos.aspx?saleorderId=<%=sale_order.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.TodoAdd %>','left=200,top=200,width=730,height=750', false);">
          <span class="lblNormalClass">待办</span>
        </div>
        <div class="RightClickMenuItem" onclick="window.open('../Activity/Notes.aspx?saleorderId=<%=sale_order.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.NoteAdd %>','left=200,top=200,width=730,height=750', false);">
          <span class="lblNormalClass">备注</span>
        </div>
        <div class="RightClickMenuItem">
          <span class="lblNormalClass">工单</span>
        </div>
        <div class="RightClickMenuItem" onclick="window.open('../Activity/AddAttachment?objId=<%=opportunity.id %>&objType=<%=(int)EMT.DoneNOW.DTO.DicEnum.ATTACHMENT_OBJECT_TYPE.SALES_ORDER %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.AttachmentAdd %>','left=200,top=200,width=730,height=750', false);">
          <span class="lblNormalClass">附件</span>
        </div>
    </div>
        <input type="hidden" id="isShowLeft" value="" runat="server"/>
    <!--头部-->
      <%
            var country = dic.FirstOrDefault(_ => _.Key == "country").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;//district
            var addressdistrict = dic.FirstOrDefault(_ => _.Key == "addressdistrict").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
           var sys_resource = dic.FirstOrDefault(_ => _.Key == "sys_resource").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
          var status = dic.FirstOrDefault(_ => _.Key == "sales_order_status").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;

          var oppo_statu = dic.FirstOrDefault(_ => _.Key == "oppportunity_status").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
          var oppo_stage = dic.FirstOrDefault(_ => _.Key == "opportunity_stage").Value as List<EMT.DoneNOW.DTO.DictionaryEntryDto>;
          %>
    <div class="SubtitleDiv">
        <span class="htmlLabel"><%=actType %>-<%=opportunity.name %></span>
        (<a onclick="window.open('../company/ViewCompany.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>','left=200,top=200,width=900,height=750', false);" class="HyperLink"><%=account.name %></a>)
    </div>
    <!--切换项-->
  <div <%if (type == "activity" || type == "note" || type == "todo") { %> style="margin-left:280px;margin-right:10px;" <%}else{ %> style="margin-left:10px;margin-right:10px;" <% } %>>
    <div id="leftDiv" class="TabContainer" style="margin-left: -270px;">
        <div class="DivScrollingContainer Tab" style="max-width: 300px;left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:120px;">
            <div class="DivSectionWithHeader">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle1">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">销售订单</span>
                </div>
                <div class="Content">
                    <table cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr class="tableRow">
                                <td class="tableCell">
                                    <span class="labelText">负责人</span>
                                </td>
                                <td class="tableCell">
                                    <span class="label"><%=sys_resource.First(_=>_.val==sale_order.owner_resource_id.ToString()).show %></span>
                                </td>
                            </tr>
                            <tr class="tableRow">
                                <td class="tableCell">
                                    <span class="labelText">开始日期</span>
                                </td>
                                <td class="tableCell">
                                    <span class="label"><%=sale_order.begin_date.ToString("yyyy-MM-dd") %></span>
                                </td>
                            </tr>
                            <tr class="tableRow">
                                <td class="tableCell">
                                    <span class="labelText">截止日期</span>
                                </td>
                                <td class="tableCell">
                                    <span class="label"><%=sale_order.end_date==null?"":((DateTime)sale_order.end_date).ToString("yyyy-MM-dd") %></span>
                                </td>
                            </tr>
                            <%
                                if (sale_order.ship_to_location_id != null)
                                {
                                    var shipLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)sale_order.ship_to_location_id);%>
                                
                                     <tr class="tableRow">
                                <td class="tableCell">
                                    <span class="labelText">配送地址</span>
                                </td>
                                <td class="tableCell">
                                    <span class="label">
                                  <%=country.FirstOrDefault(_=>_.val==shipLocation.country_id.ToString()).show %>
                                        <br />
                                        <%=addressdistrict.FirstOrDefault(_=>_.val==shipLocation.province_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==shipLocation.city_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==shipLocation.district_id.ToString()).show %>
                                        <br />
                                              <%=shipLocation.address %>
                                    </span>
                                </td>
                            </tr>
                                <%}%>
                       
                            <%if (sale_order.bill_to_location_id != null)
                                {
                                    var billLocation = new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)sale_order.bill_to_location_id);
                                    %>
                             <tr class="tableRow">
                                <td class="tableCell">
                                    <span class="labelText">配送地址</span>
                                </td>
                                <td class="tableCell">
                                    <span class="label">
                                  <%=country.FirstOrDefault(_=>_.val==billLocation.country_id.ToString()).show %>
                                        <br />
                                        <%=addressdistrict.FirstOrDefault(_=>_.val==billLocation.province_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==billLocation.city_id.ToString()).show %>
                                        &nbsp;&nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==billLocation.district_id.ToString()).show %>
                                        <br />
                                              <%=billLocation.address %>
                                    </span>
                                </td>
                            </tr>
                            <%} %>
                     
                            <tr class="tableRow">
                                <td class="tableCell">
                                    <span class="labelText">状态</span>
                                </td>
                                <td class="tableCell">
                                    <span class="label"><%=status.FirstOrDefault(_=>_.val==sale_order.status_id.ToString()).show %></span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle2">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">商机</span>
                </div>
                <div class="Content">
                    <table cellpadding="0" cellspacing="0">
                        <tbody>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">名称</span>
                            </td>
                            <td class="tableCell">
                                <a  onclick="window.open('../Opportunity/ViewOpportunity.aspx?id=<%=opportunity.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityView %>','left=200,top=200,width=900,height=750', false);" class="linkButton"><%=opportunity.name %></a>
                            </td>
                        </tr>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">负责人</span>
                            </td>
                            <td class="tableCell">
                                <span class="label"><%=sys_resource.First(_=>_.val==opportunity.resource_id.ToString()).show %></span>
                                <br>
                                <a class="linkButton">重新指派</a>
                            </td>
                        </tr>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">商机ID</span>
                            </td>
                            <td class="tableCell">
                                <span class="label"><%=opportunity.id %></span>
                            </td>
                        </tr>
                         <%if (quote != null)
                             { %>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">报价</span>
                            </td>
                            <td class="tableCell">
                                <a class="linkButton" onclick="window.open('../QuoteItem/QuoteItemManage.aspx?quote_id=<%=quote.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteItemManage %>','left=200,top=200,width=900,height=750', false);"><%=quote.name %></a>
                            </td>
                        </tr>
                            <%} %>
                            <%
// todo 对项目提案的判断
                                %>

                            <%
                                var totalRebenue = new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoRevenue(opportunity.id);
                                var totalCost = new EMT.DoneNOW.BLL.OpportunityBLL().ReturnOppoCost(opportunity.id);
                                var Gross_Profit = totalRebenue - totalCost;
                                %>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">毛利</span>
                            </td>
                            <td class="tableCell">r
                                <span>
                                    <%=Gross_Profit.ToString("#0.00") %>
                                    <br />
                                    <%=totalRebenue==0?"0":(Gross_Profit/totalRebenue).ToString("#0.00") %> %
                                    <br />
                                    <%=opportunity.number_months == null?"":opportunity.number_months.ToString()+"  个月" %>
                                </span>
                            </td>
                        </tr>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">创建日期</span>
                            </td>
                            <td class="tableCell">
                                <span><%=opportunity.projected_begin_date==null?"":((DateTime)opportunity.projected_begin_date).ToString("yyyy-MM-dd") %>
                                    <br />
                                   <%=opportunity.projected_begin_date==null?"":" 距今"+Math.Ceiling(((DateTime)opportunity.projected_begin_date - DateTime.Now).TotalDays).ToString()+"天" %>
                                </span>
                            </td>
                            <%if (opportunity.status_id != null)
                                    { %>
                        </tr>
                                      <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">状态</span>
                            </td>
                            <td class="tableCell">
                                <span><%=oppo_statu.First(_ => _.val == opportunity.status_id.ToString()).show %></span>
                            </td>
                        </tr>
                            <%} %>
                            <%if (opportunity.stage_id != null)
                                { %>
                                      <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">等级</span>
                            </td>
                            <td class="tableCell">
                                <span><%=oppo_stage.First(_ => _.val == opportunity.stage_id.ToString()).show %></span>
                            </td>
                        </tr>
                            <%} %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="DivSectionWithHeader">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle3">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass">
                        <a onclick="window.open('../company/ViewCompany.aspx?account_id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyView %>','left=200,top=200,width=900,height=750', false);" ><%=account.name %></a>
                        <img src="../Images/at16.png" style="vertical-align: middle;">
                    </span>
                </div>
                <div class="Content">
                    <table cellpadding="0" cellspacing="0">
                        <tbody>
                            <%  var location = new EMT.DoneNOW.BLL.LocationBLL().GetLocationByAccountId(account.id);
                                if (location != null)
                                {
                                %>
                        <tr class="tableRow">
                            <td class="tableCell">
                                
                                <span class="labelText">地址信息</span>
                            </td>
                            <td class="tableCell">
                               <span class="label">
                                  <%=country.FirstOrDefault(_=>_.val==location.country_id.ToString()).show %>
                                     &nbsp;&nbsp;
                                        <%=addressdistrict.FirstOrDefault(_=>_.val==location.province_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==location.city_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_=>_.val==location.district_id.ToString()).show %>
                                        <br />
                                       <%=location.address %>&nbsp;&nbsp;<%=location.additional_address %>&nbsp;&nbsp;<%=location.postal_code %>
                                    </span>
                            </td>
                        </tr>
                            <%} %>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">电话</span>
                            </td>
                            <td class="tableCell">
                                <span class="label"><%=account.phone %></span>
                            </td>
                        </tr>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">传真</span>
                            </td>
                            <td class="tableCell">
                                <span class="label"><%=account.fax %></span>
                            </td>
                        </tr>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">网站</span>
                            </td>
                            <td class="tableCell">
                                <a class="linkButton" href="http://<%=account.web_site %>" target="webSite"><%=account.web_site %></a>
                               
                            </td>
                        </tr>
                            <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">  <a class="linkButton" onclick="window.open('../Company/CompanySiteManage.aspx?id=<%=account.id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySiteConfiguration %>','left=200,top=200,width=960,height=750', false);">站点配置</a></span>
                            </td>
                            <td class="tableCell">
                              
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%if (contact != null)
                { %>
            <div class="DivSectionWithHeader">
                <!--头部-->
                <div class="HeaderRow">
                    <div class="Toggle Collapse Toggle4">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="lblNormalClass"><%=contact.name %></span>
                </div>
                <div class="Content">
                    <table cellpadding="0" cellspacing="0">
                        <tbody>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">头衔</span>
                            </td>
                            <td class="tableCell">
                                <span class="label"><%=contact.title %></span>
                            </td>
                        </tr>

                            <%
                                if (contact.location_id != null)
                                {
                                    var contactLocation =  new EMT.DoneNOW.BLL.LocationBLL().GetLocation((long)contact.location_id);%>

                               <tr class="tableRow">
                            <td class="tableCell">
                                
                                <span class="labelText">地址信息</span>
                            </td>
                                   <%if (contactLocation != null)
                                           { %>
                            <td class="tableCell">
                               <span class="label">
                                  <%=country.FirstOrDefault(_ => _.val == contactLocation.country_id.ToString()).show %>
                                     &nbsp;&nbsp;
                                        <%=addressdistrict.FirstOrDefault(_ => _.val == contactLocation.province_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_ => _.val == contactLocation.city_id.ToString()).show %>
                                        &nbsp;&nbsp;<%=addressdistrict.FirstOrDefault(_ => _.val == contactLocation.district_id.ToString()).show %>
                                        <br />
                                       <%=location.address %>&nbsp;&nbsp;<%=location.additional_address %>&nbsp;&nbsp;<%=location.postal_code %>
                                    </span>
                            </td>
                                   <%} %>
                        </tr>
                               <% }
                                %>
                        <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">电话</span>
                            </td>
                            <td class="tableCell">
                                <span><%=contact.phone %></span>
                            </td>
                        </tr>
                                <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">备用电话</span>
                            </td>
                            <td class="tableCell">
                                <span><%=contact.alternate_phone %></span>
                            </td>
                        </tr>
                                <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">移动电话</span>
                            </td>
                            <td class="tableCell">
                                <span><%=contact.mobile_phone %></span>
                            </td>
                        </tr>
                                       <tr class="tableRow">
                            <td class="tableCell">
                                <span class="labelText">邮箱</span>
                            </td>
                            <td class="tableCell">
                                 <a class="linkButton" onclick="Email（'<%=contact.email %>')"><%=contact.email %></a>
                              
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <%} %>
                  <a class="linkButton" style="margin-left:10px;cursor:pointer;">可以查看这个销售订单的员工</a>
        </div>
  
    </div>


       <div id="ShowCompany_Right" class="activityTitleright f1">
         <%if (type.Equals("activity")) { %>
         <div class="FeedHeader">
        <div class="NewRootNote">
          <textarea placeholder="添加一个备注..." id="insert"></textarea>
        </div>
        <div class="add clear">
          <span id="WordNumber">2000</span>
          <input type="button" id="addNote" value="添加" style="height:24px;" />
          <asp:DropDownList ID="noteType" runat="server" Width="100px" Height="24px">
          </asp:DropDownList>
        </div>
        <div class="checkboxs clear">
          <div class="clear">
            <asp:CheckBox ID="Todos" runat="server" />
            <label>待办</label>
          </div>
          <div class="clear">
            <asp:CheckBox ID="Note" runat="server" />
            <label>备注</label>
          </div>
          <div class="clear">
            <asp:CheckBox ID="Tickets" runat="server" />
            <label>工单</label>
          </div>
        </div>
        <div class="addselect">
          <div class="clear">
            <label>排序方式：</label>
            <asp:DropDownList ID="OrderBy" runat="server">
              <asp:ListItem Value="2">时间从晚到早</asp:ListItem>
              <asp:ListItem Value="1">时间从早到晚</asp:ListItem>
            </asp:DropDownList>
          </div>
        </div>
      </div>
        <hr class="activityTitlerighthr" />
         <div id='activityContent' style='margin-bottom:10px;'>

         </div>
         <%} else { %>
            <iframe id="viewSaleOrder_iframe" src="<%=iframeSrc %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
         <%}%>
       </div>

      </div>
    </form>
</body>
</html>
    <script type="text/javascript" src="../Scripts/jquery-3.1.0.min.js"></script>
    
    <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/common.js"></script>
<script>


    $("#SaveButton").on("mouseover", function () {
        $("#SaveButton").css("background", "#fff");
    });
    $("#SaveButton").on("mouseout", function () {
        $("#SaveButton").css("background", "#f0f0f0");
    });
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
    $("#EditButton").on("mouseover", function () {
        $("#EditButton").css("background", "#fff");
    });
    $("#EditButton").on("mouseout", function () {
        $("#EditButton").css("background", "#f0f0f0");
    });
    $("#PrintButton").on("mouseover", function () {
        $("#PrintButton").css("background", "#fff");
    });
    $("#PrintButton").on("mouseout", function () {
        $("#PrintButton").css("background", "#f0f0f0");
    });
    //工具
    $("#ToolsButton").on("mouseover", function () {
        $("#ToolsButton").css("background", "#fff");
        $(this).css("border-bottom", "none");
        $(".RightClickMenu").show();
    });
    $("#ToolsButton").on("mouseout", function () {
        $("#ToolsButton").css("background", "#f0f0f0");
        $(this).css("border-bottom", "1px solid #BCBCBC");
        $(".RightClickMenu").hide();
    });
    $(".RightClickMenu").on("mouseover", function () {
        $("#ToolsButton").css("background", "#fff");
        $("#ToolsButton").css("border-bottom", "none");
        $(this).show();
    });
    $(".RightClickMenu").on("mouseout", function () {
        $("#ToolsButton").css("background", "#f0f0f0");
        $("#ToolsButton").css("border-bottom", "1px solid #BCBCBC");
        $(this).hide();
    });
    $(".RightClickMenuItem").on("mouseover", function () {
        $(this).css("background", "#E9F0F8");
    });
    $(".RightClickMenuItem").on("mouseout", function () {
        $(this).css("background", "#FFF");
    });
    //工具结束
    $("#SiteConfiguration").on("mouseover", function () {
        $("#SiteConfiguration").css("background", "#fff");
    });
    $("#SiteConfiguration").on("mouseout", function () {
        $("#SiteConfiguration").css("background", "#f0f0f0");
    });
    $("#OtherConfigurationItems").on("mouseover", function () {
        $("#OtherConfigurationItems").css("background", "#fff");
    });
    $("#OtherConfigurationItems").on("mouseout", function () {
        $("#OtherConfigurationItems").css("background", "#f0f0f0");
    });
    //销售订单导航
    $(".nav").on("mouseover", function () {
        $(this).css("background", "#fff");
        $(this).css("border-bottom", "none");
        $(".LeftClickMenu").show();
    });
    $(".nav").on("mouseout", function () {
        $(this).css("background", "#f0f0f0");
        $(".LeftClickMenu").hide();
    });
    $(".LeftClickMenu").on("mouseover", function () {
        $(".nav").css("background", "#fff");
        $(".nav").css("border-bottom", "none");
        $(this).show();
    });
    $(".LeftClickMenu").on("mouseout", function () {
        $(".nav").css("background", "#f0f0f0");
        $(this).hide();
    });
    $.each($(".TabBar a"), function (i) {
        $(this).click(function () {
            $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
            $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
        })
    });
    var colors = ["#efefef", "white"];
    var index1 = 0;
    var index2 = 0;
    var index3 = 0;
    var index4 = 0;
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
    $(".Toggle3").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index3 % 2]);
        index3++;
    });
    $(".Toggle4").on("click", function () {
        $(this).parent().parent().find($(".Vertical")).toggle();
        $(this).parent().parent().find($('.Content')).toggle();
        $(this).parent().parent().css("background", colors[index4 % 2]);
        index4++;
    });
</script>

<script>
    $(function () {
        var isShowLeft = $("#isShowLeft").val();   
        if (isShowLeft == "1") {
            $("#leftDiv").css("display","");
        }
        else {
            $("#leftDiv").css("display", "none");
        }

        // 商机和联系人的div默认关闭
        $(".Toggle3").parent().parent().find($(".Vertical")).toggle();
        $(".Toggle3").parent().parent().find($('.Content')).toggle();
        $(".Toggle3").parent().parent().css("background", colors[index3 % 2]);
        index3++;
        $(".Toggle4").parent().parent().find($(".Vertical")).toggle();
        $(".Toggle4").parent().parent().find($('.Content')).toggle();
        $(".Toggle4").parent().parent().css("background", colors[index4 % 2]);
        index4++;
    })
    //var Height = $(window).height() - 80 + "px";
    //var Width = $(window).width() + "px";
    //$("#viewSaleOrder_iframe").css("height", Height).css("width", Width);
    //$(window).resize(function () {
    //    var Height = $(window).height() - 80 + "px";
    //    var Width = $(window).width() + "px";
    //    $("#viewSaleOrder_iframe").css("height", Height).css("width", Width);
    //});

    var Height = $(window).height() - 130 + "px";
    $("#ShowCompany_Right").css("height", Height);

    $(window).resize(function () {
      var Height = $(window).height() - 130 + "px";
      $("#ShowCompany_Right").css("height", Height);
    })
</script>