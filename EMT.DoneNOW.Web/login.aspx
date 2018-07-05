<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EMT.DoneNOW.Web.Login" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>DoneNOW</title>
		<link rel="stylesheet" type="text/css" href="Content/base.css"/>
		<link rel="stylesheet" type="text/css" href="Content/login.css"/>
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
                            <p runat="server" ID="msgtip" visible="false" style="color:red;"></p>
                            <a href="javaScript:" class="forgetBtns" style="display:none">忘记密码</a>
                        </div>
                    </li>
                    <li>
                        <div class="account-wrap clearfix">
                            <asp:Button ID="btnLogin" runat="server" Text="登录" CssClass="login-submit" OnClick="btnLogin_Click"/>
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
            <li>400-600-5588</li>
            <li>service@voiceonlice.com.cn</li>
            <li>上海声联网络科技股份有限公司</li>
        </ul>
    </div>
</footer>
</body>

<script type="text/javascript">
    window.onload = function () {
        //myBrowser();
        var brs = getBroswer();
        if (brs.broswer == "IE") {
            var vs = brs.version.split('.')[0];
            if (vs < 11)
                window.location.href = "/error.html";
        }
        function getBroswer() {
            var Sys = {};
            var ua = navigator.userAgent.toLowerCase();
            var s;
            (s = ua.match(/edge\/([\d.]+)/)) ? Sys.edge = s[1] :
                (s = ua.match(/rv:([\d.]+)\) like gecko/)) ? Sys.ie = s[1] :
                    (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
                        (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
                            (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
                                (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
                                    (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
            if (Sys.edge) return { broswer: "Edge", version: Sys.edge };
            if (Sys.ie) return { broswer: "IE", version: Sys.ie };
            if (Sys.firefox) return { broswer: "Firefox", version: Sys.firefox };
            if (Sys.chrome) return { broswer: "Chrome", version: Sys.chrome };
            if (Sys.opera) return { broswer: "Opera", version: Sys.opera };
            if (Sys.safari) return { broswer: "Safari", version: Sys.safari };
            return { broswer: "", version: "0" };
        }
    }
    document.getElementsByClassName("layout-content")[0].style.minHeight = document.body.clientHeight - 200 + 'px';
</script>
<script src="Scripts/jquery-3.1.0.min.js"></script>
<script src="Scripts/common.js"></script>
</html>
