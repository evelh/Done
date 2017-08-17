using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using EMT.DoneNOW.BLL.IVT;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.Web
{
    /// <summary>
    /// ProductAjax 的摘要说明
    /// </summary>
    public class ProductAjax : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
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
                    AddQuoteItemByProduct(context,ids,int.Parse(quote_id));
                    
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
        public void GetProduct(HttpContext context,long product_id)
        {
            var product = new ivt_product_dal().FindSignleBySql<ivt_product>($"select * from ivt_product where id= {product_id}");
            if (product != null)
            {
                context.Response.Write(new EMT.Tools.Serialize().SerializeJson(product));
            }
        }

        public void AddQuoteItemByProduct(HttpContext context,string ids,int quote_id)
        {
            var user = context.Session["dn_session_user_info"] as sys_user;
            if (!string.IsNullOrEmpty(ids))
            {
                var itemDal = new crm_quote_item_dal();
                var productIds = ids.Split(new Char[] { ','}, StringSplitOptions.RemoveEmptyEntries);
                foreach (var productId in productIds)
                {
                    var product = new ProductBLL().GetProduct(long.Parse(productId));
                    if (product != null)
                    {
                        crm_quote_item thisQuoteItem = new crm_quote_item() {
                            id = itemDal.GetNextIdCom(),
                            name = product.product_name,
                            type_id= (int)DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT,
                            object_id= product.id,
                            description = product.description,
                            unit_price = product.unit_price,
                            unit_cost = product.unit_cost,
                            quantity = 1,
                            quote_id = quote_id,
                            period_type_id = product.period_type_id,
                            create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            create_user_id = user.id,
                            update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            update_user_id = user.id,  
                        };
                        itemDal.Insert(thisQuoteItem);
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = user.name,
                            phone = user.mobile_phone == null ? "" : user.mobile_phone,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                            oper_object_id = thisQuoteItem.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.ADD,
                            oper_description = itemDal.AddValue(thisQuoteItem),
                            remark = "添加报价项",
                        });
                    }
                }
            }
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