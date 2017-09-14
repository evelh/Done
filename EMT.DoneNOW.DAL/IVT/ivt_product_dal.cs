using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_product_dal : BaseDAL<ivt_product>
    {
        /// <summary>
        /// 获取到默认的产品（查看合同保存成本时配置项向导使用）
        /// </summary>
        /// <returns></returns>
        public ivt_product GetDefaultProduct()
        {
            return FindSignleBySql<ivt_product>($"select * from ivt_product where is_system = 1 and delete_time = 0");
        }
    }
}
