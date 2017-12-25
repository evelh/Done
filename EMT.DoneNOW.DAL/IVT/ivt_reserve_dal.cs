using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_reserve_dal : BaseDAL<ivt_reserve>
    {
        /// <summary>
        /// 根据报价项信息获取相应库存预留
        /// </summary>
        public List<ivt_reserve> GetListByItemId(long itemId)
        {
            return FindListBySql<ivt_reserve>($"SELECT * from ivt_reserve where quote_item_id = {itemId} and delete_time = 0");
        }
    }
}
