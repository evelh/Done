using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 库存产品
    /// </summary>
    public class InventoryProductBLL
    {
        private readonly ivt_warehouse_product_dal dal = new ivt_warehouse_product_dal();

        public ivt_warehouse_product GetIvtProduct(long id)
        {
            return dal.FindById(id);
        }

        /// <summary>
        /// 获取库存产品的编辑信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public InventoryItemEditDto GetIvtProductEdit(long id)
        {
            string sql = @"
SELECT t.*,ifnull(
				(
					SELECT
						sum(y.quantity)
					FROM
						ivt_order x,
						ivt_order_product y
					WHERE
						y.delete_time = 0
					AND x.id = y.order_id
					AND x.status_id IN (2148, 2149)
					AND y.product_id = t.id
					AND y.warehouse_id = t.warehouse_id
				),
				0
			) as on_order,
ifnull(
				(
					SELECT
						ifnull(sum(y.quantity), 0) - ifnull(sum(z.quantity_received), 0)
					FROM
						ivt_order x,
						ivt_order_product y,
						ivt_receive z
					WHERE
						y.delete_time = 0
					AND z.delete_time = 0
					AND x.status_id IN (2149)
					AND x.id = y.order_id
					AND y.id = z.order_product_id
					AND y.product_id = t.id
					AND y.warehouse_id = t.warehouse_id
				),
				0
			) as back_order,
ifnull(
	(
		SELECT
			sum(x.quantity)
		FROM
			ivt_reserve x,
			crm_quote_item y
		WHERE
			x.delete_time = 0
		AND x.quote_item_id = y.id
		AND y.object_id = t.id
		AND x.warehouse_id = w.id
	),
	0
) + ifnull(
	(
		SELECT
			sum(x.quantity)
		FROM
			ctt_contract_cost_product x,
			ctt_contract_cost y
		WHERE
			x.delete_time = 0
		AND x.status_id = 2157
		AND x.contract_cost_id = y.id
		AND y.product_id = t.id
		AND x.warehouse_id = w.id
	),
	0
) as reserved_picked,
p.name as product_name,
w.name as location_name 
 from ivt_warehouse_product as t,ivt_product as p,ivt_warehouse as w WHERE t.id=" + id + " and p.id=t.product_id and w.id=t.warehouse_id";
            return dal.FindSignleBySql<InventoryItemEditDto>(sql);
        }

        /// <summary>
        /// 获取库存产品的序列号列表
        /// </summary>
        /// <param name="productId">库存产品id</param>
        /// <returns></returns>
        public List<ivt_warehouse_product_sn> GetProductSnList(long productId)
        {
            return new ivt_warehouse_product_sn_dal().FindListBySql($"select * from ivt_warehouse_product_sn where warehouse_product_id={productId} and delete_time=0");
        }

        /// <summary>
        /// 新增产品
        /// </summary>
        /// <param name="pdt"></param>
        /// <param name="sn">序列化产品的序列号</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddIvtProduct(ivt_warehouse_product pdt, string sn, long userId)
        {
            pdt.id = dal.GetNextIdCom();
            pdt.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            pdt.create_user_id = userId;
            pdt.update_time = pdt.create_time;
            pdt.update_user_id = userId;

            dal.Insert(pdt);
            OperLogBLL.OperLogAdd<ivt_warehouse_product>(pdt, pdt.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "新增库存产品");

            SaveProductSn(sn, pdt.id, userId);

            return true;
        }

        public bool EditIvtProduct(ivt_warehouse_product pdt, string sn, long userId)
        {
            ivt_warehouse_product product = dal.FindById(pdt.id);
            ivt_warehouse_product productOld = dal.FindById(pdt.id);

            if (product == null)
                return false;
            product.reference_number = pdt.reference_number;
            product.bin = pdt.bin;
            product.quantity_minimum = pdt.quantity_minimum;
            product.quantity_maximum = pdt.quantity_maximum;
            product.quantity = pdt.quantity;
            product.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            product.update_user_id = userId;

            dal.Update(product);
            OperLogBLL.OperLogUpdate<ivt_warehouse_product>(product, productOld, product.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "修改库存产品");

            string sql = $"update ivt_warehouse_product_sn set delete_user_id={userId},delete_time={Tools.Date.DateHelper.ToUniversalTimeStamp()} where warehouse_product_id={product.id}";
            dal.ExecuteSQL(sql);

            SaveProductSn(sn, product.id, userId);

            return true;
        }

        private void SaveProductSn(string snList,long productId,long userId)
        {
            if (string.IsNullOrEmpty(snList))
                return;
            var sns = snList.Split('\n');

            ivt_warehouse_product_sn_dal snDal = new ivt_warehouse_product_sn_dal();
            foreach(var sn in sns)
            {
                string s = sn.Trim();
                if (string.IsNullOrEmpty(s))
                    continue;
                ivt_warehouse_product_sn psn = new ivt_warehouse_product_sn();
                psn.id = dal.GetNextIdCom();
                psn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                psn.create_user_id = userId;
                psn.update_time = psn.create_time;
                psn.update_user_id = userId;
                psn.warehouse_product_id = productId;
                psn.sn = s;

                snDal.Insert(psn);
                OperLogBLL.OperLogAdd<ivt_warehouse_product_sn>(psn, psn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "新增库存产品串号");
            }
        }
    }
}
