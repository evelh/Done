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

namespace EMT.DoneNOW.Web.QuoteItem
{
    public partial class QuoteItemManage : BasePage
    {
        protected crm_quote quote = null;
        protected Dictionary<object, List<crm_quote_item>> groupList = null;
        protected List<crm_quote_item> quoteItemList = null;    // 获取该报价下的所有报价项
        protected List<crm_quote> quoteList = null;             // 获取该商机下的所有报价
        protected string groupBy = "no";
        protected List<crm_quote_item> distributionList = null;    // 配送  配置项
        protected List<crm_quote_item> oneTimeList = null;         // 一次性配置项
        protected List<crm_quote_item> optionalItemList = null;    // 可选  配置项
        protected List<crm_quote_item> discountQIList = null;      // 计算出来的折扣数

        public string isShow = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                isShow = Request.QueryString["isShow"];
                var quote_id = Request.QueryString["quote_id"];
                if (!string.IsNullOrEmpty(quote_id))
                {
                    quote = new QuoteBLL().GetQuote(Convert.ToInt64(quote_id));
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
                                                                                                 //  获取到一次性报价项
                        
                        // &&optionalItemList.Any(op=>op.id!=_.id)&&oneTimeList.Any(one=>one.id!=_.id)  满足多个报价项过滤条件的，选择其中的一个
                        distributionList = quoteItemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES&&_.optional==0).ToList();   // 配送类型的报价项

                        // 配送，一次性，可选的配置项独立显示，所以在这里分离出来，传到前台后单独处理

                        //  获取到筛选后报价项列表方便分组管理  筛选后的列表不包括可选，一次性的折扣和配送
                        var screenList = quoteItemList.Where(_ => _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.optional != 1&&_.type_id != (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISCOUNT).ToList();
                        groupBy = Request.QueryString["group_by"];
                        switch (groupBy)
                        {
                            case "cycle":
                                // 按照周期分组
                                groupList = screenList.GroupBy(_ => _.period_type_id == null ? "" : _.period_type_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());    // as Dictionary<long?, 

                                break;
                            case "product":
                                groupList = screenList.GroupBy(_ => _.object_id == null ? "" : _.object_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
                                break;
                            default:
                                groupBy = "no";
                                break;
                        }
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
    }
}