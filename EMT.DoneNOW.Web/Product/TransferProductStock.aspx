<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransferProductStock.aspx.cs" Inherits="EMT.DoneNOW.Web.TransferProductStock" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
      <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">转移库存物品</span>
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
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td valign="top">
                                        Product Name
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;">Server</span>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;"></span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td valign="top">
                                        From Inventory Location
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;">beijing</span>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;"></span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td style="width:120px;">
                                        Quantity
                                        <span class="errorSmall">*</span>
                                        <div>
                                            <input type="text" style="width:95px;text-align: right;">
                                        </div>
                                    </td>
                                    <td valign="top">
                                        Available
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;">11</span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        To Inventory Location
                        <span class="errorSmall">*</span>
                        <div>
                            <select name="" id="" style="width:214px;">
                                <option value="">select</option>
                                <option value="">sdgvsdfsjd</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        Transfer Note
                        <div>
                            <textarea class="txtBlack8Class" style="height: 100px; width: 200px; margin-top: 0px; margin-bottom: 0px;"></textarea>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
        </div>
         <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/SysSettingRoles.js"></script>
        <script>
        $("#SaveAndCloseButton").on("mouseover",function(){
            $("#SaveAndCloseButton").css("background","#fff");
        });
        $("#SaveAndCloseButton").on("mouseout",function(){
            $("#SaveAndCloseButton").css("background","#f0f0f0");
        });
    </script>
    </form>
</body>
</html>
