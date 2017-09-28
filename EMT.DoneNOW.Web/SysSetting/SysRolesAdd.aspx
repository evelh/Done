<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SysRolesAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.SysRolesAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
     <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>角色管理</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增/修改角色</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul id="btn">
             <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="SaveRole" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="SaveRole_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <!--切换按钮-->
    <div class="TabBar">
        <a id="tab1" class="Button ButtonIcon SelectedState">
            <span class="Text">角色</span>
        </a>
        <a id="tab2" class="Button ButtonIcon">
            <span class="Text">员工</span>
        </a>
    </div>
    <!--切换项-->
    <div class="TabContainer">
        <div class="DivSection" style="border:none;padding-left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="30%" class="FieldLabels">
                            角色名称
                            <span class="errorSmall">*</span>
                            <div>
                                <asp:TextBox ID="Role_Name" runat="server" style="width:268px;"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:15px;">
                            <asp:CheckBox ID="Active" runat="server" />激活
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                           描述
                            <div>
                                <asp:TextBox ID="Role_Description" runat="server" TextMode="MultiLine"  maxlength="100" cols="50" rows="4"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            默认税种
                            <div>
                                <asp:DropDownList ID="Tax_cate" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            费率
                            <div>
                                <asp:TextBox ID="Hourly_Billing_Rate" runat="server" maxlength="30" size="10" style="text-align: right;" onblur="valid()"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            时间系数
                            <div>
                                 <asp:TextBox ID="Block_Hour_Multiplier" runat="server" maxlength="30" size="10" style="text-align: right;"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding-bottom:15px;">
                            <asp:CheckBox ID="Excluded" runat="server" />从新合同中排除
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div class="TabContainer" style="display: none;">
        <div>
            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tbody>
                    <tr>
                        <td style="padding-left:10px;padding-right:10px;">
                            <div class="grid">
                                <table width="100%" border="0" cellspacing="0" cellpadding="3">
                                    <thead>
                                        <tr height="21">
                                            <td width="5">&nbsp;</td>
                                            <td>员工姓名</td>
                                            <td>部门</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%@ Import Namespace="System.Data" %>  
                                        <%foreach (DataRow tr in table.Rows)
                                            { %>                                        
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td><%=tr[1].ToString()%></td>
                                            <td><%=tr[2].ToString()%></td>
                                        </tr>

                                        <%} %>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    </form>
    <script src="../Scripts/jquery-3.1.0.min.js"></script>
 <%--   <script src="../Scripts/SysSettingRoles.js"></script>--%>
    <script type="text/javascript">
        //$.each($(".TabBar a"), function (i) {
        //    $(this).click(function () {
        //        $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
        //        $(".TabContainer").eq(i).show().siblings(".TabContainer").hide();
        //    })
        //});
        $("#tab2").click(function () {
            <%if (id<=0)
        { %>
            alert("在新增情况下，角色还未保存，无关联员工存在！");
            return false;
            <%}%>

            $("#tab2").addClass("SelectedState").siblings("a").removeClass("SelectedState");
            $(".TabContainer").eq(1).show().siblings(".TabContainer").hide();
        });
        $("#tab1").click(function () {
            $("#tab1").addClass("SelectedState").siblings("a").removeClass("SelectedState");
            $(".TabContainer").eq(0).show().siblings(".TabContainer").hide();
         });

        $("#SaveRole").click(function () {
            var r=$("#Role_Name").val();
            var h=$("#Hourly_Billing_Rate").val();
            var b=$("#Block_Hour_Multiplier").val();
            if (r == null || r == '') {
                alert("请填入角色名称！");
                return false;
            }
            if (h == null || h == '') {
                alert("请输入费率！");
                return false;
            }
            if (b == null || b == '') {
                alert("请输入时间系数！");
                return false;
            }
            var type = /^\d{1,15}\.?\d{0,4}$/;
            if (type.test(h) == false) {
                alert("请输入符合decimal(15,4)格式的数值");
                $("#Hourly_Billing_Rate").focus();
            }
            if (type.test(b) == false) {
                alert("请输入符合decimal(15,4)格式的数值");
                $("#Block_Hour_Multiplier").focus();
            }
        });
        $("#Hourly_Billing_Rate").change(function () {
            var h = $("#Hourly_Billing_Rate").val();
            //验证数据格式decimal(15,4)   /^[\d]{5,20}$/
            var type = /^\d{1,15}\.?\d{0,4}$/;
            if (type.test(h) == false) {
                alert("请输入数字格式格式的数值");
                $("#Hourly_Billing_Rate").focus();
            }
            var f = parseFloat(h);
            if (isNaN(h)) {
                return false;
            }
            var f = Math.round(h * 100) / 100;
            var s = f.toString();
            var rs = s.indexOf('.');
            if (rs < 0) {
                rs = s.length;
                s += '.';
            }
            while (s.length <= rs + 2) {
                s += '0';
            }
            $("#Hourly_Billing_Rate").val(s);
        });
        $("#Block_Hour_Multiplier").blur(function () {
            var b = $("#Block_Hour_Multiplier").val();
            //验证数据格式decimal(15,4)
            var type = /^\d{1,15}\.?\d{0,4}$/;
            if (type.test(b) == false) {
                alert("请输入符合数字格式的数值");
                $("#Block_Hour_Multiplier").focus();
            }
            var f = parseFloat(b);
            if (isNaN(f)) {
                return false;
            }
            var f = Math.round(b * 100) / 100;
            var s = f.toString();
            var rs = s.indexOf('.');
            if (rs < 0) {
                rs = s.length;
                s += '.';
            }
            while (s.length <= rs + 4) {
                s += '0';
            }
            $("#Block_Hour_Multiplier").val(s);
        });
    </script>
</body>
</html>
