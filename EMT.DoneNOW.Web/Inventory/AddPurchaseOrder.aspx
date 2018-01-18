<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddPurchaseOrder.aspx.cs" Inherits="EMT.DoneNOW.Web.Inventory.AddPurchaseOrder" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title><%if (isAdd) { %>新增<%} else { %>编辑<%} %>采购订单</title>
  <link rel="stylesheet" type="text/css" href="../Content/base.css" />
  <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
  <link href="../Content/index.css" rel="stylesheet" />
  <link href="../Content/style.css" rel="stylesheet" />
  <style>
    .content label {
      width: 130px;
    }
  </style>
</head>
<body style="overflow:auto;">
  <div class="header"><%if (isAdd) { %>新增<%} else { %>编辑<%} %>采购订单</div>
  <div class="header-title" style="min-width: 700px;">
    <ul>
      <li id="SaveClose">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
        <input type="button" value="保存并关闭" />
      </li>
      <li id="SaveSubmit">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
        <input type="button" value="保存并提交" />
      </li>
      <li id="SaveNew">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
        <input type="button" value="保存并新建" />
      </li>
      <li id="SubmitEmail">
        <input type="button" value="提交并发送邮件" />
      </li>
      <li id="ViewPrint">
        <input type="button" value="查看/打印" />
      </li>
      <li id="Cancle">
        <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
        <input type="button" value="取消" />
      </li>
    </ul>
  </div>
  <form id="form1" runat="server">
    <div class="information clear" style="min-width: 764px;">
      <p class="informationTitle"><i id="generalInfo"></i>常规信息</p>
      <div class="content clear">
        <table border="none" cellspacing="" cellpadding="" style="width: 364px;">
          <tr>
            <td>
              <div class="clear">
                <label>供应商<span class="red">*</span></label>
                <%
                    string VendorId = "";
                    if (defaultVendorAccountId != 0)
                      VendorId = defaultVendorAccountId.ToString();
                    if (!isAdd)
                      VendorId = orderEdit.vendor_account_id.ToString();

                    %>
                <input type="text" id="venderName" readonly="readonly" <%if (VendorId!="") { %> value="<%=new EMT.DoneNOW.BLL.CompanyBLL().GetCompany(long.Parse(VendorId)).name %>" <%} %> />
                <input type="hidden" id="venderNameHidden" name="vendor_account_id" value="<%=VendorId %>" />
                <i onclick="window.open('../Common/SelectCallBack?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.VENDOR_CALLBACK %>&field=venderName&callBack=SelectVendor','_blank','left=200,top=200,width=900,height=750', false);" style="width: 20px; height: 20px; float: left; margin-left: 2px; margin-top: 6px; background: url(../Images/data-selector.png) no-repeat;" id="vendorCompanySelect"></i>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>供应商发票号</label>
                <input type="text" name="vendor_invoice_no" <%if (!isAdd) { %> value="<%=orderEdit.vendor_invoice_no %>" <%} %> />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>外部采购订单号</label>
                <input type="text" name="external_purchase_order_no" <%if (!isAdd) { %> value="<%=orderEdit.external_purchase_order_no %>" <%} %> />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>付款期限</label>
                <select name="payment_term_id">
                  <option></option>
                  <%foreach (var term in paymentTerms) { %>
                  <option value="<%=term.val %>" <%if (!isAdd && orderEdit.payment_term_id!=null && orderEdit.payment_term_id.ToString()==term.val) { %> selected="selected" <%} %>><%=term.show %></option>
                  <%} %>
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>税区</label>
                <select id="tax_region_id" name="tax_region_id">
                  <option></option>
                  <%foreach (var term in taxRegion) { %>
                  <option value="<%=term.val %>" <%if (!isAdd && orderEdit.tax_region_id!=null && orderEdit.tax_region_id.ToString()==term.val) { %> selected="selected" <%} %>><%=term.show %></option>
                  <%} %>
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>显示税种</label>
                <input type="checkbox" name="checkShowTaxCate" <%if (!isAdd && orderEdit.display_tax_cate==1) { %> checked="checked" <%} %> />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>显示税种分税信息</label>
                <input type="checkbox" name="checkTaxSeparate" <%if (!isAdd && orderEdit.display_tax_seperate_line == 1) { %> checked="checked" <%} %> />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>备注</label>
                <textarea name="note" cols="20" rows="2"> <%if (!isAdd) { %><%=orderEdit.note %><%} %></textarea>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>自动添加采购项</label>
                <div style="padding-left:130px;">
                  <div style="margin-top:5px;height:16px;">
                    <input type="radio" id="autoFillOrder1" name="autoFillOrder" disabled="disabled" style="width: 16px;height:16px;" /><span style="float:left;margin-left:5px;">产品默认“供应商”为当前供应商</span>
                  </div>
                  <div style="margin-top:5px;height:16px;">
                    <input type="radio" id="autoFillOrder2" name="autoFillOrder" disabled="disabled" style="width: 16px;height:16px;" /><span style="float:left;margin-left:5px;">产品“供应商”包含当前供应商</span>
                  </div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>采购项描述信息显示内容</label>
                <select name="item_desc_display_type_id">
                  <%foreach (var term in itemDescType) { %>
                  <option value="<%=term.val %>" <%if (!isAdd && orderEdit.item_desc_display_type_id!=null && orderEdit.item_desc_display_type_id.ToString()==term.val) { %> selected="selected" <%} %>><%=term.show %></option>
                  <%} %>
                </select>
              </div>
            </td>
          </tr>
        </table>
        <table border="none" cellspacing="" cellpadding="" style="width: 350px;">
          <%
              EMT.DoneNOW.Core.crm_location purchaseLocation = null;
              if(!isAdd)
              {
                purchaseLocation= new EMT.DoneNOW.BLL.LocationBLL().GetLocation(orderEdit.location_id);
              }
              %>
          <tr>
            <td>
              <div class="clear">
                <label>标签</label>
                <input type="text" name="location_label" id="company_name" value="<%=isAdd?"":purchaseLocation.location_label %>" class="shipInput" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>收货地址<span class=" red">*</span></label>
                <div style="padding-left:130px;">
                  <div style="margin-top:5px;height:16px;">
                    <input type="radio" <%if (isAdd || (!isAdd && orderEdit.ship_to_type_id == (int)EMT.DoneNOW.DTO.DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.WORK_ADDRESS)) { %> checked="checked" <%} %> onclick="SelectShipAddr(0)" value="0" name="shipAddr" style="width: 16px;height:16px;" class="shipInput" /><span style="float:left;margin-left:5px;">本公司</span>
                  </div>
                  <div style="margin-top:5px;height:16px;">
                    <input type="radio" <%if (!isAdd && orderEdit.ship_to_type_id == (int)EMT.DoneNOW.DTO.DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.OTHER_ADDRESS) { %> checked="checked" <%} %> name="shipAddr" onclick="SelectShipAddr(1)" value="1" style="width: 16px;height:16px;" class="shipInput" /><span style="float:left;margin-left:5px;">其他地址</span>
                  </div>
                  <div style="margin-top:5px;height:16px;">
                    <input type="radio" <%if (!isAdd && orderEdit.ship_to_type_id == (int)EMT.DoneNOW.DTO.DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.SELECTED_COMPANY) { %> checked="checked" <%} %> name="shipAddr" id="shipAddrSelected" onclick="SelectShipAddr(2)" value="2" disabled="disabled" style="width: 16px;height:16px;" class="shipInput" /><span style="float:left;margin-left:5px;">采购客户地址</span>
                  </div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>采购客户</label>
                <input type="text" readonly="readonly" id="purchaseCompany" <%if (!isAdd && orderEdit.purchase_account_id != null) { %> value="<%=new EMT.DoneNOW.BLL.CompanyBLL().GetCompany((long)orderEdit.purchase_account_id).name %>" <%} %> />
                <input type="hidden" name="purchase_account_id" id="purchaseCompanyHidden" <%if (!isAdd) { %> value="<%=orderEdit.purchase_account_id %>" <%} %> />
                <i onclick="window.open('../Common/SelectCallBack?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=purchaseCompany&callBack=SelectPurchase','_blank','left=200,top=200,width=900,height=750', false);" style="width: 20px; height: 20px; float: left; margin-left: 2px; margin-top: 6px; background: url(../Images/data-selector.png) no-repeat;" id="purchaseCompanySelect"></i>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>省份<span class=" red">*</span></label>
                <input id="province_idInit" value='<%=isAdd?0:purchaseLocation.province_id %>' type="hidden" />
                <select name="province_id" id="province_id"  class="shipInput">
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>城市<span class=" red">*</span></label>
                <input id="city_idInit" value="<%=isAdd?0:purchaseLocation.city_id %>"  type="hidden" />
                <select name="city_id" id="city_id"  class="shipInput">
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>区县<span class=" red">*</span></label>
                <input id="district_idInit" value='<%=isAdd?0:purchaseLocation.district_id %>' type="hidden" />
                <select name="district_id" id="district_id"  class="shipInput">
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>地址<span class="red">*</span></label>
                <input type="text" name="address" id="address" value="<%=isAdd?"":purchaseLocation.address %>" class="shipInput" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>补充地址</label>
                <input type="text" name="additional_address" id="additional_address" value="<%=isAdd?"":purchaseLocation.additional_address %>" class="shipInput" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>邮编</label>
                <input type="text" name="postal_code" id="postal_code" value="<%=isAdd?"":purchaseLocation.postal_code %>" class="shipInput" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>电话</label>
                <input type="text" name="phone" id="phone" value="<%=isAdd?"":orderEdit.phone %>" class="shipInput" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>传真</label>
                <input type="text" name="fax" id="fax" value="<%=isAdd?"":orderEdit.fax %>" class="shipInput" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>配送类型</label>
                <select id="shipping_type_id" name="shipping_type_id" class="shipInput">
                  <option></option>
                  <%foreach (var term in shipCate) { %>
                  <option value="<%=term.val %>" <%if (!isAdd && orderEdit.shipping_type_id != null && orderEdit.shipping_type_id.ToString() == term.val) { %> selected="selected" <%} %> ><%=term.show %></option>
                  <%} %>
                </select>
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>配送日期</label>
                <input type="text" name="expected_ship_date" id="expected_ship_date" onclick="WdatePicker()" class="Wdate shipInput" value="<%=(!isAdd && orderEdit.expected_ship_date != null) ? ((DateTime)(orderEdit.expected_ship_date)).ToString("yyyy-MM-dd") : "" %>" />
              </div>
            </td>
          </tr>
          <tr>
            <td>
              <div class="clear">
                <label>运费</label>
                <input type="text" name="freight_cost" id="freight_cost" value="<%=(!isAdd && orderEdit.freight_cost != null) ? ((decimal)(orderEdit.freight_cost)).ToString() : "" %>" class="shipInput" />
              </div>
            </td>
          </tr>
        </table>
        <input type="hidden" id="orderId" value="<%=orderId %>" />
        <input type="hidden" id="subAct" name="subAct" />
      </div>
    </div>

    <div id="showItem" style="width:100%;">
      <iframe id="itemFrame" src="../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ITEM %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PurchaseItem %>&con1171=<%=orderId %>" style="overflow: scroll;width:100%;height:100%;border:0px;"></iframe>
    </div>
    <div id="background" style="left:0px;top:0px;opacity:0.6;z-index:300;width:100%;height:100%;position:fixed;display:none;background-color:rgb(27,27,27);overflow:hidden;"></div>
    <div id="memo" style="display:none;z-index:301;position:absolute;top:220px;left:260px;width:430px;height:450px;background-color:white;">
      <div class="header" style="height:32px;">新增或编辑备注</div>
      <div id="CancleMemo" style="position:absolute;height:32px;width:32px;top:0px;right:0px;background: url(../Images/cancel1.png);"></div>
      <div class="header-title">
        <ul>
          <li id="SaveMemo">
            <i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
            <input type="button" value="保存并关闭" />
          </li>
        </ul>
      </div>
      <div style="padding:0 10px 0 10px;">
        <label style="font-weight:normal;">请输入或编辑采购项的备注</label><br />
        <label style="margin-top:6px;">备注</label><br />
        <textarea style="width:260px;height:100px;" id="itemMemo"></textarea><br />
        <label style="margin-top:6px;">预计到达日期</label><br />
        <input type="text" class="Wdate" onclick="WdatePicker()" id="itemArrDate" />
      </div>
    </div>
  </form>
  <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
  <script src="../Scripts/common.js"></script>
  <script src="../Scripts/index.js"></script>
  <script type="text/javascript" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
  <script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
  <script type="text/javascript">
    $(document).ready(function () {
      <% if (!isAdd && (orderEdit.status_id == (int)EMT.DoneNOW.DTO.DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_FULL
          ||orderEdit.status_id == (int)EMT.DoneNOW.DTO.DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_PARTIAL)) { %>
      $(".shipInput").attr("disabled", "disabled");
      $("#purchaseCompanySelect").removeAttr('onclick');
      $("#vendorCompanySelect").removeAttr('onclick');
      $("#SaveSubmit").hide();
    <%} else if (!isAdd && orderEdit.status_id == (int)EMT.DoneNOW.DTO.DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED) { %>
      $("#SaveSubmit").hide();
    <%} %>
      InitArea();
    });
    $("#SaveClose").click(function () {
      $("#subAct").val("SaveClose");
      if (submitCheck())
        $("#form1").submit();
    })
    $("#Cancle").click(function () {
      $("#subAct").val("Cancle");
      $("#form1").submit();
    })
    $("#SaveSubmit").click(function () {
      $("#subAct").val("SaveSubmit");
      $("#form1").submit();
    })
    $("#SubmitEmail").click(function () {
      $("#subAct").val("SubmitEmail");
      $("#form1").submit();
    })
    function submitCheck() {
      if ($("#venderNameHidden").val() == "") {
        LayerMsg("请选择供应商");
        return false;
      }
      if ($("#district_id").val() == "") {
        LayerMsg("请选择收货地址");
        return false;
      }
      if ($("#address").val() == "") {
        LayerMsg("请填写收货地址");
        return false;
      }
      return true;
    }
      var Height = $(window).height() - 693 + "px";
      if (Height < 150)
          Height = 150;
    $("#showItem").css("height", Height);

    $(window).resize(function () {
        var Height = $(window).height() - 693 + "px";
        if (Height < 150)
            Height = 150;
      $("#showItem").css("height", Height);
      })
      $("#generalInfo").click(function () {
          var Height = $(window).height() - 693 + "px";
          if (Height < 150)
              Height = 150;
          $("#showItem").css("height", Height);
      })
    var haveVendor = 0;
    function SelectVendor() {
      if ($("#venderNameHidden").val() == "") {
        haveVendor = 0;
        return;
      } else {
        haveVendor = 1;
        requestData("/Tools/CompanyAjax.ashx?act=propertyJson&account_id=" + $("#venderNameHidden").val() + "&property=tax_region_id", null, function (data) {
          $("#tax_region_id").val(data);
          $("#autoFillOrder1").attr("disabled", false);
          $("#autoFillOrder2").attr("disabled", false);
        })
      }
    }
    function SelectPurchase() {
      if ($("#purchaseCompanyHidden").val() == "") {
        $("#shipAddrSelected").attr("disabled", "disabled");
        $("#shipAddrSelected").removeAttr("checked");
        $("#province_idInit").val(0);
        InitArea();
        $("#company_name").val("");
        $("#phone").val("");
        $("#fax").val("");
        $("#address").val("");
        $("#additional_address").val("");
        $("#postal_code").val("");
      } else {
        $("#shipAddrSelected").attr("disabled", false);
        var selval = $('input:radio[name="shipAddr"]:checked').val();
        if (selval == 2) {
          var accId = $("#purchaseCompanyHidden").val();
          requestData("/Tools/CompanyAjax.ashx?act=Location&account_id=" + accId, null, function (data) {
            $("#province_idInit").val(data.province_id);
            $("#city_idInit").val(data.city_id);
            $("#district_idInit").val(data.district_id);
            InitArea();
            $("#address").val(data.address);
            $("#additional_address").val(data.additional_address);
            $("#postal_code").val(data.postal_code);
            $("#company_name").val(data.location_label);
          })
          requestData("/Tools/CompanyAjax.ashx?act=propertyJson&account_id=" + accId + "&property=phone", null, function (data) {
            $("#phone").val(data);
          })
          requestData("/Tools/CompanyAjax.ashx?act=propertyJson&account_id=" + accId + "&property=fax", null, function (data) {
            $("#fax").val(data);
          })
        }
      }
    }
    function SelectShipAddr(type) {
      if (type == 1) {
        $("#province_idInit").val(0);
        InitArea();
        $("#company_name").val("");
        $("#phone").val("");
        $("#fax").val("");
        $("#address").val("");
        $("#additional_address").val("");
        $("#postal_code").val("");
        return;
      }
      var accId = <%=thisCompanyId %>;
      if (type == 2)
        accId = $("#purchaseCompanyHidden").val();
      requestData("/Tools/CompanyAjax.ashx?act=Location&account_id=" + accId, null, function (data) {
        $("#province_idInit").val(data.province_id);
        $("#city_idInit").val(data.city_id);
        $("#district_idInit").val(data.district_id);
        InitArea();
        $("#address").val(data.address);
        $("#additional_address").val(data.additional_address);
        $("#postal_code").val(data.postal_code);
        $("#company_name").val(data.location_label);
      })
      requestData("/Tools/CompanyAjax.ashx?act=propertyJson&account_id=" + accId + "&property=phone", null, function (data) {
        $("#phone").val(data);
      })
      requestData("/Tools/CompanyAjax.ashx?act=propertyJson&account_id=" + accId + "&property=fax", null, function (data) {
        $("#fax").val(data);
      })
    }
    <%if (isAdd || (!isAdd && orderEdit.ship_to_type_id == (int)EMT.DoneNOW.DTO.DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.WORK_ADDRESS)) { %>
    SelectShipAddr(0);
    <%} %>
    $("#autoFillOrder1").click(function () {
      if (haveVendor == 0) {
        return;
      }
      requestData("/Tools/PurchaseOrderAjax.ashx?act=AddPurchaseItemDefault&isDefault=1&vendorId=" + $("#venderNameHidden").val(), null, function (data) {
        $("#itemFrame").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ITEM %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PurchaseItem %>&con1171=<%=orderId %>");
      })
      $("#autoFillOrder1").attr("disabled", true);
      $("#autoFillOrder2").attr("disabled", true);
    })
    $("#autoFillOrder2").click(function () {
      if (haveVendor == 0) {
        return;
      }
      requestData("/Tools/PurchaseOrderAjax.ashx?act=AddPurchaseItemDefault&isDefault=0&vendorId=" + $("#venderNameHidden").val(), null, function (data) {
        $("#itemFrame").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ITEM %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PurchaseItem %>&con1171=<%=orderId %>");
      })
      $("#autoFillOrder1").attr("disabled", true);
      $("#autoFillOrder2").attr("disabled", true);
    })
    var itemId = 0;
    function editMemo(id) {
      itemId = id;
      requestData("/Tools/PurchaseOrderAjax.ashx?act=getItemMemo&id=" + id, null, function (data) {
        $("#itemMemo").val(data[0]);
        $("#itemArrDate").val(data[1]);
        $("#background").show();
        $("#memo").show();
      })
    }
    $("#SaveMemo").click(function () {
      $("#background").hide();
      $("#memo").hide();
      requestData("/Tools/PurchaseOrderAjax.ashx?act=setItemMemo&id=" + itemId + "&memo=" + $("#itemMemo").val() + "&date=" + $("#itemArrDate").val(), null, function (data) {
        $("#itemFrame").attr("src", "../Common/SearchBodyFrame?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.PURCHASE_ITEM %>&type=<%=(int)EMT.DoneNOW.DTO.QueryType.PurchaseItem %>&con1171=<%=orderId %>");
      })
    })
    $("#CancleMemo").click(function () {
      $("#background").hide();
      $("#memo").hide();
    })
</script>
</body>
</html>
