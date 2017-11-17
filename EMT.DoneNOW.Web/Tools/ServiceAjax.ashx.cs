using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ServiceAjax 的摘要说明
    /// </summary>
    public class ServiceAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "service":
                    var service_id = context.Request.QueryString["service_id"];
                    GetService(context,long.Parse(service_id));
                    break;// service_bundle
                case "service_bundle":
                    var service_bundle_id = context.Request.QueryString["service_bundle_id"];
                    GetServiceBundle(context,long.Parse(service_bundle_id));
                    break;
                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    break;
            }
        }
        /// <summary>
        /// 返回服务信息
        /// </summary>
        /// <param name="context"></param>
        /// <param name="service_id"></param>
        public void GetService(HttpContext context,long service_id)
        {
            var service = new ivt_service_dal().FindSignleBySql<ivt_service>($"select * from ivt_service where id= {service_id} ");
            if (service != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(service));
            }
        }
        /// <summary>
        /// 返回服务集信息
        /// </summary>
        /// <param name="context"></param>
        /// <param name="service_bundle_id"></param>
        public void GetServiceBundle(HttpContext context, long service_bundle_id)
        {
            var service_bundle = new ivt_service_dal().FindSignleBySql<ivt_service>($"select * from ivt_service_bundle where id= {service_bundle_id} ");
            if (service_bundle != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(service_bundle));
            }
        }
        
    }
}