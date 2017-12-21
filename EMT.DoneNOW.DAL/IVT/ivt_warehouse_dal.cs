using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class ivt_warehouse_dal : BaseDAL<ivt_warehouse>
    {
        /// <summary>
        /// 获取员工仓库
        /// </summary>
        public ivt_warehouse GetSinByResId(long resource_id)
        {
            return FindSignleBySql<ivt_warehouse>($"SELECT * from ivt_warehouse where delete_time = 0 and resource_id = {resource_id}");
        }
    }
}
