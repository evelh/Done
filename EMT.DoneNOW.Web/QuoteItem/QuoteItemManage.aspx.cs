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
                       // object list = new object();
                        groupBy = Request.QueryString["group_by"];
                        switch (groupBy)
                        {
                            case "cycle":
                                // 按照周期分组
                                groupList = quoteItemList.GroupBy(_ => _.period_type_id).ToDictionary(_=>(object)_.Key, _=>_.ToList());    // as Dictionary<long?, 
                               
                                break;
                            case "product":
                                groupList = quoteItemList.GroupBy(_ => _.object_id==null?"": _.object_id.ToString()).ToDictionary(_ => (object)_.Key, _ => _.ToList());
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