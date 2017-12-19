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
        public string product;
        public string locationName;
        public int quantity;
        public decimal unit_cost;
        public string note = "";
        public int was_auto_filled = 0;
    }
}
