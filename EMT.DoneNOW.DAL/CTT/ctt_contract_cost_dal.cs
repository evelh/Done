using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_cost_dal : BaseDAL<ctt_contract_cost>
    {
        /// <summary>
        /// 获取指定预付时间、预付费、事件ID关联的成本信息
        /// </summary>
        /// <param name="blockId"></param>
        /// <returns></returns>
        public List<ctt_contract_cost> FindByBlockId(long blockId)
        {
            string sql = $"SELECT * FROM ctt_contract_cost WHERE contract_block_id={blockId} AND delete_time=0";
            var list = FindListBySql(sql);
            if (list == null || list.Count == 0)
                return new List<ctt_contract_cost>();
            return list;
        }

        /// 根据项目Id 获取cost 
        public List<ctt_contract_cost> GetCostByProId(long project_id)
        {
            return FindListBySql<ctt_contract_cost>($"SELECT * FROM ctt_contract_cost where project_id = {project_id} and delete_time = 0");
        }
    }

}
