<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchBodyFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchBodyFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
	<link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css"/>
    <title></title>
</head>
<body>
    <form id="form1">
        <div id="search_list">
            <input type="hidden" name="search_page" <%if (queryResult != null) {%>value="<%=queryResult.page %>"<%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null) {%>value="<%=queryResult.query_id %>"<%} %> />
            <input type="hidden" name="order" <%if (queryResult != null) {%>value="<%=queryResult.order_by %>"<%} %> />
            <div id="conditions"></div>
        </div>
        <div class="contenttitle">
				<ul class="clear">
					<li><i style="background-image: url(Images/new.png);"></i><span><%=this.addBtn %></span></li>
					<li><i style="background-image: url(Images/new.png);"></i></li>
					<li><i style="background-image: url(Images/new.png);"></i></li>
					<li><i style="background-image: url(Images/new.png);"></i></li>
				</ul>
			</div>
        <%if (queryResult != null) { %>
			<div class="searchcontent" id="searchcontent">
				<table border="" cellspacing="" cellpadding="">
					<tr>
                        <%foreach(var para in resultPara) { %>
                        <th title="点击按此列排序" onclick="ChangeOrder(<%=para.name %>)"><%=para.name %></th>
                        <%} %>
						<th style="background:red url(Images/data-selector.png) no-repeat center;display:none;">11</th>
					</tr>
                    <%foreach (var rslt in queryResult.result) { %>
					<tr title="右键显示操作菜单" onclick="OpenNewWindow(<%=rslt["id"] %>)">
                        <%foreach (var para in resultPara) { %>
						<td><%=rslt[para.name] %></td>
                        <%} %>
					</tr>
                    <%} %>
				</table>
			</div>
        <%} %>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/SearchBody.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>
