using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.SaleOrder
{
    public partial class SaleOrderView : BasePage
    {
        protected crm_sales_order sale_order = null;
        protected crm_opportunity opportunity = null;
        protected crm_account account = null;
        protected crm_contact contact = null;
        protected crm_quote quote = null;
        protected Dictionary<string, object> dic = new SaleOrderBLL().GetField();
        protected string type = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                // todo - 商机的重新指派

                var sid = Request.QueryString["id"];
                var type = Request.QueryString["type"];
                sale_order = new crm_sales_order_dal().GetSingleSale(long.Parse(sid));
                opportunity = new crm_opportunity_dal().GetOpportunityById(sale_order.opportunity_id);
                account = new CompanyBLL().GetCompany(opportunity.account_id);
                quote = new QuoteBLL().GetPrimaryQuote(opportunity.id);
                if (sale_order.contact_id != null)
                {
                    contact = new ContactBLL().GetContact((long)sale_order.contact_id);
                }
                switch (type)
                {
                    case "activity":
                        type = "活动";
                        isShowLeft.Value = "1";
                        break;
                    case "todo":
                        type = "待办";
                        isShowLeft.Value = "1";
                        break;
                    case "note":
                        type = "备注";
                        isShowLeft.Value = "1";
                        break;
                    case "ticket":
                        type = "工单";
                        break;
                    case "attachment":
                        type = "附件";
                        break;
                    case "entry":
                        type = "条目";
                        viewSaleOrder_iframe.Src = "../QuoteItem/QuoteItemManage.aspx?quote_id=" + quote.id;
                        break;
                    case "purchaseOrder":
                        type = "销售订单";
                        break;
                    default:
                        type = "活动";
                        isShowLeft.Value = "1";
                        break;
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}