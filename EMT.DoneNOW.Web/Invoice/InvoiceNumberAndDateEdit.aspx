<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceNumberAndDateEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.InvoiceNumberAndDateEdit" %>

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
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">修改发票</span>
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
                       客户名称
                        <div>
                            <span><%=account %></span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        发票编号
                        <div>
                            <input id="InvoiceNumber" name="InvoiceNumber" value="<%=number %>" type="text" style="width:220px;" onkeyup="value=value.replace(/[^\w\.\/]/ig,'')"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        支付日期
                        <div>
                            <input type="text" style="width:100px;" onclick="WdatePicker()" class="Wdate" id="pay_date" value="<%=date %>"/>
                            <input type="hidden" id="datevalue" name="datevalue" />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/SysSettingRoles.js"></script>
       <script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
            <script>
                /*$(function () {
                    var myDate = new Date();
                    var dd = myDate.toLocaleDateString();
                    var reg = new RegExp("/", "g");//g,表示全部替换。
                    dd = dd.replace(reg, "-");
                    $("#pay_date").val(dd);
                });*/
                function save_deal() {
                    var k = $("#pay_date").val();
                    if (k == null || k == '') {
                        alert("请选择提交日期！");
                        return false;
                    }
                    k = k.replace(/[^0-9]+/g, '');
                    $("#datevalue").val(k);
                }
            </script>
    </form>
</body>
</html>
