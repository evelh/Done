<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContractMilestone.aspx.cs" Inherits="EMT.DoneNOW.Web.ContractMilestone" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
     <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>新增里程碑状态</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增里程碑状态</span>
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
                        名称
                        <span class="errorSmall">*</span>
                        <div>
                            <asp:TextBox ID="Name" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                     排序号
                        <div>
                            <asp:TextBox ID="SortOrder" runat="server"></asp:TextBox>
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
            </tbody>
        </table>
    </div>
</div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script src="../Scripts/SysSettingRoles.js"></script>
    <script>
        $("#Save_Close").click(function () {
            var t = $("#Market_Name").val();
            if (t == null || t == '') {
                alert("请填写里程碑状态名称");
                return false;
            }
        });
        $("#SortOrder").change(function () {
            if ((/^\d{1,15}$/.test(this.value)) == false)
            {
                alert('只能输入数值!');
                this.value = '';
                this.focus();
                return false;
            }
        });

        $("#SortOrder").change(function () {
            if ((/^\d{1,3}\.?\d{0,2}$/.test(this.value)) == false) {
                alert('请输入数字！');
                this.value = '';
                this.focus();
                return false;
            }
            var f = Math.round(this.value * 100) / 100;
            var s = f.toString();
            var rs = s.indexOf('.');
            if (rs < 0) {
                rs = s.length;
                s += '.';
            }
            while (s.length <= rs + 2) {
                s += '0';
            }
            if (s.length > 6) {
                alert('您输入的数字过大，只可以输入三位整数！');
                this.value = '';
                this.focus();
                return false;
            }
        });
    </script>

</body>
</html>
