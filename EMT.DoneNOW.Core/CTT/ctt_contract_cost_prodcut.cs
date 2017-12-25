
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_cost_product")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_cost_product : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 contract_cost_id { get; set; }
        [DataMember]
        public Int64? warehouse_id { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public Int64? order_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int32? shipping_type_id { get; set; }
        [DataMember]
        public String shipping_reference_number { get; set; }
        [DataMember]
        public Int64? shipping_time { get; set; }
        [DataMember]
        public Int64? shipping_contract_cost_id { get; set; }


    }
}