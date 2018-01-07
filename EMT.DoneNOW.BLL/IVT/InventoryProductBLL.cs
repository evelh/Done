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

        /// <summary>
        /// 获取某个采购项的已接收数
        /// </summary>
        /// <param name="orderProductId"></param>
        /// <returns></returns>
        public int GetReceivedCnt(long orderProductId)
        {
            string sql = $"select sum(quantity_received) from ivt_receive where order_product_id={orderProductId} and delete_time=0";
            var count = dal.FindSignleBySql<int?>(sql);
            return count == null ? 0 : (int)count;
        }

        /// <summary>
        /// 判断采购项对应产品是否序列化的
        /// </summary>
        /// <param name="orderProductId"></param>
        /// <returns></returns>
        public bool IsProductSerialized(long orderProductId)
        {
            string sql = $"select is_serialized from ivt_product where id=(select product_id from ivt_order_product where id={orderProductId})";
            var is_serialized = dal.FindSignleBySql<int>(sql);
            return is_serialized == 1;
        }

        /// <summary>
        /// 根据库存产品id列表获取采购订单的采购项信息
        /// </summary>
        /// <param name="pdtIds"></param>
        /// <returns></returns>
        public PurchaseOrderItemManageDto InitPurchaseOrderItems(string pdtIds)
        {
            PurchaseOrderItemManageDto dto = new PurchaseOrderItemManageDto();
            string sql = $"select product_id,warehouse_id,(select name from ivt_product where id=product_id) as product,(select unit_cost from ivt_product where id=product_id) as unit_cost,(select name from ivt_warehouse where id=warehouse_id) as locationName,(quantity_maximum-quantity) as quantity from ivt_warehouse_product where id in({pdtIds})";
            dto.items = dal.FindListBySql<PurchaseItemDto>(sql);
            for (var i = 0; i < dto.items.Count; ++i)
            {
                dto.items[i].id = dto.index++;
                if (dto.items[i].quantity < 0)
                    dto.items[i].quantity = 0;
            }
            if (dto.items.Count==0)
            {
                sql = $"select id,id as costId,product_id,(select id from ivt_warehouse where is_default=1 and delete_time=0) as warehouse_id,unit_cost,(select name from ivt_product where id=product_id) as product,(select name from ivt_warehouse where is_default=1 and delete_time=0) as locationName from ctt_contract_cost where id in({pdtIds})";
                dto.items = dal.FindListBySql<PurchaseItemDto>(sql);
                if (dto.items.Count == 0)
                    return dto;

                QueryCommonBLL queryBll = new QueryCommonBLL();
                QueryParaDto queryPara = new QueryParaDto();
                queryPara.query_params = new List<Para>();
                queryPara.query_type_id = (long)QueryType.PurchaseFulfillment;
                queryPara.para_group_id = 156;
                queryPara.page = 1;
                queryPara.page_size = 500;
                QueryResultDto queryResult = queryBll.GetResult(0, queryPara);
                if (queryResult.count == 0)
                    return dto;
                for (var i = 0; i < dto.items.Count; ++i)
                {
                    var find = queryResult.result.Find(_ => _["成本id"].ToString().Equals(dto.items[i].id.ToString()));
                    if (find == null)
                        continue;
                    dto.items[i].quantity = (int)(string.IsNullOrEmpty(find["采购数量"].ToString()) ? 0 : decimal.Parse(find["采购数量"].ToString()));
                    dto.items[i].id = dto.index++;
                }
            }
            return dto;
        }

        /// <summary>
        /// 获取供应商包含指定供应商的采购项
        /// </summary>
        /// <param name="onlyDefault">只有默认供应商</param>
        /// <param name="vendorId">供应商id</param>
        /// <returns></returns>
        public List<PurchaseItemDto> GetDefaultOrderItems(bool onlyDefault, long vendorId)
        {
            string sql = $"select * from ivt_product where id in(select product_id from ivt_product_vendor where vendor_account_id={vendorId}";
            if (onlyDefault)
                sql += " and is_default=1 ";
            sql += " and delete_time=0 ) and delete_time=0";
            var list = dal.FindListBySql<ivt_product>(sql);

            if (list == null)
                return new List<PurchaseItemDto>();

            List<PurchaseItemDto> itemList = new List<PurchaseItemDto>();
            for (int i = 0; i < list.Count; ++i)
            {
                var lctList = dal.FindListBySql($"select id,warehouse_id,product_id,quantity,quantity_minimum,quantity_maximum,(select name from ivt_warehouse where id=warehouse_id) as bin from ivt_warehouse_product where product_id={list[i].id} and delete_time=0");
                if (lctList == null || lctList.Count == 0)
                    continue;
                foreach (var lctPdt in lctList)
                {
                    if (lctPdt.quantity >= lctPdt.quantity_minimum)
                        continue;
                    PurchaseItemDto itm = new PurchaseItemDto();
                    itm.product = list[i].name;
                    itm.product_id = list[i].id;
                    itm.locationName = lctPdt.bin;
                    itm.warehouse_id = (long)lctPdt.warehouse_id;
                    itm.quantity = lctPdt.quantity_maximum - lctPdt.quantity;
                    itm.unit_cost = list[i].unit_cost;
                    itemList.Add(itm);
                }
            }
            return itemList;
        }

        /// <summary>
        /// 配送
        /// </summary>
        /// <param name="costPdtIds">成本产品id</param>
        /// <param name="isEditSaleOrder">是否修改销售订单状态</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string PurchaseShip(string costPdtIds, bool isEditSaleOrder, long userId)
        {
            ctt_contract_cost_product_dal cstPdtDal = new ctt_contract_cost_product_dal();
            var pdtList = cstPdtDal.FindListBySql<ctt_contract_cost_product>($"select * from ctt_contract_cost_product where id in({costPdtIds})");
            if (pdtList == null || pdtList.Count == 0)
                return "";

            foreach (var pdt in pdtList)
            {
                if (pdt.status_id != (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION)
                    return "状态为“待配送”的成本产品才能配送";
            }

            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
            ivt_transfer_dal tsfDal = new ivt_transfer_dal();
            ctt_contract_dal cttDal = new ctt_contract_dal();
            pro_project_dal proDal = new pro_project_dal();
            sdk_task_dal tskDal = new sdk_task_dal();
            ivt_warehouse_product_sn_dal lctPdtSnDal = new ivt_warehouse_product_sn_dal();
            ivt_transfer_sn_dal tsfSnDal = new ivt_transfer_sn_dal();
            foreach (var pdt in pdtList)
            {
                var pdtOld = cstPdtDal.FindById(pdt.id);
                pdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION;
                pdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                pdt.shipping_time = pdt.update_time;
                pdt.update_user_id = userId;
                cstPdtDal.Update(pdt);
                OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(pdtOld, pdt), pdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "成本产品配送");
                
                var cost = costDal.FindById(pdt.contract_cost_id);
                var cnt = dal.FindSignleBySql<int>($"select count(0) from ctt_contract_cost_product where contract_cost_id={pdt.contract_cost_id} and status_id<>{(int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION} and delete_time=0");
                if (cnt == 0)   // 产品全部已配送，修改成本状态
                {
                    var costOld = costDal.FindById(pdt.contract_cost_id);
                    cost.status_id = (int)DicEnum.COST_STATUS.ALREADY_DELIVERED;
                    cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    cost.update_user_id = userId;
                    costDal.Update(cost);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态已配送");
                }

                ivt_transfer transfer = new ivt_transfer();
                transfer.id = tsfDal.GetNextIdCom();
                transfer.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                transfer.create_user_id = userId;
                transfer.update_time = transfer.create_time;
                transfer.update_user_id = userId;
                transfer.product_id = (long)cost.product_id;
                transfer.type_id = (int)DicEnum.INVENTORY_TRANSFER_TYPE.PROJECT;
                transfer.from_warehouse_id = (long)pdt.warehouse_id;
                transfer.quantity = pdt.quantity;
                if (cost.contract_id != null)
                    transfer.to_account_id = cttDal.FindById((long)cost.contract_id).account_id;
                else if (cost.project_id != null)
                    transfer.to_account_id = proDal.FindById((long)cost.project_id).account_id;
                else if (cost.task_id != null)
                    transfer.to_account_id = tskDal.FindById((long)cost.task_id).account_id;
                transfer.to_contract_id = cost.contract_id;
                transfer.to_project_id = cost.project_id;
                transfer.to_task_id = cost.task_id;
                tsfDal.Insert(transfer);
                OperLogBLL.OperLogAdd<ivt_transfer>(transfer, transfer.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "产品配送转移库存");

                // 保存库存数修改
                var lctPdt = dal.FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where product_id={cost.product_id} and warehouse_id={(long)pdt.warehouse_id} and delete_time=0");
                if (lctPdt != null)
                {
                    var lctPdtOld = dal.FindById(lctPdt.id);
                    lctPdt.quantity = lctPdt.quantity - pdt.quantity;
                    lctPdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    lctPdt.update_user_id = userId;
                    dal.Update(lctPdt);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ivt_warehouse_product>(lctPdtOld, lctPdt), lctPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "修改库存产品库存数");

                    var sns = costDal.FindListBySql<string>($"select sn from ctt_contract_cost_product_sn where contract_cost_product_id={pdt.id} and delete_time=0");
                    if (sns == null || sns.Count == 0)
                        continue;

                    foreach (var sn in sns)
                    {
                        var lctPdtSn = lctPdtSnDal.FindSignleBySql<ivt_warehouse_product_sn>($"select * from ivt_warehouse_product_sn where sn='{sn}' and warehouse_product_id={lctPdt.id}");
                        lctPdtSn.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        lctPdtSn.delete_user_id = userId;
                        lctPdtSnDal.Update(lctPdtSn);
                        OperLogBLL.OperLogDelete<ivt_warehouse_product_sn>(lctPdtSn, lctPdtSn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "配送产品删除库存产品串号");

                        ivt_transfer_sn tsfSn = new ivt_transfer_sn();
                        tsfSn.id = tsfSnDal.GetNextIdCom();
                        tsfSn.sn = sn;
                        tsfSn.transfer_id = transfer.id;
                        tsfSn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        tsfSn.create_user_id = userId;
                        tsfSn.update_time = tsfSn.create_time;
                        tsfSn.update_user_id = userId;
                        tsfSnDal.Insert(tsfSn);
                        OperLogBLL.OperLogAdd<ivt_transfer_sn>(tsfSn, tsfSn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER_SN, "配送产品新增转移产品串号");
                    }

                }
            }

            return "";
        }

        /// <summary>
        /// 取消配送
        /// </summary>
        /// <param name="costPdtIds">成本产品id</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public string PurchaseUnShip(string costPdtIds, long userId)
        {
            ctt_contract_cost_product_dal cstPdtDal = new ctt_contract_cost_product_dal();
            var pdtList = cstPdtDal.FindListBySql<ctt_contract_cost_product>($"select * from ctt_contract_cost_product where id in({costPdtIds})");
            if (pdtList == null || pdtList.Count == 0)
                return "";

            ctt_contract_cost_dal costDal = new ctt_contract_cost_dal();
            ivt_transfer_dal tsfDal = new ivt_transfer_dal();
            ctt_contract_dal cttDal = new ctt_contract_dal();
            pro_project_dal proDal = new pro_project_dal();
            sdk_task_dal tskDal = new sdk_task_dal();
            ivt_warehouse_product_sn_dal lctPdtSnDal = new ivt_warehouse_product_sn_dal();
            ivt_transfer_sn_dal tsfSnDal = new ivt_transfer_sn_dal();
            foreach (var pdt in pdtList)
            {
                // 修改成本产品状态
                var pdtOld = cstPdtDal.FindById(pdt.id);
                pdt.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION;
                pdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                pdt.shipping_time = null;
                pdt.update_user_id = userId;
                cstPdtDal.Update(pdt);
                OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost_product>(pdtOld, pdt), pdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "成本产品配送");

                // 修改成本状态
                var cost = costDal.FindById(pdt.contract_cost_id);
                if (cost.status_id == (int)DicEnum.COST_STATUS.ALREADY_DELIVERED)
                {
                    var costOld = costDal.FindById(pdt.contract_cost_id);
                    cost.status_id = (int)DicEnum.COST_STATUS.PENDING_DELIVERY;
                    cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    cost.update_user_id = userId;
                    costDal.Update(cost);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "取消配送修改成本状态");
                }

                // 新建库存转移信息
                ivt_transfer tsf = new ivt_transfer();
                tsf.id = tsfDal.GetNextIdCom();
                tsf.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                tsf.update_user_id = userId;
                tsf.create_time = tsf.update_time;
                tsf.create_user_id = userId;
                tsf.type_id = (int)DicEnum.INVENTORY_TRANSFER_TYPE.PROJECT;
                tsf.product_id = (long)cost.product_id;
                tsf.quantity = 0 - pdt.quantity;
                if (cost.contract_id != null)
                    tsf.to_account_id = cttDal.FindById((long)cost.contract_id).account_id;
                else if (cost.project_id != null)
                    tsf.to_account_id = proDal.FindById((long)cost.project_id).account_id;
                else if (cost.task_id != null)
                    tsf.to_account_id = tskDal.FindById((long)cost.task_id).account_id;
                tsf.to_contract_id = cost.contract_id;
                tsf.to_project_id = cost.project_id;
                tsf.to_task_id = cost.task_id;
                tsf.from_warehouse_id = (long)pdt.warehouse_id;
                tsfDal.Insert(tsf);
                OperLogBLL.OperLogAdd<ivt_transfer>(tsf, tsf.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "取消配送新建库存转移");


                // 保存库存数修改
                var lctPdt = dal.FindSignleBySql<ivt_warehouse_product>($"select * from ivt_warehouse_product where product_id={cost.product_id} and warehouse_id={(long)pdt.warehouse_id} and delete_time=0");
                if (lctPdt != null)
                {
                    var lctPdtOld = dal.FindById(lctPdt.id);
                    lctPdt.quantity = lctPdt.quantity + pdt.quantity;
                    lctPdt.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                    lctPdt.update_user_id = userId;
                    dal.Update(lctPdt);
                    OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ivt_warehouse_product>(lctPdtOld, lctPdt), lctPdt.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "修改库存产品库存数");

                    var sns = costDal.FindListBySql<string>($"select sn from ctt_contract_cost_product_sn where contract_cost_product_id={pdt.id} and delete_time=0");
                    if (sns == null || sns.Count == 0)
                        continue;

                    foreach (var sn in sns)
                    {
                        ivt_warehouse_product_sn lctPdtSn = new ivt_warehouse_product_sn();
                        lctPdtSn.id = lctPdtSnDal.GetNextIdCom();
                        lctPdtSn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        lctPdtSn.create_user_id = userId;
                        lctPdtSn.update_time = lctPdtSn.create_time;
                        lctPdtSn.update_user_id = userId;
                        lctPdtSn.warehouse_product_id = lctPdt.id;
                        lctPdtSn.sn = sn;
                        lctPdtSnDal.Insert(lctPdtSn);
                        OperLogBLL.OperLogAdd<ivt_warehouse_product_sn>(lctPdtSn, lctPdtSn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "取消配送产品新增库存产品串号");

                        ivt_transfer_sn tsfSn = new ivt_transfer_sn();
                        tsfSn.id = tsfSnDal.GetNextIdCom();
                        tsfSn.sn = sn;
                        tsfSn.transfer_id = tsf.id;
                        tsfSn.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                        tsfSn.create_user_id = userId;
                        tsfSn.update_time = tsfSn.create_time;
                        tsfSn.update_user_id = userId;
                        tsfSnDal.Insert(tsfSn);
                        OperLogBLL.OperLogAdd<ivt_transfer_sn>(tsfSn, tsfSn.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER_SN, "取消配送产品新增转移产品串号");
                    }

                }
            }

            return "";
        }
    }
}
