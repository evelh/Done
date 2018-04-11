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
    <style>

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
        color:black;
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
</style>
</head>
<body style="overflow-x:auto;overflow-y:auto;">
             <% if (currentQuery.page_name == "角色管理" || currentQuery.page_name == "部门管理" || currentQuery.page_name == "安全等级管理" || currentQuery.page_name == "里程碑状态管理" || currentQuery.page_name == "产品管理" || currentQuery.page_name == "配置项类型管理" || currentQuery.page_name == "撤销成本审批" || currentQuery.page_name == "撤销里程碑审批" || currentQuery.page_name == "撤销定期服务审批" || currentQuery.page_name == "撤销订阅审批" || currentQuery.page_name == "市场领域管理" || currentQuery.page_name == "客户地域管理" || currentQuery.page_name == "竞争对手管理" || currentQuery.page_name == "客户类别管理" || currentQuery.page_name == "姓名后缀管理" || currentQuery.page_name == "活动类型管理" || currentQuery.page_name == "商机阶段管理" || currentQuery.page_name == "商机来源管理" || currentQuery.page_name == "关闭商机原因管理" || currentQuery.page_name == "丢失商机原因管理"||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_LABOUR||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REVOKE_EXPENSE||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_BUNDLE||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_EXPORT_COMPANY||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_EXPORT_CONTACT||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CRM_INSPRO_DETAIL||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_SERVICEDESK_TICKETBYACCOUNT||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_CONTRACT_BILLED||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_PROJECT_PROJECT_LIST||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_OTHER_SYSTEM_LOGINLOG||catId==(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.REPORT_OTHER_SYSTEM_OPERLOG)
     { %>
        <%} else {%>
    <div class="header">
        <%if (currentQuery.page_query.Count == 1)
            { %>
        <%=currentQuery.page_name %>
       
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
	</div>   <%}%>
    <%--合同管理--审批--%>
             <% if (currentQuery.page_name == "审批并提交")
                 {%>
      <div class="TabBar" style="margin-top:5px;">
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_LABOUR)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_LABOUR %>" target="PageFrame" id="tab1">
                    <span class="Text">工时</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES %>" target="PageFrame" id="tab2">
                    <span class="Text">成本</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_EXPENSE)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_EXPENSE %>" target="PageFrame" id="tab3">
                    <span class="Text">费用</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS %>" target="PageFrame" id="tab4">
                    <span class="Text">订阅</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES %>" target="PageFrame" id="tab5">
                    <span class="Text">定期服务</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_MILESTONES)
                    { %> SelectedState<%} %>"  href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_MILESTONES %>" target="PageFrame" id="tab6">
                    <span class="Text">里程碑</span>
                </a>
            </div>
    <%} %>
      <%--合同管理--审批（结束）--%>
    <%--我的工单等 相关--%>
      <% if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET)
                 {%>
      <div class="TabBar" style="margin-top:5px;">
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET %>" target="PageFrame" id="MyTaskTicket">
                    <span class="Text">我的任务和工单</span>
                </a>
             <%--   <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_CHARGES %>" target="PageFrame" id="tab2">
                    <span class="Text">成本</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_EXPENSE)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_EXPENSE %>" target="PageFrame" id="tab3">
                    <span class="Text">费用</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_SUBSCRIPTIONS %>" target="PageFrame" id="tab4">
                    <span class="Text">订阅</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES)
                    { %>SelectedState <%} %>" href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_RECURRING_SERVICES %>" target="PageFrame" id="tab5">
                    <span class="Text">定期服务</span>
                </a>
                <a class="Button ButtonIcon <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_MILESTONES)
                    { %> SelectedState<%} %>"  href="../Common/SearchFrameSet.aspx?isCheck=1&cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.APPROVE_MILESTONES %>" target="PageFrame" id="tab6">
                    <span class="Text">里程碑</span>
                </a>--%>
            </div>
    <%} %>

    <%--结束--%>

    <div class="information clear" style="border:none;">
        <button class="Search" id="SearchBtn">搜索</button>
		<p class="informationTitle"> <i id="Icon"></i>搜索</p>
		<div class="content clear" style="min-width:1210px;">
			<table border="none" cellspacing="" cellpadding="" style="width: 395px;">
            <% for (int i = 0; i < condition.Count; i += 3) {%> 
				<tr>
					<td>
						<div <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK) { %> class="clear input-dh" <%} %>>
							<label><%=condition[i].description %></label>
                        <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.AREA
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER_EQUAL
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.UN_EQUAL)
                            { %>
							<input type="text" name="<%=condition[i].id %>" <%if (!string.IsNullOrEmpty(condition[i].defaultValue)){ %> value="<%=condition[i].defaultValue %>" <%} %> class="sl_cdt" />
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DROPDOWN) { %>
                            <select name="<%=condition[i].id %>" class="sl_cdt">
                                <%if (condition[i].is_not_null != 1)
                                    { %>
                                <option value=""></option>
                                <%} %>
                                <%foreach (var item in condition[i].values) {
                                      if (!string.IsNullOrEmpty(condition[i].defaultValue) && condition[i].defaultValue.Equals(item.val)) { %>
                              <option value="<%=item.val %>" selected="selected"><%=item.show %></option>
                              <%} else { 
                                        %>
								              <option value="<%=item.val %>"><%=item.show %></option>
                                <%}} %>
							</select>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER) {
                              string df1 = "", df2 = "";
                              if(!string.IsNullOrEmpty(condition[i].defaultValue))
                              {
                                var vals = condition[i].defaultValue.Split(',');
                                df1 = vals[0];
                                if (vals.Length > 1)
                                  df2 = vals[1];
                              }
                                %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" value="<%=df1 %>" class="sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" value="<%=df2 %>" class="sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATETIME
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.TIMESPAN) { 
                              string df1 = "", df2 = "";
                              if(!string.IsNullOrEmpty(condition[i].defaultValue))
                              {
                                var vals = condition[i].defaultValue.Split(',');
                                df1 = vals[0];
                                if (vals.Length > 1)
                                  df2 = vals[1];
                              }
                                %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="sl_cdt" value="<%=df1 %>" onclick="WdatePicker()"/>
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="sl_cdt" value="<%=df2 %>" onclick="WdatePicker()"/>
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
                        <%} else if(condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE_EQUAL){%>
							<input type="text" name="<%=condition[i].id %>" class="sl_cdt" value="<%=condition[i].defaultValue %>" onclick="WdatePicker()"/>
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
						<div <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK) { %> class="clear input-dh" <%} %>>
							<label><%=condition[i].description %></label>
                        <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.AREA
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER_EQUAL
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.UN_EQUAL)
                            { %>
							<input type="text" name="<%=condition[i].id %>" <%if (!string.IsNullOrEmpty(condition[i].defaultValue)){ %> value="<%=condition[i].defaultValue %>" <%} %> class="sl_cdt" />
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DROPDOWN) { %>
                            <select name="<%=condition[i].id %>" class="sl_cdt">
                                <%if (condition[i].is_not_null != 1)
                                    { %>
                                <option value=""></option>
                                <%} %>
                                <%foreach (var item in condition[i].values) {
                                      if (!string.IsNullOrEmpty(condition[i].defaultValue) && condition[i].defaultValue.Equals(item.val)) { %>
                              <option value="<%=item.val %>" selected="selected"><%=item.show %></option>
                              <%} else { 
                                        %>
								              <option value="<%=item.val %>"><%=item.show %></option>
                                <%}} %>
							</select>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER) { 
                              string df1 = "", df2 = "";
                              if(!string.IsNullOrEmpty(condition[i].defaultValue))
                              {
                                var vals = condition[i].defaultValue.Split(',');
                                df1 = vals[0];
                                if (vals.Length > 1)
                                  df2 = vals[1];
                              }
                                %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" value="<%=df1 %>" class="sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" value="<%=df2 %>" class="sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATETIME
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.TIMESPAN) { 
                              string df1 = "", df2 = "";
                              if(!string.IsNullOrEmpty(condition[i].defaultValue))
                              {
                                var vals = condition[i].defaultValue.Split(',');
                                df1 = vals[0];
                                if (vals.Length > 1)
                                  df2 = vals[1];
                              }
                                %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="sl_cdt" value="<%=df1 %>" onclick="WdatePicker()"/>
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="sl_cdt" value="<%=df2 %>" onclick="WdatePicker()"/>
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
                        <%} else if(condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE_EQUAL){%>
							<input type="text" name="<%=condition[i].id %>" class="sl_cdt" value="<%=condition[i].defaultValue %>" onclick="WdatePicker()"/>
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
						<div <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.CALLBACK) { %> class="clear input-dh" <%} %>>
							<label><%=condition[i].description %></label>
                        <%if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.SINGLE_LINE
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.AREA
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER_EQUAL
                            || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.UN_EQUAL)
                            { %>
							<input type="text" name="<%=condition[i].id %>" <%if (!string.IsNullOrEmpty(condition[i].defaultValue)){ %> value="<%=condition[i].defaultValue %>" <%} %> class="sl_cdt" />
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DROPDOWN) { %>
                            <select name="<%=condition[i].id %>" class="sl_cdt">
                                <%if (condition[i].is_not_null != 1)
                                    { %>
                                <option value=""></option>
                                <%} %>
                                <%foreach (var item in condition[i].values) {
                                      if (!string.IsNullOrEmpty(condition[i].defaultValue) && condition[i].defaultValue.Equals(item.val)) { %>
                              <option value="<%=item.val %>" selected="selected"><%=item.show %></option>
                              <%} else { 
                                        %>
								              <option value="<%=item.val %>"><%=item.show %></option>
                                <%}} %>
							</select>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.NUMBER) { 
                              string df1 = "", df2 = "";
                              if(!string.IsNullOrEmpty(condition[i].defaultValue))
                              {
                                var vals = condition[i].defaultValue.Split(',');
                                df1 = vals[0];
                                if (vals.Length > 1)
                                  df2 = vals[1];
                              }
                                %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" value="<%=df1 %>" class="sl_cdt" />
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" value="<%=df2 %>" class="sl_cdt" />
							</div>
                        <%} else if (condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATETIME
                                || condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.TIMESPAN) { 
                              string df1 = "", df2 = "";
                              if(!string.IsNullOrEmpty(condition[i].defaultValue))
                              {
                                var vals = condition[i].defaultValue.Split(',');
                                df1 = vals[0];
                                if (vals.Length > 1)
                                  df2 = vals[1];
                              }
                                %>
                            <div class="inputTwo">
								<input type="text" name="<%=condition[i].id %>_l" class="sl_cdt" value="<%=df1 %>" onclick="WdatePicker()"/>
								<span>-</span>
								<input type="text" name="<%=condition[i].id %>_h" class="sl_cdt" value="<%=df2 %>" onclick="WdatePicker()"/>
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
                        <%} else if(condition[i].data_type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_PARA_TYPE.DATE_EQUAL){%>
							<input type="text" name="<%=condition[i].id %>" class="sl_cdt" value="<%=condition[i].defaultValue %>" onclick="WdatePicker()"/>
                            <%}%>
						</div>
					</td>
				</tr>
            <% } %>
			</table>
            <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.TICKET_ACCOUNT_LIST)
                { %>
            <input name="1731" type="hidden" class="sl_cdt" value="<%=Request.QueryString["con1731"] %>" />
            <%} %>
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
        $.each($(".TabBar a"), function (i) {
            $(this).click(function () {
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
                $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
            })
        });
    </script>
</body>
</html>
<script>
    <%if (catId == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MY_TASK_TICKET)
    { %>
        if ($("select[name = '1793']").val() != undefined) {
            $("select[name = '1793']").val('<%=LoginUserId %>');
        }
    <%}%>
</script>
