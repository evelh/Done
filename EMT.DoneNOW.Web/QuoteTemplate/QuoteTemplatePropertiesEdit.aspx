<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteTemplatePropertiesEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteTemplatePropertiesEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>报价模板新增</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
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
             <div class="header">报价模板新增</div>
             <div class="header-title">
            <ul><li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
            <asp:Button ID="Button1" runat="server" Text="修改"  BorderStyle="None" OnClick="UPdateQuoteTemplate" />
                </li><li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="close" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel" />
            </li></ul>
        </div>
            <div class="text">为这个报价模板配置基本设置</div>
            <div class="information clear">
                <p class="informationTitle"><i></i>基本信息</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 500px;margin-left: 31px;">
                         <tr>
                            <td>
                                <div class="clear">
                                    <label>模板名称<span style="color:red">*</span></label>
                                </div>
                            </td>
                             </tr>
                        <tr><td> <asp:TextBox ID="Name" runat="server" class="q1"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>说明</label>
                                </div>
                            </td>
                        </tr>
                        <tr><td>
                            <asp:TextBox ID="Description" runat="server"  TextMode="MultiLine" CssClass="q1"></asp:TextBox><br />
                            <%-- <div class="CharacterInformation"><span class="CurrentCount">0</span>/<span class="Maximum">200</span></div>--%>
                            <asp:CheckBox ID="Active" runat="server" text="激活" />
                            </td></tr>
                         </table>
                    </div>
                </div>
            <div class="information clear">
                <p class="informationTitle"><i></i>数据格式</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 500px; margin-left: 31px;">
                         <tr>
                            <td>
                                <div class="clear">
                                    <label>日期格式</label>
                                </div>
                            </td>
                             </tr>
                        <tr><td>
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
                        <tr><td>
                            <asp:DropDownList ID="NumberFormat" runat="server">
                            </asp:DropDownList>
                            </td></tr>
                         </table>
                    </div>
                </div>


            <div class="information clear">
                <p class="informationTitle"><i></i>税收显示格式设置</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 500px;margin-left: 31px;">
                         <tr>
                            <td>
                                <div class="clear">
                                    <asp:CheckBox ID="show_each_tax_in_tax_period" runat="server"/><label class="q1">单独计算每一时期的税收,同样适用于库存配送项目、一次性折扣项目和可选项目,只有首先按周期类型分组时才适用。</label>
                                </div>
                            </td>
                             </tr>
                        <tr><td><div class="clear">
                            <asp:CheckBox ID="show_tax_cate" runat="server" text="显示税种"/>
                            </div></td>
                            
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <asp:CheckBox ID="show_tax_cate_superscript" runat="server" text="根据税种显示,通常适用于每一时期的税额显示"/>
                                </div>
                            </td>
                        </tr>
                        <tr><td><div class="clear">
                            <asp:CheckBox ID="show_each_tax_in_tax_group" runat="server" text="显示每个报价的订阅的关联税种"/>

                                </div>
                            </td></tr>
                         </table>
                    </div>
   



            <div class="information clear">                
                <p class="informationTitle"><i></i>数据税收/汇总显示格式设置格式</p>
             <%--<span class="text">税收显示和总显示包含硬编码的文本。您可以自定义下面的文本,此文本将适用于每个组的总显示，总显示，总税收显示，以及期间类型的税务显示(如果显示)。</span>--%>
        <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 500px;margin-left: 31px;">
                        <tr><td><div class="clear"><label>子汇总</label></div></td><td><div class="clear"><label>半年收费汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="Subtotal" runat="server">子汇总</asp:TextBox></div></td><td>
                                <div class="clear">
                                <asp:TextBox ID="SemiAnnualTotal" runat="server">半年收费汇总</asp:TextBox>                                                                                                        </div></td></tr>
       
                       <tr><td><div class="clear"><label>汇总</label></div></td><td><div class="clear"><label>年收费子汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="Total" runat="server">汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="YearlySubtotal" runat="server" >年收费子汇总</asp:TextBox></div></td></tr>
                        <tr><td><div class="clear"><label>税收汇总</label></div></td><td><div class="clear"><label>年收费汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="TotalTaxes" runat="server">税收汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="YearlyTotal" runat="server">年收费汇总</asp:TextBox></div></td></tr>
                        <tr><td><div class="clear"><label>子项汇总</label></div></td><td><div class="clear"><label>配送费子汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="ItemTotal" runat="server">子项汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="ShippingSubtotal" runat="server" >配送费子汇总</asp:TextBox></div></td></tr>
                        <tr><td><div class="clear"><label>一次性收费子汇总</label></div></td><td><div class="clear"><label>配送费汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="OneTimeSubtotal" runat="server" >一次性收费子汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="ShippingTotal" runat="server">配送费汇总</asp:TextBox></div></td></tr>
                         <tr><td><div class="clear"><label>一次性收费汇总</label></div></td><td><div class="clear"><label>一次性折扣子汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="OneTimeTotal" runat="server">一次性收费汇总</asp:TextBox></div></td><td><div class="clear"><asp:TextBox ID="OneTimeDiscountSubtotal" runat="server" >一次性折扣子汇总</asp:TextBox></div></td></tr>
                        <tr><td><div class="clear"><label>月收费子汇总</label></div></td><td><div class="clear"><label>一次性折扣汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="MonthlySubtotal" runat="server" >月收费子汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="OneTimeDiscountTotal" runat="server">一次性折扣汇总</asp:TextBox>
                                </div></td></tr>
                        <tr><td><div class="clear"><label>月收费汇总</label></div></td><td><div class="clear"><label>可选项子汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="MonthlyTotal" runat="server">月收费汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="OptionalSubtotal" runat="server" >可选项子汇总</asp:TextBox></div></td></tr>
                        <tr><td><div class="clear"><label>季收费子汇总</label></div></td><td><div class="clear"><label>可选项汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="QuarterlySubtotal" runat="server" >季收费子汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="OptionalTotal" runat="server">可选项汇总</asp:TextBox></div></td></tr>
                         <tr><td><div class="clear"><label>季收费汇总</label></div></td><td><div class="clear"><label>包括可选项汇总</label></div></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="QuarterlyTotal" runat="server">季收费汇总</asp:TextBox></div></td><td><div class="clear">
                                <asp:TextBox ID="IncludingOptionalQuoteItems" runat="server">包括可选项汇总</asp:TextBox></div></td></tr>
                         <tr><td><div class="clear"><label>半年收费子汇总</label></div></td><td></td></tr>
                        <tr><td><div class="clear">
                            <asp:TextBox ID="SemiAnnualSubtotal" runat="server" >半年收费子汇总</asp:TextBox></div></td><td><div class="clear">
                                </div></td></tr>
                         </table>
                </div>

                </div>
                 <div class="information clear">
                <p class="informationTitle"><i></i>数据格式</p>
                <div>
                    <table border="none" cellspacing="" cellpadding="" style="width: 500px;margin-left: 31px;">
                         <tr>
                            <td>
                                <div class="clear">
                                    <label>纸张尺寸</label><br/>
                                    <asp:RadioButton ID="Letter" runat="server" Checked="True" GroupName="Radiobox" Text="信纸: 8.25&quot; x 11.75&quot; (210 mm x 297 mm)" /><br/>
                                    <asp:RadioButton ID="A4" runat="server" GroupName="Radiobox" Text="A4: 8.5&quot; x 11&quot; (215.9 mm x 279.4 mm)" />
                                </div>
                            </td><td> <div class="clear">
                                    <label>货币格式（正数）</label><br />
                                <asp:DropDownList ID="CurrencyPositivePattern" runat="server">
                                    </asp:DropDownList>
                                </div></td>
                             </tr>
                        <tr><td></td>
                           
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>页码显示</label><br/>
                                    <asp:RadioButton ID="showNO" runat="server" Checked="True" GroupName="showPage" Text="不显示" /><br/>
                                    <asp:RadioButton ID="showLeft" runat="server" GroupName="showPage" Text="底部左边" /><br/>
                                    <asp:RadioButton ID="showCenter" runat="server" GroupName="showPage" Text="底部中间" /><br/>
                                    <asp:RadioButton ID="showRight" runat="server" GroupName="showPage" Text="底部右边" /><br/>

                                   <%-- <asp:CheckBoxList ID="pageshow" runat="server"></asp:CheckBoxList>--%>
                                </div>
                            </td><td> <div class="clear">
                                    <label>货币格式（负数）</label><br /><asp:DropDownList ID="CurrencyNegativePattern" runat="server">                   </asp:DropDownList>
                                </div></td>
                        </tr>
        <tr><td></td><td></td></tr>
                         </table>
                    </div>
                </div>

        </div>
