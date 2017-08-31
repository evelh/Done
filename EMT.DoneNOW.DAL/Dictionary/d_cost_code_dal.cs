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
    }
}
