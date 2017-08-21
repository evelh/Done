using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Quote
{
    public partial class QuoteClose : BasePage
    {
        protected crm_quote quote = null;
        protected List<crm_quote_item> quoteItemList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var quote_id = Request.QueryString["id"];
                quote = new QuoteBLL().GetQuote(long.Parse(quote_id));
                quoteItemList = new crm_quote_item_dal().GetQuoteItems($"and quote_id = {quote.id}");
            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}