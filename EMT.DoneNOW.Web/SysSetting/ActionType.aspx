<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ActionType.aspx.cs" Inherits="EMT.DoneNOW.Web.ActionType" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
     <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>活动类型</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">活动类型</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
   <div class="ButtonContainer header-title">
        <ul id="btn">
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                <asp:Button ID="Save_New" OnClientClick="return save_deal()" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <!--内容-->
    <div class="DivScrollingContainer General">
        <div class="DivSectionWithHeader">
            <div class="Content">
                <table width="100%">
                    <tbody>
                        <tr>
                            <td align="left" style="width: 120px">
                                <span class="lblNormalClass">名称</span>
                                <span class="errorSmallClass">*</span>
                                <div>
                                    <span style="display: inline-block">
                                        <asp:TextBox ID="Name" runat="server"></asp:TextBox>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="left">
                                <span class="lblNormalClass">显示</span>
                                <div>
                                    <span style="display: inline-block">
                                        <asp:DropDownList ID="View" runat="server"></asp:DropDownList>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div>
                                    <span class="FieldLabel">
                                        <span class="txtBlack8Class">
                                            <asp:CheckBox ID="Active" runat="server" />
                                            <label>激活</label>
                                        </span>
                                    </span>
                                </div>
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
    <script src="../Scripts/SysSettingRoles.js"></script>
    <script>
        function save_deal() {
            if ($("#Name").val() == null || $("#Name").val() == '') {
                alert("请填入名称！");
                return false;
            }
        }
    </script>
</body>
</html>
