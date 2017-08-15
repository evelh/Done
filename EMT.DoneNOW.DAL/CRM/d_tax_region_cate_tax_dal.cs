using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_tax_region_cate_tax_dal : BaseDAL<d_tax_region_cate_tax>
    {

        public List<d_tax_region_cate_tax> GetTaxRegionCate(long tax_region_cate_id)
        {
            return FindListBySql<d_tax_region_cate_tax>($"select * from d_tax_region_cate_tax where tax_region_cate_id = {tax_region_cate_id}");
        }
    }

}