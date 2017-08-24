<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysTerritory.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.SysTerritory" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>新增地域</title>
    <style>
    hr.separator {
        color: #b2d0f2;
        height: 1px;
    }
    .qqq{
        line-height:30px;
    }
    .qqq img{
        vertical-align: middle;
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增地域</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text">保存并关闭</span>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <span class="Icon SaveAndNew"></span>
                <span class="Text">保存并新建</span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <!--切换按钮-->
    <div class="TabBar">
        <a class="Button ButtonIcon SelectedState">
            <span class="Text">总结</span>
        </a>
        <a class="Button ButtonIcon">
            <span class="Text">资源</span>
        </a>
    </div>
    <div class="TabContainer">
        <div class="DivSection" style="border:none;padding-left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            Name
                            <span class="errorSmall">*</span>
                            <div>
                                <input type="text" style="width:220px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            Region
                            <div>
                                <select style="width:234px;">
                                    <option value="">0</option>
                                    <option value="">1</option>
                                    <option value="">2</option>
                                    <option value="">3</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            Description
                            <div>
                                <input type="text" style="width:220px;">
                            </div>
                        </td>

                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="TabContainer" style="display: none;">
        <div class="DivSection" style="border:none;padding-left:0;">
            <div class="ButtonCollectionBase" style="height:25px;">
                <ul>
                    <li class="Button ButtonIcon NormalState" id="NewButton1" tabindex="0">
                        <span class="Icon New"></span>
                        <span class="Text">新建</span>
                    </li>
                </ul>
            </div>
            <table>
                <tbody>
                    <tr colspan="2">
                        <hr class="separator" style="border-left: none;">
                    </tr>
                    <tr class="qqq">
                        <td width="15" style="padding-left: 10px;">
                            <img src="img/delete.png" style="cursor: pointer;">
                        </td>
                        <td align="left" style="padding-top: 2px;padding-left: 10px;">Administrator, Autotask</td>
                    </tr>
                    <tr class="qqq">
                        <td width="15" style="padding-left: 10px;">
                            <img src="img/delete.png" style="cursor: pointer;">
                        </td>
                        <td align="left" style="padding-top: 2px;padding-left: 10px;">Administrator, Autotask</td>
                    </tr>
                    <tr class="qqq">
                        <td width="15" style="padding-left: 10px;">
                            <img src="img/delete.png" style="cursor: pointer;">
                        </td>
                        <td align="left" style="padding-top: 2px;padding-left: 10px;">Administrator, Autotask</td>
                    </tr>
                    <tr class="qqq">
                        <td width="15" style="padding-left: 10px;">
                            <img src="img/delete.png" style="cursor: pointer;">
                        </td>
                        <td align="left" style="padding-top: 2px;padding-left: 10px;">Administrator, Autotask</td>
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
