<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceTempBody.aspx.cs" Inherits="EMT.DoneNOW.Web.InvoiceTempBody" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../RichText/css/QuoteBody.css" rel="stylesheet" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
            <!--顶部  内容和帮助-->
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">发票模板主体</span>
                    <span class="text2">--<%=tempinfo.name %></span>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <!--中间form表单-->
            <div></div>
            <!--按钮部分-->
            <div class="ButtonContainer">
                <ul id="btn">
                    <li class="Button ButtonIcon Okey NormalState" id="OkButton" tabindex="0">
                        <span class="Icon Ok"></span>
                        <asp:Button ID="Save" OnClientClick="return save_deal()" runat="server" Text="确认" CssClass="Text" BorderStyle="None" OnClick="Save_Click" />
                        <input type="hidden" id="typetype" name="typetype" />
                        <input type="hidden" id="typett" name="typett" /><input type="hidden" id="data" name="data" />
                    </li>
                </ul>
            </div>
            <div class="ScrollingContainer">
                <div class="Instruction">定义显示在发票单上的字段，包括顺序和内容。还可以定义分组和排序字段。</div>
                <!--第一个选择框-->
                <div class="Section" id="b1">
                    <div class="Heading">
                        <div class="Toggle Collapse" id="a1">
                            <div class="Vertical"></div>
                            <div class="Horizontal"></div>
                        </div>
                        <span class="Text">表格显示字段设置</span>
                    </div>
                    <div class="DescriptionText" id="c1">指定显示的字段，可以修改显示名称、是否显示和显示顺序</div>
                    <div class="Content" id="d1">
                            <div class="Grid Medium">
                                <!--头部-->
                                <div class="HeaderContainer">
                                    <table cellpadding="0">
                                        <tbody>
                                            <tr class="HeadingRow">
                                                <td class="Interaction DragEnabled" style="width: 140px;">
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
                                                        <div class="Heading">显示名称<span class="Required">*</span></div>
                                                    </div>
                                                </td>
                                                <td class="Boolean">
                                                    <div class="Standard tc">
                                                        <div class="Heading">显示</div>
                                                    </div>
                                                </td>
                                                <td class="ScrollingBarSpacer" style="width: 15px;"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!--内容-->
                                <div class="RowContainer BodyContainer">
                                    <table cellpadding="0">
                                        <tbody>
                                            <tr class="D">
                                                <td class="Interaction" style="width: 131px;">
                                                    <div>
                                                        <div class="Decoration Icon DragHandle prev">
                                                            <img src="../RichText/img/prev.png" alt="">
                                                        </div>
                                                        <div class="Decoration Icon DragHandle next">
                                                            <img src="../RichText/img/next.png" alt="">
                                                        </div>
                                                        <div class="Sort Order">1</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">发票中显示序列号，从1开始</td>
                                                <td class="Text E XL U2 Column_label">发票中显示序列号，从1开始</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark CM Display"></div>
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
                                                <td class="Text E U1 Column_Content">条目创建日期</td>
                                                <td class="Text E XL U2 Column_label">条目创建日期</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark CM Display"></div>
                                                </td>
                                            </tr>
                                            <tr class="D">
                                                <td class="Interaction">
                                                    <div>
                                                        <div class="Decoration Icon DragHandle prev">
                                                            <img src="../RichText/img/prev.png" alt="">
                                                        </div>
                                                        <div class="Decoration Icon DragHandle next">
                                                            <img src="../RichText/img/next.png" alt="" />
                                                        </div>
                                                        <div class="Sort Order">3</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">条目描述</td>
                                                <td class="Text E XL U2 Column_label">条目描述</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark CM Display"></div>
                                                </td>
                                            </tr>
                                            <tr class="D">
                                                <td class="Interaction">
                                                    <div>
                                                        <div class="Decoration Icon DragHandle prev">
                                                            <img src="../RichText/img/prev.png" alt="" />
                                                        </div>
                                                        <div class="Decoration Icon DragHandle next">
                                                            <img src="../RichText/img/next.png" alt="" />
                                                        </div>
                                                        <div class="Sort Order">4</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">类型</td>
                                                <td class="Text E XL U2 Column_label">类型</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark CM Display"></div>
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
                                                        <div class="Sort Order">5</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">员工姓名</td>
                                                <td class="Text E XL U2 Column_label">员工姓名</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark CM Display"></div>
                                                </td>
                                            </tr>
                                            <tr class="D">
                                                <td class="Interaction">
                                                    <div>
                                                        <div class="Decoration Icon DragHandle prev">
                                                            <img src="../RichText/img/prev.png" alt="" />
                                                        </div>
                                                        <div class="Decoration Icon DragHandle next">
                                                            <img src="../RichText/img/next.png" alt="" />
                                                        </div>
                                                        <div class="Sort Order">6</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">计费时间</td>
                                                <td class="Text E XL U2 Column_label">计费时间</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark CM Display"></div>
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
                                                        <div class="Sort Order">7</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">数量</td>
                                                <td class="Text E XL U2 Column_label">数量</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark CM Display"></div>
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
                                                        <div class="Sort Order">8</div>
                                                    </div> 
                                                </td>
                                                <td class="Text E U1 Column_Content">费率/成本</td>
                                                <td class="Text E XL U2 Column_label">费率/成本</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark Display"></div>
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
                                                        <div class="Sort Order">9</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">税率</td>
                                                <td class="Text E XL U2 Column_label">税率</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark Display"></div>
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
                                                        <div class="Sort Order">10</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">税</td>
                                                <td class="Text E XL U2 Column_label">税</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark Display"></div>
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
                                                        <div class="Sort Order">11</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">计费总额</td>
                                                <td class="Text E XL U2 Column_label">计费总额</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark Display"></div>
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
                                                        <div class="Sort Order">12</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">小时费率</td>
                                                <td class="Text E XL U2 Column_label">小时费率</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark Display"></div>
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
                                                        <div class="Sort Order">13</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">角色</td>
                                                <td class="Text E XL U2 Column_label">角色</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark Display"></div>
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
                                                        <div class="Sort Order">14</div>
                                                    </div>
                                                </td>
                                                <td class="Text E U1 Column_Content">工作类型</td>
                                                <td class="Text E XL U2 Column_label">工作类型</td>
                                                <td class="Boolean E">
                                                    <div class="Decoration Icon CheckMark Display"></div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
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
                                        <input type="checkbox" id="ShowGridHeader" checked="checked" style="margin-top: 3px;" />
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>显示表头</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Editor CheckBox">
                                <div class="InputField">
                                    <div>
                                        <input type="checkbox" id="ShowVerticalGridlines" checked="checked" style="margin-top: 3px;">
                                    </div>
                                    <div class="EditorLabelContainer">
                                        <div class="Label">
                                            <label>显示表格的竖线</label>
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
                        <span class="Text">字段显示内容设置</span>
                    </div>
                    <div class="DescriptionText" id="c3">可以定义不同类型的条目描述字段显示内容</div>
                    <div class="Content" id="d3">
                        <div class="Grid Medium">
                            <div class="HeaderContainer">
                                <table cellpadding="0">
                                    <tbody>
                                        <tr class="HeadingRow">
                                            <td class="Interaction DragEnabled" style="width: 90px;">
                                                <div class="Standard">
                                                    <div class="Heading">排序</div>
                                                </div>
                                            </td>
                                            <td class="Command" style="width: 27px;">
                                                <div class="Standard">
                                                    <div></div>
                                                </div>
                                            </td>
                                            <td class="Text Dynamic" style="width: 130px;">
                                                <div class="Standard">
                                                    <div class="Heading">条目类型</div>
                                                </div>
                                            </td>
                                            <td class="FormatPreservation">
                                                <div class="Standard">
                                                    <div class="Heading">显示内容</div>
                                                </div>
                                            </td>
                                            <td class="FormatPreservation" style="width: 150px;">
                                                <div class="Standard">
                                                    <div class="Heading">其他设置</div>
                                                </div>
                                            </td>
                                            <td class="ScrollBarSpacer" style="width: 15px;"></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="RowContainer BodyContainer">
                                <table cellpadding="0">
                                    <tbody>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="SortOrder">1</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">工时<input type="hidden" class="invoice_type_id" value="1928" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="SortOrder">2</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">工时调整<input type="hidden" class="invoice_type_id" value="1929" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="SortOrder">3</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">成本（工单、项目、合同）<input type="hidden" class="invoice_type_id" value="1930" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="SortOrder">4</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">费用<input type="hidden" class="invoice_type_id" value="1931" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="SortOrder">5</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">订阅<input type="hidden" class="invoice_type_id" value="1932" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="SortOrder">6</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">定期服务/服务包<input type="hidden" class="invoice_type_id" value="1933" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="">
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="">
                                                    </div>
                                                    <div class="SortOrder">7</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">初始费用<input type="hidden" class="invoice_type_id" value="1934" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
                                        </tr>
                                        <tr class="D">
                                            <td class="Interaction U0" style="width: 81px;">
                                                <div>
                                                    <div class="Decoration Icon DragHandle prev">
                                                        <img src="../RichText/img/prev.png" alt="" />
                                                    </div>
                                                    <div class="Decoration Icon DragHandle next">
                                                        <img src="../RichText/img/next.png" alt="" />
                                                    </div>
                                                    <div class="SortOrder">8</div>
                                                </div>
                                            </td>
                                            <td class="Command U1" style="width: 19px;">
                                                <div class="ButtonIcon Button Edit NormalState">
                                                    <span class="Icon"></span>
                                                </div>
                                            </td>
                                            <td class="Text U2 invoice_type_name" style="width: 121px;">里程碑<input type="hidden" class="invoice_type_id" value="1935" />
                                            </td>
                                            <td class="FormatPreservation U3 Display_Format"></td>
                                            <td class="FormatPreservation U4 Add_Display_Format" style="width: 141px;"></td>
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
                    <div class="DescriptionText" id="c4"></div>
                    <div class="Content" id="d4">
                        <div class="Large Column">
                            <div class="Normal Column fl">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="GroupBy">分组条件</label>
                                    </div>
                                </div>
                                <div class="Normal Editor SingleSelect" style="padding-bottom: 15px;">
                                    <div class="InputField">
                                        <asp:DropDownList ID="GroupBy" runat="server"></asp:DropDownList>
                                        <img id="setset" src="../RichText/img/set.png" style="vertical-align: middle; cursor: pointer;" />
                                    </div>
                                </div>
                                <div class="Normal Editor CheckBox" style="padding-bottom: 10px;">
                                    <div class="InputField">
                                        <div>
                                            <asp:CheckBox ID="ShowLabelsWhenGrouped" runat="server" />
                                        </div>
                                        <div class="EditorLabelContainer">
                                            <div class="Label">
                                                <label for="ShowLabelsWhenGrouped">条目描述显示标题</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="Itemize">显示条目</label>
                                    </div>
                                </div>
                                <div class="Normal Editor SingleSelect" style="padding-bottom: 10px;">
                                    <div class="InputField">
                                        <asp:DropDownList ID="Itemize" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="Normal Column fl">
                                <div class="EditorLabelContainer">
                                    <div class="Label">
                                        <label for="SortBy">排序字段</label>
                                    </div>
                                </div>
                                <div class="Normal Editor SingleSelect" style="padding-bottom: 10px;">
                                    <div class="InputField">
                                        <asp:DropDownList ID="SortBy" runat="server"></asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
           <%-- 第一个弹窗--%>
            <div id="editedit" style="display: none">
                <div class="addText">
                    <div>
                        <div class="CancelDialogButton" id="tanchuang1"></div>
                        <div class="TitleBar">
                            <div class="Title"><span class="text1">编辑项目列</span><span class="text2"></span></div>
                        </div>
                        <div class="ButtonContainer" style="position: relative; z-index: 1000;">
                            <ul>
                                <li class="Button addButtonIcon Okey NormalState" id="addadd" tabindex="0"><span class="Icon Ok"></span><span class="Text">确认</span></li>
                                <li class="Button addButtonIcon Cancel NormalState" id="resetreset" tabindex="0"><span class="Icon Reset"></span><span class="Text">恢复默认</span></li>
                            </ul>
                        </div>
                        <div style="position: absolute; left: 0; overflow-y: auto; right: 0; top: 0px; bottom: 0px;">
                            <div class="ScrollingContainer">
                                <div class="Heading">条目类型格式</div>
                                <div class="addDescriptionText"></div>
                                <div class="addContent" style="height: 310px; position: relative; top: 66px;">
                                    <script id="containerHead" name="content" type="text/plain" style="display: block;"></script>
                                    <div class="Dialog" style="left: 525px; top: -60px;">
                                        <img src="../RichText/img/Dialog.png">
                                    </div>
                                </div>
                                <%-- 工时--%>
                                <div id="kkk1" style="display: none">
                                    <div class="Section Collapsed" style="margin-left: 16px; z-index: 1000;width:96%;">
                                        <div class="Heading">
                                            <div class="Toggle Collapse Toggle1">
                                                <div class="Vertical"></div>
                                                <div class="Horizontal"></div>
                                            </div>
                                            <span class="Text">其他信息设置</span>
                                        </div>
                                        <div class="Content">
                                            <div class="Normal Column">
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label class="typetype_name">工时显示该字段</label>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor CheckBox">
                                                    <div class="InputField">
                                                        <div>
                                                            <input type="checkbox" class="typetype_value" style="margin-top: 3px;" <%if(addset.Labour_Item!=null&&addset.Labour_Item[0].value == "checked") {%> checked="checked" <%} %> />
                                                        </div>
                                                        <div class="EditorLabelContainer">
                                                            <div class="Label">
                                                                <label class="typetype_name">显示定期服务合同工时</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor CheckBox">
                                                    <div class="InputField">
                                                        <div>
                                                            <input type="checkbox" class="typetype_value" style="margin-top: 3px;" <%if (addset.Labour_Item!=null&&addset.Labour_Item[1].value == "checked") {%> checked="checked" <%} %> />
                                                        </div>
                                                        <div class="EditorLabelContainer">
                                                            <div class="Label">
                                                                <label class="typetype_name">显示固定合同工时(如果不勾选则不显示这两种合同的工时，其他工时总是显示)</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="Normal Column">
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label class="typetype_name">费率单位显示</label>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor TextBox">
                                                    <div class="InputField">
                                                        <input class="typetype_value" type="text" <%if (addset.Labour_Item!= null)
                                                            {%>
                                                            value="<%=addset.Labour_Item[2].value %><%} %>" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="Section Collapsed" style="margin-left: 16px;width:96%;">
                                        <div class="Heading">
                                            <div class="Toggle Collapse Toggle2">
                                                <div class="Vertical"></div>
                                                <div class="Horizontal"></div>
                                            </div>
                                            <span class="Text">计费总额字段内容例外设置</span>
                                        </div>
                                        <div class="Content">
                                            <div class="Normal Column">
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label class="typetype_name">定期服务合同、固定价格合同、事件合同</label>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor TextBox">
                                                    <div class="InputField">
                                                        <input class="typetype_value" type="text" <%if (addset.Labour_Item!= null) {%> value="<%=addset.Labour_Item[3].value %>"<%} else { %> value="合同已包" <%} %> />
                                                    </div>
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label class="typetype_name">预付时间合同、预付费用合同</label>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor TextBox">
                                                    <div class="InputField">
                                                        <input class="typetype_value" type="text" <%if (addset.Labour_Item!= null)
                                                            {%>
                                                            value="<%=addset.Labour_Item[4].value %>" <%}
                                                            else
                                                            {%>
                                                            value="预支付"
                                                            <%} %> />
                                                    </div>
                                                </div>
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label class="typetype_name">不计费工时</label>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor TextBox">
                                                    <div class="InputField">
                                                        <input class="typetype_value" type="text" <%if (addset.Labour_Item!= null)
                                                            {%>
                                                            value="<%=addset.Labour_Item[5].value %>" <%}
                                                            else
                                                            {%>
                                                            value="不计费"
                                                            <%} %> />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <%--服务或服务包--%>
                                <div id="kkk2" style="display: none">
                                    <div class="Section Collapsed" style="margin-left: 16px; z-index: 1000;">
                                        <div class="Heading">
                                            <div class="Toggle Collapse Toggle3">
                                                <div class="Vertical"></div>
                                                <div class="Horizontal"></div>
                                            </div>
                                            <span class="Text">其他信息设置</span>
                                        </div>
                                        <div class="Content">
                                            <div class="Normal Column">
                                                <div class="EditorLabelContainer">
                                                    <div class="Label">
                                                        <label>调整显示内容和样式 </label>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor CheckBox">
                                                    <div class="InputField">
                                                        <div>
                                                            <input class="typetype_value" type="checkbox" style="margin-top: 3px;" <%if (addset.Service_Bundle_Item!=null&&addset.Service_Bundle_Item[0].value == "checked")
                                                                { %>
                                                                checked="checked" <%} %> />
                                                        </div>
                                                        <div class="EditorLabelContainer">
                                                            <div class="Label">
                                                                <label class="typetype_name">显示定时服务/服务包详情（分组时不起作用）</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="Normal Editor CheckBox">
                                                    <div class="InputField">
                                                        <div>
                                                            <input class="typetype_value" type="checkbox" style="margin-top: 3px;" <%if (addset.Service_Bundle_Item!=null&&addset.Service_Bundle_Item[1].value == "checked")
                                                                { %>
                                                                checked="checked" <%} %> />
                                                        </div>
                                                        <div class="EditorLabelContainer">
                                                            <div class="Label">
                                                                <label class="typetype_name">显示总额为0的条目</label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="AlertBox">
                            <div>
                                <div class="CancelDialogButton1"></div>
                                <div class="AlertTitleBar">
                                    <div class="AlertTitle"><span>变量</span></div>
                                </div>
                                <div class="VariableInsertion">
                                    <div class="AlertContent">
                                        <div class="AlertContentTitle">这是弹出的变量内容，可双击选择</div>
                                        <asp:ScriptManager ID="ScriptManager1" runat="server">
                                        </asp:ScriptManager>
                                        <asp:UpdatePanel ID="UpdatePanelkk" runat="server" ChildrenAsTriggers="True">
                                            <ContentTemplate>
                                                <asp:DropDownList ID="Variable" runat="server" OnSelectedIndexChanged="Variable_SelectedIndexChanged" AutoPostBack="True"></asp:DropDownList>
                                                <select name="" multiple="multiple" id="AlertVariableList">
                                                    <asp:Literal ID="VariableList" runat="server"></asp:Literal>
                                                </select>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="BackgroundOverLay1" style="display: block;"></div>
            </div>
           <%-- 结束--%>

           <%-- 第二个弹窗--%>
             <div id="editedit2" style="display: none;">
            <div class="addText">
                <div>
                    <div class="CancelDialogButton" id="tanchuang2"></div>
                    <div class="TitleBar">
                        <div class="Title">
                            <span class="text1">CONFIGURE ROLL UP DESCRIPTIONS</span>
                        </div>
                    </div>
                        <div class="ButtonContainer">
                            <ul>
                                <li class="Button addButtonIcon Okey NormalState" id="addOkButton2" tabindex="0">
                                    <span class="Icon Ok"></span>
                                    <span class="Text">确认</span>
                                </li>
                            </ul>
                        </div>
                    <div style="position: absolute;left: 0;overflow-y: auto;right: 0;top: 78px;bottom: 0px;">
                        <div class="ScrollingContainer" style="top:0;">
                            <div class="Section">
                                <div class="Heading">
                                    <span class="Text">Customize the Roll Up Description</span>
                                </div>
                                <div class="DescriptionText">You may customize the content that is displayed in the roll up row for each billing item type.  You may also specify the order in which the roll ups display on the invoice by dragging and dropping the Sort Order column.</div>
                                <div class="Content">
                                    <div class="Large Column">
                                        <div class="Grid Small">
                                            <div class="HeaderContainer">
                                                <table cellpadding="0">
                                                    <tbody>
                                                        <tr class="HeadingRow">
                                                            <td class="Interaction DragEnabled" style="width: 90px;">
                                                                <div class="Standard">
                                                                    <div class="Heading">排序</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command" style="width: 27px;">
                                                                <div class="Standard">
                                                                    <div></div>
                                                                </div>
                                                            </td>
                                                            <td class="Text Dynamic" style="width: 130px;">
                                                                <div class="Standard">
                                                                    <div class="Heading">条目类型</div>
                                                                </div>
                                                            </td>
                                                            <td class="FormatPreservation" style="width: 60px">
                                                                <div class="Standard">
                                                                    <div class="Heading">分组描述</div>
                                                                </div>
                                                            </td>
                                                            <td class="FormatPreservation" style="width:auto;">
                                                                <div class="Standard">
                                                                    <div class="Heading">分组描述的描述</div>
                                                                </div>
                                                            </td>
                                                            <td class="ScrollBarSpacer" style="width: 16px;border-right: none;"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="RowContainer BodyContainer">
                                                <table cellpadding="0">
                                                    <tbody>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">1</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">
                                                                工时<input type="hidden" class="add_invoice_type_id" value="1928" />
                                                            </td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">2</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">工时调整<input type="hidden" class="add_invoice_type_id" value="1929" />
                                                            </td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">3</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">成本（工单、项目、合同<input type="hidden" class="add_invoice_type_id" value="1930" />
                                                            </td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">4</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">费用<input type="hidden" class="add_invoice_type_id" value="1931" />
                                                            </td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">5</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">订阅<input type="hidden" class="add_invoice_type_id" value="1932" />
                                                            </td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">6</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">定期服务/服务包<input type="hidden" class="add_invoice_type_id" value="1933" />
                                                            </td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">7</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">初始费用<input type="hidden" class="add_invoice_type_id" value="1934" /></td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="Interaction U0" style="width: 81px;">
                                                                <div>
                                                                    <div class="Decoration Icon DragHandle prev">
                                                                        <img src="../RichText/img/prev.png" alt="">
                                                                    </div>
                                                                    <div class="Decoration Icon DragHandle next">
                                                                        <img src="../RichText/img/next.png" alt="">
                                                                    </div>
                                                                    <div class="add_Order">8</div>
                                                                </div>
                                                            </td>
                                                            <td class="Command U1" style="width: 19px;">
                                                                <div class="ButtonIcon Button Edit3 NormalState">
                                                                    <span class="Icon"></span>
                                                                </div>
                                                            </td>
                                                            <td class="Text U2 add_invoice_type_name" style="width: 121px;">里程碑<input type="hidden" class="add_invoice_type_id" value="1935" /></td>
                                                            <td class="U3" style="width:53px;">
                                                                <div class="Decoration Icon CheckMark CM add_Display"></div>
                                                            </td>
                                                            <td class="U4 add_Display_Format" style="width:auto;">[Billing Item: Type]: [Billing Item: Billing Code]</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="BackgroundOverLay2" style="display: block;"></div>
        </div>

             <%-- 结束--%>
                <%-- 第三个弹窗--%>
             <div id="editedit3" style="display: none">
              <div class="addText">
                    <div>
                        <div class="CancelDialogButton" id="tanchuang3"></div>
                        <div class="TitleBar">
                            <div class="Title"><span class="text1">编辑项目列</span><span class="text2"></span></div>
                        </div>
                        <div class="ButtonContainer" style="position: relative; z-index: 1000;">
                            <ul>
                                <li class="Button addButtonIcon Okey NormalState" id="addadd3" tabindex="0"><span class="Icon Ok"></span><span class="Text">确认</span></li>
                                <li class="Button addButtonIcon Cancel NormalState" id="resetreset3" tabindex="0"><span class="Icon Reset"></span><span class="Text">恢复默认</span></li>
                            </ul>
                        </div>
                    
                       <div style="position: absolute; left: 0; overflow-y: auto; right: 0; top: 0px; bottom: 0px;">
                            <div class="ScrollingContainer">
                                <div class="Heading">
                                    <input type="checkbox" id="xuanze3" style="margin-top:4px;"/>Roll up by Roll Up Description
                                </div>
                                <div class="addDescriptionText"></div>
                                <div class="addContent" style="height: 310px; position: relative; top: -6px;">
                                    <script id="containerHead3" name="content" type="text/plain" style="display: block;"></script>
                                    <div class="Dialog" style="left: 525px; top:15px;">
                                        <img src="../RichText/img/Dialog.png"/>
                                    </div>
                                </div>                               
                            </div>
                        </div>
                        <div class="AlertBox">
                            <div>
                                <div class="CancelDialogButton1"></div>
                                <div class="AlertTitleBar">
                                    <div class="AlertTitle"><span>变量</span></div>
                                </div>
                                <div class="VariableInsertion">
                                    <div class="AlertContent">
                                        <div class="AlertContentTitle">这是弹出的变量内容，可双击选择</div>
                                      <%--  <asp:ScriptManager ID="ScriptManager2" runat="server">
                                        </asp:ScriptManager>--%>
                                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" ChildrenAsTriggers="True">
                                            <ContentTemplate>
                                                <asp:DropDownList ID="GetVaild" runat="server" AutoPostBack="True" OnSelectedIndexChanged="GetVaild_SelectedIndexChanged"></asp:DropDownList>
                                                <select name="" multiple="multiple" id="AlertVariableList3">
                                                    <asp:Literal ID="GetVaildlist" runat="server"></asp:Literal>
                                                </select>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="BackgroundOverLay3" style="display: block;"></div>
            </div>
             <%-- 结束--%>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
        <script src="../RichText/js/ueditor.config.js"></script>
        <script src="../RichText/js/ueditor.all.js"></script>
        <script src="../RichText/js/InvoiceTemplateInvoiceBody.js"></script>
        <asp:Literal ID="datalist" runat="server"></asp:Literal>
        <script>
            var colors = ["#efefef", "white"];
            var index1 = 0;
            var index2 = 0;
            var index3 = 0;
            $(".Toggle1").on("click", function () {
                $(this).find($(".Vertical")).toggle();
                $(this).parent().parent().find($('.Content')).toggle();
                $(this).parent().parent().css("background", colors[index1 % 2]);
                index1++;
            });
            $(".Toggle2").on("click", function () {
                $(this).find($(".Vertical")).toggle();
                $(this).parent().parent().find($('.Content')).toggle();
                $(this).parent().parent().css("background", colors[index2 % 2]);
                index2++;
            });
            $(".Toggle3").on("click", function () {
                $(this).find($(".Vertical")).toggle();
                $(this).parent().parent().find($('.Content')).toggle();
                $(this).parent().parent().css("background", colors[index3 % 2]);
                index3++;
            });
            var tanchuan = 1;
            $(".Edit").on("click", function () {
                var a = $(".Edit").index(this);
                $("#showbill").hide();
                $("#editedit2").hide();
                var innerContent = $(".Edit").eq(a).parent().next().next().html();
                var k = $(".invoice_type_name").eq(a).text();
                if (k == "工时") {//工时，特殊
                    $("#kkk1").show();
                } else {
                    $("#kkk1").hide();
                }
                if (k == "定期服务/服务包") {//服务包
                    $("#kkk2").show();
                } else {
                    $("#kkk2").hide();
                }
                $("#editedit").show();
                
                //富文本编辑器
                var ue = UE.getEditor('containerHead', {
                    toolbars: [
                        ['source', 'fontfamily', 'fontsize', 'bold', 'italic', 'underline', 'fontcolor', 'backcolor', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 'undo', 'redo']
                    ],
                    initialFrameHeight: 270,//设置编辑器高度
                    initialFrameWidth: 780, //设置编辑器宽度
                    wordCount: false,
                    elementPathEnabled : false,
                    autoHeightEnabled: false  //设置滚动条
                });

                ue.ready(function () {
                    //获取html内容  返回：<p>内容</p>
                    var html = ue.getContent();
                    //获取纯文本内容  返回：内容
                    var txt = ue.getContentTxt();
                    ue.setContent(innerContent);
                    $(".Dialog").on("click", function () {
                        $("#BackgroundOverLay1").show();
                        $(".AlertBox").show();
                    });
                    $(".CancelDialogButton1").on("click", function () {
                        $("#BackgroundOverLay1").hide();
                        $(".AlertBox").hide();
                    });                    
                });
                $("#addadd").on("mouseover", function () {
                    $("#addadd").css("background", "#fff");
                });
                $("#addadd").on("mouseout", function () {
                    $("#addadd").css("background", "#f0f0f0");
                });
                $("#resetreset").on("mouseover", function () {
                    $("#resetreset").css("background", "#fff");
                });
                $("#resetreset").on("mouseout", function () {
                    $("#resetreset").css("background", "#f0f0f0");
                }); 
                //恢复默认
                $("#resetreset").on("click", function () {
                    ue.setContent("[发票：号码/编号]<br/>[发票：税收详细信息]");
                })
                // 点击确定数据保存至后台  在展示页展示
                $("#addadd").on("click", function () {
                    var html = ue.getContent();
                    var txt = ue.getContentTxt(); 
                        var k = $(".invoice_type_name").eq(a).text();
                        $(".Edit").eq(a).parent().next().next().html(html);
                        if (k == "工时") {//工时，特殊   
                            $(".Edit").eq(a).parent().next().next().next().html('');
                            var tt = '';
                            if ($(".typetype_value").eq(0).is(':checked')) {
                                tt = tt + "显示定期服务合同工时";
                            }
                            if ($(".typetype_value").eq(1).is(':checked')) {
                                tt = tt + "显示固定合同工时(如果不勾选则不显示这两种合同的工时，其他工时总是显示)";
                            }
                            $(".Edit").eq(a).parent().next().next().next().html(tt);
                        }
                        if (k == "定期服务/服务包") {//服务包
                            $(".Edit").eq(a).parent().next().next().next().html('');
                            var tt = '';
                            if ($(".typetype_value").eq(6).is(':checked')) {
                                tt = tt + "显示定时服务/服务包详情（分组时不起作用）";
                            }
                            if ($(".typetype_value").eq(7).is(':checked')) {
                                tt = tt + "显示总额为0的条目";
                            }
                            $(".Edit").eq(a).parent().next().next().next().html(tt);
                        } 
                    //}                                
                    $("#editedit").hide();        
                    a = -10;
                    return a;
                });
                //点击关闭
                $(".CancelDialogButton").on("click", function () {
                    $("#editedit").hide();                 
                    a = -10;
                    return a;
                })
            });
            $("#OkButton").on("mouseover", function () {
                $("#OkButton").css("background", "#fff");
            });
            $("#OkButton").on("mouseout", function () {
                $("#OkButton").css("background", "#f0f0f0");
            });

            //双击选中事件
            function dbclick(val) {
                UE.getEditor('containerHead').focus();
                UE.getEditor('containerHead').execCommand('inserthtml', $(val).html());
                $("#BackgroundOverLay").hide();
                $(".AlertBox").hide();
            }

            //保存
         function save_deal() {
                //json格式
                var data = [];
                //表格显示字段设置
                data.push("{\"GRID_COLUMN\":[");
                for (i = 0; i < 14; i++) {
                    var Order = $(".Order").eq(i).text();//显示顺序，从左到右
                    var Column_Content = $(".Column_Content").eq(i).text();//字段内容
                    var Column_label = $(".Column_label").eq(i).html();//显示名称            
                    var Display;
                    if ($(".Display").eq(i).hasClass("CM")) {
                        Display = "yes";
                    }
                    if (!($(".Display").eq(i).hasClass("CM"))) {
                        Display = "no";
                    }
                    var GRID_COLUMNITEM = { "Order": Order, "Column_Content": Column_Content, "Column_label": Column_label, "Display": Display };
                    var jsonArrayFinal = JSON.stringify(GRID_COLUMNITEM);
                    data.push(jsonArrayFinal);
                    console.log(jsonArrayFinal);
                }
                data.push("],\"GRID_OPTIONS\":[");
                //显示表头
                if ($("#ShowGridHeader").is(':checked')) {
                    var Show_grid_header = "yes";
                } else {
                    var Show_grid_header = "no";
                }
                //显示表格的竖线
                if ($("#ShowVerticalGridlines").is(':checked')) {
                    var Show_vertical_lines = "yes";
                }
                else {
                    var Show_vertical_lines = "no";
                }
                var GRID_OPTIONSITEM = { "Show_grid_header": Show_grid_header, "Show_vertical_lines": Show_vertical_lines };

                var jsonArrayFinal = JSON.stringify(GRID_OPTIONSITEM);
                data.push(jsonArrayFinal);
                ////报价项字段设置
                data.push("],\"CUSTOMIZE_THE_ITEM_COLUMN\":[");
                for (i = 0; i < 8; i++) {
                    var Order = $(".SortOrder").eq(i).text();//显示顺序，从左到右
                    var Type_of_Invoice_Item_ID = $(".invoice_type_id").eq(i).val();
                    var Type_of_Invoice_Item = $(".invoice_type_name").eq(i).text();
                    var Display_Format = $(".Display_Format").eq(i).text();
                    var Add_Display_Format = $(".Add_Display_Format").eq(i).text();
                    var CUSTOMIZE_THE_ITEM_COLUMNITEM = { "Order": Order, "Type_of_Invoice_Item_ID": Type_of_Invoice_Item_ID, "Type_of_Invoice_Item": Type_of_Invoice_Item, "Display_Format": Display_Format, "Add_Display_Format": Add_Display_Format };
                    var jsonArrayFinal = JSON.stringify(CUSTOMIZE_THE_ITEM_COLUMNITEM);
                    data.push(jsonArrayFinal);
                    console.log(jsonArrayFinal);
                }
                data.push("],\"ADD_THE_ITEM_COLUMN\":[");
                for (i = 0; i < 8; i++) {
                    var Order = $(".add_Order").eq(i).text();//显示顺序，从左到右
                    var Type_of_Invoice_Item_ID = $(".add_invoice_type_id").eq(i).val();
                    if ($(".add_Display").eq(i).hasClass("CM")) {
                        Display = "yes";
                    }
                    if (!($(".add_Display").eq(i).hasClass("CM"))) {
                        Display = "no";
                    }
                    var Type_of_Invoice_Item = $(".add_invoice_type_name").eq(i).text();
                    var Display_Format = $(".add_Display_Format").eq(i).text();
                    var CUSTOMIZE_THE_ITEM_COLUMNITEM = { "Order": Order, "Type_of_Invoice_Item_ID": Type_of_Invoice_Item_ID, "Type_of_Invoice_Item": Type_of_Invoice_Item, "Display_Format": Display_Format };
                    var jsonArrayFinal = JSON.stringify(CUSTOMIZE_THE_ITEM_COLUMNITEM);
                    data.push(jsonArrayFinal);
                    console.log(jsonArrayFinal);
                }

                data.push("]}");
                $("#data").val($('<div/>').text(data).html());
                //工时
                var data1 = [];
                //表格显示字段设置
                data1.push("{\"Item\":[");
                var name = $(".typetype_name").eq(0).text();
                var value = '';
                if ($(".typetype_value").eq(0).is(':checked')) {
                    value = "checked";
                }
                var Item = { "id": "0", "name": name, "value": value };
                var jsonArrayFinal = JSON.stringify(Item);
                data1.push(jsonArrayFinal);
                var name = $(".typetype_name").eq(1).text();
                var value = '';
                if ($(".typetype_value").eq(1).is(':checked')) {
                    value = "checked";
                }
                var Item = { "id": "0", "name": name, "value": value };
                var jsonArrayFinal = JSON.stringify(Item);
                data1.push(jsonArrayFinal);
                for (i = 2; i < 6; i++) {
                    var name = $(".typetype_name").eq(i).text();
                    var value = $(".typetype_value").eq(i).val();
                    var Item = { "id": "0", "name": name, "value": value };
                    var jsonArrayFinal = JSON.stringify(Item);
                    data1.push(jsonArrayFinal);
                }  
                data1.push("]}");
                $("#typetype").val($('<div/>').text(data1).html());
                //服务
                var data2 = [];
                //表格显示字段设置
                data2.push("{\"Item\":[");
                var name = $(".typetype_name").eq(6).text();
                var value = '';
                if ($(".typetype_value").eq(6).is(':checked')) {
                    value = "checked";
                }
                var Item = { "id": "0", "name": name, "value": value };
                var jsonArrayFinal = JSON.stringify(Item);
                data2.push(jsonArrayFinal);

                var name = $(".typetype_name").eq(7).text();
                var value = '';
                if ($(".typetype_value").eq(7).is(':checked')) {
                    value = "checked";
                }
                var Item = { "id": "0", "name": name, "value": value };
                var jsonArrayFinal = JSON.stringify(Item);
                data2.push(jsonArrayFinal);
                data2.push("]}");
                $("#typett").val($('<div/>').text(data2).html());                
            }
            $("#GroupBy").change(function () {
                if ($("#GroupBy").val() == $("#GroupBy option:first").val()) {
                    $("#Itemize").attr("disabled","disabled");
                } else {
                    $("#Itemize").removeAttr("disabled", "disabled");
                }
                if ($("#GroupBy").val() == $("#GroupBy option:last").val()) {

                }
            });
            $("#setset").click(function () {
                if ($("#GroupBy").val() == $("#GroupBy option:last").val()) {
                    $("#editedit2").show();                   
                }
            });
            //点击关闭
            $("#tanchuang2").on("click", function () {
                $("#editedit2").hide();
            })
            $("#addOkButton2").on("click", function () {
                $("#editedit2").hide();
            })
            $(".Edit3").on("click", function () {
                var b = $(".Edit3").index(this);
                if ($(".add_Display").eq(b).hasClass("CM")) {
                    $("#xuanze3").attr("checked", true);
                } else {
                    $("#xuanze3").removeAttr("checked");
                }
                var innerContent = $(".Edit3").eq(b).parent().next().next().next().html();
                $("#editedit2").hide();
                $("#editedit3").show();
                //富文本编辑器
                //UE.delEditor('containerHead');
                var ue = UE.getEditor('containerHead3', {
                    toolbars: [
                        ['source', 'fontfamily', 'fontsize', 'bold', 'italic', 'underline', 'fontcolor', 'backcolor', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 'undo', 'redo']
                    ],
                    initialFrameHeight: 270,//设置编辑器高度
                    initialFrameWidth: 780, //设置编辑器宽度
                    wordCount: false,
                    elementPathEnabled : false,
                    autoHeightEnabled: false  //设置滚动条
                });
                ue.ready(function () {
                    //获取html内容  返回：<p>内容</p>
                    var html = ue.getContent();
                    //获取纯文本内容  返回：内容
                    var txt = ue.getContentTxt();
                    ue.setContent(innerContent);
                    $(".Dialog").on("click", function () {
                        $("#BackgroundOverLay1").show();
                        $(".AlertBox").show();
                    });
                    $(".CancelDialogButton1").on("click", function () {
                        $("#BackgroundOverLay1").hide();
                        $(".AlertBox").hide();
                    });
                });
                $("#addadd3").on("mouseover", function () {
                    $("#addadd3").css("background", "#fff");
                });
                $("#addadd3").on("mouseout", function () {
                    $("#addadd3").css("background", "#f0f0f0");
                });
                $("#resetreset3").on("mouseover", function () {
                    $("#resetreset3").css("background", "#fff");
                });
                $("#resetreset3").on("mouseout", function () {
                    $("#resetreset3").css("background", "#f0f0f0");
                }); 
                //恢复默认
                $("#resetreset3").on("click", function () {
                    ue.setContent("[Billing Item: Type]: [Billing Item: Billing Code]");
                }); 
                // 点击确定数据保存至后台  在展示页展示
                $("#addadd3").on("click", function () {
                    var html = ue.getContent();
                    var txt = ue.getContentTxt();  
                    if ($("#xuanze3").is(':checked')) {
                        $(".add_Display").eq(b).addClass("CM");
                          
                    } else {
                        $(".add_Display").eq(b).removeClass("CM");
                    }

                    $(".Edit3").eq(b).parent().next().next().next().html(html);
                    $("#editedit3").hide();
                    $("#editedit2").show();
                    b = -9;
                    return b;
                });
                //点击关闭
                $("#tanchuang3").on("click", function () {
                    $("#editedit3").hide();
                    $("#editedit2").show();
                    b = -9;
                    return b;
                })
            });
        </script>
    </form>
</body>
</html>
