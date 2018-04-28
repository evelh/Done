using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_installed_product_dal : BaseDAL<crm_installed_product>
    {
        /// <summary>
        /// 根据客户ID去获取到所有的客户配置项
        /// </summary>
        /// <param name="account_id"></param>
        /// <returns></returns>
        public List<crm_installed_product> GetInstalledProductByAccountId(long account_id ,string where ="") 
        {
            string sql = $"SELECT * from crm_installed_product where account_id = {account_id}";
            if (where != "")
            {
                sql += where;
            }
            return FindListBySql(sql);
        }

        public crm_installed_product GetInstalledProduct(long id)
        {
            return FindSignleBySql<crm_installed_product>($"select * from crm_installed_product where id = {id} and delete_time = 0");
        }
        /// <summary>
        /// 根据报价ID 获取相应的配置项和数量
        /// </summary>
        public List<crm_installed_product> GetInsProByQuoteId(long quote_id,long num)
        {
            return FindListBySql<crm_installed_product>($"SELECT * from crm_installed_product where quote_item_id = {quote_id} and delete_time=0 LIMIT 0,{num}");
        }
        /// <summary>
        /// 根据成本ID 获取相应的配置项和数量
        /// </summary>
        public List<crm_installed_product> GetInsProByCostId(long cost_id, long num)
        {
            return FindListBySql<crm_installed_product>($"SELECT * from crm_installed_product where  delete_time=0 and contract_cost_id = {cost_id}  LIMIT {num}");
        }

        /// <summary>
        /// 根据服务包ID 获取相关配置项
        /// </summary>
        public List<crm_installed_product> GetInsListBySerBunId(long serviceBundleId)
        {
            return FindListBySql<crm_installed_product>($"SELECT id  from crm_installed_product where delete_time = 0 and service_bundle_id = {serviceBundleId}");
        }
        /// <summary>
        /// 根据服务ID 获取相关配置项
        /// </summary>
        public List<crm_installed_product> GetInsListBySerId(long serviceId)
        {
            return FindListBySql<crm_installed_product>($"SELECT id  from crm_installed_product where delete_time = 0 and service_id = {serviceId}");
        }
        /// <summary>
        /// 根据产品名称升序查询配置项
        /// </summary>
        public List<crm_installed_product> GetInsProAccoByProName(long accountId)
        {
            return FindListBySql<crm_installed_product>($"SELECT cip.* from crm_installed_product cip INNER JOIN ivt_product ip on cip.product_id = ip.id where ip.delete_time = 0 and cip.delete_time = 0 and cip.account_id = {accountId} ORDER BY ip.name");
        }
   
    }
}
