using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_warehouse_product_sn_dal : BaseDAL<ivt_warehouse_product_sn>
    {
        public List<ivt_warehouse_product_sn> GetSnByIds(string ids)
        {
            return FindListBySql<ivt_warehouse_product_sn>($"SELECT * from ivt_warehouse_product_sn where id in ({ids}) and delete_time = 0");
        }
    }

}
