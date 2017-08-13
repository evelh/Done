using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Text.RegularExpressions;

namespace EMT.DoneNOW.Web
{
    public partial class QuoteView : BasePage
    {
        public int id;
        private sys_quote_tmpl data = new sys_quote_tmpl();
        private QuoteBLL qd = new QuoteBLL();
        private List<sys_quote_tmpl> datalist = new List<sys_quote_tmpl>();
        private crm_quote qddata = new crm_quote();
        protected void Page_Load(object sender, EventArgs e)
        {
            //从URL地址获取报价id
            id = Convert.ToInt32(Request.QueryString["id"]);
            id = 294;
            //获取所有的报价模板
            datalist = new QuoteTemplateBLL().GetAllTemplate();
            //获取该报价信息
            qddata = qd.GetQuote(id);

            if (!IsPostBack)
            {
                //绑定数据，在下拉框展示报价模板
                this.quoteTemplateDropDownList.DataTextField = "name";
                this.quoteTemplateDropDownList.DataValueField = "id";
                this.quoteTemplateDropDownList.DataSource = datalist;
                this.quoteTemplateDropDownList.DataBind();
                this.quoteTemplateDropDownList.Items.Insert(0, new ListItem() { Value = "0", Text = "未选择报价模板" });
                bool k = false;
                if (!string.IsNullOrEmpty(qddata.quote_tmpl_id.ToString()))
                {
                    foreach (var list in datalist)
                    {
                        string t = "body_group_by_id";
                        list.Equals(t);
                        if (list.id == qddata.quote_tmpl_id)
                        {
                            k = true;
                            this.quoteTemplateDropDownList.SelectedValue = qddata.quote_tmpl_id.ToString();
                            initview(list);//使用报价单已选择的报价模板显示
                            //break;
                        }
                        if (list.is_default == 1)
                        {
                            //判断是否为默认模板
                            data = list;
                        }
                    }
                }
                if (!k && data.id > 0)
                {
                    initview(data);//使用默认模板显示
                }
                if (!k && data.id <= 0)
                {
                    initview(datalist[0]);//使用数据库第一个模板显示,
                    //Response.Write("<script>alert("+datalist[0].id+");</script>");
                }

            }
        }

