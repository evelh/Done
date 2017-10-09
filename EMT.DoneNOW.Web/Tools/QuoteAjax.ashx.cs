using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// QuoteAjax 的摘要说明
    /// </summary>
    public class QuoteAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var quote_id = context.Request.QueryString["id"];
                        DeleteQuote(context, long.Parse(quote_id));
                        break;
                    case "deleteQuoteItem":
                        var quoteItemId = context.Request.QueryString["id"];
                        DeleteQuoteItem(context, long.Parse(quoteItemId));
                        break;
                    case "setPrimaryQuote":
                        var primary_quote_id = context.Request.QueryString["id"];
                        SetPrimaryQuote(context, long.Parse(primary_quote_id));
                        break;
                    case "isSaleOrder":
                        var relationQuoteId = context.Request.QueryString["id"];
                        IsRelationSaleOrder(context, long.Parse(relationQuoteId));
                        break;
                    case "costCode":
                        var cid = context.Request.QueryString["id"];
                        RetuenCostCode(context, long.Parse(cid));
                        break;
                    case "compareSetupFee":
                        var quoteId = context.Request.QueryString["quote_id"];
                        var contract_id = context.Request.QueryString["contract_id"];
                        CompareSetupFee(context, long.Parse(quoteId), long.Parse(contract_id));
                        break;
                    case "compareService":
                        var thisQuoteId = context.Request.QueryString["quote_id"];
                        var thisContractId = context.Request.QueryString["contract_id"];
                        CompareService(context,long.Parse(thisQuoteId),long.Parse(thisContractId));
                        break;
                    case "isHasStart":
                        var isHasStartQuoteId = context.Request.QueryString["quote_id"];
                        ReturnStart(context,long.Parse(isHasStartQuoteId));
                        break;
                    default:
                        break;
                }
            }
            catch (Exception e)
            {
                context.Response.Write(e.Message);
                context.Response.End();
            }
        }
        /// <summary>
        /// 删除报价
        /// </summary>
        /// <param name="context"></param>
        /// <param name="quote_id"></param>

        public void DeleteQuote(HttpContext context, long quote_id)
        {
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new QuoteBLL().DeleteQuote(quote_id, user.id);
                if (result)
                {
                    context.Response.Write("删除报价成功！");
                }
                else
                {
                    context.Response.Write("删除报价失败！");
                }
            }
        }

        public void DeleteQuoteItem(HttpContext context, long quote_item_id)
        {
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                var result = new QuoteItemBLL().DeleteQuoteItem(quote_item_id, user.id);
                if (result)
                {
                    context.Response.Write("删除报价项成功！");
                }
                else
                {
                    context.Response.Write("删除报价项失败！");
                }
            }
        }

        /// <summary>
        /// 设置成为主报价
        /// </summary>
        /// <param name="context"></param>
        /// <param name="quote_id"></param>
        public void SetPrimaryQuote(HttpContext context, long quote_id)
        {
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (user != null)
            {
                if (new QuoteBLL().SetPrimaryQuote(user.id, quote_id))
                {
                    context.Response.Write("设置主报价成功！");
                }
                else
                {
                    context.Response.Write("设置主报价失败！");
                }
            }

        }

        /// <summary>
        /// 是否关联销售订单
        /// </summary>
        /// <param name="context"></param>
        /// <param name="quote_id"></param>
        public void IsRelationSaleOrder(HttpContext context, long quote_id)
        {
            var result = new QuoteBLL().CheckRelatSaleOrder(quote_id);
            context.Response.Write(result);
        }
        /// <summary>
        /// 根据物料成本ID返回物料成本信息
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void RetuenCostCode(HttpContext context, long id)
        {
            var cost_code = new d_cost_code_dal().GetSingleCostCode(id);
            if (cost_code != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(cost_code));
            }
        }

        /// <summary>
        /// 判断报价是否包含初始费 并且 合同中是否也有初始费用
        /// </summary>
        /// <param name="context"></param>
        /// <param name="quote_id"></param>
        /// <param name="contract_id"></param>
        public void CompareSetupFee(HttpContext context, long quote_id, long contract_id)
        {
            var quote = new QuoteBLL().GetQuote(quote_id);
            var contract = new ctt_contract_dal().GetSingleContract(contract_id);
            bool isHasSetupFee = false;
            if (quote != null && contract != null)
            {
                var quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id = {quote.id}");
                if (quoteItemList != null && quoteItemList.Count > 0)
                {
                    var setupFeeItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.START_COST).ToList();
                    if (setupFeeItem != null && setupFeeItem.Count > 0 && contract.setup_fee != null)
                    {
                        isHasSetupFee = true;
                    }
                }
            }
            context.Response.Write(isHasSetupFee);
        }
        /// <summary>
        /// 判断报价和合同是否有重复的服务
        /// </summary>
        /// <param name="context"></param>
        /// <param name="quote_id"></param>
        /// <param name="contract_id"></param>
        public void CompareService(HttpContext context, long quote_id, long contract_id)
        {
            
            var quote = new QuoteBLL().GetQuote(quote_id);
            var conSerList = new ctt_contract_service_dal().GetConSerList(contract_id);
            bool isHasService = false;
            if (quote != null && conSerList != null && conSerList.Count>0)
            {
                var quoteItemList = new crm_quote_item_dal().GetQuoteItems($" and quote_id = {quote.id}");
                if (quoteItemList != null && quoteItemList.Count > 0)
                {
                    var serviceItem = quoteItemList.Where(_ => _.type_id == (int)QUOTE_ITEM_TYPE.SERVICE).ToList();
                    if(conSerList.Any(_=> serviceItem.Any(item => item.object_id == _.object_id)))
                    {
                        isHasService = true;
                    }
                }
            }

            context.Response.Write(isHasService);
        }
        /// <summary>
        /// 判断报价是否含有初始费用报价项，有返回，没有返回空
        /// </summary>
        public void ReturnStart(HttpContext context, long quote_id)
        {
            var thisQuoteItem = new crm_quote_item_dal().GetStartItem(quote_id);
            if (thisQuoteItem != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(thisQuoteItem));
            }
            else
            {

            }
        }


        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}