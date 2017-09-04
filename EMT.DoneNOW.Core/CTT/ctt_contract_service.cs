using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_service")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_service : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }
        [DataMember]
        public Int64 object_id { get; set; }
        [DataMember]
        public SByte object_type { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public Decimal? unit_price { get; set; }
        [DataMember]
        public Decimal? adjusted_price { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public DateTime effective_date { get; set; }
        [DataMember]
        public String invoice_description { get; set; }
        [DataMember]
        public SByte? is_invoice_description_customized { get; set; }
        [DataMember]
        public String internal_description { get; set; }
        [DataMember]
        public Decimal? adjusted_unit_code { get; set; }


    }
}
