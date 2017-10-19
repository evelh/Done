using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    /// <summary>
    /// 合同服务（加入name字段）
    /// </summary>
    public class ContractServiceEntityDto
    {
        public Int64 id { get; set; }
        public Int64 oid { get; set; }
        public String name { get; set; }
        public Int64? vendor_id { get; set; }
        public Int32? period_type_id { get; set; }
        public Int64 contract_id { get; set; }
        public Int64 object_id { get; set; }
        public SByte object_type { get; set; }
        public Int32 quantity { get; set; }
        public Decimal? unit_price { get; set; }
        public Decimal? adjusted_price { get; set; }
        public Decimal? unit_cost { get; set; }
        public DateTime effective_date { get; set; }
        public String invoice_description { get; set; }
        public SByte? is_invoice_description_customized { get; set; }
        public String internal_description { get; set; }
    }
}
