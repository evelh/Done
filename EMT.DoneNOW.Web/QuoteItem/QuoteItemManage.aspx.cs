using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.DAL;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.QuoteItem
{
    public partial class QuoteItemManage : BasePage
    {
        protected crm_quote quote = null;
        protected Dictionary<object, List<crm_quote_item>> groupList = null;
        protected Dictionary<object, Dictionary<object, List<crm_quote_item>>> doubleGroupList = null;  // 按照两种分组的数据
        protected List<crm_quote_item> quoteItemList = null;    // 获取该报价下的所有报价项
        protected List<crm_quote> quoteList = null;             // 获取该商机下的所有报价
        protected string groupByType = "no";
        protected List<crm_quote_item> distributionList = null;    // 配送  配置项
        protected List<crm_quote_item> oneTimeList = null;         // 一次性配置项
        protected List<crm_quote_item> optionalItemList = null;    // 可选  配置项
        protected List<crm_quote_item> discountQIList = null;      // 计算出来的折扣数

        //  显示的内容
        // 1）  无选中：只在最后显示总税
        // 2)	选中第一个：按照周期分组时起作用，每个周期后显示税   最后的汇总也有税）
        // 3)	选中第二个：出现税的地方显示税的名称（税率），如果表头配置显示税，则显示税名
        // 4)	选中第三个：出现税的地方显示税的详细（税率），表头一样
        // 5)	选中第四个：显示上标

        protected Dictionary<string, object> dic = new QuoteItemBLL().GetField();  // 获取报价项相关字典项
        public string isShow = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // quote_group_by
                
                groupBy.DataTextField = "show";
                groupBy.DataValueField = "val";
                groupBy.DataSource = dic.FirstOrDefault(_ => _.Key == "quote_group_by").Value;
                groupBy.DataBind();
                

                isShow = Request.QueryString["isShow"];
                var quote_id = Request.QueryString["quote_id"];
                if (!string.IsNullOrEmpty(quote_id))
                {
                    quote = new QuoteBLL().GetQuote(Convert.ToInt64(quote_id));

                    if (quote.quote_tmpl_id != null)
                    {
                        var sys_quote_temp = new QuoteTemplateBLL().GetQuoteTemplate((long)quote.quote_tmpl_id);
                        // 获取到该报价的报价模板用于设置税的显示方式和汇总名称
                        show_each_tax_in_tax_group.Value =sys_quote_temp.show_each_tax_in_tax_group.ToString();
                        show_each_tax_in_tax_period.Value = sys_quote_temp.show_each_tax_in_tax_period.ToString(); // 选中第一个：按照周期分组时起作用，每个周期后显示税 最后的汇总也有税）
                        // var a3 =sys_quote_temp.show_labels_when_grouped;  // 预留字段
                        show_tax_cate.Value = sys_quote_temp.show_tax_cate.ToString();
                        show_tax_cate_superscript.Value = sys_quote_temp.show_tax_cate_superscript.ToString();
                    }

                }
                var opportunity_id = Request.QueryString["opportunity_id"];  // 这里是通过商机查看报价项的情况
                if (!string.IsNullOrEmpty(opportunity_id))
                {
                    var oppoQuoteList = new crm_quote_dal().GetQuoteByWhere($" and opportunity_id = {opportunity_id} ");
                    
                    if (oppoQuoteList != null && oppoQuoteList.Count > 0)
                    {
                        quote = oppoQuoteList.FirstOrDefault(_ => _.is_primary_quote == 1);  // 如果该商机下有报价则一定会有主报价
                    }
                }

               if (quote != null)
                {
                    quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id={quote.id} ");
                   // quoteItemList.Sort(SortCycle);  // 自定义排序测试
                   quoteItemList = quoteItemList.OrderBy(_ => SortQuoteItem(_.period_type_id)).ToList();
                    quoteList = new crm_quote_dal().GetQuoteByWhere($" and opportunity_id = {quote.opportunity_id} ");
                    var primaryQuote = quoteList.FirstOrDefault(_ => _.is_primary_quote == 1);
                    if (primaryQuote != null)
                    {
                        var thisQuoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id={primaryQuote.id} ");


                        var  thisDiscountQIList = thisQuoteItemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && _.optional == 0).ToList();
                        var thisOneTimeQTList = thisQuoteItemList.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME && _.optional == 0).ToList();
                        var thisOptionalItemList = thisQuoteItemList.Where(_ => _.optional == 1).ToList();

                        var totalPrice = ((decimal)((thisQuoteItemList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0) - thisDiscountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_ => (_.unit_discount != null && _.quantity != null) ? _.unit_discount * _.quantity : 0) - (thisOneTimeQTList != null && thisOneTimeQTList.Count > 0 ? thisDiscountQIList.Where(_ => _.discount_percent != null).ToList().Sum(_ => thisOneTimeQTList.Sum(one => (one.unit_discount != null && one.unit_price != null && one.quantity != null) ? (one.unit_price - one.unit_discount) * one.quantity : 0) * _.discount_percent) : 0)))).ToString("#0.00");
                        quoteList.Remove(primaryQuote);
                        primaryQuote.name = "PRIMARY:"+ primaryQuote.name+"("+totalPrice+")";
                        quoteList.Add(primaryQuote);
                    }
                   

                    #region // 为报价下拉框赋值
                    quoteDropList.DataValueField = "id";
                    quoteDropList.DataTextField = "name";
                    quoteDropList.DataSource = quoteList;
                    quoteDropList.DataBind();
                    quoteDropList.SelectedValue = quote.id.ToString();
                    #endregion
                    if (quoteItemList != null && quoteItemList.Count > 0)
                    {
                        // 用户需要添加折扣类型的报价项，然后可以针对付费周期类型为一次性的报价项进行折扣
                        // 折扣只针对一次性周期的报价项折扣
                        oneTimeList = quoteItemList.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME&&_.optional==0).ToList();

                        discountQIList = quoteItemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT&&_.optional==0).ToList();

                        //  获取到可选的报价项，
                        optionalItemList = quoteItemList.Where(_ => _.optional == 1).ToList();   // 获取到可选的报价项
                        // optionalItemList.Sort();
                        
                        // &&optionalItemList.Any(op=>op.id!=_.id)&&oneTimeList.Any(one=>one.id!=_.id)  满足多个报价项过滤条件的，选择其中的一个
                        distributionList = quoteItemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES&&_.optional==0).ToList();   // 配送类型的报价项

                        // 配送，一次性，可选的配置项独立显示，所以在这里分离出来，传到前台后单独处理

                        //  获取到筛选后报价项列表方便分组管理  筛选后的列表不包括可选，一次性的折扣和配送
                        var screenList = quoteItemList.Where(_ => _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.optional != 1&&_.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT).ToList();

                        if (!string.IsNullOrEmpty(Request.QueryString["group_by"]))
                        {
                            groupByType = Request.QueryString["group_by"];
                        }
                        else
                        {
                            if (quote.group_by_id != null)
                            {
                                groupByType = ((long)quote.group_by_id).ToString();
                            }
                            
                        }
                       //  groupByType = ?((long)quote.group_by_id).ToString():Request.QueryString["group_by"];
                        if (groupByType == ((int)EMT.DoneNOW.DTO.DicEnum.QUOTE_GROUP_BY.CYCLE).ToString())   // 按周期分组
                        {
                            groupList = screenList.GroupBy(_ => _.period_type_id == null ? "" : _.period_type_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());    // as Dictionary<long?, 
                            new QuoteBLL().UpdateGroup(quote.id, (int)QUOTE_GROUP_BY.CYCLE, GetLoginUserId());
                            groupBy.SelectedValue = ((int)QUOTE_GROUP_BY.CYCLE).ToString();
                        }
                        else if(groupByType == ((int)QUOTE_GROUP_BY.PRODUCT).ToString())  // 按产品分组
                        {
                            groupList = screenList.GroupBy(_ => _.object_id == null ? "" : _.object_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                            new QuoteBLL().UpdateGroup(quote.id, (int)QUOTE_GROUP_BY.PRODUCT, GetLoginUserId());
                            groupBy.SelectedValue = ((int)QUOTE_GROUP_BY.PRODUCT).ToString();
                        }
                        else if (groupByType == ((int)QUOTE_GROUP_BY.CYCLE_PRODUCT).ToString())   // 按周期产品分组
                        {
                            new QuoteBLL().UpdateGroup(quote.id, (int)QUOTE_GROUP_BY.CYCLE_PRODUCT, GetLoginUserId());
                            groupBy.SelectedValue = ((int)QUOTE_GROUP_BY.CYCLE_PRODUCT).ToString();
                            doubleGroupList = screenList.GroupBy(d => d.period_type_id == null ? "" : d.period_type_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList().GroupBy(d => d.object_id == null ? "" : d.object_id.ToString()).ToDictionary(d => (object)d.Key, d => d.ToList()));
                        }
                        else if (groupByType == ((int)QUOTE_GROUP_BY.PRODUCT_CYCLE).ToString()) // 按产品周期分组
                        {
                            new QuoteBLL().UpdateGroup(quote.id, (int)QUOTE_GROUP_BY.PRODUCT_CYCLE, GetLoginUserId());
                            groupBy.SelectedValue = ((int)QUOTE_GROUP_BY.PRODUCT_CYCLE).ToString();
                            doubleGroupList = screenList.GroupBy(_ => _.object_id == null ? "" : _.object_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList().GroupBy(d => d.period_type_id == null ? "" : d.period_type_id.ToString()).ToDictionary(d=>(object)d.Key,d=>d.ToList()));
                        }
                        else // 不分组
                        {
                            new QuoteBLL().UpdateGroup(quote.id, (int)QUOTE_GROUP_BY.NO, GetLoginUserId());
                            groupBy.SelectedValue = ((int)QUOTE_GROUP_BY.NO).ToString();
                        }
                        //switch (groupByType)
                        //{
                        //    case "cycle":
                        //        // 按照周期分组                             
                        //        break;
                        //    case "product":                            
                        //        break;
                        //    default:
                        //        groupByType = "no";
                        //        break;
                        //}
                        // ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script> $(\"#groupBy\").val('"+groupBy+"')</script>"); 
                    }

                }
                else
                {
                    Response.End();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
        
        private static int SortCycle(crm_quote_item item, crm_quote_item item2)
        {
            // 按照月、季度、半年、年、一次性 顺序
            if (item.period_type_id == (int)QUOTE_ITEM_PERIOD_TYPE.ONE_TIME|| item2.period_type_id == (int)QUOTE_ITEM_PERIOD_TYPE.ONE_TIME)
            {
                return 620;
            }else if (item.period_type_id == null|| item2.period_type_id == null)
            {
                return 599;
            }
            else
            {
                return (int)item.period_type_id;
            }            
        }
        /// <summary>
        /// 设定下报价项的排序规则
        /// </summary>
        /// <param name="period_type_id"></param>
        /// <returns></returns>
        private int SortQuoteItem(int? period_type_id)
        {
            if (period_type_id == null)
            {
                return 10;
            }
            else
            {
                return (int)new d_general_dal().FindSignleBySql<d_general>($"select * from d_general where id = {period_type_id} ").sort_order;
            }
        }
    }
}