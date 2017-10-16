<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchBodyFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchBodyFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css" />
     <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title></title>
    <style>
        .searchcontent {
            width: 100%;
            height: 100%;
            min-width: 2200px;
        }

            .searchcontent table th {
                background-color: #cbd9e4;
                border-color: #98b4ca;
                color: #64727a;
                height: 28px;
                line-height: 28px;
                text-align: center;
            }

        .RightClickMenu, .LeftClickMenu {
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

        .RightClickMenuItemLiveLinks > span, .RightClickMenuItemText > span {
            font-size: 12px;
            font-weight: normal;
            color: #4F4F4F;
        }
          /*加载的css样式*/
#BackgroundOverLay{
    width:100%;
    height:100%;
    background: black;
    opacity: 0.6;
    z-index: 25;
    position: absolute;
    top: 0;
    left: 0;
    display: none;
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
}/*加载的css样式(结尾)*/
    </style>
</head>
<body style="overflow-x: auto; overflow-y: auto;">
    <form id="form1">
        <div id="search_list">
            <input type="hidden" id="page_num" name="page_num" <%if (queryResult != null)
                {%>value="<%=queryResult.page %>"
                <%} %> />
            <input type="hidden" id="page_size" name="page_size" <%if (queryResult != null)
                {%>value="<%=queryResult.page_size %>"
                <%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null)
                {%>value="<%=queryResult.query_id %>"
                <%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null)
                {%>value="<%=queryResult.order_by %>"
                <%} %> />
            <input type="hidden" id="cat" name="cat" value="<%=catId %>" />
            <input type="hidden" id="type" name="type" value="<%=queryTypeId %>" />
            <input type="hidden" id="group" name="group" value="<%=paraGroupId %>" />
            <input type="hidden" id="id" name="id" value="<%=objId %>" />
            <input type="hidden" id="isCheck" name="isCheck" value="<%=isCheck %>" />
            <div id="conditions">
                <%foreach (var para in queryParaValue)
                    { %>
                <input type="hidden" name="<%=para.val %>" value="<%=para.show %>" />
                <%} %>
            </div>
        </div>
        <div class="contentboby">
            <div class="RightClickMenu" style="left: 10px; top: 36px; display: none;">
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1199)">
                                    <span class="lblNormalClass">定期服务合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1200)">
                                    <span class="lblNormalClass">工时及物料合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1201)">
                                    <span class="lblNormalClass">固定价格合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1202)">
                                    <span class="lblNormalClass">预付时间合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1203)">
                                    <span class="lblNormalClass">预付费合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1204)">
                                    <span class="lblNormalClass">事件合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="contenttitle clear" style="position: fixed; border-bottom: 1px solid #e8e8fa; left: 0; top: 0; background: #fff; width: 100%;">
                <ul class="clear fl">
                    <%if (!string.IsNullOrEmpty(addBtn))
                        {
                            if (addBtn.Equals("新增合同"))
                            {
                    %>
                    <li id="ToolsButton"><i style="background-image: url(../Images/new.png);"></i><span style="margin: 0;"><%=this.addBtn %></span><img src="../Images/dropdown.png" /></li>
                    <%
                        } else if(addBtn=="审批并提交"){
  %>
                    <li onclick="Add()"><span style="margin: 0 10px;">审批并提交</span></li>
                     <li><a href="../Invoice/InvocieSearch" target="PageFrame" style="color:#333;text-decoration:none;"><span style="margin: 0 10px;">生成发票</span></a></li>
                               <%
                        } else if(addBtn=="历史发票"){
  %>
                    <li onclick="Add()"><span style="margin: 0 10px;">邮件发票</span></li>
                     <li><a href="../Invoice/InvocieSearch" target="PageFrame" style="color:#333;text-decoration:none;"><span style="margin: 0 10px;">发票查询</span></a></li>
                    <%
                             } else if(addBtn=="完成"){
  %>
                    <li onclick="Add()"><span style="margin: 0 10px;">完成</span></li>
                    <%
                        }
                        else
                        {
                    %>
                    <li onclick="Add()"><i style="background-image: url(../Images/new.png);"></i><span><%=this.addBtn %></span></li>
                    <%}
                        } else if(queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractService) {%>
                  <li onclick="AddService()"><i style="background-image: url(../Images/new.png);"></i><span>新增服务</span></li>
                  <li onclick="AddServiceBundle()"><i style="background-image: url(../Images/new.png);"></i><span>新增服务包</span></li>
                  <li onclick="ApplyDiscount()"><span>应用全部折扣</span></li>
                  <%}%>
                    <li><i style="background-image: url(../Images/print.png);"></i></li>
                    <li onclick="javascript:window.open('ColumnSelector.aspx?type=<%=queryTypeId %>&group=<%=paraGroupId %>', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);"><i style="background-image: url(../Images/column-chooser.png);"></i></li>
                    <li><i style="background-image: url(../Images/export.png);"></i></li>
                </ul>
                <%if (queryResult != null && queryResult.count > 0)
                    { %>
                <div class="page fl">

                  <%if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractService) { %>
                <span>显示数据</span><input type="text" name="time" style="margin-left:16px;margin-right:30px;" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" onclick="WdatePicker()" class="Wdate" />
              <%} %>

                    <%
                        int indexFrom = queryResult.page_size * (queryResult.page - 1) + 1;
                        int indexTo = queryResult.page_size * queryResult.page;
                        if (indexFrom > queryResult.count)
                            indexFrom = queryResult.count;
                        if (indexTo > queryResult.count)
                            indexTo = queryResult.count;
                    %>
                    <span>第<%=indexFrom %>-<%=indexTo %>&nbsp;&nbsp;总数&nbsp;<%=queryResult.count %></span>
                    <span>每页<%if (queryResult.page_size == 20)
                                {
                    %>&nbsp;20&nbsp;<%}
                                        else
                                        {
                    %><a href="#" onclick="ChangePageSize(20)">20</a><%}
                    %>|<%if (queryResult.page_size == 50)
                           {
                    %>&nbsp;50&nbsp;<%}
                                        else
                                        {
                    %><a href="#" onclick="ChangePageSize(50)">50</a><%}
                    %>|<%if (queryResult.page_size == 100)
                           { %>&nbsp;100&nbsp;<%}
                                                  else
                                                  { %><a href="#" onclick="ChangePageSize(100)">100</a><%} %></span>
                    <i onclick="ChangePage(1)"><<</i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page-1 %>)"><</i>
                    <input type="text" style="width: 30px; text-align: center;height:30px;" value="<%=queryResult.page %>" />
                    <span>&nbsp;/&nbsp;<%=queryResult.page_count %></span>
                    <i onclick="ChangePage(<%=queryResult.page+1 %>)">></i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page_count %>)">>></i>
                </div>
                <%} %>
            </div>

        </div>
    </form>
    <%if (queryResult != null) { %>

    <div class="searchcontent" id="searchcontent" style="margin-top: 56px; min-width: <%=tableWidth%>px; overflow: hidden;">
        <table border="" cellspacing="0" cellpadding="0" style="overflow: scroll; width: 100%; height: 100%;">
            <tr>
                <%if (!string.IsNullOrEmpty(isCheck))
                    { %>
                <th style="padding-left: 4px;width:22px;max-width:22px;">
                    <input id="CheckAll" type="checkbox" /></th>

                <%} %>
                <%foreach (var para in resultPara)
                    {
                        if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                            continue;
                        string orderby = null;
                        string order = null;
                        if (!string.IsNullOrEmpty(queryResult.order_by))
                        {
                            var strs = queryResult.order_by.Split(' ');
                            orderby = strs[0];
                            order = strs[1].ToLower();
                        }
                %>
                <th title="点击按此列排序" width="<%=para.length*32 %>px" onclick="ChangeOrder('<%=para.name %>')">
                    <%=para.name %>
                    <%if (orderby != null && para.name.Equals(orderby))
                        { %><img src="../Images/sort-<%=order %>.png" />
                    <%} %></th>
                <%} %>
            </tr>
            <%               
                if (queryResult.count>0)
                {
                    var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                    foreach (var rslt in queryResult.result)
                    {
                        string id = "0";
                        if (idPara != null)
                            id = rslt[idPara.name].ToString();
            %>
           <%-- 如果是撤销审批，则不需要右键菜单--%>
            <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_CHARGES || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_MILESTONES || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_MILESTONES || catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_SUBSCRIPTIONS)
                {%>
            <tr onclick="View(<%=id %>)" data-val="<%=id %>" class="dn_tr">
            <%}
    else
    { %>
            <tr onclick="View(<%=id %>)" title="右键显示操作菜单" data-val="<%=id %>" class="dn_tr">
                <%} %>
                <%if (!string.IsNullOrEmpty(isCheck))
                    { %>
                <td style="width:22px;max-width:22px;">
                    <input type="checkbox" class="IsChecked" value="<%=id %>" /></td>

                <%} %>
                <%foreach (var para in resultPara)
                    {
                        if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                            continue;
                        string tooltip = null;
                        if (resultPara.Exists(_ => _.name.Equals(para.name + "tooltip")))
                            tooltip = para.name + "tooltip";
                %>
                <%if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.PIC)
                    { %>
                <td <%if (tooltip != null)
                    { %>title="<%=rslt[tooltip] %>"
                    <%} %> style="background: url(..<%=rslt[para.name] %>) no-repeat center;"></td>
                <%}
                    else
                    { %>
                <td><%=rslt[para.name] %></td>
                <%} %>
                <%} // foreach
                %>
            </tr>
            <%} // foreach
                } // else
            %>
        </table>
    </div>
     <%
         if (queryResult.count == 0)
         {
            %>
                <div style="color: red;text-align:center;padding:10px 0;font-size:14px;font-weight:bold;">选定的条件未查找到结果</div>
            <%}%>
    <%} %>

    <div id="menu">
        <%if (contextMenu.Count > 0)
            { %>
        <ul style="width: 220px;">
            <%foreach (var menu in contextMenu)
                { %>
            <li id="<%=menu.id %>" onclick="<%=menu.click_function %>"><i class="menu-i1"></i><%=menu.text %>
                <%if (menu.submenu != null)
                    { %>
                <i class="menu-i2">>></i>
                <ul id="menu-i2-right">
                    <%foreach (var submenu in menu.submenu)
                        { %>
                    <li onclick="<%=submenu.click_function %>"><%=submenu.text %></li>
                    <%} %>
                </ul>
                <%} %>
            </li>
            <%} %>
        </ul>
        <%} %>
    </div>
    
 <!--弹框-->
    <div class="Dialog" id="accounttanchuan">
        <div>
            <div class="CancelDialogButton cancel_account"></div>
            <div class="TitleBar"></div>
            <div class="NoHeading Section">
                <div class="Content">
                    <div class="StandardText">分类图标：有<span id="accountcount"></span>个客户关联此客户类别。</div>
                    <div class="StandardText HighImportance">如果删除，则相关客户上的客户类别信息将会被清空。</div>
                    <div class="StandardText">您确定要删除此分类吗？</div>
                </div>
            </div>
            <div class="GridBar ButtonContainer">
                <a class="Button ButtonIcon NormalState" id="delete_account">
                    <span class="Text">是的，删除</span>
                </a>
                <a class="Button ButtonIcon NormalState" id="noactive_account">
                    <span class="Text">不，停用</span>
                </a>
                <a class="Button ButtonIcon NormalState cancel_account">
                    <span class="Text">取消</span>
                </a>
            </div>
        </div>
    </div>
        <%--加载--%>
