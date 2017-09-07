<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchBodyFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchBodyFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
	<link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/style.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css"/>
    <title></title>
</head>
<style>
    .searchcontent{
   width:   100%;   height:   100%;min-width:2200px;
    }
    .searchcontent table th {
    background-color: #cbd9e4;
    border-color: #98b4ca;
    color: #64727a;
    height: 28px;
    line-height: 28px;
    text-align:center;
}
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
</style>
<body style="overflow-x:auto;overflow-y:auto;">
    <form id="form1">
        <div id="search_list">
            <input type="hidden" id="page_num" name="page_num" <%if (queryResult != null) {%>value="<%=queryResult.page %>"<%} %> />
            <input type="hidden" id="page_size" name="page_size" <%if (queryResult != null) {%>value="<%=queryResult.page_size %>"<%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null) {%>value="<%=queryResult.query_id %>"<%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null) {%>value="<%=queryResult.order_by %>"<%} %> />
            <input type="hidden" id="cat" name="cat" value="<%=catId %>" />
            <input type="hidden" id="type" name="type" value="<%=queryTypeId %>" />
            <input type="hidden" id="group" name="group" value="<%=paraGroupId %>" />
            <input type="hidden" name="id" value="<%=objId %>" />
            <input type="hidden" id="isCheck" name="isCheck" value="<%=isCheck %>" />
            <div id="conditions">
                <%foreach (var para in queryParaValue)
                    { %>
                <input type="hidden" name="<%=para.val %>" value="<%=para.show %>" />
                <%} %>
            </div>
        </div>
        <div class="contentboby">
            <div class="RightClickMenu" style="left: 10px;top: 36px;display:none;">
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
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
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
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
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
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
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
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
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
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
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
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
            <div class="contenttitle clear" style="position: fixed; border-bottom:1px solid #e8e8fa; left:0; top: 0; background: #fff; width: 100%;">
			<ul class="clear fl">
                <%if(!string.IsNullOrEmpty(addBtn)){
                        if (addBtn.Equals("新增合同")) {
                            %>
                <li id="ToolsButton"><i style="background-image: url(../Images/new.png);"></i><span style="margin:0;"><%=this.addBtn %></span><img src="../Images/dropdown.png" /></li>
                <%
                        }
                        else { 
                        %>
				<li onclick="Add()"><i style="background-image: url(../Images/new.png);"></i><span><%=this.addBtn %></span></li>
                <%}} %>
				<li><i style="background-image: url(../Images/print.png);"></i></li>
				<li onclick="javascript:window.open('ColumnSelector.aspx?type=<%=queryTypeId %>&group=<%=paraGroupId %>', 'ColumnSelect', 'left=200,top=200,width=820,height=470', false);"><i style="background-image: url(../Images/column-chooser.png);"></i></li>
				<li><i style="background-image: url(../Images/export.png);"></i></li>
			</ul>
            <%if (queryResult != null && queryResult.count>0)
                { %>
            <div class="page fl">
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
				<input type="text" style="width:30px;text-align:center;" value="<%=queryResult.page %>" />
                <span>&nbsp;/&nbsp;<%=queryResult.page_count %></span>
				<i onclick="ChangePage(<%=queryResult.page+1 %>)">></i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page_count %>)">>></i>
			</div>
            <%} %>
		</div>
        </div>        
        </form>
        <%if (queryResult != null) { %>

			<div class="searchcontent" id="searchcontent" style="margin-top: 56px;min-width:<%=tableWidth%>px;overflow:hidden;">
				<table border="" cellspacing="0" cellpadding="0"  style="overflow:scroll;width:100%;height:100%;">
					<tr>
                          <%if (!string.IsNullOrEmpty(isCheck))
                        { %>
                        <th style="padding-left: 4px;"><input id="CheckAll" type="checkbox"/></th>

                    <%} %>
                        <%foreach(var para in resultPara)
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
                        <th title="点击按此列排序" width="<%=para.length*16 %>px" onclick="ChangeOrder('<%=para.name %>')">
                            <%=para.name %>
                            <%if (orderby!=null && para.name.Equals(orderby))
                                { %><img src="../Images/sort-<%=order %>.png" /> 
                            <%} %></th>
                        <%} %>
					</tr>
                    <%
                        if (queryResult.count==0)
                        {
                            %>
                    <tr><td align="center" style="color:red;">选定的条件未查找到结果</td></tr>
                    <%
                        }
                        else
                        { 
                            var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                            foreach (var rslt in queryResult.result) {
                                string id = "0";
                                if (idPara != null)
                                    id = rslt[idPara.name].ToString();
                                %>
            
					    <tr onclick="View(<%=id %>)" title="右键显示操作菜单" data-val="<%=id %>" class="dn_tr">

                      <%if (!string.IsNullOrEmpty(isCheck))
                        { %>
                        <td><input type="checkbox" class="IsChecked" value="<%=id %>"/></td>

                    <%} %>
                            <%foreach (var para in resultPara) {
                                    if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                        continue;
                                    string tooltip = null;
                                    if (resultPara.Exists(_ => _.name.Equals(para.name + "tooltip")))
                                        tooltip = para.name + "tooltip";
                                    %>
                            <%if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.PIC) { %>
                            <td <%if (tooltip != null) { %>title="<%=rslt[tooltip] %>"<%} %> style="background:url(..<%=rslt[para.name] %>) no-repeat center;"></td>
                            <%} else { %>
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
        <%} %>
    
    <div id="menu">
        <%if (contextMenu.Count > 0) { %>
		<ul style="width:220px;">
            <%foreach (var menu in contextMenu) { %>
            <li id="<%=menu.id %>" onclick="<%=menu.click_function %>"><i class="menu-i1"></i><%=menu.text %>
                <%if (menu.submenu != null) { %>
                <i class="menu-i2">>></i>
                <ul id="menu-i2-right">
                    <%foreach (var submenu in menu.submenu) { %>
                    <li onclick="<%=submenu.click_function %>"><%=submenu.text %></li>
                    <%} %>
			    </ul>
            <%} %>
            </li>
            <%} %>
		</ul>
        <%} %>
	</div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        <% if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Company)
        { %>
        function EditCompany() {
            OpenWindow("../Company/EditCompany.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyEdit %>');
        }
        
        function ViewCompany() {
            OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + entityid, '_blank');
        }
        function Add() {
            OpenWindow("../Company/AddCompany.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>');
        }
        function DeleteCompany() {
            OpenWindow("../Company/DeleteCompany.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyDelete %>');
        }
        function View(id) {
            OpenWindow("../Company/ViewCompany.aspx?type=todo&id=" + id, '_blank');
        }
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Contact
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContactCompanyView) {
            %>
        function EditContact() {
            OpenWindow("../Contact/AddContact.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactEdit %>');
        }
        function ViewContact() {
            OpenWindow("../Contact/ViewContact.aspx?type=todo&id=" + entityid, '_blank');
        }
        function View(id) {
            OpenWindow("../Contact/ViewContact.aspx?type=todo&id=" + id, '_blank');
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
        <%if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Contact) { %>
        function Add() {
            OpenWindow("../Contact/AddContact.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>');
        }
        <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.ContactCompanyView) { %>
        function Add() {
            OpenWindow('../Contact/AddContact.aspx?account_id=<%=objId%>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>');
        }
        <%}%>
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Opportunity
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityCompanyView
            || queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityContactView) {
            %>
        function EditOpp() {
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
            window.open("../Quote/QuoteAddAndUpdate.aspx",'<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd %>' , 'left=0,top=0,location=no,status=no,width=750,height=750', false);
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
        <%if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Opportunity) { %>
        function Add() {
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityCompanyView) { %>
        function Add() {
            OpenWindow('../Opportunity/OpportunityAddAndEdit.aspx?oppo_account_id=<%=objId%>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%} else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.OpportunityContactView) { %>
        function Add() {
            OpenWindow("../Opportunity/OpportunityAddAndEdit.aspx?oppo_contact_id=<%=objId%>", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>');
        }
        <%}%>
        <%}
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Quote) {
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
        else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.QuoteTemplate) {
            %>
        function Add() {
            OpenWindow("../QuoteTemplate/QuoteTemplateAdd.aspx", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateAdd %>');
        }
        function Edit() {
            OpenWindow("../QuoteTemplate/QuoteTemplateEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.QuoteTemplateEdit %>');
        }
        <%
        }else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.InstalledProductView) {
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
                    ids += $(this).val()+',';
                }
            })
            if (ids != "") {
                ids = ids.substring(0, ids.length-1);
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
        // 失活配置项
        function NoActiveIProduct() {
            $.ajax({
                type: "GET",
                url: "../Tools/ProductAjax.ashx?act=NoActivationIP&iProduct_id=" + entityid,
                async: false,
                success: function (data) {
                    if (data == "ok") {
                        alert('失活成功');
                        history.go(0);
                    } else if (data == "no") {
                        alert('该报价项已经失活');
                    }
                    else {

                    }
                    
                }
            })
        }
        // 批量失活配置项
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
                            alert('批量失活成功！');
                        }
                        else if (data == "error") {
                            alert("批量失活失败！");
                        }
                        history.go(0);
                    }
                })
            }

        }
        // 删除配置项
        function DeleteIProduct() {
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
        <%}else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Subscription) {%>
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
                            alert('失活成功');
                            history.go(0);
                        } else if (data == "Already") {
                            alert('已经失活');
                        }
                        else {
                            alert("失活失败");
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
        <%}else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.SaleOrder){%>

        function Edit() {

        }
        function NewNote() {

        }
        function NewTodo() {

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
        <%}else if (queryTypeId == (long)EMT.DoneNOW.DTO.QueryType.Contract){%>
        function Add(type) {
            window.open("../Contract/ContractAdd.aspx?type=" + type, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
        function Edit() {
            window.open("../Contract/ContractEdit.aspx?id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContractEdit %>', 'left=0,top=0,location=no,status=no,width=900,height=950', false);
        }
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
        <%}%>
        function openopenopen() {
            //alert("暂未实现");
        }
    </script>
</body>
</html>
