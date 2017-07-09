using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.Tools;

namespace EMT.DoneNOW.Web
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        // 点击登录
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string userName = uname.Text.Trim();
            string userPwd = pswd.Text.Trim();
            string pwdMd5 = new Cryptographys().MD5Encrypt(userPwd);

            sys_user user;
            var result = new AuthBLL().Login(userName, userPwd, out user);
            if (result== DTO.ERROR_CODE.SUCCESS)
            {
                Session["dn_session_user_info"] = user;
                Common.WriteCookie("UserName", "DoneNOW", userName);
                Common.WriteCookie("UserPwd", "DoneNOW", pwdMd5);
                Response.Redirect("index.aspx");
            }
            else
            {
                Response.Write("<script>alert('error!'); </script>");
            }
        }
    }
}