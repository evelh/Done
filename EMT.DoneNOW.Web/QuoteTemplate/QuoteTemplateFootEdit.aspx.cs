using EMT.DoneNOW.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateFootEdit : BasePage
    {
        public int id;
        public string page_foot;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                id = Convert.ToInt32(Request.QueryString["id"]);

                if (Session["page_foot"] != null && !string.IsNullOrEmpty(Session["page_foot"].ToString()))
                {
                    page_foot = HttpUtility.HtmlDecode(Session["page_foot"].ToString()).Replace("\"", "'");
                }
                else
                {
                }
            }
            
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt = Request.Form["data"].Trim().ToString();
            Session["page_foot"] = tt;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
            // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('"+tt+"！');history.go(-1);</script>");
        }

    }
}