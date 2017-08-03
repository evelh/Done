using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// QuoteAjax 的摘要说明
    /// </summary>
    public class QuoteAjax : IHttpHandler
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
                        DeleteQuote(context,long.Parse(quote_id));
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

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}