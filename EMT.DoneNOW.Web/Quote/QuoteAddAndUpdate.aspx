<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuoteAddAndUpdate.aspx.cs" Inherits="EMT.DoneNOW.Web.Quote.QuoteAddAndUpdate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=isAdd?"新增报价":"修改报价" %></title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link href="../Content/index.css" rel="stylesheet" />
    <link href="../Content/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
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
                <li class="boders" id="">基本信息</li>
                <li id="">销售订单</li>
                <li id="">通知</li>
            </ul>
        </div>
        <div class="content clear">
            <div>
                <table border="none" cellspacing="" cellpadding="" style="width: 900px; margin-left: 40px;">
                    <tr>
                        <td>
                            <div class="clear">
                                <label>客户名称<span class="red">*</span></label>
                                <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="<%=isAdd?"":companyBLL.GetCompany(quote.account_id).name %>" />
                                <i onclick="chooseCompany();" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/data-selector.png) no-repeat;"></i>
                                <i onclick="javascript:window.open('../Company/AddCompany.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.CompanyAdd %>')" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                                <%--<input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="<%=isAdd?"":quote.account_id.ToString() %>" />--%>
                                <input type="hidden" id="ParentComoanyNameHidden" name="account_id" value="157" />

                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>商机名称</label>
                                <select name="opportunity_id" id="opportunity_id">
                                </select><input type="hidden" name="opportunity_idHidden" id="opportunity_idHidden" value=""/>
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
                                <textarea style="width: 72%;" name="description" id="description">
                                        <%=(!isAdd)&&(!string.IsNullOrEmpty(quote.description))?quote.description:"" %>
                                    </textarea>


                            </div>
                        </td>
                    </tr>
                    <%if (!isAdd)
                        {%>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>报价ID</label>
                                <span><%=quote.oid %></span>
                            </div>
                        </td>
                    </tr>
                    <%} %>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>创建时间<span class="red">*</span></label>
                                <span id="create_time" name="create_time"><%=DateTime.Now.ToString("dd/MM/yyyy") %></span>
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>报价生效时间</label>
                                <input type="date" name="effective_date" id="effective_date" value="<%=(!isAdd)&&(quote.effective_date!=null)?quote.effective_date.ToString("dd/MM/yyyy"):"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>报价失效时间</label>
                                <input type="date" name="expiration_date" id="expiration_date" value="<%=(!isAdd)&&(quote.expiration_date!=null)?quote.expiration_date.ToString("dd/MM/yyyy"):"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>预计完成时间<span class="red">*</span></label>
                                <input type="date" name="projected_close_date" id="projected_close_date" value="<%=(!isAdd)&&(quote.projected_close_date!=null)?quote.projected_close_date.ToString("dd/MM/yyyy"):"" %>" />
                            </div>
                            <div style="margin-top: -30px; display: -webkit-box;">
                                <a href="#" onclick="AddTime(0)">今天</a>|<a href="#"  onclick="AddTime(7)">7</a>|<a href="#"  onclick="AddTime(30)">30</a>|<a href="#"  onclick="AddTime(60)">60</a>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>成交概率</label>
                                <span name="probability" id="probability"></span>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>联系人<span class="red">*</span></label>
                                <select name="contact_id" id="contact_id">
                                </select>
                                <i onclick="javascript:window.open('../Contact/AddContact.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>')" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>项目提案名称</label>
                                <select name="project_id" id="project_id">
                                </select>
                                   <i onclick="javascript:window.open('../Contact/AddContact.aspx','<%=EMT.DoneNOW.DTO.OpenWindow.ContactAdd %>')" style="width: 15px; height: 15px; float: left; margin-left: 5px; margin-top: 5px; background: url(../Images/ButtonBarIcons.png) no-repeat -80px 0;"></i>
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
                                <input type="checkbox" name="is_active" id="is_active"  data-val="1" value="1" checked="<%=(!isAdd)&&(quote.is_active==1)?"checked":"" %>" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="clear">
                                <label>报价模板</label>
                                <select name="quote_tmpl_id" id="quote_tmpl_id">
                                </select>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div class="clear" style="text-align: left;">
                                <label>  </label>
                                <span style="margin-left:10px;">税的显示方式在<a href="#">报价模板</a>中设置</span>
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
                        <td colspan="2">
                            <div class="clear">
                                <label>备注</label>
                                <textarea style="width: 72%;" name="quote_comment" id="quote_comment">
                                        <%=(!isAdd)&&(!string.IsNullOrEmpty(quote.quote_comment))?quote.quote_comment:"" %>
                                    </textarea>
                            </div>
                        </td>

                    </tr>
                </table>

            </div>
        </div>
        <div class="content clear" style="display: none;">
            <div style="border: thin;">
                <table border="none" cellspacing="" cellpadding="" style="width: 900px; margin-left: 40px;">
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
                <div style="float: left; width: 30%;">
                    <table>
                        <tr>
                            <td>销售地址
                                <input type="hidden" name="locationID" id="locationID" value=""/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>省份</label>
                                     <input id="province_idInit" value='5' type="hidden" runat="server" />
                                    <select name="province_id" id="province_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>城市</label>
                                    <input id="city_idInit" value='' type="hidden" runat="server" />
                                    <select name="city_id" id="city_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>区县</label>
                                    <input id="district_idInit" value='' type="hidden" runat="server" />
                                    <select name="district_id" id="district_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>地址</label>
                                    <input type="text" name="address" id="address" />
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
                <div style="float: left; width: 30%;text-align:left; ">
                    <table>
                        <tr>
                            <td>账单地址  
                                <input type="checkbox" name="BillLocation" id="BillLocation" />
                                和销售地址相同</td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>省份</label>
                                    <select name="province_id" id="bill_province_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>城市</label>
                                    <select name="city_id" id="bill_city_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>区县</label>
                                    <select name="district_id" id="bill_district_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>地址</label>
                                    <input type="text" name="address" id="bill_address" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>补充地址</label>
                                    <input type="text" name="address2" id="bill_address2" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>邮编</label>
                                    <input type="text" name="postcode" id="bill_postcode" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div style="float: left; width: 30%;">
                    <table>
                        <tr>
                            <td>配送地址  
                                <input type="checkbox" name="ShipLocation" />
                                和销售地址相同</td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>省份</label>
                                    <select name="province_id" id="ship_province_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>城市</label>
                                    <select name="city_id" id="ship_city_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>区县</label>
                                    <select name="district_id" id="ship_district_id">
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>地址</label>
                                    <input type="text" name="address" id="ship_address" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>补充地址</label>
                                    <input type="text" name="address2" id="ship_address2" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="clear">
                                    <label>邮编</label>
                                    <input type="text" name="postcode" id="ship_postcode" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div class="content clear" style="display: none;">
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>

