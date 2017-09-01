using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_product_vendor")]
    [Serializable]
    [DataContract]
    public partial class ivt_product_vendor : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 product_id { get; set; }
        [DataMember]
        public Int64? vendor_id { get; set; }
        [DataMember]
        public String vendor_product_no { get; set; }
        [DataMember]
        public Decimal? vendor_cost { get; set; }
        [DataMember]
        public UInt64 is_default { get; set; }
        [DataMember]
        public SByte is_active { get; set; }


    }
}