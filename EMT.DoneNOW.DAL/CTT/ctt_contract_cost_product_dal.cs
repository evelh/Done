
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ctt_contract_cost_product_dal : BaseDAL<ctt_contract_cost_product>
    {
        public List<ctt_contract_cost_product> GetListByCostId(long cost_id)
        {
            return FindListBySql<ctt_contract_cost_product>($"SELECT * from ctt_contract_cost_product where contract_cost_id = {cost_id} and delete_time = 0");
        }
    }
}
