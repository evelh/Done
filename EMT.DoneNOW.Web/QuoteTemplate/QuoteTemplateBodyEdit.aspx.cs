using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using Newtonsoft.Json;
using EMT.Tools;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteTemplateBodyEdit : BasePage
    {
        public int id;
        public QuoteTemplateAddDto.BODY quote_body;
        protected QuoteTemplateBLL qtb = new QuoteTemplateBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
           // id = 532;
            if (!IsPostBack)
            {

                if (Session["quote_body"] != null && !string.IsNullOrEmpty(Session["quote_body"].ToString()))
                {
                    string tt = Session["quote_body"].ToString();
                    quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(tt.Replace("'", "\""));
                    if (quote_body != null)
                    {
                        StringBuilder html = new StringBuilder();
                        int i = 0;
                        html.Append(" <script>");
                        html.Append(" $(document).ready(function () { ");
                        foreach (var column in quote_body.GRID_COLUMN)
                        {
                            html.Append("$(\".Order\").eq(" + i + ").text(\"" + column.Order + "\");");
                            html.Append("$(\".Column_Content\").eq(" + i + ").html(\"" + column.Column_Content + "\");");
                            html.Append("$(\".Column_label\").eq(" + i + ").html(\"" + column.Column_label + "\");");
                            if (column.Display == "yes")
                            {
                                html.Append("$(\".Display\").eq(" + i + ").children().addClass(\"CM\");");
                            }
                            else
                            {

                            }
                            i++;

                        }
                        foreach (var OPTIONS in quote_body.GRID_OPTIONS)
                        {
                            if (OPTIONS.Show_grid_header != "yes")
                            {
                                html.Append("$(\"#ShowGridHeader\").removeAttr(\"checked\");");
                            }                            
                            if (OPTIONS.Show_QuoteComment != "yes")
                            {
                                html.Append("$(\"#DisplayQuoteCommentInBody\").removeAttr(\"checked\");");
                            }
                            if (OPTIONS.Show_vertical_lines == "yes")
                            {
                                html.Append("$(\"#ShowVerticalGridlines\").attr(\"checked\",'true');");
                            }
                        }
                        i = 0;
                        foreach (var ITEM_COLUMN in quote_body.CUSTOMIZE_THE_ITEM_COLUMN)
                        {
                            html.Append("$(\".Type_of_Quote_Item\").eq(" + i + ").html(\"" + ITEM_COLUMN.Type_of_Quote_Item + "\");");
                            html.Append("$(\".Display_Format\").eq(" + i + ").html(\"" + ITEM_COLUMN.Display_Format + "\");");
                            i++;
                        }
                        foreach (var GROUPING in quote_body.GROUPING_HEADER_TEXT)
                        {
                            html.Append("$(\"#Monthly_items\").val(\"" + GROUPING.Monthly_items + "\");");
                            html.Append("$(\"#Quarterly_items\").val(\"" + GROUPING.Quarterly_items + "\");");
                            html.Append("$(\"#One_Time_items\").val(\"" + GROUPING.One_Time_items + "\");");
                            html.Append("$(\"#Semi_Annual_items\").val(\"" + GROUPING.Semi_Annual_items + "\");");
                            html.Append("$(\"#Yearly_items\").val(\"" + GROUPING.Yearly_items + "\");");
                            html.Append("$(\"#Shipping_items\").val(\"" + GROUPING.Shipping_items + "\");");
                            html.Append("$(\"#One_Time_Discount_items\").val(\"" + GROUPING.One_Time_Discount_items + "\");");
                            html.Append("$(\"#Optional_items\").val(\"" + GROUPING.Optional_items + "\");");
                            html.Append("$(\"#No_category\").val(\"" + GROUPING.No_category + "\");");
                        }
                        html.Append("});</script>");
                        this.datalist.Text = html.ToString();
                        html.Clear();
                    }
                }
                else {
                    this.datalist.Text = "<script> $(document).ready(function () {$(\".Display\").children().addClass(\"CM\");});</script>";
                }
            }
        }
        protected void Save(object sender, EventArgs e)
        {
            string t =Convert.ToString(Request.Form["data"].ToString());
            t = t.Replace("[,", "[").Replace(",]", "]");
            Session["quote_body"] =  t.Replace("\"","'");
            Session["cancel"] = 1;
            Response.Redirect("QuoteTemplateEdit.aspx?id="+id+"&op=edit");
            //Response.Write(t);
        }
    }
}