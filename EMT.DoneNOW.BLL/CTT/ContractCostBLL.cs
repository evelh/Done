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
    }
}
