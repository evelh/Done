using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

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
                        DeleteQuoteItem(context,long.Parse(quoteItemId));
                        break;
                    case "setPrimaryQuote":
                        var primary_quote_id = context.Request.QueryString["id"];
                        SetPrimaryQuote(context,long.Parse(primary_quote_id));
                        break;
                    case "isSaleOrder":
                        var relationQuoteId = context.Request.QueryString["id"];
                        IsRelationSaleOrder(context ,long.Parse(relationQuoteId));
                        break;
                    case "costCode":
                        var cid = context.Request.QueryString["id"];
                        RetuenCostCode(context,long.Parse(cid));
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
                if(new QuoteBLL().SetPrimaryQuote(user.id,quote_id))
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
                context.Response.Write(cost_code);
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