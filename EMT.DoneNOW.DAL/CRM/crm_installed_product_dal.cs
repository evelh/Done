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
        public List<crm_installed_product> GetInstalledProductByAccountId(long account_id)
        {
            string sql = $"SELECT * from crm_installed_product where account_id = {account_id}";
            return FindListBySql(sql);
        }
    }
}
