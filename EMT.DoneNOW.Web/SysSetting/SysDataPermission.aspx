<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysDataPermission.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SysDataPermission" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>受保护的数据的权限</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <div class="TitleBarNavigationButton">
                <a class="buttons" href="##"><img src="img/move-left.png" alt=""></a>
            </div>
            <span class="text2">受保护的数据的权限</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul>
            <li class="Button ButtonIcon NormalState" id="SaveButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text">保存</span>
            </li>

            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <!--搜索内容-->
    <div class="GridContainer ">
        <div style="width: 100%; overflow: auto; height: 827px; z-index: 0;">
            <table class="dataGridBody" style="width:100%;border-collapse:collapse;">
                <tbody>
                    <tr class="dataGridHeader">
                        <td>
                            <a style="font-weight:bold;">Resource Name</a>
                        </td>
                        <td align="center">Edit Protected Data</td>
                        <td align="center">View Protected Data</td>
                        <td align="center">Edit Unprotected Data</td>
                        <td align="center">View Unprotected Data</td>
                    </tr>
                    <tr class="dataGridBody">
                        <td>
                            <span>Administrator, Autotask</span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                    </tr>
                    <tr class="dataGridBody">
                        <td>
                            <span>Li, Hong</span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                        <td align="center">
                            <span><input type="checkbox" style="vertical-align:middle;"></span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
        </div>
    </form>
     <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
</body>
</html>
