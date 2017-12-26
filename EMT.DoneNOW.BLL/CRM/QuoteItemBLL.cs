using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;
using System.Text.RegularExpressions;


namespace EMT.DoneNOW.BLL
{
    public class QuoteItemBLL
    {
        private crm_quote_item_dal _dal = new crm_quote_item_dal();

        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("quote_item_period_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE)));        // 
            dic.Add("quote_item_tax_cate", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_TAX_CATE)));        // 
            dic.Add("quote_item_type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_TYPE)));        // 
            dic.Add("quote_group_by", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_GROUP_BY)));
            

            return dic;

        }
        /// <summary>
        /// 新增报价项
        /// </summary>
        /// <param name="quote_item"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(crm_quote_item quote_item, Dictionary<long, int> wareDic, long user_id, bool isSaleOrder = false, long? saleOrderId = null)
        {
            if (quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT)
            {
                if (quote_item.unit_price == null || quote_item.unit_cost == null || quote_item.quantity == null || quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            else
            {
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if (quote_item.discount_percent == null && quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }

            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            quote_item.id = _dal.GetNextIdCom();
            quote_item.tax_cate_id = quote_item.tax_cate_id == 0 ? null : quote_item.tax_cate_id;
            quote_item.period_type_id = quote_item.period_type_id == 0 ? null : quote_item.period_type_id;
            quote_item.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote_item.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote_item.create_user_id = user_id;
            quote_item.update_user_id = user_id;

            _dal.Insert(quote_item);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                oper_object_id = quote_item.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(quote_item),
                remark = "保存报价项信息"
            });

            var oDal = new crm_opportunity_dal();
            var oppo = oDal.GetOpByItemID(quote_item.id);
            if (oppo != null && oppo.use_quote == 1)
            {
                if (quote_item.optional != 1 && quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES)
                {
                    decimal? changeRevenue = quote_item.quantity * quote_item.unit_price;
                    decimal? changeCost = quote_item.quantity * quote_item.unit_cost;

                    switch (quote_item.period_type_id)
                    {
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME:
                            if (oppo.one_time_revenue != null)
                            {
                                oppo.one_time_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.one_time_revenue = changeRevenue;
                            }
                            if (oppo.one_time_cost != null)
                            {
                                oppo.one_time_cost += changeCost;
                            }
                            else
                            {
                                oppo.one_time_cost = changeCost;
                            }
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                            if (oppo.monthly_revenue != null)
                            {
                                oppo.monthly_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.monthly_revenue = changeRevenue;
                            }
                            if (oppo.monthly_cost != null)
                            {
                                oppo.monthly_cost += changeCost;
                            }
                            else
                            {
                                oppo.monthly_cost = changeCost;
                            }
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                            if (oppo.quarterly_revenue != null)
                            {
                                oppo.quarterly_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.quarterly_revenue = changeRevenue;
                            }
                            if (oppo.quarterly_cost != null)
                            {
                                oppo.quarterly_cost += changeCost;
                            }
                            else
                            {
                                oppo.quarterly_cost = changeCost;
                            }
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                            if (oppo.semi_annual_revenue != null)
                            {
                                oppo.semi_annual_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.semi_annual_revenue = changeRevenue;
                            }
                            if (oppo.semi_annual_cost != null)
                            {
                                oppo.semi_annual_cost += changeCost;
                            }
                            else
                            {
                                oppo.semi_annual_cost = changeCost;
                            }

                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                            if (oppo.yearly_revenue != null)
                            {
                                oppo.yearly_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.yearly_revenue = changeRevenue;
                            }
                            if (oppo.yearly_cost != null)
                            {
                                oppo.yearly_cost += changeCost;
                            }
                            else
                            {
                                oppo.yearly_cost = changeCost;
                            }

                            break;
                        default:
                            break;
                    }

                    // var udfDto = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
                    // var udfValue = 
                    OpportunityAddOrUpdateDto param = new OpportunityAddOrUpdateDto()
                    {
                        general = oppo,
                        udf = null,
                        notify = null
                    };
                    new OpportunityBLL().Update(param, user.id);
                }
            }
            if (quote_item.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT)
            {
                if (wareDic != null && wareDic.Count > 0)
                {
                    var irDal = new ivt_reserve_dal();
                    var iwDal = new ivt_warehouse_dal();
                    foreach (var thisPageWare in wareDic)
                    {
                        var thisWareHouse = iwDal.FindNoDeleteById(thisPageWare.Key);
                        if (thisWareHouse != null)
                        {
                            var thisReserve = new ivt_reserve()
                            {
                                id = irDal.GetNextIdCom(),
                                create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                create_user_id = user_id,
                                update_user_id = user_id,
                                quote_item_id = quote_item.id,
                                warehouse_id = thisPageWare.Key,
                                quantity = thisPageWare.Value,
                                resource_id = thisWareHouse.resource_id,
                            };
                            irDal.Insert(thisReserve);
                            OperLogBLL.OperLogAdd<ivt_reserve>(thisReserve, thisReserve.id, user_id, OPER_LOG_OBJ_CATE.WAREHOUSE_RESERVE, "新增库存预留");
                        }

                    }

                }
            }

            if (isSaleOrder && saleOrderId != null&&(quote_item.type_id==(int)DicEnum.QUOTE_ITEM_TYPE.PRODUCT|| quote_item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DEGRESSION|| quote_item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES))
            {
                var cccDal = new ctt_contract_cost_dal();
                var costList = cccDal.GetListBySaleOrderId((long)saleOrderId);
                if (costList != null && costList.Count > 0)
                {
                    int status_id = 0;
                    long cost_code_id = (long)quote_item.object_id;
                    if (quote_item.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT)
                    {

                        status_id = (int)COST_STATUS.PENDING_PURCHASE;
                        var thisProduct = new ivt_product_dal().FindNoDeleteById(cost_code_id);
                        if (thisProduct != null) 
                        {
                            cost_code_id = thisProduct.cost_code_id;
                        }
                        else
                        {
                            return ERROR_CODE.ERROR;
                        }
                        var appSet = new SysSettingBLL().GetSetById(DTO.SysSettingEnum.CTT_COST_APPROVAL_VALUE);
                        if (appSet != null && !string.IsNullOrEmpty(appSet.setting_value)&& thisProduct.does_not_require_procurement == 1) // 该产品走采购流程，并且价格大于设置，则带审批
                        {
                            if (((decimal)quote_item.quantity * (decimal)quote_item.unit_price) > decimal.Parse(appSet.setting_value)) // 金额超出（待审批）
                            {
                                status_id = (int)COST_STATUS.PENDING_APPROVAL;
                            }
                        }
                    }
                    else
                    {
                        status_id = (int)COST_STATUS.PENDING_DELIVERY;
                    }
                    ctt_contract_cost cost = new ctt_contract_cost()
                    {
                        id = _dal.GetNextIdCom(),
                        opportunity_id = costList[0].opportunity_id,
                        quote_item_id = quote_item.id,
                        cost_code_id = cost_code_id,
                        product_id = costList[0].product_id,
                        name = quote_item.name,
                        description = quote_item.description,
                        date_purchased = DateTime.Now,
                        is_billable = 1,
                        bill_status = 0,
                        cost_type_id = (int)COST_TYPE.OPERATIONA,
                        status_id = status_id,
                        quantity = quote_item.quantity,
                        unit_price = quote_item.unit_price,
                        unit_cost = quote_item.unit_cost,
                        extended_price = quote_item.unit_price * quote_item.quantity,
                        create_user_id = user.id,
                        update_user_id = user.id,
                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        project_id = costList[0].project_id,
                        contract_id = costList[0].contract_id,
                        task_id = costList[0].task_id,
                        sub_cate_id = costList[0].sub_cate_id,
                    };
                    cccDal.Insert(cost);
                    OperLogBLL.OperLogAdd<ctt_contract_cost>(cost, cost.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "新增成本");
                }
            }

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 编辑报价项
        /// </summary>
        /// <param name="quote_item"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Update(crm_quote_item quote_item, Dictionary<long, int> wareDic, long user_id, bool isSaleOrder = false, long? saleOrderId = null)
        {
            if (quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT)
            {
                if (quote_item.unit_price == null || quote_item.unit_cost == null || quote_item.quantity == null || quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            else
            {
                if (string.IsNullOrEmpty(quote_item.name))
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
                if (quote_item.discount_percent == null && quote_item.unit_discount == null)
                {
                    return ERROR_CODE.PARAMS_ERROR;
                }
            }
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var old_quote_item = _dal.GetQuoteItem(quote_item.id);
            quote_item.oid = old_quote_item.oid;
            quote_item.update_user_id = user_id;
            quote_item.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            quote_item.tax_cate_id = quote_item.tax_cate_id == 0 ? null : quote_item.tax_cate_id;
            _dal.Update(quote_item);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                oper_object_id = quote_item.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(old_quote_item, quote_item),
                remark = "编辑报价项信息"
            });

            var oDal = new crm_opportunity_dal();
            var oppo = oDal.GetOpByItemID(quote_item.id);
            if (oppo != null && oppo.use_quote == 1)
            {
                if (quote_item.optional != 1 && quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES)
                {
                    decimal? changeRevenue = quote_item.quantity * quote_item.unit_price - old_quote_item.quantity * old_quote_item.unit_price;
                    decimal? changeCost = quote_item.quantity * quote_item.unit_cost - old_quote_item.quantity * old_quote_item.unit_cost;



                    switch (quote_item.period_type_id)
                    {
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME:
                            if (oppo.one_time_revenue != null)
                            {
                                oppo.one_time_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.one_time_revenue = changeRevenue;
                            }
                            if (oppo.one_time_cost != null)
                            {
                                oppo.one_time_cost += changeCost;
                            }
                            else
                            {
                                oppo.one_time_cost = changeCost;
                            }
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                            if (oppo.monthly_revenue != null)
                            {
                                oppo.monthly_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.monthly_revenue = changeRevenue;
                            }
                            if (oppo.monthly_cost != null)
                            {
                                oppo.monthly_cost += changeCost;
                            }
                            else
                            {
                                oppo.monthly_cost = changeCost;
                            }
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                            if (oppo.quarterly_revenue != null)
                            {
                                oppo.quarterly_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.quarterly_revenue = changeRevenue;
                            }
                            if (oppo.quarterly_cost != null)
                            {
                                oppo.quarterly_cost += changeCost;
                            }
                            else
                            {
                                oppo.quarterly_cost = changeCost;
                            }
                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                            if (oppo.semi_annual_revenue != null)
                            {
                                oppo.semi_annual_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.semi_annual_revenue = changeRevenue;
                            }
                            if (oppo.semi_annual_cost != null)
                            {
                                oppo.semi_annual_cost += changeCost;
                            }
                            else
                            {
                                oppo.semi_annual_cost = changeCost;
                            }

                            break;
                        case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                            if (oppo.yearly_revenue != null)
                            {
                                oppo.yearly_revenue += changeRevenue;
                            }
                            else
                            {
                                oppo.yearly_revenue = changeRevenue;
                            }
                            if (oppo.yearly_cost != null)
                            {
                                oppo.yearly_cost += changeCost;
                            }
                            else
                            {
                                oppo.yearly_cost = changeCost;
                            }

                            break;
                        default:
                            break;
                    }

                    // var udfDto = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
                    // var udfValue = 
                    OpportunityAddOrUpdateDto param = new OpportunityAddOrUpdateDto()
                    {
                        general = oppo,
                        udf = null,
                        notify = null
                    };
                    new OpportunityBLL().Update(param, user.id);
                }
            }


            if (quote_item.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT)
            {
                var irDal = new ivt_reserve_dal();
                var iwDal = new ivt_warehouse_dal();
                var oldReserList = irDal.GetListByItemId(quote_item.id);
                if (wareDic != null && wareDic.Count > 0)
                {
                    if (oldReserList != null && oldReserList.Count > 0)
                    {
                        foreach (var thisPageWare in wareDic)
                        {
                            var thisWareHouse = iwDal.FindNoDeleteById(thisPageWare.Key);

                            var thisOldReser = oldReserList.FirstOrDefault(_ => _.warehouse_id == thisPageWare.Key);
                            if (thisOldReser != null)
                            {
                                oldReserList.Remove(thisOldReser);
                                if (thisWareHouse != null)
                                {
                                    if (thisOldReser.quantity != thisPageWare.Value || thisOldReser.resource_id != thisWareHouse.resource_id)
                                    {
                                        thisOldReser.quantity = thisPageWare.Value;
                                        thisOldReser.resource_id = thisWareHouse.resource_id;
                                        var thisOld = irDal.FindNoDeleteById(thisOldReser.id);
                                        irDal.Update(thisOldReser);
                                        OperLogBLL.OperLogUpdate<ivt_reserve>(thisOldReser, thisOld, thisOldReser.id, user_id, OPER_LOG_OBJ_CATE.WAREHOUSE_RESERVE, "修改库存预留");
                                    }
                                }
                            }
                            else
                            {

                                if (thisWareHouse != null)
                                {
                                    var thisReserve = new ivt_reserve()
                                    {
                                        id = irDal.GetNextIdCom(),
                                        create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                        create_user_id = user_id,
                                        update_user_id = user_id,
                                        quote_item_id = quote_item.id,
                                        warehouse_id = thisPageWare.Key,
                                        quantity = thisPageWare.Value,
                                        resource_id = thisWareHouse.resource_id,
                                    };
                                    irDal.Insert(thisReserve);
                                    OperLogBLL.OperLogAdd<ivt_reserve>(thisReserve, thisReserve.id, user_id, OPER_LOG_OBJ_CATE.WAREHOUSE_RESERVE, "新增库存预留");
                                }
                            }
                        }
                    }
                    else
                    {
                        foreach (var thisPageWare in wareDic)
                        {
                            var thisWareHouse = iwDal.FindNoDeleteById(thisPageWare.Key);
                            if (thisWareHouse != null)
                            {
                                var thisReserve = new ivt_reserve()
                                {
                                    id = irDal.GetNextIdCom(),
                                    create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                    create_user_id = user_id,
                                    update_user_id = user_id,
                                    quote_item_id = quote_item.id,
                                    warehouse_id = thisPageWare.Key,
                                    quantity = thisPageWare.Value,
                                    resource_id = thisWareHouse.resource_id,
                                };
                                irDal.Insert(thisReserve);
                                OperLogBLL.OperLogAdd<ivt_reserve>(thisReserve, thisReserve.id, user_id, OPER_LOG_OBJ_CATE.WAREHOUSE_RESERVE, "新增库存预留");
                            }
                        }
                    }
                }

                if (oldReserList != null && oldReserList.Count > 0)
                {
                    oldReserList.ForEach(_ =>
                    {
                        irDal.SoftDelete(_, user_id);
                        OperLogBLL.OperLogDelete<ivt_reserve>(_, _.id, user_id, OPER_LOG_OBJ_CATE.WAREHOUSE_RESERVE, "删除库存预留");
                    });
                }
            }


            if (isSaleOrder && saleOrderId != null&& (quote_item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.PRODUCT || quote_item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DEGRESSION || quote_item.type_id == (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES))
            {
                var cccDal = new ctt_contract_cost_dal();
                var thisCost = cccDal.GetSinBuQuoteItem(quote_item.id);
                if (thisCost != null)
                {
                    long? product_id = thisCost.product_id;
                    int status_id = thisCost.status_id;
                    long cost_code_id = thisCost.cost_code_id;
                    if (quote_item.type_id == (int)QUOTE_ITEM_TYPE.PRODUCT)
                    {
                        product_id = quote_item.object_id;
                        status_id = thisCost.status_id;
                        var thisProduct = new ivt_product_dal().FindNoDeleteById((long)quote_item.object_id);
                        if (thisProduct != null)
                        {
                            cost_code_id = thisProduct.cost_code_id;
                        }
                        else
                        {
                            return ERROR_CODE.ERROR;
                        }
                        if (status_id != (int)COST_STATUS.UNDETERMINED && status_id != (int)COST_STATUS.PENDING_APPROVAL && status_id != (int)COST_STATUS.CANCELED)
                        {
                            if (thisCost.quantity != quote_item.quantity)
                            {
                                status_id = (int)COST_STATUS.PENDING_PURCHASE;
                                var appSet = new SysSettingBLL().GetSetById(DTO.SysSettingEnum.CTT_COST_APPROVAL_VALUE);
                                if (appSet != null && !string.IsNullOrEmpty(appSet.setting_value)&& thisProduct.does_not_require_procurement == 1)
                                {
                                    if (((decimal)quote_item.quantity * (decimal)quote_item.unit_price) > decimal.Parse(appSet.setting_value)) // 金额超出（待审批）
                                    {
                                        status_id = (int)COST_STATUS.PENDING_APPROVAL;
                                    }
                                }
                            }

                        }
                    }
                    thisCost.product_id = product_id;
                    thisCost.cost_code_id = cost_code_id;
                    thisCost.name = quote_item.name;
                    thisCost.description = quote_item.description;
                    thisCost.unit_price = quote_item.unit_price;
                    thisCost.unit_cost = quote_item.unit_cost;
                    thisCost.quantity = quote_item.quantity;
                    thisCost.status_id = status_id;

                    var olderCost = cccDal.FindNoDeleteById(thisCost.id);
                    cccDal.Update(thisCost);
                    OperLogBLL.OperLogUpdate<ctt_contract_cost>(thisCost, olderCost, thisCost.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本");

                }
            }

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 删除报价项
        /// </summary>
        /// <param name="quote_item_id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteQuoteItem(long quote_item_id, long user_id)
        {
            // todo 报价如果关联了销售订单，则不可删除报价项  -- 验证 
            var quote_item = _dal.GetQuoteItem(quote_item_id);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (quote_item != null && user != null)
            {
                var isSaleOrder = new QuoteBLL().CheckRelatSaleOrder(quote_item_id);
                if (isSaleOrder)
                {
                    return false;
                }

                quote_item.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                quote_item.delete_user_id = user_id;
                _dal.Update(quote_item);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.QUOTE_ITEM,
                    oper_object_id = quote_item.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                    oper_description = _dal.AddValue(quote_item),
                    remark = "删除报价项"
                });

                var oDal = new crm_opportunity_dal();
                var oppo = oDal.GetOpByItemID(quote_item.id);
                if (oppo != null && oppo.use_quote == 1)
                {
                    if (quote_item.optional != 1 && quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISCOUNT && quote_item.type_id != (int)DicEnum.QUOTE_ITEM_TYPE.DISTRIBUTION_EXPENSES)
                    {
                        decimal? changeRevenue = quote_item.quantity * quote_item.unit_price;
                        decimal? changeCost = quote_item.quantity * quote_item.unit_cost;



                        switch (quote_item.period_type_id)
                        {
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.ONE_TIME:
                                if (oppo.one_time_revenue != null)
                                {
                                    oppo.one_time_revenue += changeRevenue;
                                }
                                else
                                {
                                    oppo.one_time_revenue = changeRevenue;
                                }
                                if (oppo.one_time_cost != null)
                                {
                                    oppo.one_time_cost += changeCost;
                                }
                                else
                                {
                                    oppo.one_time_cost = changeCost;
                                }
                                break;
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.MONTH:
                                if (oppo.monthly_revenue != null)
                                {
                                    oppo.monthly_revenue += changeRevenue;
                                }
                                else
                                {
                                    oppo.monthly_revenue = changeRevenue;
                                }
                                if (oppo.monthly_cost != null)
                                {
                                    oppo.monthly_cost += changeCost;
                                }
                                else
                                {
                                    oppo.monthly_cost = changeCost;
                                }
                                break;
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.QUARTER:
                                if (oppo.quarterly_revenue != null)
                                {
                                    oppo.quarterly_revenue += changeRevenue;
                                }
                                else
                                {
                                    oppo.quarterly_revenue = changeRevenue;
                                }
                                if (oppo.quarterly_cost != null)
                                {
                                    oppo.quarterly_cost += changeCost;
                                }
                                else
                                {
                                    oppo.quarterly_cost = changeCost;
                                }
                                break;
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.HALFYEAR:
                                if (oppo.semi_annual_revenue != null)
                                {
                                    oppo.semi_annual_revenue += changeRevenue;
                                }
                                else
                                {
                                    oppo.semi_annual_revenue = changeRevenue;
                                }
                                if (oppo.semi_annual_cost != null)
                                {
                                    oppo.semi_annual_cost += changeCost;
                                }
                                else
                                {
                                    oppo.semi_annual_cost = changeCost;
                                }

                                break;
                            case (int)DicEnum.QUOTE_ITEM_PERIOD_TYPE.YEAR:
                                if (oppo.yearly_revenue != null)
                                {
                                    oppo.yearly_revenue += changeRevenue;
                                }
                                else
                                {
                                    oppo.yearly_revenue = changeRevenue;
                                }
                                if (oppo.yearly_cost != null)
                                {
                                    oppo.yearly_cost += changeCost;
                                }
                                else
                                {
                                    oppo.yearly_cost = changeCost;
                                }

                                break;
                            default:
                                break;
                        }

                        // var udfDto = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.OPPORTUNITY);
                        // var udfValue = 
                        OpportunityAddOrUpdateDto param = new OpportunityAddOrUpdateDto()
                        {
                            general = oppo,
                            udf = null,
                            notify = null
                        };
                        new OpportunityBLL().Update(param, user.id);
                    }
                }


                return true;

            }

            return false;
        }
        public List<crm_quote_item> GetAllQuoteItem(long id)
        {
            string sql = " and quote_id=" + id + " ";
            var list = _dal.GetQuoteItems(sql);
            return list;
        }

        // 计算出该报价下的所有一次姓报价项中包含税的报价项的折扣
        public decimal GetOneTimeMoneyTax(List<crm_quote_item> oneTimeList, crm_quote_item qItem)
        {

            // 按照金钱扣除的折扣转换成为百分比进行运算-- 暂时处理待测试
            // 折扣记录两种计费项。一个是一次性报价项当中含有税的，一个一次性报价项当中不含有税的
            // 折扣的计费项命名  为含税和不含税这两种
            // 计费项的名称命名为报价项的名称
            decimal totalMoney = 0;
            var AllTotalMoney = GetAllMoney(oneTimeList);
            var taxItem = oneTimeList.Where(_ => _.period_type_id != null).ToList();
            totalMoney = GetAllMoney(taxItem);
            if (qItem.discount_percent != null)
            {
                totalMoney = totalMoney * (decimal)qItem.discount_percent;
            }
            else
            {
                totalMoney = totalMoney * ((decimal)qItem.unit_discount / AllTotalMoney);
            }
            return totalMoney;
        }
        // 计算出该报价下的所有一次姓报价项中不包含税的报价项的折扣
        public decimal GetOneTimeMoney(List<crm_quote_item> oneTimeList, crm_quote_item qItem)
        {
            decimal totalMoney = 0;
            var AllTotalMoney = GetAllMoney(oneTimeList);
            var noTaxItem = oneTimeList.Where(_ => _.period_type_id == null).ToList();
            totalMoney = GetAllMoney(noTaxItem);
            if (qItem.discount_percent != null)
            {
                totalMoney = totalMoney * (decimal)qItem.discount_percent;
            }
            else
            {
                totalMoney = totalMoney * ((decimal)qItem.unit_discount / AllTotalMoney);
            }
            return totalMoney;
        }
        /// <summary>
        /// 获取到这个一次性报价的总价
        /// </summary>
        /// <param name="oneTimeList"></param>
        /// <returns></returns>
        public decimal GetAllMoney(List<crm_quote_item> oneTimeList)
        {
            decimal totalMoney = 0;
            if (oneTimeList != null && oneTimeList.Count > 0)
            {
                totalMoney = (decimal)oneTimeList.Sum(_ => (_.unit_discount != null && _.unit_price != null && _.quantity != null) ? (_.unit_price - _.unit_discount) * _.quantity : 0);
            }
            return totalMoney;
        }
        /// <summary>
        /// 在销售订单下新增
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE InsertBySale(crm_quote_item param, long user_id)
        {
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 在销售订单下编辑
        /// </summary>
        /// <returns></returns>
        public ERROR_CODE EditBySale()
        {
            return ERROR_CODE.SUCCESS;
        }


    }
}
