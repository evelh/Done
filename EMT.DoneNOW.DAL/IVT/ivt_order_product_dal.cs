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
        public object GetFirstByPro(long product_id)
        {
            return GetSingle($"SELECT  ir.unit_cost from ivt_order_product iop INNER JOIN ivt_receive ir on ir.order_product_id = iop.id where iop.product_id = {product_id}  and iop.delete_time = 0 and  ir.delete_time = 0 ORDER BY ir.create_time LIMIT 0, 1");

        }
        /// <summary>
        /// 获取该产品的最近的采购
        /// </summary>
        public object GetLastByPro(long product_id)
        {
            return GetSingle($"SELECT  ir.unit_cost from ivt_order_product iop INNER JOIN ivt_receive ir on ir.order_product_id = iop.id where iop.product_id = {product_id}  and iop.delete_time = 0 and  ir.delete_time = 0 ORDER BY ir.create_time desc LIMIT 0, 1");
        }
        /// <summary>
        /// 获取该产品的采购价格的平均价格
        /// </summary>
        public object GetAvgByPro(long product_id)
        {
            return GetSingle($"SELECT  AVG(ir.unit_cost) from ivt_order_product iop INNER JOIN ivt_receive ir on ir.order_product_id = iop.id where iop.product_id = {product_id}  and iop.delete_time = 0 and  ir.delete_time = 0 ORDER BY ir.create_time desc");
        }

    }

}
