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
<body>
    <form id="form1">
        <div id="search_list">
            <input type="hidden" name="page_num" <%if (queryResult != null) {%>value="<%=queryResult.page %>"<%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null) {%>value="<%=queryResult.query_id %>"<%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null) {%>value="<%=queryResult.order_by %>"<%} %> />
            <input type="hidden" id="show" name="show" value="<%=flag %>" />
            <input type="hidden" id="search_page" name="search_page" value="<%=queryPage %>" />
            <div id="conditions">
                <%foreach (var para in queryParaValue)
                    { %>
                <input type="hidden" name="<%=para.val %>" value="<%=para.show %>" />
                <%} %>
            </div>
        </div>
        <div class="contenttitle">
			<ul class="clear">
				<li><i style="background-image: url(../Images/new.png);"></i><span><%=this.addBtn %></span></li>
				<li><i style="background-image: url(../Images/new.png);"></i></li>
				<li><i style="background-image: url(../Images/new.png);"></i></li>
				<li><i style="background-image: url(../Images/new.png);"></i></li>
			</ul>
		</div>
        <%if (queryResult != null) { %>
			<div class="searchcontent" id="searchcontent">
				<table border="" cellspacing="" cellpadding="">
					<tr>
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
                        <th title="点击按此列排序" style="width:<%=para.length %>px;" onclick="ChangeOrder('<%=para.name %>')">
                            <%=para.name %>
                            <%if (orderby!=null && para.name.Equals(orderby))
                                { %><img src="../Images/sort-<%=order %>.png" /> 
                            <%} %></th>
                        <%} %>
						<th style="background:red url(../Images/data-selector.png) no-repeat center;display:none;"><!--客户类型--></th>
					</tr>
                    <%
                        var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);
                        foreach (var rslt in queryResult.result) {
                            string id = "0";
                            if (idPara != null)
                                id = rslt[idPara.name].ToString();
                            %>
					<tr title="右键显示操作菜单" data-val="<%=id %>" class="dn_tr">
                        <%foreach (var para in resultPara) { 
                                if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                    || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                    || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                    continue;
                                %>
						<td><%=rslt[para.name] %></td>
                        <%} %>
					</tr>
                    <%} %>
				</table>
			</div>
        <%} %>
    </form>
    <div id="menu">
		<ul>
            <%foreach (var menu in contextMenu) { %>
            <li onclick="<%=menu.click_function %>"><i class="menu-i1"></i><%=menu.text %>
                <%if (menu.submenu != null) { %>
                <i class="menu-i2">>></i>
                <ul>
                    <%foreach (var submenu in menu.submenu) { %>
                    <li onclick="<%=submenu.click_function %>"><%=submenu.text %></li>
                    <%} %>
			    </ul>
            <%} %>
            </li>
            <%} %>
		</ul>
	</div>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
        <% if (queryPage.Equals("客户查询")){ %>
        function EditCompany() {
            OpenWindow("../Company/EditCompany.aspx?id=" + entityid);
        }
        function ViewCompany() {
            OpenWindow("../Company/ViewCompany.aspx?id=" + entityid);
        }
        function AddCompany() {
            OpenWindow("../Company/AddCompany.aspx?id=" + entityid);
        }
        <%}%>
    </script>
</body>
</html>
