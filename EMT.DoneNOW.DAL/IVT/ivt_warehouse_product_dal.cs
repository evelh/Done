using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_warehouse_product_dal : BaseDAL<ivt_warehouse_product>
    {
        /// <summary>
        /// 根据仓库和产品Id 获取唯一的仓库产品信息
        /// </summary>
        public ivt_warehouse_product GetSinWarePro(long ware_id,long product_id)
        {
            return FindSignleBySql<ivt_warehouse_product>($"SELECT * from ivt_warehouse_product where warehouse_id = {ware_id} and product_id = {product_id} and delete_time = 0");
        }
    }
}
