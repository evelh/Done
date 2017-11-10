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
        protected string actType;
        protected string iframeSrc = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {

                // todo - 商机的重新指派

                var sid = Request.QueryString["id"];
                type = Request.QueryString["type"];
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
                        actType = "活动";
                        isShowLeft.Value = "1";
                        break;
                    case "todo":
                        actType = "待办";
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.TODOS + "&type=" + (int)QueryType.Todos + "&group=131&con676=" + sale_order.id;
                        isShowLeft.Value = "1";
                        break;
                    case "note":
                        actType = "备注";
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CRM_NOTE_SEARCH + "&type=" + (int)QueryType.CRMNote + "&group=129&con675=" + sale_order.id;
                        isShowLeft.Value = "1";
                        break;
                    case "ticket":
                        actType = "工单";
                        break;
                    case "attachment":
                        actType = "附件";
                        iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.SALES_ORDER_VIEW_ATTACHMENT + "&type=" + (int)QueryType.SalesOrderViewAttachment + "&con977=" + sale_order.id;
                        break;
                    case "entry":
                        actType = "报价项";
                        iframeSrc = "../QuoteItem/QuoteItemManage.aspx?isShow=1&quote_id=" + quote.id;
                        break;
                    case "purchaseOrder":
                        actType = "采购订单";
                        break;
                    default:
                        actType = "活动";
                        type = "activity";
                        isShowLeft.Value = "1";
                        break;
                }

                if (type.Equals("activity"))
                {
                    var typeList = new ActivityBLL().GetCRMActionType();
                    noteType.DataSource = typeList;
                    noteType.DataTextField = "name";
                    noteType.DataValueField = "id";
                    noteType.DataBind();
                }

            }
            catch (Exception)
            {
                Response.End();
            }
        }
    }
}