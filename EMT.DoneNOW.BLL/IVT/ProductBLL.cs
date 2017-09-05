using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;

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
        public Dictionary<string, object> GetField()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();

            dic.Add("Item_Type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.INSTALLED_PRODUCT_CATE)));              // 默认自定义配置项
            dic.Add("Period_Type", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.QUOTE_ITEM_PERIOD_TYPE)));              // 周期类型
            return dic;
        }
        /// <summary>
        /// 新增产品和相关供应商信息
        /// </summary>
        /// <param name="product">产品</param>
        /// <param name="vendordata">供应商集合</param>
        /// <param name="user_id">操作用户</param>
        /// <returns></returns>
        public ERROR_CODE InsertProductAndVendor(ivt_product product, VendorData vendordata,long user_id) {
            //产品
            product.id = (int)(_dal.GetNextIdCom());
            product.create_time=product.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            product.create_user_id = user_id;

            _dal.Insert(product);
            //供应商
            foreach (var ve in vendordata.VENDOR)
            {
                ivt_product_vendor veve = new ivt_product_vendor();
                if (ve.operate == 3) {
                    veve.id = (int)(_dal.GetNextIdCom());
                   veve.update_time= veve.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    veve.create_user_id = user_id;
                    veve.product_id = product.id;
                    veve.is_active = ve.is_active;
                    veve.is_default = ve.is_default;
                    veve.vendor_account_id = ve.vendor_account_id;
                    veve.vendor_cost = ve.vendor_cost;
                    veve.vendor_product_no = ve.vendor_product_no;
                    _dal1.Insert(veve);
                }
            }

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 修改更新产品和相关供应商信息
        /// </summary>
        /// <param name="product">产品</param>
        /// <param name="vendordata">供应商集合</param>
        /// <param name="user_id">操作用户</param>
        /// <returns></returns>
        public ERROR_CODE UpdateProductAndVendor(ivt_product product, VendorData vendordata, long user_id)
        {
            //产品更新
            product.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            product.update_user_id = user_id;


            _dal.Update(product);

            //供应商更新
            foreach (var ve in vendordata.VENDOR)
            {
                ivt_product_vendor veve = new ivt_product_vendor();
                //删除
                if (ve.operate == 1) {
                    var de = _dal1.FindById(ve.id);
                    if (de != null) {
                        de.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        de.delete_user_id = user_id;

                        _dal1.Update(de);
                    }

                }

                //更新
                if (ve.operate == 2) {
                    veve = _dal1.FindById(ve.id);
                    if (veve != null) {
                        veve.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        veve.update_user_id = user_id;
                        veve.product_id = product.id;
                        veve.is_active = ve.is_active;
                        veve.is_default = ve.is_default;
                        veve.vendor_account_id = ve.vendor_account_id;
                        veve.vendor_cost = ve.vendor_cost;
                        veve.vendor_product_no = ve.vendor_product_no;
                        _dal1.Update(veve);
                    }
                }

                //新增
                if (ve.operate == 3) {
                    veve.id = (int)(_dal.GetNextIdCom());
                    veve.update_time = veve.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    veve.create_user_id = user_id;
                    veve.product_id = product.id;
                    veve.is_active = ve.is_active;
                    veve.is_default = ve.is_default;
                    veve.vendor_account_id = ve.vendor_account_id;
                    veve.vendor_cost = ve.vendor_cost;
                    veve.vendor_product_no = ve.vendor_product_no;
                    _dal1.Insert(veve);
                }

            }

                return ERROR_CODE.SUCCESS;
        }


    }
}
