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
                    case "updateCost":
                        var ccid = context.Request.QueryString["cost_id"];
                        var isbill = context.Request.QueryString["isbill"];
                        ChangeChargeIsBilled(context,long.Parse(ccid),int.Parse(isbill));
                        break;
                    case "updateCosts":
                        var ccids = context.Request.QueryString["ids"];
                        var isbills = context.Request.QueryString["isbill"];
                        ChangeManyChargeIsBilled(context,ccids,int.Parse(isbills));
                        break;
                    case "ChargeProperty":
                        var cost_id = context.Request.QueryString["cost_id"];
                        var costPropertyName = context.Request.QueryString["property"];
                        GetContractCostoProperty(context,long.Parse(cost_id), costPropertyName);
                        break;
                    case "GetContractCost":
                        var thisCID = context.Request.QueryString["cost_id"];
                        GetContractCost(context,long.Parse(thisCID));
                        break;
                    case "deleteCost":
                        var deleteCostId = context.Request.QueryString["cost_id"];
                        DeleteCost(context,long.Parse(deleteCostId));
                        break;
                    case "deleteCosts":
                        var deleteCostIds = context.Request.QueryString["ids"];
                        DeleteCosts(context, deleteCostIds);
                        break;
                    case "deleteDefaultCost":
                        var cdcID = context.Request.QueryString["cdcID"];
                        DeleteDefaultCost(context,long.Parse(cdcID));
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
        /// <summary>
        /// 更该成本为是否可计费
        /// </summary>
        public void ChangeChargeIsBilled(HttpContext context,long cid,int isBilled)
        {
            var res = context.Session["dn_session_user_info"];
            if (res != null)
            {
               var user  = res as sys_user;
                var result = new ContractCostBLL().UpdateBillStatus(cid,user.id,isBilled);
                context.Response.Write(result);
            }
        }
        /// <summary>
        /// 批量更该成本为是否可计费
        /// </summary>
        public void ChangeManyChargeIsBilled(HttpContext context,string ccids,int isBilled)
        {
            var res = context.Session["dn_session_user_info"];
            if (res != null)
            {
                var user = res as sys_user;
                var result = new ContractCostBLL().UpdateManyBillStatus(ccids, user.id, isBilled);
                context.Response.Write(result);
            }
        }
        /// <summary>
        /// 获取到成本的属性
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void GetContractCostoProperty(HttpContext context,long id,string propertyName)
        {
            var cost = new ctt_contract_cost_dal().FindNoDeleteById(id);
            if (cost != null)
            {
                context.Response.Write(BaseDAL<ctt_contract>.GetObjectPropertyValue(cost, propertyName));
            }
        }
        /// <summary>
        /// 获取到合同成本信息
        /// </summary>
        public void GetContractCost(HttpContext context, long cid)
        {
            var conCost = new ctt_contract_cost_dal().FindNoDeleteById(cid);
            if (conCost != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(conCost));
            }
        }
        /// <summary>
        /// 删除合同成本
        /// </summary>
        public void DeleteCost(HttpContext context, long cid)
        {
            var res = context.Session["dn_session_user_info"];
            if (res != null)
            {
                var user = res as sys_user;
                var result = new ContractCostBLL().DeleteContractCost(cid, user.id);
                context.Response.Write(result);
            }
        }
        /// <summary>
        /// 批量删除合同成本
        /// </summary>
        public void DeleteCosts(HttpContext context,string ids)
        {
            var res = context.Session["dn_session_user_info"];
            if (res != null)
            {
                var user = res as sys_user;
                var result = new ContractCostBLL().DeleteContractCosts(ids, user.id);
                context.Response.Write(result);
            }
        }
        /// <summary>
        /// 删除合同默认成本
        /// </summary>
        public void DeleteDefaultCost(HttpContext context,long cdcID)
        {
            var res = context.Session["dn_session_user_info"];
            bool result = false;
            if (res != null)
            {
                var user = res as sys_user;
                result = new ContractCostBLL().DeleteConDefCost(cdcID, user.id);
            }
            context.Response.Write(result);
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