</form>
</body>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
   var k0 =<%=k%>;
    $(document).ready(function () { 
       
        if (k0==0) {
            $("#OneTimeSubtotal").attr("readonly", true);
            $("#MonthlySubtotal").attr("readonly", true);
            $("#QuarterlySubtotal").attr("readonly", true);
            $("#SemiAnnualSubtotal").attr("readonly", true);
            $("#YearlySubtotal").attr("readonly", true);
            $("#OneTimeDiscountSubtotal").attr("readonly", true);
            $("#OptionalSubtotal").attr("readonly", true);
            $("#ShippingSubtotal").attr("readonly", true);
            k0 = 1;
            //alert(k0);
            return k0;
        }
        InitArea();
    });
    //alert(k0);
    $("#show_each_tax_in_tax_period").click(function () {
        console.log(k0);
        if (k0 == 1) {
            $("#OneTimeSubtotal").attr("readonly", true);
            $("#MonthlySubtotal").attr("readonly", true);
            $("#QuarterlySubtotal").attr("readonly", true);
            $("#SemiAnnualSubtotal").attr("readonly", true);
            $("#YearlySubtotal").attr("readonly", true);
            $("#OneTimeDiscountSubtotal").attr("readonly", true);
            $("#OptionalSubtotal").attr("readonly", true);
            $("#ShippingSubtotal").attr("readonly", true);            
            k0 = 0;
            return k0;
        }else{       
            //alert("ok");
            $("#OneTimeSubtotal").removeAttr("readonly");
            $("#MonthlySubtotal").removeAttr("readonly");
            $("#QuarterlySubtotal").removeAttr("readonly");
            $("#SemiAnnualSubtotal").removeAttr("readonly");
            $("#YearlySubtotal").removeAttr("readonly");
            $("#OneTimeDiscountSubtotal").removeAttr("readonly");
            $("#OptionalSubtotal").removeAttr("readonly");
            $("#ShippingSubtotal").removeAttr("readonly");      
            k0 = 1;
            return k0;
        }
    });
</script>
</html>
