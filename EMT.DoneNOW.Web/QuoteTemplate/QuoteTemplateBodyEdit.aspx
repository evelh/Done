<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteTemplateBodyEdit.aspx.cs" Inherits="EMT.DoneNOW.Web.QuoteTemplateBodyEdit" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>报价模板正文</title>
    	<link rel="stylesheet" href="../RichText/css/reset.css">
    <link rel="stylesheet" href="../RichText/css/QuoteBody.css">
</head>
<body>
    <!--顶部  内容和帮助-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">报价模板</span>
            <span class="text2">- burberryquotetemplate</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--中间form表单-->
    <form action="" method="post" id="EditQuoteTemplate" runat="server">
        <div></div>
        <!--按钮部分-->
        <div class="ButtonContainer">
            <ul id="btn">
                <li class="Button ButtonIcon Okey NormalState" id="OkButton" tabindex="0">
                    <span class="Icon Ok"></span>
                    <%--<span class="Text">确认</span>--%><asp:Button ID="OkButton1" runat="server" Text="确认" cssclass="Text" BorderStyle="None" OnClick="Save" />
                </li>
            </ul>
        </div>
        <div class="ScrollingContainer">
            <div class="Instruction">指定显示的字段，可以修改显示名称、是否显示和显示顺序</div>
            <!--第一个选择框-->
            <div class="Section" id="b1">
                <div class="Heading">
                    <div class="Toggle Collapse" id="a1">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">表格显示字段设置</span>
                </div>
                <div class="DescriptionText" id="c1">指定要显示的列,对于每一列，指定标签及其显示顺序(通过拖放顺序列)。</div>
                <div class="Content" id="d1">
                   <%-- <form action="" method="post">--%>
                        <div class="Grid Medium">
                            <!--头部-->
                            <div class="HeaderContainer">
                                <table cellpadding="0">
                                    <tbody>
                                        <tr class="HeadingRow">
                                            <td class="Interaction DragEnabled">
                                                <div class="Standard">
                                                    <div class="Heading">显示顺序（从左到右）</div>
                                                </div>
                                            </td>
                                            <td class="Text Dynamic">
                                                <div class="Standard">
                                                    <div class="Heading">字段内容</div>
                                                </div>
                                            </td>
                                            <td class="XL Text">
                                                <div class="Standard">
                                                    <div class="Heading">显示名称 <span class="Required">*</span></div>
                                                </div>
                                            </td>
                                            <td class="Boolean">
                                                <div class="Standard tc">
                                                    <div class="Heading">显示</div>
                                                </div>
                                            </td>
                                            <td class="ScrollingBarSpacer" style="width:17px;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!--内容-->
                            <div class="RowContainer BodyContainer">
                                <table cellpadding="0">
                                    <tbody>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                         <img  src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                         <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">1</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Item#</td>
                                            <td class="Text E XL U2 Column_label">序列号</td>
                                              


                                               <%-- <asp:Label ID="Label1" runat="server" class="Text E XL U2" Text="可修改的内容1"></asp:Label>--%>
                                               <%-- <label class="Text E XL U2" name="1">可修改的内容1</label>--%>

                                           
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                         <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                         <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">2</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Quantity</td>
                                            <td class="Text E XL U2 Column_label">数量</td>
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                      <img  src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                      <img  src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">3</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Item</td>
                                            <td class="Text E XL U2 Column_label">报价项名称</td>
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                      <img  src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                      <img  src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">4</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Unit Price</td>
                                            <td class="Text E XL U2 Column_label">单价</td>
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                      <img  src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                      <img  src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">5</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Unit Discount</td>
                                            <td class="Text E XL U2 Column_label">单元折扣</td>
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                      <img  src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                      <img  src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">6</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Adjusted Unit Price</td>
                                            <td class="Text E XL U2 Column_label">折后价</td>
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                      <img  src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                      <img  src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">7</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Extended Price</td>
                                            <td class="Text E XL U2 Column_label">总价</td>
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                      <img  src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                      <img  src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="Sort Order">8</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1 Column_Content">Discount %</td>
                                            <td class="Text E XL U2 Column_label">折扣率</td>
                                            <td class="Boolean E Display">
                                                <div class="Decoration Icon CheckMark"></div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                 <%--   </form>--%>
                </div>
            </div>
            <!--第二个选择框-->
            <div class="Section" id="b2">
                <div class="Heading">
                    <div class="Toggle Collapse" id="a2">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">表格格式设置</span>
                </div>
                <div class="Content" id="d2">
                    <div class="Normal Column">
                        <div class="Normal Editor CheckBox">
                            <div class="InputField">
                                <div>
                                    <input type="checkbox" id="ShowGridHeader" checked="checked">
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="ShowGridHeader">显示网格标头</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Editor CheckBox">
                            <div class="InputField">
                                <div>
                                    <input type="checkbox" id="ShowVerticalGridlines">
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="ShowVerticalGridlines">显示网格中的竖线</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="Normal Editor CheckBox">
                            <div class="InputField">
                                <div>
                                    <input type="checkbox" id="DisplayQuoteCommentInBody" checked="checked">
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="DisplayQuoteCommentInBody">[评论]变量的引用：在引用其他部分也可。</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--第三个选择框-->
            <div class="Section" id="b3">
                <div class="Heading">
                    <div class="Toggle Collapse" id="a3">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">报价项字段设置</span>
                </div>
                <div class="DescriptionText" id="c3">可以定义不同类型的报价项（名称）字段显示内容</div>
                <div class="Content" id="d3">
                    <div class="Grid Medium">
                        <div class="HeaderContainer">
                            <table cellpadding="0">
                                <tbody>
                                    <tr class="HeadingRow">
                                        <td class="Command" style="width:27px;">
                                            <div class="Standard">
                                                <div></div>
                                            </div>
                                        </td>
                                        <td class="Text Dynamic">
                                            <div class="Standard">
                                                <div class="Heading">报价项类型</div>
                                            </div>
                                        </td>
                                        <td class="FormatPreservation">
                                            <div class="Standard">
                                                <div class="Heading">显示内容</div>
                                            </div>
                                        </td>
                                        <td class="ScrollBarSpacer" style="width:17px;"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="RowContainer BodyContainer">
                            <table cellpadding="0">
                                <tbody>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">产品</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]1<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">成本</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]2<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">工时</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]3<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">费用</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]4<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">配送费用</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]5<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">折扣</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]6<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">服务包</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]7<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1 Type_of_Quote_Item">初始费用</td>
                                        <td class="FormatPreservation U2 Display_Format">[Quote Item: Name]8<br/>[Quote Item: Item Description]</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!--第四个选择框-->
            <div class="Section" id="b4">
                <div class="Heading">
                    <div class="Toggle Collapse" id="a4">
                        <div class="Vertical"></div>
                        <div class="Horizontal"></div>
                    </div>
                    <span class="Text">分组名称设置</span>
                </div>
                <div class="DescriptionText" id="c4">定义周期类型分组名称和产品种类分名称</div>
                <div class="Content" id="d4">
                    <div class="Large Column">
                        <div class="Normal Column fl">
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>一次性收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="一次性收费" id="One_Time_items">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>月收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="月收费" id="Monthly_items">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>季收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="季收费" id="Quarterly_items">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>半年收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="半年收费" id="Semi_Annual_items">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>年收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="年收费" id="Yearly_items">
                                </div>
                            </div>
                        </div>
                        <div class="Normal Column fl">
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>配送费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="配送费" id="Shipping_items">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>一次性折扣</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="一次性折扣" id="One_Time_Discount_items">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>可选项</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="可选项" id="Optional_items">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>无分类</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="无分类" id="No_category">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
         <input id="data" type="hidden" name="data" value=""/>       
   <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../RichText/js/ueditor.config.js"></script>
    <script type="text/javascript" src="../RichText/js/ueditor.all.js"></script>
    <script type="text/javascript" src="../RichText/js/QuoteBody.js"></script>
          <asp:Literal ID="datalist" runat="server"></asp:Literal >
    <script type="text/javascript">
        $("#OkButton1").on("click", function () {
            //json格式
            var data = [];

            //表格显示字段设置
            data.push("{\"GRID_COLUMN\":[");
            for (i = 0; i < 8; i++) {
                var Order = $(".Order").eq(i).text();//显示顺序，从左到右
                var Column_Content = $(".Column_Content").eq(i).text();//字段内容
                var Column_label = $(".Column_label").eq(i).html();//显示名称            
            //此处存在问题
                var Display;
                if ($(".Display").eq(i).children().hasClass("CM"))
                {
                    Display = "yes";
                }
                if (!($(".Display").eq(i).children().hasClass("CM")))
                {
                    Display = "no";
                  
                }
                var GRID_COLUMNITEM = { "Order": Order, "Column_Content": Column_Content, "Column_label": Column_label, "Display": Display };
                var jsonArrayFinal = JSON.stringify(GRID_COLUMNITEM);
            data.push(jsonArrayFinal);
            console.log(jsonArrayFinal);
            }
            data.push("],\"GRID_OPTIONS\":[");
            //表格格式设置
            //显示表头
            if ($("#ShowGridHeader").attr("checked")) {
                var Show_grid_header = "yes";
            } else {
                var Show_grid_header = "no";
            }
            //显示表格的竖线
            if ($("#ShowVerticalGridlines").attr("checked")) {
                var Show_vertical_lines = "yes";
            }
            else {
                var Show_vertical_lines = "no";
            }
            if ($("#DisplayQuoteCommentInBody").attr("checked")) {
                var Show_QuoteComment = "yes";
            } else {
                var Show_QuoteComment = "no";
            }
            var GRID_OPTIONSITEM = { "Show_grid_header": Show_grid_header, "Show_vertical_lines": Show_vertical_lines, "Show_QuoteComment": Show_QuoteComment };

            var jsonArrayFinal = JSON.stringify(GRID_OPTIONSITEM);
            data.push(jsonArrayFinal);

            data.push("],\"CUSTOMIZE_THE_ITEM_COLUMN\":[");

            ////报价项字段设置
            for (i = 0; i < 8; i++) {
                var Type_of_Quote_Item = $(".Type_of_Quote_Item").eq(i).text();
                var Display_Format = $(".Display_Format").eq(i).text();
                var CUSTOMIZE_THE_ITEM_COLUMNITEM = {"Type_of_Quote_Item": Type_of_Quote_Item, "Display_Format": Display_Format };
                var jsonArrayFinal = JSON.stringify(CUSTOMIZE_THE_ITEM_COLUMNITEM);
                data.push(jsonArrayFinal);
                console.log(jsonArrayFinal);
            }

            //分组名称设置
            data.push("],\"GROUPING_HEADER_TEXT\":[");

            var One_Time_items = $("#One_Time_items").val();
            var Monthly_items = $("#Monthly_items").val();
            var Quarterly_items = $("#Quarterly_items").val();
            var Semi_Annual_items = $("#Semi_Annual_items").val();
            var Yearly_items = $("#Yearly_items").val();
            var Shipping_items = $("#Shipping_items").val();
            var One_Time_Discount_items = $("#One_Time_Discount_items").val();
            var Optional_items = $("#Optional_items").val();
            var No_category = $("#No_category").val();
            if (One_Time_items == null || One_Time_items == '') {
                alert("请输入一次性收费");
                return false;
            }
            if (Monthly_items == null || Monthly_items == '') {
                alert("请输入月收费");
                return false;
            }
            if (Quarterly_items == null || Quarterly_items == '') {
                alert("请输入季收费");
                return false;
            }
            if (Semi_Annual_items == null || Semi_Annual_items == '') {
                alert("请输入半年收费");
                return false;
            }
            if (Yearly_items == null || Yearly_items == '') {
                alert("请输入年收费");
                return false;
            }
            if (Shipping_items == null || Shipping_items == '') {
                alert("请输入配送收费");
                return false;

            }
            if (One_Time_Discount_items == null || One_Time_Discount_items == '') {
                alert("请输入一次性折扣收费");
                return false;
            }
            if (Optional_items == null || Optional_items == '') {
                alert("请输入“可选项”");
                return false;
            }
            if (No_category == null || No_category == '') {
                alert("请输入“无分类”");
                return false;
            }
        var GROUPING_HEADER_TEXTITEM = { "One_Time_items": One_Time_items, "Monthly_items": Monthly_items, "Quarterly_items": Quarterly_items, "Semi_Annual_items": Semi_Annual_items, "Yearly_items": Yearly_items, "Shipping_items": Shipping_items, "One_Time_Discount_items": One_Time_Discount_items, "Optional_items": Optional_items, "No_category": No_category};
        var jsonArrayFinal = JSON.stringify(GROUPING_HEADER_TEXTITEM);
        data.push(jsonArrayFinal);

        data.push("]}");

            $("#data").val(data);

        });
 $("#OkButton").on("mouseover",function(){
            $("#OkButton").css("background","#fff");
        });
        $("#OkButton").on("mouseout",function(){
            $("#OkButton").css("background","#f0f0f0");
        });
$(".Edit").on("click", function () {
          //  var i = $(this).index();
            var a = $('.Edit').index(this);
            var item = $(".Display_Format").eq(a).text();
           var returnValue = window.showModalDialog('Body_itemEdit.aspx?item='+item, window, 'dialogWidth=800px;dialogHeight=600px;status=no');

            if (returnValue !== "" && returnValue !== undefined) {
                //处理子窗口的返回值
                $(".Display_Format").eq(a).html(returnValue);
            }
        });
    </script>
</form>
</body>
</html>