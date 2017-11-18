using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System.Text;
using EMT.DoneNOW.BLL;

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
                case "GetSerList":
                    var conId  = context.Request.QueryString["contract_id"];
                    GetSerList(context,long.Parse(conId));
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
        /// <summary>
        ///  根据合同Id获取相关信息，用横线隔开
        /// </summary>
        public void GetSerList(HttpContext context,long contract_id)
        {
            var contract = new ctt_contract_dal().FindNoDeleteById(contract_id);
            if (contract != null)
            {
                var serviceList = new ctt_contract_service_dal().GetConSerList(contract.id);
                if (serviceList != null && serviceList.Count > 0)
                {
                    StringBuilder services = new StringBuilder();
                    var oppBLL = new OpportunityBLL();

                    var serList = serviceList.Where(_ => _.object_type == 1).ToList();
                    var serBagList = serviceList.Where(_ => _.object_type == 2).ToList();
                    if (serList != null && serList.Count > 0)
                    {
                        foreach (var item in serList)
                        {
                            var name = oppBLL.ReturnServiceName(item.object_id);
                            services.Append("<option value='" + item.id + "'>" + name + "</option>");
                        }
                        if (serBagList != null && serBagList.Count > 0)
                        {
                            services.Append("<option>-------</option>");
                        }
                     
                    }
                    if (serBagList != null && serBagList.Count > 0)
                    {
                        foreach (var item in serBagList)
                        {
                            var name = oppBLL.ReturnServiceName(item.object_id);
                            services.Append("<option value='" + item.id + "'>" + name + "</option>");
                        }
                        
                    }



                    context.Response.Write(services);
                   
                }
            }
        }


    }
}