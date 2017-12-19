using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_order_product")]
    [Serializable]
    [DataContract]
    public partial class ivt_order_product : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 order_id { get; set; }
        [DataMember]
        public Int64 product_id { get; set; }
        [DataMember]
        public Int64 warehouse_id { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public SByte was_auto_filled { get; set; }
        [DataMember]
        public String note { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public SByte has_been_exported { get; set; }
        [DataMember]
        public Int64? exported_time { get; set; }
        [DataMember]
        public Int64? contract_cost_id { get; set; }
        [DataMember]
        public DateTime? estimated_arrival_date { get; set; }


    }
}
