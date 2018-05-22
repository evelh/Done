using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Web.SessionState;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ProductAjax 的摘要说明
    /// </summary>
    public class ProductAjax : BaseAjax
    {

        public override void AjaxProcess(HttpContext context)
        {
            var action = context.Request.QueryString["act"];
            switch (action)
            {
                case "product":
                    var product_id = context.Request.QueryString["product_id"];
                    GetProduct(context, long.Parse(product_id));
                    break;
                case "AddQuoteItems":
                    var ids = context.Request.QueryString["ids"];
                    var quote_id = context.Request.QueryString["quote_id"];
                    AddQuoteItemByProduct(context, ids, int.Parse(quote_id));
                    break;
                case "GetVendorInfo":
                    var vendor_product_id = context.Request.QueryString["product_id"];
                    GetVendorInfo(context, long.Parse(vendor_product_id));
                    break;
                case "ActivationIP":
                    var iProduct_id = context.Request.QueryString["iProduct_id"];
                    ActivationInstalledProduct(context, long.Parse(iProduct_id), true);
                    break;
                case "ActivationIPs":
                    var iProduct_ids = context.Request.QueryString["iProduct_ids"];
                    AvtiveManyIProduct(context, iProduct_ids, true);
                    break;
                case "NoActivationIP":
                    var NoiProduct_id = context.Request.QueryString["iProduct_id"];
                    ActivationInstalledProduct(context, long.Parse(NoiProduct_id), false);
                    break;
                case "NoActivationIPs":
                    var NoiProduct_ids = context.Request.QueryString["iProduct_ids"];
                    AvtiveManyIProduct(context, NoiProduct_ids, false);
                    break;
                case "deleteIP":
                    var delete_IProductId = context.Request.QueryString["iProduct_id"];
                    DeleteIProduct(context, long.Parse(delete_IProductId));
                    break;
                case "deleteIPs":
                    var delete_IProductIds = context.Request.QueryString["iProduct_ids"];
                    DeleteIProducts(context, delete_IProductIds);
                    break;
                case "property":
                    var property_account_id = context.Request.QueryString["iProduct_id"];
                    var propertyName = context.Request.QueryString["property"];
                    GetIProductProperty(context, long.Parse(property_account_id), propertyName);
                    break;
                case "costCode":
                    var cost_code_id = context.Request.QueryString["cost_code_id"];
                    GetCostCode(context, long.Parse(cost_code_id));
                    break;
                case "GetProData":
                    var product_data_id = context.Request.QueryString["product_id"];
                    GetProData(context, long.Parse(product_data_id));
                    break;
                case "DeleteProduct":
                    var delete_product_id = context.Request.QueryString["product_id"];
                    DeleteProduct(context, long.Parse(delete_product_id));
                    break;
                case "GetPageWare":
                    var pid = context.Request.QueryString["product_id"];
                    GetPageWare(context,long.Parse(pid));
                    break;
                case "GetSnListByIds":
                    var snIds = context.Request.QueryString["snIds"];
                    GetSnListByIds(context,snIds);
                    break;
                case "CheckProductStock":  // 检查产品的库存信息。是否需要显示显示拣货，或者其余信息
                      break;
                case "GetCostPickedInfo":   // 获取该产品的已拣货的相关信息
                    var pickCostId = context.Request.QueryString["cost_id"];
                    GetCostPicked(context,long.Parse(pickCostId));
                    break;
                case "GetWareSnByCostWare":
                    var gwscostProId = context.Request.QueryString["cost_pro_id"];
                    GetWareSnByCostWare(context,long.Parse(gwscostProId));
                    break;
                case "PickProduct":
                    var ppId = context.Request.QueryString["product_id"];
                    var ppWareId = context.Request.QueryString["ware_id"];
                    var pickNum = context.Request.QueryString["pickNum"];
                    var ppSerNumIds = context.Request.QueryString["serNumIds"];
                    var tranType = context.Request.QueryString["tranType"];
                    var ppCostId = context.Request.QueryString["cost_id"];
                    PickProduct(context,long.Parse(ppId),long.Parse(ppWareId),int.Parse(pickNum),ppSerNumIds,tranType,long.Parse(ppCostId));
                    break;
                case "UnPickProduct":
                    var uppPid = context.Request.QueryString["product_id"];
                    var uppWareId = context.Request.QueryString["ware_id"];
                    var uppPickNum = context.Request.QueryString["unPickNum"];
                    var uppSerSnIds = context.Request.QueryString["SerSnIds"];
                    var uppCostId = context.Request.QueryString["costId"];
                    var uppCostProId = context.Request.QueryString["costProId"];
                    UnPickProduct(context,long.Parse(uppPid),long.Parse(uppWareId),int.Parse(uppPickNum),uppSerSnIds,long.Parse(uppCostId),long.Parse(uppCostProId));
                    break;
                case "TransferPro":
                    var tpPid = context.Request.QueryString["product_id"];
                    var tpWareId = context.Request.QueryString["ware_id"];
                    var tpPickNum = context.Request.QueryString["tranNum"];
                    var tpSerSnIds = context.Request.QueryString["SerSnIds"];
                    var tpCostId = context.Request.QueryString["costId"];
                    var tpAccount = context.Request.QueryString["account_id"];
                    var tpLocation = context.Request.QueryString["location_id"];
                    var tpTranType = context.Request.QueryString["tranType"];
                    var tpCostProId = context.Request.QueryString["costProId"];
                    TransferPro(context,long.Parse(tpPid),long.Parse(tpWareId),int.Parse(tpPickNum),tpSerSnIds,tpTranType,long.Parse(tpCostId),long.Parse(tpAccount),long.Parse(tpLocation), long.Parse(tpCostProId));
                    break;
                case "ShipItem":
                    ShipItem(context);
                    break;
                case "UnShipItem":
                    UnShipItem(context);
                    break;
                case "DoneCostSale":
                    DoneCostSale(context);
                    break;
                case "GetProductCost":
                    var gpId = context.Request.QueryString["product_id"];
                    GetProductCost(context,long.Parse(gpId));
                    break;
                case "GetInsProInfo":
                    GetInsProInfo(context);
                    break;
                case "GetInsProDetail":
                    GetInsProDetail(context);
                    break;
                case "InsProSetAsParent":
                    InsProSetAsParent(context);
                    break;
                case "InsProCancelAsParent":
                    InsProCancelAsParent(context);
                    break;
                case "ReviewInsPro":    // 设置是否需要合同审核
                    ReviewInsPro(context);
                    break;
                default:
                    context.Response.Write("{\"code\": 1, \"msg\": \"参数错误！\"}");
                    break;
            }
        }

        /// <summary>
        /// 获取到产品的信息并返回  
        /// </summary>
        /// <param name="context"></param>
        /// <param name="product_id"></param>
        public void GetProduct(HttpContext context, long product_id)
        {
            var product = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id= {product_id}");
            if (product != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(product));
            }
        }

        /// <summary>
        /// 根据产品ID去获取到相对应的平均供应商成本和最高的供应商成本
        /// </summary>
        public void GetProData(HttpContext context, long product_id)
        {
            string sql = $"SELECT AVG(vendor_cost) as unit_cost,MAX(vendor_cost) as unit_price from ivt_product_vendor where product_id = {product_id}";
            var product = new ivt_product_dal().FindSignleBySql<ivt_product>(sql);
            if (product != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { avg = product.unit_cost, max = product.unit_price }));
            }
        }
        /// <summary>
        /// 批量新增产品相关报价项
        /// </summary>
        public void AddQuoteItemByProduct(HttpContext context, string ids, int quote_id)
        {

            if (!string.IsNullOrEmpty(ids))
            {
                var itemDal = new crm_quote_item_dal();
                var productIds = ids.Split(new Char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var productId in productIds)
                {
                    var product = new ProductBLL().GetProduct(long.Parse(productId));
                    if (product != null)
                    {
                        crm_quote_item thisQuoteItem = new crm_quote_item()
                        {
                            id = itemDal.GetNextIdCom(),
                            name = product.name,
                            type_id = (int)DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT,
                            object_id = product.id,
                            description = product.description,
                            unit_price = product.unit_price,
                            unit_cost = product.unit_cost,
                            unit_discount = 0,
                            quantity = 1,
                            quote_id = quote_id,
                            period_type_id = product.period_type_id,
                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            create_user_id = LoginUserId,
                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            update_user_id = LoginUserId,
                            optional = 0,

                        };
                        itemDal.Insert(thisQuoteItem);
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)LoginUserId,
                            name = LoginUser.name,
                            phone = LoginUser.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                            oper_object_id = thisQuoteItem.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.ADD,
                            oper_description = itemDal.AddValue(thisQuoteItem),
                            remark = "添加报价项",
                        });
                    }
                }
                context.Response.Write("true");
            }
            else
            {
                context.Response.Write("false");
            }
        }
        /// <summary>
        /// 获取供应商相关信息
        /// </summary>
        public void GetVendorInfo(HttpContext context, long product_id)
        {
            var vendor = new ivt_product_dal().FindSignleBySql<ivt_product>($"SELECT a.name as name,v.vendor_product_no as vendor_product_no from crm_account a INNER join ivt_product_vendor v on a.id = v.vendor_account_id where product_id={product_id}");
            if (vendor != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(new { name = vendor.name, vendor_product_no = vendor.vendor_product_no }));
            }

        }


        /// <summary>
        /// 激活当前的配置项
        /// </summary>
        /// <param name="context"></param>
        /// <param name="iProduct_id"></param>
        public void ActivationInstalledProduct(HttpContext context, long iProduct_id, bool isActive)
        {

            var result = new InstalledProductBLL().ActivationInstalledProduct(iProduct_id, LoginUserId, isActive);
            context.Response.Write(result);
        }

        /// <summary>
        /// 批量激活选择的配置项
        /// </summary>
        /// <param name="context"></param>
        /// <param name="ids"></param>
        public void AvtiveManyIProduct(HttpContext context, string ids, bool isActive)
        {

            var result = new InstalledProductBLL().AvtiveManyIProduct(ids, LoginUserId, isActive);
            if (result)
            {
                context.Response.Write("ok");
            }
            else
            {
                context.Response.Write("error");
            }
        }

        public void DeleteIProduct(HttpContext context, long iProduct_id)
        {

            var result = new InstalledProductBLL().DeleteIProduct(iProduct_id, LoginUserId);
            context.Response.Write(result);
        }
        public void DeleteIProducts(HttpContext context, string ids)
        {

            var result = new InstalledProductBLL().DeleteIProducts(ids, LoginUserId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 根据属性名称获取到该类的value
        /// </summary>
        /// <param name="context"></param>
        /// <param name="iProduct_id"></param>
        /// <param name="propertyName"></param>
        public void GetIProductProperty(HttpContext context, long iProduct_id, string propertyName)
        {
            var iProduct = new crm_installed_product_dal().GetInstalledProduct(iProduct_id);
            if (iProduct != null)
            {
                context.Response.Write(BaseDAL<Core.crm_account>.GetObjectPropertyValue(iProduct, propertyName));
            }
        }
        /// <summary>
        /// 返回单个的物料成本代码的信息
        /// </summary>
        /// <param name="context"></param>
        /// <param name="cost_code_id"></param>
        public void GetCostCode(HttpContext context, long cost_code_id)
        {
            var costCode = new d_cost_code_dal().GetSingleCostCode(cost_code_id);
            if (costCode != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(costCode));
            }
        }
        /// <summary>
        /// 通过产品id删除产品信息
        /// </summary>
        /// <param name="context"></param>
        /// <param name="product_id"></param>
        public void DeleteProduct(HttpContext context, long product_id)
        {

            string returnvalue = string.Empty;
            var result = new ProductBLL().DeleteProduct(product_id, LoginUserId, out returnvalue);
            if (result == DTO.ERROR_CODE.SUCCESS)
            {
                context.Response.Write("删除成功！");
            }
            else if (result == DTO.ERROR_CODE.EXIST)
            {
                context.Response.Write(returnvalue);
            }
            else
            {
                context.Response.Write("删除失败！");
            }


        }
        /// <summary>
        /// 根据产品Id获取相应的库存信息
        /// </summary>
        public void GetPageWare(HttpContext context, long product_id)
        {
            var wareList = new ivt_product_dal().GetPageWareList(product_id);
            if(wareList!=null&& wareList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(wareList));
            }
        }
        /// <summary>
        /// 获取成本已拣货的相关信息
        /// </summary>
        public void GetCostPicked(HttpContext context,long cost_id)
        {
            var pickedList = new ivt_product_dal().GetCostWareNoNeed(cost_id);
            if(pickedList!=null&& pickedList.Count > 0)
            {
                context.Response.Write(new Tools.Serialize().SerializeJson(pickedList));
            }
            
        }
        /// <summary>
        /// 根据成本Id 和仓库Id 获取相应的 仓库SN 信息
        /// </summary>
        public void GetWareSnByCostWare(HttpContext context,long cost_pro_id)
        {
            // cost_pro_id
            var thisCostPro = new ctt_contract_cost_product_dal().FindNoDeleteById(cost_pro_id);
            if (thisCostPro != null)
            {
                var snType = context.Request.QueryString["snType"];
                if (snType == "conPro")
                {
                    var thisSnlist = new ctt_contract_cost_product_sn_dal ().GetListByCostProId(thisCostPro.id);
                    if (thisSnlist != null && thisSnlist.Count > 0)
                    {
                        if (thisCostPro.quantity != thisSnlist.Count)
                        {
                            thisSnlist = thisSnlist.Take(thisCostPro.quantity).ToList();
                        }
                        context.Response.Write(new Tools.Serialize().SerializeJson(thisSnlist));
                    }
                }
                else
                {
                    var thisSnlist = new ivt_warehouse_product_sn_dal().GetListByCostProId(thisCostPro.id);
                    if (thisSnlist != null && thisSnlist.Count > 0)
                    {
                        if (thisCostPro.quantity != thisSnlist.Count)
                        {
                            thisSnlist = thisSnlist.Take(thisCostPro.quantity).ToList();
                        }
                        context.Response.Write(new Tools.Serialize().SerializeJson(thisSnlist));
                    }
                }

               
            }
        }

        /// <summary>
        /// 根据Id 回去相应的sn
        /// </summary>
        public void GetSnListByIds(HttpContext context, string ids)
        {
            if (!string.IsNullOrEmpty(ids))
            {
                var type = context.Request.QueryString["snType"];
                if (type == "conPro")
                {
                    var snList = new ctt_contract_cost_product_sn_dal().GetSnByIds(ids);
                    if (snList != null && snList.Count > 0)
                    {
                        context.Response.Write(new Tools.Serialize().SerializeJson(snList));
                    }
                }
                else
                {
                    var snList = new ivt_warehouse_product_sn_dal().GetSnByIds(ids);
                    if (snList != null && snList.Count > 0)
                    {
                        context.Response.Write(new Tools.Serialize().SerializeJson(snList));
                    }
                }
                
            }
            
        }
        /// <summary>
        /// 拣货操作
        /// </summary>
        /// <param name="context"></param>
        /// <param name="product_id">产品</param>
        /// <param name="ware_id">仓库</param>
        /// <param name="pickNum">拣货数量</param>
        /// <param name="serNumIds">序列号</param>
        /// <param name="tranType">库存转移方式</param>
        public void PickProduct(HttpContext context,long product_id,long ware_id,int pickNum,string serNumIds,string tranType,long cost_id)
        {
            // tranType  ---  wareHouse    toMe   toItem
            var ccBll = new ContractCostBLL();
            var result = ccBll.AddCostProduct(cost_id,product_id,ware_id,pickNum,tranType, serNumIds,LoginUserId);
            ccBll.ChangCostStatus(cost_id,LoginUserId);
            // 是否完成销售订单（返回页面进行处理）
            var isDoneOrder = false;
            
            new SaleOrderBLL().ChangeSaleOrderStatus(cost_id,LoginUserId,out isDoneOrder);
            if (tranType == "toMe")
            {
                result = ccBll.TransToMe(product_id,pickNum,ware_id,serNumIds,LoginUserId);
            }
            else if (tranType == "toItem")
            {
                result = ccBll.TranToItem(product_id, pickNum, ware_id, serNumIds,cost_id, LoginUserId);
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(new { result  = result ,reason= isDoneOrder }));
        }

        /// <summary>
        /// 取消拣货
        /// </summary>
        public void UnPickProduct(HttpContext context,long product_id,long ware_id,int unPickNum,string SerSnIds,long cost_id,long costProId)
        {
            var result = new ContractCostBLL().UnPick(cost_id,product_id,ware_id,unPickNum,SerSnIds,LoginUserId, costProId);
            context.Response.Write(result);
        }
        /// <summary>
        /// 库存转移
        /// </summary>
        /// <param name="context"></param>
        /// <param name="product_id"></param>
        /// <param name="ware_id"></param>
        /// <param name="transNum"></param>
        /// <param name="serSnIds"></param>
        /// <param name="transType"></param>
        /// <param name="cost_id"></param>
        /// <param name="account_id"></param>
        /// <param name="toLocaId"></param>
        public void TransferPro(HttpContext context,long product_id,long ware_id,int transNum,string serSnIds,string transType,long cost_id,long account_id,long toLocaId,long costProId)
        {
            var result = false;

            var ccBll = new ContractCostBLL();
            if (transType == "ToAccount")
            {
                result = ccBll.TransferToAccount(cost_id, product_id,ware_id,account_id, transNum, serSnIds,LoginUserId, costProId);
            }
            else if (transType == "ToMe")
            {
                // todo 库存数量未完全转移 未转移完成  
                result = ccBll.TransToMe(product_id, transNum, ware_id, serSnIds, LoginUserId);
            }
            else if (transType == "ToLocation")
            {
                result = ccBll.TransToLocation(product_id, transNum, ware_id, serSnIds,toLocaId, LoginUserId, cost_id, costProId);
            }
            context.Response.Write(result);
        }
        /// <summary>
        /// 配送产品
        /// </summary>
        private void ShipItem(HttpContext context)
        {
            var result = true;         // 配送结果
            var isDoneOrder = false;   // 是否完成销售订单
            try
            {
                
                #region  获取相关参数
                var costId = long.Parse(context.Request.QueryString["cost_id"]);
                var wareId = long.Parse(context.Request.QueryString["wareId"]);
                var productId = long.Parse(context.Request.QueryString["productId"]);
                var ShipNum = int.Parse(context.Request.QueryString["ShipNum"]);
                var shipSerIds = context.Request.QueryString["shipSerIds"];
                var ShipDate = DateTime.Parse(context.Request.QueryString["ShipDate"]);
                int? shipping_type_id = null;
                if (!string.IsNullOrEmpty(context.Request.QueryString["shipping_type_id"]))
                {
                    shipping_type_id = int.Parse(context.Request.QueryString["shipping_type_id"]);
                }
                long? ShipCostCodeId = null;
                if (!string.IsNullOrEmpty(context.Request.QueryString["ShipCostCodeId"]))
                {
                    ShipCostCodeId = long.Parse(context.Request.QueryString["ShipCostCodeId"]);
                }
                var shipping_reference_number = context.Request.QueryString["shipping_reference_number"];
                decimal? BillMoney = null;
                if (!string.IsNullOrEmpty(context.Request.QueryString["BillMoney"]))
                {
                    BillMoney = decimal.Parse(context.Request.QueryString["BillMoney"]);
                }
                decimal? BillCost = null;
                if (!string.IsNullOrEmpty(context.Request.QueryString["BillCost"]))
                {
                    BillCost = decimal.Parse(context.Request.QueryString["BillCost"]);
                }
                var costProId = long.Parse(context.Request.QueryString["costProId"]);
                #endregion
                var ccBll = new ContractCostBLL();
                result = ccBll.ShipItem(costId, productId, wareId, ShipNum, shipSerIds, ShipDate, shipping_type_id, shipping_reference_number,LoginUserId, costProId, ShipCostCodeId, BillMoney, BillCost);
                ccBll.ChangCostStatus(costId, LoginUserId);
                // 是否完成销售订单（返回页面进行处理）
               

                new SaleOrderBLL().ChangeSaleOrderStatus(costId, LoginUserId, out isDoneOrder);

            }
            catch (Exception)
            {
                result = false;
            }
            context.Response.Write(new Tools.Serialize().SerializeJson(new { result = result, reason = isDoneOrder }));
        }
        /// <summary>
        /// 取消配送
        /// </summary>
        private void UnShipItem(HttpContext context)
        {
            var thisCostId = context.Request.QueryString["costProId"];
            if (!string.IsNullOrEmpty(thisCostId))
            {
                var isDelete = true; // 配送成本是否删除
                var result = new ContractCostBLL().UnShipItem(long.Parse(thisCostId),LoginUserId,out isDelete);
               //  isDelete = false; 代表有运费成本 并且已经审核无法删除
                context.Response.Write(new Tools.Serialize().SerializeJson(new { result=result,reason= isDelete }));
            }
            
        }
        /// <summary>
        /// 通过成本完成销售订单
        /// </summary>
        /// <param name="context"></param>
        private void DoneCostSale(HttpContext context)
        {
            var result = true;
            var thisCostId = context.Request.QueryString["costId"];
            if (!string.IsNullOrEmpty(thisCostId))
            {
                result = new SaleOrderBLL().DoneSaleByCost(long.Parse(thisCostId),LoginUserId);
            }
            context.Response.Write(result);
        }
        /// <summary>
        /// 获取到产品的成本（根据系统设置，决定如何获取）
        /// </summary>
        private void GetProductCost(HttpContext context,long ipId)
        {
            var thisCost = new ProductBLL().GetProCost(ipId,LoginUserId);
            if (thisCost != null)
            {
                context.Response.Write(((decimal)thisCost).ToString("#0.00"));
            }
            
        }
        /// <summary>
        /// 获取到配置项信息
        /// </summary>
        private void GetInsProInfo(HttpContext context)
        {
            var insProId = context.Request.QueryString["insProId"];
            if (!string.IsNullOrEmpty(insProId))
            {
                var insPr = new crm_installed_product_dal().FindNoDeleteById(long.Parse(insProId));
                if (insPr != null)
                {
                    context.Response.Write(new Tools.Serialize().SerializeJson(insPr));
                }
            }
        }
        /// <summary>
        /// 获取配置项相关详情数据
        /// </summary>
        private void GetInsProDetail(HttpContext context)
        {
            var insProId = context.Request.QueryString["insProId"];
            if (!string.IsNullOrEmpty(insProId))
            {
                var insPr = new crm_installed_product_dal().FindNoDeleteById(long.Parse(insProId));
                if (insPr != null)
                {
                    string name = "";
                    string contactName = "";
                    string contactId = "";
                    string insTime = "";
                    string insUser = "";
                    string insWarnTime = "";  // 保修期
                    string vendorId = "";
                    string vendorName = "";
                    string insService = "";
                    int relateNum = 0;         // 相关配置项
                    var thisPro = new ivt_product_dal().FindNoDeleteById(insPr.product_id);
                    if (thisPro != null)
                    {
                        name = thisPro.name;
                    }
                    if (insPr.contact_id != null)
                    {
                        var contact = new crm_contact_dal().FindNoDeleteById((long)insPr.contact_id);
                        if (contact != null)
                        {
                            contactId = contact.id.ToString();
                            contactName = contact.name;
                        }
                    }
                    if (insPr.installed_resource_id != null)
                    {
                        var insRes = new sys_resource_dal().FindNoDeleteById((long)insPr.installed_resource_id);
                        if (insRes != null)
                        {
                            insUser = insRes.name;
                        }
                    }
                    if (insPr.vendor_account_id != null)
                    {
                        var thisVnedor = new CompanyBLL().GetCompany((long)insPr.vendor_account_id);
                        if (thisVnedor != null)
                        {
                            vendorId = thisVnedor.id.ToString();
                            vendorName = thisVnedor.name;
                        }
                    }
                    insTime = Tools.Date.DateHelper.ConvertStringToDateTime(insPr.create_time).ToString("yyyy-MM-dd");




                    context.Response.Write(new Tools.Serialize().SerializeJson(new {id=insPr.id,name=name, contactId= contactId, contactName = contactName, insTime = insTime, insUser = insUser, insWarnTime = insWarnTime, vendorId = vendorId, vendorName = vendorName, insService = insService, relateNum = relateNum }));
                }
            }
        }
        /// <summary>
        /// 设置为父配置项
        /// </summary>
        private void InsProSetAsParent(HttpContext context)
        {
            var insProId = context.Request.QueryString["insProId"];
            var insProParentId = context.Request.QueryString["insProParentId"];
            bool result = false;
            if (!string.IsNullOrEmpty(insProId) && !string.IsNullOrEmpty(insProParentId))
                result = new InstalledProductBLL().SetAsParent(long.Parse(insProId),long.Parse(insProParentId),LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 取消父配置项配置
        /// </summary>
        private void InsProCancelAsParent(HttpContext context)
        {
            var insProId = context.Request.QueryString["insProId"];
            
            bool result = false;
            if (!string.IsNullOrEmpty(insProId))
                result = new InstalledProductBLL().RemoveParent(long.Parse(insProId), LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
        /// <summary>
        /// 配置项是否需要合同审核
        /// </summary>
        private void ReviewInsPro(HttpContext context)
        {
            var insProId = context.Request.QueryString["insProId"];  // 需要变更的ID 的集合
            var isView = !string.IsNullOrEmpty(context.Request.QueryString["isView"]);
            bool result = false;
            if (!string.IsNullOrEmpty(insProId) )
                result = new InstalledProductBLL().ReviewInsPro(insProId, isView, LoginUserId);
            context.Response.Write(new Tools.Serialize().SerializeJson(result));
        }
    }
}