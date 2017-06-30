using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace EMT.DoneNOW.WebAPI
{
    public class ActionFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            //如果用户方位的Action带有AllowAnonymousAttribute，则不进行授权验证
            if (actionContext.ActionDescriptor.GetCustomAttributes<AllowAnonymousAttribute>().Any())
            {
                return;
            }
            var token = actionContext.Request.Headers.Where(h => h.Key.ToLower().Equals("token")).FirstOrDefault().Value;
            if (token != null)
            {
                string accessToken = token.First();
                if (accessToken != null && BLL.CachedInfoBLL.GetUserInfo(accessToken) != null)
                    return;
            }

            //如果验证不通过，则返回401错误，并且Body中写入错误原因
            actionContext.Response = actionContext.Request.CreateErrorResponse(HttpStatusCode.Unauthorized, new HttpError("Token 不正确"));
        }
    }
}