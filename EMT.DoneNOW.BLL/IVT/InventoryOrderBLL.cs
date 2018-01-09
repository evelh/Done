using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class InventoryOrderBLL
    {
        ivt_order_dal dal = new ivt_order_dal();
        ivt_order_product_dal pdtDal = new ivt_order_product_dal();

        /// <summary>
        /// 新增采购订单
        /// </summary>
        /// <param name="order"></param>
        /// <param name="items"></param>
        /// <param name="location"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddOrder(ivt_order order, List<PurchaseItemDto> items, crm_location location, long userId)
        {
            var lctDal = new crm_location_dal();
            if (order.ship_to_type_id == (int)DicEnum.INVENTORY_ORDER_SHIP_ADDRESS_TYPE.OTHER_ADDRESS)
            {
                location.id = lctDal.GetNextIdCom();
                location.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                location.create_user_id = userId;
                location.update_time = location.create_time;
                location.update_user_id = userId;
                location.is_default = 0;
                location.cate_id = (int)DicEnum.LOCATION_CATE.RECIEVE_ADDR;
                lctDal.Insert(location);
                order.location_id = location.id;
            }
            else
            {
                if (order.purchase_account_id == null)
                    return false;
                var lct = lctDal.GetLocationByAccountId((long)order.purchase_account_id);
                if (lct.address == location.address && lct.district_id == location.district_id
                    && ((string.IsNullOrEmpty(lct.additional_address) && string.IsNullOrEmpty(location.additional_address)) || (lct.additional_address == location.additional_address))
                    && ((string.IsNullOrEmpty(lct.postal_code) && string.IsNullOrEmpty(location.postal_code)) || (lct.postal_code == location.postal_code))
                    && ((string.IsNullOrEmpty(lct.location_label) && string.IsNullOrEmpty(location.location_label)) || (lct.location_label == location.location_label)))
                {
                    order.location_id = lct.id;
                }
                else
                {
                    location.id = lctDal.GetNextIdCom();
                    location.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    location.create_user_id = userId;
                    location.update_time = location.create_time;
                    location.update_user_id = userId;
                    location.is_default = 0;
                    location.cate_id = (int)DicEnum.LOCATION_CATE.RECIEVE_ADDR;
                    lctDal.Insert(location);
                    order.location_id = location.id;
                }
            }
            order.id = dal.GetNextIdCom();
            order.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            order.create_user_id = userId;
            order.update_time = order.create_time;
            order.update_user_id = userId;
            order.purchase_order_no = dal.GetNextId("seq_po_no");

            dal.Insert(order);
            OperLogBLL.OperLogAdd<ivt_order>(order, order.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ORDER, "新增采购订单");

            // 保存采购订单采购项
            var costDal = new ctt_contract_cost_dal();
            var costPdtDal = new ctt_contract_cost_product_dal();
            foreach (var item in items)
            {
                // 添加采购订单采购项
                ivt_order_product pdt = new ivt_order_product();
                pdt.id = pdtDal.GetNextIdCom();
                pdt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                pdt.create_user_id = userId;
                pdt.update_time = pdt.create_time;
                pdt.update_user_id = userId;
                pdt.order_id = order.id;
                pdt.product_id = item.product_id;
                pdt.warehouse_id = item.warehouse_id;
                pdt.was_auto_filled = (sbyte)item.was_auto_filled;
                pdt.quantity = item.quantity;
                pdt.note = item.note;
                pdt.unit_cost = item.unit_cost;
                pdt.has_been_exported = 0;
                pdt.contract_cost_id = item.costId;

                pdtDal.Insert(pdt);
                OperLogBLL.OperLogAdd<ivt_order_product>(pdt, pdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PURCHASE_ORDER_ITEM, "新增采购订单增加采购项");

                // 新增订单为提交，更新成本状态
                if (order.status_id == (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED && item.costId != null)
                {
                    var cost = costDal.FindById((long)item.costId);
                    if (cost.status_id == (int)DicEnum.COST_STATUS.PENDING_PURCHASE)
                    {
                        var costOld = costDal.FindById((long)item.costId);
                        cost.status_id = (int)DicEnum.COST_STATUS.IN_PURCHASING;
                        cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        cost.update_user_id = userId;
                        costDal.Update(cost);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");

                        ctt_contract_cost_product costPdt = new ctt_contract_cost_product();
                        costPdt.id = costPdtDal.GetNextIdCom();
                        costPdt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        costPdt.create_user_id = userId;
                        costPdt.update_time = costPdt.create_time;
                        costPdt.update_user_id = userId;
                        costPdt.contract_cost_id = cost.id;
                        costPdt.warehouse_id = item.warehouse_id;
                        costPdt.quantity = item.quantity;
                        costPdt.order_id = order.id;
                        costPdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER;
                        costPdtDal.Insert(costPdt);
                        OperLogBLL.OperLogAdd<ctt_contract_cost_product>(costPdt, costPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "提交采购订单添加成本产品");
                    }
                }

                string sql = $"select count(0) from ivt_product_vendor where vendor_account_id={order.vendor_account_id} and product_id={pdt.product_id} and delete_time=0";
                int cnt = pdtDal.FindSignleBySql<int>(sql);
                if (cnt==0)
                {
                    ivt_product_vendor pv = new ivt_product_vendor();
                    ivt_product_vendor_dal pvDal = new ivt_product_vendor_dal();
                    pv.id = pvDal.GetNextIdCom();
                    pv.product_id = pdt.product_id;
                    pv.vendor_account_id = order.vendor_account_id;
                    pv.is_default = 0;
                    pv.is_active = 1;
                    pv.vendor_cost = pdt.unit_cost;
                    pv.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    pv.create_user_id = userId;
                    pv.update_time = pv.create_time;
                    pv.update_user_id = userId;
                    pvDal.Insert(pv);
                }
            }

            return true;
        }

        /// <summary>
        /// 编辑采购订单
        /// </summary>
        /// <param name="orderEdit"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditOrder(ivt_order orderEdit, crm_location location, long userId)
        {
            ivt_order order = dal.FindById(orderEdit.id);
            ivt_order orderOld = dal.FindById(orderEdit.id);

            if (orderEdit.status_id == (int)DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_FULL
                || orderEdit.status_id == (int)DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_PARTIAL)
            {
                order.vendor_invoice_no = orderEdit.vendor_invoice_no;
                order.external_purchase_order_no = orderEdit.external_purchase_order_no;
                order.payment_term_id = orderEdit.payment_term_id;
                order.tax_region_id = orderEdit.tax_region_id;
                order.display_tax_cate = orderEdit.display_tax_cate;
                order.display_tax_seperate_line = orderEdit.display_tax_seperate_line;
                order.note = orderEdit.note;
                order.item_desc_display_type_id = orderEdit.item_desc_display_type_id;
                order.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                order.update_user_id = userId;
            }
            else
            {
                order.vendor_invoice_no = orderEdit.vendor_invoice_no;
                order.external_purchase_order_no = orderEdit.external_purchase_order_no;
                order.payment_term_id = orderEdit.payment_term_id;
                order.tax_region_id = orderEdit.tax_region_id;
                order.display_tax_cate = orderEdit.display_tax_cate;
                order.display_tax_seperate_line = orderEdit.display_tax_seperate_line;
                order.note = orderEdit.note;
                order.item_desc_display_type_id = orderEdit.item_desc_display_type_id;
                order.vendor_account_id = orderEdit.vendor_account_id;
                order.item_desc_display_type_id = orderEdit.item_desc_display_type_id;
                order.ship_to_type_id = orderEdit.ship_to_type_id;
                order.purchase_account_id = orderEdit.purchase_account_id;
                order.phone = orderEdit.phone;
                order.fax = orderEdit.fax;
                order.shipping_type_id = orderEdit.shipping_type_id;
                order.expected_ship_date = orderEdit.expected_ship_date;
                order.freight_cost = orderEdit.freight_cost;

                var lctDal = new crm_location_dal();
                var lct = lctDal.FindById(order.location_id);
                if (!(lct.address == location.address && lct.district_id == location.district_id
                    && ((string.IsNullOrEmpty(lct.additional_address) && string.IsNullOrEmpty(location.additional_address)) || (lct.additional_address == location.additional_address))
                    && ((string.IsNullOrEmpty(lct.postal_code) && string.IsNullOrEmpty(location.postal_code)) || (lct.postal_code == location.postal_code))
                    && ((string.IsNullOrEmpty(lct.location_label) && string.IsNullOrEmpty(location.location_label)) || (lct.location_label == location.location_label))))
                {
                    location.id = lctDal.GetNextIdCom();
                    location.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    location.create_user_id = userId;
                    location.update_time = location.create_time;
                    location.update_user_id = userId;
                    location.is_default = 0;
                    location.cate_id = (int)DicEnum.LOCATION_CATE.RECIEVE_ADDR;
                    lctDal.Insert(location);
                    order.location_id = location.id;
                }

                order.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                order.update_user_id = userId;

                // 提交订单，修改信息
                if (orderEdit.status_id == (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED
                    && order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED)
                {
                    order.submitted_resource_id = orderEdit.submitted_resource_id;
                    order.submit_time = orderEdit.submit_time;

                    // 修改成本状态
                    var odPdtList = pdtDal.FindListBySql($"select * from ivt_order_product where order_id={order.id} and contract_cost_id is not null and delete_time=0");
                    if (odPdtList != null && odPdtList.Count > 0)
                    {
                        ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
                        ctt_contract_cost_product_dal costPdtDal = new ctt_contract_cost_product_dal();
                        foreach (var pdt in odPdtList)
                        {
                            var cost = costDal.FindById((long)pdt.contract_cost_id);
                            if (cost.status_id != (int)DicEnum.COST_STATUS.PENDING_PURCHASE)
                                continue;
                            var costOld = costDal.FindById(cost.id);
                            cost.status_id = (int)DicEnum.COST_STATUS.IN_PURCHASING;
                            cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            cost.update_user_id = userId;
                            costDal.Update(cost);
                            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");

                            ctt_contract_cost_product costPdt = new ctt_contract_cost_product();
                            costPdt.id = costPdtDal.GetNextIdCom();
                            costPdt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            costPdt.create_user_id = userId;
                            costPdt.update_time = costPdt.create_time;
                            costPdt.update_user_id = userId;
                            costPdt.contract_cost_id = cost.id;
                            costPdt.warehouse_id = pdt.warehouse_id;
                            costPdt.quantity = pdt.quantity;
                            costPdt.order_id = order.id;
                            costPdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER;
                            costPdtDal.Insert(costPdt);
                            OperLogBLL.OperLogAdd<ctt_contract_cost_product>(costPdt, costPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "新增成本产品");
                        }
                    }
                }
            }

            var desc = OperLogBLL.CompareValue<ivt_order>(orderOld, order);
            if (string.IsNullOrEmpty(desc))
                return true;

            dal.Update(order);
            OperLogBLL.OperLogUpdate(desc, order.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ORDER, "编辑采购订单");

            return true;
        }

        /// <summary>
        /// 采购订单提交
        /// </summary>
        /// <param name="orderId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool SubmitOrder(long orderId,long userId)
        {
            ivt_order order = dal.FindById(orderId);

            if (order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.NEW && order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.CANCELED)
                return false;

            ivt_order orderOld = dal.FindById(orderId);

            order.status_id = (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED;
            order.submitted_resource_id = userId;
            order.submit_time = Tools.Date.DateHelper.ToUniversalTimeStamp();

            dal.Update(order);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ivt_order>(orderOld, order), order.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ORDER, "采购订单提交");

            // 修改成本状态
            var odPdtList = pdtDal.FindListBySql($"select * from ivt_order_product where order_id={orderId} and contract_cost_id is not null and delete_time=0");
            if (odPdtList != null && odPdtList.Count > 0)
            {
                ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
                ctt_contract_cost_product_dal costPdtDal = new ctt_contract_cost_product_dal();
                foreach (var pdt in odPdtList)
                {
                    var cost = costDal.FindById((long)pdt.contract_cost_id);
                    if (cost.status_id != (int)DicEnum.COST_STATUS.PENDING_PURCHASE)
                        continue;
                    var costOld = costDal.FindById(cost.id);
                    cost.status_id = (int)DicEnum.COST_STATUS.IN_PURCHASING;
                    cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    cost.update_user_id = userId;
                    costDal.Update(cost);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");

                    ctt_contract_cost_product costPdt = new ctt_contract_cost_product();
                    costPdt.id = costPdtDal.GetNextIdCom();
                    costPdt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    costPdt.create_user_id = userId;
                    costPdt.update_time = costPdt.create_time;
                    costPdt.update_user_id = userId;
                    costPdt.contract_cost_id = cost.id;
                    costPdt.warehouse_id = pdt.warehouse_id;
                    costPdt.quantity = pdt.quantity;
                    costPdt.order_id = order.id;
                    costPdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER;
                    costPdtDal.Insert(costPdt);
                    OperLogBLL.OperLogAdd<ctt_contract_cost_product>(costPdt, costPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "新增成本产品");
                }
            }

            return true;
        }

        /// <summary>
        /// 取消采购订单
        /// </summary>
        /// <param name="orderId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool CancleOrder(long orderId, long userId)
        {
            ivt_order order = dal.FindById(orderId);

            if (order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.NEW && order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED)
                return false;

            ivt_order orderOld = dal.FindById(orderId);

            order.status_id = (int)DicEnum.PURCHASE_ORDER_STATUS.CANCELED;
            order.submitted_resource_id = userId;
            order.submit_time = Tools.Date.DateHelper.ToUniversalTimeStamp();

            dal.Update(order);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ivt_order>(orderOld, order), order.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ORDER, "采购订单取消");

            // 修改成本状态
            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
            ctt_contract_cost_product_dal costPdtDal = new ctt_contract_cost_product_dal();
            var orderPdts = GetPurchaseItemsByOrderId(order.id);
            foreach (var orderPdt in orderPdts)
            {
                if (orderPdt.contract_cost_id == null)
                    continue;

                var cost = costDal.FindById((long)orderPdt.contract_cost_id);
                if (cost.status_id == (int)DicEnum.COST_STATUS.IN_PURCHASING)
                {
                    var costOld = costDal.FindById(cost.id);
                    cost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
                    cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    cost.update_user_id = userId;
                    costDal.Update(cost);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "取消采购订单修改成本状态");
                }
                var costPdts = costPdtDal.FindListBySql($"select * from ctt_contract_cost_product where contract_cost_id={cost.id} and order_id={order.id} and delete_time=0");
                foreach (var pdt in costPdts)
                {
                    if (pdt.status_id != (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.NEW)
                    {
                        var pdtOld = costPdtDal.FindById(pdt.id);
                        pdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.NEW;
                        pdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        pdt.update_user_id = userId;
                        costPdtDal.Update(pdt);
                        OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(pdtOld, pdt), pdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "取消采购订单修改成本产品状态");
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// 删除采购订单
        /// </summary>
        /// <param name="orderId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteOrder(long orderId, long userId)
        {
            ivt_order order = dal.FindById(orderId);

            if (order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.NEW && order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED && order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.CANCELED)
                return false;
            
            order.delete_user_id = userId;
            order.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();

            dal.Update(order);
            OperLogBLL.OperLogDelete<ivt_order>(order, order.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ORDER, "删除采购订单");

            
            // 删除采购项，修改成本状态
            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
            ctt_contract_cost_product_dal costPdtDal = new ctt_contract_cost_product_dal();
            var orderPdts = GetPurchaseItemsByOrderId(order.id);
            foreach (var orderPdt in orderPdts)
            {
                orderPdt.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                orderPdt.delete_user_id = userId;
                pdtDal.Update(orderPdt);
                OperLogBLL.OperLogDelete<ivt_order_product>(orderPdt, orderPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "删除采购订单删除采购项");

                if (orderPdt.contract_cost_id == null)
                    continue;

                var cost = costDal.FindById((long)orderPdt.contract_cost_id);
                if (cost.status_id == (int)DicEnum.COST_STATUS.IN_PURCHASING)
                {
                    var costOld = costDal.FindById(cost.id);
                    cost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
                    cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    cost.update_user_id = userId;
                    costDal.Update(cost);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "删除采购订单修改成本状态");
                }
                var costPdts = costPdtDal.FindListBySql($"select * from ctt_contract_cost_product where contract_cost_id={cost.id} and order_id={order.id} and delete_time=0");
                foreach (var pdt in costPdts)
                {
                    pdt.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    pdt.delete_user_id = userId;
                    costPdtDal.Update(pdt);
                    OperLogBLL.OperLogDelete<ctt_contract_cost_product>(pdt, pdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "删除采购订单删除成本产品");
                }
            }

            return true;
        }

        /// <summary>
        /// 获取采购订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_order GetPurchaseOrder(long id)
        {
            return dal.FindById(id);
        }

        /// <summary>
        /// 根据采购项id列表获取采购项
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public List<ivt_order_product> GetPurchaseItems(string ids)
        {
            return pdtDal.FindListBySql($"select * from ivt_order_product where id in ({ids})");
        }

        /// <summary>
        /// 获取采购订单关联的采购项
        /// </summary>
        /// <param name="orderId"></param>
        /// <returns></returns>
        public List<ivt_order_product> GetPurchaseItemsByOrderId(long orderId)
        {
            return pdtDal.FindListBySql($"select * from ivt_order_product where order_id={orderId} and delete_time=0");
        }

        /// <summary>
        /// 获取采购订单产品
        /// </summary>
        /// <param name="productId"></param>
        /// <returns></returns>
        public ivt_order_product GetOrderProduct(long productId)
        {
            return new ivt_order_product_dal().FindById(productId);
        }

        /// <summary>
        /// 新增采购项
        /// </summary>
        /// <param name="item"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddOrderItem(ivt_order_product item, long userId)
        {
            ivt_order_product pdt = new ivt_order_product();
            pdt.id = pdtDal.GetNextIdCom();
            pdt.order_id = item.order_id;
            pdt.product_id = item.product_id;
            pdt.warehouse_id = item.warehouse_id;
            pdt.quantity = item.quantity;
            pdt.unit_cost = item.unit_cost;
            pdt.was_auto_filled = item.was_auto_filled;
            pdt.has_been_exported = 0;
            pdt.note = "";
            pdt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            pdt.create_user_id = userId;
            pdt.update_time = pdt.create_time;
            pdt.update_user_id = userId;

            pdtDal.Insert(pdt);
            OperLogBLL.OperLogAdd<ivt_order_product>(pdt, pdt.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.PURCHASE_ORDER_ITEM, "新增采购项");
            return true;
        }

        /// <summary>
        /// 编辑采购项
        /// </summary>
        /// <param name="item"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditOrderItem(ivt_order_product item, long userId)
        {
            ivt_order_product pdt = pdtDal.FindById(item.id);
            ivt_order_product pdtOld = pdtDal.FindById(item.id);
            pdt.product_id = item.product_id;
            pdt.warehouse_id = item.warehouse_id;
            pdt.quantity = item.quantity;
            pdt.unit_cost = item.unit_cost;
            pdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            pdt.update_user_id = userId;

            string desc = OperLogBLL.CompareValue<ivt_order_product>(pdtOld, pdt);
            if (string.IsNullOrEmpty(desc))
                return true;
            pdtDal.Update(pdt);
            OperLogBLL.OperLogUpdate(desc, pdt.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.PURCHASE_ORDER_ITEM, "编辑采购项");
            return true;
        }

        /// <summary>
        /// 删除采购项
        /// </summary>
        /// <param name="itemId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteOrderItem(long itemId, long userId)
        {
            ivt_order_product item = pdtDal.FindById(itemId);
            if (item == null)
                return false;

            // 新建和已提交状态的采购项才可以删除
            ivt_order order = dal.FindById(item.order_id);
            if (order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.NEW && order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED)
                return false;

            item.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            item.delete_user_id = userId;
            pdtDal.Update(item);
            OperLogBLL.OperLogDelete<ivt_order_product>(item, item.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "删除采购项");

            if (item.contract_cost_id != null)
            {
                var costDal = new ctt_contract_cost_dal();
                var costPdtDal = new ctt_contract_cost_product_dal();
                var cost = costDal.FindById((long)item.contract_cost_id);
                if (cost.status_id == (int)DicEnum.COST_STATUS.IN_PURCHASING)
                {
                    var costOld = costDal.FindById(cost.id);
                    cost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
                    cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    cost.update_user_id = userId;
                    costDal.Update(cost);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "删除采购项修改成本状态");

                    var pdts = costPdtDal.FindListBySql($"select * from ctt_contract_cost_product where contract_cost_id={cost.id} and warehouse_id={item.warehouse_id} and order_id={item.order_id} and delete_time=0");
                    if (pdts != null && pdts.Count > 0)
                    {
                        foreach (var pdt in pdts)
                        {
                            if (pdt.status_id != (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.NEW)
                            {
                                var pdtOld = costPdtDal.FindById(pdt.id);
                                pdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.NEW;
                                pdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                pdt.update_user_id = userId;
                                costPdtDal.Update(pdt);
                                OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(pdtOld, pdt), pdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "删除采购项修改成本产品状态");
                            }
                        }
                    }
                }
                
            }
            return true;
        }

        /// <summary>
        /// 采购订单接收
        /// </summary>
        /// <param name="orderId"></param>
        /// <param name="vendor_invoice_no"></param>
        /// <param name="freight_cost"></param>
        /// <param name="items"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool OrderReceive(long orderId, string vendor_invoice_no, decimal freight_cost, List<InventoryOrderReceiveItemDto> items, long userId)
        {
            bool haveAllReceive = false;
            bool haveUnReceive = false;
            bool havePartReceive = false;

            ivt_receive_dal recvDal = new ivt_receive_dal();
            ivt_receive_sn_dal recvSnDal = new ivt_receive_sn_dal();
            ivt_warehouse_product_dal lctPdtDal = new ivt_warehouse_product_dal();
            ivt_warehouse_product_sn_dal lctPdtSnDal = new ivt_warehouse_product_sn_dal();
            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
            ctt_contract_cost_product_dal costPdtDal = new ctt_contract_cost_product_dal();
            ctt_contract_cost_product_sn_dal costPdtSnDal = new ctt_contract_cost_product_sn_dal();
            InventoryProductBLL ivtPdtBll = new InventoryProductBLL();
            foreach (var item in items)
            {
                ivt_order_product orderPdt = dal.FindSignleBySql<ivt_order_product>($"select * from ivt_order_product where id={item.id}");
                int recvedCnt = ivtPdtBll.GetReceivedCnt(item.id);

                // 判断采购产品全部接收还是部分接收
                if (!havePartReceive)
                {
                    if ((orderPdt.quantity - recvedCnt - item.count > 0) && (recvedCnt + item.count > 0))     // 部分接收
                        havePartReceive = true;
                    else if (recvedCnt + item.count > 0)
                        haveAllReceive = true;
                    else
                        haveUnReceive = true;
                }

                // 保存采购接收
                ivt_receive recv = new ivt_receive();
                recv.id = recvDal.GetNextIdCom();
                recv.order_product_id = item.id;
                recv.quantity_received = item.count;
                recv.quantity_backordered = orderPdt.quantity - recvedCnt - item.count;
                recv.has_been_exported = 0;
                recv.unit_cost = item.cost;
                recv.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                recv.create_user_id = userId;
                recv.update_time = recv.create_time;
                recv.update_user_id = userId;
                recvDal.Insert(recv);
                OperLogBLL.OperLogAdd<ivt_receive>(recv, recv.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PURCHASE_RECEIVE, "新增采购接收");

                // 修改库存仓库库存数量
                var lctPdt = lctPdtDal.FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where warehouse_id={orderPdt.warehouse_id} and product_id={orderPdt.product_id} and delete_time=0");
                if (lctPdt == null)
                {
                    lctPdt = new ivt_warehouse_product();
                    lctPdt.id = lctPdtDal.GetNextIdCom();
                    lctPdt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    lctPdt.create_user_id = userId;
                    lctPdt.update_time = lctPdt.create_time;
                    lctPdt.update_user_id = userId;
                    lctPdt.warehouse_id = orderPdt.warehouse_id;
                    lctPdt.product_id = orderPdt.product_id;
                    lctPdt.quantity = item.count;
                    lctPdt.quantity_minimum = 0;
                    lctPdt.quantity_maximum = item.count;
                    lctPdtDal.Insert(lctPdt);
                    OperLogBLL.OperLogAdd<ivt_warehouse_product>(lctPdt, lctPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "新增仓库产品");
                }
                else
                {
                    ivt_warehouse_product pdtOld = lctPdtDal.FindById(lctPdt.id);
                    lctPdt.quantity = lctPdt.quantity + item.count;
                    lctPdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    lctPdt.update_user_id = userId;
                    lctPdtDal.Update(lctPdt);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ivt_warehouse_product>(pdtOld, lctPdt), lctPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "修改仓库产品数量");
                }

                // 采购项关联成本，修改关联成本
                if (orderPdt.contract_cost_id != null)
                {
                    if (item.count > 0)     // 接收
                    {
                        var costPdt = costPdtDal.FindSignleBySql<ctt_contract_cost_product>($"select * from ctt_contract_cost_product where contract_cost_id={orderPdt.contract_cost_id} and order_id={orderId} and warehouse_id={orderPdt.warehouse_id} and status_id={(int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER} and delete_time=0");
                        var costPdtOld = costPdtDal.FindById(costPdt.id);
                        if (costPdt.quantity == item.count)     // 全部接收
                        {
                            costPdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION;
                            costPdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            costPdt.update_user_id = userId;
                            costPdtDal.Update(costPdt);
                            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(costPdtOld, costPdt), costPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "采购接收修改成本产品状态");

                        }
                        else    // 部分接收
                        {
                            costPdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION;
                            costPdt.quantity = item.count;
                            costPdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            costPdt.update_user_id = userId;
                            costPdtDal.Update(costPdt);
                            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(costPdtOld, costPdt), costPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "采购接收修改成本产品状态");

                            costPdtOld.id = costPdtDal.GetNextIdCom();
                            costPdtOld.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER;
                            costPdtOld.quantity = costPdtOld.quantity - item.count;
                            costPdtOld.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            costPdtOld.create_user_id = userId;
                            costPdtOld.update_time = costPdtOld.create_time;
                            costPdtOld.update_user_id = userId;
                            costPdtDal.Insert(costPdtOld);
                            OperLogBLL.OperLogAdd<ctt_contract_cost_product>(costPdtOld, costPdtOld.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "采购部分接收新增成本产品");
                        }

                        // 判断成本状态
                        var cost = costDal.FindById((long)orderPdt.contract_cost_id);
                        int unReceiveCnt = costPdtDal.FindSignleBySql<int>($"select count(0) from ctt_contract_cost_product where contract_cost_id={orderPdt.contract_cost_id} and status_id={(int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER} and delete_time=0");
                        if (unReceiveCnt == 0)  // 该成本关联的成本产品全部接收
                        {
                            var costOld = costDal.FindById(cost.id);
                            cost.status_id = (int)DicEnum.COST_STATUS.PENDING_DELIVERY;
                            cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            cost.update_user_id = userId;
                            costDal.Update(cost);
                            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");
                        }
                        else if (cost.status_id == (int)DicEnum.COST_STATUS.PENDING_PURCHASE)
                        {
                            var costOld = costDal.FindById(cost.id);
                            cost.status_id = (int)DicEnum.COST_STATUS.IN_PURCHASING;
                            cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            cost.update_user_id = userId;
                            costDal.Update(cost);
                            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");
                        }

                        // 新增成本产品串号
                        if (item.sns.Count != 0)
                        {
                            foreach (var sn in item.sns)
                            {
                                ctt_contract_cost_product_sn pdtsn = new ctt_contract_cost_product_sn();
                                pdtsn.id = costPdtSnDal.GetNextIdCom();
                                pdtsn.sn = sn;
                                pdtsn.contract_cost_product_id = costPdt.id;
                                pdtsn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                pdtsn.create_user_id = userId;
                                pdtsn.update_time = pdtsn.create_time;
                                pdtsn.update_user_id = userId;
                                costPdtSnDal.Insert(pdtsn);
                                OperLogBLL.OperLogAdd<ctt_contract_cost_product_sn>(pdtsn, pdtsn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT_SN, "接收采购订单新增成本产品串号");
                            }
                        }
                    }
                    else    // 取消接收
                    {
                        // 采购中成本产品
                        var costPdtPurchasing = costPdtDal.FindSignleBySql<ctt_contract_cost_product>($"select * from ctt_contract_cost_product where contract_cost_id={orderPdt.contract_cost_id} and order_id={orderId} and warehouse_id={orderPdt.warehouse_id} and status_id={(int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER} and delete_time=0");
                        // 待配送成本产品
                        var costPdts = costPdtDal.FindListBySql($"select * from ctt_contract_cost_product where contract_cost_id={orderPdt.contract_cost_id} and order_id={orderId} and warehouse_id={orderPdt.warehouse_id} and status_id={(int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION} and delete_time=0 order by create_time asc");

                        int remainder = 0 - item.count; // 剩余需要被取消的个数

                        // 接收串号sn的id
                        string ids = "";
                        if (item.sns.Count != 0)
                        {
                            foreach (var rsnid in item.sns)
                            {
                                ids += rsnid + ",";
                            }
                            ids = ids.Remove(ids.Length - 1, 1);
                        }

                        foreach (var costPdt in costPdts)
                        {
                            if (remainder == 0)
                                break;
                            if (costPdt.quantity > remainder)   // 当前待配送成本产品个数
                            {
                                var costPdtOld = costPdtDal.FindById(costPdt.id);
                                costPdt.quantity = costPdt.quantity - remainder;
                                costPdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                costPdt.update_user_id = userId;
                                costPdtDal.Update(costPdt);
                                OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(costPdtOld, costPdt), costPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "采购接收取消配送修改成本产品");

                                remainder = 0;
                            }
                            else
                            {
                                costPdt.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                                costPdt.delete_user_id = userId;
                                costPdtDal.Update(costPdt);
                                OperLogBLL.OperLogDelete<ctt_contract_cost_product>(costPdt, costPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "采购接收取消配送删除成本产品");
                                remainder = remainder - costPdt.quantity;
                            }
                            // 删除串号
                            if (item.sns.Count != 0)
                            {
                                costPdtSnDal.ExecuteSQL($"update ctt_contract_cost_product_sn set delete_time='{Tools.Date.DateHelper.ToUniversalTimeStamp()}',delete_user_id={userId} where contract_cost_product_id={costPdt.id} and sn in(select sn from ivt_receive_sn where id in({ids}))");
                            }

                        }
                        if (costPdtPurchasing == null)
                        {
                            costPdtPurchasing = new ctt_contract_cost_product();
                            costPdtPurchasing.id = costPdtDal.GetNextIdCom();
                            costPdtPurchasing.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            costPdtPurchasing.create_user_id = userId;
                            costPdtPurchasing.update_time = costPdtPurchasing.create_time;
                            costPdtPurchasing.update_user_id = userId;
                            costPdtPurchasing.quantity = 0 - item.count;
                            costPdtPurchasing.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER;
                            costPdtPurchasing.contract_cost_id = (long)orderPdt.contract_cost_id;
                            costPdtPurchasing.order_id = orderId;
                            costPdtPurchasing.warehouse_id = orderPdt.warehouse_id;
                            costPdtDal.Insert(costPdtPurchasing);
                            OperLogBLL.OperLogAdd<ctt_contract_cost_product>(costPdtPurchasing, costPdtPurchasing.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "采购接收取消配送新增成本产品");
                        }
                        else
                        {
                            var costPdtOld = costPdtDal.FindById(costPdtPurchasing.id);
                            costPdtPurchasing.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            costPdtPurchasing.update_user_id = userId;
                            costPdtPurchasing.quantity = costPdtPurchasing.quantity - item.count;
                            costPdtDal.Update(costPdtPurchasing);
                            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(costPdtOld, costPdtPurchasing), costPdtPurchasing.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "采购接收取消配送修改成本产品");
                        }
                    }
                }
                
                // 序列化产品记录序列号
                if (item.sns.Count != 0)
                {
                    if (item.count > 0)
                    {
                        foreach (var sn in item.sns)
                        {
                            // 保存接收串号
                            ivt_receive_sn rsn = new ivt_receive_sn();
                            rsn.id = recvSnDal.GetNextIdCom();
                            rsn.receive_id = recv.id;
                            rsn.sn = sn;
                            rsn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            rsn.create_user_id = userId;
                            rsn.update_time = rsn.create_time;
                            rsn.update_user_id = userId;
                            recvSnDal.Insert(rsn);
                            OperLogBLL.OperLogAdd<ivt_receive_sn>(rsn, rsn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PURCHASE_RECEIVE_SN, "新增采购接收串号");

                            // 保存库存产品串号
                            ivt_warehouse_product_sn lpsn = new ivt_warehouse_product_sn();
                            lpsn.id = lctPdtSnDal.GetNextIdCom();
                            lpsn.warehouse_product_id = lctPdt.id;
                            lpsn.sn = sn;
                            lpsn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                            lpsn.create_user_id = userId;
                            lpsn.update_time = lpsn.create_time;
                            lpsn.update_user_id = userId;
                            lctPdtSnDal.Insert(lpsn);
                            OperLogBLL.OperLogAdd<ivt_warehouse_product_sn>(lpsn, lpsn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "新增库存产品串号");
                        }
                    }
                    else
                    {
                        string ids = "";
                        foreach (var rsnid in item.sns)
                        {
                            ids += rsnid + ",";
                        }
                        ids = ids.Remove(ids.Length - 1, 1);
                        // 删除接收串号
                        recvSnDal.ExecuteSQL($"update ivt_receive_sn set delete_time='{Tools.Date.DateHelper.ToUniversalTimeStamp()}',delete_user_id={userId} where id in({ids})");
                        // 删除库存产品串号
                        lctPdtSnDal.ExecuteSQL($"update ivt_warehouse_product_sn set delete_time='{Tools.Date.DateHelper.ToUniversalTimeStamp()}',delete_user_id={userId} where warehouse_product_id={lctPdt.id} and sn in(select sn from ivt_receive_sn where id in({ids}))");
                    }
                }

            }

            // 修改采购订单状态
            ivt_order order = dal.FindById(orderId);
            ivt_order orderOld = dal.FindById(orderId);
            if (havePartReceive || (haveAllReceive && haveUnReceive))
            {
                order.status_id = (int)DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_PARTIAL;
            }
            else if (haveAllReceive)
            {
                order.status_id = (int)DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_FULL;
            }
            else
            {
                order.status_id = (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED;
            }
            order.vendor_invoice_no = vendor_invoice_no;
            order.freight_cost = freight_cost;
            order.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            order.update_user_id = userId;
            string desc = OperLogBLL.CompareValue<ivt_order>(orderOld, order);
            if (!string.IsNullOrEmpty(desc))
            {
                dal.Update(order);
                OperLogBLL.OperLogUpdate(desc, order.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ORDER, "采购订单接收");
            }

            return true;
        }
    }
}
