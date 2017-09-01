using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_warehouse_product")]
    [Serializable]
    [DataContract]
    public partial class ivt_warehouse_product : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64? warehouse_id { get; set; }
        [DataMember]
        public Int64 product_id { get; set; }
        [DataMember]
        public Int64? vendor_account_id { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public Int32 quantity_minimum { get; set; }
        [DataMember]
        public Int32 quantity_maximum { get; set; }
        [DataMember]
        public String reference_number { get; set; }
        [DataMember]
        public String bin { get; set; }


    }
}