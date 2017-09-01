<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.ProductAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <title>产品</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">新增产品</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <asp:Button ID="Save_Close" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="SaveAndNewButton" tabindex="0">
                <asp:Button ID="Save_New" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <!--切换按钮-->
    <div class="TabBar">
        <a class="Button ButtonIcon SelectedState">
            <span class="Text">总结</span>
        </a>
        <a class="Button ButtonIcon">
            <span class="Text">用户定义的</span>
        </a>
        <a class="Button ButtonIcon">
            <span class="Text">库存</span>
        </a>
    </div>
    <!--切换项-->
    <div class="TabContainer" style="min-width: 700px;">
        <div class="DivSection" style="border:none;padding-left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="50%" class="FieldLabels">
                           产品名称
                            <span class="errorSmall">*</span>
                            <div>
                                <asp:TextBox ID="Product_Name" runat="server" style="width:268px;"></asp:TextBox>
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels">
                            产品种类
                           <%-- <div>
                                <asp:TextBox ID="Product_Category" runat="server" style="width:268px;"></asp:TextBox>
                                <img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/>
                            </div>--%>

                            <%--查找带回--%>
                           <%if (product.cate_id== null)
                            { %>
                        <div>
                            <label>产品种类<span style="color:red">*</span></label>
                           <input type="text" disabled="disabled" id="accCallBack" name="account_name" value="" />
                            <input type="hidden" name="cate_id" id="accCallBackHidden" value="" />
                            <i onclick="OpenWindowProductCate()"><img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/></i>
                        </div>

                        <%}
                        else
                        { %>
                            <div class="clear input-dh">
                            <label>产品种类<span style="color:red">*</span></label>
                            <input type="text" disabled="disabled" id="accCallBack" name="account_name" value="<%=cate_name %>" />
                            <input type="hidden" name="cate_id" id="accCallBackHidden" value="<%=cate_name %>" />
                            <i onclick="OpenWindowProductCate()"><img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/></i>
                        </div>
                        <%} %>
                         <%--查找带回--%>



                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            产品描述
                            <div>
                                <asp:TextBox ID="Product_Description" runat="server" maxlength="100" style="width: 268px;height:70px;" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </td>
                        <td class="FieldLabels" style="vertical-align: top;">
                            <div style="padding: 5px 0;">
                                <asp:CheckBox ID="Active" runat="server" />激活</div>
                            <div style="padding: 5px 0;">
                                <asp:CheckBox ID="Serialized" runat="server" />序列化</div>
                            <div style="padding: 5px 0;">
                                <asp:CheckBox ID="does_not_require_procurement" runat="server" />无需采购</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            默认配置项类型
                            <div>
                                <asp:DropDownList ID="Item_Type" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            物料代码<span class="errorSmall">*</span>
                            <div>
                             <input type="text" disabled="disabled" id="CallBack" name="account_name" value="<%=code_name %>" />
                            <input type="hidden" name="" id="CallBackHidden" value="<%=product.cost_code_id %>" />
                            <i onclick="OpenWindowMaterialCode()"><img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/></i>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            <span>单位成本</span>
                            <span style="margin-left: 20px;">毛利率</span>
                            <span style="margin-left: 12px;">单位价格</span>
                            <span style="margin-left: 15px;">MSRP</span>
                            <div style="padding-bottom: 2px;">
                                <asp:TextBox ID="Unit_Cost" runat="server" style="width:60px;text-align: right;"></asp:TextBox>
                                <asp:TextBox ID="Markup" runat="server" style="width:60px;text-align: right;"></asp:TextBox>
                                <asp:TextBox ID="Unit_Price" runat="server" style="width:60px;text-align: right;"></asp:TextBox>
                                <asp:TextBox ID="MSRP" runat="server" style="width:60px;text-align: right;"></asp:TextBox>
                            </div>
                        </td>
                        <td class="FieldLabels">
                            周期类型
                            <div style="padding-bottom: 2px;">
                                <asp:DropDownList ID="Period_Type" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                Unit Cost and Unit Price will be used for quotes and ticket/project/contract charges.
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            内部产品ID
                            <div>
                                <asp:TextBox ID="Internal_Product_ID" runat="server"></asp:TextBox>
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels">
                           制造商
                            <div>
                                <asp:TextBox ID="Manufacturer" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            外部产品ID
                            <div>
                                <asp:TextBox ID="External_Product_ID" runat="server"></asp:TextBox>
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels">
                           制造商产品编号
                            <div>
                                <asp:TextBox ID="Manufacturer_Product_Number" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            产品链接<a style="color:cadetblue" href="#">Preview</a>
                            <div>
                                <asp:TextBox ID="Product_Link" runat="server" maxlength="100" style="width: 268px;height:70px;" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels" style="vertical-align: top;">
                           产品SKU
                            <div>
                                <asp:TextBox ID="Product_SKU" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="width: 100%; margin-bottom: 10px;">
            <div class="ButtonContainer">
                <ul>
                    <li class="Button ButtonIcon NormalState" id="NewButton" tabindex="0">
                        <span class="Icon New"></span>
                        <span class="Text">新建</span>
                    </li>
                </ul>
            </div>
            <div class="GridContainer">
                <div style="width: 100%; overflow: auto; z-index: 0;">
                    <table class="dataGridBody" cellspacing="0" width="100%">
                        <tbody>
                            <tr class="dataGridHeader" style="height: 28px;">
                                <td style="width: auto;">
                                    <span>供应商名称</span>
                                </td>
                                <td align="right" style="width: auto;">
                                    <span>单位成本</span>
                                </td>
                                <td align="left" style="width: auto;">
                                    <span>供应商产品编号</span>
                                </td>
                                <td align="center" style="width: 40px;">
                                    <span>激活</span>
                                </td>
                                <td align="center" style="width: 45px;">
                                    <span>默认</span>
                                </td>
                            </tr>


                            <tr class="dataGridBody">
                                <td style="width: auto;">
                                    <span>Vendor</span>
                                </td>
                                <td align="right" style="width: auto;">
                                    <span>$11111</span>
                                </td>
                                <td align="left" style="width: auto;">
                                    <span>452542</span>
                                </td>
                                <td align="center" style="width: 40px;">
                                   <img src="../Images/check.png" />
                                </td>
                                <td align="center" style="width: 45px;">
                                 <img src="../Images/check.png" />
                                </td>
                            </tr>


                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="TabContainer" style="display: none;">
        <div>
            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tbody>
                    <tr>
                        <td style="padding-left:10px;padding-right:10px;">
                            <div class="grid">
                                There are no User-Defined Fields.
                            </div>
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
                            暂无
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
        </div>
        <input type="hidden" name="vendor_data" id="vendor_data" />
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../Scripts/SysSettingRoles.js"></script>
        <script>
            function OpenWindowProductCate() {
                window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CATE_CALLBACK %>&field=accCallBack&callBack=GetProductCate", window, 'left=200,top=200,width=600,height=800', false);
            }
            function OpenWindowMaterialCode() {
                window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=CallBack&callBack=GetProductCate", window, 'left=200,top=200,width=600,height=800', false);
            }
            function GetProductCate() {
               // alert($("#accCallBack").val());
            }
            $("#NewButton").click(function () {
                window.open('VendorAdd.aspx', '新增', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            });
            function vendoradd() {
                var vendor_data = $("#vendor_data").val();
                alert(vendor_data);
            }
        </script>
    </form>
</body>
</html>
