using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class syscopy : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Button bt = new Button();
            bt.ID = "jjj";
            bt.Text = "hello";
            this.form1.Controls.AddAt(1,bt);
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Response.Redirect("../Tools/SecurityLevelAjax.ashx?act=copy&id=2");
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Write("<script>OpenWindow('SysUserSecurityLevel.aspx');</script>");
        }
    }
}