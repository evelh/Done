<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductAdd.aspx.cs" Inherits="EMT.DoneNOW.Web.ProductAdd" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="../Content/reset.css" rel="stylesheet" />
    <link href="../Content/SysSettingRoles.css" rel="stylesheet" />
      <link rel="stylesheet" type="text/css" href="../Content/style.css" />
    <style>
     #menu { position: absolute;z-index: 999;display: none;}
#menu ul{margin: 0 ;padding: 0;position: relative;width: 150px;border: 1px solid gray;background-color: #F5F5F5;padding: 10px 0;}
#menu ul li{padding-left: 20px;height: 25px;line-height: 25px;cursor:pointer;}
#menu ul li ul {display: none; position: absolute;right:-150px;top: -1px;background-color: #F5F5F5;min-height: 90%;}
#menu ul li ul li:hover{background: #e5e5e5;}
#menu ul li:hover{background: #e5e5e5;}
#menu ul li:hover ul {display: block;}
#menu ul li .menu-i1{width: 20px;height: 100%;display: block;float: left;}
#menu ul li .menu-i2{width: 20px;height: 100%;display: block;float: right;}
#menu ul .disabled{color: #AAAAAA;}
 @media screen and (max-width: 1430px){
       .cont{
           width:1200px;
           margin:15px 2% 0 2%;
    position: absolute;
    z-index: 1;
       }
	}
        </style>
    <title>产品管理</title>
