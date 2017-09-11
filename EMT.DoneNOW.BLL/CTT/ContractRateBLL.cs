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
    }
}
