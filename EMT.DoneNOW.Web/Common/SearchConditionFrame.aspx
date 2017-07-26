﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchConditionFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchConditionFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
	<link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/multiple-select.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <title></title>
</head>
<body>
    <div class="header">
		<i>
            <% foreach (var q in currentQuery.page_query)
                    {
                    %>
            <ul>
				<li onclick="<%=q.query_url %>"><%=q.query_name %></li>
			</ul>
            <%
                } %>
		</i>
		<%=currentQuery.page_name %>
	</div>
    <div class="information clear">
        <button class="Search" id="SearchBtn">搜索</button>
		<p class="informationTitle"> <i></i>搜索</p>
		<div class="content clear">
			<table border="none" cellspacing="" cellpadding="" style="width: 400px;">
            <% for (int i = 0; i < condition.Count; i += 3) {%> 
				<tr>
					<td>
						<div class="clear">
							<label><%=condition[i].description %></label>
                        <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.AREA)
                            { %>
							<input type="text" name="<%=condition[i].id %>" class="sl_cdt" />
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DROPDOWN) { %>
                            <select name="<%=condition[i].id %>" class="sl_cdt">
                                <option value=""></option>
                                <%foreach (var item in condition[i].values) { %>
								<option value="<%=item.val %>"><%=item.show %></option>
                                <%} %>
							</select>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER) { %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATETIME) { %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="form_datetime sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="form_datetime sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN) { %>
							<select id="cms" multiple="multiple">
                                <%foreach (var v in condition[i].values) { %>
                                <option value="<%=v.val %>"><%=v.show %></option>
                                <%} %>
				            </select>
                        <%}%>
						</div>
					</td>
				</tr>
            <% } %>
			</table>
            <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
            <% for (int i = 1; i < condition.Count; i += 3) {%> 
				<tr>
					<td>
                        <div class="clear">
							<label><%=condition[i].description %></label>
                        <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.AREA)
                            { %>
							<input type="text" name="<%=condition[i].id %>" class="sl_cdt" />
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DROPDOWN) { %>
                            <select name="<%=condition[i].id %>" class="sl_cdt">
                                <option value=""></option>
                                <%foreach (var item in condition[i].values) { %>
								<option value="<%=item.val %>"><%=item.show %></option>
                                <%} %>
							</select>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER) { %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATETIME) { %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="form_datetime sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="form_datetime sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN) { %>
                            <input type="hidden" id="cmsh<%=condition[i].id %>" name="<%=condition[i].id %>" class="sl_cdt" />
							<select id="cms<%=condition[i].id %>" multiple="multiple">
                                <%foreach (var v in condition[i].values) { %>
                                <option value="<%=v.val %>"><%=v.show %></option>
                                <%} %>
				            </select>
                            <script type="text/javascript">
                                $(function () {
                                    $('#cms<%=condition[i].id %>').change(function () {
                                        $('#cmsh<%=condition[i].id %>').val($(this).val());
                                    }).multipleSelect({
                                        width: '100%'
                                    });
                                });
                            </script>
                        <%}%>
						</div>
					</td>
				</tr>
            <% } %>
			</table>
            <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
            <% for (int i = 2; i < condition.Count; i += 3) {%> 
				<tr>
					<td>
                        <div class="clear">
							<label><%=condition[i].description %></label>
                        <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.AREA)
                            { %>
							<input type="text" name="<%=condition[i].id %>" class="sl_cdt" />
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DROPDOWN) { %>
                            <select name="<%=condition[i].id %>" class="sl_cdt">
                                <option value=""></option>
                                <%foreach (var item in condition[i].values) { %>
								<option value="<%=item.val %>"><%=item.show %></option>
                                <%} %>
							</select>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER) { %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATETIME) { %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="form_datetime sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="form_datetime sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN) { %>
							<select id="cms" multiple="multiple">
                                <%foreach (var v in condition[i].values) { %>
                                <option value="<%=v.val %>"><%=v.show %></option>
                                <%} %>
				            </select>
                        <%}%>
						</div>
					</td>
				</tr>
            <% } %>
			</table>
		</div>
	</div>
	<script src="../Scripts/bootstrap-datetimepicker.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../Scripts/bootstrap-datetimepicker.zh-CN.js" type="text/javascript" charset="utf-8"></script>
	<script src="../Scripts/index.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/multiple-select.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/SearchFrame.js" type="text/javascript" charset="utf-8"></script>
</body>
</html>
