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
                                        产品名称
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;">
                                                <asp:Label ID="product_name" runat="server" Text="Label"></asp:Label></span>
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
                                        库存位置
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;"><asp:Label ID="warehouse" runat="server" Text="Label"></asp:Label></span>
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
                                       移库数量
                                        <span class="errorSmall">*</span>
                                        <div>
                                            <asp:TextBox ID="remove_quantity" runat="server"></asp:TextBox>
                                        </div>
                                    </td>
                                    <td valign="top">
                                        可用数
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;"><asp:Label ID="quantity" runat="server" Text="Label"></asp:Label></span>
                                        </div>                                        
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        目标库存位置
                        <span class="errorSmall">*</span>
                        <div>
                            <asp:DropDownList ID="warehouse_id" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        备注
                        <div>
                            <asp:TextBox ID="note" runat="server" style="height: 100px; width: 200px; margin-top: 0px; margin-bottom: 0px;" TextMode="MultiLine"></asp:TextBox>
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

            function save_deal() {
                var q = $("#remove_quantity").val();
                var w = $("#warehouse_id").val();
                if (q == null || q == '') {
                    alert("请输入移库数量！");
                    return false;
                }
                if (w == null || w == '') {
                    alert("请输入目标库存位置！");
                    return false;
                }
            }

            $("#remove_quantity").change(function () {
                if ((/^\d{1,15}$/.test(this.value)) == false) {
                    alert('只能输入整数！');
                    this.value = '';
                    this.focus();
                    return false;
                } else {
                    var q1 = $("#remove_quantity").val();
                    var q2 = $("#quantity").text();
                    q1 = parseFloat(q1);
                    q2 = parseFloat(q2);
                        if (q1>q2) {
                            alert("移库数量只能小于等于可用数！");
                            this.value = '';
                            this.focus();
                            return false;
                        }
                }

            });

    </script>
    </form>
</body>
</html>
