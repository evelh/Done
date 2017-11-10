using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
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
        protected string actType;
        protected string iframeSrc;
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
                            iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.TODOS + "&type=" + (int)QueryType.Todos + "&group=112&con659=" + opportunity.id;                              // 待办
                            actType = "待办";
                            break;                                                        
                        case "note":
                            iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.CRM_NOTE_SEARCH + "&type=" + (int)QueryType.CRMNote + "&group=110&con647=" +opportunity.id;                              // 备注
                            actType = "备注";
                            break;                                                        
                        case "activity":
                            iframeSrc = "";                              // 活动
                            actType = "活动";
                            break;
                        case "quoteItem":
                            var oppoQuoteList = new crm_quote_dal().GetQuoteByWhere($" and opportunity_id = {opportunity.id} ");

                            if (oppoQuoteList != null && oppoQuoteList.Count > 0)
                            {
                                iframeSrc = "../QuoteItem/QuoteItemManage?isShow=show&opportunity_id=" + opportunity.id;  // 报价项
                                isAddQuote.Value = "0";
                            }
                            else
                            {
                                isAddQuote.Value = "1";
                                //ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>if(confirm('商机尚未创建报价，需要现在创建吗?')){window.open('../Quote/QuoteAddAndUpdate.aspx?quote_opportunity_id=" + opportunity.id + "', '" + (int)EMT.DoneNOW.DTO.OpenWindow.QuoteAdd + "', 'left=200,top=200,width=960,height=750', false);}</script>");
                                //Response.Write("<script>debugger;</script>");
                            }

                            actType = "报价项";
                            break;
                        case "att":
                            iframeSrc = "../Common/SearchBodyFrame.aspx?cat=" + (int)DicEnum.QUERY_CATE.OPPORTUNITY_VIEW_ATTACHMENT + "&type=" + (int)QueryType.OpportunityViewAttachment + "&con976=" + opportunity.id;
                            actType = "附件";
                            break;
                        default:
                            iframeSrc = "";  // 默认
                            actType = "活动";
                            type = "activity";
                            break;
                    }
                    if (type == "activity" || type == "note" || type == "todo")
                    {
                        isHide.Value = "show";
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