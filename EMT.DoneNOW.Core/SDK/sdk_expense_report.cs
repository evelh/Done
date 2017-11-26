
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_expense_report")]
    [Serializable]
    [DataContract]
    public partial class sdk_expense_report : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }
        [DataMember]
        public DateTime? submit_date { get; set; }
        [DataMember]
        public Int64? submit_user_id { get; set; }
        [DataMember]
        public Int64? approve_and_post_user_id { get; set; }
        [DataMember]
        public DateTime? approve_and_post_date { get; set; }
        [DataMember]
        public DateTime? end_date { get; set; }
        [DataMember]
        public Decimal? amount { get; set; }
        [DataMember]
        public Decimal? cash_advance_amount { get; set; }
        [DataMember]
        public String rejection_reason { get; set; }
        [DataMember]
        public String quickbooks_reference_number { get; set; }
        [DataMember]
        public Int32? creatorstatus { get; set; }


    }
}