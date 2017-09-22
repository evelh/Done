using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class InvoiceTempTop :BasePage 
    {
        protected int id;
        protected string op;
        protected string opop;
        protected InvioceTempDto.TempContent tempinfo = null;
        protected string head;
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            op = Request.QueryString["op"];
            switch (op) {
                case "head":opop = "页眉";break;
                case "top": opop = "头部"; break;
                case "foot": opop = "页脚"; break;
            }
            if (!IsPostBack) 
            {
                tempinfo = Session["tempinfo"] as InvioceTempDto.TempContent;
                if (tempinfo!=null&&tempinfo.id==id)
                {
                    switch (op)
                    {
                        case "head": head = HttpUtility.HtmlDecode(tempinfo.head).Replace("\"", "'"); ; break;
                        case "top": head = HttpUtility.HtmlDecode(tempinfo.top).Replace("\"", "'"); ; break;
                        case "foot": head = HttpUtility.HtmlDecode(tempinfo.foot).Replace("\"", "'"); ; break;
                    }                    
                }
                this.AlertVariableFilter.DataTextField = "show";
                this.AlertVariableFilter.DataValueField = "val";
                this.AlertVariableFilter.DataSource = new QuoteTemplateBLL().GetVariableField();
                this.AlertVariableFilter.DataBind();
                this.AlertVariableFilter.Items.Insert(0, new ListItem() { Value = "0", Text = "显示全部变量", Selected = true });
                var list = new QuoteTemplateBLL().GetAllVariable();
                StringBuilder sb = new StringBuilder();
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt = Request.Form["data"].Trim().ToString().Replace("\"", "'");
            tempinfo = Session["tempinfo"] as InvioceTempDto.TempContent;
            switch (op)
            {
                case "head": tempinfo.head = tt; ; break;
                case "top": tempinfo.top = tt; ; break;
                case "foot": tempinfo.foot = tt; ; break;
            }
            Session["tempinfo"] = tempinfo;
            Session["cancel"] = 1;
            Response.Redirect("InvoiceTempEdit.aspx?id=" + id + "&op=edit");
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
            Response.Redirect("InvoiceTempEdit.aspx?id=" + id + "&op=edit");
        }
    }
}