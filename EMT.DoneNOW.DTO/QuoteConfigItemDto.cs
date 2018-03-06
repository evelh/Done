using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.DTO
{
    public class QuoteConfigItemDto
    {
        public List<InsProDto> insProList;
        public List<InsProSubDto> insProSubList;
        public List<InsChargeDto> insChargeList;
        public long quote_id;
    }

    /// <summary>
    /// 配置项向导 - 产品转配置项
    /// </summary>
    public class InsProDto
    {
        /// <summary>
        /// 报价项Id
        /// </summary>
        public long itemId;
        /// <summary>
        /// 页面上用于识别的唯一的产品相关ID
        /// </summary>
        public string pageProId;
        /// <summary>
        /// 安装日期
        /// </summary>
        public DateTime insDate;
        /// <summary>
        /// 质保到期日
        /// </summary>
        public DateTime? expDate;
        /// <summary>
        /// 序列号
        /// </summary>
        public string serNumber;
        /// <summary>
        /// 参考号
        /// </summary>
        public string refNumber;
        /// <summary>
        /// 参考名
        /// </summary>
        public string refName;
    }
    /// <summary>
    /// 配置项向导 - 配置项 订阅
    /// </summary>
    public class InsProSubDto
    {
        /// <summary>
        /// 页面上设置的配置项产品的信息
        /// </summary>
        public string insProId;
        /// <summary>
        /// 订阅名称
        /// </summary>
        public string subName;
        /// <summary>
        /// 订阅描述
        /// </summary>
        public string subDes;
        /// <summary>
        /// 订阅期间类型
        /// </summary>
        public int perType;
        /// <summary>
        /// 有效时间
        /// </summary>
        public DateTime effDate;
        /// <summary>
        /// 到期时间
        /// </summary>
        public DateTime expDate;
        /// <summary>
        /// 价格
        /// </summary>
        public decimal sunPerPrice;
    }
    /// <summary>
    /// 配置项向导 - 成本转配置项
    /// </summary>
    public class InsChargeDto
    {
        /// <summary>
        /// 相关联的报价项Id
        /// </summary>
        public long itemId;
        /// <summary>
        /// 页面上选择的产品ID
        /// </summary>
        public long? productId;
        /// <summary>
        /// 安装日期
        /// </summary>
        public DateTime insDate;
        /// <summary>
        /// 质保到期日期
        /// </summary>
        public DateTime? warExpDate;
        /// <summary>
        /// 序列号
        /// </summary>
        public string serNumber;
        /// <summary>
        /// 参考号
        /// </summary>
        public string refNumber;
        /// <summary>
        /// 参考名
        /// </summary>
        public string refName;

    }
}
