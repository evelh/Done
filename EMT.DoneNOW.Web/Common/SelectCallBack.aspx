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
        <%if (isMuilt) { %>
        <div class="header-title">
			<ul>
				<li onclick="SaveSelect(0);"><i style="background: url(../Images/save.png)" class="icon-1"></i>保存</li>
				<li onclick="ClearSelect();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -304px -16px;" class="icon-1"></i>清除选择</li>
			</ul>
		</div>
		<div class="searchSelected clear">
			<p>选中的内容</p>
			<div class="Selected fl">
				<select  name="" multiple="" class="dblselect"></select>
			</div>
			<div class="findinput clear fr" style="margin: 0;">
				<input type="text" name="" id="" value="" style="height: 28px;line-height: 28px;"/>
				<a href="javaScript:" class="search" style="height: 28px;"></a>
			</div>
		</div>
        <%} else { %>
        <div class="header-title">
			<ul>
				<li onclick="ClearSelect();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -304px -16px;" class="icon-1"></i>清除选择</li>
			</ul>
		</div>
        <%}%>
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
                        <th title="点击按此列排序" style="width:<%=para.length %>px;">
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
            <%if (isMuilt) { %>
            var isexist = false;
            $(".dblselect option").each(function () {
                var val = $(this).val();
                if (val == entityid)
                    isexist = true;
            });
            if (isexist)
                return;

            var content = '<' + 'option' + ' value' + '=' + '"' + entityid + '"' + '>' + entityname + '</' + 'option' + '>';
            $(".dblselect").append(content);
            $(".dblselect option").dblclick(function () {
                $(this).remove();
            });
            <%} else { %>
            window.opener.document.getElementById("<%=callBackField %>").value = entityname;
            window.opener.document.getElementById("<%=callBackField %>Hidden").value = entityid;
            <%if (!string.IsNullOrEmpty(callBackFunc)){ %>
            if (typeof (window.opener.<%=callBackFunc %>) != "undefined") {
                window.opener.<%=callBackFunc %>();
            }  
            <%}%>
            window.close();
            <%} %>
        }
        function ClearSelect() {
            <%if (isMuilt) { %>
            SaveSelect(1);
            <%} else { %>
            entityid = "";
            entityname = "";
            GetBack();
            <%} %>
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

        <%if (isMuilt) { %>
        $(".dblselect option").dblclick(function () {
            $(this).remove();
        });
        
        function SaveSelect(clr) {
            entityid = "";
            entityname = "";
            if (clr != 1) {
                $(".dblselect option").each(function () {
                    entityname += $(this).text() + ",";
                    entityid += $(this).val() + ",";
                });
            }
            if (entityid != "") {
                entityid = entityid.substr(0, entityid.length - 1);
                entityname = entityname.substr(0, entityname.length - 1);
            }
            window.opener.document.getElementById("<%=callBackField %>").value = entityname;
            window.opener.document.getElementById("<%=callBackField %>Hidden").value = entityid;
            <%if (!string.IsNullOrEmpty(callBackFunc)){ %>
            if (typeof (window.opener.<%=callBackFunc %>) != "undefined") {
                window.opener.<%=callBackFunc %>();
            }
            <%}%>
            window.close();
        }
        <%} %>
    </script>
</body>
</html>
