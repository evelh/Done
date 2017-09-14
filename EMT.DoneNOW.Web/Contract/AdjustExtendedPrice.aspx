<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdjustExtendedPrice.aspx.cs" Inherits="EMT.DoneNOW.Web.AdjustExtendedPrice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
       <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>合同价格调整</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">合同价格调整</span>
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
                           <label><%=name %></label>
                        </div>
                    </td>
                </tr>
                <tr style="display:none">
                    <td width="30%" class="FieldLabels">
                        Hours to Bill
                        <div>
                            <input type="text" style="width:220px;">
                        </div>
                    </td>
                </tr>
                <tr style="display:none">
                    <td width="30%" class="FieldLabels">
                        Hourly Rate
                        <div>
                            <input type="text" style="width:220px;">
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        调整后总价
                        <div>
                           <asp:TextBox ID="Extended_Price" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script>
            function save_deal() {
                var k = $("#Extended_Price").val();
                if (k == null || k == '') {
                    if (firm("您并未修改总价，点击“确定”，返回上一个页面。点击“取消”继续修改")) {
                        window.close();
                    } else {
                        return false;
                    }
                }
            }
            $("#Extended_Price").change(function () {
                if ((/^\d{1,15}\.?\d{0,2}$/.test(this.value)) == false)
                { alert('只能输入两位小数'); this.value = ''; this.focus(); return false; }
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
                $("#Extended_Price").val(s);
            });
        </script>
    </form>
</body>
</html>
