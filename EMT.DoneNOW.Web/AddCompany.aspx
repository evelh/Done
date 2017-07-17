<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.AddCompany" %>


<!DOCTYPE html>
<html>

<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>New Company</title>
    <link rel="stylesheet" type="text/css" href="Content/base.css" />
    <link rel="stylesheet" type="text/css" href="Content/NewCompany.css" />

</head>
<body runat="server">
    <form id="AddCompany" name="AddCompany" runat="server">
        <div class="header">NEW COMPANY</div>
        <div class="header-title">
        </div>
        <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_Click" />
        <input type="button" id="save" value="save&close" />
        <div class="ment">我是站位的,站位,站位,l站位,</div>
        <div class="text">To add the first Contact for this account, provide a First Name and Last Name. If you do not wish to add a new Contact at this time, you may leave these fields blank. All fields marked with a “1” apply to the Contact only.</div>

        <div class="cont-innter">
            <div class="information clear">
                <p class="informationTitle"><i></i>GENERAL INFORMATION</p>
                <div class="left fl">
                    <ul>
                        <li>
                            <label>客户名称<span class="red">*</span></label>
                            <input type="text" name="company_name" id="company_name" value="" />
                        </li>

                        <li>

                            <label>称谓<span class="num">1</span></label>
                            <asp:DropDownList ID="sufix" runat="server" Width="205px">
                       

                            </asp:DropDownList>
                        </li>

                        <li>

                            <label>电话<span class=" red">*</span></label>
                            <input type="text" name="Phone" id="Phone" value="" style="width: 300px;" />

                        </li>

                        <li>
                            <label>国家<span class=" red">*</span></label>
                            <select name="country_id" id="country_id" style="width: 205px;">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </li>



                        <li>
                            <label>城市<span class=" red">*</span></label>

                            <select name="city_id" id="city_id" style="width: 205px;">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </li>
                        <li>
                            <label>区县<span class=" red">*</span></label>
                            <select name="district_id" id="district_id" style="width: 205px;">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </li>
                        <li>
                            <label>地址附加信息<span class="num"></span></label>
                            <input type="text" name="AdditionalAddress" id="AdditionalAddress" value="" />
                        </li>

                        <li>
                            <label>税号<span class="num"></span></label>
                            <input type="text" name="TaxId" id="TaxId" value="" />
                        </li>
                        <li>

                            <input type="checkbox" name="TaxExempt" id="TaxExempt" value="" />
                           <div style="clear:both;margin-top:-20px;margin-left:200px;">是否免税</div> 
                        </li>
                        <li>
                            <label>备用电话2</label>
                            <input type="text" name="AlternatePhone2" id="AlternatePhone2" value="" />
                        </li>

                        <li>
                            <label>传真<span class="red"></span></label>
                            <input type="text" name="Fax" id="Fax" value="" />
                        </li>

                        <li>
                            <label>分类类别<span class="red"></span></label>

                            <asp:DropDownList ID="classification" runat="server" Width="205px" AutoPostBack="False">
                            </asp:DropDownList>
                        </li>

                        <li>
                            <label>销售区域<span class="red"></span></label>
                            <asp:DropDownList ID="TerritoryName" runat="server" Width="205px"></asp:DropDownList>

                        </li>


                        <li>
                            <label>竞争对手<span class="red"></span></label>
                            <asp:DropDownList ID="Competitor" runat="server"></asp:DropDownList>

                        </li>

                        <li>
                            <label>官网<span class="num">1</span></label>
                            <input type="text" name="WebSite" id="WebSite" value="" />
                        </li>

                    </ul>
                </div>
                <div class="left fl">
                    <ul>

                        <li>
                            <label>联系人姓名<span class="num">1</span></label>
                            <input type="text" name="first_name" id="first_name" value="" style="width: 125px;" />
                            <input type="text" name="" id="" value="" maxlength="2" style="width: 32px;" />
                            <input type="text" name="last_name" id="last_name" value="" style="width: 125px;" />
                        </li>
                        <li>
                            <label>头衔<span class="num">1</span></label>
                            <input type="text" name="Title" id="Title" value="" />
                        </li>
                        <li>
                            <label>Email<span class="num">1</span></label>
                            <input type="text" name="Email" id="Email" value="" />
                        </li>
                        <li class="clear">

                            <label>省份<span class=" red">*</span></label>

                            <select name="province_id" id="province_id" style="width: 205px;">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </li>
                        <li>
                            <label>邮编<span class="num"></span></label>
                            <input type="text" name="postal_code" id="postal_code" value="" style="width: 300px;" />

                        </li>
                        <li>
                            <label>
                                地址
                            </label>
                           <input type="text" name="address" id="address" value="" />
                        </li>
                        <li>
                            <label>税区<span class="num"></span></label>
                            <asp:DropDownList ID="TaxRegion" runat="server">
                            </asp:DropDownList>
                        </li>
                        <li>
                            <label>备用电话1</label>
                            <input type="text" name="AlternatePhone1" id="AlternatePhone1" value="" />
                        </li>
                        <li>
                            <label>移动电话<span class="num">1</span></label>
                            <input type="text" name="MobilePhone" id="MobilePhone" value="" />
                        </li>
                        <li>
                            <label>公司类型</label>
                            <asp:DropDownList ID="CompanyType" runat="server"></asp:DropDownList>
                        </li>
                        <li>
                            <label>客户经理</label>
                            <asp:DropDownList ID="AccountManger" runat="server"></asp:DropDownList>

                        </li>
                        <li>
                            <label>市场领域</label>
                            <asp:DropDownList ID="MarketSegment" runat="server" Width="205"></asp:DropDownList>

                        </li>
                        <li>
                            <label>父客户名称<span class="num">1</span></label>
                            <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="" />
                        </li>
                        <li>
                            <label>客户编号<span class="num">1</span></label>
                            <input type="text" name="CompanyNumber" id="CompanyNumber" value="" />
                        </li>

                    </ul>
                </div>
            </div>
        </div>


        <%-- <div class="header-title">
            <ul>
               
                <li id="SaveAndClose"><i style="background: url(img/ButtonBarIcons.png) no-repeat -32px 0;"></i>Save & Close</li>
                <li><i style="background: url(img/ButtonBarIcons.png) no-repeat -48px 0;"></i>Save & New</li>
                <li><i style="background: url(img/ButtonBarIcons.png) no-repeat -96px 0;"></i>Cancel</li>
            </ul>
        </div>
        <div class="nav-title">
            <ul class="clear">
                <li class="boders">General</li>
                <li>Additional Info</li>
                <li>TabDefault</li>
                <li>Client Portal</li>
            </ul>
        </div>
        <div class="content clear">
       
        </div>
        <div class="content clear">22</div>
        <div class="content clear">33</div>
        <div class="content clear">44</div>--%>
    </form>
