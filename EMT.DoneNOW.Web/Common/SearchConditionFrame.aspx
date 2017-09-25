<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchConditionFrame.aspx.cs" Inherits="EMT.DoneNOW.Web.SearchConditionFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
	<link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/multiple-select.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <title></title>
</head>
<style>
    #SearchCondition{
        height: 100%;
    }
    #SearchCondition>html{
        height: 100%;
    }
</style>
<body style="overflow-x:auto;overflow-y:auto;">
 <% if (currentQuery.page_name == "角色管理" || currentQuery.page_name == "部门管理" || currentQuery.page_name == "联系人管理" || currentQuery.page_name == "安全等级管理" || currentQuery.page_name == "里程碑状态管理" || currentQuery.page_name == "产品管理" || currentQuery.page_name == "配置项类型管理" || currentQuery.page_name == "撤销成本审批" || currentQuery.page_name == "撤销里程碑审批" || currentQuery.page_name == "撤销定期服务审批" || currentQuery.page_name == "撤销订阅审批" || currentQuery.page_name == "市场领域管理" || currentQuery.page_name == "客户地域管理" || currentQuery.page_name == "竞争对手管理" || currentQuery.page_name == "客户类别管理" || currentQuery.page_name == "姓名后缀管理" || currentQuery.page_name == "活动类型管理" || currentQuery.page_name == "商机阶段管理" || currentQuery.page_name == "商机来源管理" || currentQuery.page_name == "关闭商机原因管理" || currentQuery.page_name == "丢失商机原因管理")
     {
           %>
        <%}
            else
            {%>
    <div class="header">
        <%if (currentQuery.page_name == "审批并提交")
            { %>
         <div class="TabBar">
                <a class="Button ButtonIcon" id="tab1">
                    <span class="Text">工时(未开发)</span>
                </a>
                <a class="Button ButtonIcon SelectedState" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES %>" target="PageFrame" id="tab2">
                    <span class="Text">成本</span>
                </a>
                <a class="Button ButtonIcon" id="tab3">
                    <span class="Text">费用(未开发)</span>
                </a>
                <a class="Button ButtonIcon" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS %>" target="PageFrame" id="tab4">
                    <span class="Text">订阅</span>
                </a>
                <a class="Button ButtonIcon" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES %>" target="PageFrame" id="tab5">
                    <span class="Text">定期服务</span>
                </a>
                <a class="Button ButtonIcon"  href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_MILESTONES %>" target="PageFrame" id="tab6">
                    <span class="Text">里程碑</span>
                </a>
            </div>
        <%}
            else
            { %>
		<i>
            <%if (currentQuery.page_query.Count > 4)
                { %>
            <ul class="parent">
            <% foreach (var q in currentQuery.page_query)
                {
                    if (q.typeId != 4 || q.groupId == 13)
                        continue;
                    %>
				<li onclick="OpenQuery(<%=catId %>,<%=q.typeId %>,<%=q.groupId %>);"><%=q.query_name %></li>
            <%
                } %>
                <li class="parent1">父客户查询</li>
            </ul>
            <ul class="child" style="margin-left: 140px;margin-top: -142px;display:none;">
            <% foreach (var q in currentQuery.page_query)
                {
                    if (q.typeId == 4 && q.groupId != 13)
                        continue;
                    %>
				<li onclick="OpenQuery(<%=catId %>,<%=q.typeId %>,<%=q.groupId %>);"><%=q.query_name %></li>
            <%
                } %>
            </ul>
            <%}
                else
                { %>
            <ul>
            <% foreach (var q in currentQuery.page_query)
                {
                    %>
				<li onclick="OpenQuery(<%=catId %>,<%=q.typeId %>,<%=q.groupId %>);"><%=q.query_name %></li>
            <%
                } %>
			</ul>
            <%} %>
		</i>
		<%=currentQuery.page_name %>
        <%} %>
	</div><%} %>
    <div class="information clear" style="border:none;">
        <button class="Search" id="SearchBtn">搜索</button>
		<p class="informationTitle"> <i id="Icon"></i>搜索</p>
		<div class="content clear" style="min-width:1210px;">
			<table border="none" cellspacing="" cellpadding="" style="width: 395px;">
            <% for (int i = 0; i < condition.Count; i += 3) {%> 
				<tr>
					<td>
						<div class=<%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK) { %>"clear input-dh"<%} %>>
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
            <table border="none" cellspacing="" cellpadding="" style="width:395px;">
            <% for (int i = 1; i < condition.Count; i += 3) {%> 
				<tr>
					<td>
						<div class=<%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK) { %>"clear input-dh"<%} %>>
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
            <table border="none" cellspacing="" cellpadding="" style="width: 395px;">
            <% for (int i = 2; i < condition.Count; i += 3) {%> 
				<tr>
					<td>
						<div class=<%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK) { %>"clear input-dh"<%} %>>
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
		</div>
	</div>
    <script src="../Scripts/jquery-3.1.0.min.js"  type="text/javascript" charset="utf-8"></script>
	<script src="../Scripts/index.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/multiple-select.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/SearchFrame.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
    <script type="text/javascript">
        var index = 0;
        var maxhgt = window.parent.document.getElementById("SearchFrameSet").rows;
        $("#Icon").on("click", function () {
            index++;
            if (index == 2) {
                window.parent.document.getElementById("SearchFrameSet").rows = maxhgt;
                $(".informationTitle").parent().css("background", "white");
                $(".information").children(".content").removeClass("hide");
                $("#Icon").removeClass("jia");
                index = 0;
            } else {
                $(".information").children(".content").addClass("hide");
                $("#Icon").addClass("jia");
                window.parent.document.getElementById("SearchFrameSet").rows = "92,*";
                $(".informationTitle").parent().css("background", "#efefef");
                index = 1;
            }
        })
        $(".header i").on("mouseover", function () {
            window.parent.document.getElementById("SearchFrameSet").rows = maxhgt;
            $("#Icon").removeClass("jia");
            $(".informationTitle").parent().css("background", "white");
            $(".information").children(".content").removeClass("hide");
        });

        $('.header i').on("mousemove", function () {
            $('.parent').show();
        });
        $('.header i').on("mouseout", function () {
            $('.parent').hide();
            $('.child').hide();
        });
        $('.parent1').on("mousemove", function () {
            $('.child').show();
        });
        $('.parent1').on("mouseout", function () {
            $('.child').hide();
        })
        $('.child').on("mousemove", function () {
            $('.parent').show();
            $('.child').show();
        });
        $('.child').on("mouseout", function () {
            $('.child').hide();
        });
    </script>
</body>
</html>
