<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoicePreview.aspx.cs" Inherits="EMT.DoneNOW.Web.Invoice.InvoicePreview" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>发票预览</title>
    <link href="../Content/reset.css" rel="stylesheet" />
    <style>
        body {
            overflow: hidden;
        }
        /*顶部内容和帮助*/
        .TitleBar {
            color: #fff;
            background-color: #346a95;
            display: block;
            font-size: 15px;
            font-weight: bold;
            height: 36px;
            line-height: 38px;
            margin: 0;
        }

            .TitleBar > .Title {
                top: 0;
                height: 36px;
                left: 10px;
                overflow: hidden;
                position: absolute;
                text-overflow: ellipsis;
                text-transform: uppercase;
                white-space: nowrap;
                width: 95%;
            }

        .help {
            background-image: url(../Images/help.png);
            cursor: pointer;
            display: inline-block;
            height: 16px;
            position: absolute;
            right: 10px;
            top: 10px;
            width: 16px;
            border-radius: 50%;
        }
        /*按钮*/
        .ButtonBar {
            font-size: 12px;
            padding: 0 10px 10px 10px;
            width: auto;
            background-color: #FFF;
        }

            .ButtonBar ul {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 26px;
                width: 100%;
            }

                .ButtonBar ul li {
                    display: block;
                    float: left;
                    margin: 0 5px;
                }

                    .ButtonBar ul li a {
                        background: #d7d7d7;
                        background: -moz-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -webkit-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: -ms-linear-gradient(top,#fff 0,#d7d7d7 100%);
                        background: linear-gradient(to bottom,#fff 0,#d7d7d7 100%);
                        border: 1px solid #bcbcbc;
                        display: inline-block;
                        color: #4F4F4F;
                        cursor: pointer;
                        padding: 0 5px 0 3px;
                        position: relative;
                        text-decoration: none;
                        vertical-align: middle;
                        height: 22px;
                    }

                        .ButtonBar ul li a span.Text {
                            line-height: 23px;
                        }

                        .ButtonBar ul li a span.Text, .contentButton a span.Text, a.buttons span.Text, input.button span.Text {
                            font-size: 12px;
                            font-weight: bold;
                            padding: 0 1px 0 3px;
                            color: #4F4F4F;
                            vertical-align: top;
                        }

        div.ButtonBar img.ButtonRightImg {
            margin: 4px 1px 0 2px;
        }

        div.ButtonBar li.right {
            float: right;
        }

        .ButtonBar ul li.pagination a, .ButtonBar ul li.pagination a:visited, .ButtonBar ul li.pagination a:hover {
            background: none;
            border: none;
            text-decoration: none;
        }

        div.ButtonBar a.disabledLink span.Text, .ButtonBar ul li a:link.disabledLink span.Text, div.ButtonBar a:hover.disabledLink span.Text, .NavigationTabBar ul li a:link.disabledLink span.Text, a:visited.disabledLink span.Text, a:hover.disabledLink span.Text, a:active.disabledLink span.Text {
            color: #949494;
        }

        .ButtonBar ul li a span.Text, .contentButton a span.Text, a.buttons span.Text, input.button span.Text {
            font-size: 12px;
            font-weight: bold;
            padding: 0 1px 0 3px;
            color: #4F4F4F;
            vertical-align: top;
        }
        /*下拉菜单*/
        .DropDownMenu {
            background-color: #FFF;
            padding: 16px;
            border: 1px solid #BCBCBC;
            cursor: pointer;
            box-shadow: 1px 1px 4px rgba(0,0,0,0.33);
            position: fixed;
            top: 70px;
            left: 220px;
            z-index: 40;
            display: none;
        }

        .DropDownMenuItem {
            min-height: 24px;
        }

        .DropDownMenuItemHeaderText {
            padding: 3px 25px 3px 0;
        }

        .DropDownMenuSectionHeaderText, .DropDownMenuSectionSecondaryHeaderText {
            padding: 0;
            color: #333;
            font-size: 12px;
            font-weight: bold;
            text-align: left;
            cursor: default;
        }

        .DropDownMenuItemSeparator {
            height: 1px;
        }

        .DropDownMenuItemTextSeparator {
            padding: 0 0 0 3px;
            border-top: 1px solid #d3d3d3;
        }

        .DropDownMenuItemText {
            padding: 3px 25px 3px 6px;
            color: #4F4F4F;
            font-size: 12px;
            text-align: left;
        }

            .DropDownMenuItemText:hover {
                background-color: #E9F0F8;
            }
        /*主体表格部分*/
        /*水印*/
        .PreviewInvoice_OuterTextOverlay {
            width: 100%;
            height: 100%;
            position: fixed;
            z-index: -10;
        }

        .PreviewInvoice_TextOverlay {
            color: #000;
            opacity: .1;
            filter: alpha(opacity=10);
            font-size: 96pt;
            font-weight: bold;
            position: absolute;
            overflow: hidden;
            top: -300px;
            left: 100px;
            /* z-index: -1; */
            -webkit-transform: rotate(320deg);
            -moz-transform: rotate(320deg);
            -ms-transform: rotate(320deg);
            -o-transform: rotate(320deg);
            transform: rotate(320deg);
        }
        /*表格*/
        #ServiceProviderBlock {
            padding-bottom: 30px;
        }

        .boxHeader {
            border: 1px solid black;
            background-color: #f7f7f7;
            font-weight: bold;
            padding: 5px 5px 5px 5px;
        }

        .boxBody {
            border-right: 1px solid black;
            border-left: 1px solid black;
            border-bottom: 1px solid black;
            padding: 5px 5px 5px 5px;
        }

        #InvoiceInfoBlock {
            display: table;
            padding-left: 40px;
        }

        .invoiceInfoRow {
            display: table-row;
            height: 20px;
        }

        .invoiceInfoNameCell {
            font-weight: bold;
            text-align: right;
            display: table-cell;
        }

        .invoiceInfoValueCell {
            text-align: left;
            display: table-cell;
            padding-left: 5px;
        }
        /*第二个*/
        .ReadOnlyGrid_Container {
            font-size: 8pt;
            width: 100%;
            line-height: 200%;
            padding-top: 12px;
        }

        .ReadOnlyGrid_Account {
            font-weight: bold;
            font-style: normal;
            text-decoration: none;
        }

        .ReadOnlyGrid_Table {
            width: 100%;
            border: 1px solid;
            border-top: none;
            border-collapse: collapse;
            font-size: 8pt;
            font-weight: normal;
            font-style: normal;
            text-decoration: none;
            color: #000;
            line-height: normal;
        }

            .ReadOnlyGrid_Table tbody tr {
                border-bottom: 1px #ccc solid;
            }

        .ReadOnlyGrid_TableHeader {
            background-color: #f3f3f3;
            border: 1px black solid;
            padding: 3px;
            border-left: 1px #ccc solid;
            border-right: 1px #ccc solid;
        }

        .ReadOnlyGrid_TableOtherColumn {
            border-left: 1px #ccc solid;
        }

        .ReadOnlyGrid_TableCell {
            vertical-align: top;
            padding: 3px;
        }

        .ReadOnlyGrid_Subtotal {
            font-weight: bold;
            font-style: normal;
            text-decoration: none;
            text-align: right;
        }
        /*第四个表格*/
        .InvoiceTotalsBlock {
            width: 100%;
            border-collapse: collapse;
        }

        .invoiceTotalsRow {
            height: 20px;
        }

        .invoiceTotalsNameCell {
            font-weight: bold;
            text-align: left;
            vertical-align: top;
        }

        .invoiceTotalsValueCell {
            text-align: right;
            width: 120px;
            vertical-align: top;
        }

        .invoiceGrandTotalNameCell {
            font-weight: bold;
            text-align: left;
            vertical-align: top;
            font-size: 12pt;
        }

        .invoiceGrandTotalValueCell {
            font-weight: bold;
            text-align: right;
            width: 120px;
            vertical-align: top;
            font-size: 12pt;
        }
        #invoice_temp_id{
            width: 190px; margin: 0 5px 0 0; height: 24px;
        }
        #accoultList{
            width: 200px; margin: 0 5px 0 0; height: 24px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1">发票预览</span>
                    <a href="###" class="help"></a>
                </div>
            </div>
            <div style="height: 10px; background-color: #FFF;"></div>
            <!--按钮部分-->
            <div class="ButtonBar">
                <ul>
                    <li>
                        <asp:DropDownList ID="invoice_temp_id" runat="server"></asp:DropDownList>
                       
                    </li>
                    <li>
                        <a id="ToolBar">
                            <span class="Text">工具</span>
                            <img src="../Images/dropdown.png" class="ButtonRightImg">
                        </a>
                    </li>
                    <li>
                        <a id="ProcessBar">
                            <span class="Text">处理全部</span>
                        </a>
                    </li>
                    <li class="right pagination">
                        <a class="disabledLink">
                            <span class="Text">>></span>
                        </a>
                    </li>
                    <li class="right pagination">
                        <a class="disabledLink">
                            <span class="Text">></span>
                        </a>
                    </li>
                    <li class="right">
                        <asp:DropDownList ID="accoultList" runat="server"></asp:DropDownList>
                      
                    </li>
                    <li class="right pagination">
                        <a class="disabledLink">
                            <span class="Text"><</span>
                        </a>
                    </li>
                    <li class="right pagination">
                        <a class="disabledLink">
                            <span class="Text"><<</span>
                        </a>
                    </li>
                    <li class="right" style="width: 50px; padding-top: 5px;">
                        <span><%=accList.IndexOf(account)+1 %></span> of <%=accList.Count %>
                    </li>
                </ul>
                <div class="DropDownMenu">
                    <table cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr class="DropDownMenuItem">
                                <td class="DropDownMenuItemHeaderText">
                                    <span class="DropDownMenuSectionHeaderText">打印</span>
                                    <span class="FieldLevelInstructions"></span>
                                </td>
                            </tr>
                            <tr class="DropDownMenuItemSeparator">
                                <td class="DropDownMenuItemTextSeparator"></td>
                            </tr>
                            <tr class="DropDownMenuItem">
                                <td class="DropDownMenuItemText">&nbsp;&nbsp;This Invoice</td>
                            </tr>
                            <tr style="height: 8px;">
                                <td class="DropDownMenuItemSectionSeparator"></td>
                            </tr>
                            <tr class="DropDownMenuItem">
                                <td class="DropDownMenuItemHeaderText">
                                    <span class="DropDownMenuSectionHeaderText">转化为PDF格式</span>
                                    <span class="FieldLevelInstructions">(view, print, or save)</span>
                                </td>
                            </tr>
                            <tr class="DropDownMenuItemSeparator">
                                <td class="DropDownMenuItemTextSeparator"></td>
                            </tr>
                            <tr class="DropDownMenuItem">
                                <td class="DropDownMenuItemText">&nbsp;&nbsp;This Invoice</td>
                            </tr>
                            <tr style="height: 8px;">
                                <td class="DropDownMenuItemSectionSeparator"></td>
                            </tr>
                            <tr class="DropDownMenuItem">
                                <td class="DropDownMenuItemHeaderText">
                                    <span class="DropDownMenuSectionHeaderText">Miscellaneous</span>
                                    <span class="FieldLevelInstructions"></span>
                                </td>
                            </tr>
                            <tr class="DropDownMenuItemSeparator">
                                <td class="DropDownMenuItemTextSeparator"></td>
                            </tr>
                            <tr class="DropDownMenuItem">
                                <td class="DropDownMenuItemText">&nbsp;&nbsp;Un-Post</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div style="position: absolute; left: 10px; overflow-y: auto; right: 10px; top: 112px; bottom: 0px;">
            <!--水印-->
            <div class="PreviewInvoice_OuterTextOverlay">
                <div class="PreviewInvoice_TextOverlay">
                    PREVIEW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW
                <br />
                    <br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW
               <br />
                    <br />
                    PREVIEW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW
                <br />
                    <br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW
                <br />
                    <br />
                    PREVIEW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW
                <br />
                    <br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PREVIEW
               <br />
                    <br />
                </div>
            </div>

            <%--   <asp:ScriptManager ID="ScriptManager1" runat="server">
         </asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                   
                    </ContentTemplate>
            </asp:UpdatePanel>--%>
            <asp:Literal ID="table" runat="server"></asp:Literal>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script>
    $("#ToolBar").on("mouseover", function () {
        $("#ToolBar").css("background", "#fff");
        $(".DropDownMenu").show();
    }).on("mouseout", function () {
        $("#ToolBar").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".DropDownMenu").hide();
    });
    $(".DropDownMenu").on("mouseover", function () {
        $("#ToolBar").css("background", "#fff");
        $(".DropDownMenu").show();
    }).on("mouseout", function () {
        $("#ToolBar").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
        $(".DropDownMenu").hide();
    });
    $("#ProcessBar").on("mouseover", function () {
        $("#ProcessBar").css("background", "#fff");
    }).on("mouseout", function () {
        $("#ProcessBar").css("background", "linear-gradient(to bottom,#fff 0,#d7d7d7 100%)");
    });
</script>
