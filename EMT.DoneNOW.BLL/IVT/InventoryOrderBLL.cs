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
                if (lct.address == location.address && lct.district_id == location.district_id && lct.additional_address == location.additional_address && lct.postal_code == location.postal_code)
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

            foreach (var item in items)
            {
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

                pdtDal.Insert(pdt);
                OperLogBLL.OperLogAdd<ivt_order_product>(pdt, pdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.PURCHASE_ORDER_ITEM, "新增采购订单增加采购项");

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
                if (!(lct.address == location.address && lct.district_id == location.district_id && lct.additional_address == location.additional_address && lct.postal_code == location.postal_code))
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
                if (orderEdit.status_id == (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED
                    && order.status_id != (int)DicEnum.PURCHASE_ORDER_STATUS.SUBMITTED)
                {
                    order.submitted_resource_id = orderEdit.submitted_resource_id;
                    order.submit_time = orderEdit.submit_time;
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
        /// 获取采购订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ivt_order GetPurchaseOrder(long id)
        {
            return dal.FindById(id);
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
    }
}
