using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_receive")]
    [Serializable]
    [DataContract]
    public partial class ivt_receive : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 order_product_id { get; set; }
        [DataMember]
        public Int32 quantity_received { get; set; }
        [DataMember]
        public Int32 quantity_backordered { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public SByte has_been_exported { get; set; }
        [DataMember]
        public Int64? exported_time { get; set; }
        [DataMember]
        public Int64? receive_date { get; set; }
        [DataMember]
        public Int64? receive_by_id { get; set; }


    }
}
