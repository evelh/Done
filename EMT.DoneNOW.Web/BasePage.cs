using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.Tools;

namespace EMT.DoneNOW.Web
{
    public class BasePage : System.Web.UI.Page
    {
        public BasePage()
        {
            this.Load += new EventHandler(BasePage_Load);
        }

        private void BasePage_Load(object sender, EventArgs e)
        {
            //判断管理员是否登录
            if (!IsUserLogin())
            {
                Response.Write("<script>parent.location.href='/login.aspx'</script>");
                Response.End();
            }
        }

        public bool IsUserLogin()
        {
            if (Session["dn_session_user_info"] != null)
            {
                return true;
            }
            else
            {
                //检查Cookies
                string username = Common.GetCookie("UserName", "DoneNOW");
                string userpwd = Common.GetCookie("UserPwd", "DoneNOW");
                if (username != "" && userpwd != "")
                {
                    // TODO: 验证用户名密码
                    return true;
                }
            }
            return false;
        }
    }
}