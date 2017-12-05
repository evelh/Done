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
ifnull(
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
) as picked,
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

        /// <summary>
        /// 编辑库存产品
        /// </summary>
        /// <param name="pdt"></param>
        /// <param name="sn"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
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

            string desc = OperLogBLL.CompareValue<ivt_warehouse_product>(productOld, product);
            if (!string.IsNullOrEmpty(desc))
            {
                dal.Update(product);
                OperLogBLL.OperLogUpdate(desc, product.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "修改库存产品");
            }

            if (product.quantity!=productOld.quantity)      // 修改库存数量记录库存转移
            {
                var transferDal = new ivt_transfer_dal();
                var trsf = new ivt_transfer();
                trsf.id = dal.GetNextIdCom();
                trsf.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                trsf.create_user_id = userId;
                trsf.update_time = trsf.create_time;
                trsf.update_user_id = userId;
                trsf.quantity = product.quantity - productOld.quantity;
                trsf.type_id = (int)DicEnum.INVENTORY_TRANSFER_TYPE.INVENTORY;
                trsf.product_id = product.product_id;
                trsf.from_warehouse_id = (long)product.warehouse_id;
                trsf.notes = "";
                transferDal.Insert(trsf);
                OperLogBLL.OperLogAdd<ivt_transfer>(trsf, trsf.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "新增库存转移");
            }

            //OperLogBLL.OperLogUpdate<ivt_warehouse_product>(product, productOld, product.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "修改库存产品");

            string sql = $"update ivt_warehouse_product_sn set delete_user_id={userId},delete_time={Tools.Date.DateHelper.ToUniversalTimeStamp()} where warehouse_product_id={product.id}";
            dal.ExecuteSQL(sql);

            SaveProductSn(sn, product.id, userId);

            return true;
        }

        /// <summary>
        /// 删除库存产品
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteIvtProduct(long id, long userId)
        {
            var pdtInfo = GetIvtProductEdit(id);
            if (pdtInfo == null)
                return false;
            if (int.Parse(pdtInfo.picked) > 0 || int.Parse(pdtInfo.on_order) > 0)
                return false;

            ivt_warehouse_product product = dal.FindById(id);

            string sql = $"update ivt_warehouse_product_sn set delete_user_id={userId},delete_time={Tools.Date.DateHelper.ToUniversalTimeStamp()} where warehouse_product_id={id} and delete_time=0";
            dal.ExecuteSQL(sql);

            product.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            product.delete_user_id = userId;
            dal.Update(product);

            OperLogBLL.OperLogDelete<ivt_warehouse_product>(product, id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "删除库存产品");

            if (int.Parse(pdtInfo.reserved_picked) - int.Parse(pdtInfo.picked) > 0)     // 有预留库存产品，删除之
            {
                sql = $"update ivt_reserve set delete_user_id={userId},delete_time={Tools.Date.DateHelper.ToUniversalTimeStamp()} where warehouse_id={product.warehouse_id} and delete_time=0 and quote_item_id in(select id from crm_quote_item where object_id={product.id} and delete_time=0)";
                dal.ExecuteSQL(sql);
            }

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

        /// <summary>
        /// 库存产品转移
        /// </summary>
        /// <param name="ivtProductId">库存产品id</param>
        /// <param name="targetLocation">目标仓库id</param>
        /// <param name="count">转移数</param>
        /// <param name="sns">序列号</param>
        /// <param name="note">备注</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool TransferProduct(long ivtProductId, long targetLocation, int count, string sns, string note, long userId)
        {
            var ivtPdtSource = dal.FindById(ivtProductId);      // 转移的源仓库库存产品
            if (count <= 0 || count > ivtPdtSource.quantity)
                return false;

            // 修改源库存产品
            var ivtPdtSourceOld = dal.FindById(ivtProductId);
            ivtPdtSource.quantity = ivtPdtSource.quantity - count;
            ivtPdtSource.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            ivtPdtSource.update_user_id = userId;
            string desc = OperLogBLL.CompareValue<ivt_warehouse_product>(ivtPdtSourceOld, ivtPdtSource);
            dal.Update(ivtPdtSource);
            OperLogBLL.OperLogUpdate(desc, ivtPdtSource.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "库存转移减少库存");

            // 修改或新增目标库存产品
            var ivtPdtTarget = dal.FindSignleBySql<ivt_warehouse_product>(
                $"select * from ivt_warehouse_product where product_id={ivtPdtSource.product_id} and warehouse_id={targetLocation} and delete_time=0"); // 转移的目标仓库库存产品
            if (ivtPdtTarget==null)
            {
                ivtPdtTarget = new ivt_warehouse_product();
                ivtPdtTarget.id = dal.GetNextIdCom();
                ivtPdtTarget.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                ivtPdtTarget.create_user_id = userId;
                ivtPdtTarget.update_time = ivtPdtTarget.create_time;
                ivtPdtTarget.update_user_id = userId;
                ivtPdtTarget.warehouse_id = targetLocation;
                ivtPdtTarget.product_id = ivtPdtSource.product_id;
                ivtPdtTarget.quantity_minimum = ivtPdtSource.quantity_minimum;
                ivtPdtTarget.quantity_maximum = ivtPdtSource.quantity_maximum;
                ivtPdtTarget.quantity = count;

                dal.Insert(ivtPdtTarget);
                OperLogBLL.OperLogAdd<ivt_warehouse_product>(ivtPdtTarget, ivtPdtTarget.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "库存转移增加库存");
            }
            else
            {
                var ivtPdtTargetOld = dal.FindById(ivtPdtTarget.id);
                ivtPdtTarget.quantity = ivtPdtTarget.quantity + count;
                ivtPdtTarget.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                ivtPdtTarget.update_user_id = userId;
                desc= OperLogBLL.CompareValue<ivt_warehouse_product>(ivtPdtTargetOld, ivtPdtTarget);
                dal.Update(ivtPdtTarget);
                OperLogBLL.OperLogUpdate(desc, ivtPdtTarget.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "库存转移增加库存");
            }

            // 记录库存转移
            var transferDal = new ivt_transfer_dal();
            var trsf = new ivt_transfer();
            trsf.id = dal.GetNextIdCom();
            trsf.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            trsf.create_user_id = userId;
            trsf.update_time = trsf.create_time;
            trsf.update_user_id = userId;
            trsf.quantity = count;
            trsf.type_id = (int)DicEnum.INVENTORY_TRANSFER_TYPE.INVENTORY;
            trsf.product_id = ivtPdtSource.product_id;
            trsf.from_warehouse_id = (long)ivtPdtSource.warehouse_id;
            trsf.to_warehouse_id = targetLocation;
            trsf.notes = note;
            transferDal.Insert(trsf);
            OperLogBLL.OperLogAdd<ivt_transfer>(trsf, trsf.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "新增库存转移");

            if (!string.IsNullOrEmpty(sns))     // 库存转移序号
            {
                var snTrsfDal = new ivt_transfer_sn_dal();
                var snDal = new ivt_warehouse_product_sn_dal();
                var snList = snDal.FindListBySql($"select * from ivt_warehouse_product_sn where id in({sns}) and delete_time=0");
                if (snList.Count != count)
                    return true;
                foreach(var psn in snList)
                {
                    // 修改库存产品序列号所属库存产品
                    var psnOld = snDal.FindById(psn.id);
                    psn.warehouse_product_id = ivtPdtTarget.id;
                    psn.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    psn.update_user_id = userId;
                    snDal.Update(psn);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ivt_warehouse_product_sn>(psnOld, psn), psn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "库存转移修改库存产品序号");

                    // 移库产品序列号
                    ivt_transfer_sn tsn = new ivt_transfer_sn();
                    tsn.id = snTrsfDal.GetNextIdCom();
                    tsn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    tsn.create_user_id = userId;
                    tsn.update_time = tsn.create_time;
                    tsn.update_user_id = userId;
                    tsn.transfer_id = trsf.id;
                    tsn.sn = psn.sn;
                    snTrsfDal.Insert(tsn);
                    OperLogBLL.OperLogAdd<ivt_transfer_sn>(tsn, tsn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER_SN, "库存转移新增移库产品序列号");
                }
            }

            return true;
        }
    }
}
