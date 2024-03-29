﻿using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    public partial class InvoiceTempBody :BasePage
    {
        public int id;
        protected GeneralBLL gbll = new GeneralBLL();
        protected sys_quote_tmpl temp = new sys_quote_tmpl();
        protected InvioceTempDto.TempContent tempinfo = new InvioceTempDto.TempContent ();
        protected InvioceTempDto.Invoice_ext addset=new InvioceTempDto.Invoice_ext ();//扩展字段类型
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            if (!IsPostBack)
            {
                Bind();
                tempinfo = Session["tempinfo"] as InvioceTempDto.TempContent;
                if (tempinfo != null && tempinfo.id == id)
                {
                    this.GroupBy.SelectedValue = tempinfo.body_group_by.ToString();
                    this.SortBy.SelectedValue = tempinfo.body_order_by.ToString();
                    this.Itemize.SelectedValue = tempinfo.body_itemize_id.ToString();
                    if(tempinfo.show_labels_when_grouped==1)
                    this.ShowLabelsWhenGrouped.Checked = true;
                    if (!string.IsNullOrEmpty(tempinfo.Invoice_text))
                        addset = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_ext>(tempinfo.Invoice_text);
                    if (!string.IsNullOrEmpty(tempinfo.body))
                    {
                        tempinfo.body = HttpUtility.HtmlDecode(tempinfo.body);
                        var invoice_body = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_Body>(tempinfo.body.Replace("'", "\""));
                        if (invoice_body != null)
                        {
                            StringBuilder html = new StringBuilder();
                            int i = 0;
                            html.Append(" <script>");
                            html.Append(" $(document).ready(function () { ");
                            foreach (var column in invoice_body.GRID_COLUMN)
                            {
                                html.Append("$(\".Order\").eq(" + i + ").text(\"" + column.Order + "\");");
                                html.Append("$(\".Column_Content\").eq(" + i + ").html(\"" + column.Column_Content + "\");");
                                html.Append("$(\".Column_label\").eq(" + i + ").html(\"" + column.Column_label + "\");");
                                if (column.Display == "yes")
                                {
                                    html.Append("$(\".Display\").eq(" + i + ").addClass(\"CM\");");
                                }
                                i++;
                            }
                            foreach (var OPTIONS in invoice_body.GRID_OPTIONS)
                            {
                                if (OPTIONS.Show_grid_header != "yes")
                                {
                                    html.Append("$(\"#ShowGridHeader\").removeAttr(\"checked\");");
                                }
                                if (OPTIONS.Show_vertical_lines == "yes")
                                {
                                    html.Append("$(\"#ShowVerticalGridlines\").attr(\"checked\",'true');");
                                }

                            }
                            i = 0;
                            foreach (var ITEM_COLUMN in invoice_body.ADD_THE_ITEM_COLUMN)
                            {
                                html.Append("$(\".add_invoice_type_id\").eq("+i+").value=\""+ITEM_COLUMN.Type_of_Invoice_Item_ID+"\";");
                                html.Append("$(\".add_Order\").eq(" + i + ").text(\"" + ITEM_COLUMN.Order + "\");");
                                html.Append("$(\".add_invoice_type_name\").eq(" + i + ").html(\"" + ITEM_COLUMN.Type_of_Invoice_Item + "\");");
                                html.Append("$(\".add_Display_Format\").eq(" + i + ").html(\"" + ITEM_COLUMN.Display_Format + "\");");
                                if (ITEM_COLUMN.Checked != "yes")
                                {
                                    html.Append("$(\".add_Display\").eq(" + i + ").removeClass(\"checked\");");
                                }
                               else
                                {
                                    html.Append("$(\".add_Display\").eq(" + i + ").addClass(\"CM\");");
                                }
                                i++;
                            }
                            i = 0;
                            foreach (var ITEM_COLUMN in invoice_body.CUSTOMIZE_THE_ITEM_COLUMN)
                            {
                                html.Append("$(\".invoice_type_id\").eq(" + i + ").val(" + ITEM_COLUMN.Type_of_Invoice_Item_ID + ");");
                                html.Append("$(\".SortOrder\").eq(" + i + ").text(\"" + ITEM_COLUMN.Order + "\");");
                                html.Append("$(\".invoice_type_name\").eq(" + i + ").html(\"" + ITEM_COLUMN.Type_of_Invoice_Item + "\");");
                                html.Append("$(\".Display_Format\").eq(" + i + ").html(\"" + ITEM_COLUMN.Display_Format + "\");");
                                html.Append("$(\".Add_Display_Format\").eq(" + i + ").html(\"" + ITEM_COLUMN.Add_Display_Format + "\");");
                                i++;
                            }
                            html.Append("});</script>");
                            this.datalist.Text = html.ToString();
                            //Page.ClientScript.RegisterStartupScript(this.GetType(), "MyScript", html.ToString(), true);
                            html.Clear();
                        }
                    }
                    else {
                        this.datalist.Text = "<script> $(document).ready(function () {$(\".Display\").children().addClass(\"CM\");});</script>";
                    }
                }
                else
                {
                    //string myScript = @"$('.Display').children().addClass('CM')";
                    //Page.ClientScript.RegisterStartupScript(this.GetType(), "MyScript", myScript, true);
                   this.datalist.Text = "<script> $(document).ready(function () {$(\".Display\").children().addClass(\"CM\");});</script>";
                }
            }
        }
        public void Bind()
        {
            var dic = new QuoteTemplateBLL().GetField();
            //分组
            this.GroupBy.DataTextField = "show";
            this.GroupBy.DataValueField = "val";
            this.GroupBy.DataSource = dic.FirstOrDefault(_ => _.Key == "GroupBy").Value;
            this.GroupBy.DataBind();
            this.GroupBy.SelectedIndex = 0;
            //显示
            this.Itemize.DataTextField = "show";
            this.Itemize.DataValueField = "val";
            this.Itemize.DataSource = dic.FirstOrDefault(_ => _.Key == "Itemize").Value;
            this.Itemize.DataBind();
            //排序字段
            this.SortBy.DataTextField = "show";
            this.SortBy.DataValueField = "val";
            this.SortBy.DataSource = dic.FirstOrDefault(_ => _.Key == "SortBy").Value;
            this.SortBy.DataBind();
            //可选变量
            this.Variable.DataTextField = "show";
            this.Variable.DataValueField = "val";
            this.Variable.DataSource = new QuoteTemplateBLL().GetInvoiceBodyVariableField();
            this.Variable.DataBind();
            this.Variable.Items.Insert(0, new ListItem() { Value = "0", Text = "显示全部变量", Selected = true });
            var list = new QuoteTemplateBLL().GetBodyAllInvoiceVariable();
            StringBuilder sb = new StringBuilder();
            foreach (string va in list)
            {
                sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
            }
            this.VariableList.Text = sb.ToString();
            this.GetVaild.DataTextField = "show";
            this.GetVaild.DataValueField = "val";
            this.GetVaild.DataSource = new QuoteTemplateBLL().GetInvoiceBodyVariableField();
            this.GetVaild.DataBind();
            this.GetVaild.Items.Insert(0, new ListItem() { Value = "0", Text = "显示全部变量", Selected = true });
            this.GetVaildlist.Text = sb.ToString();

            
        }
        protected void Variable_SelectedIndexChanged(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder();
            if (this.Variable.SelectedValue == "0")
            {
                sb.Clear();
                var list = new QuoteTemplateBLL().GetBodyAllInvoiceVariable();
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
            else
            {
                int id = Convert.ToInt32(this.Variable.SelectedValue.ToString());
                sb.Clear();
                var list = new QuoteTemplateBLL().GetVariable(id);
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.VariableList.Text = sb.ToString();
            }
        }

        protected void Save_Click(object sender, EventArgs e)
        {
            string t = Convert.ToString(Request.Form["data"].Trim().ToString());
            t = t.Replace("[,", "[").Replace(",]", "]").Replace("\n","");
            string tt = Convert.ToString(Request.Form["typetype"].Trim().ToString());
            tt = tt.Replace("[,", "[").Replace(",]", "]").Replace("\n", "");
            string ttt = Convert.ToString(Request.Form["typett"].Trim().ToString());
            ttt = ttt.Replace("[,", "[").Replace(",]", "]").Replace("\n", "");
            tempinfo = Session["tempinfo"] as InvioceTempDto.TempContent;
            if (tempinfo != null && tempinfo.id == id)
            {
                tempinfo.body_group_by = Convert.ToInt32(this.GroupBy.SelectedValue);
                tempinfo.body_order_by = Convert.ToInt32(this.SortBy.SelectedValue);
                tempinfo.body_itemize_id = Convert.ToInt32(this.Itemize.SelectedValue);
                if (this.ShowLabelsWhenGrouped.Checked)
                {
                    tempinfo.show_labels_when_grouped = 1;
                }
                else {
                    tempinfo.show_labels_when_grouped = 0;
                }
                tempinfo.body = t.Replace("\"", "'");
                if(tempinfo.Invoice_text!=null&&!string.IsNullOrEmpty(tempinfo.Invoice_text))
                addset = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_ext>(tempinfo.Invoice_text);
                addset.Labour_Item = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_ext2>(tt).item;
                addset.Service_Bundle_Item = new EMT.Tools.Serialize().DeserializeJson<InvioceTempDto.Invoice_ext2>(ttt).item;
                tempinfo.Invoice_text = new EMT.Tools.Serialize().SerializeJson(addset);
                Session["tempinfo"] = tempinfo;
            }
            Session["cancel"] = 1;
            Response.Redirect("InvoiceTempEdit.aspx?id=" + id + "&op=edit");
        }

        protected void GetVaild_SelectedIndexChanged(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder();
            if (this.GetVaild.SelectedValue == "0")
            {
                sb.Clear();
                var list = new QuoteTemplateBLL().GetBodyAllInvoiceVariable();
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.GetVaildlist.Text = sb.ToString();
            }
            else
            {
                int id = Convert.ToInt32(this.GetVaild.SelectedValue.ToString());
                sb.Clear();
                var list = new QuoteTemplateBLL().GetVariable(id);
                foreach (string va in list)
                {
                    sb.Append("<option class='val' ondblclick='dbclick(this);'>" + va.Replace("'", "") + "</option>");
                }
                this.GetVaildlist.Text = sb.ToString();
            }
        }
    }
}