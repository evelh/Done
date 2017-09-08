using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public SByte status_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public Int32? bill_post_type_id { get; set; }
        [DataMember]
        public SByte timeentry_need_begin_end { get; set; }
        [DataMember]
        public SByte is_sdt_default { get; set; }
        [DataMember]
        public String external_no { get; set; }
        [DataMember]
        public Int64? sla_id { get; set; }
        [DataMember]
        public DateTime start_date { get; set; }
        [DataMember]
        public DateTime end_date { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Decimal? dollars { get; set; }
        [DataMember]
        public Decimal? cost { get; set; }
        [DataMember]
        public Decimal? hours { get; set; }
        [DataMember]
        public SByte? enable_overage_billing_rate { get; set; }
        [DataMember]
        public Decimal? overage_billing_rate { get; set; }
        [DataMember]
        public Decimal? setup_fee { get; set; }
        [DataMember]
        public Int32? occurrences { get; set; }
        [DataMember]
        public Int32? period_type { get; set; }
        [DataMember]
        public Int64? setup_fee_approve_and_post_user_id { get; set; }
        [DataMember]
        public Int64? setup_fee_approve_and_post_time { get; set; }
        [DataMember]
        public Int64? exclusion_contract_id { get; set; }
        [DataMember]
        public Int64? bill_to_account_id { get; set; }
        [DataMember]
        public Int64? bill_to_contact_id { get; set; }
        [DataMember]
        public Int64? renewed_contract_id { get; set; }
        [DataMember]
        public Int64? renewed_time { get; set; }
        [DataMember]
        public Int64? renewed_user_id { get; set; }
        [DataMember]
        public Int32? is_paid { get; set; }
        [DataMember]
        public Decimal? rate { get; set; }
        [DataMember]
        public Decimal? overtime { get; set; }
        [DataMember]
        public Decimal? emergency { get; set; }
        [DataMember]
        public Int32? timeentry { get; set; }
        [DataMember]
        public SByte? deduct_tax { get; set; }
        [DataMember]
        public Decimal? adjust_setup_fee { get; set; }
        [DataMember]
        public Int64? setup_fee_cost_code_id { get; set; }


    }
}
