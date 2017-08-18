using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_service_bundle")]
    [Serializable]
    [DataContract]
    public partial class ivt_service_bundle : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String invoice_description { get; set; }
        [DataMember]
        public Int64? sla_id { get; set; }
        [DataMember]
        public Int64? vendor_id { get; set; }
        [DataMember]
        public Int32? period_type_id { get; set; }
        [DataMember]
        public Decimal? old_selected_service_sum { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public Decimal? unit_price { get; set; }
        [DataMember]
        public Decimal? discount { get; set; }
        [DataMember]
        public Decimal? discount_percent { get; set; }
        [DataMember]
        public Int64 cost_code_id { get; set; }
        [DataMember]
        public SByte is_active { get; set; }


    }
}