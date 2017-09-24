using EMT.DoneNOW.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (!IsPostBack) {                
                if (Session["quote_head"] != null && !string.IsNullOrEmpty(Session["quote_head"].ToString()))
                {
                    quote_head = HttpUtility.HtmlDecode(Session["quote_head"].ToString()).Replace("\"", "'");
                }
                this.AlertVariableFilter.DataTextField = "show";
                this.AlertVariableFilter.DataValueField = "val";
                this.AlertVariableFilter.DataSource = new QuoteTemplateBLL().GetVariableField();
                this.AlertVariableFilter.DataBind();
                this.AlertVariableFilter.Items.Insert(0, new ListItem() { Value = "0", Text = "显示全部变量", Selected = true });
                //
                var list = new QuoteTemplateBLL().GetAllVariable();
                StringBuilder sb = new StringBuilder();
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
            
            //quote_head = HttpUtility.HtmlDecode(data.quote_header_html).Replace("\"", "'");
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt = Request.Form["data"].Trim().ToString().Replace("\"","'");
            Session["quote_head"] = tt;
            Session["cancel"] = 1;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
        }

        protected void AlertVariableFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder();
            if (this.AlertVariableFilter.SelectedValue == "0")
            {
                sb.Clear();
                var list = new QuoteTemplateBLL().GetAllVariable();
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
            else
            {
                int id = Convert.ToInt32(this.AlertVariableFilter.SelectedValue.ToString());
                sb.Clear();
                var list = new QuoteTemplateBLL().GetVariable(id);
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);' >" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Session["cancel"] = 1;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
        }
    }
}