
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
        /// <summary>
        /// 根据销售订单获取订单相关联的所有的成本的成本产品信息
        /// </summary>
        public List<ctt_contract_cost_product> GetListBySale(long sale_id)
        {
            return FindListBySql<ctt_contract_cost_product>($"SELECT * from ctt_contract_cost_product cccp where cccp.contract_cost_id in(SELECT ccc.id from ctt_contract_cost ccc  INNER join crm_sales_order cso on cso.opportunity_id = ccc.opportunity_id where cso.delete_time = 0 and ccc.delete_time = 0 and cso.id = {sale_id}) and cccp.delete_time = 0");
        }
    }
}
