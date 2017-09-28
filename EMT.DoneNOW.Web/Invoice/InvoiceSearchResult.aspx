<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceSearchResult.aspx.cs" Inherits="EMT.DoneNOW.Web.Invoice.InvoiceSearchResult" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <link rel="stylesheet" type="text/css" href="../Content/searchList.css" />
    <%--控制日期弹窗--%>
    <link href="../Content/Roles.css" rel="stylesheet" />
    <title></title>
    <style>
        .searchcontent {
            width: 100%;
            height: 100%;
            min-width: 2200px;
        }

            .searchcontent table th {
                background-color: #cbd9e4;
                border-color: #98b4ca;
                color: #64727a;
                height: 28px;
                line-height: 28px;
                text-align: center;
            }

        .RightClickMenu, .LeftClickMenu {
            padding: 16px;
            background-color: #FFF;
            border: solid 1px #CCC;
            cursor: pointer;
            z-index: 999;
            position: absolute;
            box-shadow: 1px 1px 4px rgba(0,0,0,0.33);
        }

        .RightClickMenuItem {
            min-height: 24px;
            min-width: 100px;
        }

        .RightClickMenuItemIcon {
            padding: 1px 5px 1px 5px;
            width: 16px;
        }

        .RightClickMenuItemTable tr:first-child td:last-child {
            white-space: nowrap;
        }

        .RightClickMenuItemLiveLinks > span, .RightClickMenuItemText > span {
            font-size: 12px;
            font-weight: normal;
            color: #4F4F4F;
        }
        /*合同审批时，提交日期窗口*/
        .addText {
            width: 486px;
            height: 275px;
            margin-left: -247px;
            margin-top: -142px;
            z-index: 980;
            display: block;
            left: 50%;
            position: fixed;
            top: 50%;
            background-color: #b9b9b9;
            border: solid 4px #b9b9b9;
        }

            .addText > div {
                background-color: #fff;
                bottom: 0;
                left: 0;
                position: absolute;
                right: 0;
                top: 0;
            }

        .CancelDialogButton {
            background-image: url(../img/cancel1.png);
            background-position: 0 -32px;
            border: none;
            cursor: pointer;
            height: 32px;
            position: absolute;
            right: -14px;
            top: -14px;
            width: 32px;
            z-index: 100;
            border-radius: 50%;
        }

        #BackgroundOverLay {
            width: 100%;
            height: 100%;
            background: black;
            opacity: 0.6;
            z-index: 25;
            position: absolute;
            top: 0;
            left: 0;
            /*合同审批时，提交日期窗口（样式尾）*/
        }
    </style>
