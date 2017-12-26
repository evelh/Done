using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_order_product_dal : BaseDAL<ivt_order_product>
    {
        /// <summary>
        /// 获取该产品的第一条采购
        /// </summary>
        public ivt_order_product GetFirstByPro(long product_id)
        {
            return FindSignleBySql<ivt_order_product>($"SELECT  * from ivt_order_product where product_id = {product_id} ORDER BY create_time LIMIT 0,1");
        }
        /// <summary>
        /// 获取该产品的最近的采购
        /// </summary>
        public ivt_order_product GetLastByPro(long product_id)
        {
            return FindSignleBySql<ivt_order_product>($"SELECT  * from ivt_order_product where product_id = {product_id} ORDER BY create_time desc LIMIT 0,1");
        }
        /// <summary>
        /// 获取该产品的采购价格的平均价格
        /// </summary>
        public object GetAvgByPro(long product_id)
        {
            return GetSingle($"SELECT  AVG(unit_cost) from ivt_order_product where product_id = {product_id} ORDER BY create_time desc");
        }

    }

}
