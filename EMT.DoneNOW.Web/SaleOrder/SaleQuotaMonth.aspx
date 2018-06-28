<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SaleQuotaMonth.aspx.cs" Inherits="EMT.DoneNOW.Web.SaleOrder.SaleQuotaMonth" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增":"编辑" %> 销售目标</title>
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style>
        td {
            text-align: left;
            padding-left: 30px;
        }

        .red {
            color: red;
        }

        select {
            width: 200px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"新增":"编辑" %> 销售目标</div>
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
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 800px; border: 0px;">
                        <tr>
                            <td>
                                <label>员工<span class="red"></span></label>
                                <div class="clear">
                                    <select id="resource_id" name="resource_id">
                                        <%if (resourceList != null && resourceList.Count > 0)
                                            {
                                                foreach (var resource in resourceList)
                                                {%>
                                        <option value="<%=resource.id %>" <%if (resQuota?.resource_id == resource.id)
                                            {%> selected="selected" <%} %>><%=resource.name %></option>
                                        <% }
                                            } %>
                                    </select>

                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>数量<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text" name="amount" id="amount" value="<%=resQuota?.amount!=null?((int)resQuota.amount).ToString():"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>专业服务目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text" name="opportunity_ext1" id="opportunity_ext1" value="<%=resQuota?.opportunity_ext1!=null?((decimal)resQuota.opportunity_ext1).ToString("#0.00"):"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>培训费用目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text" name="opportunity_ext2" id="opportunity_ext2" value="<%=resQuota?.opportunity_ext2!=null?((decimal)resQuota.opportunity_ext2).ToString("#0.00"):"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>硬件费用目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text" name="opportunity_ext3" id="opportunity_ext3" value="<%=resQuota?.opportunity_ext3!=null?((decimal)resQuota.opportunity_ext3).ToString("#0.00"):"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>月度使用费用目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text" name="opportunity_ext4" id="opportunity_ext4" value="<%=resQuota?.opportunity_ext4!=null?((decimal)resQuota.opportunity_ext4).ToString("#0.00"):"" %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>其他费用目标<span class="red"></span></label>
                                <div class="clear">
                                    <input type="text" name="opportunity_ext5" id="opportunity_ext5" value="<%=resQuota?.opportunity_ext5!=null?((decimal)resQuota.opportunity_ext5).ToString("#0.00"):"" %>" />
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
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script>

</script>
