using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class d_tax_region_cate_dal : BaseDAL<d_tax_region_cate>
    {

        public List<d_tax_region_cate> GetTaxRegionCate(long? tax_region_id)
        {
            if (tax_region_id != null)
            {
                return FindListBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id = {tax_region_id} ");
            }
            return FindListBySql<d_tax_region_cate>($"select * from d_tax_region_cate");
        }
        /// <summary>
        /// 根据税区和税种获取税相关信息
        /// </summary>
        public d_tax_region_cate GetSingleTax(long tax_region_id,long tax_cate_id)
        {
            return FindSignleBySql<d_tax_region_cate>($"select * from d_tax_region_cate where tax_region_id = {tax_region_id} and tax_cate_id = {tax_cate_id};");
        }

    }

}