<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WorkgroupResource.aspx.cs" Inherits="EMT.DoneNOW.Web.Resource.WorkgroupResource" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %>工作组员工</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
          <div class="header"><%=isAdd?"新增":"编辑" %>工作组员工</div>
        <div class="header-title">
            <ul>
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i><asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click"   /></li>
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
                                    <label>员工名称<span class="red">*</span></label>
                                    <select id="resource_id" name="resource_id">
                                        <option></option>
                                        <% if (resList != null && resList.Count > 0)
                                            {
                                                foreach (var res in resList)
                                                {  %>
                                        <option value="<%=res.id %>" <%if (thisGroupRes != null && thisGroupRes.resource_id == res.id)
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
                                    <label>领导</label>
                                    <input type="checkbox" name="isLead" id="isLead" <%if ((thisGroupRes != null && thisGroupRes.is_leader == 1))
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
            return false;
        }
        return true;
    })
</script>
