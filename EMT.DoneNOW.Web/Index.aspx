<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="EMT.DoneNOW.Web.Index" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>DoneNOW</title>
		<link rel="stylesheet" type="text/css" href="Content/base.css"/>
		<link rel="stylesheet" type="text/css" href="Content/index.css"/>
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
							<p><a href="javaScript:"><%=(Session["dn_session_user_info"] as EMT.DoneNOW.Core.sys_user).email %></a></p>
							<span></span>
							<a onclick="javaScript:window.location.href='login?action=<%=EMT.DoneNOW.DTO.ActionEnum.Logout %>'">退出</a>
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
            <iframe id="PageFrame" name="PageFrame" style="width:100%;height:100%;" src="Common/SearchFrameSet.aspx"></iframe>
            <form runat="server" visible="false">
			    <div runat="server" id="query_para" class="cont-innter" style="border:1px;">
                    <ul>
                        <li>
                            客戶名称或编号<asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                            客户类型<asp:DropDownList ID="DropDownList1" runat="server"></asp:DropDownList>
                        </li>
                    </ul>
				    <ul>
                        <li>
                            最近活动时间>=<asp:TextBox ID="TextBox3" runat="server"></asp:TextBox>
                            最近活动时间<=<asp:TextBox ID="TextBox4" runat="server"></asp:TextBox>
                        </li>
                    </ul>
                    <ul>
                        <li>
                            客戶问卷调查分数>=<asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
                            客戶问卷调查分数<=<asp:TextBox ID="TextBox5" runat="server"></asp:TextBox>
                        </li>
                    </ul>
                    <ul>
                        <li>
                            地域名称<asp:DropDownList ID="DropDownList2" runat="server"></asp:DropDownList>
                        </li>
                    </ul>
			    </div>
            </form>
		</div>
	</body>
	<script src="Scripts/jquery-3.1.0.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Scripts/index.js" type="text/javascript" charset="utf-8"></script>
</html>
