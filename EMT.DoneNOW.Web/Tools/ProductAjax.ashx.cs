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


    }
}