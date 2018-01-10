using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class ContractCostBLL
    {
        private ctt_contract_cost_dal _dal = new ctt_contract_cost_dal();

        /// <summary>
        /// 新增成本
        /// </summary>
        /// <param name="param"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE InsertCost(AddChargeDto param, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            if (param.cost.cost_code_id == 0 || param.cost.status_id == 0 || param.cost.quantity == null || param.cost.quantity == 0 || param.cost.unit_cost == null ||  param.cost.unit_price == null ||  string.IsNullOrEmpty(param.cost.name))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }
            param.cost.id = _dal.GetNextIdCom();
            param.cost.service_id = param.cost.service_id == 0 ? null : param.cost.service_id;
            param.cost.cost_type_id = param.cost.cost_type_id == 0 ? null : param.cost.cost_type_id;
            param.cost.extended_price = param.cost.quantity * param.cost.unit_price;
            param.cost.create_user_id = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.cost.create_user_id = user.id;
            param.cost.update_user_id = user.id;
            param.cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (param.cost.status_id != (int)COST_STATUS.UNDETERMINED && param.cost.status_id != (int)COST_STATUS.PENDING_APPROVAL && param.cost.status_id != (int)COST_STATUS.CANCELED)
            {
                var appSet = new SysSettingBLL().GetSetById(DTO.SysSettingEnum.CTT_COST_APPROVAL_VALUE);
                if (appSet != null && !string.IsNullOrEmpty(appSet.setting_value))
                {
                    if (param.cost.extended_price > decimal.Parse(appSet.setting_value)) // 金额超出（待审批）
                    {
                        param.cost.status_id = (int)COST_STATUS.PENDING_APPROVAL;
                    }
                }
            }

            _dal.Insert(param.cost);
            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST,
                oper_object_id = param.cost.id,// 操作对象id
                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(param.cost),
                remark = "新增合同成本"
            });
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改成本
        /// </summary>
        /// <param name="param"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE UpdateCost(AddChargeDto param, long user_id, out bool isDelShipCost,out string isHasPurchaseOrder)
        {
            isDelShipCost = false;
            isHasPurchaseOrder = "";
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            if (param.cost.cost_code_id == 0 || param.cost.status_id == 0 || param.cost.quantity == null || param.cost.quantity == 0 || param.cost.unit_cost == null  || param.cost.unit_price == null ||  string.IsNullOrEmpty(param.cost.name))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }

            var oldCost = _dal.FindNoDeleteById(param.cost.id);

            param.cost.oid = oldCost.oid;
            param.cost.update_user_id = user.id;
            param.cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.cost.sub_cate_id = oldCost.sub_cate_id;
            param.cost.contract_id = oldCost.contract_id;
            param.cost.task_id = oldCost.task_id;
            param.cost.project_id = oldCost.project_id;
            if (param.cost.status_id != (int)COST_STATUS.UNDETERMINED && param.cost.status_id != (int)COST_STATUS.PENDING_APPROVAL && param.cost.status_id != (int)COST_STATUS.CANCELED)
            {
                var appSet = new SysSettingBLL().GetSetById(DTO.SysSettingEnum.CTT_COST_APPROVAL_VALUE);
                if (appSet != null && !string.IsNullOrEmpty(appSet.setting_value))
                {
                    if (param.cost.extended_price > decimal.Parse(appSet.setting_value)) // 金额超出（待审批）
                    {
                        param.cost.status_id = (int)COST_STATUS.PENDING_APPROVAL;
                    }
                }
            }

            new sys_oper_log_dal().Insert(new sys_oper_log()
            {
                user_cate = "用户",
                user_id = user.id,
                name = user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST,
                oper_object_id = param.cost.id,
                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.CompareValue(oldCost, param.cost),
                remark = "修改合同成本"
            });
            _dal.Update(param.cost);

            var cccpDal = new ctt_contract_cost_product_dal();
            if (param.cost.status_id == (int)COST_STATUS.CANCELED)
            {
                // 转换为取消时
                // 已配送成本产品 --> 取消配送
                // 成本相关成本产品 --> 删除
                // 成本的单位价格和单位成本更改为0
                var costProList = cccpDal.GetListByCostId(param.cost.id);
                if (costProList != null && costProList.Count > 0)
                {
                    #region 取消配送已经配送的成本产品
                    var shipItemList = costProList.Where(_ => _.status_id == (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION).ToList();
                    if (shipItemList != null && shipItemList.Count > 0)
                    {
                        int delNum = 0;  // 运费成本已经审批并提交--无法删除
                        foreach (var shipItem in shipItemList)
                        {
                            UnShipItem(shipItem.id, user_id, out isDelShipCost);
                            if (isDelShipCost)
                            {
                                delNum++;
                            }
                        }
                        if (delNum > 0)
                        {
                            isDelShipCost = true;
                        }
                    }
                    #endregion

                    #region 删除相关成本产品信息
                    foreach (var _ in costProList)
                    {
                        DeletCostProSn(_.id, user_id);
                        if (_.order_id != null)
                        {
                            isHasPurchaseOrder += _.order_id+",";
                        }
                        cccpDal.SoftDelete(_, user_id);
                        OperLogBLL.OperLogDelete<ctt_contract_cost_product>(_, _.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "删除成本关联产品");
                    }
                   
                    #endregion
                }
                #region 查看成本状态 以及价格信息等
                var thisCost = _dal.FindNoDeleteById(param.cost.id);
                if (thisCost != null)
                {

                    if (thisCost.status_id != (int)COST_STATUS.CANCELED || thisCost.unit_cost != 0 || thisCost.unit_price != 0)
                    {
                        var oldThisCost = _dal.FindNoDeleteById(param.cost.id);
                        thisCost.status_id = (int)COST_STATUS.CANCELED;
                        thisCost.unit_price = 0;
                        thisCost.unit_cost = 0;
                        thisCost.update_user_id = user_id;
                        thisCost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        _dal.Update(thisCost);
                        OperLogBLL.OperLogUpdate<ctt_contract_cost>(thisCost, oldThisCost, thisCost.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本信息");
                    }
                }
                #endregion
            }
            else
            {
                var oldQuantity = oldCost.quantity;
                var newQuantity = param.cost.quantity;
                bool isAdd = false;
                if (newQuantity > oldQuantity)
                {
                    isAdd = true;
                }

                ChangCostStatus(param.cost.id, user_id, isAdd);
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更改成本的计费状态（如果已经计费则不可以更改），更改is_billable，根据bill_status 判断是否审批并提交
        /// </summary>
        public string UpdateBillStatus(long cid, long user_id, int is_billable)
        {
            var conCost = _dal.FindNoDeleteById(cid);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (conCost != null && user != null)
            {
                if (conCost.bill_status == 1) //代表已经计费
                {
                    return "billed";
                }
                else
                {
                    if (conCost.is_billable == is_billable)
                    {
                        return "already";
                    }
                    else
                    {
                        conCost.is_billable = (sbyte)is_billable;
                        conCost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        conCost.update_user_id = user.id;
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST,
                            oper_object_id = conCost.id,
                            oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.CompareValue(_dal.FindNoDeleteById(cid), conCost),
                            remark = "修改是否作为计费项"
                        });
                        _dal.Update(conCost);
                        return "ok";
                    }
                }
            }
            return "404";
        }
        /// <summary>
        /// 批量更改是否可计费
        /// </summary>
        public bool UpdateManyBillStatus(string ids, long user_id, int is_billable)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            if (!string.IsNullOrEmpty(ids) && user != null)
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    UpdateBillStatus(long.Parse(id), user_id, is_billable);
                }
                return true;
            }
            return false;
        }
        /// <summary>
        /// 删除合同成本
        /// </summary>
        public bool DeleteContractCost(long cid, long user_id)
        {

            var conCost = _dal.FindNoDeleteById(cid);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (conCost != null && user != null && conCost.bill_status != 1)
            {
                var costCode = new d_cost_code_dal().FindNoDeleteById(conCost.cost_code_id);
                if (costCode.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.BLOCK_PURCHASE || costCode.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RETAINER_PURCHASE || costCode.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.TICKET_PURCHASE)
                {
                    return false;
                }
                else
                {
                    if (conCost.create_ci == 1)
                    {
                        conCost.status_id = (int)DicEnum.COST_STATUS.CANCELED;
                        OperLogBLL.OperLogUpdate<ctt_contract_cost>(conCost, _dal.FindNoDeleteById(conCost.id), conCost.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");
                        _dal.Update(conCost);

                    }
                    else
                    {
                        conCost.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        conCost.delete_user_id = user.id;
                        _dal.Update(conCost);
                        new sys_oper_log_dal().Insert(new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = user.id,
                            name = user.name,
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST,
                            oper_object_id = conCost.id,
                            oper_type_id = (int)DicEnum.OPER_LOG_TYPE.DELETE,
                            oper_description = _dal.AddValue(conCost),
                            remark = "删除合同成本"
                        });
                    }

                    return true;
                }
            }
            return false;
        }
        /// <summary>
        /// 批量删除合同成本
        /// </summary>
        public bool DeleteContractCosts(string ids, long user_id)
        {
            var user = BLL.UserInfoBLL.GetUserInfo(user_id);
            if (!string.IsNullOrEmpty(ids) && user != null)
            {
                var idList = ids.Split(',');
                foreach (var id in idList)
                {
                    DeleteContractCost(long.Parse(id), user_id);
                }
                return true;
            }
            return false;
        }

        /// <summary>
        /// 新增修改合同默认成本
        /// </summary>
        public bool ConDefCostAddOrUpdate(ctt_contract_cost_default conDefCost, long user_id)
        {
            try
            {
                var user = UserInfoBLL.GetUserInfo(user_id);
                var ccdDal = new ctt_contract_cost_default_dal();
                if (conDefCost.id == 0)
                {
                    var def_cha = new ctt_contract_cost_default_dal().GetSinCostDef(conDefCost.contract_id, conDefCost.cost_code_id);
                    if (def_cha != null)
                    {
                        return false;
                    }
                    conDefCost.id = ccdDal.GetNextIdCom();
                    conDefCost.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    conDefCost.create_user_id = user.id;
                    conDefCost.update_user_id = user.id;
                    conDefCost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    ccdDal.Insert(conDefCost);
                    new sys_oper_log_dal().Insert(new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = user.id,
                        name = user.name,
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_DEFAULT_COST,
                        oper_object_id = conDefCost.id,// 操作对象id
                        oper_type_id = (int)DicEnum.OPER_LOG_TYPE.ADD,
                        oper_description = ccdDal.AddValue(conDefCost),
                        remark = "添加合同内部成本"
                    });
                }
                else
                {
                    var oldCost = ccdDal.FindNoDeleteById(conDefCost.id);
                    if (oldCost != null && user != null)
                    {
                        var def_cha = new ctt_contract_cost_default_dal().GetSinCostDef(conDefCost.contract_id, conDefCost.cost_code_id);
                        if (def_cha != null && def_cha.id != conDefCost.id)
                        {
                            return false;
                        }
                        else
                        {
                            conDefCost.oid = oldCost.oid;
                            conDefCost.update_user_id = user.id;
                            conDefCost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            ccdDal.Update(conDefCost);
                            new sys_oper_log_dal().Insert(new sys_oper_log()
                            {
                                user_cate = "用户",
                                user_id = user.id,
                                name = user.name,
                                phone = user.mobile == null ? "" : user.mobile,
                                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                                oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_DEFAULT_COST,
                                oper_object_id = conDefCost.id,// 操作对象id
                                oper_type_id = (int)DicEnum.OPER_LOG_TYPE.UPDATE,
                                oper_description = ccdDal.CompareValue(oldCost, conDefCost),
                                remark = "修改合同默认成本"
                            });
                        }


                    }
                    else
                    {
                        return false;
                    }
                }
                return true;
            }
            catch (Exception e)
            {
                var a = e.Message;
                return false;
            }
        }
        /// <summary>
        /// 删除合同内部成本
        /// </summary>
        /// <param name="cdcID"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool DeleteConDefCost(long cdcID, long user_id)
        {
            var ccdDal = new ctt_contract_cost_default_dal();
            var user = UserInfoBLL.GetUserInfo(user_id);
            var conDefCost = ccdDal.FindNoDeleteById(cdcID);
            if (user != null && conDefCost != null)
            {
                ccdDal.SoftDelete(conDefCost, user_id);
                new sys_oper_log_dal().Insert(new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_DEFAULT_COST,
                    oper_object_id = conDefCost.id,// 操作对象id
                    oper_type_id = (int)DicEnum.OPER_LOG_TYPE.DELETE,
                    oper_description = ccdDal.AddValue(conDefCost),
                    remark = "删除合同默认成本"
                });
                return true;
            }
            return false;
        }

        /// <summary>
        /// 采购审批通过
        /// </summary>
        /// <param name="costId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool PurchaseApproval(long costId, long userId)
        {
            var cost = _dal.FindById(costId);
            if (cost == null || cost.status_id != (int)DicEnum.COST_STATUS.PENDING_APPROVAL)
                return false;

            var costOld = _dal.FindById(costId);
            cost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
            cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            cost.update_user_id = userId;
            _dal.Update(cost);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "采购审批通过");
            return true;
        }

        /// <summary>
        /// 采购审批拒绝
        /// </summary>
        /// <param name="costId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool PurchaseReject(long costId, long userId)
        {
            var cost = _dal.FindById(costId);
            if (cost == null || cost.status_id != (int)DicEnum.COST_STATUS.PENDING_APPROVAL)
                return false;

            var costOld = _dal.FindById(costId);
            cost.status_id = (int)DicEnum.COST_STATUS.UNDETERMINED;
            cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            cost.update_user_id = userId;
            _dal.Update(cost);
            OperLogBLL.OperLogUpdate(OperLogBLL.CompareValue<ctt_contract_cost>(costOld, cost), cost.id, userId, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "采购审批拒绝");
            return true;
        }
        /// <summary>
        /// 新增成本产品
        /// </summary>
        /// <returns></returns>
        public bool AddCostProduct(long cost_id, long product_id, long ware_id, int pickNum, string tranType, string snIds, long user_id)
        {
            try
            {
                var thisCost = _dal.FindNoDeleteById(cost_id);
                var thisPro = new ivt_product_dal().FindNoDeleteById(product_id);
                if (thisCost != null && thisPro != null)
                {
                    var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    var cccpDal = new ctt_contract_cost_product_dal();
                    var status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PICKED;
                    if (tranType == "toMe")
                    {
                        var thisRes = new sys_resource_dal().FindNoDeleteById(user_id);
                        if (thisRes == null)
                        {
                            return false;
                        }

                        var iwDal = new ivt_warehouse_dal();
                        var resWare = iwDal.GetSinByResId(user_id);
                        if (resWare == null)
                        {
                            resWare = new ivt_warehouse()
                            {
                                id = iwDal.GetNextIdCom(),
                                create_user_id = user_id,
                                create_time = timeNow,
                                update_time = timeNow,
                                update_user_id = user_id,
                                name = "员工：" + thisRes.name,
                                is_active = 1,
                                is_default = 0,
                                resource_id = user_id
                            };
                            iwDal.Insert(resWare);
                            OperLogBLL.OperLogAdd<ivt_warehouse>(resWare, resWare.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_LOCATION, "新增员工仓库");
                        }
                        ware_id = resWare.id;
                    }
                    else if (tranType == "toItem")
                    {
                        status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION;
                    }

                    var cccp = new ctt_contract_cost_product()
                    {
                        id = cccpDal.GetNextIdCom(),
                        create_user_id = user_id,
                        create_time = timeNow,
                        update_time = timeNow,
                        update_user_id = user_id,
                        contract_cost_id = cost_id,
                        warehouse_id = ware_id,
                        quantity = pickNum,
                        status_id = status_id,
                    };
                    cccpDal.Insert(cccp);
                    OperLogBLL.OperLogAdd<ctt_contract_cost_product>(cccp, cccp.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "新增成本关联产品");
                    if (thisPro.is_serialized == 1)
                    {
                        AddCostProductSn(cccp.id, snIds, pickNum, product_id, user_id);
                    }
                    return true;
                }
            }
            catch (Exception)
            {
                return false;
            }

            return false;
        }
        /// <summary>
        /// 批量添加产品串号
        /// </summary>
        public bool AddCostProductSn(long cccpId, string snIds, int pickNum, long product_id, long user_id)
        {

            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var iwpsDal = new ivt_warehouse_product_sn_dal();
            var cccpsDal = new ctt_contract_cost_product_sn_dal();
            if (!string.IsNullOrEmpty(snIds))
            {
                var snIdArr = snIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var snId in snIdArr)
                {
                    var thisSn = iwpsDal.FindNoDeleteById(long.Parse(snId));
                    if (thisSn != null)
                    {
                        var thisCostSn = new ctt_contract_cost_product_sn()
                        {
                            id = cccpsDal.GetNextIdCom(),
                            contract_cost_product_id = cccpId,
                            create_time = timeNow,
                            create_user_id = user_id,
                            sn = thisSn.sn,
                            update_time = timeNow,
                            update_user_id = user_id,
                        };
                        cccpsDal.Insert(thisCostSn);
                        OperLogBLL.OperLogAdd<ctt_contract_cost_product_sn>(thisCostSn, thisCostSn.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT_SN, "新增成本关联产品串号");
                    }
                }
                return true;
            }
            else if (pickNum > 0)
            {
                var thisCccp = new ctt_contract_cost_product_dal().FindNoDeleteById(cccpId);
                if (thisCccp != null && thisCccp.warehouse_id != null)
                {
                    var iwp = new ivt_warehouse_product_dal().GetSinWarePro((long)thisCccp.warehouse_id, product_id);
                    if (iwp != null)
                    {
                        var iwpSnList = iwpsDal.GetSnByWareProId(iwp.id);
                        if (iwpSnList != null && iwpSnList.Count > 0 && pickNum <= iwpSnList.Count)
                        {
                            iwpSnList = iwpSnList.Take(pickNum).ToList();
                            foreach (var iwpSn in iwpSnList)
                            {
                                var thisCostSn = new ctt_contract_cost_product_sn()
                                {
                                    id = cccpsDal.GetNextIdCom(),
                                    contract_cost_product_id = cccpId,
                                    create_time = timeNow,
                                    create_user_id = user_id,
                                    sn = iwpSn.sn,
                                    update_time = timeNow,
                                    update_user_id = user_id,
                                };
                                cccpsDal.Insert(thisCostSn);
                                OperLogBLL.OperLogAdd<ctt_contract_cost_product_sn>(thisCostSn, thisCostSn.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT_SN, "新增成本关联产品串号");
                            }
                        }
                    }
                }

            }
            return false;
        }
        /// <summary>
        /// 根据成本下的成本产品状态改变成本本身状态
        /// </summary>
        /// <param name="costId">成本Id</param>
        /// <param name="user_id"></param>
        /// <param name="IsAddNum">成本的数量跟原来相比是否有增加</param>
        public void ChangCostStatus(long costId, long user_id, bool IsAddNum = false)
        {
            var thisCost = _dal.FindNoDeleteById(costId);
            var proList = new ctt_contract_cost_product_dal().GetListByCostId(costId);
            if (thisCost != null && thisCost.product_id != null && proList != null && proList.Count > 0)
            {
                var thisProduct = new ivt_product_dal().FindNoDeleteById((long)thisCost.product_id);
                if (thisProduct == null)
                {
                    return;
                }
                var oldCostStatus = thisCost.status_id;
                if (proList.Sum(_ => _.quantity) == thisCost.quantity)
                {
                    // 只要存在采购中
                    if (proList.Any(_ => _.status_id == (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.ON_ORDER))
                    {
                        thisCost.status_id = (int)DicEnum.COST_STATUS.IN_PURCHASING;
                    }
                    else
                    {
                        thisCost.status_id = (int)DicEnum.COST_STATUS.PENDING_DELIVERY;
                        // 全部已拣货、待配送这两种状态
                        if (!proList.Any(_ => _.status_id != (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PICKED) && proList.Any(_ => _.status_id != (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION))
                        {
                            thisCost.status_id = (int)DicEnum.COST_STATUS.PENDING_DELIVERY;
                        }
                        // 全部已配送
                        else if (!proList.Any(_ => _.status_id != (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION))
                        {
                            thisCost.status_id = (int)DicEnum.COST_STATUS.ALREADY_DELIVERED;
                        }
                        else
                        {

                        }
                    }

                }
                else
                {
                    if (thisProduct.does_not_require_procurement == 1)
                    {
                        // 待采购
                        thisCost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
                    }
                    else
                    {
                        // 有未审批-- 待审批
                        // 有审批未通过 - 待定
                        if (IsAddNum)
                        {
                            thisCost.status_id = (int)DicEnum.COST_STATUS.PENDING_APPROVAL;
                        }
                        else
                        {
                            if(oldCostStatus!= (int)DicEnum.COST_STATUS.PENDING_APPROVAL)
                            {
                                thisCost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
                            }
                        }
                        //else
                        //{
                        //    thisCost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
                        //}
                    }
                }


                if (oldCostStatus != thisCost.status_id)
                {
                    // thisCost.status_id = oldCostStatus;
                    var oldCost = _dal.FindNoDeleteById(thisCost.id);
                    thisCost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    thisCost.update_user_id = user_id;
                    _dal.Update(thisCost);
                    OperLogBLL.OperLogUpdate<ctt_contract_cost>(thisCost, oldCost, thisCost.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");

                }

            }

        }
        /// <summary>
        /// 将库存转移给我
        /// </summary>
        /// <returns></returns>
        public bool TransToMe(long product_id, int pickNum, long ware_id, string snIds, long user_id)
        {
            try
            {
                var iwDal = new ivt_warehouse_dal();
                var thisRes = new sys_resource_dal().FindNoDeleteById(user_id);
                if (thisRes == null)
                {
                    return false;
                }
                var resWare = iwDal.GetSinByResId(user_id);
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (resWare == null)
                {
                    resWare = new ivt_warehouse()
                    {
                        id = iwDal.GetNextIdCom(),
                        create_user_id = user_id,
                        create_time = timeNow,
                        update_time = timeNow,
                        update_user_id = user_id,
                        name = "员工：" + thisRes.name,
                        is_active = 1,
                        is_default = 0,
                        resource_id = user_id
                    };
                    iwDal.Insert(resWare);
                    OperLogBLL.OperLogAdd<ivt_warehouse>(resWare, resWare.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_LOCATION, "新增员工仓库");
                }

                var itDal = new ivt_transfer_dal();
                var it = new ivt_transfer()
                {
                    id = itDal.GetNextIdCom(),
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    type_id = (int)INVENTORY_TRANSFER_TYPE.INVENTORY,
                    product_id = product_id,
                    from_warehouse_id = ware_id,
                    quantity = pickNum,
                    to_warehouse_id = resWare.id,
                };
                itDal.Insert(it);
                OperLogBLL.OperLogAdd<ivt_transfer>(it, it.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "新增库存转移");
                // 插入串号
                InsertTransSn(it.id, snIds, user_id);
                // 原来仓库数量减少  新仓库数量增多
                var iwpDal = new ivt_warehouse_product_dal();
                // 获取转移过来的原仓库产品信息
                var oldFromWarePro = iwpDal.GetSinWarePro(ware_id, product_id);
                if (oldFromWarePro == null)
                {
                    return false;
                }

                var fromWare = iwpDal.GetSinWarePro(resWare.id, product_id);

                if (fromWare == null)
                {
                    fromWare = new ivt_warehouse_product()
                    {
                        id = iwpDal.GetNextIdCom(),
                        product_id = product_id,
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = user_id,
                        update_user_id = user_id,
                        quantity = 0,
                        warehouse_id = resWare.id,
                        quantity_maximum = oldFromWarePro.quantity_maximum,
                        quantity_minimum = oldFromWarePro.quantity_minimum,

                    };

                    iwpDal.Insert(fromWare);

                    OperLogBLL.OperLogAdd<ivt_warehouse_product>(fromWare, fromWare.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "新增库存产品信息");
                }

                // 原仓库减少，目标仓库增多
                string[] sqlArr = new string[] { $"update ivt_warehouse_product set quantity=quantity-{pickNum},update_user_id={user_id},update_time={timeNow} where id={oldFromWarePro.id} and delete_time = 0", $"update ivt_warehouse_product set quantity=quantity+{pickNum},update_user_id={user_id},update_time={timeNow} where id={fromWare.id} and delete_time = 0" };
                var result = iwDal.SQLTransaction(null, sqlArr);
                if (result)
                {
                    var nowoldFromWarePro = iwpDal.FindNoDeleteById(oldFromWarePro.id);
                    var nowfromWare = iwpDal.FindNoDeleteById(fromWare.id);
                    OperLogBLL.OperLogUpdate<ivt_warehouse_product>(oldFromWarePro, nowoldFromWarePro, oldFromWarePro.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "仓库产品移出");
                    OperLogBLL.OperLogUpdate<ivt_warehouse_product>(fromWare, nowfromWare, fromWare.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "仓库产品移入");

                    // 修改相关串号信息
                    UpdateWareProSn(fromWare.id, snIds, user_id, oldFromWarePro.id);
                }
                else
                {
                    return false;
                }
                // SQLTransaction 执行事务

            }
            catch (Exception)
            {
                return false;
            }


            return true;
        }
        /// <summary>
        /// 插入库存转移串号
        /// </summary>
        public bool InsertTransSn(long transId, string snIds, long user_id)
        {
            if (!string.IsNullOrEmpty(snIds))
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var iwpsDal = new ivt_warehouse_product_sn_dal();
                var ccpsDal = new ctt_contract_cost_product_sn_dal();
                var itsDal = new ivt_transfer_sn_dal();
                var snIdArr = snIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                // 拣货时，snId 指仓库产品snID ，其余表示成本产品snId
                foreach (var snId in snIdArr)
                {
                    var thisSn = iwpsDal.FindNoDeleteById(long.Parse(snId));
                    if (thisSn != null)
                    {
                        var its = new ivt_transfer_sn()
                        {
                            id = itsDal.GetNextIdCom(),
                            transfer_id = transId,
                            create_time = timeNow,
                            create_user_id = user_id,
                            sn = thisSn.sn,
                            update_time = timeNow,
                            update_user_id = user_id,
                        };
                        itsDal.Insert(its);
                        OperLogBLL.OperLogAdd<ivt_transfer_sn>(its, its.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER_SN, "新增库存转移串号");
                    }
                    else
                    {
                        var thisConSn = ccpsDal.FindNoDeleteById(long.Parse(snId));
                        if (thisConSn != null)
                        {
                            var its = new ivt_transfer_sn()
                            {
                                id = itsDal.GetNextIdCom(),
                                transfer_id = transId,
                                create_time = timeNow,
                                create_user_id = user_id,
                                sn = thisConSn.sn,
                                update_time = timeNow,
                                update_user_id = user_id,
                            };
                            itsDal.Insert(its);
                            OperLogBLL.OperLogAdd<ivt_transfer_sn>(its, its.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER_SN, "新增库存转移串号");
                        }
                    }
                }
                return true;
            }
            return false;
        }

        /// <summary>
        /// 库存转移时改变仓库产品SN相关信息
        /// </summary>
        public bool UpdateWareProSn(long newWareProId, string snIds, long user_id, long oldWareProId)
        {
            var iwpsDal = new ivt_warehouse_product_sn_dal();
            var ccpsDal = new ctt_contract_cost_product_sn_dal();

            if (!string.IsNullOrEmpty(snIds))
            {
                var thisWarePro = new ivt_warehouse_product_dal().FindNoDeleteById(newWareProId);
                if (thisWarePro == null)
                {
                    return false;
                }
                var snArr = snIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                foreach (var snId in snArr)
                {
                    var thisSn = iwpsDal.FindNoDeleteById(long.Parse(snId));
                    if (thisSn == null)
                    {
                        var cttSn = ccpsDal.FindNoDeleteById(long.Parse(snId));
                        if (cttSn != null)
                        {
                            thisSn = iwpsDal.GetSnByWareAndSn(oldWareProId, cttSn.sn);
                        }
                    }

                    if (thisSn != null)
                    {
                        var oldSn = iwpsDal.FindNoDeleteById(thisSn.id);
                        thisSn.warehouse_product_id = newWareProId;
                        thisSn.update_time = timeNow;
                        thisSn.update_user_id = user_id;
                        iwpsDal.Update(thisSn);
                        OperLogBLL.OperLogUpdate<ivt_warehouse_product_sn>(thisSn, oldSn, oldSn.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "修改库存产品串号");
                    }
                }
            }

            // iwpsDal.GetSnByWareAndSn();
            return true;
        }
        /// <summary>
        ///  库存转移时改变成本产品SN相关信息
        /// </summary>
        /// <param name="newCostProId"></param>
        /// <param name="snIds"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public bool UpdateCostProSn(long newCostProId, long oldCostProId, string snIds, long user_id, int changeNum)
        {
            var iwpsDal = new ivt_warehouse_product_sn_dal();
            var cccpsDal = new ctt_contract_cost_product_sn_dal();
            var oldProList = cccpsDal.GetListByCostProId(oldCostProId);
            if (oldProList != null && oldProList.Count > 0)
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (!string.IsNullOrEmpty(snIds))
                {
                    var snArr = snIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                    foreach (var snId in snArr)
                    {
                        var sn = "";
                        var thisSn = iwpsDal.FindNoDeleteById(long.Parse(snId));
                        if (thisSn != null)
                        {
                            sn = thisSn.sn;
                        }
                        else
                        {
                            var conProSn = cccpsDal.FindNoDeleteById(long.Parse(snId));
                            if (conProSn != null)
                            {
                                sn = conProSn.sn;
                            }
                        }
                        if (string.IsNullOrEmpty(sn))
                        {
                            continue;
                        }
                        var thisCostProSn = oldProList.FirstOrDefault(_ => _.sn == sn);
                        if (thisCostProSn != null)
                        {
                            var oldProSn = cccpsDal.FindNoDeleteById(thisCostProSn.id);
                            thisCostProSn.contract_cost_product_id = newCostProId;
                            thisCostProSn.update_time = timeNow;
                            thisCostProSn.update_user_id = user_id;
                            cccpsDal.Update(thisCostProSn);
                            OperLogBLL.OperLogUpdate<ctt_contract_cost_product_sn>(thisCostProSn, oldProSn, thisCostProSn.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT_SN, "修改成本产品串号");

                        }
                    }
                }
                else if (changeNum > 0)
                {
                    oldProList = oldProList.Take(changeNum).ToList();
                    oldProList.ForEach(_ =>
                    {
                        var thisOldSn = cccpsDal.FindNoDeleteById(_.id);
                        if (thisOldSn != null)
                        {
                            _.contract_cost_product_id = newCostProId;
                            _.update_time = timeNow;
                            _.update_user_id = user_id;
                            cccpsDal.Update(_);
                            OperLogBLL.OperLogUpdate<ctt_contract_cost_product_sn>(_, thisOldSn, _.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT_SN, "修改成本产品串号");
                        }

                    });
                }

            }
            else
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 将库存配送给客户
        /// </summary>
        public bool TranToItem(long product_id, int pickNum, long ware_id, string snIds, long cost_id, long user_id)
        {
            try
            {
                var thisCost = new ctt_contract_cost_dal().FindNoDeleteById(cost_id);
                if (thisCost == null)
                {
                    return false;
                }
                crm_account thisAccount = null;
                var accBll = new CompanyBLL();
                long? contract_id = thisCost.contract_id;
                long? project_id = thisCost.project_id;
                long? task_id = thisCost.task_id;
                if (thisCost.contract_id != null)
                {
                    var thisContract = new ctt_contract_dal().FindNoDeleteById((long)thisCost.contract_id);
                    if (thisContract != null)
                    {
                        thisAccount = accBll.GetCompany(thisContract.account_id);
                    }
                }
                if (thisCost.project_id != null && thisAccount == null)
                {
                    var thisPeoject = new pro_project_dal().FindNoDeleteById((long)thisCost.project_id);
                    if (thisPeoject != null)
                    {
                        thisAccount = accBll.GetCompany(thisPeoject.account_id);
                    }
                }


                if (thisAccount == null)
                {
                    return false;
                }

                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var itDal = new ivt_transfer_dal();
                var it = new ivt_transfer()
                {
                    id = itDal.GetNextIdCom(),
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    type_id = (int)INVENTORY_TRANSFER_TYPE.PROJECT,
                    product_id = product_id,
                    from_warehouse_id = ware_id,
                    quantity = pickNum,
                    to_account_id = thisAccount.id,
                    to_contract_id = contract_id,
                    to_project_id = project_id,
                    to_task_id = task_id,
                };
                itDal.Insert(it);
                OperLogBLL.OperLogAdd<ivt_transfer>(it, it.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "新增库存转移");
                // 插入转运串号
                InsertTransSn(it.id, snIds, user_id);
                // 原仓库数量减少
                var iwpDal = new ivt_warehouse_product_dal();
                var thisFromWarePro = iwpDal.GetSinWarePro(ware_id, product_id);
                if (thisFromWarePro == null)
                {
                    return false;
                }
                var oldFromWarePro = iwpDal.GetSinWarePro(ware_id, product_id);
                thisFromWarePro.quantity -= pickNum;
                thisFromWarePro.update_time = timeNow;
                thisFromWarePro.update_user_id = user_id;
                iwpDal.Update(thisFromWarePro);
                OperLogBLL.OperLogUpdate<ivt_warehouse_product>(thisFromWarePro, oldFromWarePro, thisFromWarePro.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "仓库产品移出操作");
                // 产品串号删除
                DeleteSns(thisFromWarePro.id, snIds, user_id, pickNum);
            }
            catch (Exception msg)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 批量删除库存产品串号
        /// </summary>
        public bool DeleteSns(long iwpId, string snIds, long user_id, int pickNum)
        {
            var iwpsDal = new ivt_warehouse_product_sn_dal();
            var thisSnList = iwpsDal.GetSnByWareProId(iwpId);
            if (thisSnList != null && thisSnList.Count > 0)
            {
                if (!string.IsNullOrEmpty(snIds))
                {
                    var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    var snIdArr = snIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (var snId in snIdArr)
                    {
                        var thisSn = iwpsDal.FindNoDeleteById(long.Parse(snId));
                        if (thisSn != null)
                        {
                            iwpsDal.SoftDelete(thisSn, user_id);
                            OperLogBLL.OperLogDelete<ivt_warehouse_product_sn>(thisSn, thisSn.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "删除库存产品串号");

                        }
                    }
                    return true;
                }
                else if (pickNum > 0)
                {
                    thisSnList = thisSnList.Take(pickNum).ToList();
                    thisSnList.ForEach(_ =>
                    {
                        iwpsDal.SoftDelete(_, user_id);
                        OperLogBLL.OperLogDelete<ivt_warehouse_product_sn>(_, _.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "删除库存产品串号");
                    });
                }
            }

            return false;
        }
        /// <summary>
        /// 取消拣货操作
        /// </summary>
        /// <param name="cost_id">成本Id</param>
        /// <param name="product_id">产品Id</param>
        /// <param name="ware_id">仓库Id</param>
        /// <param name="pickNum">拣货数量</param>
        /// <param name="snIds">SN Id 集合</param>
        /// <param name="user_id">用户Id</param>
        /// <returns></returns>
        public bool UnPick(long cost_id, long product_id, long ware_id, int unPickNum, string snIds, long user_id, long costProId)
        {
            try
            {
                var cccpDal = new ctt_contract_cost_product_dal();
                var thisCostPro = cccpDal.FindNoDeleteById(costProId);
                if (thisCostPro != null)
                {

                    if (thisCostPro.quantity == unPickNum)
                    {
                        DeletCostProSn(thisCostPro.id, user_id, "", unPickNum);
                        cccpDal.SoftDelete(thisCostPro, user_id);
                        OperLogBLL.OperLogDelete<ctt_contract_cost_product>(thisCostPro, thisCostPro.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "删除成本关联产品");
                    }
                    else
                    {
                        DeletCostProSn(thisCostPro.id, user_id, snIds, unPickNum);

                        var oldCostPro = cccpDal.FindNoDeleteById(costProId);
                        thisCostPro.quantity -= unPickNum;
                        thisCostPro.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        thisCostPro.update_user_id = user_id;
                        cccpDal.Update(thisCostPro);
                        OperLogBLL.OperLogUpdate<ctt_contract_cost_product>(thisCostPro, oldCostPro, thisCostPro.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "修改成本关联产品");
                    }

                    var cccDal = new ctt_contract_cost_dal();
                    var thisConCost = cccDal.FindNoDeleteById(cost_id);
                    var thisProduct = new ivt_product_dal().FindNoDeleteById(product_id);
                    if (thisConCost != null && thisProduct != null)
                    {
                        var oldStatus = thisConCost.status_id;
                        thisConCost.status_id = (int)DicEnum.COST_STATUS.PENDING_PURCHASE;
                        if (thisProduct.does_not_require_procurement == 1)
                        {
                            thisConCost.status_id = (int)DicEnum.COST_STATUS.PENDING_APPROVAL;
                        }
                        if (oldStatus != thisConCost.status_id)
                        {
                            var oldConCost = cccDal.FindNoDeleteById(cost_id);
                            thisConCost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                            thisConCost.update_user_id = user_id;
                            cccDal.Update(thisConCost);
                            OperLogBLL.OperLogUpdate<ctt_contract_cost>(thisConCost, oldConCost, thisConCost.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本状态");
                        }
                    }
                }
            }
            catch (Exception msg)
            {
                return false;
            }

            return true;
        }
        /// <summary>
        /// 删除成本关联产品相关Sn信息
        /// </summary>
        /// <param name="costProId"></param>
        /// <param name="snIds"></param>
        /// <returns></returns>
        public bool DeletCostProSn(long costProId, long user_id, string snIds = "", int num = 0)
        {
            //  GetListByCostProId
            try
            {
                List<ctt_contract_cost_product_sn> snList = new List<ctt_contract_cost_product_sn>();
                var cccpsDal = new ctt_contract_cost_product_sn_dal();
                // 未输入 SN Ids 代表 取消全部
                if (!string.IsNullOrEmpty(snIds))
                {
                    snList = cccpsDal.GetSnByIds(snIds);
                }
                else
                {
                    snList = cccpsDal.GetListByCostProId(costProId);
                }
                if (snList != null && snList.Count > 0)
                {
                    if (num != 0)
                    {
                        snList = snList.Take(num).ToList();
                    }
                    snList.ForEach(_ =>
                    {
                        cccpsDal.SoftDelete(_, user_id);
                        OperLogBLL.OperLogDelete<ctt_contract_cost_product_sn>(_, _.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT_SN, "成本关联产品的串号");
                    });
                }
            }
            catch (Exception)
            {
                return false;
            }

            return true;
        }
        /// <summary>
        /// 库存转移给客户
        /// </summary>
        public bool TransferToAccount(long cost_id, long product_id, long ware_id, long account_id, int transNum, string snIds, long user_id, long costProId)
        {
            var cccpDal = new ctt_contract_cost_product_dal();
            var thisCostPro = cccpDal.FindNoDeleteById(costProId);
            if (thisCostPro != null)
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                var oldStatus = thisCostPro.status_id;
                thisCostPro.status_id = (int)CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION;
                if (oldStatus != thisCostPro.status_id)
                {
                    var oldCostPro = cccpDal.FindNoDeleteById(costProId);
                    thisCostPro.update_time = timeNow;
                    thisCostPro.update_user_id = user_id;
                    cccpDal.Update(thisCostPro);
                    OperLogBLL.OperLogUpdate<ctt_contract_cost_product>(thisCostPro, oldCostPro, thisCostPro.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "修改成本关联产品状态");
                }
            }

            return false;
        }
        /// <summary>
        /// 库存转移到指定仓库
        /// </summary>
        public bool TransToLocation(long product_id, int pickNum, long ware_id, string snIds, long locaId, long user_id, long cost_id, long costProId)
        {
            try
            {
                var iwDal = new ivt_warehouse_dal();
                var thisWare = iwDal.FindNoDeleteById(locaId);
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                if (thisWare == null)
                {
                    return false;
                }
                #region 创建库存转移相关记录
                var itDal = new ivt_transfer_dal();
                var it = new ivt_transfer()
                {
                    id = itDal.GetNextIdCom(),
                    create_time = timeNow,
                    update_time = timeNow,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    type_id = (int)INVENTORY_TRANSFER_TYPE.INVENTORY,
                    product_id = product_id,
                    from_warehouse_id = ware_id,
                    quantity = pickNum,
                    to_warehouse_id = thisWare.id,
                };
                itDal.Insert(it);
                OperLogBLL.OperLogAdd<ivt_transfer>(it, it.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "新增库存转移");
                // 插入串号
                InsertTransSn(it.id, snIds, user_id);
                #endregion

                #region 修改成本产品的仓库ID
                //                //7.	全部转移：更新成本产品（ctt_contract_cost_product）的仓库id为目标仓 库的   id
                //                8.部分转移：
                //1）创建新的成本产品记录（ctt_contract_cost_product），数量为转移数量、仓库为目标仓库 ； 相关  成本    产品  串号    （ctt_contract_cost_productsn）对应的主表id更新为新的成本产品表id
                //2）原成本产品的数量为原数量减去转移数量

                var cccpDal = new ctt_contract_cost_product_dal();
                var oldCccp = cccpDal.FindNoDeleteById(costProId);
                if (oldCccp == null)
                {
                    return false;
                }
                if (oldCccp.quantity == pickNum) // 数量相等进行修改仓库操作，数量不相等，修改数量操作
                {
                    var thisOld = cccpDal.FindNoDeleteById(costProId);
                    oldCccp.warehouse_id = locaId;
                    oldCccp.update_user_id = user_id;
                    oldCccp.update_time = timeNow;
                    cccpDal.Update(oldCccp);
                    OperLogBLL.OperLogUpdate<ctt_contract_cost_product>(oldCccp, thisOld, oldCccp.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "修改成本产品信息");
                }
                else if (oldCccp.quantity < pickNum)
                {
                    return false;
                }
                else
                {
                    var toCccp = new ctt_contract_cost_product()
                    {
                        id = cccpDal.GetNextIdCom(),
                        create_user_id = user_id,
                        create_time = timeNow,
                        update_time = timeNow,
                        update_user_id = user_id,
                        contract_cost_id = cost_id,
                        warehouse_id = locaId,
                        quantity = 0,
                        status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PICKED,
                    };
                    cccpDal.Insert(toCccp);
                    OperLogBLL.OperLogAdd<ctt_contract_cost_product>(toCccp, toCccp.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "新增成本关联产品");
                    // AddCostProductSn(toCccp.id, snIds, user_id);

                    // 改变原来的数量
                    // 改变转移的数量
                    // 修改相关串号信息
                    string[] costProSqlArr = new string[] { $"update ctt_contract_cost_product set quantity=quantity-{pickNum},update_user_id={user_id},update_time={timeNow} where id={oldCccp.id} and delete_time = 0", $"update ivt_warehouse_product set quantity=quantity+{pickNum},update_user_id={user_id},update_time={timeNow} where id={toCccp.id} and delete_time = 0" };
                    var costProResult = iwDal.SQLTransaction(null, costProSqlArr);
                    if (costProResult)
                    {
                        UpdateCostProSn(toCccp.id, oldCccp.id, snIds, user_id, pickNum);
                    }
                    else
                    {
                        return false;
                    }


                }
                #endregion


                #region 修改仓库对应的数量
                // 原来仓库数量减少  新仓库数量增多
                var iwpDal = new ivt_warehouse_product_dal();
                // 获取转移过来的原仓库产品信息
                var oldFromWarePro = iwpDal.GetSinWarePro(ware_id, product_id);
                if (oldFromWarePro == null)
                {
                    return false;
                }

                var fromWare = iwpDal.GetSinWarePro(thisWare.id, product_id);

                if (fromWare == null)
                {
                    fromWare = new ivt_warehouse_product()
                    {
                        id = iwpDal.GetNextIdCom(),
                        product_id = product_id,
                        create_time = timeNow,
                        update_time = timeNow,
                        create_user_id = user_id,
                        update_user_id = user_id,
                        quantity = 0,
                        warehouse_id = thisWare.id,
                        quantity_maximum = oldFromWarePro.quantity_maximum,
                        quantity_minimum = oldFromWarePro.quantity_minimum,

                    };

                    iwpDal.Insert(fromWare);

                    OperLogBLL.OperLogAdd<ivt_warehouse_product>(fromWare, fromWare.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "新增库存产品信息");
                }

                // 原仓库减少，目标仓库增多
                string[] sqlArr = new string[] { $"update ivt_warehouse_product set quantity=quantity-{pickNum},update_user_id={user_id},update_time={timeNow} where id={oldFromWarePro.id} and delete_time = 0", $"update ivt_warehouse_product set quantity=quantity+{pickNum},update_user_id={user_id},update_time={timeNow} where id={fromWare.id} and delete_time = 0" };
                var result = iwDal.SQLTransaction(null, sqlArr);
                if (result)
                {
                    var nowoldFromWarePro = iwpDal.FindNoDeleteById(oldFromWarePro.id);
                    var nowfromWare = iwpDal.FindNoDeleteById(fromWare.id);
                    OperLogBLL.OperLogUpdate<ivt_warehouse_product>(oldFromWarePro, nowoldFromWarePro, oldFromWarePro.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "仓库产品移出");
                    OperLogBLL.OperLogUpdate<ivt_warehouse_product>(fromWare, nowfromWare, fromWare.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "仓库产品移入");

                    // 修改相关串号信息
                    UpdateWareProSn(fromWare.id, snIds, user_id, oldFromWarePro.id);
                }
                else
                {
                    return false;
                }
                #endregion



            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 获取成本的客户Id
        /// </summary>
        public long? GetAccountIdByCostId(long cost_id)
        {
            long? account_id = null;
            var thisCost = _dal.FindNoDeleteById(cost_id);
            if (thisCost != null)
            {
                if (thisCost.contract_id != null)
                {
                    var thisCon = new ctt_contract_dal().FindNoDeleteById((long)thisCost.contract_id);
                    if (thisCon != null)
                    {
                        account_id = thisCon.account_id;
                    }
                }
                else if (thisCost.project_id != null)
                {
                    var thisPro = new pro_project_dal().FindNoDeleteById((long)thisCost.project_id);
                    if (thisPro != null)
                    {
                        account_id = thisPro.account_id;
                    }
                }
                else if (thisCost.task_id != null)
                {
                    var thisTask = new sdk_task_dal().FindNoDeleteById((long)thisCost.task_id);
                    if (thisTask != null)
                    {
                        account_id = thisTask.account_id;
                    }
                }
            }

            return account_id;
        }
        /// <summary>
        /// 配送-产品
        /// </summary>
        public bool ShipItem(long costId, long productId, long wareId, int shipNum, string serIds, DateTime shipTime, int? shipType, string shipRefNum, long user_id, long costProId, long? costCodeId, decimal? unit_price, decimal? unit_cost)
        {
            var oldCost = _dal.FindNoDeleteById(costId);
            if (oldCost == null)
            {
                return false;
            }
            #region 修改成本状态
            // -修改成本状态
            var cccpDal = new ctt_contract_cost_product_dal();
            var oldCostPro = cccpDal.FindNoDeleteById(costProId);
            if (oldCostPro == null)
            {
                return false;
            }
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            var operOldCostPro = cccpDal.FindNoDeleteById(costProId);
            ctt_contract_cost_product cccp = null;
            if (oldCostPro.quantity == shipNum)   // 数量相等-修改成本产品状态
            {
                oldCostPro.shipping_time = Tools.Date.DateHelper.ToUniversalTimeStamp(shipTime);
                oldCostPro.shipping_type_id = shipType;
                oldCostPro.shipping_reference_number = shipRefNum;
                oldCostPro.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION;
            }
            else
            {
                oldCostPro.quantity -= shipNum;

                cccp = new ctt_contract_cost_product()
                {
                    id = cccpDal.GetNextIdCom(),
                    create_user_id = user_id,
                    create_time = timeNow,
                    update_time = timeNow,
                    update_user_id = user_id,
                    contract_cost_id = costId,
                    warehouse_id = wareId,
                    quantity = shipNum,
                    status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.DISTRIBUTION,
                };
                cccpDal.Insert(cccp);
                OperLogBLL.OperLogAdd<ctt_contract_cost_product>(cccp, cccp.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "新增成本关联产品");
                // 修改相关Sn信息
                UpdateCostProSn(cccp.id, oldCostPro.id, serIds, user_id, shipNum);


            }
            oldCostPro.update_time = timeNow;
            oldCostPro.update_user_id = user_id;
            cccpDal.Update(oldCostPro);
            OperLogBLL.OperLogUpdate<ctt_contract_cost_product>(oldCostPro, operOldCostPro, oldCostPro.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "修改成本关联产品");


            #endregion

            #region 配送给客户
            TranToItem(productId, shipNum, wareId, serIds, costId, user_id);
            #endregion

            #region 生成运费成本
            // 输入运费的物料成本代码，就会生成新的成本ctt_contract_cost
            if (costCodeId != null)
            {
                string shipName = "";
                if (shipType != null)
                {
                    var thisShip = new d_general_dal().FindNoDeleteById((long)shipType);
                    if (thisShip != null)
                    {
                        shipName = thisShip.name;
                    }
                }
                var shipCost = new ctt_contract_cost()
                {
                    id = _dal.GetNextIdCom(),
                    contract_id = oldCost.contract_id,
                    product_id = null,
                    cost_code_id = (long)costCodeId,
                    name = shipName,
                    date_purchased = DateTime.Now,
                    cost_type_id = (int)DicEnum.COST_TYPE.OPERATIONA,
                    status_id = (int)DicEnum.COST_STATUS.ALREADY_DELIVERED,
                    is_billable = 1,
                    quantity = 1,
                    unit_price = unit_price,
                    unit_cost = unit_cost,
                    extended_price = unit_cost * unit_price,
                    //sub_cate_id = (int)DicEnum.BILLING_ENTITY_SUB_TYPE.
                    sub_cate_id = oldCost.sub_cate_id,
                    create_user_id = user_id,
                    update_user_id = user_id,
                    create_time = timeNow,
                    update_time = timeNow,
                };
                _dal.Insert(shipCost);
                OperLogBLL.OperLogAdd<ctt_contract_cost>(shipCost, shipCost.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_COST, "新增成本");
                if (cccp != null)
                {
                    var thisCCCP = cccpDal.FindNoDeleteById(cccp.id);
                    if (thisCCCP != null)
                    {
                        var oldThisCccp = cccpDal.FindNoDeleteById(cccp.id);
                        thisCCCP.shipping_contract_cost_id = shipCost.id;
                        thisCCCP.update_time = timeNow;
                        thisCCCP.update_user_id = user_id;
                        cccpDal.Update(thisCCCP);
                        OperLogBLL.OperLogUpdate<ctt_contract_cost_product>(thisCCCP, oldThisCccp, thisCCCP.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "修改成本关联产品");
                    }

                }
                else
                {
                    var thisCostPRo = cccpDal.FindNoDeleteById(costProId);
                    if (thisCostPRo != null)
                    {
                        var oldThisCccp = cccpDal.FindNoDeleteById(costProId);
                        thisCostPRo.shipping_contract_cost_id = shipCost.id;
                        thisCostPRo.update_time = timeNow;
                        thisCostPRo.update_user_id = user_id;
                        cccpDal.Update(thisCostPRo);
                        OperLogBLL.OperLogUpdate<ctt_contract_cost_product>(thisCostPRo, oldThisCccp, thisCostPRo.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "修改成本关联产品");
                    }
                }
            }
            #endregion

            #region 发送邮件
            // todo 邮件中放入 html 代码
            #endregion
            return true;
        }

        /// <summary>
        /// 取消拣货
        /// </summary>
        public bool UnShipItem(long costProId, long user_id, out bool isDelete)
        {
            isDelete = true;
            var cccpDal = new ctt_contract_cost_product_dal();

            #region 修改成本和成本产品状态
            var thisCostPro = cccpDal.FindNoDeleteById(costProId);
            if (thisCostPro == null)
            {
                return false;
            }
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (thisCostPro.status_id != (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION)
            {
                var oldThisCostPro = cccpDal.FindNoDeleteById(costProId);
                thisCostPro.status_id = (int)DicEnum.CONTRACT_COST_PRODUCT_STATUS.PENDING_DISTRIBUTION;
                thisCostPro.update_time = timeNow;
                thisCostPro.update_user_id = user_id;
                cccpDal.Update(thisCostPro);
                OperLogBLL.OperLogUpdate<ctt_contract_cost_product>(thisCostPro, oldThisCostPro, thisCostPro.id, user_id, OPER_LOG_OBJ_CATE.CTT_CONTRACT_COST_PRODUCT, "修改成本关联产品");
            }
            var thisCost = _dal.FindNoDeleteById(thisCostPro.contract_cost_id);
            if (thisCost == null)
            {
                return false;
            }
            if (thisCost.status_id == (int)DicEnum.COST_STATUS.ALREADY_DELIVERED)
            {
                var oldThisCost = _dal.FindNoDeleteById(thisCost.id);
                thisCost.status_id = (int)DicEnum.COST_STATUS.PENDING_DELIVERY;
                thisCost.update_time = timeNow;
                thisCost.update_user_id = user_id;
                _dal.Update(thisCost);
                OperLogBLL.OperLogUpdate<ctt_contract_cost>(thisCost, oldThisCost, thisCost.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "修改成本");
            }

            #endregion
            var thisCostProSnList = new ctt_contract_cost_product_sn_dal().GetListByCostProId(costProId);
            #region 插入转运相关信息（串号）
            var itDal = new ivt_transfer_dal();
            var it = new ivt_transfer()
            {
                id = itDal.GetNextIdCom(),
                create_time = timeNow,
                update_time = timeNow,
                create_user_id = user_id,
                update_user_id = user_id,
                type_id = (int)INVENTORY_TRANSFER_TYPE.PROJECT,
                product_id = (long)thisCost.product_id,
                from_warehouse_id = (long)thisCostPro.warehouse_id,
                quantity = 0 - thisCostPro.quantity,
                //to_warehouse_id = (long)thisCostPro.warehouse_id,
                to_account_id = GetAccountIdByCostId(thisCost.id),
                to_contract_id = thisCost.contract_id,
                to_project_id = thisCost.project_id,
                to_task_id = thisCost.task_id,
            };
            itDal.Insert(it);
            OperLogBLL.OperLogAdd<ivt_transfer>(it, it.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER, "新增库存转移");
            // 插入串号
            // InsertTransSn(it.id, snIds, user_id);
            if (thisCostProSnList != null && thisCostProSnList.Count > 0)
            {
                var itsDal = new ivt_transfer_sn_dal();
                thisCostProSnList.ForEach(_ =>
                {
                    var its = new ivt_transfer_sn()
                    {
                        id = itsDal.GetNextIdCom(),
                        transfer_id = it.id,
                        create_time = timeNow,
                        create_user_id = user_id,
                        sn = _.sn,
                        update_time = timeNow,
                        update_user_id = user_id,
                    };
                    itsDal.Insert(its);
                    OperLogBLL.OperLogAdd<ivt_transfer_sn>(its, its.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_TRANSFER_SN, "新增库存转移串号");
                });
            }
            #endregion

            #region 库存变更信息
            var iwpDal = new ivt_warehouse_product_dal();

            var thisWarePro = iwpDal.GetSinWarePro((long)thisCostPro.warehouse_id, (long)thisCost.product_id);
            if (thisWarePro != null)
            {
                var oldThisWarePro = iwpDal.FindNoDeleteById(thisWarePro.id);
                thisWarePro.quantity += thisCostPro.quantity;
                thisWarePro.update_time = timeNow;
                thisWarePro.update_user_id = user_id;
                iwpDal.Update(thisWarePro);
                OperLogBLL.OperLogUpdate<ivt_warehouse_product>(thisWarePro, oldThisWarePro, thisWarePro.id, user_id, OPER_LOG_OBJ_CATE.INVENTORY_ITEM, "仓库产品移入");
                if (thisCostProSnList != null && thisCostProSnList.Count > 0)
                {
                    var iwpsDal = new ivt_warehouse_product_sn_dal();
                    thisCostProSnList.ForEach(_ =>
                    {
                        var its = new ivt_warehouse_product_sn()
                        {
                            id = iwpsDal.GetNextIdCom(),
                            warehouse_product_id = thisWarePro.id,
                            create_time = timeNow,
                            create_user_id = user_id,
                            sn = _.sn,
                            update_time = timeNow,
                            update_user_id = user_id,
                        };
                        iwpsDal.Insert(its);
                        OperLogBLL.OperLogAdd<ivt_warehouse_product_sn>(its, its.id, user_id, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_ITEM_SN, "新增库存转移串号");
                    });
                }

            }
            #endregion

            #region 删除运费成本
            if (thisCostPro.shipping_contract_cost_id != null)
            {
                var thisShipCost = _dal.FindNoDeleteById((long)thisCostPro.shipping_contract_cost_id);
                if (thisShipCost != null)
                {
                    if (thisShipCost.bill_status == 1)
                    {
                        isDelete = false;
                    }
                    else
                    {
                        _dal.SoftDelete(thisShipCost, user_id);
                        OperLogBLL.OperLogDelete<ctt_contract_cost>(thisShipCost, thisShipCost.id, user_id, OPER_LOG_OBJ_CATE.CONTRACT_COST, "删除成本");
                    }
                }
            }
            #endregion

            return true;
        }
    }
}
