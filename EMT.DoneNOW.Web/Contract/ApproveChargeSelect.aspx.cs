using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class ApproveChargeSelect :BasePage
    {
        protected int id;
        protected int rate_null;
        protected string date;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!int.TryParse(Request.QueryString["id"], out id)) {
                //失败
                Response.Write("<script>window.close();</script>");
            }
            if (!int.TryParse(Request.QueryString["rate_null"], out rate_null)) {
                //失败
                Response.Write("<script>window.close();</script>");
            }
            if (string.IsNullOrEmpty(Request.QueryString["date"]))
            {
                Response.Write("<script>window.close();</script>");
            }
            date = Request.QueryString["date"];
            if (rate_null == 0)
            {
                this.Auto.Enabled = false;
            }
        }
    }
}