</head>
<body style="overflow-x: auto; overflow-y: auto;">
    <form id="form1">
        <div id="search_list">
            <input type="hidden" id="page_num" name="page_num" <%if (queryResult != null)
                {%>value="<%=queryResult.page %>"
                <%} %> />
            <input type="hidden" id="page_size" name="page_size" <%if (queryResult != null)
                {%>value="<%=queryResult.page_size %>"
                <%} %> />
            <input type="hidden" id="search_id" name="search_id" <%if (queryResult != null)
                {%>value="<%=queryResult.query_id %>"
                <%} %> />
            <input type="hidden" id="order" name="order" <%if (queryResult != null)
                {%>value="<%=queryResult.order_by %>"
                <%} %> />
            <input type="hidden" id="cat" name="cat" value="<%=catId %>" />
            <input type="hidden" id="type" name="type" value="<%=queryTypeId %>" />
            <input type="hidden" id="group" name="group" value="<%=paraGroupId %>" />
            <input type="hidden" name="id" value="<%=objId %>" />
            <input type="hidden" id="isCheck" name="isCheck" value="<%=isCheck %>" />
            <input type="hidden" id="account_ids" name="account_ids" />
            <div id="conditions">
                <%foreach (var para in queryParaValue)
                    { %>
                <input type="hidden" name="<%=para.val %>" value="<%=para.show %>" />
                <%} %>
            </div>
        </div>
        <div class="contentboby">
            <div class="RightClickMenu" style="left: 10px; top: 36px; display: none;">
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1199)">
                                    <span class="lblNormalClass">定期服务合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1200)">
                                    <span class="lblNormalClass">工时及物料合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1201)">
                                    <span class="lblNormalClass">固定价格合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1202)">
                                    <span class="lblNormalClass">预付时间合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1203)">
                                    <span class="lblNormalClass">预付费合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="RightClickMenuItem">
                    <table class="RightClickMenuItemTable" cellspacing="0" cellpadding="0" border="0" style="border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td class="RightClickMenuItemText" onclick="Add(1204)">
                                    <span class="lblNormalClass">事件合同</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="contenttitle clear" style="position: fixed; border-bottom: 1px solid #e8e8fa; left: 0; top: 0; background: #fff; width: 100%;">
                <ul class="clear fl">

                    <li id="liPre" onclick="Preview()"><i style="background-image: url(../Images/new.png);"></i><span>预览选中</span></li>
                    <li id="liPro" onclick="Process()"><i style="background-image: url(../Images/new.png);"></i><span>处理全部</span></li>

                    <li><i style="background-image: url(../Images/print.png);"></i></li>

                    <li><i style="background-image: url(../Images/export.png);"></i></li>
                </ul>
                <%if (queryResult != null && queryResult.count > 0)
                    { %>
                <div class="page fl">
                    <%
                        int indexFrom = queryResult.page_size * (queryResult.page - 1) + 1;
                        int indexTo = queryResult.page_size * queryResult.page;
                        if (indexFrom > queryResult.count)
                            indexFrom = queryResult.count;
                        if (indexTo > queryResult.count)
                            indexTo = queryResult.count;
                    %>
                    <span>第<%=indexFrom %>-<%=indexTo %>&nbsp;&nbsp;总数&nbsp;<%=queryResult.count %></span>
                    <span>每页<%if (queryResult.page_size == 20)
                                {
                    %>&nbsp;20&nbsp;<%}
                                        else
                                        {
                    %><a href="#" onclick="ChangePageSize(20)">20</a><%}
                    %>|<%if (queryResult.page_size == 50)
                           {
                    %>&nbsp;50&nbsp;<%}
                                        else
                                        {
                    %><a href="#" onclick="ChangePageSize(50)">50</a><%}
                    %>|<%if (queryResult.page_size == 100)
                           { %>&nbsp;100&nbsp;<%}
                                                  else
                                                  { %><a href="#" onclick="ChangePageSize(100)">100</a><%} %></span>
                    <i onclick="ChangePage(1)"><<</i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page-1 %>)"><</i>
                    <input type="text" style="width: 30px; text-align: center;" value="<%=queryResult.page %>" />
                    <span>&nbsp;/&nbsp;<%=queryResult.page_count %></span>
                    <i onclick="ChangePage(<%=queryResult.page+1 %>)">></i>&nbsp;&nbsp;<i onclick="ChangePage(<%=queryResult.page_count %>)">>></i>
                </div>
                <%} %>
            </div>
        </div>
    </form>
    <%if (queryResult != null)
        { %>

    <div class="searchcontent" id="searchcontent" style="margin-top: 56px; min-width: <%=tableWidth%>px; overflow: hidden;">
        <table border="" cellspacing="0" cellpadding="0" style="overflow: scroll; width: 100%; height: 100%;">
            <tr>
                <th style="padding-left: 4px;">
                    <input id="CheckAll" type="checkbox" /></th>
                <%foreach (var para in resultPara)
                    {
                        if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                            continue;
                        string orderby = null;
                        string order = null;
                        if (!string.IsNullOrEmpty(queryResult.order_by))
                        {
                            var strs = queryResult.order_by.Split(' ');
                            orderby = strs[0];
                            order = strs[1].ToLower();
                        }
                        if (para.name == "排序字段")
                        {
                            continue;
                        }
                %>
                <th  width="<%=para.length*16 %>px" >
                    <%=para.name %>
                    <%if (orderby != null && para.name.Equals(orderby))
                        { %><img src="../Images/sort-<%=order %>.png" />
                    <%} %></th>
                <%} %>
            </tr>
            <%
                if (queryResult.count == 0)
                {
            %>
            <tr>
                <td align="center" style="color: red;">选定的条件未查找到结果</td>
            </tr>
            <%
                }
                else
                {
                    var idPara = resultPara.FirstOrDefault(_ => _.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID);

                    foreach (var rslt in queryResult.result)
                    {


                        string id = "0";
                        if (idPara != null)
                            id = rslt[idPara.name].ToString();

            %>

            <tr title="右键显示操作菜单" data-val="<%=id %>" <%=rslt["排序字段"].ToString() == "1"?"class='dn_tr'":"" %>>

                <%
                    if (rslt["排序字段"].ToString() == "1")
                    {%>
                <td>
                    <input type="checkbox" class="IsChecked" value="<%=id %>" /></td>
                <%}
                    else
                    { %>
                <td></td>
                <%} %>

                <%foreach (var para in resultPara)
                    {
                        if (para.name == "排序字段")
                        {
                            continue;
                        }
                        if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.ID
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.TOOLTIP
                            || para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.RETURN_VALUE)
                            continue;
                        string tooltip = null;
                        if (resultPara.Exists(_ => _.name.Equals(para.name + "tooltip")))
                            tooltip = para.name + "tooltip";
                %>
                <%if (para.type == (int)EMT.DoneNOW.DTO.DicEnum.QUERY_RESULT_DISPLAY_TYPE.PIC)
                    { %>
                <td  style="background: url(..<%=rslt[para.name] %>) no-repeat center;"></td>
                <%}
                    else
                    { %>
                <td><%if (rslt["排序字段"].ToString() != "1"&&para.name=="客户名称")
                        { %>
                    <a onclick="xiangdao('<%=id %>')"><%=rslt[para.name] %></a>
                    <%}
                    else
                    { 
                             if (para.name == "排序字段")
                        {
                            continue;
                        }
                            %>

                    <%=rslt[para.name] %>
                    <%} %>
                    </td>
                <%} %>
                <%} // foreach
                %>
            </tr>
            <%} // foreach
                } // else
            %>
        </table>
    </div>
    <%} %>

    <div id="menu">
        <%if (contextMenu.Count > 0)
            { %>
        <ul style="width: 220px;">
            <%foreach (var menu in contextMenu)
                { %>
            <li id="<%=menu.id %>" onclick="<%=menu.click_function %>"><i class="menu-i1"></i><%=menu.text %>
                <%if (menu.submenu != null)
                    { %>
                <i class="menu-i2">>></i>
                <ul id="menu-i2-right">
                    <%foreach (var submenu in menu.submenu)
                        { %>
                    <li onclick="<%=submenu.click_function %>"><%=submenu.text %></li>
                    <%} %>
                </ul>
                <%} %>
            </li>
            <%} %>
        </ul>
        <%} %>
    </div>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/Common/SearchBody.js"></script>
