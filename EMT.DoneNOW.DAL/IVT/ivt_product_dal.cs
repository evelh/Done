using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.DAL
{
    public class ivt_product_dal : BaseDAL<ivt_product>
    {
        /// <summary>
        /// 获取到默认的产品（查看合同保存成本时配置项向导使用）
        /// </summary>
        /// <returns></returns>
        public ivt_product GetDefaultProduct()
        {
            return FindSignleBySql<ivt_product>($"select * from ivt_product where is_system = 1 and delete_time = 0");
        }

        // QuoteItemWareHouseDto
        /// <summary>
        /// 获取该产品相关库存信息
        /// </summary>
        public List<QuoteItemWareHouseDto> GetPageWareList(long project_id)
        {
            return FindListBySql<QuoteItemWareHouseDto>($"select w.warehouse_id as ware_id, p.name as productName,(select name from ivt_warehouse where id=w.warehouse_id) as wareName,w.quantity as onHand,ifnull((select sum(y.quantity) from ivt_order x, ivt_order_product y where y.delete_time = 0 and x.id = y.order_id and x.status_id in({(int)PURCHASE_ORDER_STATUS.SUBMITTED}, {(int)PURCHASE_ORDER_STATUS.RECEIVED_PARTIAL}) and y.product_id = w.product_id and y.warehouse_id = w.warehouse_id), 0) as onOrder,ifnull((select ifnull(sum(y.quantity), 0) - ifnull(sum(z.quantity_received), 0) from ivt_order x, ivt_order_product y, ivt_receive z where y.delete_time = 0 and z.delete_time = 0 and  x.status_id in({(int)PURCHASE_ORDER_STATUS.RECEIVED_PARTIAL}) and x.id = y.order_id and y.id = z.order_product_id and y.product_id = w.product_id  and y.warehouse_id = w.warehouse_id),0) as backOrder, ifnull((select sum(x.quantity) from ivt_reserve x, crm_quote_item y where x.delete_time = 0 and x.quote_item_id = y.id and x.warehouse_id = w.warehouse_id and y.object_id = w.product_id),0) +ifnull((select sum(x.quantity) from ctt_contract_cost_product x, ctt_contract_cost y where x.delete_time = 0 and x.status_id = {(int)CONTRACT_COST_PRODUCT_STATUS.PICKED} and x.contract_cost_id = y.id and x.warehouse_id = w.warehouse_id  and y.product_id = w.product_id),0) as picked,	w.quantity - ifnull((select sum(x.quantity) from ivt_reserve x, crm_quote_item y where x.delete_time = 0 and x.quote_item_id = y.id and x.warehouse_id = w.warehouse_id and y.object_id = w.product_id),0) -ifnull((select sum(x.quantity) from ctt_contract_cost_product x, ctt_contract_cost y where x.delete_time = 0 and x.status_id = {(int)CONTRACT_COST_PRODUCT_STATUS.PICKED} and x.contract_cost_id = y.id and x.warehouse_id = w.warehouse_id  and y.product_id = w.product_id),0)   as available from ivt_product p join ivt_warehouse_product w on p.id = w.product_id and w.delete_time = 0 where p.delete_time = 0 and p.id = {project_id}");
        }
        /// <summary>
        /// 根据产品信息获取相应的库存信息
        /// </summary>
        public List<QuoteItemWareHouseDto> GetCostWareNeed(long product_id)
        {
            return FindListBySql<QuoteItemWareHouseDto>($"select  a.id, b.product_id, a.ware_id, (select name from ivt_warehouse where id = a.warehouse_id)wareName,a.quantity as onHand,ifnull((select sum(x.quantity) from ivt_reserve x, crm_quote_item y where x.delete_time = 0 and x.quote_item_id = y.id and y.object_id = b.product_id and x.warehouse_id = a.warehouse_id),0) +ifnull((select sum(x.quantity) from ctt_contract_cost_product x, ctt_contract_cost y where x.delete_time = 0 and x.status_id = 2157 and x.contract_cost_id = y.id and y.product_id = b.product_id and x.warehouse_id = a.warehouse_id),0) as picked,a.quantity- ifnull((select sum(x.quantity) from ivt_reserve x, crm_quote_item y where x.delete_time = 0 and x.quote_item_id = y.id and y.object_id = b.product_id and x.warehouse_id = a.warehouse_id),0)-ifnull((select sum(x.quantity) from ctt_contract_cost_product x, ctt_contract_cost y where x.delete_time = 0 and x.status_id = 2157 and x.contract_cost_id = y.id and y.product_id = b.product_id and x.warehouse_id = a.warehouse_id),0)  as available from ctt_contract_cost b join ivt_warehouse_product a on b.product_id = a.product_id and a.delete_time = 0 where b.delete_time = 0    and b.quantity > (select sum(quantity) from ctt_contract_cost_product where delete_time = 0 and contract_cost_id = b.id) and b.product_id = 3");
        }

        /// <summary>
        /// 获取成本已经拣货的相关信息
        /// </summary>
        public List<QuoteItemWareHouseDto> GetCostWareNoNeed(long cost_id)
        {
            return FindListBySql<QuoteItemWareHouseDto>($"select a.id as cost_pro_id, a.warehouse_id as ware_id,a.quantity,(select name from ivt_warehouse where id=a.warehouse_id)wareName,(select GROUP_CONCAT(sn order by sn) from ctt_contract_cost_product_sn where contract_cost_product_id = a.id and delete_time = 0)sn,(select vendor_invoice_no from ivt_order where id = a.order_id)vendorNo,(select name from d_general where id = a.status_id)statusName,a.status_id as statusId from ctt_contract_cost_product a where a.contract_cost_id = {cost_id}  and a.delete_time = 0");
        }
    }
}
