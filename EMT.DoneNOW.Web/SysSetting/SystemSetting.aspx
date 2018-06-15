<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SystemSetting.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SystemSetting" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/SystemSet.css" rel="stylesheet" />
    <style>
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="ButtonContainer header-title">
            <ul id="btn">
                <li id="SaveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" />

                </li>
                <li onclick="javascript:window.close();"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    取消
                </li>
                <li>展开全部</li>
                <li>折叠全部</li>
            </ul>
        </div>
        <div>
            <table class="unScrollControl GridBottomBorder" id="CollapsableList_divdata">

                <tr class="dataGridHeader" style="background-color: rgb(241, 242, 231);">
                    <td>Setting Name</td>
                    <td style="width: 360px;">Setting Value</td>
                </tr>

                <% if (setDic != null && setDic.Count > 0) {
                        foreach (var thisDic in setDic)
                        {
                            var thisMoudle = moduleList?.FirstOrDefault(_=>_.id==thisDic.Key);
                            if (thisMoudle != null)
                            {%>
                <tr><td><%=thisMoudle.name %></td><td></td></tr>
                <%
                                if (thisDic.Value != null && thisDic.Value.Count > 0)
                                {
                                    foreach (var thisSet in thisDic.Value)
                                    {
                                        %>
                 <tr><td><%=thisSet.setting_name %></td><td><%=thisSet.setting_value %></td></tr>
                                   <% }
                                }

                            }
                        }
                    } %>
            </table>
        </div>
    </form>
</body>
</html>
