<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ColumnSelector.aspx.cs" Inherits="EMT.DoneNOW.Web.ColumnSelector" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="../Content/base.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css"/>
    <link rel="stylesheet" type="text/css" href="../Content/style.css"/>
    <title></title>
</head>
<body>
    <div class="header">
		查询结果选择
	</div>
	<div class="header-title" style="height:40px;">
        <form id="form1" runat="server">
		    <ul>
			    <li onclick="clk()"><i style="background: url(../Images/save.png) -32px 0;"></i>保存并关闭</li>
			    <li onclick="javascript:window.close()"><i style="background: url(../Images/cancel.png) no-repeat -48px 0;"></i>取消</li>
		    </ul>
            <input type="hidden" id="ids" name="ids" />
            <%--<input type="hidden" name="type" value="<%=queryPage %>" />--%>
            <%if (queryTypeId == (int)EMT.DoneNOW.DTO.QueryType.MyWorkListTicket)
                { %>
            <input type="hidden" name="keep_running" id="isKeep" value=""/>
            <input type="hidden" name="auto_start" id="isStart" value=""/>
            <%} %>
        </form>
	</div>

    <div>
        <div class="rowtitle" style="width:800px;margin-left: 20px;">
			<div class="col-xs-5" style="padding-left: 30px;">可选择列</div>
			<div class="col-xs-1"></div>
			<div class="col-xs-5"style="padding-left: 30px;">已选择列</div>
			<div class="col-xs-1"></div>
		</div>
		<div class="row"  style="width:800px;margin-left: 20px;">
		    <div class="col-xs-5">
		        <select name="from[]" id="multiselect" class="form-control" size="8" style="height:320px;" multiple="multiple">
                    <%foreach (var c in allPara) {
                            if (selectedPara.Exists(_ => _.val.Equals(c.val)))  // 已选择列不显示
                                continue;
                            %>
                    <option value="<%=c.val %>"><%=c.show %></option>
                    <%
                        } %>
		        </select>
		    </div>
		    <div class="col-xs-1">
		        <button type="button"  class="btn btn-block" style="background: #fff;" disabled="disabled"><i class="glyphicon"></i></button>
		        <button type="button"  class="btn btn-block" style="background: #fff;" disabled="disabled"><i class="glyphicon"></i></button>
		        <button type="button" id="multiselect_rightAll" class="btn btn-block"><i class="glyphicon glyphicon-forward"></i></button>
		        <button type="button" id="multiselect_rightSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i></button>
		        <button type="button" id="multiselect_leftSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-left"></i></button>
		        <button type="button" id="multiselect_leftAll" class="btn btn-block"><i class="glyphicon glyphicon-backward"></i></button>
		    </div>
		    <div class="col-xs-5">
		        <select name="to[]" id="multiselect_to" class="form-control" size="8" style="height:320px;" multiple="multiple">
                    <%foreach (var c in selectedPara) {
                            %>
                    <option value="<%=c.val %>"><%=c.show %></option>
                    <%
                        } %>
		        </select>
		    </div>
		    <div class="col-xs-1">
		        <button type="button"  class="btn btn-block" style="background: #fff;" disabled="disabled"><i class="glyphicon"></i></button>
		        <button type="button"  class="btn btn-block" style="background: #fff;" disabled="disabled"><i class="glyphicon"></i></button>
		        <button type="button"  class="btn btn-block" style="background: #fff;" disabled="disabled"><i class="glyphicon"></i></button>
		        <button type="button" id="multiselect_move_up" class="btn btn-block"><i class="glyphicon glyphicon-arrow-up"></i></button>
		        <button type="button" id="multiselect_move_down" class="btn btn-block col-sm-6"><i class="glyphicon glyphicon-arrow-down"></i></button>
		        <button type="button"  class="btn btn-block" style="background: #fff;" disabled="disabled"><i class="glyphicon"></i></button>
		    </div>
		</div>
    </div>
    <%if (queryTypeId == (int)EMT.DoneNOW.DTO.QueryType.MyWorkListTicket)
        {
            var thisWorkSet = new EMT.DoneNOW.DAL.sys_work_list_dal().GetByResId(LoginUserId);
            %>
    <div>
        <p style="margin-left:35px;margin-top:10px;"><span><input type="checkbox" <%if (thisWorkSet != null && thisWorkSet.keep_running == 1)
                                                               { %> checked="checked" <%} %>  name="" id="keep_running"/></span><span>在将工单发送到我的工作列表时保持秒表运行（否则秒表将暂停)</span> </p>
        <p style="margin-left:35px;"><span><input type="checkbox" <%if (thisWorkSet != null && thisWorkSet.auto_start == 1)
                                                               { %> checked="checked" <%} %> name="" id="auto_start"/></span><span>从我的工作列表打开工单或工时自动启动（或取消暂停）秒表。</span> </p>
    </div>
    <%} %>
    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="../Scripts/bootstrap.min-3.3.4.js" type="text/javascript" charset="utf-8"></script>
	<script src="../Scripts/multiselect.min.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
		jQuery(document).ready(function($) {
		    $('#multiselect').multiselect({
		    	sort:false
		  	 });
        });

        function clk() {
            if ($("#multiselect_to option").length == 0) {
                alert("请至少选择一列");
                return;
            }
            <%if (queryTypeId == (int)EMT.DoneNOW.DTO.QueryType.MyWorkListTicket || queryTypeId == (int)EMT.DoneNOW.DTO.QueryType.MyWorkListTask)
            { %>
            if ($("#multiselect_to option").length > 6) {
                alert("最多选择六列");
                return;
            }
            if ($("#keep_running").is(":checked")) {
                $("#isKeep").val("1");
            }
            else {
                $("#isKeep").val("");
            }
            if ($("#auto_start").is(":checked")) {
                $("#isStart").val("1");
            }
            else {
                $("#isStart").val("");
            }
            <%} %>
            var ids = "";
            $("#multiselect_to option").each(function () {
                ids += $(this).val() + ',';
            });
            ids = ids.substr(0, ids.length - 1);
            $("#ids").val(ids);
            $("#form1").submit();
        }
	</script>
</body>
</html>