</head>
<body>
    <form id="form1" runat="server" method="post">
        <div>
             <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">产品管理</span>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer header-title">
        <ul id="btn">
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                <asp:Button ID="Save_Close" OnClientClick="return save_deal()" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="Save_Close_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                <asp:Button ID="Save_New" OnClientClick="return save_deal()" runat="server" Text="保存并新建" BorderStyle="None" OnClick="Save_New_Click"/>
            </li>
            <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                <asp:Button ID="Cancel" runat="server" Text="取消" BorderStyle="None" OnClick="Cancel_Click"/>
            </li>
        </ul>
    </div>
    <!--切换按钮-->
    <div class="TabBar">
        <a class="Button ButtonIcon SelectedState" id="tab1">
            <span class="Text">总结</span>
        </a>
        <a class="Button ButtonIcon" id="tab2">
            <span class="Text">用户定义的</span>
        </a>
        <a class="Button ButtonIcon" id="tab3">
            <span class="Text">库存</span>
        </a>
    </div>
    <!--切换项-->
 <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:122px;">
    <div class="TabContainer" style="min-width: 700px;">
        <div class="DivSection" style="border:none;padding-left:0;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <tr>
                        <td width="50%" class="FieldLabels">
                           产品名称
                            <span class="errorSmall">*</span>
                            <div>
                                <asp:TextBox ID="Product_Name" runat="server" style="width:268px;"></asp:TextBox>
                                <input type="hidden" id="prodct_id" name="prodct_id" value="<%=product.id %>" />
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels">
                            产品种类
                        <div>
                            <label>产品种类</label>
                            <input type="text"disabled="disabled" id="accCallBack" name="accCallBack" value="<%=cate_name %>" />
                            <input type="hidden" name="accCallBackHidden" id="accCallBackHidden" value=""/>
                            <i onclick="OpenWindowProductCate()"><img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/></i>
                        </div>
                         <%--查找带回--%>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            产品描述
                            <div>
                                <asp:TextBox ID="Product_Description" runat="server" maxlength="100" style="width: 268px;height:70px;" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </td>
                        <td class="FieldLabels" style="vertical-align: top;">
                            <div style="padding: 5px 0;">
                                <asp:CheckBox ID="Active" runat="server" Checked="True" />激活</div>
                            <div style="padding: 5px 0;">
                                <asp:CheckBox ID="Serialized" runat="server" />序列化</div>
                            <div style="padding: 5px 0;">
                                <asp:CheckBox ID="does_not_require_procurement" runat="server" />无需采购</div>
                        </td>
                    </tr>
                    <tr>
                        <td class="FieldLabels">
                            默认配置项类型
                            <div>
                                <asp:DropDownList ID="Item_Type" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            物料代码<span class="errorSmall">*</span>
                            <div>
                             <input type="text" disabled="disabled" id="kkCallBack" name="kkCallBack" value="<%=code_name %>" />
                            <input type="hidden" name="kkCallBackHidden" id="kkCallBackHidden" value="" />
                            <i onclick="OpenWindowMaterialCode()"><img src="../Images/data-selector.png" style="vertical-align: middle;cursor: pointer;"/></i>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            <span>单位成本</span>
                            <span style="margin-left: 20px;">毛利率</span>
                            <span style="margin-left: 12px;">单位价格</span>
                            <span style="margin-left: 15px;">MSRP</span>
                            <div style="padding-bottom: 2px;">
                                <asp:TextBox ID="Unit_Cost" runat="server" style="width:60px;text-align: right;" ></asp:TextBox>
                               <%-- 计算毛利率--%>
                                <input type="text" disabled="disabled" id="maolilv" style="width:50px"/>
                                <asp:TextBox ID="Unit_Price" runat="server" style="width:60px;text-align: right;"></asp:TextBox>
                                <asp:TextBox ID="MSRP" runat="server" style="width:60px;text-align: right;"></asp:TextBox>
                            </div>
                        </td>
                        <td class="FieldLabels">
                            周期类型
                            <div style="padding-bottom: 2px;">
                                <asp:DropDownList ID="Period_Type" runat="server"></asp:DropDownList>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>
                                Unit Cost and Unit Price will be used for quotes and ticket/project/contract charges.
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            内部产品ID
                            <div>
                                <asp:TextBox ID="Internal_Product_ID" runat="server"></asp:TextBox>
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels">
                           制造商
                            <div>
                                <asp:TextBox ID="Manufacturer" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            外部产品ID
                            <div>
                                <asp:TextBox ID="External_Product_ID" runat="server"></asp:TextBox>
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels">
                           制造商产品编号
                            <div>
                                <asp:TextBox ID="Manufacturer_Product_Number" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" class="FieldLabels">
                            产品链接<a id="pre_url" style="color:cadetblue;cursor:pointer">Preview</a><input type="hidden" id="urlhidden" name="urlhidden" value="<%=url %>" />
                            <div>
                                <asp:TextBox ID="Product_Link" runat="server" maxlength="100" style="width: 268px;height:70px;" TextMode="MultiLine"></asp:TextBox>
                            </div>
                        </td>
                        <td width="50%" class="FieldLabels" style="vertical-align: top;">
                           产品SKU
                            <div>
                                <asp:TextBox ID="Product_SKU" runat="server"></asp:TextBox>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div style="width: 100%; margin-bottom: 10px;">
            <div class="ButtonContainer header-title">
                <ul>
                   <li id="NewButton"><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                        <span class="Text">新建</span>
                    </li>
                </ul>
            </div>
            <div class="GridContainer" style="height:auto;">
                <div style="width: 100%; overflow: auto; z-index: 0;height:100px;">
                    <table class="dataGridBody" cellspacing="0" width="100%">
                        <tbody id="vendortable">
                            <tr class="dataGridHeader" style="height: 28px;">
                                <td style="width: auto;">
                                    <span>供应商名称</span>
                                </td>
                                <td align="right" style="width: auto;">
                                    <span>单位成本</span>
                                </td>
                                <td align="left" style="width: auto;">
                                    <span>供应商产品编号</span>
                                </td>
                                <td align="center" style="width: 40px;">
                                    <span>激活</span>
                                </td>
                                <td align="center" style="width: 45px;">
                                    <span>默认</span>
                                </td>
                            </tr>
                            <%foreach (var tr in VendorList)
                                {%>
                            <tr class="dataGridBody dn_tr oldvendor" title="右键显示操作菜单" data-val="<%=tr.vendor.id %>">
                                <td style="width: auto;">
                                    <span><%=tr.vendorname %></span>
                                    <input type="hidden" id="<%=tr.vendorname %>" name="<%=tr.vendorname %>" value="<%=tr.vendor.vendor_account_id %>" />
                                </td>
                                <td align="right" style="width: auto;">
                                    <span><%=tr.vendor.vendor_cost %></span>
                                </td>
                                <td align="left" style="width: auto;">
                                    <span><%=tr.vendor.vendor_product_no %></span>
                                </td>
                                <td align="center" style="width: 40px;text-align:center">
                                    <%if (tr.vendor.is_active > 0)
                                        { %>
                                   <img src="../Images/check.png" />
                                    <%} %>
                                </td>
                                <td align="center" style="width: 45px;text-align:center">
                                 <%if (tr.vendor.is_default > 0)
                                     {%>
                                    <img src="../Images/check.png" />
                                    <input type="hidden" id="def" value="default"/>
                                    <%}%>
                                </td>
                            </tr>
                             <%} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <div class="TabContainer" style="display: none;">
         <div>
                <div>
                    <ul>
                        <% if (product_udfList != null && product_udfList.Count > 0)
                            {
                                foreach (var udf in product_udfList)
                                {
                                    if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                    {%>
                        <li>
                            <label><%=udf.name %></label>
                            <input type="text" name="<%=udf.id %>" class="sl_cdt" />
                        </li>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                            {%>
                        <li>
                            <label><%=udf.name %></label>
                            <textarea name="<%=udf.id %>" rows="2" cols="20"></textarea>
                        </li>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                            {%><li>
                                <label><%=udf.name %></label>
                                <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" />
                            </li>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                            {%>
                        <li>
                            <label><%=udf.name %></label>
                            <input onclick="WdatePicker()" type="text" name="<%=udf.id %>" class="sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                        </li>
                        <%}
                            else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                            {%>
                        <li>
                            <label><%=udf.name %></label>
                            <select name="<%=udf.id %>">
                                <%
                                    if (udf.value_list != null)
                                    {
                                        foreach (var v in udf.value_list)
                                        {
                                %>
                                <option value="<%=v.val %>"><%=v.show %></option>
                                <%
                                        } // foreach
                                    } // if
                                %>
                            </select>
                        </li>
                        <%}
                                }
                            } %>
                    </ul>
                </div>
            </div>
    </div>
    <div class="TabContainer" style="display: none;">
            <div class="cont" style="margin-top:15px;">
                <iframe id="PageFrame22" name="PageFrame22" style="width:100%;height:auto" src="../Common/SearchFrameSet.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCTINVENTORY %>&id=<%=product.id %>"></iframe>
            </div>
    </div>
        </div>
 <div id="menu">
             <input type="hidden" id="vendor_data" name="vendor_data" />
        <%if (contextMenu.Count > 0) { %>
		<ul style="width:220px;">
            <%foreach (var menu in contextMenu) { %>
            <li id="<%=menu.id %>" onclick="<%=menu.click_function%>"><i class="menu-i1"></i><%=menu.text %>
            </li>
            <%} %>
		</ul>
        <%} %>
	</div>
        </div>
        <script src="../Scripts/jquery-3.1.0.min.js"></script>
           <script src="../Scripts/Common/SearchBody.js" type="text/javascript" charset="utf-8"></script>
        <script>
            $(window).resize(function () {
                var Height = $(document).height() - 66 + "px";
                $("#PageFrame22").css("height", Height);
            })
            var Height = $(document).height() - 66 + "px";
            $("#PageFrame22").css("height", Height);
            $("#tab1").click(function () {
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
                $(".TabContainer").eq(0).show().siblings(".TabContainer").hide();
            });
            $("#tab2").click(function () {
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
                $(".TabContainer").eq(1).show().siblings(".TabContainer").hide();
            });
            $("#tab3").click(function () {
                <%if(product.id>0){%>
                $(this).addClass("SelectedState").siblings("a").removeClass("SelectedState");
                $(".TabContainer").eq(2).show().siblings(".TabContainer").hide();
                <%}else{%>
                alert("产品还未保存，不存在库存信息！");
                return false;
                <%}%>
            });
            $(document).ready(function () {
                //填入毛利率
                var k1 = $("#Unit_Price").val();
                var k2 = $("#Unit_Cost").val();
                var f1 = parseFloat(k1);
                if (isNaN(f1)) {
                    $("#Unit_Price").val('');
                    return false;
                }
                var f2 = parseFloat(k2);
                if (isNaN(f2)) {
                    $("#Unit_Cost").val('');
                    return false;
                }
                if (k2 == null || k2 == '') {
                    alert("请先输入单元成本！");
                    $("#Unit_Cost").focus();
                    return false;
                }
                var m = ((k1 - k2) / k2) * 100;
                m = Math.round(m * 100) / 100;
                $("#maolilv").val(m + "%");
            });
            $("#Product_Link").change(function () {
                regExp = /http(s)?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?/;
                var re = new RegExp(regExp);
                if (!re.test($(this).val())) {
                    alert("输入的链接不符合规范！");
                    $(this).val('<%=url%>');
                    return false;
                } else {
                    $("#urlhidden").val($(this).val());
                }
                //$("#urlhidden").val($(this).val());
            });
            //点击产品预览
            $("#pre_url").on("click", function () {
                var k = $("#urlhidden").val();
                if (k!="#") {
                    window.open(k,'kk', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                }
            });
            //供应商右键菜单删除
            function Delete() {

                if ($("tr[data-val=" + entityid + "]").hasClass("oldvendor")) {
                    $("tr[data-val=" + entityid + "]").addClass("deletevendor");
                    $("tr[data-val=" + entityid + "]").removeClass("oldvendor")
                    $("tr[data-val=" + entityid + "]").hide();
                } else {
                    $("tr[data-val=" + entityid + "]").remove();
                }
            }
            //供应商右键菜单修改
            function Edit() {
                var _this = $("tr[data-val=" + entityid + "]");
                var vendorname = _this.children().eq(0).text();
                var id = _this.children().eq(0).find("input").val();
                var vendor_cost = _this.children().eq(1).text();
                var vendor_product_no = _this.children().eq(2).text();
                var is_active = 0;
                if (_this.children().eq(3).text() != '') {
                    is_active = "1";
                }
                $("#vendor_data").val('');
                if (_this.hasClass("oldvendor")) {
                    id = entityid;
                    window.open('VendorAdd.aspx?id=' + entityid, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.VendorAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                    return entityid;
                }
                else {
                    var kk = "{'vendorname': '" + vendorname + "', 'id': '" + id + "', 'vendor_cost': '" + vendor_cost + "', 'vendor_product_no':'" + vendor_product_no + "', 'is_active': '" + is_active + "'}";
                    $("#vendor_data").val(kk);
                    window.open('VendorAdd.aspx?state=new', '<%=(int)EMT.DoneNOW.DTO.OpenWindow.VendorAdd %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
                }                
                return entityid;
            }
            //更新反馈
            function EditReturn(val) {
                var _this = $("tr[data-val=" +entityid+ "]");                
                returnValue = $("#vendor_data").val();
                console.log(returnValue);
                if (returnValue !== '' && returnValue !== undefined) {
                    _this.addClass("updatevendor");
                    result = returnValue.replace(/'/g, '"');
                    var obj = JSON.parse('[' + result + ']');
                    for (var i = 0; i < obj.length; i++) {
                        //清空原始值
                        _this.children().eq(0).html("");
                        _this.children().eq(1).html("");
                        _this.children().eq(2).html("");
                        _this.children().eq(3).html("");

                        _this.children().eq(0).append('<span>' + obj[i].vendorname + '</span><input type="hidden" id="' + obj[i].vendorname + '"  name="' + obj[i].vendorname + '"  value="' + obj[i].id + '"/>');
                        _this.children().eq(1).append('<span>' + obj[i].vendor_cost + '</span>');
                        _this.children().eq(2).append('<span>' + obj[i].vendor_product_no + '</span>');
                        if (obj[i].is_active == "1") {
                            _this.children().eq(3).append("<img src='../Images/check.png' />");
                        } 
                        $(".dn_tr").bind("contextmenu", function (event) {
                            clearInterval(Times);
                            var oEvent = event;
                            entityid = $(this).data("val");
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
                            var Top = $(document).scrollTop() + oEvent.clientY;
                            var Left = $(document).scrollLeft() + oEvent.clientX;
                            var winWidth = window.innerWidth;
                            var winHeight = window.innerHeight;
                            var menuWidth = menu.clientWidth;
                            var menuHeight = menu.clientHeight;
                            var scrLeft = $(document).scrollLeft();
                            var scrTop = $(document).scrollTop();
                            var clientWidth = Left + menuWidth;
                            var clientHeight = Top + menuHeight;
                            if (winWidth < clientWidth) {
                                menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
                            } else {
                                menu.style.left = Left + "px";
                            }
                            if (winHeight < clientHeight) {
                                menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
                            } else {
                                menu.style.top = Top + "px";
                            }
                            return false;
                        });
                    }
                }


            }
            //供应商右键菜单激活
            function Active() {
                var _this = $("tr[data-val=" + entityid + "]");
                if (_this.children().eq(3).find("img").length>0) {
                    alert("已经激活！");
                } else {
                    _this.addClass("updatevendor");
                    _this.children().eq(3).append("<img src='../Images/check.png'/>");
                }
            }

            //供应商右键菜单停用活
            function NoActive() {
                var _this = $("tr[data-val=" + entityid + "]");
                if (_this.children().eq(3).find("img").length <= 0) {
                    alert("已经停用！");
                } else {
                    _this.addClass("updatevendor");
                    _this.children().eq(3).html('');
                }
            }
             //供应商右键菜单设为默认
            function Default() {
               
                var _this = $("tr[data-val=" + entityid + "]");
                if (_this.children().eq(4).find("img").length > 0) {
                    alert("已经为默认！");
                } else {
                    $("#def").parent().html('');
                    _this.addClass("updatevendor");
                    _this.children().eq(4).append("<img src='../Images/check.png'/><input type= 'hidden' id= 'def' value='default'/>");
                }
            }
            //处理保存数据
            function save_deal() {
                if ($("#Product_Name").val() == null || ($("#Product_Name").val() == '')){
                    alert("请填入产品名称！");
                    return false;
                }
                if ($("#kkCallBack").val() ==null || $("#kkCallBack").val() == '') {
                    alert("请选择物料代码");
                    return false;
                }
                var vendor = [];
                vendor.push("{\"VENDOR\":[");
                $("#vendortable").find("tr").each(function () {
                    var _this = $(this);
                    if (_this.hasClass("deletevendor")) {
                        //删除的供应商
                        var id = _this.data("val");
                            var k = { "id": id, "operate": 1 };
                            var json = JSON.stringify(k);
                            console.log("delete:"+json);
                            vendor.push(json);
                    }
                    console.log(this);
                    if (_this.hasClass("newvendor")) {
                        //新增的供应商
                        var vendorname = _this.children().eq(0).text();
                        var vendorid = _this.children().eq(0).find("input").val();
                        var vendor_cost = _this.children().eq(1).text();
                        var vendor_product_no = _this.children().eq(2).text();
                            var is_active = 0;
                            var is_default = 0;
                            if (_this.children().eq(3).find("img").length>0) {
                                is_active = 1;
                            }
                            if (_this.children().eq(4).find("img").length>0) {
                                is_default = 1;
                            }
                            var k = { "id": 0, "operate": 3, "vendor_account_id": vendorid, "vendor_product_no": vendor_product_no, "vendor_cost": vendor_cost, "is_default": is_default, "is_active": is_active };
                            var json = JSON.stringify(k);
                            console.log("insert"+json);
                            vendor.push(json);
                    }
                    if (_this.hasClass("updatevendor")) {
                        //更新的供应商
                            var id = 0;
                            var operate = 3;
                            if (_this.hasClass("oldvendor")) {
                                id = _this.data("val");
                                operate = 2;
                            }
                            var vendorname = _this.children().eq(0).text();
                            var vendorid = _this.children().eq(0).find("input").val();
                            var vendor_cost = _this.children().eq(1).text();
                            var vendor_product_no = _this.children().eq(2).text();
                            var is_active = 0;
                            var is_default = 0;
                            if (_this.children().eq(3).find("img").length>0) {
                                is_active = 1;
                            }
                            if (_this.children().eq(4).find("img").length > 0) {
                                is_default = 1;
                            }
                            var k = { "id": id, "operate": operate, "vendor_account_id": vendorid, "vendor_product_no": vendor_product_no, "vendor_cost": vendor_cost, "is_default": is_default, "is_active": is_active };
                            var json = JSON.stringify(k);
                            console.log("update"+json);
                            vendor.push(json);
                    }
                });
                console.log(vendor);
                vendor.push("]}");
                $("#vendor_data").val('');
                $("#vendor_data").val($('<div/>').text(vendor).html());
            }
            //获取毛利率
            
            $("#Unit_Price").change(function () {
                var k1 = $("#Unit_Price").val();
                var k2 = $("#Unit_Cost").val();
                if ((/^\d{1,15}\.?\d{0,2}$/.test(k1)) == false) {
                    alert('只能输入两位小数');
                    $("#Unit_Price").val('');
                    $("#Unit_Price").focus();
                    return false;
                }
                var f = parseFloat(k1);
                if (isNaN(f)) {
                    return false;
                }
                var f = Math.round(k1 * 100) / 100;
                var s = f.toString();
                var rs = s.indexOf('.');
                if (rs < 0) {
                    rs = s.length;
                    s += '.';
                }
                while (s.length <= rs + 2) {
                    s += '0';
                }    
                $("#Unit_Price").val(s);
                if (k2 == null || k2 == '') {
                    alert("请先输入单元成本！");
                    $("#Unit_Cost").focus();
                    return false;
                }                
                var m = ((k1 - k2) / k2) * 100;
                m = Math.round(m* 100)/100;
                $("#maolilv").val(m+"%");

            });
            $("#Unit_Cost").change(function () {
                if ((/^\d{1,15}\.?\d{0,2}$/.test(this.value)) == false) { alert('只能输入两位小数'); this.value = ''; this.focus(); return false; }
                var k1 = $("#Unit_Price").val();
                var k2 = $("#Unit_Cost").val();
                var f = parseFloat(k2);
                if (isNaN(f)) {
                    return false;
                }
                var f = Math.round(k2 * 100) / 100;
                var s = f.toString();
                var rs = s.indexOf('.');
                if (rs < 0) {
                    rs = s.length;
                    s += '.';
                }
                while (s.length <= rs + 2) {
                    s += '0';
                }
                $("#Unit_Cost").val(s);

                if (k1 != ''&&k2!=0) {
                    var m = ((k1 - k2) / k2) * 100 + "%";
                    $("#maolilv").val(m);
                }               

            });
            $("#MSRP").change(function () {
                if ((/^\d{1,15}\.?\d{0,2}$/.test(this.value)) == false) { alert('只能输入两位小数'); this.value = ''; this.focus(); return false; }
                var f = Math.round(this.value * 100) / 100;
                var s = f.toString();
                var rs = s.indexOf('.');
                if (rs < 0) {
                    rs = s.length;
                    s += '.';
                }
                while (s.length <= rs + 2) {
                    s += '0';
                }
                $("#MSRP").val(s);
            });
       

            function OpenWindowProductCate() {
                window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PRODUCT_CATE_CALLBACK %>&field=accCallBack&callBack=GetProductCate", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ProductCata %>', 'left=200,top=200,width=600,height=800', false);
            }
            function OpenWindowMaterialCode() {
                window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.MATERIALCODE_CALLBACK %>&field=kkCallBack&callBack=GetProductCate", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.MaterialCode %>', 'left=200,top=200,width=600,height=800', false);
            }
            function GetProductCate() {
            }

            $("#NewButton").click(function () {
                $("#vendor_data").val('');
                window.open('VendorAdd.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.VendorAdd %>','left=0,top=0,location=no,status=no,width=900,height=750', false);
            });

            function kkk() {
                returnValue = $("#vendor_data").val();
                $("#vendor_data").val('');
                console.log(returnValue);
                if (returnValue !== '' && returnValue !== undefined) {
                    result = returnValue.replace(/'/g, '"');
                    var obj = JSON.parse('[' + result + ']');
                    for (var i = 0; i < obj.length; i++) {
                        if (obj[i].active == "y") {
                            $('.dataGridHeader').after(
                                $('<tr class="dataGridBody newvendor dn_tr" title="右键显示操作菜单" data-val="' + obj[i].id + '">' +
                                    '<td style= "width: auto;" >' +
                                    '<span>' + obj[i].vendorname + '</span><input type="hidden" id="' + obj[i].vendorname + '"  name="' + obj[i].vendorname + '"  value="' + obj[i].id + '"/>' +
                                    '</td>' +
                                    '<td align="right" style="width: auto;">' +
                                    '<span>' + obj[i].vendor_cost + '</span>' +
                                    '</td>' +
                                    '<td align= "left" style= "width: auto;" >' +
                                    '<span>' + obj[i].vendor_product_no + '</span>' +
                                    '</td>' +
                                    '<td align="center" style="width: 40px;text-align:center"><img src="../Images/check.png" />' +
                                    '</td>' +
                                    '<td align="center" style="width: 45px;text-align:center">' +
                                    '</td>' +
                                    '</tr >'))
                        } else {
                            $('.dataGridHeader').after(
                                $('<tr class="dataGridBody newvendor dn_tr" title="右键显示操作菜单" data-val="' + obj[i].id + '">' +
                                    '<td style= "width: auto;" >' +
                                    '<span>' + obj[i].vendorname + '</span><input type="hidden" id="' + obj[i].vendorname + '"  name="' + obj[i].vendorname + '"  value="' + obj[i].id + '"/>' +
                                    '</td>' +
                                    '<td align="right" style="width: auto;">' +
                                    '<span>' + obj[i].vendor_cost + '</span>' +
                                    '</td>' +
                                    '<td align= "left" style= "width: auto;" >' +
                                    '<span>' + obj[i].vendor_product_no + '</span>' +
                                    '</td>' +
                                    '<td align="center" style="width: 40px;text-align:center">' +
                                    '</td>' +
                                    '<td align="center" style="width: 45px;text-align:center">' +
                                    '</td>' +
                                    '</tr >')
                            )
                        }
                        if ($("#def").val() == null || $("#def").val() == '')
                        {
                            $("tr[data-val=" + obj[i].id + "]").children().eq(4).append("<img src='../Images/check.png'/><input type= 'hidden' id= 'def' value='default'/>");
                        }
                        $(".dn_tr").bind("contextmenu", function (event) {
                            clearInterval(Times);
                            var oEvent = event;
                            entityid = $(this).data("val");
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
                            var Top = $(document).scrollTop() + oEvent.clientY;
                            var Left = $(document).scrollLeft() + oEvent.clientX;
                            var winWidth = window.innerWidth;
                            var winHeight = window.innerHeight;
                            var menuWidth = menu.clientWidth;
                            var menuHeight = menu.clientHeight;
                            var scrLeft = $(document).scrollLeft();
                            var scrTop = $(document).scrollTop();
                            var clientWidth = Left + menuWidth;
                            var clientHeight = Top + menuHeight;
                            if (winWidth < clientWidth) {
                                menu.style.left = winWidth - menuWidth - 18 + scrLeft + "px";
                            } else {
                                menu.style.left = Left + "px";
                            }
                            if (winHeight < clientHeight) {
                                menu.style.top = winHeight - menuHeight - 18 + scrTop + "px";
                            } else {
                                menu.style.top = Top + "px";
                            }
                            return false;
                        });
                    }                   
                }
            }

            //打开新增库存窗口
            function openkk() {
                var kk = $("#prodct_id").val();
                var kkk = $("#Product_Name").val();
                window.open("../Product/ProductStock.aspx?pid=" + kk + "&pname=" + kkk, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.Inventory %>', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
            }
            //刷新库存管理
            function refrekkk() {
                var src = $("#PageFrame22").attr("src");
                $("#PageFrame22").attr("src",src );
            }
        </script>
    </form>
</body>
</html>
