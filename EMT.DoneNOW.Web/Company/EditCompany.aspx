<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditCompany.aspx.cs" Inherits="EMT.DoneNOW.Web.EditCompany" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <title>Edit Company</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewCompany.css" />

</head>
<body>
    <form id="form1" runat="server">
        <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_close_Click" />
        <asp:Button ID="delete" runat="server" Text="删除" OnClick="delete_Click" />
        <asp:Button ID="close" runat="server" Text="关闭" />
        <div class="cont-innter">
            <div class="information clear">
                <p class="informationTitle"><i></i>GENERAL INFORMATION</p>
                <div class="left fl">
                    <ul>
                        <li>
                            <label>客户名称<span class="red">*</span></label>

                            <asp:TextBox ID="company_name" runat="server"></asp:TextBox>
                        </li>
                        <li>
                            <label>客户编号</label>
                            <asp:TextBox ID="CompanyNumber" runat="server"></asp:TextBox>

                        </li>

                        <li>
                            <label>
                                国家<span class=" red">*</span>

                            </label>
                            <asp:DropDownList ID="country_id" runat="server">
                                <asp:ListItem Value="1">111111</asp:ListItem>
                                <asp:ListItem Value="2">222222</asp:ListItem>
                                <asp:ListItem Value="3">333333</asp:ListItem>
                            </asp:DropDownList>

                        </li>

                        <li class="clear">

                            <label>省份<span class=" red">*</span></label>
                            <asp:DropDownList ID="province_id" runat="server">
                                <asp:ListItem Value="1">11111</asp:ListItem>
                                <asp:ListItem Value="2">22222</asp:ListItem>
                                <asp:ListItem Value="3">33333</asp:ListItem>
                            </asp:DropDownList>

                        </li>

                        <li>
                            <label>城市<span class=" red">*</span></label>
                            <asp:DropDownList ID="city_id" runat="server">
                                <asp:ListItem Value="1">11111</asp:ListItem>
                                <asp:ListItem Value="2">22222</asp:ListItem>
                                <asp:ListItem Value="3">33333</asp:ListItem>
                            </asp:DropDownList>

                        </li>
                        <li>
                            <label>区县<span class=" red">*</span></label>

                            <asp:DropDownList ID="district_id" runat="server">
                                <asp:ListItem Value="1">11111</asp:ListItem>
                                <asp:ListItem Value="2">22222</asp:ListItem>
                                <asp:ListItem Value="3">33333</asp:ListItem>
                            </asp:DropDownList>
                        </li>
                        <li>
                            <label>
                                地址
                            </label>
                            <asp:TextBox ID="address" runat="server"></asp:TextBox>
                        </li>
                        <li>
                            <label>地址附加信息<span class="num"></span></label>
                            <asp:TextBox ID="AdditionalAddress" runat="server"></asp:TextBox>

                        </li>
                        <li>
                            <label>是否是默认地址<span class="num"></span></label>
                            <asp:DropDownList ID="is_default" runat="server">
                                <asp:ListItem Value="1">默认地址</asp:ListItem>
                                <asp:ListItem Value="0">     </asp:ListItem>
                            </asp:DropDownList>
                        </li>
                        <li>
                            <label>邮编<span class="num"></span></label>
                            <asp:TextBox ID="postal_code" runat="server"></asp:TextBox>


                        </li>
                        <li>

                            <label>电话<span class=" red">*</span></label>
                            <asp:TextBox ID="Phone" runat="server"></asp:TextBox>


                        </li>

                        <li>
                            <label>备用电话1</label>
                            <asp:TextBox ID="AlternatePhone1" runat="server"></asp:TextBox>
                        </li>
                        <li>
                            <label>备用电话2</label>
                            <asp:TextBox ID="AlternatePhone2" runat="server"></asp:TextBox>
                        </li>

                        <li>
                            <label>传真<span class="red"></span></label>
                            <asp:TextBox ID="Fax" runat="server"></asp:TextBox>

                        </li>
                        <li>
                            <label>官网</label>
                            <asp:TextBox ID="WebSite" runat="server"></asp:TextBox>

                        </li>
                        <li>
                            <asp:CheckBox ID="is_optout_survey" runat="server" />
                            <div style="clear: both; margin-top: -20px; margin-left: 200px;">是否接受问卷调查</div>
                        </li>
                        <li>


                            <span style="margin-left: 115px; margin-right: 30px;">全程距离</span><asp:TextBox ID="mileage" runat="server"></asp:TextBox><span>千米</span>
                        </li>



                        <li>
                            <label>公司类型</label>
                            <asp:DropDownList ID="CompanyType" runat="server"></asp:DropDownList>
                        </li>
                        <li>
                            <label>分类类别<span class="red"></span></label>

                            <asp:DropDownList ID="classification" runat="server" Width="205px" AutoPostBack="False">
                            </asp:DropDownList>
                        </li>
                        <li>
                            <label>客户经理</label>
                            <asp:DropDownList ID="AccountManger" runat="server"></asp:DropDownList>

                        </li>
                        <li>
                            <label>客户小组</label>
                        </li>
                        <li>
                            <label>销售区域<span class="red"></span></label>
                            <asp:DropDownList ID="TerritoryName" runat="server" Width="205px"></asp:DropDownList>

                        </li>
                        <li>
                            <label>市场领域</label>
                            <asp:DropDownList ID="MarketSegment" runat="server" Width="205"></asp:DropDownList>

                        </li>
                        <li>
                            <label>竞争对手<span class="red"></span></label>
                            <asp:DropDownList ID="Competitor" runat="server"></asp:DropDownList>

                        </li>



                        <li>
                            <asp:CheckBox ID="TaxExempt" runat="server" />

                            <div style="clear: both; margin-top: -20px; margin-left: 200px;">是否免税</div>
                        </li>
                        <li>
                            <label>税区<span class="num"></span></label>
                            <asp:DropDownList ID="TaxRegion" runat="server">
                            </asp:DropDownList>
                        </li>

                        <li>
                            <label>税号<span class="num"></span></label>
                            <asp:TextBox ID="TaxId" runat="server"></asp:TextBox>


                        </li>

                        <li>
                            <label>父客户名称</label>
                            <asp:TextBox ID="ParentComoanyName" runat="server"></asp:TextBox>

                        </li>









                        <%--         <li>
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
                            <label>移动电话<span class="num">1</span></label>
                            <input type="text" name="MobilePhone" id="MobilePhone" value="" />
                        </li>--%>
                    </ul>
                </div>
            </div>


            <%--         <div class="information clear">
                <p class="informationTitle"><i></i>Location</p>
            
            </div>--%>
        </div>
    </form>
</body>
</html>
<script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
<script src="../Scripts/index.js"></script>
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
            //debugger;
            //var email = $("#Email").val();
            ////alert(Trim(email,'g'));
            //if (email != '') {
            //    if (!checkEmail(email)) {
            //        alert("请输入正确格式的邮箱！");
            //        return false;
            //    }
            //}

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
