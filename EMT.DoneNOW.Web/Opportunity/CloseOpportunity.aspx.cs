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
using EMT.DoneNOW.BLL.CRM;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web.Opportunity
{
    public partial class CloseOpportunity : BasePage
    {
        protected crm_opportunity opportunity = null;
        protected crm_quote primaryQuote = null;            // 改商机下的主报价，可以为null
        protected List<crm_quote_item> quoteItemList = null;     // 主报价下的所有报价项的集合
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    var id = Request.QueryString["id"];
                    opportunity = new crm_opportunity_dal().GetOpportunityById(long.Parse(id));
                    if (opportunity != null)
                    {
                        primaryQuote = new QuoteBLL().GetPrimaryQuote(opportunity.id);
                        if (primaryQuote != null)
                        {
                            if (primaryQuote.project_id != null) // 判断该报价是否关联项目提案，如果关联，默认选中，不关联，灰掉，不可选
                            {

                            }

                            quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id = {primaryQuote.id}");
                            if (quoteItemList != null && quoteItemList.Count > 0)
                            {
                                // 如果报价项中包含了服务 / 服务包、初始费用，则可以选中（默认不选）
                                // 此功能需要具有合同模块权限以及修改合同服务/包权限

                                var isServiceChargeItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE || _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE_PACK || _.type_id == (int)QUOTE_ITEM_TYPE.START_COST).ToList();
                                if (isServiceChargeItem != null && isServiceChargeItem.Count > 0)
                                {
                                    // 前台需要判断用户权限
                                }

                            }
                        }
                    }
                }
           
            }
            catch (Exception)
            {

                Response.End();
            }
        }
    }
}