﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OpportunityStage.aspx.cs" Inherits="EMT.DoneNOW.Web.OpportunityStage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>商机阶段</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1"><%if (id > 0)
                                    { %>修改商机阶段<%}
    else
    { %>新增商机阶段<%} %></span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
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
                    <td>
                        <div>
                            <asp:CheckBox ID="Won" runat="server" />
                            丢失商机默认阶段<asp:Label ID="won2" runat="server" Text=""  style="color:red"></asp:Label>
                        </div>
                        <div>
                           <asp:CheckBox ID="Lost" runat="server" />
                           关闭商机默认阶段<asp:Label ID="loss2" runat="server" Text="" style="color:red"></asp:Label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        排序号
                        <span class="errorSmall">*</span>
                        <div>
                            <asp:TextBox ID="Sort_Order" runat="server" style="width:200px;"></asp:TextBox>
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
            if ($("#Name").val() == null || $("#Name").val() == '')
            {
                alert("请输入商机阶段的名称！");
                return false;
            }
        }
        $("#Sort_Order").change(function () {
            if ((/^\d{1,3}\.?\d{0,2}$/.test(this.value)) == false)
            {
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
