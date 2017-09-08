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
                            Configuration Item Type Name
                            <span class="errorSmall">*</span>
                            <div style="padding-bottom: 10px;">
                                <input type="text" style="width:268px;">
                                <input type="checkbox">
                                <span class="lblNormalClass" style="font-weight: normal;">Active</span>
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
                                <span style="font-weight: bold;">Configuration Item User-Defined Fields</span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="width: 100%; margin-bottom: 10px;">
            <div class="ButtonContainer">
                <ul>
                    <li class="Button ButtonIcon NormalState" id="NewButton" tabindex="0">
                        <span class="Icon New"></span>
                        <span class="Text">新建</span>
                    </li>
                </ul>
            </div>
            <div class="GridContainer" style="height: auto;">
                <div style="width: 100%; overflow: auto; z-index: 0;height:700px;">
                    <table class="dataGridBody" cellspacing="0" style="width:100%;border-collapse:collapse;">
                        <tbody>
                            <tr class="dataGridHeader" style="height: 28px;">
                                <td align="center" style="width: 27px;"></td>
                                <td style="width: auto;">
                                    <span>Name</span>
                                </td>
                                <td align="center" style="width:57px;">
                                    <span>Required</span>
                                </td>
                                <td align="center" style="width:57px;">
                                    <span>Protected </span>
                                </td>
                                <td align="right">
                                    <span>
                                        Sort Order
                                    </span>
                                </td>
                            </tr>
                            <tr class="dataGridBody">
                                <td align="center">
                                    <img src="img/edit.png" alt="">
                                </td>
                                <td style="width: auto;">
                                    <span>Battery Life</span>
                                </td>
                                <td align="center">
                                    <img src="img/check.png" alt="">
                                </td>
                                <td align="center">

                                </td>
                                <td align="right">
                                    <span></span>
                                </td>
                            </tr>
                            <tr class="dataGridBody">
                                <td align="center">
                                    <img src="img/edit.png" alt="">
                                </td>
                                <td style="width: auto;">
                                    <span>Brand</span>
                                </td>
                                <td align="center">
                                    <img src="img/check.png" alt="">
                                </td>
                                <td align="center">
                                    <img src="img/check.png" alt="">
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
