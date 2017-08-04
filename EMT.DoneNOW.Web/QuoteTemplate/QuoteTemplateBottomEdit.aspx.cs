using EMT.DoneNOW.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateBottomEdit : BasePage
    {
        public int id;
        public string quote_foot;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                id = Convert.ToInt32(Request.QueryString["id"]);
                if (Session["quote_foot"] != null && !string.IsNullOrEmpty(Session["quote_foot"].ToString()))
                {
                    quote_foot = Session["quote_foot"].ToString();
                }
                else
                {

                }
            }
            
            
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt = Request.Form["data"].Trim().ToString();
            Session["quote_foot"] = tt;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
            // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('"+tt+"！');history.go(-1);</script>");
        }
    }
}