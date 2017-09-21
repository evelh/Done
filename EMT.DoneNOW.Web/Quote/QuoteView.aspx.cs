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
        public int colsum = 1;                                   //显示列数
        private sys_quote_tmpl data = new sys_quote_tmpl();
        private QuoteBLL qd = new QuoteBLL();                    //qd获取报价项相关信息使用
        private List<sys_quote_tmpl> datalist = new List<sys_quote_tmpl>();
        private crm_quote qddata = new crm_quote();
        private QuoteTemplateAddDto.BODY quote_body = new QuoteTemplateAddDto.BODY();
        private QuoteTemplateAddDto.Tax_Total_Disp ttd = new QuoteTemplateAddDto.Tax_Total_Disp();
        List<int> showstyle = new List<int>();                    //存储设置税收显示情况
        private double Super_toatl = 0;
        private double Super_tax_total = 0;
        private double option = 0;
        private double option_tax = 0;
        Dictionary<int, Double> taxt_item_sum = new Dictionary<int, double>();//用于统计全部子项税收
        List<int> sup = new List<int>();
        Dictionary<string, string> cyc_tax = new Dictionary<string, string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            //从URL地址获取报价id
            id = Convert.ToInt32(Request.QueryString["id"]);
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
                sys_quote_tmpl kkk = null;
                foreach (var list in datalist)
                {                    
                    if (qddata.quote_tmpl_id != null && !string.IsNullOrEmpty(qddata.quote_tmpl_id.ToString()) && list.id == qddata.quote_tmpl_id)
                    {
                        k = true;
                        this.quoteTemplateDropDownList.SelectedValue = qddata.quote_tmpl_id.ToString();
                        initquote(list);//使用报价单已选择的报价模板显示
                                        //break;
                    }
                   if (list.is_default == 1)
                    {                     
                       //判断是否为默认模板
                       kkk=list;//使用默认模板显示
                    }
                }              
                if (!k)
                {
                    if (kkk != null)
                    {
                        initquote(kkk);//使用默认模板显示
                    }
                    else {
                        initquote(datalist[0]);//使用数据库第一个模板显示,
                    }                    
                }

            }
        }

        private void initquote(sys_quote_tmpl list)
        {
            if (!string.IsNullOrEmpty(list.body_html))//如果body_html未填写，则不显示表格
            {
                quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(list.body_html.Replace("'", "\""));//正文主体
                ttd = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.Tax_Total_Disp>(list.tax_total_disp.Replace("'", "\"")); //税收汇总自定义
                                                                                                                                             //显示表头
                if (quote_body.GRID_OPTIONS[0].Show_vertical_lines == "yes")
                {
                    Response.Write("<style>.bord{border-left: 1px solid  #eaeaea;border-right: 1px solid #eaeaea;}</style>");
                }
                StringBuilder table = new StringBuilder();
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
                //设置税收显示情况
                if (list.show_each_tax_in_tax_period == 1)//每个期间类型分开计算税额',
                { showstyle.Add(1); }
                if (list.show_each_tax_in_tax_group == 1)//分行显示每个税收组的税额',
                { showstyle.Add(2); }
                if (list.show_tax_cate_superscript == 1)//显示税收种类上标',
                { showstyle.Add(3); }
                if (list.show_tax_cate == 1)//显示税收种类
                { showstyle.Add(4); }


                ///               
                string page_header = "";
                if (!string.IsNullOrEmpty(list.page_header_html))
                {

                    page_header = VarSub(list.page_header_html);//变量替换

                    page_header = HttpUtility.HtmlDecode(page_header).Replace("\"", "'");//页眉


                }
                string quote_header = "";
                if (!string.IsNullOrEmpty(list.quote_header_html))
                {
                    quote_header = VarSubTop(list.quote_header_html);
                    quote_header = HttpUtility.HtmlDecode(quote_header).Replace("\"", "'");//头部
                }
                table.Append(page_header);
                //此处需要特别处理
                table.Append(quote_header);
                //页眉+top
                table.Append("<table class='ReadOnlyGrid_Table'>");
                table.Append("<tr>");
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes")
                    {
                        table.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Right; '>" + coulmn.Column_label + "</td>");
                        if (coulmn.Column_Content == "总价")
                        {
                            table.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Left; '></td>");
                        }
                        colsum += 1;
                    }
                }
                table.Append("</tr>");

                string cccccc;
                cccccc = cyclegroup();

                //测试先屏蔽其他情况
                if (qddata.group_by_id == (int)DicEnum.QUOTE_GROUP_BY.NO)//不分组
                {
                    table.Append(nogroup());
                }
                if (qddata.group_by_id == (int)DicEnum.QUOTE_GROUP_BY.CYCLE)//按周期分组
                {
                    table.Append(cccccc);
                }
                if (qddata.group_by_id == (int)DicEnum.QUOTE_GROUP_BY.PRODUCT)//按产品种类分组
                {
                    table.Append(productgroup());
                }
                if (qddata.group_by_id == (int)DicEnum.QUOTE_GROUP_BY.CYCLE_PRODUCT)//按周期+产品种类分组
                {
                    table.Append(cycle_productgroup());
                }
                if (qddata.group_by_id == (int)DicEnum.QUOTE_GROUP_BY.PRODUCT_CYCLE)//按产品种类+周期分组
                {
                    table.Append(product_cyclegroup());
                }
                if (string.IsNullOrEmpty(qddata.group_by_id.ToString()))
                {
                    table.Append(nogroup());//使用不分组展示
                }

                //table.Append(cycle_productgroup());
                table.Append(Total());
                table.Append("</table>");
                //bottom+底部

                table.Append(quote_footer);
                table.Append(page_footer);



                this.table.Text = table.ToString();
                showstyle.Clear();
                table.Clear();
                //判断分组





            }

        }
        /// <summary>
        /// 不分组
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        private string nogroup()
        {
            StringBuilder nogroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
            double sumtotal = 0;//报价单所有子项汇总
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> onetime = new List<crm_quote_item>();
            int order = 1;//序列号
            double total;//总价
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    if (item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                    {
                        onetime.Add(item);
                    }
                    nogroup.Append(td(item, out total, ref order));
                    sumtotal += total;
                }

                else
                {
                    three.Add(item);
                }
            }
            //汇总
            nogroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumtotal + "</strong></td></tr>");
            nogroup.Append(Threesingle(three, onetime, out total, ref order));
            return nogroup.ToString();
        }
        /// <summary>
        /// 按产品种类分组
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        private string productgroup()
        {
            StringBuilder productgroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);//获取所有子项
            //double sumtotal = 0;//报价单所有子项汇总
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> onetime = new List<crm_quote_item>();
            Dictionary<string, List<crm_quote_item>> pro = new Dictionary<string, List<crm_quote_item>>();
            List<crm_quote_item> groupitem = new List<crm_quote_item>();
            List<string> name = new List<string>();
            int order = 1;//序列号
            double total;//总价
            double sumtotal = 0;
            string productname=string.Empty;

            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    groupitem.Add(item);
                    if (item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                    {
                        onetime.Add(item);
                    }
                }
                else
                {
                    three.Add(item);
                }
            }

            var doubleGroupList = groupitem.GroupBy(d => d.object_id == null ? "" : d.object_id.ToString()).ToDictionary(d => (object)d.Key, d => d.ToList());


            //foreach (var item in cqi)
            //{
            //    if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
            //    {
            //        if (item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
            //        {
            //            onetime.Add(item);
            //        }
            //        if (item.object_id!=null&&!string.IsNullOrEmpty(item.object_id.ToString()))
            //        {
            //            productname = qd.GetProductName(Convert.ToInt32(item.object_id));
            //        }
            //        if (!string.IsNullOrEmpty(productname)&&pro[productname]!=null)
            //        {
            //            pro.Add(productname, item);
            //            pro[]
            //            if (!name.Contains(productname))
            //            {
            //                name.Add(productname);
            //            }
            //        }
            //        else
            //        {
            //            if (!name.Contains("y"))
            //                name.Add("y");
            //        }

            //    }
            //    else
            //    {
            //        three.Add(item);
            //    }
            //}
            if (doubleGroupList.Count > 0)
            {

                foreach (var proname in doubleGroupList)
                {
                    if (!string.IsNullOrEmpty(proname.Key.ToString()))
                    {
                        string na = qd.GetProductName(Convert.ToInt32(proname.Key.ToString()));
                        productgroup.Append(group_td(na));
                        foreach (var pp in proname.Value as List<crm_quote_item>)
                        {
                            productgroup.Append(td(pp, out total, ref order));
                            sumtotal += total;
                        }
                        productgroup.Append("<tr><td style = 'text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "(" + na + ")</strong></td><td style = 'text-align: Right;' class='bord'><strong>" + sumtotal + "</strong></td></tr>");
                        sumtotal = 0;
                    }

                    //if (na == proname.Key)//输出同一产品的
                    //    {
                    //        productgroup.Append(td(proname.Value, out total, ref order));
                    //        sumtotal += total;
                    //    }
                    //}
                }
                foreach (var proname in doubleGroupList)
                {
                    if (string.IsNullOrEmpty(proname.Key.ToString()))
                    {
                        productgroup.Append(group_td("无产品"));
                        foreach (var pp in proname.Value as List<crm_quote_item>)
                        {
                            productgroup.Append(td(pp, out total, ref order));
                            sumtotal += total;
                        }
                        productgroup.Append("<tr><td style = 'text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "(无产品)</strong></td><td style = 'text-align: Right;' class='bord'><strong>" + sumtotal + "</strong></td></tr>");
                        sumtotal = 0;
                    }
                }

            }
            //无产品绑定的，object_id为空
            //if (name.Contains("y"))
            //{
            //    productgroup.Append(group_td("无产品"));
            //    foreach (var item in cqi)
            //    {
            //        if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
            //        {
            //            if (string.IsNullOrEmpty(item.object_id.ToString()))
            //            {
            //                productgroup.Append(td(item, out total, ref order));
            //                sumtotal += total;
            //            }
            //        }
            //    }
            //    productgroup.Append("<tr><td style = 'text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "(无产品)</strong></td><td style = 'text-align: Right;' class='bord'><strong>" + sumtotal + "</strong></td></tr>");
            //    sumtotal = 0;
            //}
            if (three.Count > 0)
                productgroup.Append(Threesingle(three, onetime, out total, ref order));
            return productgroup.ToString();
        }
        /// <summary>
        /// 周期+产品
        /// </summary>
        /// <returns></returns>
        private string cycle_productgroup()
        {// 周期产品
            int order = 1;//序列号
            double total;//总价
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> groupitem = new List<crm_quote_item>();
            List<crm_quote_item> onetime = new List<crm_quote_item>();
            StringBuilder cycle_productgroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
            // 按周期产品分组
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    groupitem.Add(item);
                    if (item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                    {
                        onetime.Add(item);
                    }
                }
                else
                {
                    three.Add(item);
                }
            }
            var doubleGroupList = groupitem.GroupBy(d => d.period_type_id == null ? "" : d.period_type_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList().GroupBy(d => d.object_id == null ? "" : d.object_id.ToString()).ToDictionary(d => (object)d.Key, d => d.ToList()));
            string productname = string.Empty;

            foreach (var item1 in doubleGroupList)
            {
                //start 一次性收费
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_items));//周期分组
                    foreach (var item2 in item1.Value)
                    {
                        productname = string.Empty;
                        if (item2.Key != null && !string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            productname = qd.GetProductName(Convert.ToInt32(item2.Key));
                        }
                        if (!string.IsNullOrEmpty(productname))
                        {
                            cycle_productgroup.Append(group_chind_td(productname));//产品分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }
                        }
                        else
                        {
                            cycle_productgroup.Append(group_chind_td("无产品"));
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }

                        }
                    }
                    //汇总
                    //statrt显示税收                   
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        //计算子汇总
                        cycle_productgroup.Append(cyc_tax["onesub"]);
                        if (showstyle.Contains(2))
                        {
                            cycle_productgroup.Append(cyc_tax["onetax"]);
                        }
                        cycle_productgroup.Append(cyc_tax["onetaxsum"]);
                    }
                    //stop显示税收
                    cycle_productgroup.Append(cyc_tax["onetotal"]);

                }//stop

            }
            foreach (var item1 in doubleGroupList)
            {

                //start  按月分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));
                    foreach (var item2 in item1.Value)
                    {
                        productname = string.Empty;
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            productname = qd.GetProductName(Convert.ToInt32(item2.Key));
                        }
                        if (!string.IsNullOrEmpty(productname))
                        {                          
                            cycle_productgroup.Append(group_chind_td(productname));//产品分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }
                        }
                        else
                        {
                            cycle_productgroup.Append(group_chind_td("无产品"));
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }

                        }
                    }
                    //statrt显示税收                   
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        //计算子汇总
                        cycle_productgroup.Append(cyc_tax["montsub"]);
                        if (showstyle.Contains(2))
                        {
                            cycle_productgroup.Append(cyc_tax["monttax"]);
                        }
                        cycle_productgroup.Append(cyc_tax["monttaxsum"]);
                    }
                    //stop显示税收
                    cycle_productgroup.Append(cyc_tax["monttotal"]);

                }
                //stop
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  按季度分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));
                    foreach (var item2 in item1.Value)
                    {
                        productname = string.Empty;
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            productname = qd.GetProductName(Convert.ToInt32(item2.Key));
                        }
                        if (!string.IsNullOrEmpty(productname)) { 
                            cycle_productgroup.Append(group_chind_td(productname));//产品分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }
                        }
                        else
                        {
                            cycle_productgroup.Append(group_chind_td("无产品"));
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }

                        }
                    }
                    //statrt显示税收                   
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        //计算子汇总
                        cycle_productgroup.Append(cyc_tax["quarsub"]);
                        if (showstyle.Contains(2))
                        {
                            cycle_productgroup.Append(cyc_tax["quartax"]);
                        }
                        cycle_productgroup.Append(cyc_tax["quartaxsum"]);
                    }
                    //stop显示税收
                    cycle_productgroup.Append(cyc_tax["quartotal"]);

                }
                //stop
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  按半年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));
                    foreach (var item2 in item1.Value)
                    {
                        productname = string.Empty;
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            productname = qd.GetProductName(Convert.ToInt32(item2.Key));
                        }
                        if (!string.IsNullOrEmpty(productname)) { 
                            cycle_productgroup.Append(group_chind_td(productname));//产品分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }
                        }
                        else
                        {
                            cycle_productgroup.Append(group_chind_td("无产品"));
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }

                        }
                    }
                    //statrt显示税收                   
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        //计算子汇总
                        cycle_productgroup.Append(cyc_tax["semisub"]);
                        if (showstyle.Contains(2))
                        {
                            cycle_productgroup.Append(cyc_tax["semitax"]);
                        }
                        cycle_productgroup.Append(cyc_tax["semitaxsum"]);
                    }
                    //stop显示税收
                    cycle_productgroup.Append(cyc_tax["semitotal"]);

                }
                //stop
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  按年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));
                    foreach (var item2 in item1.Value)
                    {
                        productname = string.Empty;
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            productname = qd.GetProductName(Convert.ToInt32(item2.Key));
                        }
                        if (!string.IsNullOrEmpty(productname)) { 
                            cycle_productgroup.Append(group_chind_td(productname));//产品分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }
                        }
                        else
                        {
                            cycle_productgroup.Append(group_chind_td("无产品"));
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }

                        }
                    }
                    //statrt显示税收                   
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        //计算子汇总
                        cycle_productgroup.Append(cyc_tax["yearsub"]);
                        if (showstyle.Contains(2))
                        {
                            cycle_productgroup.Append(cyc_tax["yeartax"]);
                        }
                        cycle_productgroup.Append(cyc_tax["yeartaxsum"]);
                    }
                    //stop显示税收
                    cycle_productgroup.Append(cyc_tax["yeartotal"]);
                }
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  无分组分组
                if (string.IsNullOrEmpty(item1.Key.ToString()))
                {
                    cycle_productgroup.Append(group_td("无分组"));
                    foreach (var item2 in item1.Value)
                    {
                        productname = string.Empty;
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            productname = qd.GetProductName(Convert.ToInt32(item2.Key));
                        }
                        if (!string.IsNullOrEmpty(productname)) { 
                            cycle_productgroup.Append(group_chind_td(productname));//产品分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }
                        }
                        else
                        {
                            cycle_productgroup.Append(group_chind_td("无产品"));
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }

                        }
                    }
                    //stop
                    //statrt显示税收                   
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        //计算子汇总
                        cycle_productgroup.Append(cyc_tax["nosub"]);
                        if (showstyle.Contains(2))
                        {
                            cycle_productgroup.Append(cyc_tax["notax"]);
                        }
                        cycle_productgroup.Append(cyc_tax["notaxsum"]);
                    }
                    //stop显示税收
                    cycle_productgroup.Append(cyc_tax["nototal"]);

                }
            }
            cycle_productgroup.Append(Threesingle(three, onetime, out total, ref order));
            return cycle_productgroup.ToString();
        }


        /// <summary>
        /// 按产品种类+周期分组
        /// </summary>
        private string product_cyclegroup()
        {
            int order = 1;//序列号
            double total;//总价
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> groupitem = new List<crm_quote_item>();
            List<crm_quote_item> onetime = new List<crm_quote_item>();
            StringBuilder product_cyclegroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
            double sumtotal = 0;
            // 按周期产品分组
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    groupitem.Add(item);
                    if (item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                    {
                        onetime.Add(item);
                    }
                }
                else
                {
                    three.Add(item);
                }
            }
            var doubleGroupList = groupitem.GroupBy(d => d.object_id == null ? "" : d.object_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList().GroupBy(d => d.period_type_id == null ? "" : d.period_type_id.ToString()).ToDictionary(d => (object)d.Key, d => d.ToList()));


            //var doubleGroupList = groupitem.GroupBy(d => d.period_type_id == null ? "" : d.period_type_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList().GroupBy(d => d.object_id == null ? "" : d.object_id.ToString()).ToDictionary(d => (object)d.Key, d => d.ToList()));


            foreach (var item1 in doubleGroupList)
            {
                string productname = string.Empty;
                if (!string.IsNullOrEmpty(item1.Key.ToString()))
                {
                    productname = qd.GetProductName(Convert.ToInt32(item1.Key));
                }
                if (!string.IsNullOrEmpty(productname))//有产品
                {
                    product_cyclegroup.Append(group_td(productname));//产品分组
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //一次性
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按月
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按季度
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按无分组
                        if (string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            product_cyclegroup.Append(group_chind_td("无分组"));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    product_cyclegroup.Append("<tr><td style = 'text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "(" + productname + ")</strong></td><td style = 'text-align: Right;' class='bord'><strong>" + sumtotal + "</strong></td></tr>");
                    sumtotal = 0;
                }
            }
            foreach (var item1 in doubleGroupList)
            {
                if (string.IsNullOrEmpty(item1.Key.ToString()))
                {
                    product_cyclegroup.Append(group_td("无产品"));//产品分组
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //一次性
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按月
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按季度
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //按无分组
                        if (string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            product_cyclegroup.Append(group_chind_td("无分组"));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                                sumtotal += total;
                            }
                        }
                    }
                    product_cyclegroup.Append("<tr><td style = 'text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "(无产品)</strong></td><td style = 'text-align: Right;' class='bord'><strong>" + sumtotal + "</strong></td></tr>");
                    sumtotal = 0;
                }
            }
            product_cyclegroup.Append(Threesingle(three, onetime, out total, ref order));
            return product_cyclegroup.ToString();

        }
              

        private string cyclegroup()
        {
            StringBuilder cyclegroup = new StringBuilder();
            int order = 1;//序列号
            double total;//总价
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> groupitem = new List<crm_quote_item>();
            List<crm_quote_item> oneitem = new List<crm_quote_item>();
            StringBuilder product_cyclegroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
            // 按周期产品分组
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    groupitem.Add(item);
                    if (item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                    {
                        oneitem.Add(item);
                    }
                }
                else
                {
                    three.Add(item);
                }
            }
            var doubleGroupList = groupitem.GroupBy(d => d.period_type_id == null ? "" : d.period_type_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
            foreach (var item1 in doubleGroupList)
            {
                //start一次性收费
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                {
                    double onetotal = 0;
                    double tax_sum = 0;
                    StringBuilder k = new StringBuilder();
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_items));//周期分组
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                        onetotal += total;
                    }
                    //statrt显示税收
                    double sum = 0;
                    var tax = item1.Value.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                    foreach (var item_tax in tax)
                    {
                        if (!string.IsNullOrEmpty(item_tax.Key.ToString()))
                        {
                            sum = 0;
                            foreach (var item1_tax in item_tax.Value)
                            {
                                if (item1_tax.quantity != null && item1_tax.unit_price != null)
                                {

                                    sum += (double)((item1_tax.unit_price - item1_tax.unit_discount) * item1_tax.quantity);

                                }
                            }
                            //统计税收
                            if (taxt_item_sum.ContainsKey(Convert.ToInt32(item_tax.Key)))
                            {
                                taxt_item_sum[Convert.ToInt32(item_tax.Key)] += sum;
                            }
                            else
                            {
                                taxt_item_sum.Add(Convert.ToInt32(item_tax.Key), sum);
                            }
                            k.Append(ShowTax(Convert.ToInt32(item_tax.Key), ref sum));//计算税收
                            tax_sum += sum;
                        }

                    }
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        //计算子汇总
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.One_Time_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + onetotal + "</strong></td></tr>");
                        string k1 = "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.One_Time_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + onetotal + "</strong></td></tr>";
                        cyc_tax.Add("onesub", k1);
                        cyc_tax.Add("onetax", k.ToString());
                        if (showstyle.Contains(2))
                        {
                            cyclegroup.Append(k.ToString());
                        }
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                        cyc_tax.Add("onetaxsum", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                    }
                    //stop显示税收
                    cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.One_Time_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (onetotal+tax_sum) + "</strong></td></tr>");

                    Super_toatl= Super_toatl+onetotal + tax_sum;
                    Super_tax_total= Super_tax_total+tax_sum;
                    string k2 = "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.One_Time_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (onetotal + tax_sum) + "</strong></td></tr>";
                    cyc_tax.Add("onetotal", k2);
                    break;
                }
            }
            foreach (var item1 in doubleGroupList)
            {
                //stop
                //start  按月分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                {
                    double monthsum = 0;
                    double tax_sum = 0;
                    StringBuilder k = new StringBuilder();
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                        monthsum += total;
                    }
                    //statrt显示税收
                    double sum = 0;
                    var tax = item1.Value.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                    foreach (var item_tax in tax)
                    {
                        if (!string.IsNullOrEmpty(item_tax.Key.ToString()))
                        {
                            sum = 0;
                            foreach (var item1_tax in item_tax.Value)
                            {
                                if (item1_tax.quantity != null && item1_tax.unit_price != null)
                                {

                                    sum += (double)((item1_tax.unit_price - item1_tax.unit_discount) * item1_tax.quantity);
                                }
                            }
                            //统计税收
                            if (taxt_item_sum.ContainsKey(Convert.ToInt32(item_tax.Key)))
                            {
                                taxt_item_sum[Convert.ToInt32(item_tax.Key)] += sum;
                            }
                            else
                            {
                                taxt_item_sum.Add(Convert.ToInt32(item_tax.Key), sum);
                            }

                            k.Append(ShowTax(Convert.ToInt32(item_tax.Key), ref sum));//计算税收
                            tax_sum += sum;

                            //显示子汇总
                            //cyclegroup.Append("");

                        }
                    }
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Monthly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + monthsum + "</strong></td></tr>");
                        string k1 = "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Monthly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + monthsum + "</strong></td></tr>";
                        cyc_tax.Add("montsub", k1);
                        cyc_tax.Add("monthtax", k.ToString());
                        if (showstyle.Contains(2))
                        {
                            cyclegroup.Append(k.ToString());
                        }
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                        cyc_tax.Add("monttaxsum", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                    }
                    //stop显示税收
                    cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Monthly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (monthsum + tax_sum) + "</strong></td></tr>");
                    cyc_tax.Add("monttotal", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Monthly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (monthsum + tax_sum) + "</strong></td></tr>");
                    Super_toatl += monthsum + tax_sum;
                    Super_tax_total += tax_sum;
                    break;
                }
                //stop
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  按季度分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                {
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));
                    double quartersum = 0;
                    double tax_sum = 0;
                    StringBuilder k = new StringBuilder();
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                        quartersum += total;
                    }

                    //statrt显示税收
                    double sum = 0;

                    var tax = item1.Value.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                    foreach (var item_tax in tax)
                    {
                        if (!string.IsNullOrEmpty(item_tax.Key.ToString()))
                        {
                            sum = 0;
                            foreach (var item1_tax in item_tax.Value)
                            {
                                if (item1_tax.quantity != null && item1_tax.unit_price != null)
                                {

                                    sum += (double)((item1_tax.unit_price - item1_tax.unit_discount) * item1_tax.quantity);
                                }
                            }
                            //统计税收
                            if (taxt_item_sum.ContainsKey(Convert.ToInt32(item_tax.Key)))
                            {
                                taxt_item_sum[Convert.ToInt32(item_tax.Key)] += sum;
                            }
                            else
                            {
                                taxt_item_sum.Add(Convert.ToInt32(item_tax.Key), sum);
                            }

                            k.Append(ShowTax(Convert.ToInt32(item_tax.Key), ref sum));//计算税收
                            tax_sum += sum;

                        }

                    }
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Quarterly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + quartersum + "</strong></td></tr>");
                        cyc_tax.Add("quarsub", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Quarterly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + quartersum + "</strong></td></tr>");
                        cyc_tax.Add("quartax", k.ToString());
                        if (showstyle.Contains(2))
                        {
                            cyclegroup.Append(k.ToString());
                        }
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                        cyc_tax.Add("quartaxsum", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                    }
                    //stop显示税收
                    cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Quarterly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (quartersum + tax_sum) + "</strong></td></tr>");
                    cyc_tax.Add("quartotal", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Quarterly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (quartersum + tax_sum) + "</strong></td></tr>");
                    Super_toatl += quartersum + tax_sum;
                    Super_tax_total += tax_sum;
                }
                //stop
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  按半年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                {
                    double halfsum = 0;
                    double tax_sum = 0;
                    StringBuilder k = new StringBuilder();
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                        halfsum += total;
                    }
                    //statrt显示税收
                    double sum = 0;

                    var tax = item1.Value.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                    foreach (var item_tax in tax)
                    {
                        if (!string.IsNullOrEmpty(item_tax.Key.ToString()))
                        {
                            sum = 0;
                            foreach (var item1_tax in item_tax.Value)
                            {
                                if (item1_tax.quantity != null && item1_tax.unit_price != null)
                                {

                                    sum += (double)((item1_tax.unit_price - item1_tax.unit_discount) * item1_tax.quantity);
                                }
                            }
                            //统计税收
                            if (taxt_item_sum.ContainsKey(Convert.ToInt32(item_tax.Key)))
                            {
                                taxt_item_sum[Convert.ToInt32(item_tax.Key)] += sum;
                            }
                            else
                            {
                                taxt_item_sum.Add(Convert.ToInt32(item_tax.Key), sum);
                            }

                            k.Append(ShowTax(Convert.ToInt32(item_tax.Key), ref sum));//计算税收
                            tax_sum += sum;

                        }

                    }
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Semi_Annual_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + halfsum + "</strong></td></tr>");
                        cyc_tax.Add("semisub", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Semi_Annual_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + halfsum + "</strong></td></tr>");
                        cyc_tax.Add("semitax", k.ToString());
                        if (showstyle.Contains(2))
                        {
                            cyclegroup.Append(k.ToString());
                        }
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                        cyc_tax.Add("semitaxsum", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                    }
                    //stop显示税收
                    cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Semi_Annual_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (halfsum + tax_sum) + "</strong></td></tr>");
                    cyc_tax.Add("semitotal", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Semi_Annual_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (halfsum + tax_sum) + "</strong></td></tr>");
                    Super_toatl += halfsum + tax_sum;
                    Super_tax_total += tax_sum;
                }
                //stop
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  按年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                {
                    double yearsum = 0;
                    double tax_sum = 0;
                    StringBuilder k = new StringBuilder();
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                        yearsum += total;
                    }
                    //statrt显示税收

                    double sum = 0;

                    var tax = item1.Value.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                    foreach (var item_tax in tax)
                    {
                        if (!string.IsNullOrEmpty(item_tax.Key.ToString()))
                        {
                            sum = 0;
                            foreach (var item1_tax in item_tax.Value)
                            {
                                if (item1_tax.quantity != null && item1_tax.unit_price != null)
                                {

                                    sum += (double)((item1_tax.unit_price - item1_tax.unit_discount) * item1_tax.quantity);
                                }
                            }
                            //统计税收
                            if (taxt_item_sum.ContainsKey(Convert.ToInt32(item_tax.Key)))
                            {
                                taxt_item_sum[Convert.ToInt32(item_tax.Key)] += sum;
                            }
                            else
                            {
                                taxt_item_sum.Add(Convert.ToInt32(item_tax.Key), sum);
                            }

                            k.Append(ShowTax(Convert.ToInt32(item_tax.Key), ref sum));//计算税收
                            tax_sum += sum;

                        }

                    }
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Yearly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + yearsum + "</strong></td></tr>");
                        cyc_tax.Add("yearsub", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Yearly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + yearsum + "</strong></td></tr>");
                        cyc_tax.Add("yeartax", k.ToString());
                        if (showstyle.Contains(2))
                        {
                            cyclegroup.Append(k);
                        }
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + tax_sum + "</strong></td></tr>");
                        cyc_tax.Add("yeartaxsum", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + tax_sum + "</strong></td></tr>");

                    }
                    //stop显示税收
                    cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Yearly_Total + "</strong></td><td style='text-align: Right;' class='bord'>" + (yearsum + tax_sum) + "</td></tr>");
                    cyc_tax.Add("yeartotal", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Yearly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (yearsum + tax_sum) + "</strong></td></tr>");
                    Super_toatl += yearsum + tax_sum;
                    Super_tax_total += tax_sum;
                }
                //stop
            }
            foreach (var item1 in doubleGroupList)
            {
                //start  无分组
                if (string.IsNullOrEmpty(item1.Key.ToString()))
                {
                    double nogroupp = 0;
                    double tax_sum = 0;
                    StringBuilder k = new StringBuilder();
                    cyclegroup.Append(group_td("无分组"));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                        nogroupp += total;
                    }
                    //statrt显示税收
                    double sum = 0;

                    var tax = item1.Value.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                    foreach (var item_tax in tax)
                    {
                        if (!string.IsNullOrEmpty(item_tax.Key.ToString()))
                        {
                            sum = 0;
                            foreach (var item1_tax in item_tax.Value)
                            {
                                if (item1_tax.quantity != null && item1_tax.unit_price != null)
                                {

                                    sum += (double)((item1_tax.unit_price - item1_tax.unit_discount) * item1_tax.quantity);
                                }
                            }
                            //统计税收
                            if (taxt_item_sum.ContainsKey(Convert.ToInt32(item_tax.Key)))
                            {
                                taxt_item_sum[Convert.ToInt32(item_tax.Key)] += sum;
                            }
                            else
                            {
                                taxt_item_sum.Add(Convert.ToInt32(item_tax.Key), sum);
                            }
                            k.Append(ShowTax(Convert.ToInt32(item_tax.Key), ref sum));//计算税收
                            tax_sum += sum;

                        }

                    }
                    if (showstyle.Contains(1))//每个期间类型分开计算税额
                    {
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + nogroupp + "</strong></td></tr>");
                        cyc_tax.Add("nosub", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + nogroupp + "</strong></td></tr>");
                        cyc_tax.Add("notax", k.ToString());
                        if (showstyle.Contains(2))
                        {
                            cyclegroup.Append(k.ToString());
                        }
                        cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                        cyc_tax.Add("notaxsum", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (tax_sum) + "</strong></td></tr>");
                    }
                    //stop显示税收
                    cyclegroup.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (nogroupp + tax_sum) + "</strong></td></tr>");
                    cyc_tax.Add("nototal", "<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (nogroupp + tax_sum) + "</strong></td></tr>");
                    Super_toatl += nogroupp + tax_sum;
                    Super_tax_total += tax_sum;
                }
                //stop

            }
            Threetotal(three, oneitem);
            cyclegroup.Append(Threesingle(three, oneitem, out total, ref order));
            return cyclegroup.ToString();
        }

        /// <summary>
        /// 用于分组显示组名
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        private string group_td(string name)
        {
            StringBuilder group_td = new StringBuilder();
            group_td.Append("<tr><td style='text-align: Left;' class='bord' colspan=" + colsum + ">" + name + "</td></tr>");
            return group_td.ToString();
        }

        /// <summary>
        /// 用于二级分组的组名显示
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        private string group_chind_td(string name)
        {
            StringBuilder group_chind_td = new StringBuilder();
            group_chind_td.Append("<tr><td style='text-align: Left;' class='bord' colspan=2 ></td><td style='text-align: Left;' class='bord' colspan=" + (colsum - 2) + " >" + name + "</td></tr>");
            return group_chind_td.ToString();
        }
        /// <summary>
        /// 显示单项
        /// </summary>
        /// <param name="item"></param>
        /// <param name="total"></param>
        /// <param name="order"></param>
        /// <returns></returns>
        private string td(crm_quote_item item, out double total, ref int order)
        {
            total = 0;
            StringBuilder table = new StringBuilder();
            table.Append("<tr>");
            var Vartable = qd.GetQuoteItemVar((int)item.id);//此处获取准备用作替换的数据集
                                                            //string type_name = qd.GetItemTypeName(item.type_id);//获取报价子项的类型
                                                            //var typef = quote_body.CUSTOMIZE_THE_ITEM_COLUMN.Find(_ => _.Type_of_Quote_Item == type_name);          

            //foreach (var type in quote_body.CUSTOMIZE_THE_ITEM_COLUMN)
            //{
            //    if (type.Type_of_Quote_Item == type_name)//根据报价子项的类型展示相应的数据格式
            //    {
            //Regex reg = new Regex(@"\[(.+?)]");
            //string type_format = type.Display_Format.ToString();
            //foreach (Match m in reg.Matches(type_format))
            //{
            //    string t = m.Groups[0].ToString();
            //    if (Vartable.Rows.Count > 0)
            //    {
            //        if (Vartable.Columns.Contains(t) && !string.IsNullOrEmpty(Vartable.Rows[0][t].ToString()))
            //        {
            //            type_format = type_format.Replace(t, Vartable.Rows[0][t].ToString());
            //        }
            //        else
            //        {
            //            type_format = type_format.Replace(m.Groups[0].ToString(), "");
            //        }
            //    }
            //    else
            //    {
            //        type_format = type_format.Replace(m.Groups[0].ToString(), "");
            //    }

            //}
            //item.name = string.Empty;
            //item.name = type_format;
            //    }
            //}
            var typef2 = quote_body.CUSTOMIZE_THE_ITEM_COLUMN.Find(d=>d.Type_of_Quote_Item_ID ==item.type_id.ToString());
            if (typef2 != null) {
                Regex reg = new Regex(@"\[(.+?)]");
                string type_format = typef2.Display_Format;
                foreach (Match m in reg.Matches(type_format))
                {
                    string t = m.Groups[0].ToString();
                    if (Vartable.Rows.Count > 0)
                    {
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

            //item.name 是替换后的报价子项的名字和说明之类
            if (string.IsNullOrEmpty(item.discount_percent.ToString()))
            {
                item.discount_percent = item.unit_discount / item.unit_price;//计算折扣比
            }
            if (item.unit_price != null && item.quantity != null)
            {
                total = (double)((item.unit_price - (item.unit_discount != null ? item.unit_discount : 0)) * item.quantity);//计算单项报价项的金额
            }
            if (showstyle.Contains(4))
            {
                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()))
                {
                    if (!sup.Contains((int)item.tax_cate_id))
                    {
                        sup.Add((int)item.tax_cate_id);
                    }
                    item.name = "<span style='vertical-align: super;'>" + (sup.IndexOf((int)item.tax_cate_id) + 1).ToString() + "</span>" + item.name;

                }
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
                        case "总价": table.Append("<td style='text-align: Right;' class='bord'>" + total + "</td><td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>" + decimal.Round(Convert.ToDecimal(item.discount_percent)* 100, 2) + "%</td>"); break;
                    }
                }
            }
            table.Append("</tr>");
            return table.ToString();
        }

        private string disc_td(crm_quote_item item, double total, ref int order)
        {
            StringBuilder table = new StringBuilder();
            table.Append("<tr>");
            var Vartable = qd.GetQuoteItemVar((int)item.id);//此处获取准备用作替换的数据集
            string type_name = qd.GetItemTypeName(item.type_id);//获取报价子项的类型
            foreach (var type in quote_body.CUSTOMIZE_THE_ITEM_COLUMN)
            {
                if (type.Type_of_Quote_Item == type_name)//根据报价子项的类型展示相应的数据格式
                {
                    Regex reg = new Regex(@"\[(.+?)]");
                    string type_format = type.Display_Format.ToString();
                    foreach (Match m in reg.Matches(type_format))
                    {
                        string t = m.Groups[0].ToString();
                        if (Vartable.Rows.Count > 0)
                        {
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
            if (item.unit_discount != null)
            {
                item.discount_percent= (decimal)(Convert.ToDouble(item.unit_discount)/total);
                total = Convert.ToDouble(item.unit_discount);
            }
            else if (string.IsNullOrEmpty(item.discount_percent.ToString()))
            {
                item.discount_percent = item.unit_discount/item.unit_price;//计算折扣比
                total =(total * Convert.ToDouble(item.discount_percent));
            }
            if (showstyle.Contains(4))
            {
                if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()))
                {
                    if (!sup.Contains((int)item.tax_cate_id))
                    {
                        sup.Add((int)item.tax_cate_id);
                    }
                    item.name = "<span style='vertical-align: super;'>" + (sup.IndexOf((int)item.tax_cate_id) + 1).ToString() + "</span>" + item.name;

                }
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
                        case "总价": table.Append("<td style='text-align: Right;' class='bord'><font color=\"red\">" + total+ "</font></td><td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>" + decimal.Round(Convert.ToDecimal(item.discount_percent) * 100, 2) + "%</td>"); break;
                    }
                }
            }
            table.Append("</tr>");
            return table.ToString();
        }
        /// <summary>
        /// 配送、一次性折扣、可选报价项三类特殊报价项总是分开独立显示
        /// </summary>
        /// <param name="item"></param>
        /// <param name="total"></param>
        /// <param name="order"></param>
        /// <returns></returns>
        /// item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1
        private string Threesingle(List<crm_quote_item> list, List<crm_quote_item> onetime, out double total, ref int order)
        {
            total = 0;
            StringBuilder table = new StringBuilder();
            List<crm_quote_item> itemlist1 = new List<crm_quote_item>();
            List<crm_quote_item> itemlist2 = new List<crm_quote_item>();
            List<crm_quote_item> itemlist3 = new List<crm_quote_item>();
            foreach (var item in list)
            {
                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
                {
                    itemlist1.Add(item);
                }
                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)//一次性折扣
                {
                    itemlist2.Add(item);
                }
                if (item.optional == 1)
                {
                    itemlist3.Add(item);
                }
            }
            //配送
            if (itemlist1.Count > 0)
            {
                double sum = 0;
                double tax_sum = 0;
                double shippsum = 0;
                StringBuilder k = new StringBuilder();
                table.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Shipping_items));//配送费
                foreach (var item in itemlist1)
                {        //显示配送子项            
                    table.Append(td(item, out total, ref order));
                    shippsum += total;
                }
                var tax = itemlist1.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());//税收种类分组
                foreach (var tax_item in tax)
                {
                    if (!string.IsNullOrEmpty(tax_item.Key.ToString()))
                    {
                        foreach (var ii in tax_item.Value as List<crm_quote_item>)//税收类型分组
                        {
                            if (ii.quantity != null && ii.unit_price != null)
                            {

                                sum += (double)((ii.unit_price - ii.unit_discount) * ii.quantity);
                            }
                        }
                        ////统计税收
                        //if (taxt_item_sum.ContainsKey(Convert.ToInt32(tax_item.Key)))
                        //{
                        //    taxt_item_sum[Convert.ToInt32(tax_item.Key)] += sum;
                        //}
                        //else
                        //{
                        //    taxt_item_sum.Add(Convert.ToInt32(tax_item.Key), sum);
                        //}

                        k.Append(ShowTax(Convert.ToInt32(tax_item.Key), ref sum));//计算税收
                        tax_sum += sum;

                    }
                }
                //汇总
                if (showstyle.Contains(1))//判断是否每个期间类型分开计算税额
                {
                    //一配送收费汇总
                    table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Shipping_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + shippsum + "</strong></td></tr>");
                    if (showstyle.Contains(2))
                    {
                        table.Append(k.ToString());
                    }
                    table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + tax_sum + "</strong></td></tr>");
                }
                //配送收费汇总
                table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Shipping_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (shippsum + tax_sum) + "</strong></td></tr>");
                tax_sum = 0;
                shippsum = 0;
            }
            if (itemlist2.Count > 0)
            {
                double sum = 0;
                double tax_sum = 0;
                decimal discpre = 0;//一次性折扣百分比
                double sum_onetime = 0;
                StringBuilder k = new StringBuilder();
                table.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_Discount_items));//一次性折扣，对一次性收费处理
                foreach (var one_time in onetime)
                {
                    if (one_time.quantity != null && one_time.unit_price != null)
                    {
                        sum_onetime += (double)((Convert.ToDecimal(one_time.unit_price) - Convert.ToDecimal(one_time.unit_discount)) * Convert.ToDecimal(one_time.quantity));//对一次性收费汇总
                    }
                }
                foreach (var dis in itemlist2)
                {
                    discpre += Convert.ToDecimal(dis.discount_percent) + Convert.ToDecimal(dis.unit_discount)/(decimal)sum_onetime;
                    table.Append(disc_td(dis, sum_onetime, ref order));                   
                }
                //一次性收费单项已做
                var discount = onetime.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());//税收种类分组 
                foreach (var tax_item in discount)
                {
                    if (!string.IsNullOrEmpty(tax_item.Key.ToString()))
                    {
                        foreach (var ii in tax_item.Value as List<crm_quote_item>)//税收类型分组
                        {
                            if (ii.quantity != null && ii.unit_price != null)
                            {

                                sum += (double)((ii.unit_price - ii.unit_discount) * ii.quantity);
                            }
                        }
                        sum = sum * (double)decimal.Round(discpre,2);
                        ////统计税收
                        //if (taxt_item_sum.ContainsKey(Convert.ToInt32(tax_item.Key)))
                        //{
                        //    taxt_item_sum[Convert.ToInt32(tax_item.Key)] -= sum;
                        //}
                        k.Append(ShowTax(Convert.ToInt32(tax_item.Key), ref sum));//计算税收
                        tax_sum += sum;

                    }
                    sum = 0;
                }
                if (showstyle.Contains(1))//判断是否每个期间类型分开计算税额
                {
                    //一次性折扣收费汇总
                    table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.One_Time_Discount_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><font color=\"red\"><strong>(" + decimal.Round(((decimal)sum_onetime *discpre),2) + ")</strong></font></td></tr>");
                    if (showstyle.Contains(2))
                    {
                        table.Append(k.ToString());
                    }
                    table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><font color=\"red\"><strong>(" + tax_sum + ")</strong></font></td></tr>");
                }
                //一次性折扣收费汇总
                table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.One_Time_Discount_Total + "</strong></td><td style='text-align: Right;' class='bord'><font color=\"red\"><strong>(" + ((sum_onetime * (double)discpre) + tax_sum) + ")</strong></font></td></tr>");
                tax_sum = 0;
                sum_onetime = 0;

            }
            if (itemlist3.Count > 0)
            {
                double sum = 0;
                double tax_sum = 0;
                StringBuilder k = new StringBuilder();
                double opsum = 0;
                table.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Optional_items));
                foreach (var item in itemlist3)
                {
                    table.Append(td(item, out total, ref order));
                    opsum += total;
                }
                var tax = itemlist3.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());//税收种类分组
                foreach (var tax_item in tax)
                {
                    if (!string.IsNullOrEmpty(tax_item.Key.ToString()))
                    {
                        foreach (var ii in tax_item.Value as List<crm_quote_item>)//税收类型分组
                        {
                            if (ii.quantity != null && ii.unit_price != null)
                            {

                                sum += (double)((ii.unit_price - ii.unit_discount) * ii.quantity);
                            }
                        }
                        ////统计税收
                        //if (taxt_item_sum.ContainsKey(Convert.ToInt32(tax_item.Key)))
                        //{
                        //    taxt_item_sum[Convert.ToInt32(tax_item.Key)] += sum;
                        //}
                        //else
                        //{
                        //    taxt_item_sum.Add(Convert.ToInt32(tax_item.Key), sum);
                        //}
                        k.Append(ShowTax(Convert.ToInt32(tax_item.Key), ref sum));//计算税收
                        tax_sum += sum;
                        sum = 0;
                    }
                }
                if (showstyle.Contains(1))//判断是否每个期间类型分开计算税额
                {
                    //可选项
                    table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Optional_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + opsum + "</strong></td></tr>");
                    if (showstyle.Contains(2))
                    {
                        table.Append(k.ToString());
                    }
                    table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + tax_sum + "</strong></td></tr>");
                }
                //可选项
                table.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Optional_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (opsum + tax_sum) + "</strong></td></tr>");
                option = opsum + tax_sum;//全局变量，可选项汇总
                option_tax = tax_sum;//全局变量，可选项税收汇总
            }
            return table.ToString();
        }
        
        private void Threetotal(List<crm_quote_item> list, List<crm_quote_item> onetime)
        {
            double total;
            int order = 1;
            List<crm_quote_item> itemlist1 = new List<crm_quote_item>();
            List<crm_quote_item> itemlist2 = new List<crm_quote_item>();
            List<crm_quote_item> itemlist3 = new List<crm_quote_item>();
            foreach (var item in list)
            {
                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
                {
                    itemlist1.Add(item);
                }
                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)//一次性折扣
                {
                    itemlist2.Add(item);
                }
                if (item.optional == 1)
                {
                    itemlist3.Add(item);
                }
            }
            //配送
            if (itemlist1.Count > 0)
            {
                double sum = 0;
                double tax_sum = 0;
                double shippsum = 0;
                StringBuilder k = new StringBuilder();
                foreach (var item in itemlist1)
                {        //显示配送子项            
                   td(item, out total, ref order);
                    shippsum += total;
                }
                var tax = itemlist1.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());//税收种类分组
                foreach (var tax_item in tax)
                {
                    if (!string.IsNullOrEmpty(tax_item.Key.ToString()))
                    {
                        foreach (var ii in tax_item.Value as List<crm_quote_item>)//税收类型分组
                        {
                            if (ii.quantity != null && ii.unit_price != null)
                            {

                                sum += (double)((ii.unit_price - ii.unit_discount) * ii.quantity);
                            }
                        }
                        //统计税收
                        if (taxt_item_sum.ContainsKey(Convert.ToInt32(tax_item.Key)))
                        {
                            taxt_item_sum[Convert.ToInt32(tax_item.Key)] += sum;
                        }
                        else
                        {
                            taxt_item_sum.Add(Convert.ToInt32(tax_item.Key), sum);
                        }

                        k.Append(ShowTax(Convert.ToInt32(tax_item.Key), ref sum));//计算税收
                        tax_sum += sum;

                    }
                }
                Super_toatl += shippsum + tax_sum;
                Super_tax_total += tax_sum;
                tax_sum = 0;
                shippsum = 0;
            }
            if (itemlist2.Count > 0)
            {
                double sum = 0;
                double tax_sum = 0;
                decimal discpre = 0;//一次性折扣百分比
                double sum_onetime = 0;
                StringBuilder k = new StringBuilder();
                foreach (var one_time in onetime)
                {
                    if (one_time.quantity != null && one_time.unit_price != null)
                    {
                        sum_onetime += (double)((one_time.unit_price - one_time.unit_discount) * one_time.quantity);//对一次性收费汇总
                    }
                }
                foreach (var dis in itemlist2)
                {                   
                    discpre += Convert.ToDecimal(dis.discount_percent)+Convert.ToDecimal(dis.unit_discount)/(decimal)sum_onetime;
                }
                //一次性收费单项已做

                var discount = onetime.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());//税收种类分组      
                foreach (var tax_item in discount)
                {
                    if (!string.IsNullOrEmpty(tax_item.Key.ToString()))
                    {
                        sum = 0;
                        foreach (var ii in tax_item.Value as List<crm_quote_item>)//税收类型分组
                        {
                            if (ii.quantity != null && ii.unit_price != null)
                            {

                                sum += (double)((ii.unit_price - ii.unit_discount) * ii.quantity);
                            }
                        }
                        sum = sum * (double)decimal.Round(discpre,2);
                        //统计税收
                        if (taxt_item_sum.ContainsKey(Convert.ToInt32(tax_item.Key)))
                        {
                            taxt_item_sum[Convert.ToInt32(tax_item.Key)] -= sum;
                        }
                        k.Append(ShowTax(Convert.ToInt32(tax_item.Key), ref sum));//计算税收
                        tax_sum += sum;
                    }                   
                }
                Super_toatl = Super_toatl - (sum_onetime * (double)decimal.Round(discpre,4))- tax_sum;
                Super_tax_total = Super_tax_total - tax_sum;
                tax_sum = 0;
                sum_onetime = 0;
            }
            if (itemlist3.Count > 0)
            {
                double sum = 0;
                double tax_sum = 0;
                StringBuilder k = new StringBuilder();
                double opsum = 0;
                foreach (var item in itemlist3)
                {
                   td(item, out total, ref order);
                    opsum += total;
                }
                var tax = itemlist3.GroupBy(d => d.tax_cate_id == null ? "" : d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());//税收种类分组
                foreach (var tax_item in tax)
                {
                    if (!string.IsNullOrEmpty(tax_item.Key.ToString()))
                    {
                        foreach (var ii in tax_item.Value as List<crm_quote_item>)//税收类型分组
                        {
                            if (ii.quantity != null && ii.unit_price != null)
                            {

                                sum += (double)((ii.unit_price - ii.unit_discount) * ii.quantity);
                            }
                        }
                        //统计税收
                        if (taxt_item_sum.ContainsKey(Convert.ToInt32(tax_item.Key)))
                        {
                            taxt_item_sum[Convert.ToInt32(tax_item.Key)] += sum;
                        }
                        else
                        {
                            taxt_item_sum.Add(Convert.ToInt32(tax_item.Key), sum);
                        }
                        k.Append(ShowTax(Convert.ToInt32(tax_item.Key), ref sum));//计算税收
                        tax_sum += sum;
                        sum = 0;
                    }
                }
                //可选项
                option = opsum + tax_sum;//全局变量，可选项汇总
                option_tax = tax_sum;//全局变量，可选项税收汇总
                Super_toatl += opsum + tax_sum;
                Super_tax_total += tax_sum;
            }
        }

        private string ShowTax(int t, ref double sum)
        {
            if (qddata.tax_region_id == null) {
                sum = 0;
                return string.Empty;
            }
            StringBuilder table = new StringBuilder();
            decimal ttttt = 0;
            string name = qd.GetTaxName((int)qddata.tax_region_id);   //获取地区收税的数据 
            string tax_type = qd.GetTaxName(t);
            var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id), Convert.ToInt32(t));
            var tax_cate = qd.GetTaxRegiontax((int)tax.id);
            if (showstyle.Contains(4))
            {
                if (showstyle.Contains(3))
                {
                    if (!string.IsNullOrEmpty(t.ToString()))
                    {
                        if (!sup.Contains(t))
                        {
                            sup.Add(t);
                        }
                        tax_type = "<span style='vertical-align: super;'>" + (sup.IndexOf(t) + 1).ToString() + "</span>" + tax_type;

                    }
                }
                //是否显示税收种类
                table.Append("<tr>");
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                    {
                        // 获取税收地区                                       

                        table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_type + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + decimal.Round(tax.total_effective_tax_rate * (decimal)sum, 2) + "</strong></td>");
                    }
                    else
                    {
                        table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                    }
                }
                table.Append("</tr>");
            }

            foreach (var ttt in tax_cate)
            {
                table.Append("<tr>");
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                    {
                        // 获取税收地区                                       

                        table.Append("<td style='text-align: Right;' class='bord'>" + ttt.tax_name + " (税率" + decimal.Round(ttt.tax_rate * 100, 2) + "%)</td><td style='text-align: Right;' class='bord'>" + decimal.Round(ttt.tax_rate * (decimal)sum, 2) + "</td>");
                    }
                    else
                    {
                        table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                    }
                }
                ttttt += ttt.tax_rate;
                table.Append("</tr>");

            }
            sum = (double)decimal.Round(ttttt * (decimal)sum, 2);
            return table.ToString();
        }

        //总汇总
        private string Total()
        {
            StringBuilder k = new StringBuilder();
            StringBuilder total = new StringBuilder();
            if (option > 0)//如果存在可选项，则显示包括可选项汇总
            {
                total.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Including_Optional_Quote_Items + "</strong></td><td></td></tr>");
            }
            if (showstyle.Contains(1))//判断是否每个期间类型分开计算税额
            {
                //可选项
                total.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + (Super_toatl - Super_tax_total) + "</strong></td></tr>");
                if (showstyle.Contains(2))
                {
                    //汇总说有税收
                    foreach (var ii in taxt_item_sum)
                    {
                        double sum = ii.Value;
                        total.Append(ShowTax(Convert.ToInt32(ii.Key), ref sum));//计算税收
                    }
                    total.Append(k.ToString());
                }
            }
            total.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'>" + Super_tax_total + "</td></tr>");
            total.Append("<tr><td style='text-align: Right;' class='bord' colspan=" + (colsum - 1) + "><strong>" + ttd.Total + "</strong></td><td style='text-align: Right;' class='bord'>" + decimal.Round((decimal)Super_toatl,2) + "</td></tr>");
            return total.ToString();
        }



        protected void quoteTemplateDropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            int select_id = Convert.ToInt32(this.quoteTemplateDropDownList.SelectedValue.ToString());
            if (select_id > 0)
            {
                data = new QuoteTemplateBLL().GetQuoteTemplate(select_id);
                initquote(data);
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
                        st = st.Replace(m.Groups[0].ToString(), "无数据");
                        //Response.Write(Vartable.Rows[0]["[联系人：外部编号]"].ToString());
                    }
                }
                else
                {
                    st = st.Replace(m.Groups[0].ToString(), "无数据");
                    //Response.Write(Vartable.Rows[0]["[联系人：外部编号]"].ToString());
                }
            }
            return st;
        }

        private string VarSubTop(string st)
        {
            Regex reg = new Regex(@"\[(.+?)]");
            var Vartable = qd.GetVar((int)qddata.contact_id, (int)qddata.account_id, (int)qddata.id, (int)qddata.opportunity_id);
            foreach (Match m in reg.Matches(st))
            {
                string t = m.Groups[0].ToString();//[客户：名称]    
                if (t == "[Quote: Tax]" && st.IndexOf("[Quote: Tax Detail]") < 0)
                {
                    StringBuilder k = new StringBuilder();
                    if (taxt_item_sum.Count > 0)
                    {
                        foreach (var ii in taxt_item_sum)
                        {
                            var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), ii.Key);
                            k.Append(qd.GetTaxName(ii.Key) + "(" + decimal.Round(tax.total_effective_tax_rate * 100, 3) + ")</br>");

                        }
                        st = st.Replace(t, k.ToString());
                    }
                    else
                    {
                        st = st.Replace(t, "");
                    }


                }
                if (t == "[Quote: Tax Detail]")
                {
                    StringBuilder k = new StringBuilder();
                    if (taxt_item_sum.Count > 0)
                    {
                        foreach (var ii in taxt_item_sum)
                        {
                            double sum = ii.Value;
                            ShowTax(Convert.ToInt32(ii.Key), ref sum);//计算税收
                            var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), ii.Key);
                            k.Append(qd.GetTaxName(ii.Key) + "(" + decimal.Round(tax.total_effective_tax_rate * 100, 3) + ")：&nbsp; &nbsp;&nbsp; &nbsp;" + sum.ToString() + "</br>");

                        }
                        st = st.Replace(t, k.ToString()).Replace("[Quote: Tax]", "");
                    }
                    else
                    {
                        st = st.Replace(t, "");
                    }

                }
                if (t != "[Quote: Tax Detail]" && t != "[Quote: Tax]")
                {
                    if (Vartable.Rows.Count > 0)
                    {
                        if (Vartable.Columns.Contains(t) && !string.IsNullOrEmpty(Vartable.Rows[0][t].ToString()))
                        {
                            st = st.Replace(t, Vartable.Rows[0][t].ToString());
                        }
                        else
                        {
                            st = st.Replace(m.Groups[0].ToString(), "无数据");
                        }
                    }
                    else
                    {
                        st = st.Replace(m.Groups[0].ToString(), "无数据");
                    }
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
                        if (Vartable.Rows.Count > 0)
                        {
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
                        case "总价": table.Append("<td style='text-align: Right;' class='bord'>" + total + "</td><td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
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
                        case "总价": table.Append("<td style='text-align: Right;' class='bord'>" + onetime * (double)decimal.Round((decimal)item.discount_percent, 2) + "</td><td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>" + decimal.Round((decimal)item.discount_percent * 100, 2) + "%</td>"); break;
                    }
                }
            }
            table.Append("</tr>");
            //显示备注
            if (quote_body.GRID_OPTIONS[0].Show_QuoteComment == "yes")
            {
                table.Append("<tr><td style='text-align: Left;' class='bord'>" + qddata.quote_comment + "</td></tr>");
            }
            total = onetime * (double)decimal.Round((decimal)item.discount_percent, 4);
            return table.ToString();
        }

        private string Discount_ShowTax(int t, ref double sum)
        {

            StringBuilder table = new StringBuilder();
            decimal ttttt = 0;
            string name = qd.GetTaxName((int)qddata.tax_region_id);   //获取地区收税的数据 
            string tax_type = qd.GetTaxName(t);
            var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), Convert.ToInt32(t));
            var tax_cate = qd.GetTaxRegiontax((int)tax.id);
            table.Append("<tr>");
            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
            {
                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                {
                    // 获取税收地区                                       

                    table.Append("<td style='text-align: Right;' class='bord'><strong><font color=\"red\">" + tax_type + "</font></strong></td><td style='text-align: Right;' class='bord'><strong><font color=\"red\">" + decimal.Round(tax.total_effective_tax_rate * (decimal)sum, 4) + "</font></strong></td>");
                }
                else
                {
                    table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                }
            }
            table.Append("</tr>");

            foreach (var ttt in tax_cate)
            {
                table.Append("<tr>");
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                    {
                        // 获取税收地区                                       

                        table.Append("<td style='text-align: Right;' class='bord'><font color=\"red\">" + ttt.tax_name + " (税率" + decimal.Round(ttt.tax_rate * 100, 4) + "%</font></td><td style='text-align: Right;' class='bord'><font color=\"red\">" + decimal.Round(ttt.tax_rate * (decimal)sum, 4) + "</font></td>");
                    }
                    else
                    {
                        table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
                    }
                }
                ttttt += ttt.tax_rate;
                table.Append("</tr>");

            }
            sum = (double)decimal.Round(ttttt * (decimal)sum, 4);
            return table.ToString();
        }

        /// <summary>
        /// 税收
        /// </summary>
        /// <param name="t"></param>
        /// <param name="sum"></param>
        /// <returns></returns>
        private double TaxSum(int t, double sum)
        {
            var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), Convert.ToInt32(t));
            sum = (Double)decimal.Round(tax.total_effective_tax_rate * (decimal)sum, 4);
            return sum;
        }
    }
}