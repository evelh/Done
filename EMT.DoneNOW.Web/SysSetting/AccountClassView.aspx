<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountClassView.aspx.cs" Inherits="EMT.DoneNOW.Web.AccountClassView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
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
                <img src="../Images/move-left.png" style="margin-left: -3px;"/></button>
            <span class="text1">客户类别</span>
            <a href="###" class="collection"></a>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="AddButton" tabindex="0">
                <span class="Icon Add"></span>
                <span class="Text">新增</span>
            </li>
        </ul>
    </div>
    <div class="ScrollingContainer ContainsGrid Active" style="top: 82px; bottom: 0;">
        <div class="Grid Small">
            <div class="HeaderContainer">
                <table cellpadding="0">
                    <tbody>
                        <tr class="HeadingRow">
                            <td class="Interaction DragEnabled" style="width:58px;">
                                <div class="Standard"></div>
                            </td>
                            <td class="Context" style="width:23px;">
                                <div class="Standard"></div>
                            </td>
                            <td class="Image" style="width:27px;">
                                <div class="Standard">
                                    <div class="Classification ButtonIcon">
                                        <div class="Icon"></div>
                                    </div>
                                </div>
                            </td>
                            <td class="XL Text" style="width:190px;">
                                <div class="Standard">
                                    <div class="Heading">Name</div>
                                </div>
                            </td>
                            <td class="Text Dynamic" style="width:auto;">
                                <div class="Standard">
                                    <div class="Heading">Description</div>
                                </div>
                            </td>
                            <td class="Boolean" style="width:70px;">
                                <div class="Standard">
                                    <div class="Heading">Active</div>
                                </div>
                            </td>
                            <td class="Boolean" style="width:70px;">
                                <div class="Standard">
                                    <div class="Heading">System</div>
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
                            <td class="Interaction U0" style="width:59px;">
                                <div>
                                    <div class="Decoration Icon DragHandle prev">
                                        <img src="../Images/prev.png" />
                                    </div>
                                    <div class="Decoration Icon DragHandle next">
                                        <img src="../Images/next.png" />
                                    </div>
                                    <div class="Text Sort">1</div>
                                </div>
                            </td>
                            <td class="Context U1" style="width:25px;">
                                <a class="ButtonIcon Button ContextMenu NormalState">
                                    <div class="Icon">
                                        <img src="../Images/column-chooser.png" /></div>
                                </a>
                            </td>
                            <td class="Image U2" style="width:29px;">
                                <img src="../Images/Classification/blockhour.png" />
                            </td>
                            <td class="Text XL U3" style="width:192px;">
                                Bronze Managed Service
                            </td>
                            <td class="Text U4" style="width:auto;"></td>
                            <td  class="Boolean U5" style="width:72px;">
                                <div class="Decoration Icon CheckMark"></div>
                            </td>
                            <td  class="Boolean U6" style="width:72px;">
                                <div class="Decoration Icon"></div>
                            </td>
                        </tr>
                        <tr>
                            <td class="Interaction U0" style="width:59px;">
                                <div>
                                    <div class="Decoration Icon DragHandle prev">
                                        <img src="../Images/prev.png" />
                                    </div>
                                    <div class="Decoration Icon DragHandle next">
                                        <img src="../Images/next.png" />
                                    </div>
                                    <div class="Text Sort">2</div>
                                </div>
                            </td>
                            <td class="Context U1" style="width:25px;">
                                <a class="ButtonIcon Button ContextMenu NormalState">
                                    <div class="Icon">
                                        <img src="../Images/column-chooser.png" /></div>
                                </a>
                            </td>
                            <td class="Image U2" style="width:29px;">
                                <img src="../Images/Classification/delinquent.png" />
                            </td>
                            <td class="Text XL U3" style="width:192px;">
                                Bronze Managed Service
                            </td>
                            <td class="Text U4" style="width:auto;"></td>
                            <td  class="Boolean U5" style="width:72px;">
                                <div class="Decoration Icon CheckMark"></div>
                            </td>
                            <td  class="Boolean U6" style="width:72px;">
                                <div class="Decoration Icon CheckMark"></div>
                            </td>
                        </tr>
                        <tr>
                            <td class="Interaction U0" style="width:59px;">
                                <div>
                                    <div class="Decoration Icon DragHandle prev">
                                        <img src="../Images/prev.png" />
                                    </div>
                                    <div class="Decoration Icon DragHandle next">
                                        <img src="../Images/next.png" />
                                    </div>
                                    <div class="Text Sort">3</div>
                                </div>
                            </td>
                            <td class="Context U1" style="width:25px;">
                                <a class="ButtonIcon Button ContextMenu NormalState">
                                    <div class="Icon">
                                        <img src="../Images/column-chooser.png" /></div>
                                </a>
                            </td>
                            <td class="Image U2" style="width:29px;">
                                <img src="../Images/Classification/residential.png" />
                            </td>
                            <td class="Text XL U3" style="width:192px;">
                                Bronze Managed Service
                            </td>
                            <td class="Text U4" style="width:auto;"></td>
                            <td  class="Boolean U5" style="width:72px;">
                                <div class="Decoration Icon"></div>
                            </td>
                            <td  class="Boolean U6" style="width:72px;">
                                <div class="Decoration Icon CheckMark"></div>
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
                            <img src="../Images/edit.png" />
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
                            <img src="../Images/delete.png" />
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
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/ClassificationIcons.js"></script>
</body>
</html>
