<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.AddCompany" %>


<!DOCTYPE html>
<html>

<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>New Company</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewCompany.css" />

</head>
<body runat="server">
    <form id="AddCompany" name="AddCompany" runat="server">
        <div class="header">NEW COMPANY</div>
        <div class="header-title">
        </div>
        <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_Click" />
        <asp:Button ID="save_newAdd" runat="server" Text="保存并新建" OnClick="save_newAdd_Click" />
        <asp:Button ID="save_create_opportunity" runat="server" Text="保存并创建商机" OnClick="save_create_opportunity_Click" />
        <asp:Button ID="close" runat="server" Text="关闭" />
        <input type="button" id="save" value="save&close" />
        <div class="ment">我是站位的,站位,站位,l站位,</div>
        <div class="text">若要添加此帐户的第一个联系人，请提供名称和姓氏。如果此时您不希望添加新联系人，则可以将这些字段留空。所有标有“1”的字段只适用于联系人。</div>

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
                            <label>税区<span class="num"></span></label>
                            <asp:DropDownList ID="TaxRegion" runat="server">
                            </asp:DropDownList>
                        </li>


                        <li>
                            <label>税号<span class="num"></span></label>
                            <input type="text" name="TaxId" id="TaxId" value="" />
                        </li>
                        <li>

                            <input type="checkbox" name="TaxExempt" id="TaxExempt" value="" />
                            <div style="clear: both; margin-top: -20px; margin-left: 200px;">是否免税</div>
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
                            <label>官网</label>
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
                            <label>地址附加信息<span class="num"></span></label>
                            <input type="text" name="AdditionalAddress" id="AdditionalAddress" value="" />
                        </li>
                        <li>
                            <label>备用电话1</label>
                            <input type="text" name="AlternatePhone1" id="AlternatePhone1" value="" />
                        </li>
                        <li>
                            <label>备用电话2</label>
                            <input type="text" name="AlternatePhone2" id="AlternatePhone2" value="" />
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
                            <label>父客户名称</label>
                            <input type="text" name="ParentComoanyName" id="ParentComoanyName" value="" />
                        </li>
                        <li>
                            <label>客户编号</label>
                            <input type="text" name="CompanyNumber" id="CompanyNumber" value="" />
                        </li>

                    </ul>
                </div>
            </div>

            <div>
                <p class="informationTitle"><i></i>NOTE</p>
                <div class="left fl">
                    <ul>
                        <li>
                            <label>活动类型</label>
                            <asp:DropDownList ID="note_action_type" runat="server" Width="205"></asp:DropDownList>
                        </li>
                        <li>
                            <label>开始时间</label>
                            <input type="datetime-local" name="note_start_time" id="note_start_time" value="" />
                        </li>
                        <li>
                            <label>结束时间</label>
                            <input type="datetime-local" name="note_end_time" id="note_end_time" value="" />
                        </li>

                    </ul>
                </div>
                <div class="left fl">
                    <label>备注描述</label>
                    <textarea id="note_description" name="note_description" cols="20" rows="2"></textarea>
                </div>
            </div>

            <div style="clear:both;">
                <p class="informationTitle"><i></i>TODO</p>
                <div class="left fl">
                    <ul>
                        <li>
                            <label>活动类型</label>
                            <asp:DropDownList ID="todo_action_type" runat="server" Width="205"></asp:DropDownList>
                        </li>
                        <li>
                            <asp:DropDownList ID="assigned_to" runat="server">
                                <asp:ListItem Value="1">测试</asp:ListItem>
                            </asp:DropDownList>
                        </li>
                        <li>
                            <label>开始时间</label>
                            <input type="datetime-local" name="todo_start_time" id="todo_start_time" value="" />
                        </li>
                        <li>
                            <label>结束时间</label>
                            <input type="datetime-local" name="todo_end_time" id="todo_end_time" value="" />
                        </li>
                    </ul>
                </div>
                <div class="left fl">
                    <label>活动描述</label>
                    <textarea id="todo_description" name="todo_description" cols="20" rows="2"></textarea>
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
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
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
                // alert(companyName);
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
            debugger;
            var email = $("#Email").val();
            //alert(Trim(email,'g'));
            if (email != '') {
                if (!checkEmail(email)) {
                    alert("请输入正确格式的邮箱！");
                    return false;
                }
            }

            // 邮编验证
            var postal_code = $("#postal_code").val();
            //alert(Trim(email, 'g'));
            if (postal_code != '') {
                if (!checkPostalCode(postal_code)) {
                    alert("请输入正确的邮编！");
                    return false;
                }
            }

        });   // 保存并关闭的事件


        $("#close").click(function () {
            if (navigator.userAgent.indexOf("MSIE") > 0) {
                if (navigator.userAgent.indexOf("MSIE 6.0") > 0) {
                    window.opener = null;
                    window.close();
                } else {
                    window.open('', '_top');
                    window.top.close();
                }
            }
            else if (navigator.userAgent.indexOf("Firefox") > 0) {
                window.location.href = 'about:blank ';
            } else {
                window.opener = null;
                window.open('', '_self', '');
                window.close();
            }
        });  // 直接关闭窗口
    })
    // 校验电话格式
    function checkPhone(str) {
        var re = /^0\d{2,3}-?\d{7,8}$/;
        if (re.test(str)) {
            return true;
        } else {
            return false;
        }
    }

    // 校验邮箱
    function checkEmail(str) {
        var re = /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/;
        if (re.test(str)) {
            return true;
        } else {
            return false;
        }
    }
    // var re= /^[1-9][0-9]{5}$/

    function checkPostalCode(str) {
        var re = /^[1-9][0-9]{5}$/;
        if (re.test(str)) {
            return true;
        } else {
            return false;
        }
    }
    // 去除多余空格 可以更换第二个参数去替换别的
    function Trim(str, is_global) {
        var result;
        result = str.replace(/(^\s+)|(\s+$)/g, "");
        if (is_global.toLowerCase() == "g") {
            result = result.replace(/\s/g, "");
        }
        return result;
    }
</script>
