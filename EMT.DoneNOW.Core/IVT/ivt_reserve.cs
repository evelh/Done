
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_reserve")]
    [Serializable]
    [DataContract]
    public partial class ivt_reserve : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 quote_item_id { get; set; }
        [DataMember]
        public Int64 warehouse_id { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }


    }
}