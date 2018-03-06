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
                    GetService(context, long.Parse(service_id));
                    break;// service_bundle
                case "service_bundle":
                    var service_bundle_id = context.Request.QueryString["service_bundle_id"];
                    GetServiceBundle(context, long.Parse(service_bundle_id));
                    break;
                case "GetSerList":
                    var conId = context.Request.QueryString["contract_id"];
                    GetSerList(context, long.Parse(conId));
                    break;
                case "GetServicesByIds":
                    GetServicesByIds(context);
                    break;
                case "GetServicePriceByIds":
                    GetServicePriceByIds(context);
                    break;
                case "GetServiceContractCount":
                    GetServiceContractCount(context);
                    break;
                case "DeleteService":
                    DeleteService(context);
                    break;
                case "ActiveService":
                    ActiveService(context);
                    break;
                case "GetServicesByIds":
                    GetServicesByIds(context);
                    break;
                case "GetServicePriceByIds":
                    GetServicePriceByIds(context);
                    break;
                case "GetServiceContractCount":
                    GetServiceContractCount(context);
                    break;
                case "DeleteService":
                    DeleteService(context);
                    break;
                case "ActiveService":
                    ActiveService(context);
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
        public void GetService(HttpContext context, long service_id)
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
        public void GetSerList(HttpContext context, long contract_id)
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
        /// <summary>
        /// 根据ID 集合获取相应的服务信息
        /// </summary>
        public void GetServicesByIds(HttpContext context)
        {
            var serviceIds = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(serviceIds))
            {
                var serList = new ivt_service_dal().GetServiceList($" and id in({serviceIds})");
                if (serList != null && serList.Count > 0)
                {
                    List<ServiceDto> serDtoList = new List<ServiceDto>();
                    var accBll = new CompanyBLL();
                    var dDal = new d_general_dal();
                    var dccDal = new d_cost_code_dal();
                    serList.ForEach(_ => {
                        var thisDto = new ServiceDto()
                        {
                            id = _.id,
                            name = _.name,
                            description = _.description,
                            unit_cost = (_.unit_cost ?? 0),
                            unit_price = (_.unit_price ?? 0),
                            cost_code_id = _.cost_code_id,
                            period_type_id = _.period_type_id,
                            vendor_id = _.vendor_account_id,
                        };
                        if (_.vendor_account_id != null)
                        {
                            var thisVendor = accBll.GetCompany((long)_.vendor_account_id);
                            if (thisVendor != null)
                                thisDto.vendor_name = thisVendor.name;
                        }
                        if (_.period_type_id != null)
                        {
                            var thisType = dDal.FindNoDeleteById((long)_.period_type_id);
                            if (thisType != null)
                                thisDto.period_type_name = thisType.name;
                        }
                        var thisCode = dccDal.FindNoDeleteById(_.cost_code_id);
                        if (thisCode != null)
                            thisDto.cost_code_name = thisCode.name;
                        serDtoList.Add(thisDto);

                    });

                    context.Response.Write(new EMT.Tools.Serialize().SerializeJson(serDtoList));
                }
            }
        }
        /// <summary>
        /// 根据ID 集合获取相应的服务 每月价格
        /// </summary>
        public void GetServicePriceByIds(HttpContext context)
        {
            decimal unit_price = 0;
            var serviceIds = context.Request.QueryString["ids"];
            if (!string.IsNullOrEmpty(serviceIds))
            {
                var serList = new ivt_service_dal().GetServiceList($" and id in({serviceIds})");
                if (serList != null && serList.Count > 0)
                {
                    serList.ForEach(_ => {
                        switch (_.period_type_id)
                        {
                            case (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME:
                            case (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                                unit_price += (_.unit_price ?? 0);
                                break;
                            case (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                                unit_price += ((_.unit_price ?? 0) / 3);
                                break;
                            case (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                                unit_price += ((_.unit_price ?? 0) / 6);
                                break;
                            case (int)DTO.DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                                unit_price += ((_.unit_price ?? 0) / 12);
                                break;
                            default:
                                break;
                        }
                    });
                }
            }
            context.Response.Write(unit_price.ToString("#0.0000"));
        }
        /// <summary>
        /// 获取到引用此合同的定期服务合同数量
        /// </summary>
        public void GetServiceContractCount(HttpContext context)
        {
            var count = 0;
            var serviceId = context.Request.QueryString["serivce_id"];
            if (!string.IsNullOrEmpty(serviceId))
            {
                var objCount = new ivt_service_bundle_dal().GetServiceContractCount(long.Parse(serviceId));
                if (objCount != null && !string.IsNullOrEmpty(objCount.ToString()))
                {
                    count = int.Parse(objCount.ToString());
                }
            }
            context.Response.Write(count);
        }
        /// <summary>
        /// 删除服务/服务包
        /// </summary>
        public void DeleteService(HttpContext context)
        {
            var result = true;
            var faileReason = "";
            var serId = context.Request.QueryString["service_id"];
            if (!string.IsNullOrEmpty(serId))
            {
                if (!string.IsNullOrEmpty(context.Request.QueryString["is_bundle"]))
                    result = new ServiceBLL().DeleteServiceBundle(long.Parse(serId), LoginUserId, ref faileReason);
                else
                    result = new ServiceBLL().DeleteService(long.Parse(serId), LoginUserId, ref faileReason);
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { result = result, reason = faileReason }));
        }
        /// <summary>
        /// 激活/停用 相关服务
        /// </summary>
        public void ActiveService(HttpContext context)
        {
            var result = false;
            string faileReason = "";
            var serviceId = context.Request.QueryString["service_id"];
            var isActive = !string.IsNullOrEmpty(context.Request.QueryString["is_active"]);
            if (!string.IsNullOrEmpty(serviceId))
            {
                if (!string.IsNullOrEmpty(context.Request.QueryString["is_bundle"]))
                    result = new ServiceBLL().ActiveServiceBundle(long.Parse(serviceId), isActive, LoginUserId, ref faileReason);
                else
                    result = new ServiceBLL().ActiveService(long.Parse(serviceId), isActive, LoginUserId, ref faileReason);
            }
            context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { result = result, reason = faileReason }));
        }

    }
    public class ServiceDto
    {
        public long id;
        public string name;
        public string description = "";
        public long? vendor_id;
        public string vendor_name = "";
        public long? period_type_id;
        public string period_type_name = "";
        public long cost_code_id;
        public string cost_code_name = "";
        public decimal unit_price;
        public decimal unit_cost;
    }
}