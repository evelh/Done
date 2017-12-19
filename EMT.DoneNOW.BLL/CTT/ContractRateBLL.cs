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
    public class ContractRateBLL
    {
        private readonly ctt_contract_rate_dal dal = new ctt_contract_rate_dal();

        /// <summary>
        /// 获取一个合同可选的角色列表
        /// </summary>
        /// <param name="contractId"></param>
        /// <returns></returns>
        public List<sys_role> GetAvailableRoles(long contractId)
        {
            var list = new sys_role_dal().GetList();
            var exclusionList = new ctt_contract_exclusion_role_dal().FindListByContractId(contractId);

            if (exclusionList == null || exclusionList.Count == 0)
                return list;

            List<sys_role> roles = new List<sys_role>();
            foreach (var role in list)
            {
                if (!exclusionList.Exists(r => r.role_id == role.id))
                    roles.Add(role);
            }

            return roles;
        }

        /// <summary>
        /// 新增或编辑角色费率
        /// </summary>
        /// <param name="rate"></param>
        /// <param name="logUserId"></param>
        public void CreateOrUpdateRate(ctt_contract_rate rate, long logUserId)
        {
            rate.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            rate.update_user_id = logUserId;
            if (rate.id==0)
            {
                rate.id = dal.GetNextIdCom();
                rate.create_time = rate.update_time;
                rate.create_user_id = rate.update_user_id;
                dal.Insert(rate);
                OperLogBLL.OperLogAdd<ctt_contract_rate>(rate, rate.id, logUserId, DTO.DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_RATE, "新增合同费率");
            }
            else
            {
                var roleRate = dal.FindById(rate.id);
                roleRate.role_id = rate.role_id;
                roleRate.rate = rate.rate;
                roleRate.update_time = rate.update_time;
                roleRate.update_user_id = rate.update_user_id;
                dal.Update(roleRate);
                OperLogBLL.OperLogUpdate<ctt_contract_rate>(roleRate, dal.FindById(rate.id), roleRate.id, logUserId, DTO.DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_RATE, "编辑合同费率");
            }
        }

        /// <summary>
        /// 根据id查找合同角色费率
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ctt_contract_rate GetRoleRate(long id)
        {
            return dal.FindById(id);
        }

        /// <summary>
        /// 删除合同费率
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        public void DeleteRate(long id, long userId)
        {
            var rate = dal.FindById(id);
            rate.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            rate.delete_user_id = userId;
            dal.Update(rate);
            OperLogBLL.OperLogDelete<ctt_contract_rate>(rate, rate.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.CONTRACT_RATE, "删除合同费率");
        }
        /// <summary>
        /// 根据 物料代码Id 和 角色ID返回相关费率
        /// </summary>
        public decimal? GetRateByCodeAndRole(long cost_code_id,long role_id)
        {
            decimal? rate = null;
            var dccDal = new d_cost_code_dal();
            var srDal = new sys_role_dal();
            var thisCostCode = dccDal.FindNoDeleteById(cost_code_id);
            var thisRole = srDal.FindNoDeleteById(role_id);
            if (thisCostCode != null && thisRole != null)
            {
                switch (thisCostCode.billing_method_id)
                {
                    case (int)DicEnum.WORKTYPE_BILLING_METHOD.USE_ROLE_RATE:
                        rate = thisRole.hourly_rate;
                        break;
                    case (int)DicEnum.WORKTYPE_BILLING_METHOD.FLOAT_ROLE_RATE:
                        if (thisCostCode.rate_adjustment != null)
                        {
                            rate = (thisRole.hourly_rate + thisCostCode.rate_adjustment);
                        }
                        break;
                    case (int)DicEnum.WORKTYPE_BILLING_METHOD.RIDE_ROLE_RATE:
                        if (thisCostCode.rate_multiplier != null)
                        {
                            rate = (thisRole.hourly_rate * thisCostCode.rate_multiplier);
                        }
                        break;
                    case (int)DicEnum.WORKTYPE_BILLING_METHOD.USE_UDF_ROLE_RATE:
                        if (thisCostCode.custom_rate != null)
                        {
                            rate =  thisCostCode.custom_rate;
                        }
                        break;
                    case (int)DicEnum.WORKTYPE_BILLING_METHOD.BY_TIMES:
                        if (thisCostCode.flat_rate != null)
                        {
                            rate = thisCostCode.flat_rate;
                        }
                        break;
                    default:
                        break;
                }
            }
            return rate;
        } 
    }
}
