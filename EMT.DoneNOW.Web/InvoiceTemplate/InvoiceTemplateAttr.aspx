<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceTemplateAttr.aspx.cs" Inherits="EMT.DoneNOW.Web.InvoiceTemplateAttr" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>发票模板新增</title>
        <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
    <style type="text/css">
    .clear{
        overflow:hidden;
    }
    #show_each_tax_in_tax_period,#show_tax_cate,#show_tax_cate_superscript,#show_each_tax_in_tax_group,#Active,#showNO,#showLeft,#showCenter,#showRight,#Letter,#A4{
        float:left;
    }
    .q1{
        width:466px;
    }
    td{
        text-align:left;
        padding: 0 0 0 12px;
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="header">发票模板新增</div>
           <div class="ButtonContainer header-title">
        <ul id="btn">
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
            <div class="text">为这个模板配置基本设置</div>
            <div style="left: 0; overflow-x: auto; overflow-y: auto; position: fixed; right: 0; bottom: 0; top: 118px;">
                <div class="information clear">
                    <p class="informationTitle"><i></i>基本信息</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 31px; border: none;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>模板名称<span style="color: red">*</span></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="Name" runat="server" class="q1"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>说明</label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:TextBox ID="Description" runat="server" TextMode="MultiLine" CssClass="q1" Style="max-width: 466px; width: 466px; resize: vertical;"></asp:TextBox><br />
                                    <%-- <div class="CharacterInformation"><span class="CurrentCount">0</span>/<span class="Maximum">200</span></div>--%>
                                    <asp:CheckBox ID="Active" runat="server" Text="激活" Checked="True" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="information clear">
                    <p class="informationTitle"><i></i>数据格式</p>
                    <div>
                        <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 31px; border: none;">
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>日期格式</label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="DateFormat" runat="server">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="clear">
                                        <label>数字格式</label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DropDownList ID="NumberFormat" runat="server">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                    <div class="information clear">
                        <p class="informationTitle"><i></i>数据格式</p>
                        <div>
                            <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 31px; border: none;">
                                <tr>
                                    <td>
                                        <div class="clear">
                                            <label>纸张尺寸</label><br />
                                            <asp:RadioButton ID="Letter" runat="server" Checked="True" GroupName="Radiobox" Text="信纸: 8.25&quot; x 11.75&quot; (210 mm x 297 mm)" /><br />
                                            <asp:RadioButton ID="A4" runat="server" GroupName="Radiobox" Text="A4: 8.5&quot; x 11&quot; (215.9 mm x 279.4 mm)" />
                                        </div>
                                    </td>
                                    <td>
                                        <div class="clear">
                                            <label>支付条款</label><br />
                                            <asp:DropDownList ID="Payment_terms" runat="server">
                                            </asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td> <div class="clear">
                                            <label>货币格式（正数）</label><br />
                                            <asp:DropDownList ID="CurrencyPositivePattern" runat="server">
                                            </asp:DropDownList>
                                        </div></td>

                                </tr>
                                <tr>
                                    <td>
                                        <div class="clear">
                                            <label>页码显示</label><br />
                                            <asp:RadioButton ID="showNO" runat="server" Checked="True" GroupName="showPage" Text="不显示" /><br />
                                            <asp:RadioButton ID="showLeft" runat="server" GroupName="showPage" Text="底部左边" /><br />
                                            <asp:RadioButton ID="showCenter" runat="server" GroupName="showPage" Text="底部中间" /><br />
                                            <asp:RadioButton ID="showRight" runat="server" GroupName="showPage" Text="底部右边" /><br />

                                            <%-- <asp:CheckBoxList ID="pageshow" runat="server"></asp:CheckBoxList>--%>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="clear">
                                            <label>货币格式（负数）</label><br />
                                            <asp:DropDownList ID="CurrencyNegativePattern" runat="server"></asp:DropDownList>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </div>

                </div>
        </div>
        
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
    </form>
</body>
</html>
