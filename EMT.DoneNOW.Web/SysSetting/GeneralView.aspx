<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GeneralView.aspx.cs" Inherits="EMT.DoneNOW.Web.GeneralView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/ClassificationIcons.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <button style="width:26px;height:26px;cursor: pointer;">
                <img src="../Images/move-left.png" style="vertical-align: middle;"/></button>
            <span class="text1">
                <img src="../Images/add.png" />领地</span>
            <a href="###" class="collection"></a>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="AddButton" tabindex="0">
                <span class="Icon Add"></span>
                <span class="Text">新增领地</span>
            </li>
        </ul>
    </div>
    <div class="ScrollingContainer ContainsGrid Active" style="top: 82px; bottom: 0;margin: 0 10px;overflow: auto">
        <div class="Grid Small">
            <div class="HeaderContainer">
                <table cellpadding="0">
                    <tbody>
                        <tr class="HeadingRow">
                            <td class="XL Text" style="width:200px;">
                                <div class="Standard">
                                    <div class="Heading">Name</div>
                                </div>
                            </td>
                            <td class="Context" style="width:250px;">
                                <div class="Standard">Region</div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">Description</div>
                                </div>
                            </td>
                            <td style="width:6px;"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="RowContainer BodyContainer Active" style="top: 27px; bottom: 0px;">
                <table cellpadding="0">
                    <tbody>
                        <tr>
                            <td class="Text XL U3" style="width:201px;">
                                Bronze Managed Service
                            </td>
                            <td class="Context" style="width:252px;">
                                <div class="Standard">North America</div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td class="Text XL U3" style="width:201px;">
                                Bronze Managed Service
                            </td>
                            <td class="Context" style="width:252px;">
                                <div class="Standard">North America</div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading"></div>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="ContextOverlayContainer">
        <div class="RightClickMenu" style="left: 69px;top: 0px;width: 100px;display: none" id="RightClickMenu">
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                    <tbody>
                    <tr>
                        <td class="RightClickMenuItemIcon" align="center" valign="middle">
                            <img src="img/copy.png" alt="">
                        </td>
                        <td class="RightClickMenuItemText">
                            <span class="lblNormalClass">Edit</span>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                    <tbody>
                    <tr>
                        <td class="RightClickMenuItemIcon" align="center" valign="middle">
                        </td>
                        <td class="RightClickMenuItemText">
                            <span class="lblNormalClass">Inactive</span>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="RightClickMenuItem">
                <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse:collapse;">
                    <tbody>
                    <tr>
                        <td class="RightClickMenuItemIcon" align="center" valign="middle">
                            <img src="img/employees.png" alt="">
                        </td>
                        <td class="RightClickMenuItemText">
                            <span class="lblNormalClass">Delete</span>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
        </div>
   <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/ClassificationIcons.js"></script>
    </form>
</body>
</html>