</body>
<script src="Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="Scripts/index.js"></script>
</html>
<script type="text/javascript">
    $(function () {
        $("#TaxExempt").click(function () {
            debugger;
            if ($('#TaxExempt').is(':checked')) {
                // 禁用
                $("#TaxRegion").attr("disabled", "disabled");

            }
            else {
                // 解除禁用
                $("#TaxRegion").removeAttr("disabled");
            }
        });  // 选中免税，税区不可在进行编辑的事件处理


        $("#save_close").click(function () {
            var companyName = $("#company_name").val();          //  公司名称--必填项校验
            if (companyName == null || companyName == '') {
                alert("请输入公司名称");
                return false;
            }
            var phone = $("#Phone").val();                        //  电话-- 必填项校验
            if (phone == null || phone == '') {
                alert("请输入电话名称");
                return false;
            }
            if (!checkPhone(phone)) {
                alert("请输入正确格式的电话！");
                return false;
            }
            var firstName = $("#first_name").val();                                  // 姓
            var lastName = $("#last_name").val();                                    // 名
            var country = $("#country_id").val();                                      // 国家
            var province = $("#province_id").val();                                    // 省份
            var city = $("#City").val();                                            // 城市
            if (country == 0 || province == 0 || city == 0) {
                alert("请填写选择地址");                                           // 地址下拉框的必填校验
                return false;
            }
            var address = $("#address").val();                                      // 地址信息
            if (address == null || address == '') {
                alert("请完善地址信息");                                              // 地址的必填校验
                return false;
            }

            //$("#AddCompany").submit();



        });   // 保存并关闭的事件

    })

    function checkPhone(str) {
        var re = /^0\d{2,3}-?\d{7,8}$/;
        if (re.test(str)) {
            return true;
        } else {
            return false;
        }
    }
</script>
