using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_product_vendor_dal : BaseDAL<ivt_product_vendor>
    {

        public ivt_product_vendor GetDefault(long product_id)
        {
            return FindSignleBySql<ivt_product_vendor>($"SELECT * from ivt_product_vendor where delete_time= 0 and product_id = {product_id} and is_default = 1");
            // 
        }
    }

}