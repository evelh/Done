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
    public partial class InvoiceTempBottom : BasePage
    {
        protected int id;
        protected InvioceTempDto.TempContent tempinfo = null;
        protected string bottom;
        protected List<InvioceTempDto.SETTING_ITEM> bottom_value;
        protected InvioceTempDto.Invoice_ext bottomttt=new InvioceTempDto.Invoice_ext ();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                tempinfo = Session["tempinfo"] as InvioceTempDto.TempContent;
                if (tempinfo != null && tempinfo.id == id)
                {
                    if(!string.IsNullOrEmpty(tempinfo.bottom))
                    bottom = HttpUtility.HtmlDecode(tempinfo.bottom).Replace("\"", "'");
                    if (!string.IsNullOrEmpty(tempinfo.Invoice_text)) {
                        bottomttt = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_ext>(tempinfo.Invoice_text);
                        if (tempinfo.tax_cat == 1)
                        {
                            this.tax_cate.Checked = true;
                        }
                        if (tempinfo.tax_group == 1)
                        {
                            this.tax_group.Checked = true;
                        }
                        if (tempinfo.tax_sup == 1)
                        {
                            this.tax_sup.Checked = true;
                        }
                    }                    
                }
                this.AlertVariableFilter.DataTextField = "show";
                this.AlertVariableFilter.DataValueField = "val";
                this.AlertVariableFilter.DataSource = new QuoteTemplateBLL().GetInvoiceVariableField();
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
            tempinfo.bottom = tt;
            string t = Convert.ToString(Request.Form["bottom"].ToString()).Replace(" ", ""); ;
            t = t.Replace("[,", "[").Replace(",]", "]");
            if (tempinfo.Invoice_text != null) {
                bottomttt = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_ext>(tempinfo.Invoice_text);                
            }
            var kk = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_ext2>(t).item;
            bottomttt.Bottom_Item = kk;
            tempinfo.Invoice_text = new EMT.Tools.Serialize().SerializeJson(bottomttt);
            if (this.tax_sup.Checked)
            {
                tempinfo.tax_sup = 1;
            }
            else {
                tempinfo.tax_sup = 0;
            }
            if (this.tax_cate.Checked)
            {
                tempinfo.tax_cat = 1;
            }
            else {
                tempinfo.tax_cat = 0;
            }
            if (this.tax_group.Checked)
            {
                tempinfo.tax_group = 1;
            }
            else {
                tempinfo.tax_group = 0;
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
                var list = new QuoteTemplateBLL().GetAllInvoiceVariable();
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