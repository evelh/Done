using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_cost_code_dal : BaseDAL<d_cost_code>
    {
        /// <summary>
        /// 根据ID返回单个的物料成本
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public d_cost_code GetSingleCostCode(long id)
        {
            return FindSignleBySql<d_cost_code>($"SELECT * from d_cost_code where id = {id} and delete_time = 0 ");
        }

        public List<d_cost_code> GetListCostCode(int cate_id)
        {
            return FindListBySql<d_cost_code>($"SELECT * from d_cost_code where cate_id = {cate_id} and delete_time = 0");
           
        }
        /// <summary>
        /// 根据条件获取相应的costCode
        /// </summary>
        public List<d_cost_code> GetCostCodeByWhere(int cate_id, string where = "")
        {
            return FindListBySql<d_cost_code>($"SELECT * from d_cost_code where cate_id = {cate_id} and delete_time = 0 "+where);

        }

        /// <summary>
        /// 根据合同Id 获取相关例外因素的工作类型
        /// </summary>
        public List<d_cost_code> GetConExsCode(long contract_id)
        {
            return FindListBySql<d_cost_code>($"SELECT * from d_cost_code where id in (SELECT cost_code_id FROM ctt_contract_exclusion_cost_code WHERE contract_id={contract_id} AND delete_time=0) and delete_time = 0 and cate_id = 1158");
        }

        /// <summary>
        /// 获取不在合同例外因素的工作类型
        /// </summary>
        public List<d_cost_code> GetNotConExsCode(long contract_id)
        {
            return FindListBySql<d_cost_code>($"SELECT * from d_cost_code where id not in (SELECT cost_code_id FROM ctt_contract_exclusion_cost_code WHERE contract_id=1377 AND delete_time=0) and delete_time = 0 and cate_id = 1158");
        }
     }
}
