<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ServiceBundle.aspx.cs" Inherits="EMT.DoneNOW.Web.SysSetting.ServiceBundleManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <title><%if (isAdd)
               { %>新增<%}
                         else
                         { %>编辑<%} %>服务包</title>
    <style>
        input {
            width: 180px;
        }

        textarea {
            padding: 6px;
            resize: vertical;
            height: 52px;
            width: 350px;
            margin-top: 0px;
            margin-bottom: 0px;
        }

        #name {
            width: 350px;
        }

        .DivScrollingContainer {
            left: 0;
            overflow-x: auto;
            overflow-y: auto;
            position: fixed;
            right: 0;
            bottom: 0;
            top: 82px;
        }

        .ServiceTable {
            background-color: white;
            border-bottom-width: 1px;
            border-bottom-style: solid;
            font-size: 12px;
            color: #333;
            text-decoration: none;
            vertical-align: middle;
            padding: 10px 0 4px 0;
            vertical-align: top;
            word-wrap: break-word;
            border-right-width: 1px;
            border-right-style: solid;
            border-left-width: 1px;
            border-left-color: #98b4ca;
            border-left-style: solid;
        }

        .menu {
            position: absolute;
            z-index: 999;
            display: none;
        }

            .menu ul {
                margin: 0;
                padding: 0;
                position: relative;
                width: 150px;
                border: 1px solid gray;
                background-color: #F5F5F5;
                padding: 10px 0;
            }

                .menu ul li {
                    padding-left: 20px;
                    height: 25px;
                    line-height: 25px;
                    cursor: pointer;
                }

                    .menu ul li ul {
                        display: none;
                        position: absolute;
                        right: -150px;
                        top: -1px;
                        background-color: #F5F5F5;
                        min-height: 90%;
                    }

                        .menu ul li ul li:hover {
                            background: #e5e5e5;
                        }

                    .menu ul li:hover {
                        background: #e5e5e5;
                    }

                        .menu ul li:hover ul {
                            display: block;
                        }

                    .menu ul li .menu-i1 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: left;
                    }

                    .menu ul li .menu-i2 {
                        width: 20px;
                        height: 100%;
                        display: block;
                        float: right;
                    }

                .menu ul .disabled {
                    color: #AAAAAA;
                }
                input[type="radio" i] {
    width: 24px;
}
                #serviceHtml td {
    border-width: 1px;
    border-style: solid;
    border-left-color: #F8F8F8;
    border-right-color: #F8F8F8;
    border-top-color: #e8e8e8;
    border-bottom-width: 0;
    font-size: 12px;
    color: #333;
    text-decoration: none;
    vertical-align: top;
    padding: 4px;
    word-wrap: break-word;
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="TitleBar">
                <div class="Title">
                    <span class="text1"><%if (isAdd)
                                            { %>新增<%}
                                                      else
                                                      { %>编辑<%} %>服务包</span>
                </div>
            </div>
            <div class="ButtonContainer header-title" style="margin: 0;">
                <ul id="btn">
                    <li id="saveClose"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input  type="button" value="保存并关闭" style="width: 68px;" />
                    </li>
                     <li id="saveNew"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input  type="button" value="保存并新建" style="width: 68px;" />
                    </li>
                     <li id="Close"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <input  type="button" value="关闭" style="width: 25px;" />
                    </li>
                     
                </ul>
            </div>
            <div class="DivScrollingContainer General">
                <div class="DivSection" style="padding-left: 15px; margin: 10px; width: 650px;">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td width="30%" class="FieldLabels">名称<span class="errorSmall">*</span>
                                    <div>
                                        <input type="text" id="name" name="name" <%if (serviceBundle != null)
                                            { %>
                                            value="<%=serviceBundle.name %>" <%} %> />
                                    </div>
                                </td>
                                <td width="30%" class="FieldLabels">
                                    <div>
                                        <input type="checkbox" name="active" <%if (isAdd || serviceBundle.is_active == 1)
                                            { %>
                                            checked="checked" <%} %> style="width: 15px; height: 15px;" />
                                        激活
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td width="30%" class="FieldLabels">描述
                                <div>
                                    <textarea name="description"><%if (serviceBundle != null)
                                                                     { %> <%=serviceBundle.description %> <%} %></textarea>
                                </div>
                                </td>
                            </tr>

                            <tr>
                                <td width="30%" class="FieldLabels">发票描述
                                <div>
                                    <textarea name="invoice_description"><%if (serviceBundle != null)
                                                                             { %> <%=serviceBundle.invoice_description %> <%} %></textarea>
                                </div>
                                </td>
                            </tr>

                            <tr>
                                <td width="30%" class="FieldLabels">周期类型<span class="errorSmall">*</span>
                                    <div>
                                        <select id="period_type_id" name="period_type_id" style="width: 194px;">
                                            <%foreach (var period in periodType)
                                                { %>
                                            <option value="<%=period.val %>" <%if ((serviceBundle != null && period.val.Equals(serviceBundle.period_type_id.ToString())) || (serviceBundle == null && period.val.Equals(((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH).ToString())))
                                                {%>
                                                selected="selected" <% } %>><%=period.show %></option>
                                            <%}%>
                                        </select>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td width="30%" class="FieldLabels">SLA 
                                <div>
                                    <select id="sla_id" name="sla_id" style="width: 194px;">
                                        <option></option>
                                        <%foreach (var sla in slaList)
                                            { %>
                                        <option value="<%=sla.id %>" <%if (serviceBundle != null && serviceBundle.sla_id != null && serviceBundle.sla_id == sla.id)
                                            { %>
                                            selected="selected" <%} %>><%=sla.name %></option>
                                        <%} %>
                                    </select>
                                </div>
                                </td>
                            </tr>

                            <%--   <tr>
                            <td width="30%" class="FieldLabels">供应商
                                <div>
                                    <input type="text" id="vendorSelect" disabled="disabled" <%if (serviceBundle != null && serviceBundle.vendor_account_id != null)
                                        { %> value="<%=new EMT.DoneNOW.BLL.CompanyBLL().GetCompany((long)serviceBundle.vendor_account_id).name %>" <%} %> />
                                    <input type="hidden" id="vendorSelectHidden" name="vendor_account_id" <%if (serviceBundle != null && serviceBundle.vendor_account_id != null)
                                        { %> value="<%=serviceBundle.vendor_account_id %>" <%} %> />
                                    <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.VENDOR_CALLBACK %>&field=vendorSelect', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.VendorSelect %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle; cursor: pointer;" />
                                </div>
                            </td>
                        </tr>--%>
                            <%--   <tr>
                            <td width="30%" class="FieldLabels">单位成本
                                <div>
                                    <input type="text" id="unit_cost" name="unit_cost" <%if (serviceBundle != null)
                                        { %> value="<%=serviceBundle.unit_cost %>" <%} %> maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="decimal2" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">加价%
                                <div>
                                    <input type="text" id="markup" disabled="disabled" <%if (serviceBundle != null && serviceBundle.unit_cost != null && serviceBundle.unit_cost != 0 && serviceBundle.unit_price != null)
                                        { %> value="<%=decimal.Round((decimal)(serviceBundle.unit_price / serviceBundle.unit_cost - 1) * 100, 2) %>" <%} %> />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td width="30%" class="FieldLabels">单元价格<span class="errorSmall">*</span>
                                <div>
                                    <input type="text" id="unit_price" name="unit_price" <%if (serviceBundle != null)
                                        { %> value="<%=serviceBundle.unit_price %>" <%} %> maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" class="decimal2" />
                                </div>
                            </td>
                        </tr>--%>

                            <tr>
                                <td width="30%" class="FieldLabels">计费代码<span class="errorSmall">*</span>
                                    <div>
                                        <input type="text" id="billCode" disabled="disabled" <%if (serviceBundle != null)
                                            { %>
                                            value="<%=new EMT.DoneNOW.DAL.d_cost_code_dal().FindById(serviceBundle.cost_code_id).name %>" <%} %> />
                                        <input type="hidden" id="billCodeHidden" name="cost_code_id" <%if (serviceBundle != null)
                                            { %>
                                            value="<%=serviceBundle.cost_code_id %>" <%} %> />
                                        <img src="../Images/data-selector.png" onclick="window.open('../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=billCode&con439=<%=(int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RECURRING_CONTRACT_SERVICE_CODE %>', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.BillCodeCallback %>', 'left=200,top=200,width=600,height=800', false)" style="vertical-align: middle; cursor: pointer;" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                            </tr>
                        </tbody>
                    </table>

                </div>
                <div class="DivSection" style="padding-left: 15px; margin: 10px; width: 650px; min-height: 120px;">
                    <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td>
                                    <div class="FieldLabel" style="width: 530px; padding-bottom: 3px;">
                                        <span style="font-weight: normal; font-weight: 700; vertical-align: middle;">服务</span>&nbsp;&nbsp;&nbsp;<a class="lblNormalClass" href="#" onclick="ServiceCallBack()"><img src="../Images/data-selector.png" border="0" /></a>
                                    </div>
                                    <span id="datagrid" class="datagrid" style="display: inline-block; height: auto; width: 530px;">
                                        <span></span>
                                        <input type="hidden" id="ServiceIds" />
                                        <% string serIds = "";
                                            if (serList != null && serList.Count > 0)
                                            {
                                                serList.ForEach(_ => { serIds += _.service_id + ","; });
                                                if (!string.IsNullOrEmpty(serIds))
                                                {
                                                    serIds = serIds.Substring(0,serIds.Length-1);
                                                }
                                            }
                                            %>
                                        <input type="hidden" id="ServiceIdsHidden" name="ServiceIds" value="<%=serIds %>" />
                                        <div id="datagrid_datagrid_divgrid" class="GridContainer">
                                            <div id="datagrid_datagrid_divhead" style="width: 645px; overflow: auto;">
                                                <table id="datagrid_datasgrid_tblHead" class="ServiceTable" cellspacing="0" border="0" style="width: 640px; border-collapse: collapse;">
                                                    <thead class="dataGridHeader">
                                                        <tr class="dataGridHeader" style="height: 39px;">
                                                            <td style="width: 82px;"><span style="font-weight: normal;">服务名称</span></td>
                                                            <td style="width: 72px;"><span style="font-weight: normal;">描述</span></td>
                                                            <td align="left" style="width: 64px;"><span style="font-weight: normal;">供应商</span></td>
                                                            <td align="left" style="width: 58px;"><span style="font-weight: normal;">周期类型</span></td>
                                                            <td align="left" style="width: 82px;"><span style="font-weight: normal;">计费代码</span></td>
                                                            <td align="right" style="width: 54px;"><span style="font-weight: normal;">单元成本</span></td>
                                                            <td align="right" style="width: 54px;"><span style="font-weight: normal;">单元价格</span></td>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="serviceHtml">
                                                        <tr class="dn_tr">
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                        </div>
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="DivSection" style="padding-left: 15px; margin: 10px; width: 650px;">
                    <table cellspacing="0" cellpadding="0" border="0" style="width: 100%; border-collapse: collapse;">
                        <tbody>
                            <tr>
                                <td align="left">
                                    <div style="padding-bottom: 0px;">
                                        <table class="tableTransparent" cellspacing="0" cellpadding="0" border="0" style="width: 330px; border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td style="width: 250px;"><span class="fieldLabel" style="white-space: nowrap;">
                                                        <label>服务价格汇总</label></span></td>
                                                    <td style="padding-left: 6px;"><span id="old_selected_service_sum">
                                                        <input name="selected_service_sum" type="text" value="" readonly="readonly" id="selected_service_sum" class="txtBlack8Class" /></span></td>
                                                </tr>
                                                <tr style="height: 12px;">
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 250px;"><span class="fieldLabel">
                                                        <label>原始总价</label></span></td>
                                                    <td style="padding-left: 6px;"><span>
                                                        <input name="other_price" type="text" id="other_price" class="txtBlack8Class decimal2" value="<%=serviceBundle!=null&&serviceBundle.old_selected_service_sum!=null?(((decimal)serviceBundle.old_selected_service_sum).ToString("#0.00")):"" %>" /></span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 20px;">
                                <td>
                                    <div style="height: 0px; border-top: solid 1px #d3d3d3; width: 100%; padding: 0px;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <div style="padding-bottom: 0px;">
                                        <table class="tableTransparent" cellspacing="0" cellpadding="0" border="0" style="width: 330px; border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td style="width: 150px;"><span class="fieldLabel">
                                                        <input id="use_discount_dollars" type="radio" name="use_dollars" value="use_discount_dollars" class="decimal2"  checked="checked" /><label>折扣数</label></span></td>
                                                    <td style="padding-left: 6px;"><span disabled="disabled">
                                                        <input name="discount_dollars" type="text" id="discount_dollars" class="txtBlack8Class"  style="text-align: right;" value="<%=serviceBundle!=null&&serviceBundle.discount!=null?(((decimal)serviceBundle.discount).ToString("#0.00")):"" %>" /></span></td>
                                                    <td style="padding-left: 6px;"><span>
                                                        <input name="discount_dollars_calc" type="text" readonly="readonly" id="discount_dollars_calc" class="txtBlack8Class" style="text-align: right;" /></span></td>
                                                </tr>
                                                <tr style="height: 12px;">
                                                    <td></td>
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 150px;"><span class="fieldLabel" style="display: inline-flex;">
                                                        <input id="use_discount_percent" type="radio" name="use_dollars" class="decimal2" value="use_discount_percent" /><label style="width: 100px;">折扣率</label></span></td>
                                                    <td style="padding-left: 6px;"><span style="display: inline-block;">
                                                        <input name="discount_percent" type="text" value="<%=serviceBundle!=null&&serviceBundle.discount_percent!=null?(((decimal)serviceBundle.discount_percent).ToString("#0.00")):"" %>" id="discount_percent" class="txtBlack8Class" style="width: 100px; text-align: right;"  disabled="disabled"  /></span></td>
                                                    <td style="width: 100px; padding-left: 6px;"><span>
                                                        <input name="discount_percent_calc" type="text" value="" readonly="readonly" id="discount_percent_calc" class="txtBlack8Class" style="text-align: right;" /></span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                            <tr style="height: 20px;">
                                <td>
                                    <div style="height: 0px; border-top: solid 1px #d3d3d3; width: 100%; padding: 0px;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    <div>
                                        <table class="tableTransparent" cellspacing="0" cellpadding="0" border="0" style="width: 330px; border-collapse: collapse;">
                                            <tbody>
                                                <tr>
                                                    <td align="left" style="width: 250px;"><span class="fieldLabel" style="font-weight: bold;">服务包单价</span></td>
                                                    <td style="padding-left: 6px;"><span>
                                                        <input name="extended_price" type="text" value="<%=serviceBundle!=null&&serviceBundle.unit_price!=null?(((decimal)serviceBundle.unit_price).ToString("#0.00")):"" %>" readonly="readonly" id="extended_price" class="txtBlack8Class" style="text-align: right;" /></span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <input type="hidden" id="SaveType" name="SaveType"/>
        <div id="datagrid_menuGrid" class="menu">
            <ul style="width: 220px;">
                <li id="" onclick="DeleteService()"><i class="menu-i1"></i>删除服务
                </li>
            </ul>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/SysSettingRoles.js"></script>
<script>
    $(function () {
        BindContextMenu();
        <%if (!isAdd)
    { %>
        $("#period_type_id").prop("disabled",true);
        GetDataBySerivceIds();
        // GetServiceIds();
        <%if (serviceBundle != null) {
        if (serviceBundle.discount != null) {
            %>
        $("#use_discount_dollars").prop("checked", true);
        $("#use_discount_dollars").trigger("click");
        $("#discount_dollars").trigger("change");
        <%
        }
        else if(serviceBundle.discount_percent!=null)
        {%>
        $("#use_discount_percent").prop("checked", true);
        $("#use_discount_percent").trigger("click");
        $("#discount_percent").trigger("change");
        <%}

    } %>
        <%}%>
    })
    $(".decimal2").blur(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            $(this).val(toDecimal2(thisValue))
        }
        else {
            $(this).val("")
        }
    })
    function ServiceCallBack() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.SERVICE_CALLBACK %>&muilt=1&field=ServiceIds&callBack=GetDataBySerivceIds", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ServiceSelect %>', 'left=200,top=200,width=600,height=800', false);
    }
    // 根据服务ID 获取相关的值
    function GetDataBySerivceIds() {
        var ServiceIds = $("#ServiceIdsHidden").val();
        var serviceHtml = "";
        if (ServiceIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ServiceAjax.ashx?act=GetServicesByIds&ids=" + ServiceIds,
                success: function (data) {
                    if (data != "") {
                        for (var i = 0; i < data.length; i++) {
                            serviceHtml += "<tr class='dn_tr' id='" + data[i].id + "' data-val='" + data[i].id + "'><td>" + data[i].name + "</td><td>" + data[i].description + "</td><td>" + data[i].vendor_name + "</td><td>" + data[i].period_type_name + "</td><td>" + data[i].cost_code_name + "</td><td>" + toDecimal2(data[i].unit_cost) + "</td><td>" + toDecimal2(data[i].unit_price) + "</td></tr>";
                        }
                    }
                },
                error: function (data) {
                    alert(data);
                },
            });
        }

        $("#serviceHtml").html(serviceHtml);
        GetServicePriceByIds();
        BindContextMenu();
    }
    var entityid;
    var Times = 0;
    var oEvent;
    var menu = document.getElementById("datagrid_menuGrid");

    function BindContextMenu() {
        $(".dn_tr").bind("contextmenu", function (event) {
            entityid = $(this).data("val");
            oEvent = event;
            clearInterval(Times);
            (function () {
                menu.style.display = "block";
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            }());
            menu.onmouseenter = function () {
                clearInterval(Times);
                menu.style.display = "block";
            };
            menu.onmouseleave = function () {
                Times = setTimeout(function () {
                    menu.style.display = "none";
                }, 1000);
            };
            var Left = $(document).scrollLeft() + oEvent.clientX;
            var Top = $(document).scrollTop() + oEvent.clientY;
            var winWidth = window.innerWidth;
            var winHeight = window.innerHeight;
            var menuWidth = menu.clientWidth;
            var menuHeight = menu.clientHeight;
            var scrLeft = $(document).scrollLeft();
            var scrTop = $(document).scrollTop();
            var clientWidth = Left + menuWidth;
            var clientHeight = Top + menuHeight;
            var rightWidth = winWidth - oEvent.clientX;
            var bottomHeight = winHeight - oEvent.clientY;
            if (winWidth < clientWidth && rightWidth < menuWidth) {
                menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
            } else {
                menu.style.left = Left + "px";
            }
            if (winHeight < clientHeight && bottomHeight < menuHeight) {
                menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
            } else {
                menu.style.top = Top + "px";
            }
            return false;
        });
    }

    // 获取页面上选择的服务的ID
    function GetServiceIds() {
        var ids = "";
        $(".dn_tr").each(function () {
            var thisId = $(this).data("val");
            if (thisId != "") {
                ids += thisId + ",";
            }
        })
        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $("#ServiceIdsHidden").val(ids);
    }
    // 删除相关服务
    function DeleteService() {
        $("#" + entityid).remove();
        GetServiceIds();
        menu.style.display = "none";
        GetServicePriceByIds();
        <%if (isAdd)
        { %>

        <%}%>
    }
    // 计算出相关价格
    function MarkMoney() {
        var price_sum = 0;
        var unit_price = 0;
        
        var other_price = $("#other_price").val();
        if (other_price != "" && !isNaN(other_price)) {
            price_sum = Number(other_price);
        }
        

        if ($("#use_discount_dollars").is(":checked")) {
            var discount_dollars_calc = $("#discount_dollars_calc").val();
            if (discount_dollars_calc != "" && !isNaN(discount_dollars_calc)) {
                unit_price = Number(price_sum) - Number(discount_dollars_calc);
            } else {
                unit_price = price_sum;
            }
        }
        else if ($("#use_discount_percent").is(":checked")) {
            var discount_percent = $("#discount_percent").val();
            if (discount_percent != "") {

            }
            else {
                discount_percent = 0;
            }
            var discount = (Number(price_sum) / 100) * Number(discount_percent);
            $("#discount_percent_calc").val(toDecimal2(discount));



            var discount_percent_calc = $("#discount_percent_calc").val();
            if (discount_percent_calc != "" && !isNaN(discount_percent_calc)) {
                unit_price = Number(price_sum) - Number(discount_percent_calc);
            } else {
                unit_price = price_sum;
            }
        }

        $("#extended_price").val(toDecimal2(unit_price));
        
    }

    $("#use_discount_dollars").click(function () {
        if ($(this).is(":checked")) {
            $("#discount_dollars").prop("disabled", false);
            $("#discount_percent").prop("disabled", true);
            $("#discount_percent").val("");
            $("#discount_percent_calc").val("");
        }
        else {
            $("#discount_dollars").prop("disabled", true);
            $("#discount_percent").prop("disabled", false);
        }
        MarkMoney();
    })

    $("#use_discount_percent").click(function () {
        if ($(this).is(":checked")) {
            $("#discount_dollars").prop("disabled", true);
            $("#discount_percent").prop("disabled", false);
            $("#discount_dollars").val("");
            $("#discount_dollars_calc").val("");
        }
        else {
            $("#discount_dollars").prop("disabled", false);
            $("#discount_percent").prop("disabled", true);
        }
        MarkMoney();
    })
    $("#other_price").change(function () {
        MarkMoney();
    })

    $("#discount_dollars").change(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            thisValue = toDecimal2(thisValue);
            $("#discount_dollars_calc").val(thisValue);
            $(this).val(thisValue);
        }
        MarkMoney();
    })
    $("#discount_percent").change(function () {
        var thisValue = $(this).val();
        if (thisValue != "" && !isNaN(thisValue)) {
            thisValue = toDecimal2(thisValue);
            $(this).val(thisValue);
            var price_sum = 0;
            var other_price = $("#other_price").val();
            if (other_price != "" && !isNaN(other_price)) {
                price_sum = Number(other_price);
            }
            var discount = (Number(price_sum) / 100) * Number(thisValue);
            $("#discount_percent_calc").val(toDecimal2(discount));
        }
        MarkMoney();
    })

    function GetServicePriceByIds() {
        var price = 0;
        var ServiceIds = $("#ServiceIdsHidden").val();
        if (ServiceIds != "") {
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ServiceAjax.ashx?act=GetServicePriceByIds&ids=" + ServiceIds,
                success: function (data) {
                    if (data != "") {
                        price = Number(data);
                    }
                },
            });
        }
        $("#selected_service_sum").val(toDecimal2(price));
        <%if (isAdd){ %>
        $("#other_price").val(toDecimal2(price));
        MarkMoney();
        <%}%>
    }
    
