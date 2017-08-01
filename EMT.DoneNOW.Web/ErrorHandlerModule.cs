using System;
using System.Web;

namespace EMT.DoneNOW.Web
{
    public class ErrorHandlerModule : IHttpModule
    {
        /// <summary>
        /// 您将需要在网站的 Web.config 文件中配置此模块
        /// 并向 IIS 注册它，然后才能使用它。有关详细信息，
        /// 请参阅以下链接: https://go.microsoft.com/?linkid=8101007
        /// </summary>
        #region IHttpModule Members

        public void Dispose()
        {
            //此处放置清除代码。
        }

        public void Init(HttpApplication context)
        {
            // 下面是如何处理 LogRequest 事件并为其 
            // 提供自定义日志记录实现的示例
            //context.LogRequest += new EventHandler(OnLogRequest);
            context.Error += new EventHandler(ContextError);
        }

        #endregion

        public void OnLogRequest(Object source, EventArgs e)
        {
            //可以在此处放置自定义日志记录逻辑
        }

        public void ContextError(object sender, EventArgs e)
        {
            //此处处理异常
            HttpContext ctx = HttpContext.Current;
            HttpResponse response = ctx.Response;
            HttpRequest request = ctx.Request;

            //获取到HttpUnhandledException异常，这个异常包含一个实际出现的异常
            Exception ex = ctx.Server.GetLastError();
            //实际发生的异常
            Exception iex = ex.InnerException;

            response.Write("来自ErrorModule的错误处理<br />");
            response.Write(iex.Message);

            ctx.Server.ClearError();
        }
    }
}
