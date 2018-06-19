<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PurchasingTeam.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.PurchasingTeam" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/multipleList.css" />
    <title>采购团队</title>

    <style>
        li {
            list-style: None;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">采购团队</div>
        <div class="header-title" style="width: 480px;">
            <ul>
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>取消</li>
            </ul>
        </div>
        <div id="contactSelectSection" style="padding: 5px">
            <span>
                <table id="_ctl1_ContainerTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                    <tbody>
                        <tr>
                            <td valign="middle" style="align: center;">
                                <table id="_ctl1_LeftListBoxTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span id="_ctl1_LeftListBoxLabel" class="lblNormalClass" style="font-weight: bold;">可用员工</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <select size="15" name="from[]" id="multiselect" class="form-control" multiple="multiple" style="height: 300px; width: 285px;">
                                                    <%if (resList != null && resList.Count > 0)
                                                        {
                                                            string[] idArr = dto.ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                                                            var pageResList = resList.Where(_ => !idArr.Contains(_.id.ToString())).ToList();
                                                            foreach (var thisRes in pageResList)
                                                            {%>
                                                    <option value="<%=thisRes.id %>"><%=thisRes.name %></option>
                                                    <%}
                                                        } %>
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td valign="middle" style="align: center; padding-left: 10px; padding-right: 10px;">
                                <table id="_ctl1_MiddleButtonTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <button type="button" id="multiselect_rightSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-right"></i></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div style="height: 20px;"></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <button type="button" id="multiselect_leftSelected" class="btn btn-block"><i class="glyphicon glyphicon-chevron-left"></i></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td valign="middle" style="align: center;">
                                <table id="_ctl1_RightListBoxTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                                    <tbody>
                                        <tr>
                                            <td><span id="_ctl1_RightListBoxLabel" class="lblNormalClass" style="font-weight: bold;">已选员工</span></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <select size="15" name="to[]" id="multiselect_to" class="form-control" multiple="multiple" style="height: 300px; width: 285px;">
                                                    <%if (resList != null && resList.Count > 0)
                                                        {
                                                            string[] idArr = dto.ids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                                                            var pageResList = resList.Where(_ => idArr.Contains(_.id.ToString())).ToList();
                                                            foreach (var thisRes in pageResList)
                                                            {%>
                                                    <option value="<%=thisRes.id %>"><%=thisRes.name %></option>
                                                    <%}
                                                        } %>
                                                </select></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <p>其他邮箱地址</p>
                                <input type="text" id="emails" name="emails" value="<%=dto.emails %>" style="width: 100%;" />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </span>
        </div>

    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/multiselect.min.js" type="text/javascript" charset="utf-8"></script>
<script>
    jQuery(document).ready(function ($) {
        $('#multiselect').multiselect({
            sort: false
        });
    });
</script>
