using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_service_adjust")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_service_adjust : SoftDeleteCore
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
        public Int32 quantity_change { get; set; }
        [DataMember]
        public Decimal prorated_price_change { get; set; }
        [DataMember]
        public Decimal prorated_cost_change { get; set; }
        [DataMember]
        public DateTime effective_date { get; set; }
        [DataMember]
        public DateTime end_date { get; set; }
        [DataMember]
        public Int64? approve_and_post_user_id { get; set; }
        [DataMember]
        public DateTime? approve_and_post_date { get; set; }
        [DataMember]
        public Int64? vendor_account_id { get; set; }
        [DataMember]
        public Int64 contract_service_id { get; set; }
        [DataMember]
        public Decimal adjust_prorated_price_change { get; set; }


    }
}