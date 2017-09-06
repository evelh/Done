<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountClass.aspx.cs" Inherits="EMT.DoneNOW.Web.AccountClass" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>客户类别</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增客户类别</span>
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
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                       名称
                        <span class="errorSmall">*</span>
                        <div>
                            <asp:TextBox ID="Name" runat="server" style="width:306px"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <div>
                            <asp:CheckBox ID="Active" runat="server" />
                           激活
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        图标<span class="errorSmall">*</span>(PNG, JPG, GIF supported. Maximum dimension: 128px.)
                        <div>
                             <img id="imgshow" src="<%=avatarPath %>"  style="width:50px;height:50px;"/>
                        <a href="#" style="display: inline-block; width: 100px; height: 24px; position: relative; overflow: hidden;">点击修改图标
                            <input type="file" value="浏览" id="browsefile" name="browsefile" style="position: absolute; right: 0; top: 0; opacity: 0; filter: alpha(opacity=0);" />
                        </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        描述
                        <div>
                            <asp:TextBox ID="Description" runat="server" style="width:306px;height:100px;" TextMode="MultiLine"></asp:TextBox>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

        </div>
    </form>
      <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
    <script>
        function save_deal() {
            if ($("#Name").val() == null || $("#Name").val() == '') {
                alert("请填入客户分类名称！");
                return false;
            }
        }
    </script>
</body>
</html>
