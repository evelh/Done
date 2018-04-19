using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.Tools;

namespace EMT.DoneNOW.Web
{
    public partial class Login : System.Web.UI.Page
    {
        private string action = "Login"; //操作类型

        protected void Page_Init(object sernder, EventArgs e)
        {

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string _action = DNRequest.GetQueryString("action");
            if ("Logout".Equals(_action))
            {
                EMT.Tools.Common.WriteCookie("Token", "DoneNOW", -14400);
                //Session["dn_session_user_info"] = null;
                //EMT.Tools.Common.WriteCookie("UserName", "DoneNOW", -14400);
                //EMT.Tools.Common.WriteCookie("UserPwd", "DoneNOW", -14400);
                Response.Redirect("Login.aspx");
            }
        }

        // 点击登录
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string userName = uname.Text.Trim();
            string userPwd = pswd.Text.Trim();
            string pwdMd5 = new Cryptographys().MD5Encrypt(userPwd);

            string ip = DNRequest.GetIP();
            string agent = HttpContext.Current.Request.UserAgent;
            var bll = new AuthBLL();

            TokenDto token = new TokenDto();
            var result = bll.Login(userName, userPwd, agent, ip, out token);
            if (result == ERROR_CODE.SUCCESS)
            {
                Common.WriteCookie("Token", "DoneNOW", token.token);
                Application["isFromLogin"] = "1";
                Response.Redirect("index.aspx");
            }
            else
            {
                if (result == ERROR_CODE.PARAMS_ERROR)
                    msgtip.InnerHtml = "请使用邮箱或手机号登录!";
                if (result == ERROR_CODE.PASSWORD_ERROR)
                    msgtip.InnerHtml = "密码错误!";
                if (result == ERROR_CODE.USER_NOT_FIND)
                    msgtip.InnerHtml = "输入用户不存在!";
                if (result == ERROR_CODE.LOCK)
                    msgtip.InnerHtml = "您的账户已被锁定，登录失败";
                msgtip.Visible = true;
            }

            /*
            var result = bll.Login(userName, userPwd, ip, agent, out user);
            if (result== DTO.ERROR_CODE.SUCCESS)
            {
                Session["dn_session_user_info"] = user;
                Session["dn_session_user_permits"] = bll.GetUserPermit(user.id);
                EMT.Tools.Common.WriteCookie("UserName", "DoneNOW", userName);
                EMT.Tools.Common.WriteCookie("UserPwd", "DoneNOW", pwdMd5);
                Response.Redirect("index.aspx");
            }
            else
            {
                if (result == ERROR_CODE.PARAMS_ERROR)
                    msgtip.InnerHtml = "请使用邮箱或手机号登录!";
                if (result == ERROR_CODE.PASSWORD_ERROR)
                    msgtip.InnerHtml = "密码错误!";
                if (result == ERROR_CODE.USER_NOT_FIND)
                    msgtip.InnerHtml = "输入用户不存在!";
                msgtip.Visible = true;
            }
            */
        }
    }
}