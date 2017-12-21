using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_warehouse_product_sn_dal : BaseDAL<ivt_warehouse_product_sn>
    {
        public List<ivt_warehouse_product_sn> GetSnByIds(string ids)
        {
            return FindListBySql<ivt_warehouse_product_sn>($"SELECT * from ivt_warehouse_product_sn where id in ({ids}) and delete_time = 0");
        }
        /// <summary>
        /// 根据仓库产品Id 和sn 获取唯一的仓库产品串号信息
        /// </summary>
        public ivt_warehouse_product_sn GetSnByWareAndSn(long wareProId,string sn)
        {
            return FindSignleBySql<ivt_warehouse_product_sn>($"SELECT * from ivt_warehouse_product_sn where warehouse_product_id={wareProId} and sn='{sn}' and delete_time = 0");
        }
        /// <summary>
        /// 获取仓库产品下的Sn
        /// </summary>
        public List<ivt_warehouse_product_sn> GetSnByWareProId(long wareProId)
        {
            return FindListBySql<ivt_warehouse_product_sn>($"SELECT * from ivt_warehouse_product_sn where warehouse_product_id={wareProId}  and delete_time = 0");
        }
        
        /// <summary>
        /// 根据成本产品ID 获取相应序列号
        /// </summary>
        public List<ivt_warehouse_product_sn> GetListByCostProId(long costProId)
        {
            return FindListBySql<ivt_warehouse_product_sn>($"SELECT iwps.* from ctt_contract_cost_product_sn cccp inner join ivt_warehouse_product_sn iwps on cccp.sn = iwps.sn where cccp.delete_time = 0 and iwps.delete_time = 0 and cccp.contract_cost_product_id = {costProId}");
        }
    }

}
