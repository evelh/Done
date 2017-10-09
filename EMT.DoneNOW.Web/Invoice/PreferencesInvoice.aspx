<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PreferencesInvoice.aspx.cs" Inherits="EMT.DoneNOW.Web.Invoice.PreferencesInvoice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>发票设置</title>
    <link href="../../Content/reset.css" rel="stylesheet" />
    <link href="../../Content/NewConfigurationItem.css" rel="stylesheet" />
    <style>
        #_ctl3_chkTaxExempt_ATCheckBox{
            vertical-align: middle;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!--顶部-->
    <div class="TitleBar">
        <div class="Title">
            <span class="text1">发票设置</span>
            <a href="###" class="collection"></a>
            <a href="###" class="help"></a>
        </div>
    </div>
    <!--按钮-->
    <div class="ButtonContainer">
        <ul id="btn">
            <li class="Button ButtonIcon NormalState" id="SaveAndCloneButton" tabindex="0">
                <span class="Icon SaveAndClone"></span>
                <span class="Text">
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" /></span>
            </li>
            <li class="Button ButtonIcon NormalState" id="CancelButton" tabindex="0">
                <span class="Icon Cancel"></span>
                <span class="Text">取消</span>
            </li>
        </ul>
    </div>
    <!--内容-->
    <div class="DivScrollingContainer Tab" style="top:82px;">
        <div class="DivSectionWithHeader">
            <!--头部-->
            <div class="HeaderRow">
                <div class="Toggle Collapse Toggle1">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <span class="lblNormalClass">常规</span>
            </div>
            <div class="Content">
                <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td>
                                <div>
                                    <table cellpadding="0" cellspacing="0" style="width:100%;">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabel">
                                                    发票模板<span class="errorSmallClass" style="color:red;">*</span>
                                                    <div>
                                                        <asp:DropDownList ID="invoice_tmpl_id" runat="server" Width="250px"></asp:DropDownList>
                                                   
                                                        <img src="../Images/add.png" style="vertical-align: middle;">
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    &nbsp;
                                                    <div>
                                                        <asp:CheckBox ID="nocontract_bill_to_parent" runat="server" />
                                            <%--            <input type="checkbox" style="vertical-align: middle;" disabled>--%>
                                                        无合同条目父客户计费
                                                    </div>
                                                </td>
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
        <div class="DivSectionWithHeader">
            <!--头部-->
            <div class="HeaderRow">
                <div class="Toggle Collapse Toggle2">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <span class="lblNormalClass">税收</span>
            </div>
            <div class="Content">
                <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td>
                                <div>
                                    <table cellpadding="0" cellspacing="0" style="width:100%;">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabel">
                                                    <div>
                                                        <asp:CheckBox ID="_ctl3_chkTaxExempt_ATCheckBox" runat="server" />
                                              
                                                        免税
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel">
                                                    税区
                                                    <div>
                                                        <asp:DropDownList ID="tax_region_id" runat="server" Width="250px"></asp:DropDownList>
                                                        &nbsp;  &nbsp;
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    税号
                                                    <div>
                                                        <input type="text" name="tax_identification" id="tax_identification" style="width: 250px;" value="<%=account!=null?account.tax_identification:"" %>" /> 
                                                    </div>
                                                </td>
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
        <div class="DivSectionWithHeader">
            <!--头部-->
            <div class="HeaderRow">
                <div class="Toggle Collapse Toggle3">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <span class="lblNormalClass">发票地址</span>
            </div>
            <div class="Content">
                <div class="SectionLevelInstruction">
                    <span class="lblNormalClass" style="font-weight:normal;color: #666;">
                    <%--    Please note: If you have already exported this company to QuickBooks, manually update this company's address in QuickBooks.--%>
                    </span>
                    <input type="hidden" name="billing_location_id" id="billing_location_id" value="<%=accRef!=null&&accRef.billing_location_id!=null?accRef.billing_location_id.ToString():"" %>"/>
                </div>
                <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td>
                                <div>
                                    <table cellpadding="0" cellspacing="0" style="width:100%;">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabel" style="width: 390px;">
                                                    &nbsp;
                                                    <div>
                                                        <asp:RadioButton ID="_ctl3_rdoAccount" runat="server" GroupName="_ctl3_rdoBillTo" />
                                                      <%--  <input type="radio" style="vertical-align: middle;" name="" id="">--%>
                                                        使用客户地址  
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    注意
                                                    <div>
                                                        <input type="text"  style="width: 250px;" id="attention" name="attention" value="<%=accRef!=null?accRef.attention:"" %>">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel">
                                                    &nbsp;
                                                    <div>
                                                        <asp:RadioButton ID="_ctl3_UseParent" runat="server" GroupName="_ctl3_rdoBillTo" />
                                                        <%--<input type="radio" style="vertical-align: middle;" name="_ctl3:rdoBillTo" id="" />  --%>                                                          使用父客户地址
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    地址
                                                    <div>
                                                        <input type="text"  style="width: 250px;" disabled value="<%=accRef!=null?accRef.address:"" %>" id="address" name="address" />
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel">
                                                    &nbsp;
                                                    <div>
                                                        <asp:RadioButton ID="_ctl3UseParInv" runat="server" GroupName="_ctl3_rdoBillTo" />
                                                   <%--     <input type="radio" style="vertical-align: middle;" name="_ctl3:rdoBillTo" id="" >--%>
                                                        使用父客户发票地址    
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    补充地址
                                                    <div>
                                                        <input type="text"  style="width: 250px;" disabled value="<%=accRef!=null?accRef.additional_address:"" %>" id="additional_address" name="additional_address">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel">
                                                    &nbsp;
                                                    <div>
                                                        <asp:RadioButton ID="_ctl3_rdoAccountBillTo" runat="server" GroupName="_ctl3_rdoBillTo" />
                                                        <%--<input type="radio" style="vertical-align: middle;" name="_ctl3:rdoBillTo" id="">--%>
                                                        手工输入地址  
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    省
                                                    <div>
                                                        <input type="hidden" id="province_idInit" value="<%=accRef!=null&&accRef.province_id!=null?accRef.province_id.ToString():"" %>" />
                                                         <select name="province_id" id="province_id" style="width: 264px;" disabled>
                                                        </select>
                                    
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel"></td>
                                                <td class="FieldLabel">
                                                    市
                                                    <div>
                                                        <input type="hidden" id="city_idInit" value="<%=accRef!=null&&accRef.city_id!=null?accRef.city_id.ToString():"" %>" />
                                                           <select name="city_id" id="city_id" style="width: 264px;" disabled>
                                                        </select>
                                                      
                                                    </div>
                                                </td>
                                            </tr>
                                                  <tr>
                                                <td class="FieldLabel"></td>
                                                <td class="FieldLabel">
                                                    区/县
                                                    <div>
                                                         <input type="hidden" id="district_idInit" value="<%=accRef!=null&&accRef.district_id!=null?accRef.district_id.ToString():"" %>" />
                                                          <select name="district_id" id="district_id" style="width: 264px;" disabled>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel"></td>
                                                <td class="FieldLabel">
                                                    邮编 
                                                    <div>
                                                        <input type="text"  style="width: 250px;" disabled value="<%=accRef!=null?accRef.postal_code:"" %>" id="postal_code" name="postal_code"  />
                                                    </div>
                                                </td>
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
       <%-- <div class="DivSectionWithHeader">
            <!--头部-->
            <div class="HeaderRow">
                <div class="Toggle Collapse Toggle4">
                    <div class="Vertical"></div>
                    <div class="Horizontal"></div>
                </div>
                <span class="lblNormalClass">EXTERNAL ACCOUNTING OPTIONS</span>
            </div>
            <div class="Content">
                <div class="SectionLevelInstruction">
                    <span class="lblNormalClass" style="font-weight:normal;color: #666;">
                        This will determine the default setting for invoices and purchase orders that are transferred to QuickBooks.
                    </span>
                </div>
                <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td>
                                <div>
                                    <table cellpadding="0" cellspacing="0" style="width:100%;">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabel">
                                                    Transmission Method
                                                    <div>
                                                        <select name="" id="" style="width:250px;">
                                                            <option value=""></option>
                                                            <option value="">1111</option>
                                                            <option value="">111111</option>
                                                        </select>
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>--%>
        <div class="DivSectionWithHeader" style="background-color: #efefef;">
            <!--头部-->
            <div class="HeaderRow">
                <div class="Toggle5" style="margin: 2px 6px 0 6px;float: left;">
                    <asp:CheckBox ID="enable_email" runat="server" /> <%--<input type="checkbox" style="width:16px;height:16px;">--%>
                </div>
                <span class="lblNormalClass">支持发邮件</span>

                <input type="hidden" name="email_to_contacts" id="email_to_contacts" value="<%=accRef!=null?accRef.email_to_contacts:"" %>"/>
                <input type="hidden" name="email_bcc_resources" id="email_bcc_resources" value="<%=accRef!=null?accRef.email_bcc_resources:"" %>"/>
                <input type="hidden" name="email_bcc_account_manager" id="email_bcc_account_manager" value="<%=accRef!=null?accRef.email_bcc_account_manager:"" %>"/>
                <input type="hidden" name="email_notes" id="email_notes" value="<%=accRef!=null?accRef.email_notes:"" %>"/>
                <input type="hidden" name="" id="" value=""/>
            </div>
            <!--内容-->
            <div class="Content" style="display: none;">
                <table class="Neweditsubsection" style="width: 780px;" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td>
                                <div>
                                    <table cellpadding="0" cellspacing="0" style="width:100%;">
                                        <tbody>
                                            <tr>
                                                <td class="FieldLabel" style="width: 390px;">
                                                    通知
                                                    <div>
                                                        <input type="checkbox" id="chooseManage" style="vertical-align: middle;">
                                                        客户经理(BCC)
                                                        <span class="FieldLevelInstruction"></span>
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    邮件模板
                                                    <div>
                                                        <asp:DropDownList ID="invoice_email_message_tmpl_id" runat="server" Width="264px"></asp:DropDownList>
                                                      
                                                        <img src="../Images/add.png" alt="">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel">
                                                    联系人(To)
                                                    <span class="FieldLevelInstruction"></span>
                                                    <div style="height: 95px; width: 258px; overflow: auto; z-index: 0;border: 1px solid #d3d3d3;">
                                                        <table class="dataGridBody" cellspacing="0" style="width:100%;border-collapse:collapse;" border="1">
                                                            <tbody>
                                                                <%if (contractList != null && contractList.Count > 0)
                                                                    {
                                                                        foreach (var contract in contractList)
                                                                        {
                                                                        %>
                                                                   <tr class="dataGridBody dataGridBodyHover" style="height:22px;">
                                                                    <td align="center">
                                                                        <span class="txtBlack8Class">
                                                                             <input type="checkbox" class="contractCheck" id="<%=contract.id %>_check" style="vertical-align: middle;" value="<%=contract.id %>" />
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <span><%=contract.name %></span>
                                                                    </td>
                                                                    <td>
                                                                        <span><%=contract.email %></span>
                                                                    </td>
                                                                </tr>
                                                                <%} }%>
                                                             
                                                                
                                                              
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                                <td class="FieldLabel">
                                                    员工
                                                    <span class="FieldLevelInstruction"></span>
                                                    <div style="height: 95px; width: 258px; overflow: auto; z-index: 0;border: 1px solid #d3d3d3;">
                                                        <table class="dataGridBody" cellspacing="0" style="width:100%;border-collapse:collapse;" border="1">
                                                            <tbody>
                                                                   <%if (resourceList != null && resourceList.Count > 0)
                                                                    {
                                                                        foreach (var source in resourceList)
                                                                        {
                                                                        %>
                                                                   <tr class="dataGridBody dataGridBodyHover" style="height:22px;">
                                                                    <td align="center">
                                                                        <span class="txtBlack8Class">
                                                                             <input type="checkbox" class="sourceCheck" id="<%=source.id %>_check" style="vertical-align: middle;" value="<%=source.id %>" />
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <span><%=source.name %></span>
                                                                    </td>
                                                                    <td>
                                                                        <span><%=source.email %></span>
                                                                    </td>
                                                                </tr>
                                                                <%} }%>
                                                                <tr class="dataGridBody dataGridBodyHover" style="height:22px;">
                                                                    <td align="center">
                                                                            <span class="txtBlack8Class">
                                                                                 <input type="checkbox" style="vertical-align: middle;">
                                                                            </span>
                                                                    </td>
                                                                    <td>
                                                                        <span>Li, Hong</span>
                                                                    </td>
                                                                    <td>
                                                                        <span>hong.li@itcat.net.cn</span>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel" colspan="2">
                                                   其他联系人(To)
                                                    <span class="FieldLevelInstruction"></span>
                                                    <div>
                                                        <input type="text" name="email_to_others" id="email_to_others" style="width:636px;" value="<%=accRef!=null?accRef.email_to_others:"" %>"/>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="FieldLabel" colspan="2">
                                                    <span class="FieldLevelInstruction"></span>
                                                </td>
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

    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js"></script>
