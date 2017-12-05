<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductStock.aspx.cs" Inherits="EMT.DoneNOW.Web.ProductStock" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
      <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title>新增库存产品</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增库存产品</span>
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
                <asp:Button ID="Save_New" OnClientClick="return save_deal()" runat="server" Text="保存并新增" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li onclick="javascript:window.close()"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" />
            </li>
        </ul>
    </div>
    <div class="DivSection" style="border:none;padding-left:0;">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
                <tr>
                    <td width="30%" class="FieldLabels">
                        产品名称
                        <span class="errorSmall">*</span>
                        <div>
                           <input type="text" id="product_name" name="product_name" disabled="disabled" value="<%=productname %>"/>
                            <input type="hidden" id="product_id" name="product_id" value="<%=product_id %>" />
                           <img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        库存位置
                        <span class="errorSmall">*</span>
                        <div>
                           <asp:DropDownList ID="warehouse_id" runat="server"></asp:DropDownList>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        参考号
                        <div>
                            <asp:TextBox ID="reference_number" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        货柜
                        <div>
                            <asp:TextBox ID="bin" runat="server"></asp:TextBox>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td width="30%" class="FieldLabels">
                        <table border="0">
                            <tbody>
                                <tr>
                                    <td style="width:120px;">
                                        最小值
                                        <span class="errorSmall">*</span>
                                        <div>
                                            <asp:TextBox ID="quantity_minimum" runat="server" ></asp:TextBox>
                                        </div>
                                    </td>
                                    <td>
                                        最大值
                                        <span class="errorSmall">*</span>
                                        <div>
                                            <asp:TextBox ID="quantity_maximum" runat="server"></asp:TextBox>
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
                                       库存数
                                        <span class="errorSmall">*</span>
                                        <div>
                                            <asp:TextBox ID="quantity" runat="server"></asp:TextBox>
                                        </div>
                                    </td>
                                    <td valign="top" style="display: none;">
                                       订购中数量
                                        <div style="Padding-bottom:15px;">
                                           <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
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
                                    <td valign="top" style="display: none;">
                                      预留/检出数量
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;">0</span>
                                        </div>
                                    </td>
                                    <td valign="top" style="display: none;">
                                        延期交付数量
                                        <div style="Padding-bottom:15px;">
                                            <span class="lblNormalClass" style="font-weight: normal;">0</span>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
        </div>
         <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/SysSettingRoles.js"></script>
        <script>        
            function save_deal() {
                var w = $("#warehouse_id").val();
                var min = $("#quantity_minimum").val();
                var max = $("#quantity_maximum").val();
                var q = $("#quantity").val();
                max = parseFloat(max);
                q = parseFloat(q);
                min = parseFloat(min);
                if (w == null || w == '') {
                    alert('请选择库存位置！');
                    return false;
                }
                if (min == null || min == '') {
                    alert("请输入库存最小值！");
                    return false;
                }
                if (max == null || max == '') {
                    alert("请输入库存最大值！");
                    return false;
                }
                if (q == null || q == '') {
                    alert("请输入库存数量！");
                    return false;
                }
                if (min > max) {
                    alert("最大值不能小于最小值！");
                    return false;
                }
                if (q > max) {
                    alert("库存数不能大于最大值！");
                    return false;
                }
            }
                $("#quantity").change(function () {
                    if ((/^\d{1,15}$/.test(this.value)) == false) {
                        alert('只能输入整数！');
                        this.value = '';
                        this.focus();
                        return false;
                    } else {
                        var max = $("#quantity_maximum").val();
                        var q = $("#quantity").val();
                        if (max != null && max != '') {
                            max = parseFloat(max);
                            q = parseFloat(q);
                            if (q > max) {
                                alert("库存数不能大于最大值！");
                                this.value = '';
                                this.focus();
                                return false;
                            }
                        }
                    }
                   
                });

                $("#quantity_minimum").change(function () {
                    if ((/^\d{1,15}$/.test(this.value)) == false) {
                        alert('只能输入整数！');
                        this.value = '';
                        this.focus();
                        return false;
                    } else {
                        var min = $("#quantity_minimum").val();
                        var max = $("#quantity_maximum").val();
                        if (max != null && max != '') {
                            max = parseFloat(max);
                            min = parseFloat(min);
                            if (max < min) {
                                alert("最大值不能小于最小值！");
                                this.value = '';
                                this.focus();
                                return false;
                            }
                        }

                    }

                });
                $("#quantity_maximum").change(function () {
                    if ((/^\d{1,15}$/.test(this.value)) == false) {
                        alert('只能输入整数！');
                        this.value = '';
                        this.focus();
                        return false;
                    } else {
                        var min = $("#quantity_minimum").val();
                        var max = $("#quantity_maximum").val();
                        if (min != null && min != '') {
                            max= parseFloat(max);
                            min= parseFloat(min);
                            if (max < min) {
                                alert("最大值不能小于最小值！");
                                this.value = '';
                                this.focus();
                                return false;
                            }
                        }
                    }

                });
               
        </script>
    </form>
</body>
</html>
