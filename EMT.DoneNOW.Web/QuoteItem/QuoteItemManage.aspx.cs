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
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var quote_id = Request.QueryString["quote_id"];
                quote = new QuoteBLL().GetQuote(Convert.ToInt64(quote_id));
                if (quote != null)
                {
                    quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id={quote.id} ");
                    quoteList = new crm_quote_dal().GetQuoteByWhere($" and opportunity_id = {quote.opportunity_id} ");


                    // 为报价下拉框赋值
                    quoteDropList.DataValueField = "id";
                    quoteDropList.DataTextField = "name";
                    quoteDropList.DataSource = quoteList;
                    quoteDropList.DataBind();
                    quoteDropList.SelectedValue = quote.id.ToString();

                    if(quoteItemList!=null&& quoteItemList.Count > 0)
                    {
                        optionalItemList = quoteItemList.Where(_ => _.optional == 1).ToList();   // 获取到可选的报价项
                        oneTimeList = quoteItemList.Where(_ => _.period_type_id == (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME).ToList();
                        distributionList = quoteItemList.Where(_ => _.type_id == (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES).ToList();   // 配送类型的报价项

                         // 配送，一次性，可选的配置项独立显示，所以在这里分离出来，传到前台后单独处理
                         //  获取到筛选后报价项列表方便分组管理
                        var screenList= quoteItemList.Where(_ => _.type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES && _.period_type_id != (int)EMT.DoneNOW.DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME && _.optional != 1).ToList();
                        groupBy = Request.QueryString["group_by"];
                        switch (groupBy)
                        {
                            case "cycle":
                                // 按照周期分组
                                groupList = screenList.GroupBy(_ => _.period_type_id).ToDictionary(_=>(object)_.Key, _=>_.ToList());    // as Dictionary<long?, 
                               
                                break;
                            case "product":
                                groupList = screenList.GroupBy(_ => _.object_id==null?"": _.object_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
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