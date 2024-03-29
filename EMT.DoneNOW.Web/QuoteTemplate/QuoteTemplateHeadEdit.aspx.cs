﻿using EMT.DoneNOW.BLL;
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
    public partial class QuoteTemplateHeadEdit : BasePage
    {
        public int id;
        public string page_head;
        protected QuoteTemplateBLL qtb = new QuoteTemplateBLL();
        protected List<string> list = new List<string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (!IsPostBack) {                
                if (Session["page_head"] != null && !string.IsNullOrEmpty(Session["page_head"].ToString()))
                {
                    page_head = HttpUtility.HtmlDecode(Session["page_head"].ToString()).Replace("\"", "'");
                }
                else
                {

                }
                this.AlertVariableFilter.DataTextField = "show";
                this.AlertVariableFilter.DataValueField = "val";
                this.AlertVariableFilter.DataSource = new QuoteTemplateBLL().GetVariableField();
                this.AlertVariableFilter.DataBind();
                this.AlertVariableFilter.Items.Insert(0, new ListItem() { Value = "0", Text = "显示全部变量", Selected = true });
                // list = new QuoteTemplateBLL().GetAllVariable();
                //
                list = new QuoteTemplateBLL().GetAllVariable();
                StringBuilder sb = new StringBuilder();
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this)' >" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            //    Page.ClientScript.RegisterStartupScript(this.GetType(), OpenWindow.GeneralJs.ToString(), @"function dbclick2(val) {
            //UE.getEditor('containerHead').focus();
            //UE.getEditor('containerHead').execCommand('inserthtml', $(val).html());
            //$('#BackgroundOverLay').hide();
            //$('.AlertBox').hide();
            //}
            //", true);
         }
        }

        protected void Save(object sender, EventArgs e)
        {
            string tt= Request.Form["data"].Trim().ToString();
            Session["page_head"] = tt;
            Session["cancel"] = 1;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id+"&op=edit");
          // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('"+tt+"！');history.go(-1);</script>");
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
                    sb.Append("<option class='val' ondblclick='dbclick(this)'>" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
            else
            {
                int selectid = Convert.ToInt32(this.AlertVariableFilter.SelectedValue.ToString());
                sb.Clear();
                var list = new QuoteTemplateBLL().GetVariable(selectid);
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this)' >" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
        }

        protected void Cancel(object sender, EventArgs e)
        {
            Session["cancel"] = 1;
            Response.Redirect("QuoteTemplateEdit.aspx?id=" + id + "&op=edit");
        }
    }
}