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
using EMT.DoneNOW.DAL;

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


            var tax_list = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.Tax_Total_Disp>(list.tax_total_disp);

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
                    double tax_item = 0;
                    double sum_tax = 0;
                    double total=0;
                    double totalsum = 0;
                    double sum_total = 0;
                    table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].One_Time_items + "</td></tr>");
                    //一次性收费
                    foreach (var item in cqi)
                    {

                        //此处添加分组判断
                        if (item.period_type_id!=null&&(int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                        {                            
                            table.Append(ReplaceQuoteItem(item, quote_body,out total,out tax_item));
                            totalsum += total+tax_item;
                            sum_tax += tax_item;
                        }                      

                    }
                   
                    sum_total += totalsum;
                    //一次性收费汇总
                  //  table.Append("<tr><td></td><td>"+ tax_item_list.One_Time_Subtotal+ "</td><td>"+ totalsum + "</td></tr>");

                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.One_Time_Subtotal + ":"+ totalsum + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }

                        }
                    }
                    table.Append("</tr>");



                    totalsum = 0;

                    //按月收费
                    table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Monthly_items + "</td></tr>");
                    foreach (var item in cqi)
                    {
                        if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        {
                            table.Append(ReplaceQuoteItem(item, quote_body, out total, out tax_item));
                            totalsum += total + tax_item;
                            sum_tax += tax_item;
                        }
                    }
                   
                    sum_total += totalsum;
                    //按月收费汇总

                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Monthly_Subtotal + ":" + totalsum + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }

                        }
                    }
                    table.Append("</tr>");
                    totalsum = 0;

                    //按季度收费
                    table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items + "</td></tr>");
                    foreach (var item in cqi)
                    {
                        if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        {

                            table.Append(ReplaceQuoteItem(item, quote_body, out total, out tax_item));
                            totalsum += total + tax_item;
                            sum_tax += tax_item;
                        }
                    }
                    
                    sum_total += totalsum;
                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Quarterly_Subtotal+ ":" + totalsum + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }

                        }
                    }

                    table.Append("</tr>");
                    totalsum = 0;
                    //按年收费
                    table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Yearly_items + "</td></tr>");
                    foreach (var item in cqi)
                    {
                            if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR) {

                            table.Append(ReplaceQuoteItem(item, quote_body, out total, out tax_item));
                            totalsum += total + tax_item;
                            sum_tax += tax_item;
                        }                      
                       
                    }
                   
                    sum_total += totalsum;
                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Yearly_Subtotal + ":" + totalsum + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }

                        }
                    }
                    table.Append("</tr>");
                    totalsum = 0;

                    //无分类
                    table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].No_category+ "</td></tr>");
                    foreach (var item in cqi)
                    {
                        if (item.period_type_id == null)
                        {
                            table.Append(ReplaceQuoteItem(item, quote_body, out total, out tax_item));
                            totalsum += total+ tax_item;
                            sum_tax += tax_item;
                        }

                    }
                   
                    sum_total += totalsum;
                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Subtotal + ":" + totalsum + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }
                        }
                    }


                    table.Append("</tr>");
                    totalsum = 0;


                    
                    //税收汇总
                    //table.Append("<tr><td>总纳税"+sum_tax +"</td></tr>");
                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Total_Taxes + ":" + sum_tax + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }
                        }
                    }
                    table.Append("</tr>");
                    //汇总
                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Total+ ":" + sum_total + "</td>"); break;
                                case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }
                        }
                    }
                    table.Append("</tr>");

                  

                    if (quote_body.GRID_OPTIONS[0].Show_vertical_lines == "yes")
                    {
                        Response.Write("<style>.bord{border-left: 1px solid #808080;border - right: 1px solid #808080;}</style>");
                    }

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
                var Vartable = qd.GetVar((int)qddata.contact_id, (int)qddata.account_id,(int)qddata.id,(int)qddata.opportunity_id);//此处需要填id
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





        private string ReplaceQuoteItem(crm_quote_item item, QuoteTemplateAddDto.BODY quote_body,out double total,out double tax_item) {
            total = 0;
            tax_item = 0;
            StringBuilder table = new StringBuilder();

            table.Append("<tr>");
            //获取item
            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
            {
                if (coulmn.Display == "yes")
                {
                    switch (coulmn.Column_Content)
                    {
                        case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                        case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>" + item.quantity + "</td>"); break;
                        case "Item": table.Append("<td style='text-align: Left;' class='bord'>" + item.name + "</td>"); break;
                        case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_price + "</td>"); break;
                        case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_discount + "</td>"); break;
                        case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'>" + (item.unit_price - item.unit_discount) + "</td>"); break;
                        case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>" + ((item.unit_price - item.unit_discount) * item.quantity) + "</td>"); break;
                        case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;                            
                    }
                    if(item.unit_price!=null&& item.quantity != null)
                    {
                        total = (double)((item.unit_price - (item.unit_discount != null ? item.unit_discount : 0)) * item.quantity);
                    }

                }
            }
            table.Append("</tr>");
            //显示税收
            if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && !string.IsNullOrEmpty(qddata.tax_region_id.ToString()))
            {
                try
                {
                    var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), Convert.ToInt32(item.tax_cate_id));
                    //获取分项税收
                    var tax_cate = qd.GetTaxRegiontax((int)tax.id);
                    if (tax != null && tax_cate != null)
                    {
                        foreach (var cate in tax_cate)
                        {
                            //确定显示位置
                            table.Append("<tr><td></td></tr>");
                            table.Append("<tr>");
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes")
                                {
                                    switch (coulmn.Column_Content)
                                    {
                                        case "Item#": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                        case "Quantity": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                        case "Item": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                        case "Unit Price": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                        case "Unit Discount": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                        case "Adjusted Unit Price": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                        case "Extended Price": table.Append("<td style='text-align: Left;' class='bord'>（税）" + cate.tax_name + "(" + (double)(cate.tax_rate * 100) + "%)（金额）" + (Double)(((item.unit_price - item.unit_discount) * item.quantity) * cate.tax_rate) + "</td>"); break;
                                        case "Discount %": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    }

                                }
                            }
                            table.Append("</tr>");

                            //table.Append("<tr><td>" + cate.tax_name + "(" + cate.tax_rate + ")</td><td>" + (((item.unit_price -item.unit_discount) * item.quantity) * cate.tax_rate) + "</td></tr>");



                        }
                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes" && coulmn.Column_Content == "Extended Price")
                            {
                                // 获取税收地区
                                string name = qd.GetTaxName(tax.tax_region_id);
                                table.Append("<td>" + name + "(" + (double)tax.total_effective_tax_rate * 100 + "%)（金额）" + (double)(((item.unit_price - item.unit_discount) * item.quantity) * tax.total_effective_tax_rate) + "</td>");
                                tax_item =total* (double)tax.total_effective_tax_rate;

                            }
                            else
                            {
                                table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                            }
                        }

                        table.Append("</tr>");
                    }
                }
                catch
                {
                    //获取总项税收
                    Response.Write("异常");

                }
            }
            return table.ToString();
        }
    }
}