using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.SessionState;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ContractAjax 的摘要说明
    /// </summary>
    public class ContractAjax : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "delete":
                        var cicid = context.Request.QueryString["cicid"];
                        DeleteConIntCost(context, Convert.ToInt64(cicid));
                        break;
                    case "RelieveIP":
                        var relieveCID = context.Request.QueryString["contract_id"];
                        var relieveIPID = context.Request.QueryString["InsProId"];
                        RelieveInsProduct(context,long.Parse(relieveCID),long.Parse(relieveIPID));
                        break;
                    case "RelationIP":
                        var relationCID = context.Request.QueryString["contract_id"];
                        var relationIPID = context.Request.QueryString["InsProId"];
                        var service_id = context.Request.QueryString["service_id"];
                        if (!string.IsNullOrEmpty(service_id))
                        {
                            RelationInsProduct(context,long.Parse(relationCID),long.Parse(relationIPID),long.Parse(service_id));
                        }
                        else
                        {
                            RelationInsProduct(context, long.Parse(relationCID), long.Parse(relationIPID));
                        }
                        break;
                    case "isService":
                        var isSerContractId= context.Request.QueryString["contract_id"];
                        isHasService(context,long.Parse(isSerContractId));
                        break;
                    case "property":
                        var proCID = context.Request.QueryString["contract_id"];
                        var propertyName = context.Request.QueryString["property"];
                        GetContractProperty(context,long.Parse(proCID),propertyName);
                        break;
                    case "DeleteRate":
                        var rateId = context.Request.QueryString["rateId"];
                        DeleteContractRate(context, Convert.ToInt64(rateId));
                        break;
                    default:
                        break;
                }

            }
            catch (Exception)
            {
                context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                
            }
        }
        /// <summary>
        /// 删除合同内部成本
        /// </summary>
        /// <param name="context"></param>
        /// <param name="cicId"></param>
        private void DeleteConIntCost(HttpContext context,long cicId)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                context.Response.Write(new ContractBLL().DeleteConIntCost(cicId,res.id));
            }

        }

        /// <summary>
        /// 删除合同费率
        /// </summary>
        /// <param name="context"></param>
        /// <param name="rateId"></param>
        private void DeleteContractRate(HttpContext context, long rateId)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            new ContractRateBLL().DeleteRate(rateId, res.id);
            context.Response.Write(true);
        }

        /// <summary>
        /// 解除配置项与合同的绑定
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contract_id"></param>
        /// <param name="ipID"></param>
        private void RelieveInsProduct(HttpContext context,long contract_id,long ipID)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new InstalledProductBLL().RelieveInsProduct(contract_id,ipID,res.id);
                context.Response.Write(result);
            }
        }
        /// <summary>
        /// 将配置项绑定到合同
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contract_id"></param>
        /// <param name="ipID"></param>
        private void RelationInsProduct(HttpContext context, long contract_id, long ipID,long? service_id = null)
        {
            var res = context.Session["dn_session_user_info"] as sys_user;
            if (res != null)
            {
                var result = new InstalledProductBLL().RelationInsProduct(contract_id, ipID, res.id,service_id);
                context.Response.Write(result);
            }
        }
        /// <summary>
        /// 获取到合同的相关属性
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contract_id"></param>
        /// <param name="propertyName"></param>
        private void GetContractProperty(HttpContext context, long contract_id, string propertyName)
        {
            var contract = new ctt_contract_dal().FindNoDeleteById(contract_id);
            if (contract != null)
            {
                context.Response.Write(BaseDAL<ctt_contract>.GetObjectPropertyValue(contract, propertyName));
            }
        }
        /// <summary>
        /// 判断当前合同是否有相关的服务/包，有的话返回，没有返回""
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contract_id"></param>
        public void isHasService(HttpContext context, long contract_id)
        {
            var isHas = "";
            var contract = new ctt_contract_dal().FindNoDeleteById(contract_id);
            if (contract != null)
            {
                var serviceList = new ctt_contract_service_dal().GetConSerList(contract.id);
                if (serviceList != null && serviceList.Count > 0)
                {
                    StringBuilder services = new StringBuilder("<option value='0'>     </option>");
                    var oppBLL = new OpportunityBLL();
                    foreach (var item in serviceList)
                    {
                        var name = oppBLL.ReturnServiceName(item.object_id);
                        services.Append("<option value='" + item.id + "'>" + name + "</option>");
                    }
                    context.Response.Write(services);
                    return;
                }
            }
            context.Response.Write(isHas);
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