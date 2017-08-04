<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SelectCallBack.aspx.cs" Inherits="EMT.DoneNOW.Web.SelectCallBack" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css"/>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
</head>
<body>
    <form id="form1">
        <div class="header">
			查找
		</div>
		<div class="findinput clear">
			<input type="text" name="" id="" value="" />
			<a href="javaScript:" class="search"></a>
		</div>
        <div id="search_list">
            <input type="hidden" name="page_num" <%if (queryResult != null) {%>value="<%=queryResult.page %>"<%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null) {%>value="<%=queryResult.query_id %>"<%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null) {%>value="<%=queryResult.order_by %>"<%} %> />
            <input type="hidden" id="type" name="type" value="<%=queryTypeId %>" />
            <input type="hidden" id="group" name="group" value="<%=paraGroupId %>" />
            <div id="conditions">
            </div>
        </div>
        <div class="content clear " style="padding: 10px;">
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
                            var rtnPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE);
                            foreach (var rslt in queryResult.result) {
                                string id = "";
                                string rtn = "";
                                if (idPara != null)
                                    id = rslt[idPara.name].ToString();
                                if (rtnPara != null)
                                    rtn = rslt[rtnPara.name].ToString();
                                %>
					    <tr class="dn_cbd" title="右键选择" data-val="<%=id %>" data-show="<%=rtn %>">
                            <%foreach (var para in resultPara) { 
                                    if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                                        || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                                        continue;
                                    %>
						    <td><%=rslt[para.name] %></td>
                            <%} // foreach
                                %>
					    </tr>
                        <%} // foreach
                    } // else
                        %>
				</table>
			</div>
        <%} %>
        </div>
    </form>
    <div id="menu">
		<ul>
            <li onclick="GetBack()">选择
            </li>
		</ul>
	</div>
    <script type="text/javascript">
        var entityid;
        var entityname;
        function GetBack() {
            window.opener.document.getElementById("<%=callBackField %>").value = entityname;
            window.opener.document.getElementById("<%=callBackField %>Hidden").value = entityid;
            <%if (!string.IsNullOrEmpty(callBackFunc)){ %>
            if (typeof (window.opener.<%=callBackFunc %>) != "undefined") {
                window.opener.<%=callBackFunc %>();
            }  
            <%}%>
            window.close();
        }
        Times = 0;
        $(".dn_cbd").bind("contextmenu", function (event) {
            clearInterval(Times);
            var oEvent = event;
            entityid = $(this).data("val");
            entityname = $(this).data("show");
            //自定义的菜单显示
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
            var Top = $(document).scrollTop() + oEvent.clientY
            var Left = $(document).scrollLeft() + oEvent.clientX
            menu.style.top = Top + "px";
            menu.style.left = Left + "px";
            return false;
        });

        $(".dn_cbd").bind("click", function (event) {
            entityid = $(this).data("val");
            entityname = $(this).data("show");
            GetBack();
        });

        function ChangeOrder(para) {
            var order = $("#order").val();
            var orderStr = order.split(" ");
            if (para == orderStr[0]) {
                if (orderStr[1] == "asc")
                    $("#order").val(para + " desc");
                else
                    $("#order").val(para + " asc");
            } else {
                $("#order").val(para + " asc");
            }
            $("#form1").submit();
        }
    </script>
</body>
</html>
