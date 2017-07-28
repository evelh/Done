<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddContact.aspx.cs" Inherits="EMT.DoneNOW.Web.AddContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>New Contact</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/index.css" />
    <link rel="stylesheet" type="text/css" href="../Content/style.css" />
</head>

<body runat="server">
   <form id="AddCompany" name="AddCompany" runat="server">
         <div class="header">添加联系人</div>
         <div class="header-title">
           <ul>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_Click" BorderStyle="None" />
                </li>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;"></i>
                    <asp:Button ID="save_newAdd" runat="server" Text="保存并新建" OnClick="save_newAdd_Click" BorderStyle="None" /></li>
             
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
            </ul>
        </div>
          
        <div class="content clear">
			<table border="none" cellspacing="" cellpadding="" style="width:400px;margin-left: 40px;">
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
							<input type="text" disabled="disabled" id="accCallBack" name="account_name" value="<%=aName %>" />
                            <input type="hidden" name="account_id" id="accCallBackHidden" value="<%=account_id %>" />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowCompany()"></i></span>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>外部资源ID<span class="red">*</span></label>
							<input type="text" name="external_id" id="" value="<%=extId %>" />
						</div>
					</td>
				</tr>

                 <tr>
                    <td>
                        <div class="clear">
                            <label>联系人姓名<span class="num"></span></label>
                            <div class="inputTwo">
										<input type="text" name="first_name" id="first_name" value="<%=fName %>"/>
										<span>-</span>
										<input type="text" name="last_name" id="last_name" value="<%=lName %>"/>
								</div>
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
							<label>激活<span class="red">*</span></label>
							<input type="checkbox" name="is_active" id="active" value="<%=active %>" />
						</div>
					</td>
				</tr>

                  <tr>
					<td>
						<div class="clear">
							<label>头衔<span class="red">*</span></label>
							<input type="text" name="title" id="" value="<%=title %>" />
						</div>
					</td>
				 </tr>

                <tr>
					<td>
						<div class="clear">
							<label>主联系人<span class="red">*</span></label>
							<input type="checkbox" name="is_primary_contact" id="" value="<%=pContact %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear input-dh">
							<label>地址<span class="red">*</span></label>
							<input type="text" disabled="disabled" id="locCallBack" name="location" value="<%=location %>" />
                            <input type="hidden" name="location_id" id="locCallBackHidden" />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowLocation('locCallBack')"></i></span>
						</div>
					</td>
				</tr> 
                
                <tr>
					<td>
						<div class="clear input-dh">
							<label>备用地址<span class="red">*</span></label>
							<input type="text" disabled="disabled" id="loc1CallBack" name="location2" value="<%=location2 %>" />
                            <input type="hidden" name="location_id2" id="loc1CallBackHidden" />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowLocation('loc1CallBack')"></i></span>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>Email<span class="red">*</span></label>
							<input type="text" name="email" id="" value="<%=email %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用Email<span class="red">*</span></label>
							<input type="text" name="email2" id="" value="<%=email2 %>" />
						</div>
					</td>
				</tr>
               
			</table>
           
			<table border="none" cellspacing="" cellpadding="" style="width:400px;margin-left: 40px;">
				<tr>
					<td>
						
                        <asp:Image ID="pic" ImageUrl="pop.jpg" runat="server" />
                        <input type="hidden" name="avatar" value="<%=fileAvatar %>"/>
                        <asp:FileUpload ID="pic_upload" runat="server" Width="123px" />
                        <asp:Button ID="Button1" runat="server"  OnClick="Button1_Click" Text="修改照片" />                      
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
							<input type="text" name="phone" id="Phone" value="<%=phone %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用电话<span class="red">*</span></label>
							<input type="text" name="alternate_phone" id="" value="<%=al_phone %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>移动电话<span class="red">*</span></label>
							<input type="text" name="mobile_phone" id="" value="<%=mobile_phone %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>传真<span class="red">*</span></label>
							<input type="text" name="fax" id="" value="<%=fax %>" />
						</div>
					</td>
				</tr>
															
			</table>
		</div>

       <div class="content clear" style="display:none">
            <table border="none" cellspacing="" cellpadding="" style="width: 650px; margin-left: 40px;">             
                 <tr>
                    <td>
                        <div class="clear">
                            <label>微博地址<span class="red"></span></label>
                            <asp:TextBox ID="weibo_url" runat="server"></asp:TextBox>
                            <input type="button" class="Jump" value="跳转"/>

                        </div>
                    </td>
                </tr>

                 <tr>
					<td>
						<div class="clear">
							<label>QQ号<span class="red">*</span></label>
                            <asp:TextBox ID="QQ_url" runat="server"></asp:TextBox>	
                            <input type="button" class="Jump" value="跳转"/>
						</div>
					</td>
				 </tr>

                <tr>
					<td>
						<div class="clear">
							<label>微信号<span class="red">*</span></label>
							<asp:TextBox ID="WeChat_url" runat="server"></asp:TextBox>
                            <input type="button" class="Jump" value="跳转"/>
						</div>
					</td>
				 </tr>
            </table>
       </div>   

       <div class="content clear" style="display:none">
                <p class="informationTitle"><i></i>联系人自定义</p>
                <div>
                    <div>
                        <ul>
                            <% if (contact_udfList != null && contact_udfList.Count > 0)
                                {
                                    foreach (var udf in contact_udfList)
                                    {
                                        if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.SINGLE_TEXT)    /* 单行文本*/
                                        {%>
                            <li>
                                <label><%=udf.col_name %></label>
                                <input type="text" name="<%=udf.id %>" class="sl_cdt" />
                            </li>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.MUILTI_TEXT)       /* 多行文本 */
                                {%>
                            <li>
                                <label><%=udf.col_name %></label>
                                <textarea name="<%=udf.id %>" rows="2" cols="20"></textarea>
                            </li>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.DATETIME)    /* 日期 */
                                {%><li>
                                    <label><%=udf.col_name %></label>
                                    <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" />
                                </li>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.NUMBER)         /*数字*/
                                {%>
                            <li>
                                <label><%=udf.col_name %></label>
                                <input type="text" name="<%=udf.id %>" class="form_datetime sl_cdt" maxlength="11" onkeyup="value=value.replace(/[^\d]/g,'') " onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d]/g,''))" />
                            </li>
                            <%}
                                else if (udf.data_type == (int)EMT.DoneNOW.DTO.DicEnum.UDF_DATA_TYPE.LIST)            /*列表*/
                                {%>
                            <li>
                                <label><%=udf.col_name %></label>
                                <select name="<%=udf.id %>">
                                    <%
                                        if (udf.value_list != null) {
                                            foreach (var v in udf.value_list) {
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

       <div class="content clear" style="display:none">
       </div>
    </form>

    <script src="../Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/NewContact.js" type="text/javascript" charset="utf-8"></script>
    <script src="../Scripts/common.js"></script>
    <script type="text/javascript">

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
                var companyName = $("#accCallBack").val();          //  客户名称--必填项校验
                if (companyName == null || companyName == '') {
                    alert("请输入客户名称");
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
                if (firstName == undefined || firstName == null || firstName == "") {
                    alert("请输入正确的姓"); 
                }
                if (country == 0 || province == 0 || city == 0) {
                    alert("请填写选择地址");                                           // 地址下拉框的必填校验
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

                return true;
            }

        })
     </script>
    <script>
        function OpenWindowCompany() {
            window.open("../Common/SelectCallBack.aspx?type=查找客户&field=accCallBack", "newwindow", 'left=200,top=200,width=600,height=800', false);
        }
        function OpenWindowLocation(fld) {
            window.open("../Common/SelectCallBack.aspx?type=查找客户&field=" + fld, "newwindow", 'left=200,top=200,width=600,height=800', false);
        }
    </script>
</body>
</html>
