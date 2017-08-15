using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_tax_region_cate_dal : BaseDAL<d_tax_region_cate>
    {

        public List<d_tax_region_cate> GetTaxRegionCate()
        {
            return FindListBySql<d_tax_region_cate>($"select * from d_tax_region_cate");
        }
    }

}