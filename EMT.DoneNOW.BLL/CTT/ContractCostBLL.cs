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
    public  class ContractCostBLL
    {
        private ctt_contract_cost_dal _dal = new ctt_contract_cost_dal();

        /// <summary>
        /// 新增成本
        /// </summary>
        /// <param name="param"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE InsertCost(AddChargeDto param,long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            if (param.cost.cost_code_id==0||param.cost.status_id==0||param.cost.quantity == null|| param.cost.quantity==0||param.cost.unit_cost==null|| param.cost.unit_cost==0 || param.cost.unit_price == null || param.cost.unit_price == 0 || string.IsNullOrEmpty(param.cost.name))
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
            param.cost.sub_cate_id = (int)DicEnum.BILLING_ENTITY_SUB_TYPE.CONTRACT_COST;
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
        public ERROR_CODE UpdateCost(AddChargeDto param, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            if (param.cost.cost_code_id == 0 || param.cost.status_id == 0 || param.cost.quantity == null || param.cost.quantity == 0 || param.cost.unit_cost == null || param.cost.unit_cost == 0 || param.cost.unit_price == null || param.cost.unit_price == 0 || string.IsNullOrEmpty(param.cost.name))
            {
                return ERROR_CODE.PARAMS_ERROR;
            }

            var oldCost = _dal.FindNoDeleteById(param.cost.id);

            param.cost.oid = oldCost.oid;
            param.cost.update_user_id = user.id;
            param.cost.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            param.cost.sub_cate_id = oldCost.sub_cate_id;
            param.cost.contract_id = oldCost.contract_id;
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
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更改成本的计费状态（如果已经计费则不可以更改），更改is_billable，根据bill_status 判断是否审批并提交
        /// </summary>
        public string UpdateBillStatus(long cid,long user_id,int is_billable)
        {
            var conCost = _dal.FindNoDeleteById(cid);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (conCost != null&& user!=null)
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
        public bool UpdateManyBillStatus(string ids,long user_id,int is_billable)
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
        public bool DeleteContractCost(long cid,long user_id)
        {

            var conCost = _dal.FindNoDeleteById(cid);
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (conCost != null && user != null&&conCost.bill_status!=1)
            {
                var costCode = new d_cost_code_dal().FindNoDeleteById(conCost.cost_code_id);
                if(costCode.cate_id ==  (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.BLOCK_PURCHASE || costCode.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.RETAINER_PURCHASE || costCode.cate_id == (int)EMT.DoneNOW.DTO.DicEnum.COST_CODE_CATE.TICKET_PURCHASE)
                {
                    return false;
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
                    return true;
                }
            }
            return false;
        }
        /// <summary>
        /// 批量删除合同成本
        /// </summary>
        public bool DeleteContractCosts(string ids ,long user_id)
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
        public bool ConDefCostAddOrUpdate(ctt_contract_cost_default conDefCost,long user_id)
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
                        if(def_cha!=null&& def_cha.id!= conDefCost.id)
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
        public bool DeleteConDefCost(long cdcID,long user_id)
        {
            var ccdDal = new ctt_contract_cost_default_dal();
            var user = UserInfoBLL.GetUserInfo(user_id);
            var conDefCost = ccdDal.FindNoDeleteById(cdcID);
            if (user!=null&&conDefCost!=null)
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
    }
}