<script src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script src="../Scripts/NewConfigurationItem.js"></script>
<script src="../Scripts/Common/Address.js"></script>
<script src="../Scripts/common.js"></script>
<script>
     $(function () {
         InitArea();
         CheckByValue();
         <%if (parentAccount == null)
        { %>
         $("#_ctl3_UseParent").prop("disabled", true);  
         $("#_ctl3UseParInv").prop("disabled", true);
         <%} %>

         <%if (accRef == null)
        { %>
         GetLocationByAccount();
         $("#_ctl3_rdoAccount").prop("checked", true);
         <%}%>

         if ($("#enable_email").is(":checked")) {
             $(this).parent().parent().find($('.Content')).toggle();
             $(this).parent().parent().css("background", colors[index5 % 2]);
             index5++;
         }

    });

    function GetLocationByAccount() {
        var account_id = <%=account.id %>;
        if (account_id != "") {
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=Location&account_id=" + account_id,
                dataType: "json",
                success: function (data) {
                    if (data != "") {
                        debugger;
                        $("#province_idInit").val(data.province_id);
                        $("#city_idInit").val(data.city_id);
                        $("#district_idInit").val(data.district_id);
                        $("#address").val(data.address);
                        $("#additional_address").val(data.additional_address);
                        $("#postal_code").val(data.postcode);
                        InitArea();
                    }
                },

            });
             }
    }

    $("#save_close").click(function () {
        var invoice_tmpl_id = $("#invoice_tmpl_id").val();
        if (invoice_tmpl_id == undefined || invoice_tmpl_id == "0") {
            alert("请选择发票模板");
            return false;
        }
        $("#address").prop("disabled", false);
        $("#additional_address").prop("disabled", false);
        $("#province_id").prop("disabled", false);
        $("#district_id").prop("disabled", false);
        $("#city_id").prop("disabled", false);
        $("#postal_code").prop("disabled", false);
        $("#tax_region_id").prop("disabled", false);
        GetCheckValue();
        return true;
    })
    $("#CancelButton").click(function () {
        window.close();
    })
    // 将通知中选中的信息以，分割存入隐藏input中，
    function GetCheckValue() {
        debugger;
        // 选中客户经理
        if ($("#chooseManage").is(":checked")) {
            $("#email_bcc_account_manager").val('<%=account.resource_id %>');
        }
        // 选中联系人
        var contactIds = "";
        $(".contractCheck").each(function () {
            if ($(this).is(":checked")) {
                contactIds += $(this).val() + ',';
            }
        })
        if (contactIds != "") {
            contactIds = contactIds.substring(0, contactIds.length - 1);
            $("#email_to_contacts").val(contactIds);
        }
        debugger;
        // 选中员工
        var sourceIds = "";
        $(".sourceCheck").each(function () {
            if ($(this).is(":checked")) {
                sourceIds += $(this).val() + ',';
            }
        })
        if (sourceIds != "") {
            sourceIds = sourceIds.substring(0, sourceIds.length - 1);
            $("#email_bcc_resources").val(sourceIds);
        }

    }
    // 根据隐藏的input ，为页面上的check赋值
    function CheckByValue() {
        var manage = $("#email_bcc_account_manager").val();
        if (manage != "") {
            $("#chooseManage").prop("checked", true);
        }
        var contactIds = $("#email_to_contacts").val();
        if (contactIds != "") {
            var contactArr = contactIds.split(',');
            for (var i = 0; i < contactArr.length; i++) {
                $("#" + contactArr[i] + "_check").prop("checked", true);
            }
        }
        var sourceIds = $("#email_bcc_resources").val();
        if (sourceIds != "") {
            var sourceArr = sourceIds.split(',');
            for (var i = 0; i < sourceArr.length; i++) {
                $("#" + sourceArr[i] + "_check").prop("checked", true);
            }
        }
    }

        $("#_ctl3_chkTaxExempt_ATCheckBox").on("click",function(){
            var _this=$(this);
            if(_this.is(":checked")){
                $("#tax_region_id").prop("disabled",true);
            }else{
                $("#tax_region_id").prop("disabled",false);
            }
        });
        $("#_ctl3_rdoAccount").on("click",function(){ // 使用客户地址
            $("#address").prop("disabled",true);
            $("#additional_address").prop("disabled",true);
            $("#province_id").prop("disabled",true);
            $("#district_id").prop("disabled", true);
            $("#city_id").prop("disabled", true);
            $("#postal_code").prop("disabled", true);
            var account_id = <%=account.id %>;
            debugger;
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=Location&account_id=" + account_id,
                dataType:"json",
                success: function (data) {
                    if (data != "") {
                        debugger;
                        $("#biling_location_id").val(data.id);  // 应用客户的地址
                        $("#province_idInit").val(data.province_id);
                        $("#city_idInit").val(data.city_id);
                        $("#district_idInit").val(data.district_id);
                        $("#address").val(data.address);
                        $("#additional_address").val(data.additional_address);
                        $("#postal_code").val(data.postcode);
                        InitArea();
                    }
                },
               
            });
      
         });
     
        $("#_ctl3_UseParent").on("click", function () { // 使用父客户地址
            $("#address").prop("disabled", true);
            $("#additional_address").prop("disabled", true);
            $("#province_id").prop("disabled", true);
            $("#district_id").prop("disabled", true);
            $("#city_id").prop("disabled", true);
            $("#postal_code").prop("disabled", true);
            var account_id = <%=parentAccount!=null?parentAccount.id.ToString():"0" %>;
            if (account_id != "0") {
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/CompanyAjax.ashx?act=Location&account_id=" + account_id,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            $("#biling_location_id").val(data.id);  // 引用父客户的地址
                            $("#province_idInit").val(data.province_id);
                            $("#city_idInit").val(data.city_id);
                            $("#district_idInit").val(data.district_id);
                            $("#address").val(data.address);
                            $("#additional_address").val(data.additional_address);
                            $("#postal_code").val(data.postcode);
                            InitArea();
                        }
                    },
                });
            }
          
        });
     
        $("#_ctl3UseParInv").on("click", function () { // 使用父客户的发票地址
            $("#address").prop("disabled", true);
            $("#additional_address").prop("disabled", true);
            $("#province_id").prop("disabled", true);
            $("#district_id").prop("disabled", true);
            $("#city_id").prop("disabled", true);
            $("#postal_code").prop("disabled", true);
            var account_id = <%=parentAccount!=null?parentAccount.id.ToString():"0" %>;
            if (account_id != "0") {
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/CompanyAjax.ashx?act=AccReference&account_id=" + account_id,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            $("#biling_location_id").val(data.id);  // 引用父客户的发票地址
                            $("#province_idInit").val(data.province_id);
                            $("#city_idInit").val(data.city_id);
                            $("#district_idInit").val(data.district_id);
                            $("#address").val(data.address);
                            $("#additional_address").val(data.additional_address);
                            $("#postal_code").val(data.postcode);
                            InitArea();
                        }
                    },
                });
            }
        });

        $("#_ctl3_rdoAccountBillTo").on("click",function(){ // 手工输入地址
            $("#address").prop("disabled", false);
            $("#address").val("");
            $("#additional_address").prop("disabled", false);
            $("#additional_address").val("");
            $("#province_id").prop("disabled",false);
            $("#district_id").prop("disabled", false);
            $("#city_id").prop("disabled", false);
            $("#postal_code").prop("disabled", false);
            $("#biling_location_id").val("");

            <%if (accRef != null && accRef.billing_location_id != null)
            { %>
            $("#biling_location_id").val('<%=accRef.billing_location_id %>');
            <%}%>
            var location_id = $("#biling_location_id").val();
            if (location_id != undefined && location_id != "") {
                $.ajax({
                    type: "GET",
                    async: false,
                    url: "../Tools/AddressAjax.ashx?act=location&location_id=" + location_id,
                    dataType: "json",
                    success: function (data) {
                        if (data != "") {
                            $("#biling_location_id").val(data.id);  // 引用父客户的发票地址
                            $("#province_idInit").val(data.province_id);
                            $("#city_idInit").val(data.city_id);
                            $("#district_idInit").val(data.district_id);
                            $("#address").val(data.address);
                            $("#additional_address").val(data.additional_address);
                            $("#postal_code").val(data.postcode);
                            InitArea();
                        }
                    },
                });
            }


            InitArea();
        });
    </script>