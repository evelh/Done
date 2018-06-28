<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SLAItemManage.aspx.cs" Inherits="EMT.DoneNOW.Web.SLA.SLAItemManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %> 服务等级条目</title>
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        input[type=radio]{
            width:15px;
            height:15px;
        }
        .txtFirstResponse{
            width:70px;
        }
        td{
            text-align:left;
        }
        select{
            width:200px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %> 服务等级条目</div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 110px;">
            <div class="information clear">
                <div style="padding-left:20px;">
                    <table border="none" cellspacing="" cellpadding="" style="width: 400px; border: 0px;">
                        <tr>
                            <td style="width: 50%;">
                                <label>优先级<span class="red"></span></label>
                                <div class="clear">

                                    <select id="priority_id" name="priority_id">
                                        <option value="">全部</option>
                                        <% if (priorityList != null && priorityList.Count > 0)
                                            {
                                                foreach (var priority in priorityList)
                                                {  %>
                                        <option value="<%=priority.id %>" <%if (slaItem?.priority_id == priority.id)
                                            {%>
                                            selected="selected" <%} %>><%=priority.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%;">
                                <label>工单类型<span class="red"></span></label>
                                <div class="clear">

                                    <select id="ticket_type_id" name="ticket_type_id">
                                        <option value="">全部</option>
                                        <% if (ticketTypeList != null && ticketTypeList.Count > 0)
                                            {
                                                foreach (var ticketType in ticketTypeList)
                                                {  %>
                                        <option value="<%=ticketType.id %>" <%if (slaItem?.ticket_type_id == ticketType.id)
                                            {%>
                                            selected="selected" <%} %>><%=ticketType.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%;">
                                <label>工单种类<span class="red"></span></label>
                                <div class="clear">

                                    <select id="ticket_cate_id" name="ticket_cate_id">
                                        <option value="">全部</option>
                                        <% if (ticketCateList != null && ticketCateList.Count > 0)
                                            {
                                                foreach (var ticketCate in ticketCateList)
                                                {  %>
                                        <option value="<%=ticketCate.id %>" <%if (slaItem?.ticket_cate_id == ticketCate.id)
                                            {%>
                                            selected="selected" <%} %>><%=ticketCate.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%;">
                                <label>问题类型<span class="red"></span></label>
                                <div class="clear">

                                    <select id="issue_type_id" name="issue_type_id">
                                        <option value="">全部</option>
                                        <% if (issueTypeList != null && issueTypeList.Count > 0)
                                            {
                                                foreach (var issueType in issueTypeList)
                                                {  %>
                                        <option value="<%=issueType.id %>" <%if (slaItem?.issue_type_id == issueType.id)
                                            {%>
                                            selected="selected" <%} %>><%=issueType.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%;">
                                <label>子问题类型<span class="red"></span></label>
                                <div class="clear">
                                    <select id="sub_issue_type_id" name="sub_issue_type_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>

                                <div class="clear">
                                    <label>激活<span class="red"></span></label>
                                    <input type="checkbox" style="margin-top: 3px;" name="isActive" id="isActive" <%if ((isAdd) || slaItem?.is_active == 1)
                                        {%>
                                         checked="checked" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 50%;">
                                <label>计时方法<span class="red"></span></label>
                                <div class="clear">
                                    <select id="sla_timeframe_id" name="sla_timeframe_id">
                                        <% if (timeframeList != null && timeframeList.Count > 0)
                                            {
                                                foreach (var timeframe in timeframeList)
                                                {  %>
                                        <option value="<%=timeframe.id %>" <%if (slaItem?.sla_timeframe_id == timeframe.id)
                                            {%>
                                            selected="selected" <%} %>><%=timeframe.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="information clear">
                <table border="none" cellspacing="" cellpadding="" style="border: 0px;">
                    <tr>
                        <td style="width:33%;">
                           <div style="padding-left:20px;">
                               <label>响应时间</label>
                               <table border="none" cellspacing="" cellpadding="" style="border: 0px;">
                                   <% if (targetTypeList != null && targetTypeList.Count > 0) {
                                           foreach (var targetType in targetTypeList)
                                           {%>
                                   <tr>
                                       <td><input type="radio" id="rd<%=targetType.id %>FirstResponse" name="firstResponse" class="rdFirstResponse" value="<%=targetType.id %>"/> <span><%=targetType.name %></span></td>
                                       <td><input type="text" disabled="disabled" class="txtFirstResponse" id="<%=targetType.id %>_firstResponse" name="<%=targetType.id %>_firstResponse_value"/></td>
                                   </tr>
                                          <% }
                                       } %>
                               </table>
                           </div>
                        </td>
                        <td> <div style="padding-left:20px;">
                               <label>解决方案提供时间</label>
                               <table border="none" cellspacing="" cellpadding="" style="border: 0px;">
                                   <% if (targetTypeList != null && targetTypeList.Count > 0) {
                                           foreach (var targetType in targetTypeList)
                                           {%>
                                   <tr>
                                       <td><input type="radio"  id="rd<%=targetType.id %>ResoluPlan" name="resoluPlan" class="rdResoluPlan" value="<%=targetType.id %>"/> <span><%=targetType.name %></span></td>
                                       <td><input type="text" disabled="disabled" class="txtResoluPlan" id="<%=targetType.id %>_resoluPlan" name="<%=targetType.id %>_resoluPlan_value"/></td>
                                   </tr>
                                          <% }
                                       } %>
                               </table>
                           </div></td>
                        <td><div style="padding-left:20px;">
                               <label>解决时间</label>
                               <table border="none" cellspacing="" cellpadding="" style="border: 0px;">
                                   <% if (targetTypeList != null && targetTypeList.Count > 0) {
                                           foreach (var targetType in targetTypeList)
                                           {%>
                                   <tr>
                                       <td><input type="radio"  id="rd<%=targetType.id %>Resolution" name="resolution" class="rdResolution" value="<%=targetType.id %>"/> <span><%=targetType.name %></span></td>
                                       <td><input type="text" disabled="disabled" class="txtResolution" id="<%=targetType.id %>_resolution" name="<%=targetType.id %>_resolution_value"/></td>
                                   </tr>
                                          <% }
                                       } %>
                               </table>
                           </div></td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>
    $(".rdFirstResponse").click(function () {
        $(".txtFirstResponse").prop("disabled", true);
        var thisValue = $(this).val();
        $("#" + thisValue + "_firstResponse").prop("disabled", false)
        
    })
    $(".rdResoluPlan").click(function () {
        $(".txtResoluPlan").prop("disabled", true);
        var thisValue = $(this).val();
        $("#" + thisValue + "_resoluPlan").prop("disabled", false)

    })
    $(".rdResolution").click(function () {
        $(".txtResolution").prop("disabled", true);
        var thisValue = $(this).val();
        $("#" + thisValue + "_resolution").prop("disabled", false)

    })

    $(function () {
        $(".rdFirstResponse").eq(0).trigger("click");
        $(".rdResoluPlan").eq(0).trigger("click");
        $(".rdResolution").eq(0).trigger("click");

        <%if (!isAdd) {%>
        <%if (slaItem.issue_type_id != null) {%>  $("#issue_type_id").trigger("change"); <% } %>
        <%if (slaItem.sub_issue_type_id != null) {%>  $("#sub_issue_type_id").val('<%=slaItem.sub_issue_type_id %>'); <% } %>
        $("#rd<%=slaItem.first_response_target_type_id %>FirstResponse").trigger("click");
        $("#<%=slaItem.first_response_target_type_id %>_firstResponse").val('<%=slaItem.first_response_target_hours %>');

        $("#rd<%=slaItem.resolution_plan_target_type_id %>ResoluPlan").trigger("click");
        $("#<%=slaItem.resolution_plan_target_type_id %>_resoluPlan").val('<%=slaItem.resolution_plan_target_hours %>');

        $("#rd<%=slaItem.resolution_target_type_id %>Resolution").trigger("click");
        $("#<%=slaItem.resolution_target_type_id %>_resolution").val('<%=slaItem.resolution_target_hours %>');
    <%} %>

    })


    $("#issue_type_id").change(function () {
        GetSubIssueType();
    })

    // 根据 问题类型，返回相应的子问题类型
    function GetSubIssueType() {
        var subIssTypeHtml = "<option value=''>全部</option>";
        var issue_type_id = $("#issue_type_id").val();
        if (issue_type_id != "" && issue_type_id != null && issue_type_id != undefined) {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/GeneralAjax.ashx?act=GetGeneralByParentId&parent_id=" + issue_type_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            subIssTypeHtml += "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
                        }
                    }
                },
            });
        }
        $("#sub_issue_type_id").html(subIssTypeHtml);
    }
</script>
