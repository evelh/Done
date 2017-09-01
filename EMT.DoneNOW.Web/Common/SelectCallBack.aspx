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
    <form id="form1" runat="server" class="clear" style="min-width:600px;">
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
		<div class="searchSelected clear fl" style="margin-left:10px;">
			<p>选中的内容</p>
			<div class="Selected fl">
				<select  name="" multiple="" class="dblselect" style="width:160px;min-height:131px;"></select>
			</div>
		</div>
        <%} else { %>
        <div class="header-title fl">
			<ul>
				<li onclick="ClearSelect();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -304px -16px;" class="icon-1"></i>清除选择</li>
			</ul>
		</div>
        <%}%>
        <table border="none" cellspacing="" cellpadding="" style="width:350px;margin:15px 0 0 5px;border: none;" class="fl">
        <% for (int i = 0; i < condition.Count; i++) {%> 
			<tr>
				<td>
					<div style="margin:5px 0;" class=<%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK) { %>"clear input-dh"<%}
                        else { %>"clear"<%} %>>
						<label><%=condition[i].description %></label>
                    <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                        || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.AREA
                        || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER_EQUAL)
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
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATETIME
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.TIMESPAN) { %>
                        <div class="inputTwo">
							<input type="text" name="<%=condition[i].id %>_l" class="sl_cdt" onclick="WdatePicker()"/>
							<span>-</span>
							<input type="text" name="<%=condition[i].id %>_h" class="sl_cdt" onclick="WdatePicker()"/>
						</div>
                    <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MUILT_CALLBACK) { %>
                        <input type="text" id="con<%=condition[i].id %>" disabled="disabled" />
                        <input type="hidden" id="con<%=condition[i].id %>Hidden" name="<%=condition[i].id %>" class="sl_cdt" />
                        <span class="on" onclick="window.open('<%=condition[i].ref_url %>con<%=condition[i].id %>','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false)"><i class="icon-dh"></i></span>
                    <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.MULTI_DROPDOWN) { %>
                        <input type="hidden" id="cmsh<%=condition[i].id %>" name="<%=condition[i].id %>" class="sl_cdt" />
                        <div class="multiplebox">
							<select id="cms<%=condition[i].id %>" multiple="multiple">
                                <%foreach (var v in condition[i].values) { %>
                                <option value="<%=v.val %>"><%=v.show %></option>
                                <%} %>
				            </select>
                        </div>
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
        <asp:Button ID="Search" runat="server" Text="搜索" OnClick="Search_Click" style="margin-top: 22px;width: 56px;height: 30px;"/>
        <div id="search_list">
            <input type="hidden" id="page_num" name="page_num" <%if (queryResult != null) {%>value="<%=queryResult.page %>"<%} %> />
            <input type="hidden" id="page_size" name="page_size" <%if (queryResult != null) {%>value="<%=queryResult.page_size %>"<%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null) {%>value="<%=queryResult.query_id %>"<%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null) {%>value="<%=queryResult.order_by %>"<%} %> />
            <input type="hidden" id="type" name="type" value="<%=queryTypeId %>" />
            <input type="hidden" id="group" name="group" value="<%=paraGroupId %>" />
            <div id="conditions">
            </div>
        </div>

        <!-- 分页信息 -->
        <%if (queryResult != null && queryResult.count>0)
            { %>
        <div class="page clear" style="float:none;margin:108px 0 0 90px;">
            <%
                                int indexFrom = queryResult.page_size * (queryResult.page - 1) + 1;
                                int indexTo = queryResult.page_size * queryResult.page;
                                if (indexFrom > queryResult.count)
                                    indexFrom = queryResult.count;
                                if (indexTo > queryResult.count)
                                    indexTo = queryResult.count;
                %>
			<span class="fl">第<%=indexFrom %>-<%=indexTo %>&nbsp;&nbsp;总数&nbsp;<%=queryResult.count %></span>
			<span class="fl">每页<%if (queryResult.page_size == 20)
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
			<i class="fl" onclick="ChangePage(1)"><<</i>&nbsp;&nbsp;<i class="fl" onclick="ChangePage(<%=queryResult.page-1 %>)"><</i>
			<input class="fl" type="text" style="width:24px;height:22px;text-align:center;" value="<%=queryResult.page %>" />
            <span class="fl">&nbsp;/&nbsp;<%=queryResult.page_count %></span>
			<i class="fl" onclick="ChangePage(<%=queryResult.page+1 %>)">></i>&nbsp;&nbsp;<i class="fl" onclick="ChangePage(<%=queryResult.page_count %>)">>></i>
		</div>
        <%} %>
        <!-- 分页信息 -->

        <div class="content clear " style="padding: 10px;">
        <%if (queryResult != null) { %>
			<div class="searchcontent" id="searchcontent" style="min-width:580px;width:580px;">
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
                        <th title="点击按此列排序" style="width:<%=para.length*16 %>px;">
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
    <script type="text/javascript">
        function ChangePageSize(num) {
            $("#page_size").val(num);
            $("#form1").submit();
        }
        function ChangePage(num) {
            $("#page_num").val(num);
            $("#form1").submit();
        }
    </script>
</body>
</html>
