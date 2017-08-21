
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
        /// 返回销售订单
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
        public crm_sales_order GetSingleSalesOrderByWhere(string where = "")
        {
            if (where != "")
            {
                return FindSignleBySql<crm_sales_order>("select * from crm_sales_order where delete_time = 0 " + where);
            }
            return FindSignleBySql<crm_sales_order>("select * from crm_sales_order where delete_time = 0");
        }

    }
}
