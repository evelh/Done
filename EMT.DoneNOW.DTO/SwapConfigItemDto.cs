using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class SwapConfigItemDto
    {
        public long outSwapId; // 替换的配置项的Id
        /// <summary>
        /// 是否产品回收入库
        /// </summary>
        public bool CkToWarehouse = false;
        /// <summary>
        /// 传入配置项 库存产品Id
        /// </summary>
        public long? inWareProId;
        public long? inWareProSnId;

        // 产品回收入库时选择方式
        public bool isExist=false;
        public long? existWareProId;
        public string existWareProSn;

        public bool isNew=false;
        public long newWareId;
        public string newSerNum;
        public string newRefNumber;
        public string newBin;
        public int newMax;
        public int newMin;
        public int newQuan = 1;
        /// <summary>
        /// 配置项未关闭工单处理方式
        /// </summary>
        public Dictionary<long, string> ticketList;
        // 邮件相关
        public string conIds;
        public string resIds;
        public string otherEmails;
        public string subject;
        public string content;
    }
}
