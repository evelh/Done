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
                                                    <div class="Sort">1</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Item#</td>
                                            <td class="Text E XL U2">可修改的内容1
                                               <input id="data" type="hidden" name="data" value=""/>


                                               <%-- <asp:Label ID="Label1" runat="server" class="Text E XL U2" Text="可修改的内容1"></asp:Label>--%>
                                               <%-- <label class="Text E XL U2" name="1">可修改的内容1</label>--%>

                                            </td>
                                            <td class="Boolean E">
                                                <div class="Decoration Icon CheckMark CM"></div>
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
                                                    <div class="Sort">2</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Quantity</td>
                                            <td class="Text E XL U2">可修改的内容2</td>
                                            <td class="Boolean E">
                                                <div class="Decoration Icon CheckMark CM"></div>
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
                                                    <div class="Sort">3</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Item</td>
                                            <td class="Text E XL U2">可修改的内容3</td>
                                            <td class="Boolean E">
                                                <div class="Decoration Icon CheckMark CM"></div>
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
                                                    <div class="Sort">4</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Unit Price</td>
                                            <td class="Text E XL U2">可修改的内容4</td>
                                            <td class="Boolean E">
                                                <div class="Decoration Icon CheckMark CM"></div>
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
                                                    <div class="Sort">5</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Unit Discount</td>
                                            <td class="Text E XL U2">可修改的内容5</td>
                                            <td class="Boolean E">
                                                <div class="Decoration Icon CheckMark CM"></div>
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
                                                    <div class="Sort">6</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Adjusted Unit Price</td>
                                            <td class="Text E XL U2">可修改的内容6</td>
                                            <td class="Boolean E">
                                                <div class="Decoration Icon CheckMark CM"></div>
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
                                                    <div class="Sort">7</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Extended Price</td>
                                            <td class="Text E XL U2">可修改的内容7</td>
                                            <td class="Boolean E">
                                                <div class="Decoration Icon CheckMark CM"></div>
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
                                                    <div class="Sort">8</div>
                                                </div>
                                            </td>
                                            <td class="Text E U1">Discount %</td>
                                            <td class="Text E XL U2">可修改的内容8</td>
                                            <td class="Boolean E">
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
                                        <td class="Text U1">Labour</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]1
[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1">Product</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]2
[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1">Service or Bundle</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]3
[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1">Charge</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]4
[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1">Expense</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]5
[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1">One-Time Discount</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]6
[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1">Shipping</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]7
[Quote Item: Item Description]</td>
                                    </tr>
                                    <tr>
                                        <td class="Command U0" style="width:18px;">
                                            <div class="ButtonIcon Button Edit NormalState">
                                                <span class="Icon"></span>
                                            </div>
                                        </td>
                                        <td class="Text U1">Contract Setup Fee</td>
                                        <td class="FormatPreservation U2">[Quote Item: Name]8
[Quote Item: Item Description]</td>
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
                                    <input type="text" value="11111">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>月收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="2222">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>季收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="333">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>半年收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="444">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>年收费</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="555">
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
                                    <input type="text" value="11111">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>一次性折扣</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="2222">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>可选项</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="333">
                                </div>
                            </div>
                            <div class="EditorLabelContainer">
                                <div class="Label">
                                    <label>无分类</label>
                                </div>
                            </div>
                            <div class="Normal Editor TextBox">
                                <div class="InputField">
                                    <input type="text" value="444">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>



   <script src="../Scripts/jquery-3.1.0.min.js"></script>
    <script type="text/javascript" src="../RichText/js/ueditor.config.js"></script>
    <script type="text/javascript" src="../RichText/js/ueditor.all.js"></script>
    <script type="text/javascript" src="../RichText/js/QuoteBody.js"></script>
    <script>
    $("#OkButton1").on("click",function(){
           
         //如何获取修改后的值，传入后台
        var qq = $(".U2").eq(0).html();
        console.log(qq);
        $("#data").val(qq);

        });
        $("#OkButton").on("mouseover",function(){
            $("#OkButton").css("background","#fff");
        });
        $("#OkButton").on("mouseout",function(){
            $("#OkButton").css("background","#f0f0f0");
        });
    </script>
</body>
</html>