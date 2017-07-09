<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="EMT.DoneNOW.Web.Index" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>DoneNOW</title>
		<link rel="stylesheet" type="text/css" href="Content/base.css"/>
		<link rel="stylesheet" type="text/css" href="Content/index.css"/>
<script type="text/javascript">
function open_win()
{
window.open("NewCompany.html","_blank","toolbar=yes, location=yes,directories=no,status=no, menubar=yes, scrollbars=yes,resizable=no, copyhistory=yes, width=600, height=600,top=150,left=300")
}
</script>
	</head>
	<body>
		<div class="index-titleLeft">
			<dl>
				<dt></dt>
				<dd class="crm">C R M
					<div class="crmcont clear">
						<dl>
							<dt>服务台</dt>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
						</dl>
						<dl>
							<dt>服务台</dt>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
						</dl>
						<dl>
							<dt>服务台</dt>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
							<dd><a href="javaScript:">服务台</a></dd>
						</dl>
					</div>
				</dd>
				<dd class="ml">目&nbsp;&nbsp;录</dd>
				<dd class="xm">项&nbsp;&nbsp;目</dd>
				<dd class="fwt">服务台</dd>
				<dd class="sjb">时间表</dd>
				<dd class="kc">库&nbsp;&nbsp;存</dd>
				<dd class="wb">外&nbsp;&nbsp;包</dd>
				<dd class="gly">管理员</dd>
			</dl>
		</div>
		<div class="index-titleTop">
			<div class="titleTop-up clear">
				<div class="up-left fl">
					<ul>
						<li><span></span></li>
						<li><span></span></li>
						<li><span></span></li>
						<li><span></span></li>
						<li><span></span></li>
						<li></li>
						<li>
							<input type="text" name="" id="" value="" />
							<button></button>
						</li>
					</ul>
				</div>
				<div class="up-right fr">
					<ul>
						<li class="name">
							<p><a href="javaScript:" onclick="open_win()" ><%=(Session["dn_session_user_info"] as EMT.DoneNOW.Core.sys_user).email %></a></p>
							<span></span>
							<a href="javaScript:">退出</a>
						</li>
						<li><span></span></li>
						<li><span></span></li>
						<li></li>
					</ul>
				</div>
			</div>
			<div class="titleTop-down clear">
				<div class="up-left fl pr">
					<ul>
						<li><p>站位</p><span></span></li>
						<li><p>站位</p><span></span></li>
						<li><p>站位</p><span></span></li>
						<li><p>站位</p><span></span></li>
						<li class="titleAdd"><i></i></li>
					</ul>
				</div>
				<div class="up-right fr">
					<ul>
						<li></li>
						<li></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="index-titleRight">
			<div class="titleRight-men pa">
				<div class="men-top">
					<i></i>
					<i></i>
					<i></i>
				</div>
				<div class="men-down">
					<i></i>
				</div>
			</div>
		</div>
		<div class="cont">
			<div class="cont-innter">
				<div class="cont-title clear">
					<div class="title-left fl">
						<i></i>
						<p>	COMPANY SEARCH</p>
					</div>
					<div class="title-right fr">
						<i class="help"></i>
						<i class="collect"></i>
					</div>
			</div>
				<div class="information clear">
					<p class="informationTitle"> <i></i>GENERAL INFORMATION</p>
					<div class="left fl">
						<ul>
							<li>
								<label>Company Name<span class="red">*</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Contact Name <span class="num">1</span></label>
								<input type="text" name="" id="" value=""  style="width: 75px;"/>
								<input type="text" name="" id="" value="" maxlength="2"  style="width: 32px;"/>
								<input type="text" name="" id="" value=""  style="width: 75px;"/>
							</li>
							<li class="clear">
								<ul class="clear">
									<li class="fl">
										<label>Prefix<span class="num">1</span></label>
										<select name=""  style="width: 92px; ">
											<option value="">1111</option>
											<option value="">1111</option>
											<option value="">1111</option>
										</select>
									</li>
									<li class="fl" style="margin-left: 20px;">
										<label>Suffix<span class="num">1</span></label>
										<select name=""  style="width: 92px; ">
											<option value="">2222</option>
											<option value="">2222</option>
											<option value="">2222</option>
										</select>
									</li>
								</ul>
							</li>
							<li>
								<label>Title<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li class="clear">
								<ul class="clear">
									<li class="fl">
										<label>Phone<span class=" red">*</span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
									<li class="fl" style="margin-left:20px;">
										<label>Ext.<span class="num">1</span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
								</ul>
							</li>
							<li>
								<label>Email<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Address <span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Address <span class="num">2</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>City<span class="num"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li class="clear">
								<ul class="clear">
									<li class="fl">
										<label>State<span class=" red"></span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
									<li class="fl" style="margin-left:20px;">
										<label>Post Code<span class="num"></span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
								</ul>
							</li>
							<li>
								<label>Country<span class="num"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
		
							<li>
								<label>Additional Address Information<span class="num"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Country<span class="num"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Tax ID<span class="num"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<input type="checkbox" name="" id="" value="" style="width: auto;"/> Tax Exempt
							</li>
						</ul>
					</div>
					<div class="left fl">
						<ul>
							<li>
								<label>Alternate Phone<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Alternate Phone<span class="num">2</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Mobile Phone<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Fax<span class="red"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Company Type<span class="red">*</span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Classification<span class="red"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Account Manager<span class="red">*</span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Territory Name<span class="red"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Market Segment<span class="red">*</span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Competitor<span class="red"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Parent Company Name<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Web Site<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Company Number<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
		
						</ul>
					</div>
				
					<div class="left fl">
						<ul>
							<li>
								<label>Company Name<span class="red">*</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Contact Name <span class="num">1</span></label>
								<input type="text" name="" id="" value=""  style="width: 75px;"/>
								<input type="text" name="" id="" value="" maxlength="2"  style="width: 32px;"/>
								<input type="text" name="" id="" value=""  style="width: 75px;"/>
							</li>
							<li class="clear">
								<ul class="clear">
									<li class="fl">
										<label>Prefix<span class="num">1</span></label>
										<select name=""  style="width: 92px; ">
											<option value="">1111</option>
											<option value="">1111</option>
											<option value="">1111</option>
										</select>
									</li>
									<li class="fl" style="margin-left: 20px;">
										<label>Suffix<span class="num">1</span></label>
										<select name=""  style="width: 92px; ">
											<option value="">2222</option>
											<option value="">2222</option>
											<option value="">2222</option>
										</select>
									</li>
								</ul>
							</li>
							<li>
								<label>Title<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li class="clear">
								<ul class="clear">
									<li class="fl">
										<label>Phone<span class=" red">*</span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
									<li class="fl" style="margin-left:20px;">
										<label>Ext.<span class="num">1</span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
								</ul>
							</li>
							<li>
								<label>Email<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Address <span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Address <span class="num">2</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>City<span class="num"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li class="clear">
								<ul class="clear">
									<li class="fl">
										<label>State<span class=" red"></span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
									<li class="fl" style="margin-left:20px;">
										<label>Post Code<span class="num"></span></label>
										<input type="text" name="" id="" value="" style="width: 88px;"/>
									</li>
								</ul>
							</li>
							<li>
								<label>Country<span class="num"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
		
							<li>
								<label>Additional Address Information<span class="num"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Country<span class="num"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Tax ID<span class="num"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<input type="checkbox" name="" id="" value="" style="width: auto;"/> Tax Exempt
							</li>
						</ul>
					</div>
					<div class="left fl">
						<ul>
							<li>
								<label>Alternate Phone<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Alternate Phone<span class="num">2</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Mobile Phone<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Fax<span class="red"></span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Company Type<span class="red">*</span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Classification<span class="red"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Account Manager<span class="red">*</span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Territory Name<span class="red"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Market Segment<span class="red">*</span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Competitor<span class="red"></span></label>
								<select name="" style="width: 205px;">
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
									<option value="">11111111111</option>
								</select>
							</li>
							<li>
								<label>Parent Company Name<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Web Site<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
							<li>
								<label>Company Number<span class="num">1</span></label>
								<input type="text" name="" id="" value="" />
							</li>
		
						</ul>
					</div>
				
				</div>
			</div>
		</div>
	</body>
	<script src="Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
</html>
