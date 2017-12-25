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
        /// <summary>
        /// sn相关信息
        /// </summary>
        public string sn;
        /// <summary>
        /// 供应商编号
        /// </summary>
        public string vendorNo;
        /// <summary>
        /// 成本产品状态
        /// </summary>
        public string statusName;
        /// <summary>
        /// 成本产品状态Id
        /// </summary>
        public long statusId;
        /// <summary>
        /// 数量
        /// </summary>
        public long quantity;
        /// <summary>
        /// 成本产品Id
        /// </summary>
        public long cost_pro_id;
        /// <summary>
        /// 配送描述
        /// </summary>
        public string ShiDetail;
    }
}
