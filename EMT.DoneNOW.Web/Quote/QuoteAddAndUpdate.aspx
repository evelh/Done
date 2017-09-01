<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteAddAndUpdate.aspx.cs" Inherits="EMT.DoneNOW.Web.Quote.QuoteAddAndUpdate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增报价":"修改报价" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server" style="min-width:500px;width:100%;">
        <div class="header"><%=isAdd?"添加报价":"修改报价" %></div>
        <div class="header-title">
            <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_open_quote" runat="server" Text="保存并打开报价" BorderStyle="None" OnClick="save_open_quote_Click" />
                </li>
                <li id="close">关闭</li>
            </ul>
        </div>
        <%--  <div style="float: left;">
            <asp:DropDownList ID="formTemplate" runat="server"></asp:DropDownList>
        </div>--%>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders" id="">常规信息</li>
                <li id="">销售订单</li>
                <li id="">通知</li>
            </ul>
        </div>
        <div style="left: 0;overflow-x: auto;overflow-y: auto;position: fixed;right: 0;bottom: 0;top:132px;">
        <div class="content clear">
            <div>
                <table border="none" cellspacing="" cellpadding="" style="width: 400px;">
                    <tr>
                        <td>
                            <div class="clear" style="width:410px;">
                                <label>客户<span class="red">*</span></label>
                                <%if (isAdd)
                                    { %>
                                <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="<%=isAdd ? ((isAdd && account != null) ? account.name : "") : companyBLL.GetCompany(quote.account_id).name %>" />
                                <i onclick="chooseCompany();" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                <i onclick="javascript:window.open('../Company/AddCompany.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>','left=200,top=200,width=600,height=800', false)" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                <%--<input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=isAdd?"":quote.account_id.ToString() %>" />--%>
                                <input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=isAdd && account != null ? account.id.ToString() : (!isAdd && account != null) ? account.id.ToString() : "" %>" />
                                <%}
                                    else
                                    { %>
                                <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="<%=companyBLL.GetCompany(quote.account_id).name %>" disabled="disabled" />
                                <i style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                <i onclick="javascript:window.open('../Company/AddCompany.aspx','<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>','left=200,top=200,width=600,height=800', false)" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                <%--<input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=isAdd?"":quote.account_id.ToString() %>" />--%>
                                <input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=quote.account_id %>" />
                                <%} %>
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>商机名称</label>
                                <%if (isAdd)
                                    { %>
                                <select name="opportunity_id" id="opportunity_id">
                                </select><input type="hidden" name="opportunity_idHidden" id="opportunity_idHidden" value="<%=(isAdd && opportunity != null) ? opportunity.id.ToString() : (!isAdd ? quote.opportunity_id.ToString() : "") %>" />
                                <i onclick="AddOppo()",'<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>','left=200,top=200,width=600,height=800', false)" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                <%}
                                    else
                                    { %>
                                <select name="opportunity_id" id="opportunity_id" disabled="disabled">
                                </select><input type="hidden" name="opportunity_idHidden" id="opportunity_idHidden" value="<%= quote.opportunity_id %>" />
                                <i onclick="AddOppo()" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                <%} %>
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>报价名称<span class="red">*</span></label>
                                <input type="text" name="name" id="name" value="<%=isAdd?"":quote.name %>" />
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="clear">
                                <label>报价描述</label>
                                <textarea style="width: 180px;" name="description" id="description"><%=(!isAdd)&&(!string.IsNullOrEmpty(quote.description))?quote.description:"" %></textarea>


                            </div>
                        </td>
                    </tr>
                    <%if (!isAdd)
                        {%>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>报价ID</label>
                                <span name="oid"><%=quote.oid %></span>
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>创建日期<span class="red">*</span></label>
                                <span id="create_time" name="create_time" style="line-height: 35px;margin-left: -138px;"><%=DateTime.Now.ToString("dd/MM/yyyy") %></span>
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>有效日期</label>
                                <input onclick="WdatePicker()" type="text" class="sl_cdt" name="effective_date" id="effective_date" value="<%=(!isAdd)&&(quote.effective_date!=null)?quote.effective_date.ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>过期日期</label>
                                <input onclick="WdatePicker()" type="text" class="sl_cdt" name="expiration_date" id="expiration_date" value="<%=(!isAdd)&&(quote.expiration_date!=null)?quote.expiration_date.ToString("yyyy-MM-dd"):DateTime.Now.AddMonths(1).ToString("yyyy-MM-dd") %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>预计完成日期<span class="red">*</span></label>
                                <input onclick="WdatePicker()" type="text" class="sl_cdt" name="projected_close_date" id="projected_close_date" value="<%=(!isAdd)&&(quote.projected_close_date!=null)?quote.projected_close_date.ToString("yyyy-MM-dd"):DateTime.Now.ToString("yyyy-MM-dd") %>" <%if (!isAdd)
                                    { %>
                                    disabled="disabled" <%} %> />
                            </div>
                            <div style="margin-top: -29px; position:absolute;left:368px;">
                                <%if (isAdd)
                                    { %>
                                <a onclick="AddTime(0)">今天</a>|<a onclick="AddTime(7)">7</a>|<a onclick="AddTime(30)">30</a>|<a onclick="AddTime(60)">60</a><%} %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>成交概率</label>
                                <%if (isAdd)
                                    { %>
                                <input type="text" name="probability" id="probability" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                <%}
                                    else
                                    { %>
                                <input type="text" name="probability" id="probability" value="<%=opportunity.probability %>" disabled="disabled" maxlength="11" onkeyup="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" />
                                <%} %>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>联系人<span class="red">*</span></label>
                                <select name="contact_id" id="contact_id">
                                </select>
                                <input type="hidden" name="contact_idHidden" id="contact_idHidden" value="<%=(!isAdd&&quote.contact_id!=null)?quote.contact_id.ToString():"" %>" />
                                <i onclick="AddContact()" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>项目提案名称</label>
                                <select name="project_id" id="project_id">
                                </select>
                             <%--   <i onclick="javascript:window.open('../Contact/AddContact.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>')" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>--%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>税区</label><asp:DropDownList ID="tax_region_id" runat="server"></asp:DropDownList>
                                <%--<select name="tax_region_id" id="tax_region_id">
                                </select>--%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>激活的电子报价单</label>
                                <input type="checkbox" name="is_active" id="is_active" data-val="1" value="1" checked="<%=(!isAdd)&&(quote.is_active==1)?"checked":"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>报价模板</label><asp:DropDownList ID="quote_tmpl_id" runat="server"></asp:DropDownList>

                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="clear" style="text-align: left;">
                                <label></label>
                                <span style="margin-left: 10px;">税的显示方式在<a href="#">报价模板</a>中设置</span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>外部报价编号</label>
                                <input type="text" name="external_quote_no" id="external_quote_no" value="<%=(!isAdd)&&(!string.IsNullOrEmpty(quote.external_quote_no))?quote.external_quote_no:"" %>" />
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                
                                <label>报价注释</label>
                                <textarea style="width:180px;" name="quote_comment" id="quote_comment"><%=(!isAdd)&&(!string.IsNullOrEmpty(quote.quote_comment))?quote.quote_comment:"" %></textarea>
                            </div>
                        </td>

                    </tr>
                </table>

            </div>
        </div>
        <div class="content clear" style="display: none;">
            <div style="border: thin;">
                <table border="none" cellspacing="" cellpadding="" style="width: 100%;">
                    <tr>
                        <td>
                            <div class="clear">
                                <label>付款期限</label><asp:DropDownList ID="payment_term_id" runat="server"></asp:DropDownList>
                                <%--   <select name="payment_term_id" id="payment_term_id">
                                </select>--%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>付款类型</label><asp:DropDownList ID="payment_type_id" runat="server"></asp:DropDownList>
                                <%--    <select name="payment_type_id" id="payment_type_id">
                                </select>--%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>采购订单号</label>
                                <input type="text" name="purchase_order_no" id="purchase_order_no" value="<%=(!isAdd)&&(!string.IsNullOrEmpty(quote.purchase_order_no))?quote.purchase_order_no:"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>配送类型</label><asp:DropDownList ID="shipping_type_id" runat="server"></asp:DropDownList>
                                <%--    <select name="shipping_type_id" id="shipping_type_id">
                                </select>--%>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>

            <div>
                <div>
                    <table style="margin-top:30px;">
                        <%

                            EMT.DoneNOW.Core.crm_location sold_to_location = null;
                            EMT.DoneNOW.Core.crm_location bill_to_location = null;
                            EMT.DoneNOW.Core.crm_location ship_to_location = null;
                            if ((!isAdd) && (quote.sold_to_location_id != null))
                            {
                                sold_to_location = new EMT.DoneNOW.BLL.CRM.LocationBLL().GetLocation((long)quote.sold_to_location_id);
                            }
                            if ((!isAdd) && (quote.bill_to_location_id != null))
                            {
                                bill_to_location = new EMT.DoneNOW.BLL.CRM.LocationBLL().GetLocation((long)quote.bill_to_location_id);
                            }
                            if ((!isAdd) && (quote.ship_to_location_id != null))
                            {
                                ship_to_location = new EMT.DoneNOW.BLL.CRM.LocationBLL().GetLocation((long)quote.ship_to_location_id);
                            }

                        %>
                        <tr>
                            <td>
                                <div class="clear" style="margin-left:123px;">
                                    <input type="hidden" name="sold_to_location_id" id="locationID" value="" />
                                    <label style="font-weight:normal;">销售地址</label>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>省份</label>
                                    <input id="province_idInit" value="<%=sold_to_location==null?"":sold_to_location.province_id.ToString() %>" type="hidden"  />
                                    <select name="province_id" id="province_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>城市</label>
                                    <input id="city_idInit" value="<%=sold_to_location==null?"":sold_to_location.city_id.ToString() %>" type="hidden"  />
                                    <select name="city_id" id="city_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>区县</label>
                                    <input id="district_idInit" value='<%=sold_to_location==null?"":sold_to_location.district_id.ToString() %>' type="hidden"  />
                                    <select name="district_id" id="district_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>地址</label>
                                    <input type="text" name="address" id="address"  />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>补充地址</label>
                                    <input type="text" name="address2" id="address2" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>邮编</label>
                                    <input type="text" name="postcode" id="postcode" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div>
                    <table style="margin-top:30px;">
                        <tr>
                            <td style="text-align:left;">
                                <div class="clear" style="margin-left:140px;">
                                    <input type="checkbox" name="BillLocation" id="BillLocation"  runat="server"/> 
                                    <label style="font-weight:normal;">账单地址和销售地址相同</label>
                                    <input type="hidden" name="bill_to_location_id" id="bill_to_location_id" value="<%=bill_to_location==null?"":bill_to_location.id.ToString() %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>省份</label>
                                      <input id="bill_province_idInit" value="<%=bill_to_location==null?"":bill_to_location.province_id.ToString() %>" type="hidden"  />
                                    <select name="bill_province_id" id="bill_province_id" class="billLoca">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>城市</label>
                                     <input id="bill_city_idInit" value="<%=bill_to_location==null?"":bill_to_location.city_id.ToString() %>" type="hidden"  />
                                    <select name="bill_city_id" id="bill_city_id" class="billLoca">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>区县</label>
                                     <input id="bill_district_idInit" value="<%=bill_to_location==null?"":bill_to_location.district_id.ToString() %>" type="hidden"  />
                                    <select name="bill_district_id" id="bill_district_id" class="billLoca">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>地址</label>
                                    <input type="text" name="bill_address" id="bill_address" class="billLoca" value="<%=bill_to_location==null?"":bill_to_location.address %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>补充地址</label>
                                    <input type="text" name="bill_address2" id="bill_address2" class="billLoca" value="<%=bill_to_location==null?"":bill_to_location.additional_address %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>邮编</label>
                                    <input type="text" name="bill_postcode" id="bill_postcode" class="billLoca" value="<%=bill_to_location==null?"":bill_to_location.postal_code %>" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div>
                    <table style="margin-top:30px;">
                        <tr>
                            <td style="text-align:left;">  
                                <div class="clear" style="margin-left:140px;">
                                    <input type="checkbox" name="ShipLocation" id="ShipLocation" runat="server"/>
                                    <label style="font-weight:normal;">配送地址和销售地址相同</label>
                                    <input type="hidden" name="ship_to_location_id" id="ship_to_location_id" value="<%=ship_to_location==null?"":ship_to_location.id.ToString() %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>省份</label>
                                      <input id="ship_province_idInit" value="<%=ship_to_location==null?"":ship_to_location.province_id.ToString() %>" type="hidden"  />
                                    <select name="ship_province_id" id="ship_province_id" class="shipLoca">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>城市</label>
                                     <input id="ship_city_idInit" value="<%=ship_to_location==null?"":ship_to_location.city_id.ToString() %>" type="hidden"  />
                                    <select name="ship_city_id" id="ship_city_id" class="shipLoca">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>区县</label>
                                     <input id="ship_district_idInit" value="<%=ship_to_location==null?"":ship_to_location.district_id.ToString() %>" type="hidden"  />
                                    <select name="ship_district_id" id="ship_district_id" class="shipLoca">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>地址</label>
                                    <input type="text" name="ship_address" id="ship_address" class="shipLoca" value="<%=ship_to_location==null?"":ship_to_location.address %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>补充地址</label>
                                    <input type="text" name="ship_address2" id="ship_address2" class="shipLoca"   value="<%=ship_to_location==null?"":ship_to_location.additional_address %>" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>邮编</label>
                                    <input type="text" name="ship_postcode" id="ship_postcode" class="shipLoca" value="<%=ship_to_location==null?"":ship_to_location.postal_code %>"  />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="content clear" style="display: none;">
        </div>
            </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>

<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js"></script>
<script type="text/javascript" charset="utf-8" src="../Scripts/My97DatePicker/WdatePicker.js"></script>
<script>
    $(function () {

        var s1 = ["province_id", "city_id", "district_id"];
        var s2 = ["ship_province_id", "ship_city_id", "ship_district_id"];
       var s3 = ["bill_province_id", "bill_city_id", "bill_district_id"];
        InitArea(s1);  // 地址下拉框
        InitArea(s2);  // 地址下拉框
       
        //change(0, s2);
        //change(1, s2);
        InitArea(s3);  // 地址下拉框
        //change(0, s3);
        //change(1, s3);
        GetDataBySelectCompany();  // 用于修改的时候赋值
        
        var opportunity_idHidden = $("#opportunity_idHidden").val();
        if (opportunity_idHidden != "") {

            $("#opportunity_id").val(opportunity_idHidden);
        }

        var contact_idHidden = $("#contact_idHidden").val();
        if (contact_idHidden != "") {
            $("#contact_id").val(contact_idHidden);
        }


        $("#opportunity_id").change(function () {
            
            var opportunity_id = $("#opportunity_id").val();
            if (opportunity_id != 0 && opportunity_id != null && opportunity_id != undefined) {
                // 根据选中的商机为预计完成时间赋值
                $.ajax({
                    type: "GET",
                    //async: false,
                    url: "../Tools/OpportunityAjax.ashx?property=projected_close_date&act=property&id=" + opportunity_id,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        if (data != "") {
                            var date = new Date(data);
                            // date.setTime(data);
                            var newDate = date.getFullYear() + '-' + returnNumber((date.getMonth() + 1)) + '-' + returnNumber(date.getDate());

                            $("#projected_close_date").val(newDate);
                        }
                    },
                });
                // 根据选中的时间为联系人下拉赋值选中  // 注意 新增商机的时候联系人是可以为空
                $.ajax({
                    type: "GET",
                    //async: false,
                    url: "../Tools/OpportunityAjax.ashx?property=contact_id&act=property&id=" + opportunity_id,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        if (data != "") {
                            $("#contact_id").val(data);
                        }
                    },
                });


            }
        })


        $("#save_close").click(function () {
            if (!SubmitCheck()) {
                return false;
            }
            return true;
        })

        $("#save_open_quote").click(function () {
            if (!SubmitCheck()) {
                return false;
            }
            return true;
        })



        $("#BillLocation").click(function () {
            if ($(this).is(":checked")) {
                $("#bill_to_location_id").val($("#locationID").val());
                //  $("#bill_province_id").html($("#province_id").html());
                $("#bill_province_id").val($("#province_id").val());
                change(0, ["bill_province_id", "bill_city_id", "bill_district_id"]);
                //  $("#bill_city_id").html($("#city_id").html());
                $("#bill_city_id").val($("#city_id").val());
                change(1, ["bill_province_id", "bill_city_id", "bill_district_id"]);
                //   $("#bill_district_id").html($("#district_id").html());
                $("#bill_district_id").val($("#district_id").val());
                $("#bill_address").val($("#address").val());
                $("#bill_address2").val($("#address2").val());
                $("#bill_postcode").val($("#postcode").val());
                $(".billLoca").attr("disabled", "disabled")
            }
            else {
                $("#bill_to_location_id").val("");
                $(".billLoca").removeAttr("disabled")
            }
        });

        $("#ShipLocation").click(function () {
            if ($(this).is(":checked")) {
                $("#ship_to_location_id").val($("#locationID").val());
                // $("#ship_province_id").html($("#province_id").html());
                $("#ship_province_id").val($("#province_id").val());// "ship_province_id", "ship_city_id", "ship_district_id"
                change(0, ["ship_province_id", "ship_city_id", "ship_district_id"]);
                // $("#ship_city_id").html($("#city_id").html());
                $("#ship_city_id").val($("#city_id").val());
                change(1, ["ship_province_id", "ship_city_id", "ship_district_id"]);
                // $("#ship_district_id").html($("#district_id").html());
                $("#ship_district_id").val($("#district_id").val());
                $("#ship_address").val($("#address").val());
                $("#ship_address2").val($("#address2").val());
                $("#ship_postcode").val($("#postcode").val());
                $(".shipLoca").attr("disabled", "disabled")
            }
            else {
                $("#ship_to_location_id").val("");
                $(".shipLoca").removeAttr("disabled")
            }
        })

    })

    // 根据查找带回的客户，为页面上的基本信息赋值
    function GetDataBySelectCompany() {

        var account_id = $("#ParentComoanyNameHidden").val();
        if (account_id != "") {
            // 为商机下拉框赋值                  ✔                           
            // 为联系人下拉框赋值                 ✔                           
            // 根据客户ID 获取到客户信息，为税区赋值  ✔                         
            // 商机下拉框赋值之后，根据商机的预计完成时间为预计完成时间赋值   ✔      
            // todo 客户的报价模板？？？？
            // 为销售地址信息赋值                                         ✔      待测试
            // 为项目提案赋值                       
            $("#contact_id").html("");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=contact&userParentContact=true&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#contact_id").html(data);
                    }
                },
            });

            $("#opportunity_id").html("");
            // $("#opportunity_idHidden").val("");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=opportunity&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#opportunity_id").html(data);
                    }
                },
            });


            // 根据客户选择税区
            $("#tax_region_id").val("0");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=property&property=tax_region_id&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#tax_region_id").val(data);
                    }

                },
            });


            // 获取到用户的默认地址并赋值给界面
            $.ajax({
                type: "GET",
                async: false,
                dataType: "json",   // 返回json数据需要这样接收下
                url: "../Tools/CompanyAjax.ashx?act=Location&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                      
                       // InitArea(["province_id", "city_id", "district_id"]);  // 地址下拉框
                       // alert($("#province_id").html());
                        $("#province_id").val(data.province_id);
                        $("#province_idInit").val(data.province_id);
                       // alert($("#province_id").val());
                        //alert($("#province_id").val());

                       // alert($("#province_idInit").val());
                        change(0, ["province_id", "city_id", "district_id"]);
                 
                        $("#city_idInit").val(data.city_id);
                        $("#city_id").val(data.city_id);

                        change(1, ["province_id", "city_id", "district_id"]);
                        $("#locationID").val(data.id);

                        $("#district_idInit").val(data.district_id);
                        $("#district_id").val(data.district_id);
                        $("#address").val(data.address);
                        $("#address2").val(data.additional_address);
                        $("#postcode").val(data.postcode);
                    }

                },
            });
        }
    }

    function AddTime(time) {
        var date = new Date();
        date.setDate(Number(date.getDate()) + Number(time));

        var newDate = date.getFullYear() + '-' + returnNumber((date.getMonth() + 1)) + '-' + returnNumber(date.getDate());
        $("#projected_close_date").val(newDate);
        // $("#projected_close_date").datebox('setValue', newDate);       
    }
    function returnNumber(param) {
        if (param < 10) {
            return "0" + param
        }
        return param;
    }


    function chooseCompany() {
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=ParentComoanyName&callBack=GetDataBySelectCompany", '<%=(int)EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
    }

    function SubmitCheck() {
        var ParentComoanyName = $("#ParentComoanyNameHidden").val();
        if (ParentComoanyName == "") {
            alert("请通过查找功能查找客户");
            return false;
        }
        var QuoteName = $("#name").val();
        if (QuoteName == "") {
            alert("请填写报价名称");
            return false;
        }

        var create_time = $("#create_time").text();
        if (create_time == "") {
            alert("创建时间出错");
        }
        var projected_close_date = $("#projected_close_date").val();
      
        if (projected_close_date == "") {
            alert("请填写预计完成时间");
            return false;
        }
        // 如果选择商机的话，默认为商机联系人
        var contact_id = $("#contact_id").val();
       // var opportunity_id = $("#opportunity_id").val();
        if (contact_id == "" || contact_id ==0) {
            alert("请选择联系人");
            return false;
        }

      
        var effective_date = $("#effective_date").val();
        var expiration_date = $("#expiration_date").val();
        //alert(check(effective_date));
        //alert(check(expiration_date));
        if (!check(effective_date)) {
            alert("有效日期填写有误");
            return false;
        }
        if (!check(expiration_date)) {
            alert("过期日期填写有误");
            return false;
        }
        var projected_close_date = $("#projected_close_date").val();
        if (!check(effective_date)) {
            alert("预计完成日期有误");
            return false;
        }




        return true;
    }

    function check(date) {
        return (new Date(date).getDate() == date.substring(date.length - 2));
    }

    //var s = ["province_id", "city_id", "district_id"];//三个select的id

    function change(index, s) {

        
        var sel = $("#" + s[index]).val();
 
        var url = "Tools/AddressAjax.ashx?act=district&pid=" + sel;
        var initVal = $("#" + s[index + 1] + "Init") ? $("#" + s[index + 1] + "Init").val() : 0;
        if (index == 0) {
            $("#" + s[1]).empty();
            $("#" + s[1]).append($("<option>").val("").text("请选择"));
        }
        $("#" + s[2]).empty();
        $("#" + s[2]).append($("<option>").val("").text("请选择"));


        $.ajax({
            type: "POST",
            url: "../Tools/AddressAjax.ashx?act=district&pid=" + sel,
            //data: data,
            dataType: "JSON",
            timeout: 20000,
            async: false,
            beforeSend: function () {
                //$("body").append(loadDialog);
            },
            success: function (data) {
                
                if (data.code !== 0) {
                    show_alert(data.msg);
                } else {
                 
                    for (i = 0; i < data.data.length; i++) {
                        var option = $("<option>").val(data.data[i].val).text(data.data[i].show);
                        $("#" + s[index + 1]).append(option);
                    }
                    if (initVal != undefined && initVal != 0) {
                        $("#" + s[index + 1]).val(initVal);
                        $("#" + s[index + 1] + "Init").val(0);
                        if (index < 1)
                            change(1,s);
                    }
                }
            },
            error: function (XMLHttpRequest) {
                //$("#LoadingDialog").remove();
                //console.log(XMLHttpRequest);
                alert('请检查网络');
            }
        });



    }

    function InitArea(s) {

      
        document.getElementById(s[0]).onchange = new Function('change(0,["' + s[0] + '","'+s[1]+'","'+s[2]+'"])');
        document.getElementById(s[1]).onchange = new Function('change(1,["' + s[0] + '","'+s[1]+'","'+s[2]+'"])');
        $("#" + s[0]).empty();
        $("#" + s[1]).empty();
        $("#" + s[2]).empty();
        $("#" + s[0]).append($("<option>").val("").text("请选择"));
        $("#" + s[1]).append($("<option>").val("").text("请选择"));
        $("#" + s[2]).append($("<option>").val("").text("请选择"));



        $.ajax({
            type: "POST",
            url: "../Tools/AddressAjax.ashx?act=district",
            //data: data,
            dataType: "JSON",
            timeout: 20000,
            async: false,
            beforeSend: function () {
                //$("body").append(loadDialog);
            },
            success: function (data) {
                if (data.code !== 0) {
                    show_alert(data.msg);
                } else {
                    for (i = 0; i < data.data.length; i++) {
                        var option = $("<option>").val(data.data[i].val).text(data.data[i].show);
                        $("#" + s[0]).append(option);
                    }

                    var initVal = $("#" + s[0] + "Init") ? $("#" + s[0] + "Init").val() : 0;
                    if (initVal != undefined && initVal != 0) {
                        $("#" + s[0]).val(initVal);
                        $("#" + s[0] + "Init").val(0);
                       
                        change(0, s);
                    }
                }
            },
            error: function (XMLHttpRequest) {
                //$("#LoadingDialog").remove();
                //console.log(XMLHttpRequest);
                alert('请检查网络');
            }
        });
        //requestData("Tools/AddressAjax.ashx?act=district", "", function (data) {
        //    if (data.code !== 0) {
        //        show_alert(data.msg);
        //    } else {
        //        for (i = 0; i < data.data.length; i++) {
        //            var option = $("<option>").val(data.data[i].val).text(data.data[i].show);
        //            $("#" + s[0]).append(option);
        //        }

        //        var initVal = $("#" + s[0] + "Init") ? $("#" + s[0] + "Init").val() : 0;
        //        if (initVal != undefined && initVal != 0) {
        //            $("#" + s[0]).val(initVal);
        //            $("#" + s[0] + "Init").val(0);
        //            change(0, s);
        //        }
        //    }
        //}, false)
    }

    function AddOppo() {
       
        var account_id = $("#ParentComoanyNameHidden").val();
        if (account_id != "") {
            window.open('../Opportunity/OpportunityAddAndEdit?callBackFiled=NameOppo&oppo_account_id=' + account_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.OpportunityAdd %>', 'left=200,top=200,width=900,height=800', false);
        }
        else {
            alert("请先选择客户");
        }
        
    }
    function NameOppo(name, id)
    {
        //var values = document.getElementById("opportunity_id");
        //var thisOption = new Option(name, id);
        //values.add(thisOption);
        var account_id = $("#ParentComoanyNameHidden").val();
        if (account_id != "") {
            $("#opportunity_id").html("");
            // $("#opportunity_idHidden").val("");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=opportunity&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#opportunity_id").html(data);
                    }
                },
            });
            $("#opportunity_id").val(id);
        }
       
    }

    function AddContact() {
        var account_id = $("#ParentComoanyNameHidden").val();
        if (account_id != "") {
            window.open('../Contact/AddContact.aspx?callback=AddContactBack&account_id=' + account_id, '<%=(int)EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>', 'left=200,top=200,width=900,height=800', false);
        } else {
            alert("请先选择客户");
        }
        
    }
    function AddContactBack(contact_id) {
        var account_id = $("#ParentComoanyNameHidden").val();
        $("#contact_id").html("");
        $.ajax({
            type: "GET",
            async: false,
            url: "../Tools/CompanyAjax.ashx?act=contact&userParentContact=true&account_id=" + account_id,
            // data: { CompanyName: companyName },
            success: function (data) {
                if (data != "") {
                    $("#contact_id").html(data);
                }
            },
        });
        $("#contact_id").val(contact_id);
    }
 
  

</script>
