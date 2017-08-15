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
        private QuoteTemplateAddDto.BODY quote_body = new QuoteTemplateAddDto.BODY();
        protected void Page_Load(object sender, EventArgs e)
        {
            //从URL地址获取报价id
            id = Convert.ToInt32(Request.QueryString["id"]);
           // id = 406;//测试使用数据
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
                foreach (var list in datalist)
                {
                    //string t = "body_group_by_id";
                    //list.Equals(t);
                    if (!string.IsNullOrEmpty(qddata.quote_tmpl_id.ToString()) && list.id == qddata.quote_tmpl_id)
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
                if (!k && data.id > 0)
                {
                    initview(data);//使用默认模板显示
                }
                if (!k && data.id <= 0)
                {
                    initview(datalist[0]);//使用数据库第一个模板显示,
                }

            }
        }
        /// <summary>
        /// 根据报价模板向页面动态切换数据显示形式
        /// </summary>
        /// <param name="list"></param>
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
                quote_footer = VarSub(list.quote_footer_html);
                quote_footer = HttpUtility.HtmlDecode(quote_footer).Replace("\"", "'");//底部
            }
            string page_footer = "";
            if (!string.IsNullOrEmpty(list.page_footer_html))
            {
                page_footer = VarSub(list.page_footer_html);
                page_footer = HttpUtility.HtmlDecode(page_footer).Replace("\"", "'");//页脚
            }




            StringBuilder table = new StringBuilder();
            table.Append(page_header);
            table.Append(quote_header);


            var tax_list = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.Tax_Total_Disp>(list.tax_total_disp);

            if (!string.IsNullOrEmpty(list.body_html))
            {
                quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(list.body_html.Replace("'", "\""));//正文主体
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
                    double total = 0;//单项汇总
                    double totalsum = 0;//分组汇总使用
                    double sum_total = 0;//全部汇总使用
                    int order = 1;//排序码

                    List<int> group = new List<int>();
                    foreach (var item in cqi)
                    {
                        if (item.period_type_id != null && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                        {
                            if (!string.IsNullOrEmpty(item.period_type_id.ToString()) && !group.Contains((int)item.period_type_id))
                            {
                                group.Add((int)item.period_type_id);
                            }
                        }
                        if (item.period_type_id == null && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                        {
                            group.Add(1);
                        }
                        if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
                        {
                            group.Add((int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES);
                        }
                        if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                        {
                            group.Add((int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT);
                        }
                        if (item.optional == 1)
                        {
                            group.Add(2);
                        }
                    }


                    Dictionary<int, double> tax_dic1 = new Dictionary<int, double>();
                    Dictionary<int, double> tax_dic = new Dictionary<int, double>();
                    if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME))
                    {
                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].One_Time_items + "</td></tr>");
                        //一次性收费
                        foreach (var item in cqi)
                        {
                            //此处添加分组判断
                            if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME && item.optional != 1)
                            {
                                table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
                                totalsum += total;
                                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
                                {
                                    if (tax_dic1.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic1[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic1.Add((int)item.tax_cate_id, total);
                                    }
                                }
                            }
                        }
                    }
                    double sum = 0;
                    double sumsum = 0;
                    if (tax_dic1.Count > 0)
                    {

                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                            {
                                // 获取税收地区                                        
                                table.Append("<td>显示税收：</td>");
                            }
                            else
                            {
                                table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                            }
                        }



                        foreach (var tax_item in tax_dic1)
                        {
                            sum = tax_item.Value;
                            table.Append(ShowTax(tax_item.Key, ref sum));
                            sumsum += sum;
                        }
                        //ShowTax();
                    }
                    double one = totalsum;
                    sum_total += totalsum;
                    totalsum += sumsum;
                    //显示汇总
                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.One_Time_Subtotal + ":" + totalsum + "</td>"); break;
                                case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }

                        }
                    }
                    table.Append("</tr>");



                    //一次性收费汇总

                    totalsum = 0;

                    Dictionary<int, double> tax_dic2 = new Dictionary<int, double>();

                    //按月收费
                    if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH))
                    {
                        //按月收费
                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Monthly_items + "</td></tr>");
                        foreach (var item in cqi)
                        {
                            if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH && item.optional != 1)
                            {
                                table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
                                totalsum += total;
                                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
                                {
                                    if (tax_dic2.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic2[(int)item.tax_cate_id] += total;

                                    }
                                    else
                                    {
                                        tax_dic2.Add((int)item.tax_cate_id, total);
                                    }
                                    if (tax_dic.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic[(int)item.tax_cate_id] += total;

                                    }
                                    else
                                    {
                                        tax_dic.Add((int)item.tax_cate_id, total);
                                    }
                                }
                            }
                        }
                        sum_total += totalsum;
                        //按月收费汇总
                        sumsum = 0;
                        sum = 0;
                        if (tax_dic2.Count > 0)
                        {
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                                {
                                    // 获取税收地区                                        
                                    table.Append("<td>显示税收：</td>");
                                }
                                else
                                {
                                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                                }
                            }
                            foreach (var tax_item in tax_dic2)
                            {
                                sum = tax_item.Value;
                                table.Append(ShowTax(tax_item.Key, ref sum));
                                sumsum += sum;
                            }
                            //ShowTax();
                        }
                        totalsum += sumsum;



                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                switch (coulmn.Column_Content)
                                {
                                    case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                    case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Monthly_Subtotal + ":" + totalsum + "</td>"); break;
                                    case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                }

                            }
                        }
                        table.Append("</tr>");
                    }


                    totalsum = 0;
                    Dictionary<int, double> tax_dic3 = new Dictionary<int, double>();
                    //按季度收费
                    if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER))
                    {
                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items + "</td></tr>");
                        foreach (var item in cqi)
                        {
                            if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER && item.optional != 1)
                            {

                                table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
                                totalsum += total;
                                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
                                {
                                    if (tax_dic3.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic3[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic3.Add((int)item.tax_cate_id, total);
                                    }
                                    if (tax_dic.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic.Add((int)item.tax_cate_id, total);
                                    }
                                }

                            }
                        }

                        sum_total += totalsum;
                        //按月收费汇总

                        sum = 0;
                        sumsum = 0;
                        if (tax_dic3.Count > 0)
                        {
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                                {
                                    // 获取税收地区                                        
                                    table.Append("<td>显示税收：</td>");
                                }
                                else
                                {
                                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                                }
                            }
                            foreach (var tax_item in tax_dic3)
                            {
                                sum = tax_item.Value;
                                table.Append(ShowTax(tax_item.Key, ref sum));
                                sumsum += sum;
                            }
                            //ShowTax();
                        }
                        totalsum += sumsum;



                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                switch (coulmn.Column_Content)
                                {
                                    case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                    case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Quarterly_Subtotal + ":" + totalsum + "</td>"); break;
                                    case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                }

                            }
                        }

                        table.Append("</tr>");
                    }



                    totalsum = 0;
                    Dictionary<int, double> tax_dic4 = new Dictionary<int, double>();

                    if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR))
                    {
                        //按年收费
                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Yearly_items + "</td></tr>");
                        foreach (var item in cqi)
                        {
                            if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR && item.optional != 1)
                            {

                                table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
                                totalsum += total;
                                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
                                {
                                    if (tax_dic4.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic4[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic4.Add((int)item.tax_cate_id, total);
                                    }
                                    if (tax_dic.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic.Add((int)item.tax_cate_id, total);
                                    }
                                }
                            }

                        }
                        sum_total += totalsum;
                        sumsum = 0;
                        sum = 0;
                        if (tax_dic4.Count > 0)
                        {
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                                {
                                    // 获取税收地区                                        
                                    table.Append("<td>显示税收：</td>");
                                }
                                else
                                {
                                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                                }
                            }
                            foreach (var tax_item in tax_dic4)
                            {
                                sum = tax_item.Value;
                                table.Append(ShowTax(tax_item.Key, ref sum));
                                sumsum += sum;
                            }
                            //ShowTax();
                        }
                        totalsum += sumsum;

                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                switch (coulmn.Column_Content)
                                {
                                    case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                    case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Yearly_Subtotal + ":" + totalsum + "</td>"); break;
                                    case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                }

                            }
                        }
                        table.Append("</tr>");

                    }
                    totalsum = 0;
                    //无分类

                    Dictionary<int, double> tax_dic5 = new Dictionary<int, double>();

                    if (group.Contains(1))
                    {
                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].No_category + "</td></tr>");
                        foreach (var item in cqi)
                        {
                            if (item.period_type_id == null && item.optional != 1)
                            {
                                table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
                                totalsum += total;
                                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
                                {
                                    if (tax_dic5.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic5[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic5.Add((int)item.tax_cate_id, total);
                                    }
                                    if (tax_dic.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic.Add((int)item.tax_cate_id, total);
                                    }
                                }
                            }

                        }
                        sum_total += totalsum;

                        sumsum = 0;
                        sum = 0;
                        if (tax_dic5.Count > 0)
                        {
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                                {
                                    // 获取税收地区                                        
                                    table.Append("<td>显示税收：</td>");
                                }
                                else
                                {
                                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                                }
                            }
                            foreach (var tax_item in tax_dic5)
                            {
                                sum = tax_item.Value;
                                table.Append(ShowTax(tax_item.Key, ref sum));
                                sumsum += sum;
                            }
                            //ShowTax();
                        }
                        totalsum += sumsum;


                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                switch (coulmn.Column_Content)
                                {
                                    case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                    case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Subtotal + ":" + totalsum + "</td>"); break;
                                    case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                }
                            }
                        }


                        table.Append("</tr>");
                    }
                    totalsum = 0;

                    Dictionary<int, double> tax_dic6 = new Dictionary<int, double>();

                    //配送类型
                    if (group.Contains((int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES))
                    {
                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Shipping_items + "</td></tr>");

                        foreach (var item in cqi)
                        {
                            if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
                            {
                                table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
                                totalsum += total;
                                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
                                {
                                    if (tax_dic6.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic6[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic6.Add((int)item.tax_cate_id, total);
                                    }
                                    if (tax_dic.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic.Add((int)item.tax_cate_id, total);
                                    }
                                }


                            }

                        }
                        sum_total += totalsum;
                        sumsum = 0;
                        sum = 0;
                        if (tax_dic6.Count > 0)
                        {
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                                {
                                    // 获取税收地区                                        
                                    table.Append("<td>显示税收：</td>");
                                }
                                else
                                {
                                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                                }
                            }
                            foreach (var tax_item in tax_dic6)
                            {
                                sum = tax_item.Value;
                                table.Append(ShowTax(tax_item.Key, ref sum));
                                sumsum += sum;
                            }
                            //ShowTax();
                        }
                        totalsum += sumsum;

                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                switch (coulmn.Column_Content)
                                {
                                    case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                    case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Shipping_Subtotal + ":" + totalsum + "</td>"); break;
                                    case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                }
                            }
                        }

                        table.Append("</tr>");
                    }
                    totalsum = 0;
                    double discount_percent = 0;


                    //折扣类型
                    if (group.Contains((int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT))
                    {

                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].One_Time_Discount_items + "</td></tr>");

                        foreach (var item in cqi)
                        {
                            if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                            {
                                table.Append(ReplaceQuoteItem_Discount(item, quote_body, one, out total, ref order));

                                totalsum = totalsum - total;
                                discount_percent += (double)item.discount_percent;
                            }

                        }


                        sum_total += totalsum;

                        //特别处理
                        sum = 0;
                        sumsum = 0;
                        if (tax_dic1.Count > 0)
                        {
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                                {
                                    // 获取税收地区                                        
                                    table.Append("<td>显示税收：</td>");
                                }
                                else
                                {
                                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                                }
                            }
                            foreach (var tax_item in tax_dic1)
                            {
                                sum = tax_item.Value * discount_percent;
                                if (tax_dic.ContainsKey(tax_item.Key))
                                {
                                    // tax_dic.Add(tax_item.Key, tax_dic[tax_item.Key] - sum);
                                    tax_dic[tax_item.Key] = tax_dic[tax_item.Key] - sum;
                                }
                                else
                                {
                                    double v = tax_dic1[tax_item.Key] - sum;
                                    tax_dic.Add(tax_item.Key, v);
                                }
                                table.Append(ShowTax(tax_item.Key, ref sum));
                                sumsum += sum;
                            }
                            //ShowTax();
                        }
                        totalsum = totalsum - sum;


                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                switch (coulmn.Column_Content)
                                {
                                    case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                    case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.One_Time_Discount_Subtotal + ":" + totalsum + "</td>"); break;
                                    case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                }
                            }
                        }

                        table.Append("</tr>");
                    }
                    totalsum = 0;

                    Dictionary<int, double> tax_dic7 = new Dictionary<int, double>();
                    //可选项
                    if (group.Contains(2))
                    {
                        table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Optional_items + "</td></tr>");

                        foreach (var item in cqi)
                        {
                            if (item.optional == 1)
                            {
                                table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
                                totalsum += total;
                                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
                                {
                                    if (tax_dic7.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic7[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic7.Add((int)item.tax_cate_id, total);
                                    }
                                    if (tax_dic.ContainsKey((int)item.tax_cate_id))
                                    {
                                        tax_dic[(int)item.tax_cate_id] += total;
                                    }
                                    else
                                    {
                                        tax_dic.Add((int)item.tax_cate_id, total);
                                    }
                                }
                            }

                        }
                        sum_total += totalsum;
                        sumsum = 0;
                        sum = 0;
                        if (tax_dic7.Count > 0)
                        {
                            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                            {
                                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                                {
                                    // 获取税收地区                                        
                                    table.Append("<td>显示税收：</td>");
                                }
                                else
                                {
                                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                                }
                            }
                            foreach (var tax_item in tax_dic7)
                            {
                                sum = tax_item.Value;
                                table.Append(ShowTax(tax_item.Key, ref sum));
                                sumsum += sum;
                            }
                            //ShowTax();
                        }
                        totalsum += sumsum;
                        table.Append("<tr>");
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes")
                            {
                                switch (coulmn.Column_Content)
                                {
                                    case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                    case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
                                    case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Optional_Subtotal + ":" + totalsum + "</td>"); break;
                                    case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                }
                            }
                        }
                        table.Append("</tr>");
                    }


                    totalsum = 0;


                    //税收汇总
                    sumsum = 0;
                    sum = 0;
                    if (tax_dic.Count > 0)
                    {
                        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                        {
                            if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                            {
                                // 获取税收地区                                        
                                table.Append("<td>显示分类税收：</td>");
                            }
                            else
                            {
                                table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                            }
                        }
                        foreach (var tax_item in tax_dic)
                        {
                            sum = tax_item.Value;
                            table.Append(ShowTax(tax_item.Key, ref sum));
                            sumsum += sum;
                        }
                        //ShowTax();
                    }
                    sum_total += sumsum;

                    //汇总
                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "折后价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Total_Taxes + "</td>"); break;
                                case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + sumsum + "</td>"); break;
                                case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }
                        }
                    }
                    table.Append("</tr>");

                    table.Append("<tr>");
                    foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                    {
                        if (coulmn.Display == "yes")
                        {
                            switch (coulmn.Column_Content)
                            {
                                case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                                case "折后价": table.Append("<td style='text-align: Left;' class='bord'>" + tax_list.Total + ":</td>"); break;
                                case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + sum_total + "</td>"); break;
                                case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
                            }
                        }
                    }
                    table.Append("</tr>");

                    if (quote_body.GRID_OPTIONS[0].Show_vertical_lines == "yes")
                    {
                        Response.Write("<style>.bord{border-left: 1px solid #808080;border - right: 1px solid #808080;}</style>");
                    }
                    //清空字典
                    tax_dic.Clear(); tax_dic1.Clear(); tax_dic2.Clear(); tax_dic3.Clear(); tax_dic4.Clear(); tax_dic5.Clear(); tax_dic6.Clear(); tax_dic7.Clear();
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
            var Vartable = qd.GetVar((int)qddata.contact_id, (int)qddata.account_id, (int)qddata.id, (int)qddata.opportunity_id);
            foreach (Match m in reg.Matches(st))
            {
                string t = m.Groups[0].ToString();//[客户：名称]               
                if (Vartable.Rows.Count > 0)
                {
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


        private string ReplaceQuoteItem(crm_quote_item item, QuoteTemplateAddDto.BODY quote_body, out double total, ref int order)
        {
            total = 0;
            StringBuilder table = new StringBuilder();

            table.Append("<tr>");
            //获取quote_item的type_id，设置显示类型
            var Vartable = qd.GetQuoteItemVar((int)item.id);//此处需要填id
            string type_name = qd.GetItemTypeName(item.type_id);
            foreach (var type in quote_body.CUSTOMIZE_THE_ITEM_COLUMN)
            {
                if (type.Type_of_Quote_Item == type_name)
                {
                    //type.Display_Format;
                    Regex reg = new Regex(@"\[(.+?)]");
                    string type_format = type.Display_Format.ToString();
                    foreach (Match m in reg.Matches(type_format))
                    {
                        string t = m.Groups[0].ToString();//[客户：名称]               
                        if (Vartable.Rows.Count > 0) {
                            if (Vartable.Columns.Contains(t) && !string.IsNullOrEmpty(Vartable.Rows[0][t].ToString()))
                            {
                                type_format = type_format.Replace(t, Vartable.Rows[0][t].ToString());
                            }
                            else
                            {
                                type_format = type_format.Replace(m.Groups[0].ToString(), "");
                            }
                        }
                        else
                        {
                            type_format = type_format.Replace(m.Groups[0].ToString(), "");
                        }

                    }
                    item.name = string.Empty;
                    item.name = type_format;

                }
            }

            if (string.IsNullOrEmpty(item.discount_percent.ToString()))
            {
                item.discount_percent = item.unit_discount / item.unit_price;
            }
            if (item.unit_price != null && item.quantity != null)
            {
                total = (double)((item.unit_price - (item.unit_discount != null ? item.unit_discount : 0)) * item.quantity);
            }
            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
            {
                if (coulmn.Display == "yes")
                {
                    switch (coulmn.Column_Content)
                    {
                        case "序列号": table.Append("<td style='text-align: Right;' class='bord'>" + (order++) + ")</td>"); break;
                        case "数量": table.Append("<td style='text-align: Left;' class='bord'>" + decimal.Round((decimal)item.quantity, 2) + "</td>"); break;
                        case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>" + item.name + "</td>"); break;
                        case "单价": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_price + "</td>"); break;
                        case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_discount + "</td>"); break;
                        case "折后价": table.Append("<td style='text-align: Left;' class='bord'>" + (item.unit_price - item.unit_discount) + "</td>"); break;
                        case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + total + "</td>"); break;
                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>" + decimal.Round((decimal)item.discount_percent * 100, 2) + "%</td>"); break;
                    }

                }
            }
            table.Append("</tr>");
            return table.ToString();
        }


        //折扣


        private string ReplaceQuoteItem_Discount(crm_quote_item item, QuoteTemplateAddDto.BODY quote_body, double onetime, out double total, ref int order)
        {
            total = 0;
            StringBuilder table = new StringBuilder();
            table.Append("<tr>");
            //获取quote_item的type_id，设置显示类型
            var Vartable = qd.GetQuoteItemVar((int)item.id);//此处需要填id
            string type_name = qd.GetItemTypeName(item.type_id);
            foreach (var type in quote_body.CUSTOMIZE_THE_ITEM_COLUMN)
            {
                if (type.Type_of_Quote_Item == type_name)
                {
                    //type.Display_Format;
                    Regex reg = new Regex(@"\[(.+?)]");
                    string type_format = type.Display_Format.ToString();
                    foreach (Match m in reg.Matches(type_format))
                    {
                        string t = m.Groups[0].ToString();//[客户：名称]               

                        if (Vartable.Columns.Contains(t) && !string.IsNullOrEmpty(Vartable.Rows[0][t].ToString()))
                        {
                            type_format = type_format.Replace(t, Vartable.Rows[0][t].ToString());
                        }
                        else
                        {
                            type_format = type_format.Replace(m.Groups[0].ToString(), "");
                        }
                    }
                    item.name = string.Empty;
                    item.name = type_format;

                }
            }
            if (string.IsNullOrEmpty(item.discount_percent.ToString()))
            {
                item.discount_percent = item.unit_discount / item.unit_price;
            }
            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
            {
                if (coulmn.Display == "yes")
                {
                    switch (coulmn.Column_Content)
                    {
                        case "序列号": table.Append("<td style='text-align: Right;' class='bord'>" + (order++) + ")</td>"); break;
                        case "数量": table.Append("<td style='text-align: Left;' class='bord'>" + decimal.Round((decimal)item.quantity, 2) + "</td>"); break;
                        case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>" + item.name + "</td>"); break;
                        case "单价": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_price + "</td>"); break;
                        case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>" + item.unit_discount + "</td>"); break;
                        case "折后价": table.Append("<td style='text-align: Left;' class='bord'>" + (item.unit_price - item.unit_discount) + "</td>"); break;
                        case "总价": table.Append("<td style='text-align: Left;' class='bord'>" + onetime * (double)decimal.Round((decimal)item.discount_percent, 2) + "</td>"); break;
                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>" + decimal.Round((decimal)item.discount_percent * 100, 2) + "%</td>"); break;
                    }
                }
            }
            table.Append("</tr>");
            total = onetime * (double)decimal.Round((decimal)item.discount_percent, 4);
            return table.ToString();
        }
        private string ShowTax(int t, ref double sum)
        {

            StringBuilder table = new StringBuilder();
            decimal ttttt = 0;
            string name = qd.GetTaxName((int)qddata.tax_region_id);   //获取地区收税的数据                            
                                                                      // var tax_cate = qd.GetTaxRegiontax(qd.GetTaxid((int)qddata.tax_region_id));
            var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), Convert.ToInt32(t));
            var tax_cate = qd.GetTaxRegiontax((int)tax.id);
            foreach (var ttt in tax_cate)
            {
                table.Append("<tr>");
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                    {
                        // 获取税收地区                                       

                        table.Append("<td>" + ttt.tax_name + " (税率" + decimal.Round(ttt.tax_rate * 100, 4) + "%)" + decimal.Round(ttt.tax_rate * (decimal)sum, 4) + "</td>");
                    }
                    else
                    {
                        table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                    }
                }
                ttttt += ttt.tax_rate;
                table.Append("</tr>");

            }
            table.Append("<tr>");
            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
            {
                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                {
                    // 获取税收地区                                        

                    table.Append("<td>" + name + "(税率" + decimal.Round(ttttt * 100, 4) + "%)" + decimal.Round(ttttt * (decimal)sum, 4) + "</td>");
                    // tax_item = (double)decimal.Round(ttttt * (decimal)onetiemtax, 2);
                }
                else
                {
                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                }
            }
            table.Append("</tr>");
            sum = (double)decimal.Round(ttttt * (decimal)sum, 4);
            return table.ToString();
        }
    }
}