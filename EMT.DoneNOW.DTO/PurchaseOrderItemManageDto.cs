using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 采购订单新增编辑页面采购项管理
    /// </summary>
    public class PurchaseOrderItemManageDto
    {
        public int index = 1;
        public List<PurchaseItemDto> items = new List<PurchaseItemDto>();
    }

    /// <summary>
    /// 采购项
    /// </summary>
    public class PurchaseItemDto
    {
        public long id;
        public long product_id;
        public long warehouse_id;
        public long? costId;
        public string accountName;
        public string contractName;
        public string product;
        public string locationName;
        public int quantity;        // 采购数量
        public int ivtQuantity = 0; // 库存数
        public int max = 0;         // 最大数
        public int min = 0;         // 最小数
        public string onOrder = "0";// 采购中
        public string back_order = "0"; // 尚未接收
        public string reserved_picked = "0";    // 预留和拣货
        public string avaCnt = "0"; // 可用数
        public decimal? unit_cost;  // 成本
        public string note = "";    // 备注
        public string arrivalDate = ""; // 预期到达时间
        public int was_auto_filled = 0;
    }
}