</script>
<script>
    $("#saveClose").click(function () {
        $("#SaveType").val("SaveClose");
        if (SubmitCheck()) {
            <%if (isAdd)
            { %>
            $("input").prop("disabled", false);
            $("select").prop("disabled", false);
            $("#form1").submit();
            <%}
            else
            {%>
            var count = 0;
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ServiceAjax.ashx?act=GetServiceContractCount&serivce_id=<%=serviceBundle==null?"":serviceBundle.id.ToString() %>",
                success: function (data) {
                    if (data != "") {
                        count = Number(data);
                    }
                },
            });
            if (Number(count) > 0) {
                LayerConfirm("您即将修改的服务包有" + count + "个定期服务合同引用。请检查合同，并进行必要的调整。是否继续？", "是", "否", function () {
                    $("input").prop("disabled", false);
                    $("select").prop("disabled", false);
                    $("#form1").submit();
                }, function () { })
            }
            else {
                $("input").prop("disabled", false);
                $("select").prop("disabled", false);
                $("#form1").submit();
            }
            <%}%>
        }
    })
    $("#saveNew").click(function () {
        $("#SaveType").val("SaveNew");
        if (SubmitCheck()) {
             <%if (isAdd)
            { %>
            $("input").prop("disabled", false);
            $("select").prop("disabled", false);
            $("#form1").submit();
            <%}
            else
            {%>
            var count = 0;
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",
                url: "../Tools/ServiceAjax.ashx?act=GetServiceContractCount&serivce_id=<%=serviceBundle==null?"":serviceBundle.id.ToString() %>",
                success: function (data) {
                    if (data != "") {
                        count = Number(data);
                    }
                },
            });
            if (Number(count) > 0) {
                LayerConfirm("您即将修改的服务包有" + count + "个定期服务合同引用。请检查合同，并进行必要的调整。是否继续？", "是", "否", function () {
                    $("input").prop("disabled", false);
                    $("select").prop("disabled", false);
                    $("#form1").submit();
                }, function () { })
            }
            else {
                $("input").prop("disabled", false);
                $("select").prop("disabled", false);
                $("#form1").submit();
            }
            <%}%>
        }
    })
    $("#Close").click(function () {
        window.close();
    })
    // saveNew
    function SubmitCheck() {
        if ($("#name").val()=="") {
            LayerMsg("请填写服务包名称！");
            return false;
        }
        if ($("#period_type_id").val() == "") {
            LayerMsg("请选择周期类型！");
            return false;
        }
        if ($("#billCodeHidden").val() == "") {
            LayerMsg("请选择计费代码！");
            return false;
        }
        
        if ($("#ServiceIdsHidden").val() == "") {
            LayerMsg("请选择相关服务！");
            return false;
        } 
        if ($("#extended_price").val() == "") {
            LayerMsg("请通过计算得出相应单价！");
            return false;
        } 
        
        return true;
    }
</script>
