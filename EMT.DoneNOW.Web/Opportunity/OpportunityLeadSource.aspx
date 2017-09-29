<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OpportunityLeadSource.aspx.cs" Inherits="EMT.DoneNOW.Web.OpportunityLeadSource" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
     <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>商机来源</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增商机来源</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
           <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <asp:Button ID="Save_New" OnClientClick="return save_deal()" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
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
                            <asp:TextBox ID="Name" runat="server" style="width:400px;"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        描述
                        <div>
                            <asp:TextBox ID="Description" runat="server" style="width:400px;height:80px;" TextMode="MultiLine"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        排序号
                        <div>
                            <asp:TextBox ID="Number" runat="server" style="width:400px;"></asp:TextBox>
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
            var n = $("#Name").val();
            if (n == null || n == '') {
                alert("请输入商机来源的名称！");
                return false;
            }
        }
        $("#Number").change(function () {
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
