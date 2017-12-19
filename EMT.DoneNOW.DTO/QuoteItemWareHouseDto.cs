using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 显示仓库产品相关信息展示
    /// </summary>
    public class QuoteItemWareHouseDto
    {
        /// <summary>
        /// 仓库ID
        /// </summary>
        public int ware_id;
        /// <summary>
        /// 仓库名称
        /// </summary>
        public string wareName;
        /// <summary>
        /// 产品名称
        /// </summary>
        public string productName;
        /// <summary>
        /// 库存数
        /// </summary>
        public int onHand;
        /// <summary>
        /// 采购中
        /// </summary>
        public int onOrder;
        /// <summary>
        /// 尚未接收
        /// </summary>
        public int backOrder;
        /// <summary>
        /// 预留和拣货
        /// </summary>
        public int picked;
        /// <summary>
        /// 可用数
        /// </summary>
        public int available;
    }
}
