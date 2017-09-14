using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

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
            var exclusionList = new ctt_contract_exclusion_role_dal().GetList(contractId);

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
    }
}
