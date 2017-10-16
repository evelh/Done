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

        #invoice_temp_id {
            width: 190px;
            margin: 0 5px 0 0;
            height: 24px;
        }

        #accoultList {
            width: 200px;
            margin: 0 5px 0 0;
            height: 24px;
        }
    </style>
    <style media="print">
    @page {
      size: auto;  /* auto is the initial value */
      margin: 0mm; /* this affects the margin in the printer settings */
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="thisTitle">
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
                    <li onclick="processAll()">
                        <a id="ProcessBar">
                            <span class="Text">处理全部</span>
                        </a>
                    </li>
                    <%
                        var accInvDicList = accInvDic.ToList();
                        var firstDic = accInvDicList.FirstOrDefault(_ => _.Key == account_id);
                        
                        %>
                    <li class="right pagination">
                        <a class="disabledLink" onclick="changeByAccount('<%=accInvDicList.IndexOf(firstDic) == accInvDicList.Count - 1 ? "0" : accInvDicList[accInvDicList.Count - 1].Key.ToString() %>')">
                            <span class="Text">>></span>
                        </a>
                    </li>
                    <li class="right pagination">
                        <a class="disabledLink" onclick="changeByAccount('<%=accInvDicList.IndexOf(firstDic) == accInvDicList.Count - 1 ? "0" : accInvDicList[accInvDicList.IndexOf(firstDic) + 1].Key.ToString() %>')">
                            <span class="Text">></span>
                        </a>
                    </li>
                    <li class="right">
                        <%--<asp:DropDownList ID="accoultList" runat="server"></asp:DropDownList>--%>
                        <select id="accoultList">
                            <%if (accInvDic != null && accInvDic.Count > 0)
                                {
                                    foreach (var item in accInvDic)
                                    {%>
                                     <option value="<%=item.Key %>" <%=item.Key==account_id?"selected":"" %>><%=item.Value %></option>
                                     <%}
                                }%>
                        </select>

                    </li>
                    <li class="right pagination">
                        <a class="disabledLink" onclick="changeByAccount('<%=accInvDicList.IndexOf(firstDic)==0?"0":accInvDicList[accInvDicList.IndexOf(firstDic)-1].Key.ToString() %>')">
                            <span class="Text"><</span>
                        </a>
                    </li>
                    <li class="right pagination">
                        <a class="disabledLink" onclick="changeByAccount('<%=accInvDicList.IndexOf(firstDic)==0?"0":accInvDicList[0].Key.ToString() %>')">
                            <span class="Text"><<</span>
                        </a>
                    </li>
                    <li class="right" style="width: 50px; padding-top: 5px;">
                        <span><%=accInvDicList.IndexOf(firstDic)+1 %></span> of <%=accInvDicList.Count %>
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
                            <tr class="DropDownMenuItem" onclick="Print()">
                                <td class="DropDownMenuItemText">&nbsp;&nbsp;This Invoice</td>
                            </tr>
                            <tr style="height: 8px;">
                                <td class="DropDownMenuItemSectionSeparator"></td>
                            </tr>
                            <tr class="DropDownMenuItem">
                                <td class="DropDownMenuItemHeaderText">
                                    <asp:Button ID="ConToPdf" runat="server" Text="转化为PDF格式<" OnClick="ConToPdf_Click" />
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
                                <td class="DropDownMenuItemText" onclick="UnPost()">&nbsp;&nbsp;撤销审批</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <div id="thisDiv" style="position: absolute; left: 10px; overflow-y: auto; right: 10px; top: 112px; bottom: 0px;">
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
        <input type="hidden" id="thisAccDedIds" runat="server"/>
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
<script>
    $("#invoice_temp_id").change(function () {
        locationChange();
    })
    $("#accoultList").change(function () {
        locationChange();
    })


    $(function () {
        
        <% if (isInvoice)
    {%>
        $("#invoice_temp_id").css("display", "none"); // ProcessBar
        $("#ProcessBar").css("display", "none");
        $(".PreviewInvoice_TextOverlay").hide();
        <%} %>

        <%if (!string.IsNullOrEmpty(isPrint)){ %>
        $("#thisDiv").css("overflow-y", "visible");
        $("#thisTitle").hide();
        <%}%>

    })

    // 页面参数改变更新页面
    function locationChange() {
        debugger;
        var account_id = $("#accoultList").val();
        var invTempId = $("#invoice_temp_id").val();
       
        if (invTempId != "" && invTempId != "0" && account_id != "" && account_id != "0" ) {
            location.href = "InvoicePreview?account_ids=<%=Request.QueryString["account_ids"] %>&account_id=" + account_id + "&invoice_temp_id=" + invTempId + "&stareDate=<%=itemStartDatePara %>&endDate=<%=itemEndDatePara %>&contract_type=<%=contractTypePara %>&contract_cate=<%=contractCatePara %>&itemDeal=<%=projectItemPara %>&purchaseNo=<%=purchaseNo %>&isInvoice=<%=isInvoice?"1":"" %>&accDedIds=<%=Request.QueryString["accDedIds"] %>&inv_batch=<%=Request.QueryString["inv_batch"] %>&invoice_id=<%=Request.QueryString["invoice_id"] %>";
        }
    }

    function changeByAccount(account_id) {
        var invTempId = $("#invoice_temp_id").val();
        if (invTempId != "" && invTempId != "0" && account_id != "" && account_id != "0") {
            location.href = "InvoicePreview?account_ids=<%=Request.QueryString["account_ids"] %>&account_id=" + account_id + "&invoice_temp_id=" + invTempId + "&stareDate=<%=itemStartDatePara %>&endDate=<%=itemEndDatePara %>&contract_type=<%=contractTypePara %>&contract_cate=<%=contractCatePara %>&itemDeal=<%=projectItemPara %>&purchaseNo=<%=purchaseNo %>&isInvoice=<%=isInvoice?"1":"" %>&accDedIds=<%=Request.QueryString["accDedIds"] %>&inv_batch=<%=Request.QueryString["inv_batch"] %>&invoice_id=<%=Request.QueryString["invoice_id"] %>";
        }
    }

    // 处理全部发票--注意开始时间和结束时间没有不进行处理
    function processAll() {
        var thisAccDedIds = $("#thisAccDedIds").val();
        var startDate = '<%=itemStartDatePara %>';
        var endDate = '<%=itemEndDatePara %>';
        var invTempId = $("#invoice_temp_id").val();
        var invoiceDate = '<%=invoiceDate %>';
        var purNo = '<%=purchaseNo %>';
        var notes = '<%=notes %>';
        var pay_term = '<%=pay_term %>';
        if (thisAccDedIds == "") {
            alert("当前暂无条目");
            return false;
        }
        if (invTempId == undefined || invTempId == '0' || invTempId == "") {
            alert('请选择发票模板');
            return false;
        }
        $.ajax({
            type: "GET",
            async: false,
            // dataType: "json",
            url: "../Tools/ContractAjax.ashx?act=processAll&thisAccDedIds=" + thisAccDedIds + "&startDate=" + startDate + "&endDate=" + endDate + "&invTempId=" + invTempId + "&invoiceDate=" + invoiceDate + "&purNo=" + purNo + "&notes=" + notes + "&pay_term=" + pay_term,
            success: function (data) {
                if (data == 'True') {
                    alert('处理成功');
                } else {
                    alert('处理失败');
                }
                window.close();
                self.opener.location.reload();
            },
        });
    }
    // 撤销审批
    function UnPost() {
        var thisAccDedIds = $("#thisAccDedIds").val();
        if (thisAccDedIds == "") {
            alert("当前暂无条目");
            return false;
        }
        $.ajax({
            type: "GET",
            async: false,
            // dataType: "json",
            url: "../Tools/ReverseAjax.ashx?act=UnPostAll&ids=" + thisAccDedIds ,
            success: function (data) {
                if (data != "") {
                    alert("撤销审批成功");
                }
                window.close();
                self.opener.location.reload();
            },
        });
    }

    function Print()
    {
        // overflow-y
        $("#thisTitle").hide();
        $("#thisDiv").css("overflow-y", "");
        if (getExplorer() == "IE") {
            pagesetup_null();
        }
        window.print();
        $("#thisDiv").css("overflow-y", "auto");
        $("#thisTitle").show();
    }


    function pagesetup_null() {
        var hkey_root, hkey_path, hkey_key;
        hkey_root = "HKEY_CURRENT_USER";
        hkey_path = "\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
        try {
            var RegWsh = new ActiveXObject("WScript.Shell");
            hkey_key = "header";
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, "");
            hkey_key = "footer";
            RegWsh.RegWrite(hkey_root + hkey_path + hkey_key, "");
        } catch (e) { }
    }
    function getExplorer() {
        var explorer = window.navigator.userAgent;
        //ie 
        if (explorer.indexOf("MSIE") >= 0) {
            return "IE";
        }
        //firefox 
        else if (explorer.indexOf("Firefox") >= 0) {
            return "Firefox";
        }
        //Chrome
        else if (explorer.indexOf("Chrome") >= 0) {
            return "Chrome";
        }
        //Opera
        else if (explorer.indexOf("Opera") >= 0) {
            return "Opera";
        }
        //Safari
        else if (explorer.indexOf("Safari") >= 0) {
            return "Safari";
        }
    }

</script>