<div id="BackgroundOverLay"></div>
<div id="LoadingIndicator"></div>
     <%--加载结束--%>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        <% if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Company)
        { %>
        function EditCompany() {
            OpenWindow("../Company/EditCompany.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyEdit %>');
        }

        function ViewCompany() {
            OpenWindow("../Company/ViewCompany.aspx?id=" + entityid, '_blank');
        }
        function Add() {
            OpenWindow("../Company/AddCompany.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>');
        }
        function DeleteCompany() {
            OpenWindow("../Company/DeleteCompany.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyDelete %>');
        }
        function View(id) {
            OpenWindow("../Company/ViewCompany.aspx?id=" + id, '_blank');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Contact
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContactCompanyView)
        {
            %>
        function EditContact() {
            OpenWindow("../Contact/AddContact.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactEdit %>');
        }
        function ViewContact() {
            OpenWindow("../Contact/ViewContact.aspx?id=" + entityid, '_blank');
        }
        function View(id) {
            OpenWindow("../Contact/ViewContact.aspx?id=" + id, '_blank');
        }
        function DeleteContact() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContactAjax.ashx?act=delete&id=" + entityid,
                success: function (data) {
                    alert(data);
                }

            })
        }
        <%if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Contact)
        { %>
        function Add() {
            OpenWindow("../Contact/AddContact.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContactCompanyView)
        { %>
        function Add() {
            OpenWindow('../Contact/AddContact.aspx?account_id=<%=objId%>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>');
        }
        <%}%>
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Opportunity
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityCompanyView
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityContactView)
        {
            %>
        function EditOpp() {
            <%--window.open("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityEdit %>', 'left=0,top=0,location=no,status=no,width=750,height=750', false);--%>
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx?opportunity_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityEdit %>');
        }
        function ViewOpp() {
            OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + entityid, '_blank');
        }
        function View(id) {
            OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + id, '_blank');
        }
        function ViewCompany() {
            OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, '_blank');
        }
        function AddQuote() {
            window.open("../Quote/QuoteAddAndUpdate.aspx",'<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd %>', 'left=0,top=0,width=750,height=750', false);
        }
        function DeleteOpp() {
            $.ajax({
                type: "GET",
                url: "../Tools/OpportunityAjax.ashx?act=delete&id=" + entityid,
                success: function (data) {
                    alert(data);
                }
            })
        }
        <%if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Opportunity)
        { %>
        function Add() {
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityCompanyView)
        { %>
        function Add() {
            OpenWindow('../Opportunity/OpportunityAddAndEdit.aspx?oppo_account_id=<%=objId%>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityContactView)
        { %>
        function Add() {
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx?oppo_contact_id=<%=objId%>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%}%>
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Quote)
        {
            %>
        function Edit() {
            OpenWindow("../Quote/QuoteAddAndUpdate.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteEdit %>');
        }
        function ViewOpp() {
            OpenWindow("../Opportunity/ViewOpportunity.aspx?type=todo&id=" + entityid, '_blank');
        }
        function ViewCompany(id) {
            OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, '_blank');
        }
        function LossQuote() {
            OpenWindow("../Quote/QuoteLost.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteLost %>');
        }
        function QuoteManage() {
            OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteItemManage %>');
        }
        function DeleteQuote() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteAjax.ashx?act=delete&id=" + entityid,
                success: function (data) {
                    alert(data);
                }
            })
        }
        function View(id) {
            OpenWindow("../QuoteItem/QuoteItemManage.aspx?quote_id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteItemManage %>');
        }
        function Add() {
            OpenWindow("../Quote/QuoteAddAndUpdate.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd %>');
        }
        function ViewQuote() {
            OpenWindow("../Quote/QuoteView.aspx?id=" + entityid, '_blank');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.QuoteTemplate)
        {
            %>
        function Add() {
            OpenWindow("../QuoteTemplate/QuoteTemplateAdd.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateAdd %>');
        }
        function Edit() {
            OpenWindow("../QuoteTemplate/QuoteTemplateEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateEdit %>');
        }
        function View(id) {
            OpenWindow("../QuoteTemplate/QuoteTemplateEdit.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateEdit %>');
         }
        function Copy() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=copy&id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "error") {
                        alert("报价模板，复制失败！");
                    } else {
                        alert("报价模板复制成功，点击确定进入编辑界面！");
                        OpenWindow("../QuoteTemplate/QuoteTemplateEdit.aspx?id=" + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateEdit %>');
                    }                    
                }
            })
        }
        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=delete&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Default() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=default&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function NoActive() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=noactive&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        <%
        }
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.InstalledProductView)
        {
            %>
        function Edit() {
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        // 激活单个配置项
        function ActiveIProduct() {
            $.ajax({
                type: "GET",
                url: "../Tools/ProductAjax.ashx?act=ActivationIP&iProduct_id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "ok") {
                        alert('激活成功');
                        history.go(0);
                    } else if (data == "no") {
                        alert('该报价项已经激活');
                    }
                    else {

                    }

                }
            })
        }
        // 批量激活配置项
        function ActiveIProducts() {

            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=ActivationIPs&iProduct_ids=" + ids,
                    success: function (data) {
                        if (data == "ok") {
                            alert('批量激活成功！');
                        }
                        else if (data == "error") {
                            alert("批量激活失败！");
                        }
                        history.go(0);
                    }
                })
            }

        }
        // 停用配置项
        function NoActiveIProduct() {
            $.ajax({
                type: "GET",
                url: "../Tools/ProductAjax.ashx?act=NoActivationIP&iProduct_id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "ok") {
                        alert('停用成功');
                        history.go(0);
                    } else if (data == "no") {
                        alert('该配置项已经停用');
                    }
                    else {

                    }

                }
            })
        }
        // 批量停用配置项
        function NoActiveIProducts() {

            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=NoActivationIPs&iProduct_ids=" + ids,
                    success: function (data) {
                        if (data == "ok") {
                            alert('批量停用成功！');
                        }
                        else if (data == "error") {
                            alert("批量停用失败！");
                        }
                        history.go(0);
                    }
                })
            }

        }
        // 删除配置项
        function DeleteIProduct() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=deleteIP&iProduct_id=" + entityid,
                    success: function (data) {

                        if (data == "True") {
                            alert('删除成功');
                        } else if (data == "False") {
                            alert('删除失败');
                        }
                        history.go(0);
                    }
                })
            }

        }
        // 批量删除配置项
        function DeleteIProducts() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=deleteIPs&iProduct_ids=" + ids,
                    success: function (data) {

                        if (data == "True") {
                            alert('批量删除成功');
                        } else if (data == "False") {
                            alert('批量删除失败');
                        }
                        history.go(0);
                    }
                })
            }

        }
        // 全选/全不选
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })

        function View(jdgshdfghsdfgsl) {

        }
        var entityid;
        var menu = document.getElementById("menu");
        var menu_i2_right = document.getElementById("menu-i2-right");
        var Times = 0;

        $(".dn_tr").bind("contextmenu", function (event) {
            clearInterval(Times);
            var oEvent = event;
            entityid = $(this).data("val");
            (function () {
                menu.style.display = "block";
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            }());
            menu.onmouseenter = function () {
                clearInterval(Times);
                menu.style.display = "block";
            };
            menu.onmouseleave = function () {
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            };
            var Top = $(document).scrollTop() + oEvent.clientY;
            var Left = $(document).scrollLeft() + oEvent.clientX;
            var winWidth = window.innerWidth;
            var winHeight = window.innerHeight;
            var menuWidth = menu.clientWidth;
            var menuHeight = menu.clientHeight;
            var scrLeft = $(document).scrollLeft();
            var scrTop = $(document).scrollTop();
            var clientWidth = Left + menuWidth;
            var clientHeight = Top + menuHeight;
            if (winWidth < clientWidth) {
                menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
            } else {
                menu.style.left = Left + "px";
            }
            if (winHeight < clientHeight) {
                menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
            } else {
                menu.style.top = Top + "px";
            }

            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })

            if (ids == "") {
                $("#ActiveChoose").css("color", "grey");
                $("#NoActiveChoose").css("color", "grey");
                $("#ActiveChoose").removeAttr('onclick');
                $("#NoActiveChoose").removeAttr('onclick');

            } else {
                $("#ActiveChoose").css("color", "");
                $("#NoActiveChoose").css("color", "");
                $("#ActiveChoose").click(function () {
                    ActiveIProducts();
                })
                $("#NoActiveChoose").click(function () {
                    NoActiveIProducts();
                })
            }

            $.ajax({
                type: "GET",
                url: "../Tools/ProductAjax.ashx?act=property&property=is_active&iProduct_id=" + entityid,
                async: false,
                success: function (data) {
                    debugger;
                    if (data == "1") {
                        $("#ActiveThis").css("color", "grey");
                        $("#NoActiveThis").css("color", "");
                        $("#ActiveThis").removeAttr('onclick');

                        $("#NoActiveThis").click(function () {
                            NoActiveIProduct();
                        })


                    } else if (data == "0") {
                        $("#ActiveThis").css("color", "");
                        $("#NoActiveThis").css("color", "grey");

                        $("#NoActiveThis").removeAttr('onclick');

                        $("#ActiveThis").click(function () {
                            ActiveIProduct();
                        })
                    }

                }
            })



            return false;
        });
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Subscription)
        {%>
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Edit() {
            window.open("../ConfigurationItem/SubscriptionAddOrEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SubscriptionEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function CancelSubscription() {

            if (confirm("你选择取消此订阅,将导致该订阅的所有未计费项被立即取消,通常在该客户永久注销的前提下操作, 该操作无法恢复确定无论如何都要取消此订阅?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=2&sid=" + entityid,
                    async: false,
                    success: function (data) {
                        if (data == "ok") {
                            alert('取消成功');
                            history.go(0);
                        } else if (data == "Already") {
                            alert('已经取消');
                        }
                        else {
                            alert("取消失败");
                        }

                    }
                })
            }


        }

        function CancelSubscriptions() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/SubscriptionAjax.ashx?act=activeSubscripts&status_id=2&sids=" + ids,
                    async: false,
                    success: function (data) {
                        if (data == "True") {
                            alert("批量取消成功");
                        }
                        else {
                            alert("批量取消失败");
                        }
                        history.go(0);

                    }
                })
            }

        }

        function ActiveSubscription() {
            $.ajax({
                type: "GET",
                url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=1&sid=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "ok") {
                        alert('激活成功');
                        history.go(0);
                    } else if (data == "Already") {
                        alert('已经激活');
                    }
                    else {
                        alert("激活失败");
                    }

                }
            })
        }
        function NoActiveSubscription() {

            if (confirm("你选择注销(搁置)此订阅,,该订阅的计费项将继续计费,该订阅的关联支持服务将被停止,该操作通常发生在客户发生欠费或者该客户的服务被暂停,你确定无法如何都要注销此订阅?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=0&sid=" + entityid,
                    async: false,
                    success: function (data) {
                        if (data == "ok") {
                            alert('停用成功');
                            history.go(0);
                        } else if (data == "Already") {
                            alert('已经停用');
                        }
                        else {
                            alert("停用失败");
                        }

                    }
                })
            }

        }

        function DeleteSubscription() {
            $.ajax({
                type: "GET",
                url: "../Tools/SubscriptionAjax.ashx?act=deleteSubscriprion&sid=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        alert('删除成功');

                    }
                    else {
                        alert("删除失败");
                    }
                    history.go(0);
                }
            })
        }
        function DeleteSubscriptions() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/SubscriptionAjax.ashx?act=deleteSubscriprions&sids=" + ids,
                    async: false,
                    success: function (data) {
                        if (data == "True") {
                            alert("批量删除成功");
                        }
                        else {
                            alert("批量删除失败");
                        }

                    }
                })
            }

        }
        function View(jdgshdfghsdfgsl) {

        }
        var entityid;
        var menu = document.getElementById("menu");
        var menu_i2_right = document.getElementById("menu-i2-right");
        var Times = 0;

        $(".dn_tr").bind("contextmenu", function (event) {
            clearInterval(Times);
            var oEvent = event;
            entityid = $(this).data("val");
            (function () {
                menu.style.display = "block";
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            }());
            menu.onmouseenter = function () {
                clearInterval(Times);
                menu.style.display = "block";
            };
            menu.onmouseleave = function () {
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            };
            var Top = $(document).scrollTop() + oEvent.clientY;
            var Left = $(document).scrollLeft() + oEvent.clientX;
            var winWidth = window.innerWidth;
            var winHeight = window.innerHeight;
            var menuWidth = menu.clientWidth;
            var menuHeight = menu.clientHeight;
            var scrLeft = $(document).scrollLeft();
            var scrTop = $(document).scrollTop();
            var clientWidth = Left + menuWidth;
            var clientHeight = Top + menuHeight;
            if (winWidth < clientWidth) {
                menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
            } else {
                menu.style.left = Left + "px";
            }
            if (winHeight < clientHeight) {
                menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
            } else {
                menu.style.top = Top + "px";
            }

            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })

            if (ids == "") {
                $("#CancelSubscriptions").css("color", "grey");
                $("#DeleteSubscriptions").css("color", "grey");
                $("#CancelSubscriptions").removeAttr('onclick');
                $("#DeleteSubscriptions").removeAttr('onclick');

            } else {
                $("#CancelSubscriptions").css("color", "");
                $("#DeleteSubscriptions").css("color", "");
                $("#CancelSubscriptions").click(function () {
                    CancelSubscriptions();
                })
                $("#DeleteSubscriptions").click(function () {
                    DeleteSubscriptions();
                })
            }

            $.ajax({
                type: "GET",
                url: "../Tools/SubscriptionAjax.ashx?act=property&property=status_id&sid=" + entityid,
                async: false,
                success: function (data) {
                    debugger;
                    if (data == "1") {
                        $("#CancelSubscription").css("color", "");
                        $("#CancelSubscription").click(function () {
                            CancelSubscription();
                        });
                        $("#ActiveSubscription").css("color", "grey");
                        $("#ActiveSubscription").removeAttr('onclick');
                        $("#NoActiveSubscription").css("color", "");
                        $("#NoActiveSubscription").click(function () {
                            NoActiveSubscription();
                        })

                    } else if (data == "0") {
                        $("#CancelSubscription").css("color", "");
                        $("#CancelSubscription").click(function () {
                            CancelSubscription();
                        });
                        $("#NoActiveSubscription").css("color", "grey");
                        $("#NoActiveSubscription").removeAttr('onclick');
                        $("#ActiveSubscription").css("color", "");
                        $("#ActiveSubscription").click(function () {
                            ActiveSubscription();
                        })
                    } else if (data == "2") {
                        $("#CancelSubscription").css("color", "grey");
                        $("#CancelSubscription").removeAttr('onclick');
                        $("#ActiveSubscription").css("color", "grey");
                        $("#ActiveSubscription").removeAttr('onclick');
                        $("#NoActiveSubscription").css("color", "grey");
                        $("#NoActiveSubscription").removeAttr('onclick');
                    }

                }
            })



            return false;
        });
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SaleOrder)
        {%>

        function Edit() {
            window.open("../SaleOrder/SaleOrderEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SaleOrderEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function NewNote() {

        }
        function NewTodo() {

        }
        function View(id) {
            window.open("../SaleOrder/SaleOrderView.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SaleOrderView %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function CancelSaleOrder() {
            $.ajax({
                type: "GET",
                url: "../Tools/SaleOrderAjax.ashx?act=status&status_id=<%=(int)EMT.DoneNOW.DTO.DicEnum.SALES_ORDER_STATUS.CANCELED %>&id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        alert('取消成功');
                        history.go(0);
                    } else {
                        alert("取消失败");
                    }

                }
            })
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Contract)
        {%>
        function Add(type) {
            window.open("../Contract/ContractAdd.aspx?type=" + type, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../Contract/ContractEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=950', false);
        }
        function ViewContract() {
          window.open("../Contract/ContractView.aspx?id=" + entityid, '_blank', 'left=0,top=0,location=no,status=no,width=1350,height=950', false);
        }
        function View(id) {
          window.open("../Contract/ContractView.aspx?id=" + id, '_blank', 'left=0,top=0,location=no,status=no,width=1350,height=950', false);
        }
        function ViewNewWindow() {
          window.open("../Contract/ContractView.aspx?id=" + entityid, '_blank');
        }
        function DeleteContract() {
            if (confirm('删除合同，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=deleteContract&id=" + entityid,
                    success: function (data) {
                      if (data =="True"){
                        alert("删除成功");
                        window.location.reload();
                      } else {
                        alert("删除失败，合同关联以下对象时不能被删除：项目、工单、合同默认成本、配置项、合同成本、已计费条目、工时、taskfire。")
                      }
                    }
                });
            }
        }
        $("#ToolsButton").on("mouseover", function () {
            $("#ToolsButton").css("background", "#fff");
            $(this).css("border-bottom", "none");
            $(".RightClickMenu").show();
            var scrTop = $(document).scrollTop();
            var Top = scrTop + 36;
            $(".RightClickMenu").css("top",Top);
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
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ProuductInventory)
        {%>//产品库存管理
        function Add() {
            parent.parent.parent.openkk();
        }
        function Edit() {
            window.open("../Product/ProductStock.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Inventory %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Transfer() {
            window.open("../Product/TransferProductStock.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InventoryTransfer %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Order() {
            alert("暂未实现");
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/InventoryAjax.ashx?act=delete&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        parent.parent.parent.refrekkk();
                    }
                })
            }

        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.InternalCost)
        {%>
        function Edit() {
            var contract_id = <%=Request.QueryString["id"] %> ;
            if (contract_id != undefined && contract_id != "") {
                window.open("../Contract/InteralCostAddOrEdit.aspx?contract_id=" + contract_id + "&cost_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConIntCostEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        }

        function Delete() {
            if (confirm("如果删除此内部成本，则此员工和角色的所有尚未提交的工时表将使用管理模块中为该资源配置的内部成本。您要继续吗？")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=delete&cicid=" + entityid,
                    async: false,
                    success: function (data) {
                        if (data == "True") {
                            alert('删除成功');
                            history.go(0);
                        } else {
                            alert("删除失败");
                        }

                    }
                })
            }
        }

        function Add() {
            var contract_id = <%=Request.QueryString["id"] %> ;
            if (contract_id != undefined && contract_id != "") {
                window.open("../Contract/InteralCostAddOrEdit.aspx?contract_id=" + contract_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        }

        function View() {

        }

         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Resource)
        {%>//员工
        function View(id) {
            window.open("../SysSetting/SysUserEdit.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Resource %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Add() {
            window.open("../SysSetting/SysUserAdd.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Resource %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../SysSetting/SysUserEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Resource %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Copy() {

        }
        function k() {
            alert("暂未实现");
        }
        function Delete() { }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Role)
        {%>//角色
        function View(id) {
            window.open("../SysSetting/SysRolesAdd.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Role %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Add() {
            window.open("../SysSetting/SysRolesAdd.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Role %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../SysSetting/SysRolesAdd.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Role %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            //if (confirm("删除后无法恢复，是否继续?")) {
            //    $.ajax({
            //        type: "GET",
            //        url: "../Tools/RoleAjax.ashx?act=delete&id=" + entityid,
            //        async: false,
            //        success: function (data) {
            //            alert(data);
            //        }
            //    })
            //}

        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=Active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Inactive() {
            $.ajax({
                type: "GET",
                url: "../Tools/RoleAjax.ashx?act=No_Active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        //从全部激活的合同中排除
        function Exclude() {
            if (confirm("从全部当前激活的合同中排除?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/RoleAjax.ashx?act=Exclude&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
        }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Department)
        {%>//部门
        function View(id) {
            window.open("../SysSetting/SysDepartment.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Department %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Add() {
            window.open("../SysSetting/SysDepartment.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Department %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../SysSetting/SysDepartment.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Department %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/DepartmentAjax.ashx?act=delete&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Prouduct)
        {%>//产品
        function Add() {
            window.open("../Product/ProductAdd.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductView %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../Product/ProductAdd.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProuductEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View(id) {
            window.open("../Product/ProductAdd.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProuductEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=DeleteProduct&product_id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
        }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Relation_ConfigItem)
        {%>
        function view() {

        }
        function Edit() {
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Norelation() {
            var contract_id = <%=Request.QueryString["id"] %>;
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=RelieveIP&InsProId=" + entityid + "&contract_id=" + contract_id,
                success: function (data) {
                    if (data == "True") {
                        alert("解除绑定成功");
                    }
                    else {
                        alert("解除绑定失败");
                    }
                    // history.go(0);

                    parent.location.reload();
                }
            })
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=deleteIP&iProduct_id=" + entityid,
                    success: function (data) {
                        if (data == "True") {
                            alert('删除成功');
                        } else if (data == "False") {
                            alert('删除失败');
                        }
                        history.go(0);
                    }
                })
            }
        }

        function Add() {
            var contract_id = <%=Request.QueryString["id"] %>;
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?contract_id=" + contract_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Norelation_ConfigItem)
        {%>
        function view() {

        }
        function Edit() {
            window.open("../ConfigurationItem/AddOrEditConfigItem.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.EditInstalledProduct %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Relation() {
            var contract_id = <%=Request.QueryString["contract_id"] %>;
            var isopen = "";
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/ContractAjax.ashx?act=isService&contract_id=" + contract_id,
                success: function (data) {
                    if (data != "") {
                        isopen = data;
                    }
                }
            })


            if (isopen == "") {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=RelationIP&InsProId=" + entityid + "&contract_id=" + contract_id,
                    success: function (data) {
                        if (data == "True") {
                            alert('关联成功');
                        } else if (data == "False") {
                            alert('关联失败');
                        }
                        parent.location.reload();

                    }
                })
            }
            else {
                // 打开窗口
                window.open("../ConfigurationItem/RelatiobContract.aspx?insProId=" + entityid + "&contractId=" + contract_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.RelationContract %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
        }
        function Delete() {
            if (confirm("删除后无法恢复，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ProductAjax.ashx?act=deleteIP&iProduct_id=" + entityid,
                    success: function (data) {
                        if (data == "True") {
                            alert('删除成功');
                        } else if (data == "False") {
                            alert('删除失败');
                        }
                        history.go(0);
                    }
                })
            }
        }


         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONFIGITEM)
        {%>//配置项类型
        function View(id) {
            window.open("../ConfigurationItem/ConfigType.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConfigItemType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open("../ConfigurationItem/ConfigType.aspx?", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConfigItemType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
          }
          function Edit() {
              window.open("../ConfigurationItem/ConfigType.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConfigItemType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
          }
          function Delete() {
              if (confirm('删除操作将不能恢复，是否继续?')) {
                  $.ajax({
                      type: "GET",
                      url: "../Tools/ConfigItemTypeAjax.ashx?act=delete_validate&id=" + entityid,
                      success: function (data) {
                          if (data == "system") {
                              alert("系统默认不能删除！");
                          } else if (data == "other") {
                              alert("其他原因使得删除失败！");
                          } else {
                              if (confirm(data)) {
                                  $.ajax({
                                      type: "GET",
                                      url: "../Tools/ConfigItemTypeAjax.ashx?act=delete&id=" + entityid,
                                      success: function (data) {
                                          alert(data);
                                          history.go(0);
                                      }
                                  });
                              }
                          }
                      }
                  });
              }
              window.location.reload();
          }
          function Active() {
              $.ajax({
                  type: "GET",
                  url: "../Tools/ConfigItemTypeAjax.ashx?act=Active&id=" + entityid,
                  async: false,
                  success: function (data) {
                      alert(data);
                      history.go(0);
                  }
              })
              window.location.reload();
          }
          function Inactive() {
              $.ajax({
                  type: "GET",
                  url: "../Tools/ConfigItemTypeAjax.ashx?act=No_Active&id=" + entityid,
                  async: false,
                  success: function (data) {
                      alert(data);
                      history.go(0);
                  }
              })
              window.location.reload();
          }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SECURITYLEVEL)
        {%>//安全等级
        function View(id) {
            window.open('../SysSetting/SysUserSecurityLevel.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SecurityLevel%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Copy() {
            $.ajax({
                type: "GET",
                url: "../Tools/SecurityLevelAjax.ashx?act=copy&id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "error") {
                        alert("安全等级复制失败！");
                    } else {
                        alert("安全等级复制成功，点击确定进入编辑界面！");
                        window.open('../SysSetting/SysUserSecurityLevel.aspx?id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SecurityLevel%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                        history.go(0);
                    }
                }
            })
        }
        function Edit() {
            window.open('../SysSetting/SysUserSecurityLevel.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SecurityLevel%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/SecurityLevelAjax.ashx?act=active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
            window.location.reload();
        }
        function Delete() {
            if (confirm('删除操作将不能恢复，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/SecurityLevelAjax.ashx?act=delete&id=" + entityid,
                    async: false,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            }
            window.location.reload();
        }
        function Inactive() {
            $.ajax({
                type: "GET",
                url: "../Tools/SecurityLevelAjax.ashx?act=noactive&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
            window.location.reload();
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.MILESTONE)
        {%>//里程碑状态
        function View(id) {
            window.open('../SysSetting/ContractMilestone.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open('../SysSetting/ContractMilestone.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open('../SysSetting/ContractMilestone.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralViewAjax.ashx?act=active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
        function Delete() {
            if (confirm('删除操作将不能恢复，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid,
                    async: false,
                    success: function (data) {
                        if (data == "system") {
                            alert("系统状态不能删除！");
                        } else if (data == "other") {
                            alert("其他原因使得删除失败！");
                        } else if (data=="success"){
                            alert("删除成功！");
                            history.go(0);
                        } else {
                            alert(data);
                            history.go(0);
                        }
                    }
                });
            }
        }
        function Inactive() {
            $.ajax({
                type: "GET",
                url: "../Tools/GeneralViewAjax.ashx?act=noactive&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_CHARGES)
        {%>//撤销审批成本
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            //$("#BackgroundOverLay").show();
            //$("#LoadingIndicator").show();
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=CHARGES&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_RECURRING_SERVICES)
        {%>//撤销定期服务审批
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            //$("#BackgroundOverLay").show();
            //$("#LoadingIndicator").show();
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=Recurring_Services&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_MILESTONES)
        {%>//撤销里程碑审批
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=Milestones&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
       <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.REVOKE_SUBSCRIPTIONS)
        {%>//撤销订阅审批
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            //$("#BackgroundOverLay").show();
            //$("#LoadingIndicator").show();
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ReverseAjax.ashx?act=Subscriptions&ids=" + ids,
                    success: function (data) {
                        alert(data);
                        history.go(0);
                    }
                })
            } else {
                alert("请选择需要审批的数据！");
            }
        }
            <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_MILESTONES)
        {%>//审批里程碑
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("请选择需要审批的数据！");
            }
        }
        //审批并提交
        function Post() {
            window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看里程碑详情
        function Miledetail() {
            window.open('../Contract/ContractMilestoneDetail.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractMilestone%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看合同详情
        function ContractDetail() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=ContractDetails&id=" + entityid + "&type=" + <%=queryTypeId%>,
                success: function (data) {
                    window.open('../Contract/ContractView.aspx?&id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeDetails%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                }
            });
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_SUBSCRIPTIONS)
        {%>//审批订阅
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("请选择需要审批的数据！");
            }
        }
        //审批并提交
        function Post() {
            window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //恢复初始值
        function Restore_Initiall() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=init&id=" + entityid + "&type=" + <%=queryTypeId%>,
                async: false,
                success: function (data) {
                    alert(data);
                }
            });
            window.location.reload();
        }
        //调整总价
        function AdjustExtend() {
            window.open('../Contract/AdjustExtendedPrice.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_RECURRING_SERVICES)
        {%>//审批定期服务
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("请选择需要审批的数据！");
            }
        }
        //审批并提交
        function Post() {
            window.open('../Contract/ContractPostDate.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractPostDate%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看合同详情
        function ContractDetail() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=ContractDetails&id=" + entityid + "&type=" + <%=queryTypeId%>,
                success: function (data) {
                    window.open('../Contract/ContractView.aspx?&id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeDetails%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                }
            });
        }
        //恢复初始值
        function Restore_Initiall() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=init&id=" + entityid + "&type=" + <%=queryTypeId%>,
                async: false,
                success: function (data) {
                    alert(data);
                }
            });
            window.location.reload();
        }
        //调整总价
        function AdjustExtend() {
            window.open('../Contract/AdjustExtendedPrice.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);

        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.APPROVE_CHARGES)
        {%>//审批成本
        //审批并提交(批量)
        $("#CheckAll").click(function () {
            if ($(this).is(":checked")) {
                $(".IsChecked").prop("checked", true);
                $(".IsChecked").css("checked", "checked");
            }
            else {
                $(".IsChecked").prop("checked", false);
                $(".IsChecked").css("checked", "");
            }
        })
        function Add() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            });
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                window.open('../Contract/ApproveChargeSelect.aspx?type=' +  <%=queryTypeId%>  + '&ids=' + ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractChargeSelect%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            } else {
                alert("至少选择一项！");
            }
        }
        //生成发票
      <%--  function ToInvoice() {
            $("#PageFrame").attr("src", "Invoice/InvocieSearch");
           <%-- window.open('../Invoice/InvocieSearch.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>','left=0,top=0,location=no,status=no,width=900,height=750',false);--%>
        //审批并提交
        function Post() {
            window.open('../Contract/ApproveChargeSelect.aspx?type=' +  <%=queryTypeId%>  + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看合同详情
        function ContractDetail() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=ContractDetails&id=" + entityid + "&type=" + <%=queryTypeId%>,
                success: function (data) {
                    window.open('../Contract/ContractView.aspx?&id=' + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeDetails%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);  
                }
            });    
        }
        //查看工单详情
        function TicketDetail() {

        }
        //设置为可计费
        function Billing() {
            $.ajax({
                type: "GET",
                url: "../Tools/ApproveAndPostAjax.ashx?act=billing&id=" + entityid + "&type=" + <%=queryTypeId%>,
                    success: function (data) {
                        alert(data);
                    }
                });
                window.location.reload();
            }
            //设置为不可计费
            function NoBilling() {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ApproveAndPostAjax.ashx?act=nobilling&id=" + entityid + "&type=" + <%=queryTypeId%>,
                    async: false,
                    success: function (data) {
                        alert(data);
                    }
                });
                window.location.reload();
            }
            //恢复初始值
            function Restore_Initiall() {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ApproveAndPostAjax.ashx?act=init&id=" + entityid + "&type=" + <%=queryTypeId%>,
                    async: false,
                    success: function (data) {
                        alert(data);
                    }
                });
                window.location.reload();
            }
            //调整总价
            function AdjustExtend() {
                window.open('../Contract/AdjustExtendedPrice.aspx?type=' + <%=queryTypeId%> + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdjust%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);

            }
 <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Contract_Charge)
        {%>
            $("#CheckAll").click(function () {
                if ($(this).is(":checked")) {
                    $(".IsChecked").prop("checked", true);
                    $(".IsChecked").css("checked", "checked");
                }
                else {
                    $(".IsChecked").prop("checked", false);
                    $(".IsChecked").css("checked", "");
                }
            })
            // 新增
            function Add() {
                window.open('../Contract/AddCharges.aspx?contract_id=' + <%=Request.QueryString["id"] %>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeEdit%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        // 修改
        function Edit() {
            window.open('../Contract/AddCharges.aspx?contract_id=' + <%=Request.QueryString["id"] %> + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeEdit%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        // 查看
        function ViewCharge() {
            window.open('../Contract/ChargeDetails.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConChargeEdit%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        // 更改成本是否可计费
        function ChangeIsbilled(isBilled) {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=updateCost&isbill=" + isBilled + "&cost_id=" + entityid,
                async: false,
                success: function (data) {
                    debugger;
                    if (data == "ok") {
                        alert('更改成功');
                    } else if (data == "Already") {
                        alert('计费无需更改');
                    }
                    else if (data == "404") {
                        alert("成本丢失，请重新登陆查看");
                    } else if (data == "billed") {
                        alert("成本已经提交并审批，不可更改");
                    }
                    history.go(0);
                }
            })
        }

        function ChangeManyIsbilled(isBilled) {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=updateCosts&isbill=" + isBilled + "&ids=" + ids,
                    async: false,
                    success: function (data) {
                        if (data == "True") {
                            alert('批量更改成功');
                        } else if (data == "False") {
                            alert('批量更改失败');
                        }
                        history.go(0);
                    }
                })
            }
        }

        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=deleteCost&cost_id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        alert('删除成功');
                    } else if (data == "False") {
                        alert('删除失败');
                    }
                    history.go(0);
                }
            })
        }

        function ManyDelete() {
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length - 1);
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=deleteCosts&ids=" + ids,
                    async: false,
                    success: function (data) {
                        if (data == "True") {
                            alert('批量删除成功');
                        } else if (data == "False") {
                            alert('批量删除失败');
                        }
                        history.go(0);
                    }
                })
            }
        }
        var entityid;
        var menu = document.getElementById("menu");
        var menu_i2_right = document.getElementById("menu-i2-right");
        var Times = 0;

        $(".dn_tr").bind("contextmenu", function (event) {
            clearInterval(Times);
            var oEvent = event;
            entityid = $(this).data("val");
            (function () {
                menu.style.display = "block";
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            }());
            menu.onmouseenter = function () {
                clearInterval(Times);
                menu.style.display = "block";
            };
            menu.onmouseleave = function () {
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            };
            var Top = $(document).scrollTop() + oEvent.clientY;
            var Left = $(document).scrollLeft() + oEvent.clientX;
            var winWidth = window.innerWidth;
            var winHeight = window.innerHeight;
            var menuWidth = menu.clientWidth;
            var menuHeight = menu.clientHeight;
            var scrLeft = $(document).scrollLeft();
            var scrTop = $(document).scrollTop();
            var clientWidth = Left + menuWidth;
            var clientHeight = Top + menuHeight;
            if (winWidth < clientWidth) {
                menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
            } else {
                menu.style.left = Left + "px";
            }
            if (winHeight < clientHeight) {
                menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
            } else {
                menu.style.top = Top + "px";
            }
            debugger;
            var ids = "";
            $(".IsChecked").each(function () {
                if ($(this).is(":checked")) {
                    ids += $(this).val() + ',';
                }
            })

            if (ids == "") {
                $("#ChooseBilled").css("color", "grey");
                $("#ChooseNoBilled").css("color", "grey");
                $("#ChooseDelete").css("color", "grey");
                $("#ChooseBilled").removeAttr('onclick');
                $("#ChooseNoBilled").removeAttr('onclick');
                $("#ChooseDelete").removeAttr('onclick');

            } else {
                $("#ChooseBilled").css("color", "");
                $("#ChooseNoBilled").css("color", "");
                $("#ChooseDelete").css("color", "");
                $("#ChooseBilled").click(function () {
                    ChangeManyIsbilled(1);
                })
                $("#ChooseNoBilled").click(function () {
                    ChangeManyIsbilled(0);
                })
                $("#ChooseDelete").click(function () {
                    ManyDelete();
                })
            }
            var isBillCharge = ""; // 判断这个成本是否是已经审批提交的成本
            var isBill = "";           // 这个成本是否可计费
            var costCodeId = "";         // 这个成本的物料代码
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=GetContractCost&cost_id=" + entityid,
                async: false,
                dataType: "json",
                success: function (data) {
                    isBillCharge = data.bill_status;
                    isBill = data.is_billable;
                    costCodeId = data.cost_code_id;
                }
            })
            debugger;
            if (isBillCharge == "1") {   // 代表成本时审批并提交
                $("#thisBilled").css("color", "grey");
                $("#thisBilled").removeAttr('onclick');
                $("#thisNoBilled").css("color", "grey");
                $("#thisNoBilled").removeAttr('onclick');
                $("#delete").css("color", "grey");
                $("#delete").removeAttr('onclick');
            } else {

                if (isBill == "1") {  // 代表成本已经是计费
                    $("#thisBilled").css("color", "grey");
                    $("#thisBilled").removeAttr('onclick');
                    $("#thisNoBilled").css("color", "");
                    $("#thisNoBilled").click(function () {
                        ChangeIsbilled(0);
                    });
                } else if (isBill == "0") {
                    $("#thisNoBilled").css("color", "grey");
                    $("#thisNoBilled").removeAttr('onclick');
                    $("#thisBilled").css("color", "");
                    $("#thisBilled").click(function () {
                        ChangeIsbilled(1);
                    });
                }

                if (costCodeId != "" && costCodeId !=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.BLOCK_PURCHASE %>&&costCodeId !=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RETAINER_PURCHASE %>&&costCodeId !=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.TICKET_PURCHASE %>){
                    $("#delete").css("color", "");
                    $("#delete").click(function () {
                        Delete();
                    });
                }
                else {
                    $("#delete").css("color", "grey");
                    $("#delete").removeAttr('onclick');
                }

            }



            return false;
        });

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONTRACT_DEFAULT_COST)
        { %>
        function Edit() {
            window.open('../Contract/AddDefaultCharge.aspx?contract_id=' + <%=Request.QueryString["id"] %> + '&id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConDefCostEdit%>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=deleteDefaultCost&cdcID=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        alert("删除成功");
                    }
                    else {
                        alert("删除失败");
                    }
                    history.go(0);
                }
            })
        }
        function Add() {
            debugger;
            var contract_id = '<%=Request.QueryString["id"] %>';
            var isAdd = "";
            if (contract_id != "" && (!isNaN(contract_id))) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=GetDefaultCost&contract_id=" + contract_id,
                    async: false,
                    success: function (data) {
                        if (data != "") {
                            isAdd = "1";
                        }
                    }
                })
            }
            if (isAdd != "") {
                alert("该合同已经拥有默认成本，不可重复添加！");
                return false;
            }

            window.open('../Contract/AddDefaultCharge.aspx?contract_id=' + <%=Request.QueryString["id"] %>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConDefCostAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View() {

        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONTRACT_RATE)
        {%>

        function Add() {
            window.open('../Contract/AddContractRate.aspx?contract_id=' + <%=Request.QueryString["id"] %>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {

            window.open('../Contract/AddContractRate.aspx?contract_id=' + <%=Request.QueryString["id"] %>+"&rate_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }

        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/ContractAjax.ashx?act=DeleteRate&rateId=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "True") {
                        alert("删除成功");
                    }
                    else {
                        alert("删除失败");
                    }
                    history.go(0);
                }
            })
        }
         <%}//发票模板
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.InvoiceTemplate)
        {%>
        function Add() {
            OpenWindow("../InvoiceTemplate/InvoiceTemplateAttr.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InvoiceTemplateAttr %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View(id) {
            OpenWindow("../InvoiceTemplate/InvoiceTempEdit.aspx?id=" + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InvoiceTemplate %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            OpenWindow("../InvoiceTemplate/InvoiceTempEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InvoiceTemplate %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Copy() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=copy&id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "error") {
                        alert("发票模板复制失败！");
                    } else {
                        alert("发票模板复制成功，点击确定进入编辑界面！");
                        OpenWindow("../InvoiceTemplate/InvoiceTempEdit.aspx?id=" + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InvoiceTemplateAttr %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                    }                    
                }
            })
        }
        function Delete() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=delete&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Default() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=default&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=active&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        function NoActive() {
            $.ajax({
                type: "GET",
                url: "../Tools/QuoteTemplateAjax.ashx?act=noactive&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }



         <%}//历史发票查询
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Invoice_History)
        {%>
        function Add() {
            alert("暂未实现");
        }
        //修改发票
        function EditInvoice() {
            window.open('../Invoice/InvoiceNumberAndDateEdit.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.InvoiceHistoryEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //作废发票
        function VoidInvoice() {
            $.ajax({
                type: "GET",
                url: "../Tools/HistoryInvoiceAjax.ashx?act=voidone&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        //作废本批发票
        function VoidBatchInvoice() {
            $.ajax({
                type: "GET",
                url: "../Tools/HistoryInvoiceAjax.ashx?act=voidbatch&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        //作废发票并取消审批
        function VoidInvoiceAndUnPost() {
            $.ajax({
                type: "GET",
                url: "../Tools/HistoryInvoiceAjax.ashx?act=voidunpost&id=" + entityid,
                async: false,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            })
        }
        //查看发票
        function InvoiceView() {
            window.open("../Invoice/InvoicePreview.aspx?isInvoice=1&invoice_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PREVIEW %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        //查看本批全部发票
        function InvoiceAllView() {
            $.ajax({
                type: "GET",
                url: "../Tools/HistoryInvoiceAjax.ashx?act=getbatch_id&id=" + entityid,
                async: false,
                success: function (data) {
                    if (data > 0) {
                        window.open("../Invoice/InvoicePreview.aspx?isInvoice=1&inv_batch=" + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PREVIEW %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                    } else {
                        alert("跳转失败！");
                    }                   
                }
            })          
        }
        //发票设置
        function InvoiceEdit() {
            $.ajax({
                type: "GET",
                url: "../Tools/HistoryInvoiceAjax.ashx?act=getaccount_id&id=" + entityid,
                async: false,
                success: function (data) {
                    window.open("../Invoice/PreferencesInvoice.aspx?account_id=" + data, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PREFERENCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                }
            })           
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ACCOUNTTYPE)
        { %>//客户类别
        function Add() {
            window.open('../SysSetting/AccountClass.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ACCOUNTTYPE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open('../SysSetting/AccountClass.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ACCOUNTTYPE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View(id) {
            window.open('../SysSetting/AccountClass.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ACCOUNTTYPE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm('删除操作将不能恢复，是否继续?')) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/AccountClassAjax.ashx?act=delete_validate&id=" + entityid,
                    success: function (data) {
                        if (data == "system") {
                            alert("系统默认不能删除！");
                            return false;
                        } else if (data == "other") {
                            alert("其他原因使得删除失败！");
                        } else if (data == "success") {
                            alert("删除成功！");
                            history.go(0);
                        } else if (data == "error") {
                            alert("删除失败！");
                        } else {
                            $("#accountcount").text(data);
                            $("#BackgroundOverLay").show();
                            $("#accounttanchuan").addClass("Active");
                            $("#delete_account").on("click", function () {                               
                                //点击删除
                                $.ajax({
                                    type: "GET",
                                    url: "../Tools/AccountClassAjax.ashx?act=delete&id=" + entityid,
                                    success: function (data) {
                                        if (data == "success") {
                                            alert("删除成功！");
                                            history.go(0);
                                        } else if (data == "error") {
                                            alert("删除失败！");
                                        }
                                    }
                                });
                                $("#BackgroundOverLay").hide();
                                $("#accounttanchuan").removeClass("Active");
                            });   
                             
                            //选择停用
                            $("#noactive_account").on("click", function () {
                                NoActive();
                                $("#BackgroundOverLay").hide();
                                $("#accounttanchuan").removeClass("Active");
                            });

                            //取消
                            $(".cancel_account").on("click", function () {
                                $("#BackgroundOverLay").hide();
                                $("#accounttanchuan").removeClass("Active");
                            });
                        }
                    }
                });
            }
        }
        function Active() {
            $.ajax({
                type: "GET",
                url: "../Tools/AccountClassAjax.ashx?act=active&id=" + entityid,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
        function NoActive() {
            $.ajax({
                type: "GET",
                url: "../Tools/AccountClassAjax.ashx?act=noactive&id=" + entityid,
                success: function (data) {
                    alert(data);
                    history.go(0);
                }
            });
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPPORTUNITYWINREASON)
        { %>//关闭商机
        function Add() {           
            window.open('../Opportunity/OpportunityWinReasons.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYWIN %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);               
        }
        function Edit() {
            window.open('../Opportunity/OpportunityWinReasons.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYWIN %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('确认删除?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/OpportunityReasonAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_WIN_REASON_TYPE%>",//GT_id 表示当前操作的类型
                        success: function (data) {
                            if (data == "system") {
                                alert("系统默认不能删除！");
                                return false;
                            } else if (data == "other") {
                                alert("其他原因使得删除失败！");
                            } else if (data == "success") {
                                alert("删除成功！");
                                history.go(0);
                            } else if (data == "error") {
                                alert("删除失败！");
                            } else {
                                alert(data);
                                history.go(0);
                            }
                        }
                });
            }
        }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPPORTUNITYLOSSREASON)
        { %>//丢失商机
          function Add() {
              window.open('../Opportunity/OpportunityLossReason.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYLOSS %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
          function View(id) {
              window.open('../Opportunity/OpportunityLossReason.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYLOSS %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
          }
          function Edit() {
              window.open('../Opportunity/OpportunityLossReason.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITYLOSS %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('确认删除?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/OpportunityReasonAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_LOSS_REASON_TYPE%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                             return false;
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             alert(data);
                             history.go(0);
                         }
                     }
                 });
             }
          }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Market)
        { %>//市场
         function Edit() {
             window.open('../SysSetting/SysMarket.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MARKET_SEGMENT %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysMarket.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MARKET_SEGMENT %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/SysMarket.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MARKET_SEGMENT %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.MARKET_SEGMENT%>",//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else if (data == "success") {
                               alert("删除成功！");
                               history.go(0);
                           } else if (data == "error") {
                               alert("删除失败！");
                           } else {
                               if (confirm(data)) {
                                   $.ajax({
                                       type: "GET",
                                       url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.MARKET_SEGMENT%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                   });
                               }
                           }
                       }
                });
            }
        }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ACCOUNTREGION)
        { %>//区域
         function Edit() {
             window.open('../SysSetting/SysRegion.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.REGION %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysRegion.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.REGION %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/SysRegion.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.REGION %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.REGION%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.REGION%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Territory)
        { %>//地域
         function Edit() {
             window.open('../SysSetting/SysTerritory.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TERRITORY %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysTerritory.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TERRITORY %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
           }
           function View(id) {
               window.open('../SysSetting/SysTerritory.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.TERRITORY %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.TERRITORY%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.TERRITORY%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }

          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.COMPETITOR)
        { %>//竞争对手
         function Edit() {
             window.open('../SysSetting/SysCompetitor.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.COMPETITOR %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/SysCompetitor.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.COMPETITOR %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/SysCompetitor.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.COMPETITOR %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
           }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.COMPETITOR%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.COMPETITOR%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }

          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPORTUNITYSOURCE)
        { %>//商机来源
         function Edit() {
             window.open('../Opportunity/OpportunityLeadSource.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_SOURCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../Opportunity/OpportunityLeadSource.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_SOURCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../Opportunity/OpportunityLeadSource.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_SOURCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_SOURCE%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_SOURCE%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }

          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SUFFIXES)
        { %>//后缀
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.NAME_SUFFIX%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.NAME_SUFFIX%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                 });
                             }
                         }
                     }
                 });
             }
         }
         function Edit() {
             window.open('../SysSetting/Suffixes.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/Suffixes.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/Suffixes.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }


          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ACTIONTYPE)
        { %>//活动类型
         function Delete() {
                 if (confirm('删除操作将不能恢复，是否继续?')) {
                     $.ajax({
                         type: "GET",
                         url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE%>",//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else if (data == "success") {
                               alert("删除成功！");
                               history.go(0);
                           } else if (data == "error") {
                               alert("删除失败！");
                           } else {
                               if (confirm(data)) {
                                   $.ajax({
                                       type: "GET",
                                       url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.ACTION_TYPE%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           alert(data);
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if (data == "error") {
                                               alert("删除失败！");
                                           }
                                       }
                                   });
                               }
                           }
                       }
                     });
                 }
             }
         function Edit() {
             window.open('../SysSetting/ActionType.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open('../SysSetting/ActionType.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/ActionType.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
          <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OPPORTUNITYAGES)
        { %>
         function Delete() {
             //商机阶段
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: '../Tools/GeneralViewAjax.ashx?act=delete_validate&id='+ entityid + '&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.OPPORTUNITY_STAGE%>',//GT_id 表示当前操作的类型
                       success: function (data) {
                           if (data == "system") {
                               alert("系统默认不能删除！");
                           } else if (data == "other") {
                               alert("其他原因使得删除失败！");
                           } else if (data == "success") {
                               alert("删除成功！");
                               history.go(0);
                           } else if (data == "error") {
                               alert("删除失败！");
                           }
                           else {
                               alert(data);
                               history.go(0);
                           }
                       }
                });
            }
         }
         function Edit() {
             window.open('../Opportunity/OpportunityStage.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../Opportunity/OpportunityStage.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../Opportunity/OpportunityStage.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OPPORTUNITY_STAGE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.CONFIGSUBSCRIPTION)
        {%>

         function Add() {
             window.open("../ConfigurationItem/SubscriptionAddOrEdit.aspx?insProId=" + <%=Request.QueryString["id"] %>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SubscriptionEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }

         function Edit() {
             window.open("../ConfigurationItem/SubscriptionAddOrEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SubscriptionEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Update() {

         }
         function Cancel()
         {
             if (confirm("你选择取消此订阅,将导致该订阅的所有未计费项被立即取消,通常在该客户永久注销的前提下操作, 该操作无法恢复确定无论如何都要取消此订阅?")) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=2&sid=" + entityid,
                     async: false,
                     success: function (data) {
                         if (data == "ok") {
                             alert('取消成功');
                             history.go(0);
                         } else if (data == "Already") {
                             alert('已经取消');
                         }
                         else {
                             alert("取消失败");
                         }

                     }
                 })
             }

         }
         function Invalid() {
             if (confirm("你选择注销(搁置)此订阅,,该订阅的计费项将继续计费,该订阅的关联支持服务将被停止,该操作通常发生在客户发生欠费或者该客户的服务被暂停,你确定无法如何都要注销此订阅?")) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=0&sid=" + entityid,
                     async: false,
                     success: function (data) {
                         if (data == "ok") {
                             alert('停用成功');
                             history.go(0);
                         } else if (data == "Already") {
                             alert('已经停用');
                         }
                         else {
                             alert("停用失败");
                         }

                     }
                 })
             }
         }
         function Delete() {
             if (confirm("你选择注销(搁置)此订阅,,该订阅的计费项将继续计费,该订阅的关联支持服务将被停止,该操作通常发生在客户发生欠费或者该客户的服务被暂停,你确定无法如何都要注销此订阅?")) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/SubscriptionAjax.ashx?act=activeSubscript&status_id=0&sid=" + entityid,
                     async: false,
                     success: function (data) {
                         if (data == "ok") {
                             alert('停用成功');
                             history.go(0);
                         } else if (data == "Already") {
                             alert('已经停用');
                         }
                         else {
                             alert("停用失败");
                         }

                     }
                 })
             }
         }

        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractUDF)
        { %>
        function Edit() {
          window.open("../Contract/ContractUdf.aspx?contractId=" + $("#id").val() + "&colName=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.SubscriptionEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function View(id) {
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractBlock
        || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractBlockTime
        || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractBlockTicket)
        { %>
        function Edit() {
          window.open("../Contract/EditRetainerPurchase.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConBlockEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=868', false);
        }
        function Add() {
          window.open("../Contract/AddRetainerPurchase.aspx?id=" + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConBlockAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=868', false);
        }
        function SetActive() {

            $.ajax({
              type: "GET",
              url: "../Tools/ContractAjax.ashx?act=SetBlockActive&blockId=" + entityid,
              async: false,
              success: function (data) {
                if (data == "True") {
                  alert("设置成功");
                  history.go(0);
                } else {
                  alert("设置失败！已审批预付不可修改");
                }
              }
            })
        }
        function SetInactive() {

          $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=SetBlockInactive&blockId=" + entityid,
            async: false,
            success: function (data) {
              if (data == "True") {
                alert("设置成功");
                history.go(0);
              } else {
                alert("设置失败！已审批预付不可修改");
              }
            }
          })
        }
        function Delete() {
          if (confirm("预付费用关联了一个合同成本，如果删除，则相关的合同成本也会删除，是否继续?")) {
            $.ajax({
              type: "GET",
              url: "../Tools/ContractAjax.ashx?act=DeleteBlock&blockId=" + entityid,
              async: false,
              success: function (data) {
                alert("删除成功");
                history.go(0);
              }
            })
          }
        }
        function View(id) {
        }
        <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractRate) { %>
        function Edit() {
            window.open("../Contract/RoleRate.aspx?contractId=" + $("#id").val() + "&id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open("../Contract/RoleRate.aspx?contractId=" + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConRateAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("修改将会影响本合同的未提交工时表，是否继续?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=DeleteRate&rateId=" + entityid,
                    async: false,
                    success: function (data) {
                      history.go(0);
                    }
                })
            }
        }
        <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractMilestone) { %>
        function Edit() {
            window.open("../Contract/ContractMilestone.aspx?contractId=" + $("#id").val() + "&id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConMilestoneEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Add() {
            window.open("../Contract/ContractMilestone.aspx?contractId=" + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConMilestoneAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Delete() {
            if (confirm("确定要删除此里程碑吗?")) {
                $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=DeleteMilestone&milestoneId=" + entityid,
                    async: false,
                    success: function (data) {
                      if (data == "True") {
                            alert('删除成功');
                            history.go(0);
                        } else {
                            alert("删除失败，已计费状态下不能删除");
                        }
                    }
                })
            }
        }
         <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractType)
        { %>//合同类别
            function Delete() {
                if (confirm('删除操作将不能恢复，是否继续?')) {
                    $.ajax({
                        type: "GET",
                        url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.CONTRACT_CATE%>",//GT_id 表示当前操作的类型
                         success: function (data) {
                             if (data== "system") {
                                 alert("系统默认不能删除！");
                             } else if (data == "other") {
                                alert("其他原因使得删除失败！");
                             } else if (data == "success") {
                                 alert("删除成功！");
                                 history.go(0);
                             } else if (data == "error") {
                                 alert("删除失败！");
                             }
                                 else {
                                 if (confirm(data)) {
                                     $.ajax({
                                         type: "GET",
                                         url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.CONTRACT_CATE%>",//GT_id 表示当前操作的类型
                                       success: function (data) {
                                           if (data == "success") {
                                               alert("删除成功！");
                                               history.go(0);
                                           } else if(data=="error") {
                                               alert("删除失败！");
                                           }
                                       }
                                     });
                                 }
                             }
                         }
                    });
                }
            }
        function Edit() {
            window.open('../SysSetting/ContractType.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/ContractType.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/ContractType.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContractService) { %>
         function AddService() {
           window.open('../Contract/AddService.aspx?type=1&contractId=' + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConServiceAdd %>', 'left=0,top=0,location=no,status=no,width=710,height=524', false);
           }
         function AddServiceBundle() {
           window.open('../Contract/AddService.aspx?type=2&contractId=' + $("#id").val(), '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ConServiceAdd %>', 'left=0,top=0,location=no,status=no,width=710,height=524', false);
           }
         function ApplyDiscount() {
           }
         function Delete() {
            $.ajax({
            type: "GET",
            url: "../Tools/ContractAjax.ashx?act=IsApprove&id=" + entityid,
            async: false,
            success: function (data) {
              if (data == "True") {
                alert('该服务/服务包不能删除，因为已经计费');
                return;
              } else {
                if (confirm("所有的合同服务周期和交易历史将会被删除，是否继续?")) {
                  $.ajax({
                    type: "GET",
                    url: "../Tools/ContractAjax.ashx?act=DeleteService&id=" + entityid,
                    async: false,
                    success: function (data) {
                      if (data == "True") {
                        alert('删除成功');
                        window.location.reload();
                      } else {
                        alert('该服务/服务包不能删除，因为已经计费');
                      }
                    }
                  })
                }
              }
            }
          })
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SUFFIXES)
        { %>//姓名后缀
         function Edit() {
             window.open('../SysSetting/Suffixes.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Add() {
             window.open('../SysSetting/Suffixes.aspx', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/Suffixes.aspx?id=' + id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractType %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid + "&GT_id=<%=(int)EMT.DoneNOW.DTO.GeneralTableEnum.NAME_SUFFIX%>",//GT_id 表示当前操作的类型
                     success: function (data) {
                         if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         }
                     }
                 });
             }

              <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Line_Of_Business)
        { %>//general表的通用处理
             function Edit() {
                 window.open('../SysSetting/GeneralAdd.aspx?id=' + entityid + '&type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.GeneralAddAndEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
             }
             function Add() {
                 window.open('../SysSetting/GeneralAdd.aspx?type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.GeneralAddAndEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function View(id) {
             window.open('../SysSetting/GeneralAdd.aspx?id=' + id + 'type=' +<%=queryTypeId%>, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.GeneralAddAndEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
         }
         function Delete() {
             if (confirm('删除操作将不能恢复，是否继续?')) {
                 $.ajax({
                     type: "GET",
                     url: "../Tools/GeneralViewAjax.ashx?act=delete_validate&id=" + entityid,
                     success: function (data) {
                         if (data == "system") {
                             alert("系统默认不能删除！");
                         } else if (data == "other") {
                             alert("其他原因使得删除失败！");
                         } else if (data == "success") {
                             alert("删除成功！");
                             history.go(0);
                         } else if (data == "error") {
                             alert("删除失败！");
                         } else {
                             if (confirm(data)) {
                                 $.ajax({
                                     type: "GET",
                                     url: "../Tools/GeneralViewAjax.ashx?act=delete&id=" + entityid,
                                     success: function (data) {
                                         alert(data);
                                         if (data == "success") {
                                             alert("删除成功！");
                                             history.go(0);
                                         } else if (data == "error") {
                                             alert("删除失败！");
                                         }
                                     }
                                 });
                             }
                         }
                     }
                 });
             }
         }

        <%}%>
        function openopenopen() {
            //alert("暂未实现");
        }
    </script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
</body>
</html>
