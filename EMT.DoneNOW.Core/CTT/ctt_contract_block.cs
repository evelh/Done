using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_block")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_block : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }
        [DataMember]
        public DateTime start_date { get; set; }
        [DataMember]
        public DateTime end_date { get; set; }
        [DataMember]
        public Decimal quantity { get; set; }
        [DataMember]
        public Decimal rate { get; set; }
        [DataMember]
        public SByte? is_billed { get; set; }
        [DataMember]
        public SByte status_id { get; set; }
        [DataMember]
        public DateTime date_purchased { get; set; }
        [DataMember]
        public String payment_number { get; set; }
        [DataMember]
        public Int32? payment_type_id { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte? is_paid { get; set; }
        [DataMember]
        public String invoice_no { get; set; }
        [DataMember]
        public Int32? payment_id { get; set; }
        [DataMember]
        public SByte? overridehourlyrate { get; set; }
        [DataMember]
        public Int64? paid_time { get; set; }


    }
}
