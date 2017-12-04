using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
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
    public class ContractAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            try
            {
                var action = context.Request.QueryString["act"];
                switch (action)
                {
                    case "deleteContract":
                        var contractId = context.Request.QueryString["id"];
                        DeleteContract(context, Convert.ToInt64(contractId));
                        break;
                    case "delete":
                        var cicid = context.Request.QueryString["cicid"];
                        DeleteConIntCost(context, Convert.ToInt64(cicid));
                        break;
                    case "RelieveIP":
                        var relieveCID = context.Request.QueryString["contract_id"];
                        var relieveIPID = context.Request.QueryString["InsProId"];
                        RelieveInsProduct(context, long.Parse(relieveCID), long.Parse(relieveIPID));
                        break;
                    case "RelationIP":
                        var relationCID = context.Request.QueryString["contract_id"];
                        var relationIPID = context.Request.QueryString["InsProId"];
                        var service_id = context.Request.QueryString["service_id"];
                        if (!string.IsNullOrEmpty(service_id))
                        {
                            RelationInsProduct(context, long.Parse(relationCID), long.Parse(relationIPID), long.Parse(service_id));
                        }
                        else
                        {
                            RelationInsProduct(context, long.Parse(relationCID), long.Parse(relationIPID));
                        }
                        break;
                    case "isService":
                        var isSerContractId = context.Request.QueryString["contract_id"];
                        isHasService(context, long.Parse(isSerContractId));
                        break;
                    case "property":
                        var proCID = context.Request.QueryString["contract_id"];
                        var propertyName = context.Request.QueryString["property"];
                        GetContractProperty(context, long.Parse(proCID), propertyName);
                        break;
                    case "updateCost":
                        var ccid = context.Request.QueryString["cost_id"];
                        var isbill = context.Request.QueryString["isbill"];
                        ChangeChargeIsBilled(context, long.Parse(ccid), int.Parse(isbill));
                        break;
                    case "updateCosts":
                        var ccids = context.Request.QueryString["ids"];
                        var isbills = context.Request.QueryString["isbill"];
                        ChangeManyChargeIsBilled(context, ccids, int.Parse(isbills));
                        break;
                    case "ChargeProperty":
                        var cost_id = context.Request.QueryString["cost_id"];
                        var costPropertyName = context.Request.QueryString["property"];
                        GetContractCostoProperty(context, long.Parse(cost_id), costPropertyName);
                        break;
                    case "GetContractCost":
                        var thisCID = context.Request.QueryString["cost_id"];
                        GetContractCost(context, long.Parse(thisCID));
                        break;
                    case "deleteCost":
                        var deleteCostId = context.Request.QueryString["cost_id"];
                        DeleteCost(context, long.Parse(deleteCostId));
                        break;
                    case "deleteCosts":
                        var deleteCostIds = context.Request.QueryString["ids"];
                        DeleteCosts(context, deleteCostIds);
                        break;
                    case "deleteDefaultCost":
                        var cdcID = context.Request.QueryString["cdcID"];
                        DeleteDefaultCost(context, long.Parse(cdcID));
                        break;
                    case "DeleteRate":
                        var rateId = context.Request.QueryString["rateId"];
                        DeleteContractRate(context, Convert.ToInt64(rateId));
                        break;
                    case "DeleteBlock":
                        var blockId = context.Request.QueryString["blockId"];
                        DeleteContractBlock(context, Convert.ToInt64(blockId));
                        break;
                    case "CanRenewContract":
                        contractId = context.Request.QueryString["id"];
                        IsServiceContract(context, Convert.ToInt64(contractId));
                        break;
                    case "AddService":
                        var serId = context.Request.QueryString["id"];
                        AddService(context, Convert.ToInt64(serId));
                        break;
                    case "AddServiceBundle":
                        var serBunId = context.Request.QueryString["id"];
                        AddServiceBundle(context, Convert.ToInt64(serBunId));
                        break;
                    case "GetDefaultCost":
                        var defCostConId = context.Request.QueryString["contract_id"];
                        GetDefaultCost(context, long.Parse(defCostConId));
                        break;
                    case "DeleteMilestone":
                        var milestoneId = context.Request.QueryString["milestoneId"];
                        DeleteMilestone(context, Convert.ToInt64(milestoneId));
                        break;
                    case "SetBlockActive":
                        blockId = context.Request.QueryString["blockId"];
                        SetBlockActive(context, Convert.ToInt64(blockId));
                        break;
                    case "SetBlockInactive":
                        blockId = context.Request.QueryString["blockId"];
                        SetBlockInactive(context, Convert.ToInt64(blockId));
                        break;
                    case "processAll":   // 处理全部条目
                        var thisAccDedIds = context.Request.QueryString["thisAccDedIds"];
                        var startDate = context.Request.QueryString["startDate"];
                        var endDate = context.Request.QueryString["endDate"];
                        var invTempId = context.Request.QueryString["invTempId"];
                        var invoiceDate = context.Request.QueryString["invoiceDate"];
                        var purNo = context.Request.QueryString["purNo"];
                        var notes = context.Request.QueryString["notes"];
                        var pay_term = context.Request.QueryString["pay_term"];
                        InvoiceDealDto param = new InvoiceDealDto()
                        {
                            invoice_template_id = int.Parse(invTempId),
                            invoice_date = DateTime.Parse(invoiceDate),
                            purchase_order_no = purNo,
                            notes = notes,
                            ids = thisAccDedIds,
                        };
                        if (!string.IsNullOrEmpty(startDate))
                        {
                            param.date_range_from = DateTime.Parse(startDate);
                        }
                        if (!string.IsNullOrEmpty(endDate))
                        {
                            param.date_range_to = DateTime.Parse(endDate);
                        }
                        if (!string.IsNullOrEmpty(pay_term))
                        {
                            param.payment_term_id = int.Parse(pay_term);
                        }
                        ProcessAll(context, param);
                        break;
                    case "GetService":
                        GetService(context);
                        break;
                    case "DeleteService":
                        string id = context.Request.QueryString["id"];
                        DeleteService(context, Convert.ToInt64(id));
                        break;
                    case "IsApprove":
                        id = context.Request.QueryString["id"];
                        IsServiceApproveAndPost(context, Convert.ToInt64(id));
                        break;
                    case "CalcServiceAdjustPercent":
                        CalcServiceAdjustPercent(context);
                        break;
                    case "ChecckCostCode":   // 校验物料代码是否在默认成本出现过
                        var ccccid = context.Request.QueryString["id"];
                        var cost_code_id = context.Request.QueryString["cost_code_id"];
                        ChecckCostCode(context, long.Parse(ccccid), long.Parse(cost_code_id));
                        break;
                    case "CheckResRole":
                        var crrcid = context.Request.QueryString["contract_id"];  // 合同Id
                        var crrrid = context.Request.QueryString["resource_id"];  // 员工Id
                        var crrRoleId = context.Request.QueryString["role_id"];   // 角色Id
                        CheckResRole(context, long.Parse(crrcid), long.Parse(crrrid), long.Parse(crrRoleId));
                        break;
                    case "GetSinCost":
                        var costId = context.Request.QueryString["cost_id"];
                        GetSinCost(context,long.Parse(costId));
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
        /// 删除合同
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void DeleteContract(HttpContext context, long id)
        {
            
            context.Response.Write(new ContractBLL().DeleteContract(id, LoginUserId));
        }

        /// <summary>
        /// 删除合同内部成本
        /// </summary>
        /// <param name="context"></param>
        /// <param name="cicId"></param>
        private void DeleteConIntCost(HttpContext context, long cicId)
        {
            context.Response.Write(new ContractBLL().DeleteConIntCost(cicId, LoginUserId));
        }

        /// <summary>
        /// 删除合同费率
        /// </summary>
        /// <param name="context"></param>
        /// <param name="rateId"></param>
        private void DeleteContractRate(HttpContext context, long rateId)
        {
            new ContractRateBLL().DeleteRate(rateId, LoginUserId);
            context.Response.Write(true);
        }

        /// <summary>
        /// 解除配置项与合同的绑定
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contract_id"></param>
        /// <param name="ipID"></param>
        private void RelieveInsProduct(HttpContext context, long contract_id, long ipID)
        {

            var result = new InstalledProductBLL().RelieveInsProduct(contract_id, ipID, LoginUserId);
            context.Response.Write(result);

        }
        /// <summary>
        /// 将配置项绑定到合同
        /// </summary>
        /// <param name="context"></param>
        /// <param name="contract_id"></param>
        /// <param name="ipID"></param>
        private void RelationInsProduct(HttpContext context, long contract_id, long ipID, long? service_id = null)
        {

            var result = new InstalledProductBLL().RelationInsProduct(contract_id, ipID, LoginUserId, service_id);
            context.Response.Write(result);

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
        public void ChangeChargeIsBilled(HttpContext context, long cid, int isBilled)
        {


            var result = new ContractCostBLL().UpdateBillStatus(cid, LoginUserId, isBilled);
            context.Response.Write(result);

        }
        /// <summary>
        /// 批量更该成本为是否可计费
        /// </summary>
        public void ChangeManyChargeIsBilled(HttpContext context, string ccids, int isBilled)
        {


            var result = new ContractCostBLL().UpdateManyBillStatus(ccids, LoginUserId, isBilled);
            context.Response.Write(result);

        }
        /// <summary>
        /// 获取到成本的属性
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void GetContractCostoProperty(HttpContext context, long id, string propertyName)
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


            var result = new ContractCostBLL().DeleteContractCost(cid, LoginUserId);
            context.Response.Write(result);

        }
        /// <summary>
        /// 批量删除合同成本
        /// </summary>
        public void DeleteCosts(HttpContext context, string ids)
        {

            var result = new ContractCostBLL().DeleteContractCosts(ids, LoginUserId);
            context.Response.Write(result);

        }
        /// <summary>
        /// 删除合同默认成本
        /// </summary>
        public void DeleteDefaultCost(HttpContext context, long cdcID)
        {

            bool result = false;


            result = new ContractCostBLL().DeleteConDefCost(cdcID, LoginUserId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 删除合同预付
        /// </summary>
        /// <param name="context"></param>
        /// <param name="blockId"></param>
        public void DeleteContractBlock(HttpContext context, long blockId)
        {

            bool result = false;


            result = new ContractBlockBLL().DeletePurchase(blockId, LoginUserId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 设置预付为激活状态
        /// </summary>
        /// <param name="context"></param>
        /// <param name="blockId"></param>
        public void SetBlockActive(HttpContext context, long blockId)
        {

            bool result = false;

            result = new ContractBlockBLL().SetBlockActive(blockId, LoginUserId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 设置预付为停用状态
        /// </summary>
        /// <param name="context"></param>
        /// <param name="blockId"></param>
        public void SetBlockInactive(HttpContext context, long blockId)
        {

            bool result = false;

            result = new ContractBlockBLL().SetBlockInactive(blockId, LoginUserId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 新增合同时添加服务
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void AddService(HttpContext context, long id)
        {
            var service = new ivt_service_dal().FindById(id);
            string txt = "";
            decimal pricePerMonth = 0;
            if (service != null)
            {
                // 获取供应商名称
                string vendorName = "";
                if (service.vendor_id != null)
                {
                    var vendorDal = new ivt_product_vendor_dal();
                    var accountDal = new crm_account_dal();
                    var vendor = vendorDal.FindById((long)service.vendor_id);
                    if (vendor.vendor_account_id != null)
                    {
                        vendorName = accountDal.FindById((long)vendor.vendor_account_id).name;
                    }
                }

                // 周期
                string period = "";
                if (service.period_type_id != null)
                {
                    period = new GeneralBLL().GetGeneralName((int)service.period_type_id);
                    if (service.unit_price == null)
                        pricePerMonth = 0;
                    else
                    {
                        if (service.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                            pricePerMonth = service.unit_price == null ? 0 : (decimal)service.unit_price;
                        if (service.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                            pricePerMonth = service.unit_price == null ? 0 : (decimal)service.unit_price / 3;
                        if (service.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                            pricePerMonth = service.unit_price == null ? 0 : (decimal)service.unit_price / 6;
                        if (service.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                            pricePerMonth = service.unit_price == null ? 0 : (decimal)service.unit_price / 12;
                    }
                }

                string unitCost = "";
                if (service.unit_cost != null)
                {
                    unitCost = "¥" + service.unit_cost.ToString();
                }

                txt += $"<tr id='service{service.id}'>";
                txt += $"<td style='white - space:nowrap; '><img src = '../Images/delete.png' onclick='RemoveService({service.id})' alt = '' /></ td > ";
                txt += $"<td><span>{service.name}</span></td>";
                txt += $"<td nowrap>{vendorName}</td>";
                txt += $"<td nowrap><span>{period}</span></td>";
                txt += $"<td nowrap align='right'><span>{unitCost}</span></td>";
                txt += $"<td nowrap align='right'><input type = 'text' onblur='CalcService()' id='price{service.id}' name='price{service.id}' value = '{pricePerMonth}' ></ td > ";
                txt += $"<td nowrap align='right'><input type = 'text' onblur='CalcService()' id='num{service.id}' name='num{service.id}' value = '1' ></ td > ";
                txt += $"<td nowrap align='right'>￥<input type = 'text' id='pricenum{service.id}' value = '{pricePerMonth}' disabled ></ td > ";
                txt += "</tr>";
            }

            List<object> result = new List<object>();
            result.Add(txt);
            result.Add(pricePerMonth);
            result.Add(service.id);

            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        /// <summary>
        /// 新增合同时添加服务包
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        public void AddServiceBundle(HttpContext context, long id)
        {
            var serBun = new ivt_service_bundle_dal().FindById(id);
            string txt = "";
            decimal pricePerMonth = 0;
            List<object> result = new List<object>();

            if (serBun == null)
            {
                result.Add(txt);
                result.Add(pricePerMonth);

                context.Response.Write(new Tools.Serialize().SerializeJson(result));
                return;
            }

            // 获取供应商名称
            string vendorName = "";
            if (serBun.vendor_id != null)
            {
                var vendorDal = new ivt_product_vendor_dal();
                var accountDal = new crm_account_dal();
                var vendor = vendorDal.FindById((long)serBun.vendor_id);
                if (vendor.vendor_account_id != null)
                {
                    vendorName = accountDal.FindById((long)vendor.vendor_account_id).name;
                }
            }

            // 周期
            string period = "";
            if (serBun.period_type_id != null)
            {
                period = new GeneralBLL().GetGeneralName((int)serBun.period_type_id);
                if (serBun.unit_price == null)
                    pricePerMonth = 0;
                else
                {
                    if (serBun.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH)
                        pricePerMonth = serBun.unit_price == null ? 0 : (decimal)serBun.unit_price;
                    if (serBun.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER)
                        pricePerMonth = serBun.unit_price == null ? 0 : (decimal)serBun.unit_price / 3;
                    if (serBun.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR)
                        pricePerMonth = serBun.unit_price == null ? 0 : (decimal)serBun.unit_price / 6;
                    if (serBun.period_type_id == (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR)
                        pricePerMonth = serBun.unit_price == null ? 0 : (decimal)serBun.unit_price / 12;
                }
            }

            string unitCost = "";
            if (serBun.unit_cost != null)
            {
                unitCost = "¥" + serBun.unit_cost.ToString();
            }

            txt += $"<tr id='service{serBun.id}'>";
            txt += $"<td style='white - space:nowrap; '><img src = '../Images/delete.png' onclick='RemoveServiceBundle({serBun.id})' alt = '' /></ td > ";
            txt += $"<td><span>{serBun.name}</span></td>";
            txt += $"<td nowrap>{vendorName}</td>";
            txt += $"<td nowrap><span>{period}</span></td>";
            txt += $"<td nowrap align='right'><span>{unitCost}</span></td>";
            txt += $"<td nowrap align='right'>" + $"<input type='text' onblur='CalcService()' id='price{serBun.id}' name='price{serBun.id}' value = '{pricePerMonth}' >" + "</ td > ";
            txt += $"<td nowrap align='right'>" + $"<input type='text' onblur='CalcService()' id='num{serBun.id}' name='num{serBun.id}' value = '1' >" + "</ td > ";
            txt += $"<td nowrap align='right'>￥" + $"<input type='text' id='pricenum{serBun.id}' value = '{pricePerMonth}' disabled >" + "</ td > ";
            txt += "</tr>";

            result.Add(txt);
            result.Add(pricePerMonth);
            result.Add(serBun.id);

            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }

        private void GetDefaultCost(HttpContext context, long contract_id)
        {
            var defCost = new ctt_contract_cost_default_dal().GetSinCostDef(contract_id);
            if (defCost != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(defCost));
            }
        }


        /// <summary>
        /// 删除合同里程碑
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void DeleteMilestone(HttpContext context, long id)
        {

            bool result = false;


            result = new ContractBLL().DeleteMilestone(id, LoginUserId);

            context.Response.Write(result);
        }

        private void ProcessAll(HttpContext context, InvoiceDealDto param)
        {

            bool result = false;


            result = new InvoiceBLL().ProcessInvoice(param, LoginUserId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 判断合同是否可以续约
        /// </summary>
        /// <param name="context"></param>
        /// <param name="id"></param>
        private void IsServiceContract(HttpContext context, long id)
        {
            ContractBLL bll = new ContractBLL();
            var contract = bll.GetContract(id);
            if (contract.type_id == (int)DicEnum.CONTRACT_TYPE.SERVICE)
            {
                var ctRenew = bll.GetRenewContract(id);
                if (ctRenew == null)
                    context.Response.Write(new Tools.Serialize().SerializeJson(0));
                else
                    context.Response.Write(new Tools.Serialize().SerializeJson(1));
            }
            else
                context.Response.Write(new Tools.Serialize().SerializeJson(2));
        }

        /// <summary>
        /// 获取服务/服务包信息
        /// </summary>
        /// <param name="context"></param>
        private void GetService(HttpContext context)
        {
            var bll = new ServiceBLL();
            var id = context.Request.QueryString["id"];
            var type = context.Request.QueryString["type"];
            if ("2".Equals(type))
            {
                var serviceBundle = bll.GetServiceBundleById(long.Parse(id));
                context.Response.Write(new Tools.Serialize().SerializeJson(serviceBundle));
            }
            else
            {
                var service = bll.GetServiceById(long.Parse(id));
                context.Response.Write(new Tools.Serialize().SerializeJson(service));
            }
        }

        /// <summary>
        /// 删除服务/服务包
        /// </summary>
        /// <param name="context"></param>
        /// <param name="serviceId"></param>
        private void DeleteService(HttpContext context, long serviceId)
        {

            bool result = false;

            result = new ContractServiceBLL().DeleteService(serviceId, LoginUserId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 判断服务/服务包是否已计费
        /// </summary>
        /// <param name="context"></param>
        /// <param name="serviceId"></param>
        private void IsServiceApproveAndPost(HttpContext context, long serviceId)
        {

            bool result = false;


            result = new ContractServiceBLL().IsServiceApproveAndPost(serviceId);

            context.Response.Write(result);
        }

        /// <summary>
        /// 根据生效时间计算生效时间开始的首周期所占整周期的天数百分比(保留4位小数)
        /// </summary>
        /// <param name="context"></param>
        private void CalcServiceAdjustPercent(HttpContext context)
        {
            long contractId = long.Parse(context.Request.QueryString["contractId"]);
            DateTime date = DateTime.Parse(context.Request.QueryString["date"]);
            var result = new Tools.Serialize().SerializeJson(new ContractServiceBLL().CalcServiceAdjustDatePercent(contractId, date));
            context.Response.Write(result);
        }

        private void ChecckCostCode(HttpContext context, long cid, long cost_code_id)
        {
            var contract = new ctt_contract_dal().FindNoDeleteById(cid);
            var result = false;
            if (contract != null)
            {
                var def_cha = new ctt_contract_cost_default_dal().GetSinCostDef(cid, cost_code_id);
                if (def_cha != null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(def_cha));
                }
            }

        }
        /// <summary>
        /// 用于添加内部成本时校验 合同-员工-角色 唯一性校验
        /// </summary>
        /// <param name="context"></param>
        /// <param name="cid">合同ID</param>
        /// <param name="rid">员工ID</param>
        /// <param name="role_id">角色ID</param>
        private void CheckResRole(HttpContext context, long cid, long rid, long role_id)
        {
            var int_cost = new ctt_contract_internal_cost_dal().GetCheckkSinIntCost(cid, rid, role_id);
            if (int_cost != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(int_cost));
            }

        }
        /// <summary>
        /// 获取单个的成本信息
        /// </summary>
        private void GetSinCost(HttpContext context,long cost_id)
        {
            var thisCost = new ctt_contract_cost_dal().FindNoDeleteById(cost_id);
            if (thisCost != null)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(thisCost));
            }
        }
    }
}