<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteItemAddAndUpdate.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteItem.QuoteItemAddAndUpdate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"添加报价项":"修改报价项" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="header"><%=isAdd?"添加报价项":"修改报价项" %>-<%=type %></div>

        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_new" runat="server" Text="保存并新增" BorderStyle="None" />
                </li>

                <li id="close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    关闭</li>
            </ul>
        </div>

        <div style="float: left; width: 30%;">
            <table>
                <tr>
                    <td>报价项名称</td>
                </tr>
                <tr>
                    <td>
                        <input type="text" name="name" id="name" /></td>
                </tr>
                <tr>
                    <td>报价项描述</td>
                </tr>
                <tr>
                    <td>
                        <textarea name="description" id="description">

                        </textarea>
                    </td>
                </tr>
                <tr>
                    <td>期间类型</td>
                </tr>
                <tr>
                    <td>
                        <asp:DropDownList ID="period_type_id" runat="server"></asp:DropDownList></td>

                </tr>
                <tr>
                    <td>
                        <input type="checkbox" name="" id="" />项目提案工时</td>
                </tr>
                <tr>
                    <td>
                        <input type="text" name="project_id" id="project_id" /></td>
                </tr>
                <tr>
                    <td>税收种类</td>
                </tr>
                <tr>
                    <td>
                        <asp:DropDownList ID="tax_cate_id" runat="server"></asp:DropDownList></td>
                </tr>
            </table>
        </div>
        <div style="float: left; width: 60%;">
            <table>
                <tr>
                    <td>
                        <div class="clear">
                            <label>单价</label>
                            <input type="text" class="Calculation" name="unit_price" id="unit_price" value="<%=(!isAdd)&&(quote_item.unit_price!=null)?quote_item.unit_price.ToString():"" %>" />
                        </div>
                    </td>
                    <td>
                        <div class="clear">
                            <label>单元折扣</label>
                            <input type="text" class="Calculation" name="unit_discount" id="unit_discount"  value="<%=(!isAdd)&&(quote_item.unit_discount!=null)?quote_item.unit_discount.ToString():"" %>"/>
                        </div>
                    </td>

                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>毛利率</label>
                            <input type="text" name="gross_profit_margin" id="gross_profit_margin" disabled="disabled"/>
                        </div>
                    </td>
                    <td>
                        <div class="clear">
                            <label>折扣数</label>
                            <input type="text" name="Line_Discount" id="Line_Discount"  disabled="disabled"/>
                        </div>
                    </td>

                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>单元成本</label>
                            <input type="text" class="Calculation" name="unit_cost" id="unit_cost" value="<%=(!isAdd)&&(quote_item.unit_cost!=null)?quote_item.unit_cost.ToString():"" %>" />
                        </div>
                    </td>
                    <td>
                        <div class="clear">
                            <label>折扣率</label>
                            <input type="text" name="Discount" id="Discount"  disabled="disabled"/>
                        </div>
                    </td>

                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>数量</label>
                            <input type="text" class="Calculation" name="quantity" id="quantity" value="<%=(!isAdd)&&(quote_item.quantity!=null)?quote_item.quantity.ToString():isAdd?"1":"" %>" />
                        </div>
                    </td>
                    <td>
                        <input type="checkbox" name="optional" id="optional" data-val="1" value="1" />可选的</td>

                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>总价</label>
                            <input type="text" name="TotalPrice" id="TotalPrice" disabled="disabled" />
                        </div>
                    </td>

                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>毛利润</label>
                            <input type="text" name="Gross_Profit" id="Gross_Profit" disabled="disabled" />
                        </div>
                    </td>

                </tr>
            </table>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/NewContact.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script>
    $(function () {

        Markup();

        $(".Calculation").blur(function () {
            Markup();
        })
    })

    // 计算页面上的利，总价等
    function Markup() {
        var unit_price = $("#unit_price").val();    // 单价
        var unit_cost = $("#unit_cost").val();      // 单元成本
        var quantity = $("#quantity").val();       // 数量
        var unit_discount = $("#unit_discount").val();  // 单元折扣

        // 计算毛利率
        if (unit_price != "" && unit_cost != "")   
        {
            if ((!isNaN(unit_price)) && (!isNaN(unit_cost))) // 两个都是数字开始执行
            {
                var Markup = Math.round((Number(unit_price) - Number(unit_cost)) / Number(unit_price) * 10000) / 100.00;  //gross_profit_margin
                $("#gross_profit_margin").val(Markup);
            }
        }

         // 计算总价
        if (unit_price != "" && unit_discount != "" && quantity != "") 
        {
            if ((!isNaN(unit_price)) && (!isNaN(unit_discount)) && (!isNaN(quantity))) // 都是数字开始执行
            {
                var total_price = (Number(unit_price) - Number(unit_discount)) * quantity;
                $("#TotalPrice").val(total_price);
            }
        }

         // 计算毛利润
        if (unit_price != "" && unit_discount != "" && quantity != "" && unit_cost != "") 
        {
            if ((!isNaN(unit_price)) && (!isNaN(unit_discount)) && (!isNaN(quantity)) && (!isNaN(unit_cost))) // 都是数字开始执行
            {
                var Gross_Profit = (Number(unit_price) - Number(unit_discount) - Number(unit_cost)) * quantity;
                $("#Gross_Profit").val(Gross_Profit);
            }
        }

        // 计算折扣数
        if ( unit_discount != "" && quantity != "" ) {
            if ((!isNaN(unit_discount)) && (!isNaN(quantity))) // 都是数字开始执行
            {
                var Line_Discount =  Number(unit_discount) * quantity;
                $("#Line_Discount").val(Line_Discount);
            }
        }
        // 计算折扣率  Discount
        if (unit_discount != "" && unit_price != "") {
            if ((!isNaN(unit_discount)) && (!isNaN(unit_price))) // 都是数字开始执行
            {
                var Discount = Math.round(Number(unit_discount) / Number(unit_price)*10000)/100.00;
                $("#Discount").val(Discount);
            }
        }


       
    }
    
 


</script>