<script>
    $(function () {
        $("#liPre").prop("disabled", true);
        $("#liPro").prop("disabled", true);
        $("#liPre").removeAttr("onclick");
        $("#liPro").removeAttr("onclick");
        $("#liPre").css("color", "grey");
        $("#liPro").css("color", "grey");
    });

    $("#CheckAll").click(function () {
        if ($(this).is(":checked")) {
            $(".IsChecked").prop("checked", true);
            $("#liPre").prop("disabled", false);
            $("#liPro").prop("disabled", false);
            $("#liPre").css("color", "");
            $("#liPro").css("color", "");
            $("#liPre").click(function () {
                Preview();
            })
            $("#liPro").click(function () {
                Process();
            })
        }
        else {
            $(".IsChecked").prop("checked", false);
            $("#liPre").prop("disabled", true);
            $("#liPro").prop("disabled", true);
            $("#liPre").removeAttr("onclick");
            $("#liPro").removeAttr("onclick");
            $("#liPre").css("color", "grey");
            $("#liPro").css("color", "grey");
        }
    })


    $(".IsChecked").click(function () {
        var ids = "";
        $(".IsChecked").each(function () {
            if ($(this).is(":checked")) {
                ids += $(this).val() + ",";
            }
        })
        if (ids != "") {

            ids = ids.substring(0, ids.length - 1);
            $("#account_ids").val(ids);
            // 启用两个控件，将客户ID赋值
            $("#liPre").prop("disabled", false);
            $("#liPro").prop("disabled", false);
            $("#liPre").css("color", "");
            $("#liPro").css("color", "");
            $("#liPre").click(function () {
                Preview();
            })
            $("#liPro").click(function () {
                Process();
            })
        }
        else {
            // 禁用两个控件
            $("#liPre").prop("disabled", true);
            $("#liPro").prop("disabled", true);
            $("#liPre").removeAttr("onclick");
            $("#liPro").removeAttr("onclick");
            $("#liPre").css("color", "grey");
            $("#liPro").css("color", "grey");
        }
    });

    function View() {

    }
    function Edit() {

    }
    function Preview() {
        var account_ids = "";
        $(".IsChecked").each(function () {
            if ($(this).is(":checked")) {
                account_ids += $(this).val() + ",";
            }
        })
        if (account_ids == "") {
            return false;
        }
        account_ids = account_ids.substring(0, account_ids.length - 1);
        var stareDate = "";
        var endDate = "";
        //var account_id = "";
        var item_type = ""; //cms591
        var contract_type = ""; // 589
        var contract_cate = ""; // 590
        var itemDeal = "";      // 596
        var purchaseNo = "";    // 594  采购订单号
        debugger;
        if ($("input[name = '588_l']").val() != undefined) {
            stareDate = $("input[name = '588_l']").eq(0).val();
        }
        if ($("input[name = '588_h']").val() != undefined) {
            endDate = $("input[name = '588_h']").eq(0).val();
        }
        //if ($("#586")) {
        //    account_id = $("#586").val();
        //}
        if ($("input[name = 'cms591']").val() != undefined) {
            item_type = $("input[name = 'cms591']").eq(0).val();
        }
        if ($("input[name = '589']").val() != undefined) {
            contract_type = $("input[name = '589']").eq(0).val();
        }
        if ($("input[name = '590']").val() != undefined) {
            contract_cate = $("input[name = '590']").eq(0).val();
        }
        if ($("input[name = '596']").val() != undefined) {
            itemDeal = $("input[name = '596']").eq(0).val();
        }
        if ($("input[name = '594']").val() != undefined) {
            purchaseNo = $("input[name = '594']").eq(0).val();
        }
        if (account_ids != "") {
            window.open("InvoicePreview.aspx?account_ids=" + account_ids + "&stareDate=" + stareDate + "&endDate=" + endDate + "&item_type=" + item_type + "&contract_type=" + contract_type + "&contract_cate=" + contract_cate + "&itemDeal=" + itemDeal + "&purchaseNo=" + purchaseNo, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PREVIEW %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
    }
    function Process() {
        debugger;
        var account_ids = "";
        $(".IsChecked").each(function () {
            if ($(this).is(":checked")) {
                account_ids += $(this).val() + ",";
            }
        })
        if (account_ids == "") {
            return false;
        }
        account_ids = account_ids.substring(0, account_ids.length - 1);
        if (account_ids != "") {
            window.open("ProcessInvoice.aspx?account_ids=" + account_ids, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PROCESS %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
        }
    }
    function xiangdao(account_id) {
        debugger;
        var stareDate = "";
        var endDate = "";
        //var account_id = "";
        var item_type = ""; //cms591
        var contract_type = ""; // 589
        var contract_cate = ""; // 590
        var itemDeal = "";      // 596
        var purchaseNo = "";    // 594  采购订单号
        debugger;
        if ($("input[name = '588_l']").val() != undefined) {
            stareDate = $("input[name = '588_l']").eq(0).val();
        }
        if ($("input[name = '588_h']").val() != undefined) {
            endDate = $("input[name = '588_h']").eq(0).val();
        }
        //if ($("#586")) {
        //    account_id = $("#586").val();
        //}
        if ($("input[name = 'cms591']").val() != undefined) {
            item_type = $("input[name = 'cms591']").eq(0).val();
        }
        if ($("input[name = '589']").val() != undefined) {
            contract_type = $("input[name = '589']").eq(0).val();
        }
        if ($("input[name = '590']").val() != undefined) {
            contract_cate = $("input[name = '590']").eq(0).val();
        }
        if ($("input[name = '596']").val() != undefined) {
            itemDeal = $("input[name = '596']").eq(0).val();
        }
        if ($("input[name = '594']").val() != undefined) {
            purchaseNo = $("input[name = '594']").eq(0).val();
        }
        window.open("InvoiceWizard.aspx?account_id=" + account_id + "&stareDate=" + stareDate + "&endDate=" + endDate + "&item_type=" + item_type + "&contract_type=" + contract_type + "&contract_cate=" + contract_cate + "&itemDeal=" + itemDeal + "&purchaseNo=" + purchaseNo, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_WIZARD %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);

    }

    function Preference() {
        // account_id
        window.open("PreferencesInvoice.aspx?account_id=" + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.INVOICE_PREFERENCE %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
    }
</script>
