using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL.IVT
{
    public class ProductBLL
    {
        private ivt_product_dal _dal = new ivt_product_dal();
        public ivt_product GetProduct(long id)
        {
            return _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time = 0 ");
        }
    }
}
