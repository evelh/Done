using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_service_period")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_service_period : SoftDeleteCore
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
        public DateTime period_begin_date { get; set; }
        [DataMember]
        public DateTime period_end_date { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public Decimal? period_price { get; set; }
        [DataMember]
        public Decimal? period_adjusted_price { get; set; }
        [DataMember]
        public Decimal? period_cost { get; set; }
        [DataMember]
        public Int64? vendor_account_id { get; set; }
        [DataMember]
        public Int64? approve_and_post_user_id { get; set; }
        [DataMember]
        public Int64? approve_and_post_time { get; set; }
        [DataMember]
        public Decimal? adjusted_unit_code { get; set; }
        [DataMember]
        public Int64 contract_service_id { get; set; }


    }
}
