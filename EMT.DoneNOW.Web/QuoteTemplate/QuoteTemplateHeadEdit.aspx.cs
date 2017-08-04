using EMT.DoneNOW.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateHeadEdit : BasePage
    {
        public int id;
        public string page_head;
        protected void Page_Load(object sender, EventArgs e)
        {
            id=Convert.ToInt32(Request.QueryString["id"]);           
            if (Session["page_head"] != null && !string.IsNullOrEmpty(Session["page_head"].ToString()))
            {
                page_head = HttpUtility.HtmlDecode(Session["page_head"].ToString()).Replace("\"", "'");
            }
            else {
                
            }
           
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt= Request.Form["data"].Trim().ToString();
            Session["page_head"] = tt;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id+"&op=edit");
          // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('"+tt+"！');history.go(-1);</script>");
        }

    }
}