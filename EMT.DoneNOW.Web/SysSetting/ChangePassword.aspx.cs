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

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class ChangePassword : BasePage
    {
        protected sys_user thisUser;
        protected UserResourceBLL userBll = new UserResourceBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            thisUser = userBll.GetUserById(LoginUserId);
            if (thisUser == null)
            {
                Response.Write("<script>alert('未获取员工信息，请重试！');</script>");
            }
        }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            string userPwd = oldPwd.Text.Trim();
            if (!new Cryptographys().SHA1Encrypt(userPwd).Equals(thisUser.password))
            {
                // 密码错误
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('原密码填写错误，请重新填写!');</script>");
                return;
            }
            string userNewPwd = newPwd.Text.Trim();
            thisUser.password = new Cryptographys().SHA1Encrypt(userNewPwd);
            var result = new UserResourceBLL().ChangeUserPass(thisUser,LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}!');window.close();</script>");
        }
    }
}