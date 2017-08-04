using EMT.DoneNOW.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateTopEdit :BasePage
    {
        public int id;
        public string quote_head;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                id = Convert.ToInt32(Request.QueryString["id"]);
                if (Session["quote_head"] != null && !string.IsNullOrEmpty(Session["quote_head"].ToString()))
                {
                    quote_head = HttpUtility.HtmlDecode(Session["quote_head"].ToString()).Replace("\"", "'");
                }
                else
                {
                   
                }
            }
            
            //quote_head = HttpUtility.HtmlDecode(data.quote_header_html).Replace("\"", "'");
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt = Request.Form["data"].Trim().ToString();
            Session["quote_head"] = tt;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
        }
    }
}