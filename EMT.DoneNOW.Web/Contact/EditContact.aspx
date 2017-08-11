﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditContact.aspx.cs" Inherits="EMT.DoneNOW.Web.EditContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Edit Contact</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>
<body runat="server">
   <form id="AddCompany" name="AddCompany" runat="server">
         <div class="header-title">
           <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭"  BorderStyle="None" OnClick="save_close_Click" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_newAdd" runat="server" Text="保存并新建"  BorderStyle="None" OnClick="save_newAdd_Click" /></li>
             
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;"></i>
                    <asp:Button ID="close" runat="server" Text="关闭" BorderStyle="None" /></li>
            </ul>
        </div>

         <div class="nav-title">
            <ul class="clear">
                <li class="boders">基本信息</li>
                <li>附件信息</li>
                <li>用户自定义信息</li>
                <li>自助服务台</li>
         <div class="header">添加联系人</div>
            </ul>
        </div>
          
        <div class="content clear">
			<table border="none" cellspacing="" cellpadding="" style="width: 380px;margin-left: 40px;">
				<tr>
					<th>
						<h1>自助服务台状态</h1>
						<p>Inactive</p>
					</th>
				</tr>
				<tr>
					<td>
						<div class="clear input-dh">
							<label>客户名称<span class="red">*</span></label>
							<input type="text" disabled="disabled" id="companyName" value="" runat="server"/>
                            <input type="hidden" name="account_id" id="account_id" />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowCompany()"></i></span>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>外部资源ID<span class="red">*</span></label>
							 <%-- <input type="text" name="" id="" value="" />--%>
                            <asp:TextBox ID="externalID" runat="server"></asp:TextBox>
						</div>
					</td>
				</tr>

                 <tr>
                    <td>
                        <div class="clear">
                            <label>联系人姓名<span class="num"></span></label>
                            <input type="text" name="first_name" id="first_name" value="" style="width: 160px;" runat="server" />                       
                            <input type="text" name="last_name" id="last_name" value="" style="width: 165px;" runat="server"/>
                        </div>
                    </td>
                </tr>

				<tr>
					<td>
						<div class="clear">
							<label>称谓<span class="red">*</span></label>
							 <asp:DropDownList ID="sufix" runat="server">
                             </asp:DropDownList>
						</div>
					</td>
				</tr>

                 <tr>
                    <td>
                        <div class="clear">
                            <label>国家<span class=" red">*</span></label>
                            <input id="country_idInit" value='1' type="hidden" runat="server" />
                            <select name="country_id" id="country_id">
                                <option value="1">中国</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>省份<span class=" red">*</span></label>
                            <input id="province_idInit" type="hidden" runat="server" />
                            <select name="province_id" id="province_id">
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>城市<span class=" red">*</span></label>
                            <input id="city_idInit" type="hidden" runat="server" />
                            <select name="city_id" id="city_id">
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>区县<span class=" red">*</span></label>
                            <input id="district_idInit" type="hidden" runat="server" />
                            <select name="district_id" id="district_id">
                            </select>
                        </div>
                    </td>
                </tr>

				<tr>
					<td>
						<div class="clear">
							<label>激活<span class="red">*</span></label>
							<input type="checkbox" name="" id="active" value="" runat="server"/>
						</div>
					</td>
				</tr>

                  <tr>
					<td>
						<div class="clear">
							<label>头衔<span class="red">*</span></label>
							<input type="text" name="" id="title" value="" runat="server"/>
						</div>
					</td>
				 </tr>

                <tr>
					<td>
						<div class="clear">
							<label>主联系人<span class="red">*</span></label>
							<input type="checkbox" name="" id="primaryContact" value="" runat="server"/>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>地址<span class="red">*</span></label>
							<input type="text" name="address" id="address" value="" runat="server"/>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用地址<span class="red">*</span></label>
							<input type="text" name="AdditionalAddress" id="AdditionalAddress" value="" runat="server"/>
						</div>
					</td>
				</tr>


                <tr>
					<td>
						<div class="clear">
							<label>Email<span class="red">*</span></label>
							<input type="text" name="" id="email" value="" runat="server"/>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用Email<span class="red">*</span></label>
							<input type="text" name="" id="email2" value="" runat="server"/>
						</div>
					</td>
				</tr>
               
			</table>
           
			<table border="none" cellspacing="" cellpadding="" style="width: 380px;margin-left: 40px;">
				<tr>
					<td>
						<img src="img/pop.jpg" />
						<a href="javaScript:" class="Change">修改照片</a>
					</td>
				</tr>
				<tr>
					<td>
                        <div class="clear"><p class="font">提示</p></div>
				        <asp:CheckBox ID="CheckBox1" runat="server" /> 任务和工单中允许发邮件<br/>
                        <asp:CheckBox ID="CheckBox2" runat="server" />拒绝满意度调查 <br/>
                        <asp:CheckBox ID="CheckBox3" runat="server" />拒绝联系人组邮件<br/                                                 
                    </td>
                </tr>
                <tr>
					<td>
						<div class="clear">
							<label>电话<span class="red">*</span></label>
							<input type="text" name="" id="phone" value="" runat="server"/>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用电话<span class="red">*</span></label>
							<input type="text" name="" id="alternatePhone" value="" runat="server"/>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>移动电话<span class="red">*</span></label>
							<input type="text" name="" id="mobilePhone" value="" runat="server"/>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>传真<span class="red">*</span></label>
							<input type="text" name="" id="fax" value="" runat="server"/>
						</div>
					</td>
				</tr>
															
			</table>
		</div>   
   </form>
    <script>
        function OpenWindowCompany() {
            window.open("../Common/SelectCallBack.aspx", "newwindow", "height=200,width=400", "toolbar =no", "menubar=no", "scrollbars=no", "resizable=no", "location=no", "status=no");
        }
    </script>

    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/Common/Address.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            InitArea();
        });

        $(".Jump").click(function () {
            $("a").attr("target", "_blank");
            var url = $(this).prev().val();
            window.open("http://" + url);
        })

        $(function () {
            $("#save_close").click(function () {
                if (!submitcheck()) {
                    return false;
                }
            });   // 保存并关闭的事件

            $("#save_newAdd").click(function () {
                if (!submitcheck()) {
                    return false;
                }
            });   // 保存并新建的事件

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

            $("#first_name").blur(function () {
                var firstName = $(this).val();
                var lastName = $("#last_name").val();
                if (firstName.length > 1 && lastName == "") {
                    var subName = firstName.substring(1, firstName.length)
                    $("#last_name").val(subName);
                    $(this).val(firstName.substring(0, 1));
                }
            });

            function submitcheck() {
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
                return true;
            }
        })
     </script>
</body>
   
</html>