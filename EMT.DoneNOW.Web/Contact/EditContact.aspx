<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditContact.aspx.cs" Inherits="EMT.DoneNOW.Web.EditContact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Edit Contact</title>
    <link rel="stylesheet" type="text/css" href="../Content/base.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/bootstrap-datetimepicker.min.css" />
    <link rel="stylesheet" type="text/css" href="../Content/NewContact.css" />
    <link rel="stylesheet" type="text/css" href="../Content/contact.css" />
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
							<input type="text" disabled="disabled" id="companyName" value="" />
                            <input type="hidden" name="account_id" id="account_id" />
                            <span class="on"><i class="icon-dh" onclick="OpenWindowCompany()"></i></span>
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>外部资源ID<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
						</div>
					</td>
				</tr>

                 <tr>
                    <td>
                        <div class="clear">
                            <label>联系人姓名<span class="num"></span></label>
                            <input type="text" name="first_name" id="first_name" value="" style="width: 160px;" />                       
                            <input type="text" name="last_name" id="last_name" value="" style="width: 165px;" />
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
                            <select name="country_id" id="country_id">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>省份<span class=" red">*</span></label>

                            <select name="province_id" id="province_id">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>城市<span class=" red">*</span></label>

                            <select name="city_id" id="city_id">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div class="clear">
                            <label>区县<span class=" red">*</span></label>
                            <select name="district_id" id="district_id">
                                <option value="1">11111111111</option>
                                <option value="2">22222222222</option>
                                <option value="3">33333333333</option>
                                <option value="4">44444444444</option>
                            </select>
                        </div>
                    </td>
                </tr>

				<tr>
					<td>
						<div class="clear">
							<label>激活<span class="red">*</span></label>
							<input type="checkbox" name="" id="" value="" />
						</div>
					</td>
				</tr>

                  <tr>
					<td>
						<div class="clear">
							<label>头衔<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
						</div>
					</td>
				 </tr>

                <tr>
					<td>
						<div class="clear">
							<label>主联系人<span class="red">*</span></label>
							<input type="checkbox" name="" id="" value="" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>地址<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
						</div>
					</td>
				</tr>




                <tr>
					<td>
						<div class="clear">
							<label>Email<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用Email<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
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
					<%--	<div class="clear"><p class="font">提示</p></div>
						<div class="clear">	--%>			
                          <%--<form  method="get"> --%>  <asp:CheckBox ID="CheckBox1" runat="server" /> 任务和工单中允许发邮件<br/>
                        <asp:CheckBox ID="CheckBox2" runat="server" />拒绝满意度调查 <br/>
                        <asp:CheckBox ID="CheckBox3" runat="server" />拒绝联系人组邮件<br/                                                 
                           <%--</form> --%>
						<%--</div>--%>
                    </td>
                </tr>
                <tr>
					<td>
						<div class="clear">
							<label>电话<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>备用电话<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>移动电话<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
						</div>
					</td>
				</tr>

                <tr>
					<td>
						<div class="clear">
							<label>传真<span class="red">*</span></label>
							<input type="text" name="" id="" value="" />
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
</body>
   
</html>