<script src="../Scripts/index.js"></script>
<script src="../Scripts/common.js"></script>
<script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js"></script>
<script>

    $(function () {
        InitArea();  // 地址下拉框
        GetDataBySelectCompany();  // 用于修改的时候赋值

        $("#opportunity_id").change(function () {
            var opportunity_id = $("#opportunity_id").val();
            if (opportunity_id != 0 && opportunity_id != null && opportunity_id != undefined)
            {
                $.ajax({
                    type: "GET",
                    //async: false,
                    url: "../Tools/OpportunityAjax.ashx?property=projected_close_date&act=property&id=" + opportunity_id,
                    // data: { CompanyName: companyName },
                    success: function (data) {
                        if (data != "") {
                            $("#projected_close_date").html(data);
                        }
                    },
                });  // 根据商机的预计完成时间为预计完成时间赋值
            }
        })


        $("#save_close").click(function () {
            if (!SubmitCheck()) {
              //  return false;
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

                // todo 
                $("#bill_province_id").val($("#province_id").val());
                $("#bill_city_id").val($("#city_id").val());
                $("#bill_district_id").val($("#district_id").val());
                $("#bill_address").val($("#address").val());
                $("#bill_address2").val($("#address2").val());
                $("#bill_postcode").val($("#postcode").val());
            }
        })
 
    })

    // 根据查找带回的客户，为页面上的基本信息赋值
    function GetDataBySelectCompany() {

        var account_id = $("#ParentComoanyNameHidden").val();
        if (account_id != "") {                                                 
            // 为商机下拉框赋值                  ✔                               待测试
            // 为联系人下拉框赋值                 ✔                              待测试
            // 根据客户ID 获取到客户信息，为税区赋值  ✔                            待测试
            // 商机下拉框赋值之后，根据商机的预计完成时间为预计完成时间赋值   ✔      待测试
            // todo 客户的报价模板？？？？
            // 为销售地址信息赋值                                         ✔      待测试
            // 为项目提案赋值                       
            $("#contact_id").html("");
            $.ajax({
                type: "GET",
                async: false,
                url: "../Tools/CompanyAjax.ashx?act=contact&account_id=" + account_id,
                // data: { CompanyName: companyName },
                success: function (data) {
                    if (data != "") {
                        $("#contact_id").html(data);
                    }
                },
            });

            $("#opportunity_id").html("");
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

                        $("#province_id").val(data.province_id);
                        $("#province_idInit").val(data.province_id);
                        debugger;

                        $("#city_idInit").val(data.city_id);
                        $("#city_id").val(data.city_id);
                    
                        $("#locationID").val(data.id);

                        $("#district_idInit").val(data.district_id);
                        $("#district_id").val(data.district_id);
                        $("#address").val(data.address);
                        $("#address2").val(data.address2);
                        $("#postcode").val(data.postcode);
                    }

                },
            });
        }
    }

    function AddTime(time)
    {
        var date = new Date();
        date.setDate( Number(date.getDate())+ Number(time));

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
        window.open("../Common/SelectCallBack.aspx?cat=<%=(int)EMT.DoneNOW.DTO.DicEnum.QUERY_CATE.COMPANY_CALLBACK %>&field=ParentComoanyName&callBack=GetDataBySelectCompany", '<%=EMT.DoneNOW.DTO.OpenWindow.CompanySelect %>', 'left=200,top=200,width=600,height=800', false);
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
        var opportunity_id = $("#opportunity_idHidden").val();
        if (opportunity_idHidden == "" && contact_id == "") {
            alert("请选择联系人");
            return false;
        }
        return true;
    }
</script>
