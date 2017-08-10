using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.BLL.CRM;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class ViewOpportunity :BasePage
    {
        protected crm_opportunity opportunity = null;
        protected Dictionary<string, object> dic = null;
        protected string type = "";
        protected crm_account account = null;
        protected crm_contact contact = null;
        protected LocationBLL locationBLL = new LocationBLL();
        protected CompanyBLL companyBll = new CompanyBLL();
        protected List<crm_quote> quoteList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var id = Request.QueryString["id"];

                opportunity = new crm_opportunity_dal().GetOpportunityByOtherId(Convert.ToInt64(id));
                type = Request.QueryString["type"];
             
                if (opportunity != null)
                {
                    dic = new OpportunityBLL().GetField();
                    quoteList = new crm_quote_dal().GetQuoteByOpportunityId(opportunity.id);
                    account = new CompanyBLL().GetCompany(opportunity.account_id);
                    if (opportunity.contact_id != null)
                    {
                        contact = new ContactBLL().GetContact((long)opportunity.contact_id);
                    }




                    switch (type)    // 根据传过来的不同的类型，为页面中的iframe控件选择不同的src
                    {

                        case "todo":
                            viewOpportunity_iframe.Src = "";  // 待办
                            break;
                        case "note":
                            viewOpportunity_iframe.Src = "";  // 备注
                            break;
                        case "activity":
                            viewOpportunity_iframe.Src = "";  // 活动
                            break;
                        default:
                            viewOpportunity_iframe.Src = "";  // 默认
                            type = "activity";
                            break;
                    }
                    if (type == "activity" || type == "note" || type == "todo")
                    {
                        isHide.Value = "show";
                    }
                }
                else
                {
                    Response.End();
                }
            }
            catch (Exception)
            {

                Response.End();
            }
        }
    }
}