        private void initview(sys_quote_tmpl list)
        {
            string page_header = "";
            if (!string.IsNullOrEmpty(list.page_header_html))
            {

                page_header = VarSub(list.page_header_html);//变量替换

                page_header = HttpUtility.HtmlDecode(page_header).Replace("\"", "'");//页眉


            }
            string quote_header = "";
            if (!string.IsNullOrEmpty(list.quote_header_html))
            {
                quote_header = VarSub(list.quote_header_html);
                quote_header = HttpUtility.HtmlDecode(quote_header).Replace("\"", "'");//头部
            }
            string quote_footer = "";
            if (!string.IsNullOrEmpty(list.quote_footer_html))
            {
                quote_footer = HttpUtility.HtmlDecode(list.quote_footer_html).Replace("\"", "'");//底部
            }
            string page_footer = "";
            if (!string.IsNullOrEmpty(list.page_footer_html))
            {
                page_footer = HttpUtility.HtmlDecode(list.page_footer_html).Replace("\"", "'");//页脚
            }

            StringBuilder table = new StringBuilder();
            table.Append(page_header);
            table.Append(quote_header);
            if (!string.IsNullOrEmpty(list.body_html))
            {
                var quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(list.body_html.Replace("'", "\""));//正文主体
                int i = 0;//统计显示的列数
                table.Append("<table class='ReadOnlyGrid_Table'>");
                table.Append("<tr>");
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes")
                    {
                        table.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Left; '>" + coulmn.Column_label + "</td>");
                        i++;
                    }
                }
                table.Append("</tr>");

                
                //获取报价子项 crm_quote_item
                var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
                //判断是否有对应子项数据
                if (cqi != null && cqi.Count > 0)
                {
                    i = 1;
                    foreach (var item in cqi)
                    {
                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            //if (coulmn.Column_Content == "Item#")
                            //{
                            //    table.Append("<td style='text - align: Left; '>" + item.name + "</td>");
                            //}
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>" + (i++)+")</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>" + item.quantity + "</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>" + item.name + "</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_price + "</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_discount + "</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'>" + (item.unit_price-item.unit_discount)+ "</td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + ((item.unit_price - item.unit_discount)*item.quantity) + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }
                            if (item.tax_cate_id != null) {
                                table.Append("<tr><td></td></tr>");
                            }
                        }
                        table.Append("</tr>");

                        //显示税收
                        if (item.tax_cate_id != null && qddata.tax_region_id != null) {
                            try
                            {
                                var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), Convert.ToInt32(item.tax_cate_id));
                                //获取分项税收
                                var tax_cate = qd.GetTaxRegiontax((int)tax.id);
                                if (tax != null && tax_cate != null)
                                {
                                    foreach (var cate in tax_cate) {
                                        table.Append("<tr><td>"+cate.tax_name+"("+cate.tax_rate+")</td><td>"+(((item.unit_price - item.unit_discount) * item.quantity)* cate.tax_rate)+ "</td></tr>");
                                    }
                                    //获取税收地区
                                    string name = qd.GetTaxName(tax.tax_cate_id);
                                    table.Append("<tr><td>"+name+"("+tax.total_effective_tax_rate+ ")</td><td>"+(((item.unit_price - item.unit_discount) * item.quantity)*tax.total_effective_tax_rate)+"</td></tr>");
                                }
                            }
                            catch {
                            }
                            //获取总项税收
                           
                           
                        }
                    }
                }
                

                if (quote_body.GRID_OPTIONS[0].Show_vertical_lines == "yes") {
                    Response.Write("<style>.bord{border-left: 1px solid #808080;border - right: 1px solid #808080;}</style>");
                }

            }
            





           
            table.Append("</table>");
            table.Append(quote_footer);
            table.Append(page_footer);
            this.table.Text = table.ToString();
            table.Clear();
        }
        //改变报价模板显示数据
        protected void quoteTemplateDropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            int select_id = Convert.ToInt32(this.quoteTemplateDropDownList.SelectedValue.ToString());
            if (select_id > 0)
            {
                data = new QuoteTemplateBLL().GetQuoteTemplate(select_id);
                initview(data);
            }
        }
        /// <summary>
        /// 替换报价模板中显示变量
        /// </summary>
        /// <param name="tt"></param>
        /// <returns></returns>
        private string VarSub(string st)
        {
            Regex reg = new Regex(@"\[(.+?)]");
            foreach (Match m in reg.Matches(st))
            {
                string t = m.Groups[0].ToString();//[客户：名称]
                var Vartable = qd.GetVar((int)qddata.contact_id, (int)qddata.account_id);//此处需要填id
                                                                                         //此处需要编写替换逻辑//d_query_result表的col_comment[客户：名称]
                                                                                         //st.Replace(m.Groups[0].ToString());

                if (Vartable.Columns.Contains(t) && !string.IsNullOrEmpty(Vartable.Rows[0][t].ToString()))
                {
                    st = st.Replace(t, Vartable.Rows[0][t].ToString());
                    //Response.Write("kongzhi");
                }
                else
                {
                    st = st.Replace(m.Groups[0].ToString(), "无相关数据");
                    //Response.Write(Vartable.Rows[0]["[联系人：外部编号]"].ToString());
                }
            }
            return st;
        }
        /// <summary>
        /// 保存
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Save_click(object sender, EventArgs e)
        {
            qddata.quote_tmpl_id = Convert.ToInt32(this.quoteTemplateDropDownList.SelectedValue.ToString());
            qd.UpdateQuoteTemp(qddata, GetLoginUserId());

        }
        /// <summary>
        /// 关闭当前窗口
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Close_click(object sender, EventArgs e)
        {
            Response.Write("<script>window.close();self.opener.location.reload();</script>");
        }
    }
}