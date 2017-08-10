<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EMT.DoneNOW.Web.Login" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>DoneNow</title>
		<link rel="stylesheet" type="text/css" href="Content/base.css"/>
		<link rel="stylesheet" type="text/css" href="Content/login.css"/>
		<script src="Scripts/jquery-3.1.0.min.js"></script>
	</head>
	<body>
		<div class="header">
			<div class="innter">
				<div class="header-logo fl">
					<img src="Images/logo.png" alt="声联科技"/>
				</div>
				<div class="header-login fr pr">
					<a href="javaScript:"><i></i>未登录</a>
				</div>
			</div>
		</div>
<div class="layout-content">
    <div class="loginwrap">
        <h3 class="login-title"></h3>
        <form id="form1" runat="server">
            <div class="login-cnt clearfix">
                <ul>
                    <li>
                        <div class="account-wrap">
                            <label>用户</label>
                            <asp:TextBox type="text" runat="server" id="uname" class="ipt"></asp:TextBox>
                        </div>
                    </li>
                    <li>
                        <div class="account-wrap">
                            <label>密码</label>
                            <asp:TextBox type="password" runat="server" id="pswd" class="ipt"></asp:TextBox>
                        </div>
                    </li>
                    <li>
                        <div class="account-wrap opts clear">
                            <p runat="server" ID="msgtip" visible="false"></p>
                            <a href="javaScript:" class="forgetBtns" style="display:none">忘记密码</a>
                        </div>
                    </li>
                    <li>
                        <div class="account-wrap clearfix">
                            <asp:Button ID="btnLogin" runat="server" Text="登录" CssClass="login-submit" OnClick="btnLogin_Click"/>
                            <!--<a href="javaScript:" class="login-submit">登陆</a>-->
                        </div>
                    </li>
                </ul>
            </div>
        </form>
    </div>
</div>

<footer>
    <div class="layout-footer">
        <ul>
            <li>www.voiceonline.com.cn</li>
            <li>400-600-5688</li>
            <li>service@voiceonlice.com.cn</li>
            <li>上海声联网路科技股份有限公司</li>
        </ul>
    </div>
</footer>
</body>

<script src="Scripts/common.js"></script>
<script type="text/javascript">
    document.getElementsByClassName("layout-content")[0].style.minHeight = document.body.clientHeight - 200 + 'px';
    window.onload = function () {
        myBrowser();
    }
</script>
</html>
