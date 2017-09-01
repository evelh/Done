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
        private readonly ivt_product_dal _dal = new ivt_product_dal();
        private readonly ivt_product_vendor_dal _dal1 = new ivt_product_vendor_dal();
        public ivt_product GetProduct(long id)
        {
            return _dal.FindSignleBySql<ivt_product>($"select * from ivt_product where id={id} and delete_time = 0 ");
        }
        public string cost_code_name(long cost_code_id) {
            return new d_cost_code_dal().FindById(cost_code_id).name;
        }
        public ivt_product_vendor GetSingelVendor(long id)
        {
            return _dal1.FindSignleBySql<ivt_product_vendor>($"select * from ivt_product_vendor where id={id} and delete_time=0");
        }
        public string GetVendorName(long id)
        {
            return new crm_account_dal().FindSignleBySql<crm_account>($"select * from crm_account where id={id} and delete_time=0").name;
        }
        /// <summary>
        /// 通过产品id,返回供应商对象集合
        /// </summary>
        /// <param name="product_id"></param>
        /// <returns></returns>
        public List<ivt_product_vendor> GetVendorList(long product_id)
        {
            return _dal1.FindListBySql<ivt_product_vendor>($"select * from ivt_product_vendor where product_id={product_id} and delete_time=0").ToList();
        }
    }
}
