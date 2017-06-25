using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Http.Filters;
using EMT.Tools;
using EMT.DoneNOW.DTO;
using System.Net.Http;
using System.Collections.Specialized;

namespace EMT.DoneNOW.WebAPI
{
    public class WebApiErrorHandleAttribute : ExceptionFilterAttribute
    {
        //重写基类的异常处理方法
        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            //1.异常日志记录
            var sb = new StringBuilder();
            sb.AppendLine("ExceptionType: " + actionExecutedContext.Exception.GetType().ToString());
            sb.AppendLine("Message: " + actionExecutedContext.Exception.Message);
            sb.AppendLine("Stack Trace: " + actionExecutedContext.Exception.StackTrace);
            Lgr.Error(sb);
            //返回自定义error信息
            if (actionExecutedContext.Response == null)
                actionExecutedContext.Response = new HttpResponseMessage(System.Net.HttpStatusCode.InternalServerError);
            actionExecutedContext.Response.Content = new StringContent(new Serialize().SerializeJson(new ApiResultDto() { code = (int)ERROR_CODE.ERROR, msg = actionExecutedContext.Exception.Message }));
        }

        private static string GetFormString(NameValueCollection form)
        {
            if (form == null || form.Count == 0) return string.Empty;
            StringBuilder sb = new StringBuilder();
            foreach (var key in form.AllKeys)
            {
                sb.AppendFormat("&{0}={1}", key, form[key]);
            }
            return sb.Remove(0, 1).ToString();
        }
    }
}