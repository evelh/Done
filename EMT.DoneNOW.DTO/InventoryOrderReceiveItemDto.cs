using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 采购接收-采购项的接收信息
    /// </summary>
    public class InventoryOrderReceiveItemDto
    {
        public long id;                                    // 采购项id
        public int count;                                  // 接收数
        public decimal cost;                               // 单位成本
        public List<string> sns = new List<string>();      // 序列号
    }
}
