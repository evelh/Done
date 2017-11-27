using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_milestone_dal : BaseDAL<ctt_contract_milestone>
    {
        /// <summary>
        /// 查找对应合同id的所有里程碑
        /// </summary>
        /// <param name="contractId"></param>
        /// <returns></returns>
        public List<ctt_contract_milestone> FindListByContractId(long contractId)
        {
            string sql = $"SELECT * FROM ctt_contract_milestone WHERE contract_id={contractId} AND delete_time=0";
            return FindListBySql(sql);
        }
        /// <summary>
        /// 查找项目相对应的合同的里程碑 并且未被阶段关联的里程碑
        /// </summary>
        public List<PageMile> GetListByProId(long project_id)
        {
            return FindListBySql<PageMile>($"SELECT ccm.id ,'conMile' as type,ccm.`name` as `name` ,d.`name` as status ,d.id as status_id,ccm.dollars as amount,due_date as dueDate,'' as isAss from ctt_contract_milestone as ccm INNER JOIN ctt_contract as cc on ccm.contract_id = cc.id INNER JOIN pro_project as pp ON pp.contract_id = cc.id LEFT JOIN d_general as d on ccm.status_id = d.id where ccm.delete_time = 0 and cc.delete_time = 0 and pp.delete_time = 0 and pp.id = {project_id} and ccm.id not in (SELECT contract_milestone_id FROM sdk_task_milestone as stm where stm.delete_time=0)");
        }
    }

}
