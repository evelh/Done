
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_sales_order_dal : BaseDAL<crm_sales_order>
    {
        /// <summary>
        /// 根据条件返回多个销售订单
        /// </summary>
        /// <param name="where"></param>
        /// <returns></returns>
        public List<crm_sales_order> GetSalesOrderByWhere(string where = "")
        {
            if(where != "")
            {
                return FindListBySql<crm_sales_order>("select * from crm_sales_order where delete_time = 0 "+where);
            }
            return FindListBySql<crm_sales_order>("select * from crm_sales_order where delete_time = 0");
        }
        /// <summary>
        /// 根据查询条件查询到单个的销售订单
        /// </summary>
        /// <param name="where"></param>
        /// <returns></returns>
        public crm_sales_order GetSingleSalesOrderByWhere(string where = "")
        {
            if (where != "")
            {
                return FindSignleBySql<crm_sales_order>("select * from crm_sales_order where delete_time = 0 " + where);
            }
            return FindSignleBySql<crm_sales_order>("select * from crm_sales_order where delete_time = 0");
        }
        /// <summary>
        /// 根据id查询到单个的销售订单
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public crm_sales_order GetSingleSale(long id)
        {
            return FindSignleBySql<crm_sales_order>($"select * from crm_sales_order where delete_time = 0 and id = {id} ");
        }
        /// <summary>
        /// 根据成本id获取关联的销售订单
        /// </summary>
        public crm_sales_order GetOrderByCostId(long cost_id)
        {
            return FindSignleBySql<crm_sales_order>($"SELECT cso.* from crm_sales_order cso INNER join ctt_contract_cost ccc on cso.opportunity_id = ccc.opportunity_id where ccc.id = {cost_id} and cso.delete_time = 0 and ccc.delete_time = 0");
        }

    }
}
