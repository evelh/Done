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
    public partial class test : BasePage
    {
        public int id;
        public int colsum = 1;//显示列数
        private sys_quote_tmpl data = new sys_quote_tmpl();
        private QuoteBLL qd = new QuoteBLL();
        private List<sys_quote_tmpl> datalist = new List<sys_quote_tmpl>();
        private crm_quote qddata = new crm_quote();
        private QuoteTemplateAddDto.BODY quote_body = new QuoteTemplateAddDto.BODY();
        private QuoteTemplateAddDto.Tax_Total_Disp ttd = new QuoteTemplateAddDto.Tax_Total_Disp();
        List<int> showstyle = new List<int>();//存储设置税收显示情况
        protected void Page_Load(object sender, EventArgs e)
        {
            //从URL地址获取报价id
            id = Convert.ToInt32(Request.QueryString["id"]);
            id = 294;//测试使用数据
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
                        initquote(list);//使用报价单已选择的报价模板显示
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
                    initquote(data);//使用默认模板显示
                }
                if (!k && data.id <= 0)
                {
                    initquote(datalist[0]);//使用数据库第一个模板显示,
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
                StringBuilder table = new StringBuilder();
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
                //设置税收显示情况
                if (list.show_each_tax_in_tax_period == 1)//每个期间类型分开计算税额',
                { showstyle.Add(1); }
                if (list.show_each_tax_in_tax_group == 1)//分行显示每个税收组的税额',
                { showstyle.Add(2); }
                if (list.show_tax_cate_superscript == 1)//显示税收种类上标',
                { showstyle.Add(3); }
                if (list.show_tax_cate == 1)//显示税收种类
                { showstyle.Add(4); }
                table.Append(cyclegroup());
                table.Append("</table>");
                this.table.Text = table.ToString();
                showstyle.Clear();
                table.Clear();
                //判断分组


                //测试先屏蔽其他情况
                //    if (qddata.group_by_id == 1192)//不分组
                //    {
                //        nogroup();
                //    }
                //    if (qddata.group_by_id == 1193)//按周期分组
                //    {
                //        cycle(list);
                //    }
                //    if (qddata.group_by_id == 1194)//按产品种类分组
                //    {
                //        productgroup();
                //    }
                //    if (qddata.group_by_id == 1195)//按周期+产品种类分组
                //    {
                //        cycle_productgroup();
                //    }
                //    if (qddata.group_by_id == 1196)//按产品种类+周期分组
                //    {
                //        product_cyclegroup();
                //    }
                //    if (string.IsNullOrEmpty(qddata.group_by_id.ToString()))
                //    {
                //        nogroup();//使用不分组展示
                //    }
                //}
                //else { 

                //    //此处先空着



                
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
            double sumtax = 0;
            List<crm_quote_item> three = new List<crm_quote_item>();
            int order = 1;//序列号
            double total;//总价
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    nogroup.Append(td(item, out total, ref order));
                    sumtotal += total; 
                    if(!string.IsNullOrEmpty(item.tax_cate_id.ToString()))
                    //ShowTax((int)item.tax_cate_id,ref total);//计算税收
                   sumtax += total;
                }

                else
                {
                    three.Add(item);
                }
            }

            nogroup.Append(Threesingle(three, out total, ref order));
            sumtotal += total;
            //nogroup.Append("<tr><td colspan=" + (colsum+1 - 2) + " style='text-align:Right;'>" + ttd.Total_Taxes+ "</td><td style='text-align:Right;'>" + sumtax + "</td></tr>");
            nogroup.Append("<tr><td colspan="+(colsum+1-2)+ " style='text-align:Right;'>"+ttd.Total+"</td><td style='text-align:Right;'>" + sumtotal + "</td></tr>");
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
            Dictionary<string, crm_quote_item> pro = new Dictionary<string, crm_quote_item>();
            List<string> name = new List<string>();
            int order = 1;//序列号
            double total;//总价
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    if (!string.IsNullOrEmpty(item.object_id.ToString()))
                    {
                        var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item.object_id}");
                        pro.Add(prod.product_name, item);
                        if (!name.Contains(prod.product_name))
                        {
                            name.Add(prod.product_name);
                        }
                    }
                    else
                    {
                        if (!name.Contains("y"))
                            name.Add("y");
                    }

                }
                else
                {
                    three.Add(item);
                }
            }
            if (pro.Count > 0)
            {
                foreach (var na in name)
                {
                    if (na != "y")
                        productgroup.Append(group_td(na));
                    foreach (var proname in pro)
                    {
                        if (na == proname.Key)//输出同一产品的
                        {
                            productgroup.Append(td(proname.Value, out total, ref order));
                        }
                    }
                }
            }
            //无产品绑定的，object_id为空
            if (name.Contains("y"))
            {
                productgroup.Append(group_td("无产品"));
                foreach (var item in cqi)
                {
                    if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                    {
                        if (string.IsNullOrEmpty(item.object_id.ToString()))
                        {
                            productgroup.Append(td(item, out total, ref order));
                        }
                    }
                }
            }
            if (three.Count > 0)
             productgroup.Append(Threesingle(three, out total, ref order));
            return productgroup.ToString();
        }
        /// <summary>
        /// 周期+产品
        /// </summary>
        /// <returns></returns>
        private string cycle_productgroup() {// 周期产品
            int order = 1;//序列号
            double total;//总价
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> groupitem = new List<crm_quote_item>();
            StringBuilder cycle_productgroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
            // 按周期产品分组
            foreach (var item in cqi) {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    groupitem.Add(item);
                }
                else
                {
                    three.Add(item);
                }                
            }
            var doubleGroupList = groupitem.GroupBy(d => d.period_type_id == null ? "" : d.period_type_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList().GroupBy(d => d.object_id == null ? "" : d.object_id.ToString()).ToDictionary(d => (object)d.Key, d => d.ToList()));
            foreach (var item1 in doubleGroupList)
            {
                //start 一次性收费
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_items));//周期分组
                    foreach (var item2 in item1.Value)
                    {
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item2.Key}");
                            cycle_productgroup.Append(group_chind_td(prod.product_name));//产品分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }
                        }
                        else {
                            cycle_productgroup.Append(group_chind_td("无产品"));
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                cycle_productgroup.Append(td(item3, out total, ref order));
                            }

                        }                        
                    }

                }//stop
                //start  按月分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));
                    foreach (var item2 in item1.Value)
                    {
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item2.Key}");
                            cycle_productgroup.Append(group_chind_td(prod.product_name));//产品分组
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

                }
                //stop
                //start  按季度分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));
                    foreach (var item2 in item1.Value)
                    {
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item2.Key}");
                            cycle_productgroup.Append(group_chind_td(prod.product_name));//产品分组
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

                }
                //stop
                //start  按半年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));
                    foreach (var item2 in item1.Value)
                    {
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item2.Key}");
                            cycle_productgroup.Append(group_chind_td(prod.product_name));//产品分组
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

                }
                //stop
                //start  按年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                {
                    cycle_productgroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));
                    foreach (var item2 in item1.Value)
                    {
                        if (!string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item2.Key}");
                            cycle_productgroup.Append(group_chind_td(prod.product_name));//产品分组
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
                }
                    //start  无分组分组
                    if (string.IsNullOrEmpty(item1.Key.ToString()))
                    {
                        cycle_productgroup.Append(group_td("无分组"));
                        foreach (var item2 in item1.Value)
                        {
                            if (!string.IsNullOrEmpty(item2.Key.ToString()))
                            {
                                var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item2.Key}");
                                cycle_productgroup.Append(group_chind_td(prod.product_name));//产品分组
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

                }
            }
            cycle_productgroup.Append(Threesingle(three, out total, ref order));
            return cycle_productgroup.ToString();
        }


        /// <summary>
        /// 按产品种类+周期分组
        /// </summary>
        private string product_cyclegroup() {
            int order = 1;//序列号
            double total;//总价
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> groupitem = new List<crm_quote_item>();
            StringBuilder product_cyclegroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
            // 按周期产品分组
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    groupitem.Add(item);
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

                if (!string.IsNullOrEmpty(item1.Key.ToString()))//有产品
                {
                    var prod = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id={item1.Key}");
                    product_cyclegroup.Append(group_td(prod.product_name));//产品分组
                    foreach (var item2 in item1.Value)//周期分组
                    {
                        //一次性
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按月
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按季度
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按无分组
                        if (string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            product_cyclegroup.Append(group_chind_td("无分组"));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                    }
                }
                else//无产品
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
                            }
                        }
                        //按月
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按季度
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按半年
                        if (!string.IsNullOrEmpty(item2.Key.ToString()) && Convert.ToInt32(item2.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                        {
                            product_cyclegroup.Append(group_chind_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                        //按无分组
                        if (string.IsNullOrEmpty(item2.Key.ToString()))
                        {
                            product_cyclegroup.Append(group_chind_td("无分组"));//周期分组
                            foreach (var item3 in item2.Value as List<crm_quote_item>)
                            {
                                product_cyclegroup.Append(td(item3, out total, ref order));
                            }
                        }
                    }

                }


            }
            product_cyclegroup.Append(Threesingle(three, out total, ref order));
            return product_cyclegroup.ToString();

        }


        

        private string cyclegroup() {
            StringBuilder cyclegroup = new StringBuilder();
            int order = 1;//序列号
            double total;//总价
            List<crm_quote_item> three = new List<crm_quote_item>();
            List<crm_quote_item> groupitem = new List<crm_quote_item>();
            StringBuilder product_cyclegroup = new StringBuilder();
            var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
            // 按周期产品分组
            foreach (var item in cqi)
            {
                if (item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                {
                    groupitem.Add(item);
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
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_items));//周期分组
                        foreach (var item3 in item1.Value as List<crm_quote_item>)
                        {
                            cyclegroup.Append(td(item3, out total, ref order));
                        }

                    
                    if (showstyle.Contains(2)) { }
                    //分行显示每个税收组的税额',
                    if (showstyle.Contains(3)) { }
                    //显示税收种类上标',
                    if (showstyle.Contains(4)) { }
                    //statrt显示税收
                    double sum = 0;
                    double tax_sum = 0;
                    var tax = item1.Value.GroupBy(d => d.tax_cate_id == null?"": d.tax_cate_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                    foreach (var item_tax in tax) {
                        if (!string.IsNullOrEmpty(item_tax.Key.ToString()))
                        {
                            sum = 0;
                            foreach (var item1_tax in item_tax.Value)
                            {
                                if (item1_tax.quantity != null && item1_tax.unit_price != null)
                                {

                                    sum += (double)((item1_tax.unit_price-item1_tax.unit_discount)*item1_tax.quantity);
                                }
                            }
                            string k=ShowTax(Convert.ToInt32(item_tax.Key),ref sum);//计算税收
                            tax_sum += sum;                            
                            if (showstyle.Contains(1))//每个期间类型分开计算税额
                            {
                                if (showstyle.Contains(2)) {
                                    cyclegroup.Append(k);
                                }                                
                            }
                        }

                    }
                    //stop显示税收

                }

                //stop
                //start  按月分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                {
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Monthly_items));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                    }
                    //statrt显示税收
                    double sum = 0;
                    double tax_sum = 0;
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
                            string k = ShowTax(Convert.ToInt32(item_tax.Key), ref sum);//计算税收
                            tax_sum += sum;
                            if (showstyle.Contains(1))//每个期间类型分开计算税额
                            {
                                //显示子汇总

                                if (showstyle.Contains(2))
                                {
                                    cyclegroup.Append(k);
                                }
                            }
                        }
                    }
                    //stop显示税收
                }
                //stop
                //start  按季度分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                {
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                    }
                    //statrt显示税收
                    double sum = 0;
                    double tax_sum = 0;
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
                            string k = ShowTax(Convert.ToInt32(item_tax.Key), ref sum);//计算税收
                            tax_sum += sum;
                            if (showstyle.Contains(1))//每个期间类型分开计算税额
                            {
                                if (showstyle.Contains(2))
                                {
                                    cyclegroup.Append(k);
                                }
                            }
                        }

                    }
                    //stop显示税收

                }
                //stop
                //start  按半年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                {
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Semi_Annual_items));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                    }
                    //statrt显示税收
                    double sum = 0;
                    double tax_sum = 0;
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
                            string k = ShowTax(Convert.ToInt32(item_tax.Key), ref sum);//计算税收
                            tax_sum += sum;
                            if (showstyle.Contains(1))//每个期间类型分开计算税额
                            {
                                if (showstyle.Contains(2))
                                {
                                    cyclegroup.Append(k);
                                }
                            }
                        }

                    }
                    //stop显示税收
                }
                //stop
                //start  按年分组
                if (!string.IsNullOrEmpty(item1.Key.ToString()) && Convert.ToInt32(item1.Key) == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                {
                    cyclegroup.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Yearly_items));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                    }
                    //statrt显示税收
                    double sum = 0;
                    double tax_sum = 0;
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
                            string k = ShowTax(Convert.ToInt32(item_tax.Key), ref sum);//计算税收
                            tax_sum += sum;
                            if (showstyle.Contains(1))//每个期间类型分开计算税额
                            {
                                if (showstyle.Contains(2))
                                {
                                    cyclegroup.Append(k);
                                }
                            }
                        }

                    }
                    //stop显示税收
                    //
                }
                //stop
                //start  无分组
                if (string.IsNullOrEmpty(item1.Key.ToString()))
                {
                    cyclegroup.Append(group_td("无分组"));
                    foreach (var item3 in item1.Value as List<crm_quote_item>)
                    {
                        cyclegroup.Append(td(item3, out total, ref order));
                    }
                    //statrt显示税收
                    double sum = 0;
                    double tax_sum = 0;
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
                            string k = ShowTax(Convert.ToInt32(item_tax.Key), ref sum);//计算税收
                            tax_sum += sum;
                            if (showstyle.Contains(1))//每个期间类型分开计算税额
                            {
                                if (showstyle.Contains(2))
                                {
                                    cyclegroup.Append(k);
                                }
                            }
                        }

                    }
                    //stop显示税收
                }
                //stop
            }
            cyclegroup.Append(Threesingle(three, out total, ref order));
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
            group_td.Append("<tr><td style='text-align: Left;' class='bord' colspan="+colsum+">" + name + "</td></tr>");
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
            group_chind_td.Append("<tr><td style='text-align: Left;' class='bord' colspan=2 ></td><td style='text-align: Left;' class='bord' colspan="+(colsum-2)+" >" + name + "</td></tr>");
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
            //item.name 是替换后的报价子项的名字和说明之类
            if (string.IsNullOrEmpty(item.discount_percent.ToString()))
            {
                item.discount_percent = item.unit_discount / item.unit_price;//计算折扣比
            }
            if (item.unit_price != null && item.quantity != null)
            {
                total = (double)((item.unit_price - (item.unit_discount != null ? item.unit_discount : 0)) * item.quantity);//计算单项报价项的金额
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
        /// <summary>
        /// 配送、一次性折扣、可选报价项三类特殊报价项总是分开独立显示
        /// </summary>
        /// <param name="item"></param>
        /// <param name="total"></param>
        /// <param name="order"></param>
        /// <returns></returns>
        /// item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1
        private string Threesingle(List<crm_quote_item> list, out double total, ref int order)
        {
            total = 0;
            StringBuilder table = new StringBuilder();
            List<int> three = new List<int>();
            foreach (var item in list)
            {
                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
                {
                    three.Add(1);
                }
                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)//一次性折扣
                {
                    three.Add(2);
                }
                if (item.optional == 1)
                {
                    three.Add(3);
                }
            }
            //配送
            if (three.Contains(1))
            {
                table.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Shipping_items));//配送费
                foreach (var item in list)
                {
                    if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
                    {
                        table.Append(td(item, out total, ref order));
                    }
                }
            }
            if (three.Contains(2))
            {
                table.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].One_Time_Discount_items));//一次性折扣，对一次性收费处理
                foreach (var item in list)
                {
                    //一次折扣
                    if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
                    {
                        table.Append(td(item, out total, ref order));
                    }
                }
            }
            if (three.Contains(3))
            {
                table.Append(group_td(quote_body.GROUPING_HEADER_TEXT[0].Optional_items));
                foreach (var item in list)
                {
                    if (item.optional == 1)
                    {
                        table.Append(td(item, out total, ref order));
                    }
                }
            }
            return table.ToString();
        }


        private string ShowTax(int t, ref double sum)
        {
            StringBuilder table = new StringBuilder();
            decimal ttttt = 0;
            string name = qd.GetTaxName((int)qddata.tax_region_id);   //获取地区收税的数据 
            string tax_type = qd.GetTaxName(t);
            var tax = qd.GetTaxRegion(Convert.ToInt32(qddata.tax_region_id.ToString()), Convert.ToInt32(t));
            var tax_cate = qd.GetTaxRegiontax((int)tax.id);
            if (showstyle.Contains(4)) {//是否显示税收种类
                table.Append("<tr>");
                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
                {
                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
                    {
                        // 获取税收地区                                       

                        table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_type + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + decimal.Round(tax.total_effective_tax_rate * (decimal)sum, 4) + "</strong></td>");
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

                        table.Append("<td style='text-align: Right;' class='bord'>" + ttt.tax_name + " (税率" + decimal.Round(ttt.tax_rate * 100, 4) + "%)</td><td style='text-align: Right;' class='bord'>" + decimal.Round(ttt.tax_rate * (decimal)sum, 4) + "</td>");
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
        /// 根据报价模板向页面动态切换数据显示形式
        /// </summary>
        /// <param name="list"></param>
        //private void cycle(sys_quote_tmpl list)
        //{
        //    string page_header = "";
        //    if (!string.IsNullOrEmpty(list.page_header_html))
        //    {

        //        page_header = VarSub(list.page_header_html);//变量替换

        //        page_header = HttpUtility.HtmlDecode(page_header).Replace("\"", "'");//页眉


        //    }
        //    string quote_header = "";
        //    if (!string.IsNullOrEmpty(list.quote_header_html))
        //    {
        //        quote_header = VarSub(list.quote_header_html);
        //        quote_header = HttpUtility.HtmlDecode(quote_header).Replace("\"", "'");//头部
        //    }
        //    string quote_footer = "";
        //    if (!string.IsNullOrEmpty(list.quote_footer_html))
        //    {
        //        quote_footer = VarSub(list.quote_footer_html);
        //        quote_footer = HttpUtility.HtmlDecode(quote_footer).Replace("\"", "'");//底部
        //    }
        //    string page_footer = "";
        //    if (!string.IsNullOrEmpty(list.page_footer_html))
        //    {
        //        page_footer = VarSub(list.page_footer_html);
        //        page_footer = HttpUtility.HtmlDecode(page_footer).Replace("\"", "'");//页脚
        //    }




        //    StringBuilder table = new StringBuilder();
        //    table.Append(page_header);
        //    table.Append(quote_header);
        //    var tax_list = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.Tax_Total_Disp>(list.tax_total_disp);

        //    if (!string.IsNullOrEmpty(list.body_html))
        //    {
        //        quote_body = new EMT.Tools.Serialize().DeserializeJson<QuoteTemplateAddDto.BODY>(list.body_html.Replace("'", "\""));//正文主体
        //        int i = 0;//统计显示的列数
        //        table.Append("<table class='ReadOnlyGrid_Table'>");
        //        table.Append("<tr>");
        //        foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //        {
        //            if (coulmn.Display == "yes")
        //            {
        //                table.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Right; '>" + coulmn.Column_label + "</td>");
        //                if (coulmn.Column_Content == "总价")
        //                {
        //                    table.Append("<td class='ReadOnlyGrid_TableHeader' style='text-align: Left; '></td>");
        //                }
        //                i++;
        //            }
        //        }
        //        table.Append("</tr>");


        //        //获取报价子项 crm_quote_item
        //        var cqi = new QuoteItemBLL().GetAllQuoteItem(qddata.id);
        //        //判断是否有对应子项数据
        //        if (cqi != null && cqi.Count > 0)
        //        {
        //            i = 1;
        //            double total = 0;//单项汇总
        //            double totalsum = 0;//分组汇总使用
        //            double sum_total = 0;//全部汇总使用
        //            int order = 1;//排序码

        //            List<int> group = new List<int>();
        //            foreach (var item in cqi)
        //            {
        //                if (item.period_type_id != null && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
        //                {
        //                    if (!string.IsNullOrEmpty(item.period_type_id.ToString()) && !group.Contains((int)item.period_type_id))
        //                    {
        //                        group.Add((int)item.period_type_id);
        //                    }
        //                }
        //                if (item.period_type_id == null && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
        //                {
        //                    group.Add(1);
        //                }
        //                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
        //                {
        //                    group.Add((int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES);
        //                }
        //                if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
        //                {
        //                    group.Add((int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT);
        //                }
        //                if (item.optional == 1)
        //                {
        //                    group.Add(2);
        //                }
        //            }


        //            Dictionary<int, double> tax_dic1 = new Dictionary<int, double>();
        //            Dictionary<int, double> tax_dic = new Dictionary<int, double>();
        //            if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME))
        //            {//判断是否显示表头
        //                if (quote_body.GRID_OPTIONS[0].Show_grid_header == "yes")
        //                {
        //                    table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].One_Time_items + "</td></tr>");
        //                }

        //                //一次性收费
        //                foreach (var item in cqi)
        //                {
        //                    //此处添加分组判断
        //                    if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME && item.optional != 1)
        //                    {
        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic1.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic1[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic1.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }
        //                    }
        //                }
        //            }
        //            double sum = 0;
        //            double sumsum = 0;



        //            StringBuilder table1 = new StringBuilder();
        //            table1.Append("<tr>");
        //            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //            {
        //                if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                {
        //                    // 获取税收地区                                        
        //                    table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.One_Time_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'>" + totalsum + "</td>");
        //                }
        //                else
        //                {
        //                    table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                }
        //            }
        //            table1.Append("</tr>");
        //            if (tax_dic1.Count > 0)
        //            {
        //                foreach (var tax_item in tax_dic1)
        //                {
        //                    sum = tax_item.Value;
        //                    table1.Append(ShowTax(tax_item.Key, ref sum));
        //                    sumsum += sum;
        //                }
        //                //ShowTax();
        //            }
        //            double one = totalsum;
        //            sum_total += totalsum;
        //            //税收汇总
        //            table1.Append("<tr>");
        //            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //            {
        //                if (coulmn.Display == "yes")
        //                {
        //                    switch (coulmn.Column_Content)
        //                    {
        //                        case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                        case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;'class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                        case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                    }
        //                }
        //            }
        //            table1.Append("</tr>");
        //            //显示汇总

        //            if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //            {
        //                table.Append(table1.ToString());
        //                table1.Clear();
        //                totalsum += sumsum;
        //            }


        //            table.Append("<tr>");
        //            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //            {
        //                if (coulmn.Display == "yes")
        //                {
        //                    switch (coulmn.Column_Content)
        //                    {
        //                        case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                        case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.One_Time_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>"); break;
        //                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                    }

        //                }
        //            }
        //            table.Append("</tr>");





        //            totalsum = 0;
        //            Dictionary<int, double> tax_dic2 = new Dictionary<int, double>();

        //            //按月收费
        //            if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH))
        //            {
        //                //按月收费
        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Monthly_items + "</td></tr>");
        //                foreach (var item in cqi)
        //                {
        //                    if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH && item.optional != 1)
        //                    {
        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic2.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic2[(int)item.tax_cate_id] += total;

        //                            }
        //                            else
        //                            {
        //                                tax_dic2.Add((int)item.tax_cate_id, total);
        //                            }
        //                            if (tax_dic.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic[(int)item.tax_cate_id] += total;

        //                            }
        //                            else
        //                            {
        //                                tax_dic.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }
        //                    }
        //                }
        //                sum_total += totalsum;
        //                //按月收费汇总
        //                sumsum = 0;
        //                sum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Monthly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>");
        //                    }
        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic2.Count > 0)
        //                {

        //                    foreach (var tax_item in tax_dic2)
        //                    {
        //                        sum = tax_item.Value;
        //                        table1.Append(ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                // 

        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table1.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum += sumsum;
        //                }


        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Monthly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>:" + totalsum + "</strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }

        //                    }
        //                }
        //                table.Append("</tr>");
        //            }


        //            totalsum = 0;
        //            Dictionary<int, double> tax_dic3 = new Dictionary<int, double>();
        //            //按季度收费
        //            if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER))
        //            {
        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Quarterly_items + "</td></tr>");
        //                foreach (var item in cqi)
        //                {
        //                    if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER && item.optional != 1)
        //                    {

        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic3.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic3[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic3.Add((int)item.tax_cate_id, total);
        //                            }
        //                            if (tax_dic.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }

        //                    }
        //                }

        //                sum_total += totalsum;

        //                sum = 0;
        //                sumsum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Quarterly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>");
        //                    }
        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic3.Count > 0)
        //                {
        //                    foreach (var tax_item in tax_dic3)
        //                    {
        //                        sum = tax_item.Value;
        //                        table1.Append(ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                // totalsum += sumsum;

        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table1.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum += sumsum;
        //                }


        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Quarterly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }

        //                    }
        //                }

        //                table.Append("</tr>");
        //            }

        //            totalsum = 0;

        //            Dictionary<int, double> tax_dic8 = new Dictionary<int, double>();
        //            if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR))//按半年收费
        //            {
        //                //按半年收费
        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Yearly_items + "</td></tr>");
        //                foreach (var item in cqi)
        //                {
        //                    if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR && item.optional != 1)
        //                    {

        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic8.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic8[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic8.Add((int)item.tax_cate_id, total);
        //                            }
        //                            if (tax_dic.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }
        //                    }

        //                }
        //                sum_total += totalsum;
        //                sumsum = 0;
        //                sum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Semi_Annual_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>");
        //                    }
        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic8.Count > 0)
        //                {

        //                    foreach (var tax_item in tax_dic8)
        //                    {
        //                        sum = tax_item.Value;
        //                        table1.Append(ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                //totalsum += sumsum;
        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table1.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum += sumsum;
        //                }

        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Semi_Annual_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }

        //                    }
        //                }
        //                table.Append("</tr>");

        //            }

        //            totalsum = 0;

        //            Dictionary<int, double> tax_dic4 = new Dictionary<int, double>();
        //            if (group.Contains((int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR))
        //            {
        //                //按年收费
        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Yearly_items + "</td></tr>");
        //                foreach (var item in cqi)
        //                {
        //                    if (item.period_type_id != null && (int)item.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR && item.optional != 1)
        //                    {

        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic4.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic4[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic4.Add((int)item.tax_cate_id, total);
        //                            }
        //                            if (tax_dic.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }
        //                    }

        //                }
        //                sum_total += totalsum;
        //                sumsum = 0;
        //                sum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Yearly_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>");
        //                    }
        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic4.Count > 0)
        //                {

        //                    foreach (var tax_item in tax_dic4)
        //                    {
        //                        sum = tax_item.Value;
        //                        table1.Append(ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                //totalsum += sumsum;
        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table1.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum += sumsum;
        //                }



        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Yearly_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }

        //                    }
        //                }
        //                table.Append("</tr>");

        //            }
        //            totalsum = 0;
        //            //无分类

        //            Dictionary<int, double> tax_dic5 = new Dictionary<int, double>();

        //            if (group.Contains(1))
        //            {
        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].No_category + "</td></tr>");
        //                foreach (var item in cqi)
        //                {
        //                    if (item.period_type_id == null && item.optional != 1)
        //                    {
        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic5.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic5[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic5.Add((int)item.tax_cate_id, total);
        //                            }
        //                            if (tax_dic.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }
        //                    }

        //                }
        //                sum_total += totalsum;

        //                sumsum = 0;
        //                sum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>");
        //                    }

        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic5.Count > 0)
        //                {


        //                    foreach (var tax_item in tax_dic5)
        //                    {
        //                        sum = tax_item.Value;
        //                        table1.Append(ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                //totalsum += sumsum;
        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum += sumsum;
        //                }

        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }


        //                table.Append("</tr>");
        //            }
        //            totalsum = 0;

        //            Dictionary<int, double> tax_dic6 = new Dictionary<int, double>();

        //            //配送类型
        //            if (group.Contains((int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES))
        //            {
        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Shipping_items + "</td></tr>");

        //                foreach (var item in cqi)
        //                {
        //                    if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && item.optional != 1)
        //                    {
        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic6.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic6[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic6.Add((int)item.tax_cate_id, total);
        //                            }
        //                            if (tax_dic.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }


        //                    }

        //                }
        //                sum_total += totalsum;
        //                sumsum = 0;
        //                sum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Shipping_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>");
        //                    }
        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic6.Count > 0)
        //                {

        //                    foreach (var tax_item in tax_dic6)
        //                    {
        //                        sum = tax_item.Value;
        //                        table1.Append(ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                // totalsum += sumsum;
        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table1.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum += sumsum;
        //                }

        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Shipping_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }

        //                table.Append("</tr>");
        //            }
        //            totalsum = 0;
        //            double discount_percent = 0;


        //            //折扣类型
        //            if (group.Contains((int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT))
        //            {

        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].One_Time_Discount_items + "</td></tr>");

        //                foreach (var item in cqi)
        //                {
        //                    if (item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && item.optional != 1)
        //                    {
        //                        table.Append(ReplaceQuoteItem_Discount(item, quote_body, one, out total, ref order));

        //                        totalsum = totalsum - total;
        //                        discount_percent += (double)item.discount_percent;
        //                    }

        //                }


        //                sum_total += totalsum;

        //                //特别处理
        //                sum = 0;
        //                sumsum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><font color=\"red\">" + tax_list.One_Time_Discount_Subtotal + "</font></td><td style='text-align: Right;' class='bord'><font color=\"red\">" + totalsum + "</font></td>");
        //                    }
        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic1.Count > 0)
        //                {

        //                    foreach (var tax_item in tax_dic1)
        //                    {
        //                        sum = tax_item.Value * discount_percent;
        //                        if (tax_dic.ContainsKey(tax_item.Key))
        //                        {
        //                            // tax_dic.Add(tax_item.Key, tax_dic[tax_item.Key] - sum);
        //                            tax_dic[tax_item.Key] = tax_dic[tax_item.Key] - sum;
        //                        }
        //                        else
        //                        {
        //                            double v = tax_dic1[tax_item.Key] - sum;
        //                            tax_dic.Add(tax_item.Key, v);
        //                        }
        //                        table1.Append(Discount_ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                //totalsum = totalsum - sumsum;
        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong><font color=\"red\">" + tax_list.Total_Taxes + "</font></strong></td><td style='text-align: Right;' class='bord'><strong><font color=\"red\">" + sumsum + "</font></strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table1.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum = totalsum - sumsum;
        //                }

        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong><font color=\"red\">" + tax_list.One_Time_Discount_Total + "</font></strong></td><td style='text-align: Right;' class='bord'><strong><font color=\"red\">" + totalsum + "</font></strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }

        //                table.Append("</tr>");
        //            }
        //            totalsum = 0;

        //            Dictionary<int, double> tax_dic7 = new Dictionary<int, double>();
        //            //可选项
        //            if (group.Contains(2))
        //            {
        //                table.Append("<tr><td>" + quote_body.GROUPING_HEADER_TEXT[0].Optional_items + "</td></tr>");

        //                foreach (var item in cqi)
        //                {
        //                    if (item.optional == 1)
        //                    {
        //                        table.Append(ReplaceQuoteItem(item, quote_body, out total, ref order));
        //                        totalsum += total;
        //                        if (!string.IsNullOrEmpty(item.tax_cate_id.ToString()) && qddata.tax_region_id != null)
        //                        {
        //                            if (tax_dic7.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic7[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic7.Add((int)item.tax_cate_id, total);
        //                            }
        //                            if (tax_dic.ContainsKey((int)item.tax_cate_id))
        //                            {
        //                                tax_dic[(int)item.tax_cate_id] += total;
        //                            }
        //                            else
        //                            {
        //                                tax_dic.Add((int)item.tax_cate_id, total);
        //                            }
        //                        }
        //                    }

        //                }
        //                sum_total += totalsum;
        //                sumsum = 0;
        //                sum = 0;
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes" && coulmn.Column_Content == "总价")
        //                    {
        //                        // 获取税收地区                                        
        //                        table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Optional_Subtotal + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>");
        //                    }
        //                    else
        //                    {
        //                        table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>");
        //                    }
        //                }
        //                table1.Append("</tr>");
        //                if (tax_dic7.Count > 0)
        //                {

        //                    foreach (var tax_item in tax_dic7)
        //                    {
        //                        sum = tax_item.Value;
        //                        table1.Append(ShowTax(tax_item.Key, ref sum));
        //                        sumsum += sum;
        //                    }
        //                    //ShowTax();
        //                }
        //                // totalsum += sumsum;
        //                //税收汇总
        //                table1.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table1.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table1.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table1.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                            case "折扣率": table1.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table1.Append("</tr>");

        //                if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //                {
        //                    table.Append(table1.ToString());
        //                    table1.Clear();
        //                    totalsum += sumsum;
        //                }

        //                table.Append("<tr>");
        //                foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //                {
        //                    if (coulmn.Display == "yes")
        //                    {
        //                        switch (coulmn.Column_Content)
        //                        {
        //                            case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                            case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                            case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Optional_Total + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + totalsum + "</strong></td>"); break;
        //                            case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        }
        //                    }
        //                }
        //                table.Append("</tr>");
        //            }


        //            totalsum = 0;


        //            //税收汇总
        //            sumsum = 0;
        //            sum = 0;



        //            if (tax_dic.Count > 0)
        //            {
        //                foreach (var tax_item in tax_dic)
        //                {
        //                    sum = tax_item.Value;
        //                    sum = TaxSum(tax_item.Key, sum);
        //                    sumsum += sum;
        //                }
        //                //ShowTax();
        //            }
        //            sum_total += sumsum;

        //            //汇总
        //            //if (qddata.show_each_tax_in_tax_group == 1)//判断是否单独计算每一时期的税收
        //            //{
        //            //    table.Append(table1.ToString());
        //            //    table1.Clear();
        //            //    totalsum += sumsum;
        //            //}


        //            table.Append("<tr>");
        //            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //            {
        //                if (coulmn.Display == "yes")
        //                {
        //                    switch (coulmn.Column_Content)
        //                    {
        //                        case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "折后价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Total_Taxes + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sumsum + "</strong></td>"); break;
        //                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                    }
        //                }
        //            }
        //            table.Append("</tr>");

        //            table.Append("<tr>");
        //            foreach (var coulmn in quote_body.GRID_COLUMN)//获取需要显示的列名
        //            {
        //                if (coulmn.Display == "yes")
        //                {
        //                    switch (coulmn.Column_Content)
        //                    {
        //                        case "序列号": table.Append("<td style='text-align: Right;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "数量": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "报价项名称": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单价": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "单元折扣": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                        case "折后价": table.Append("<td style='text-align: Left;' class='bord'></td>"); break;
        //                        case "总价": table.Append("<td style='text-align: Right;' class='bord'><strong>" + tax_list.Including_Optional_Quote_Items + "</strong></td><td style='text-align: Right;' class='bord'><strong>" + sum_total + "</strong></td>"); break;
        //                        case "折扣率": table.Append("<td style='text-align: Left;' class='bord'>&nbsp; &nbsp;</td>"); break;
        //                    }
        //                }
        //            }
        //            table.Append("</tr>");

        //            if (quote_body.GRID_OPTIONS[0].Show_vertical_lines == "yes")
        //            {
        //                Response.Write("<style>.bord{border-left: 1px solid  #eaeaea;border-right: 1px solid #eaeaea;}</style>");
        //            }
        //            //else {
        //            //    Response.Write("<style>.bord{border-bottom: 1px solid #eaeaea;border-top: 1px solid #eaeaea;}</style>");
        //            //}
        //            //清空字典
        //            tax_dic.Clear(); tax_dic1.Clear(); tax_dic2.Clear(); tax_dic3.Clear(); tax_dic4.Clear(); tax_dic5.Clear(); tax_dic6.Clear(); tax_dic7.Clear();
        //        }
        //    }

        //    table.Append("</table>");
        //    table.Append(quote_footer);
        //    table.Append(page_footer);
        //    this.table.Text = table.ToString();
        //    table.Clear();
        //}
        //改变报价模板显示数据


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