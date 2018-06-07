<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QueueResourceManage.aspx.cs" Inherits="EMT.DoneNOW.Web.ServiceDesk.QueueResourceManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>队列员工</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %>队列员工</div>
        <div class="header-title">
            <ul>
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>保存并关闭</li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>关闭</li>
            </ul>
        </div>
        <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 100px;">
            <div class="content clear" id="GeneralDiv">
                <div class="information clear">
                    <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>员工<span class="red">*</span></label>
                                    <select id="resource_id" name="resource_id">
                                        <option></option>
                                        <% if (resList != null && resList.Count > 0)
                                            {
                                                resList = resList.Where(_ => _.is_active != 0).ToList();
                                                foreach (var res in resList)
                                                {  %>
                                        <option value="<%=res.id %>" <%if (resDep != null && resDep.resource_id == res.id)
                                            {%>
                                            selected="selected" <%} %>><%=res.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                         <tr>
                            <td>
                                <div class="clear">
                                    <label>角色<span class="red">*</span></label>
                                    <select id="role_id" name="role_id">
                                        <option></option>
                                        <% if (roleList != null && roleList.Count > 0)
                                            {
                                                foreach (var role in roleList)
                                                {  %>
                                        <option value="<%=role.id %>" <%if (resDep != null && resDep.role_id == role.id)
                                            {%>
                                            selected="selected" <%} %>><%=role.name %></option>
                                        <% }
                                            } %>
                                    </select>
                                </div>
                            </td>
                        </tr>
                         <tr>
                            <td>
                                <div class="clear">
                                    <label>主要负责人</label>
                                    <input type="checkbox" name="isLead" id="isLead" <%if ((resDep != null && resDep.is_lead == 1))
                                        {%>
                                        checked="checked" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>激活<span class="red"></span></label>
                                    <input type="checkbox" name="isActive" id="isActive" <%if (isAdd || (resDep != null && resDep.is_active == 1))
                                        {%>
                                        checked="checked" <%} %> />
                                </div>
                            </td>
                        </tr>

                    </table>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/common.js"></script>
<script>
    $("#SaveClose").click(function () {
        var resource_id = $("#resource_id").val();
        if (resource_id == "") {
            LayerMsg("请选择员工");
            return;
        }
        var role_id = $("#role_id").val();
        if (role_id == "") {
            LayerMsg("请选择角色");
            return;
        }
        var url = "../Tools/DepartmentAjax.ashx?act=ResourceManage&queId=<%=queue!=null?queue.id.ToString():"" %>&id=<%=resDep!=null?resDep.id.ToString():"" %>&resId=" + resource_id + "&roleId=" + role_id;
        if ($("#isLead").is(":checked")) {
            url += "&isLead=1";
        }
        if ($("#isActive").is(":checked")) {
            url += "&isActive=1";
        }
        $.ajax({
            type: "GET",
            url: url,
            dataType: "json",
            success: function (data) {
                if (data != "") {
                    if (data.result) {
                        LayerMsg("保存成功！");
                        setTimeout(function () { self.opener.location.href = "QueueManage?id=<%=queue!=null?queue.id.ToString():"" %>&type=res"; window.close(); }, 800);
                    }
                    else
                    {
                        LayerMsg("保存失败！"+data.reason);
                    }
                }
            }
        });
    })
</script>
