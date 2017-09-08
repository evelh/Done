<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfigType.aspx.cs" Inherits="EMT.DoneNOW.Web.ConfigType" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
      <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>配置项类型</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">配置项类型</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul id="btn">
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <!--切换项-->
    <div class="TabContainer" style="min-width: 700px;">
        <div class="DivSection" style="border:none;padding-left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="50%" class="FieldLabels">
                           配置项类型名称
                            <span class="errorSmall">*</span>
                            <div style="padding-bottom: 10px;">
                                <asp:TextBox ID="Config_name" runat="server" style="width:268px;"></asp:TextBox>
                                <asp:CheckBox ID="Active" runat="server" />
                                <span class="lblNormalClass" style="font-weight: normal;">激活</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            <div style="padding-bottom: 10px;">
                                <span>Select the user-defined fields used by this Configuration Item Type:</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            <div style="padding-bottom: 10px;">
                                <span style="font-weight: bold;">用户自定义字段</span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="width: 100%; margin-bottom: 10px;">
            <div class="ButtonContainer header-title">
                <ul>
                   <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                        <span class="Text">新建</span>
                    </li>
                </ul>
            </div>
            <div class="GridContainer" style="height: auto;">
                <div style="width: 100%; overflow: hidden; position: absolute; z-index: 99; height: 40px;">
                    <table class="dataGridHeader" style="width:100%;border-collapse:collapse;">
                        <tbody>
                           <tr class="dataGridHeader" style="height: 8px;">
                                <td align="center" style="width:17px;"></td>
                                <td style="width: 27px;">
                                    <span></span>
                                </td>
                                <td style="width:200px;">
                                    <span>自定义字段名称</span>
                                </td>
                                <td align="center" style="width:57px;">
                                    <span>必填</span>
                                </td>
                                <td align="center" style="width:57px;">
                                    <span>保护 </span>
                                </td>
                                <td align="right" style="width:100px;">
                                    <span>
                                        排序号
                                    </span>
                                </td>
                               <td style="width:9.5px;visibility:hidden;">
                               </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div style="width: 100%; overflow: auto; z-index: 0;height:700px;">
                    <table class="dataGridBody" cellspacing="0" style="width:100%;border-collapse:collapse;">
                        <tbody>                            
                           <tr class="dataGridHeader" style="height: 8px;">
                                <td align="center" style="width:17px;"></td>
                                <td style="width: 27px;">
                                    <span></span>
                                </td>
                                <td style="width:200px;">
                                    <span>自定义字段名称</span>
                                </td>
                                <td align="center" style="width:57px;">
                                    <span>必填</span>
                                </td>
                                <td align="center" style="width:57px;">
                                    <span>保护 </span>
                                </td>
                                <td align="right" style="width:100px;">
                                    <span>
                                        排序号
                                    </span>
                                </td>
                            </tr>
                            <%foreach (var tr in GetAlludf)
                                { %>
                            <tr class="dataGridBody">
                                <td align="center">
                                    <img src="../Images/edit.png" />
                                </td>
                                <td style="text-align:center"><input type="checkbox" /></td>
                                <td style="width: auto;">
                                    <span><%=tr.col_comment %></span>
                                </td>
                                <td align="center">
                                    <%if (tr.is_required > 0)
                                        { %>
                                    <img src="../Images/check.png" />
                                    <%} %>
                                </td>
                                <td align="center">
                                    <%if (tr.is_protected > 0)
                                        { %>
                                    <img src="../Images/check.png" />
                                    <%} %>
                                </td>
                                <td align="right">
                                    <span><%=tr.sort_order %></span>
                                </td>
                            </tr>
                            <%} %>

                            <tr class="dataGridBody">
                                <td align="center">
                                   <img src="../Images/edit.png" />
                                </td>
                                <td style="text-align:center"><input type="checkbox" /></td>
                                <td style="width: auto;">
                                    <span>Brand</span>
                                </td>
                                <td align="center">
                                    <img src="../Images/check.png" />
                                </td>
                                <td align="center">
                                   <img src="../Images/check.png" />
                                </td>
                                <td align="right">
                                    <span>sgg</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
        </div>
    </form>
</body>
</html>
