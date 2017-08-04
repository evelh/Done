using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateBodyEdit : BasePage 
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {

            }
            //string s = "11111";
            //string t;
            //t=s.Replace("\"", "'");
            //Response.Write(t);
        }

        protected void Save(object sender, EventArgs e)
        {
            // string t = this.Label1.Text.Trim().ToString();
            string t = Request.Form["qq"].ToString();
            //ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('"+t+"');</script>");
            //Response.Write(t);
        }
    }
}