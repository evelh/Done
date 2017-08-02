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
         <div class="header"><%if (dto.contact.id == 0) { %>添加联系人<%} else { %>编辑联系人<%} %></div>
         <div class="header-title">
           <ul>
                <li><i  style="background: url(../Images/ButtonBarIcons.png) no-repeat -32px 0;" class="icon-1"></i>
                    <asp:Button ID="save_close" runat="server" Text="保存并关闭" OnClick="save_Click" BorderStyle="None" />
                </li>
               <% if (dto.contact.id == 0) {%>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -48px 0;" class="icon-1"></i>
                    <asp:Button ID="save_newAdd" runat="server" Text="保存并新建" OnClick="save_newAdd_Click" BorderStyle="None" /></li>
             <%} %>
                <li><i style="background: url(../Images/ButtonBarIcons.png) no-repeat -96px 0;" class="icon-1"></i>
                    <asp:Button ID="close" runat="server" Text="关闭" BorderStyle="None" OnClick="close_Click" /></li>
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
          
        <div class="content clear" style="width:880px;">
			<table border="none" cellspacing="" cellpadding="" style="width:400px;margin-left: 40px;">
				<tr>
					<th>
						<h1>自助服务台状态</h1>
						<p>未激活</p>
					</th>
				</tr>
				<tr>
					<td>
						<div class="clear input-dh">
							<label>客户名称<span class="red">*</span></label>
							<input type="text" disabled="disabled" id="accCallBack" name="account_name" value="<%=dto.company_name %>" />
                            <input type="hidden" name="account_id" id="accCallBackHidden" value="<%=dto.contact.account_id %>" />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowCompany()"></i></span>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>外部资源ID<span class="red">*</span></label>
							<input type="text" name="external_id" id="" value="<%=dto.contact.external_id %>" />
						</div>
					</td>
				</tr>

                 <tr>
                    <td>
                        <div class="clear">
                            <label>联系人姓名<span class="num"></span></label>
                            <div class="inputTwo">
								<input type="text" name="first_name" id="first_name" value="<%=dto.contact.first_name %>"/>
								<span>-</span>
								<input type="text" name="last_name" id="last_name" value="<%=dto.contact.last_name %>"/>
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
                            <asp:CheckBox ID="active" runat="server" />
						</div>
					</td>
				</tr>

                  <tr>
					<td>
						<div class="clear">
							<label>头衔<span class="red">*</span></label>
							<input type="text" name="title" id="" value="<%=dto.contact.title %>" />
						</div>
					</td>
				 </tr>

                <tr>
					<td>
						<div class="clear">
							<label>主联系人<span class="red">*</span></label>
                            <asp:CheckBox ID="primary" runat="server" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear input-dh">
							<label>地址<span class="red">*</span></label>
							<input type="text" disabled="disabled" id="locCallBack" name="location" <%if (dto.location != null) { %> value="<%=dto.location.address %>" <%} %> />
                            <input type="hidden" name="location_id" id="locCallBackHidden" <%if (dto.location != null) { %> value="<%=dto.location.id %>" <%} %> />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowLocation('locCallBack')"></i></span>
						</div>
					</td>
				</tr> 
                
                <tr>
					<td>
						<div class="clear input-dh">
							<label>备用地址<span class="red">*</span></label>
							<input type="text" disabled="disabled" id="loc1CallBack" name="location2" <%if (dto.location2 != null) { %> value="<%=dto.location2.address %>" <%} %> />
                            <input type="hidden" name="location_id2" id="loc1CallBackHidden" <%if (dto.location2 != null) { %> value="<%=dto.location2.id %>" <%} %> />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowLocation('loc1CallBack')"></i></span>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>Email<span class="red">*</span></label>
							<input type="text" name="email" id="" value="<%=dto.contact.email %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用Email<span class="red">*</span></label>
							<input type="text" name="email2" id="" value="<%=dto.contact.email2 %>" />
						</div>
					</td>
				</tr>
               
			</table>
           
			<table border="none" cellspacing="" cellpadding="" style="width:400px;margin-left: 40px;">
				<tr>
                    <td>
                        <img id="imgshow" src="<%=avatarPath %>" />
                        <a href="#" style="display:inline-block; width:100px; height:24px; position:relative; overflow:hidden;">点击修改头像
                            <input type="file" value="浏览" id="browsefile" name="browsefile" style="position:absolute;right:0; top:0; opacity:0;filter:alpha(opacity=0);" />
                        </a>
                    </td>
				</tr>
				<tr>
					<td><p class="font">提示</p>
                        <div class="clear" style="padding-left:140px;">		
                            <asp:CheckBox ID="allowEmail" runat="server"  />
                            <label style="text-align:left;margin-left:20px;">任务和工单中允许发邮件</label>
                        </div>	
                        <div class="clear" style="padding-left:140px;">	
                            <asp:CheckBox ID="optoutSurvey" runat="server" />                           
                            <label style="text-align:left;margin-left:20px;">拒绝满意度调查</label>
                        </div>	
                        <div class="clear" style="padding-left:140px;">	
                            <asp:CheckBox ID="optoutEmail" runat="server" />                      
                            <label style="text-align:left;margin-left:20px;">拒绝联系人组邮件</label>
                        </div>	

                        
                    </td>
                </tr>
                <tr>
					<td>
						<div class="clear">
							<label>电话<span class="red">*</span></label>
							<input type="text" name="phone" id="Phone" value="<%=dto.contact.phone %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用电话<span class="red">*</span></label>
							<input type="text" name="alternate_phone" id="" value="<%=dto.contact.alternate_phone %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>移动电话<span class="red">*</span></label>
							<input type="text" name="mobile_phone" id="" value="<%=dto.contact.mobile_phone %>" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>传真<span class="red">*</span></label>
							<input type="text" name="fax" id="" value="<%=dto.contact.fax %>" />
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
                //if (!checkPhone(phone)) {
                //    alert("请输入正确格式的电话！");
                //    return false;
                //}
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

        $("#browsefile").change(function (e) {
            for (var i = 0; i < e.target.files.length; i++) {
                var file = e.target.files.item(i);
                //允许文件MIME类型 也可以在input标签中指定accept属性
                //console.log(/^image\/.*$/i.test(file.type));
                if (!(/^image\/.*$/i.test(file.type))) {
                    continue;            //不是图片 就跳出这一次循环
                }

                //实例化FileReader API
                var freader = new FileReader();
                freader.readAsDataURL(file);
                freader.onload = function (e) {
                    $("#imgshow").attr("src", e.target.result);
                    //var img = '<img src="' + e.target.result + '" width="200px" height="200px"/>';
                    //$("#images_show").empty().append(img);
                }
            }
        });
        
        function OpenWindowCompany() {
            window.open("../Common/SelectCallBack.aspx?type=查找客户&field=accCallBack&callBack=GetCompany", "newwindow", 'left=200,top=200,width=600,height=800', false);
        }
        function OpenWindowLocation(fld) {
            window.open("../Common/SelectCallBack.aspx?type=查找客户&field=" + fld, "newwindow", 'left=200,top=200,width=600,height=800', false);
        }
        function GetCompany() {
            requestData("Tools/CompanyAjax.ashx?act=companyPhone&account_id=" + $("#accCallBackHidden").val(), "", function (data) {
                if ($("#Phone").val() == "")
                    $("#Phone").val(data);
            })
        }
    </script>
</body>
</html>
