
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_cost_product_sn_dal : BaseDAL<ctt_contract_cost_product_sn>
    {
        /// <summary>
        /// 根据成本关联产品 获取对应的串号信息
        /// </summary>
        /// <returns></returns>
        public List<ctt_contract_cost_product_sn> GetListByCostProId(long costProId)
        {
            return FindListBySql<ctt_contract_cost_product_sn>($"SELECT * from ctt_contract_cost_product_sn where contract_cost_product_id = {costProId} and delete_time = 0");
        }
        /// <summary>
        /// 根据仓库序列号Id和成本Id 获取相应的成本产品序列信息
        /// </summary>
        public List<ctt_contract_cost_product_sn> GetListByProAndSnIds(long costProId,string snIds)
        {
            return FindListBySql<ctt_contract_cost_product_sn>($"SELECT cccp.* from ctt_contract_cost_product_sn cccp inner join ivt_warehouse_product_sn iwps on cccp.sn = iwps.sn where cccp.delete_time = 0 and iwps.delete_time = 0 and iwps.id in ({snIds}) and cccp.contract_cost_product_id = {costProId} ");
        }
        /// <summary>
        /// 根据Ids获取相应串号
        /// </summary>
        public List<ctt_contract_cost_product_sn> GetSnByIds(string ids)
        {
            return FindListBySql<ctt_contract_cost_product_sn>($"SELECT * from ctt_contract_cost_product_sn where id in ({ids}) and delete_time = 0");
        }
    }
}
