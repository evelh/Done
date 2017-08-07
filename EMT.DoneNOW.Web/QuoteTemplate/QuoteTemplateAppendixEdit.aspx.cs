using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateAppendixEdit : BasePage
    {
        public int id;
        public string page_appendix;

        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (Session["page_appendix"] != null && !string.IsNullOrEmpty(Session["page_appendix"].ToString()))
            {
                page_appendix = HttpUtility.HtmlDecode(Session["page_appendix"].ToString()).Replace("\"", "'");
            }
            else
            {

            }
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt = Request.Form["data"].Trim().ToString();
            Session["page_appendix"] = tt;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
        }
    }
}