
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_expense")]
    [Serializable]
    [DataContract]
    public partial class sdk_expense : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }
        [DataMember]
        public Int64 expense_report_id { get; set; }
        [DataMember]
        public Int64 cost_code_id { get; set; }
        [DataMember]
        public Int32 payment_type_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public DateTime add_date { get; set; }
        [DataMember]
        public SByte is_billable { get; set; }
        [DataMember]
        public Decimal amount { get; set; }
        [DataMember]
        public SByte is_approved { get; set; }
        [DataMember]
        public SByte has_receipt { get; set; }
        [DataMember]
        public String location { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Int32? allocation_code_id { get; set; }
        [DataMember]
        public SByte? reimbursable { get; set; }
        [DataMember]
        public String from_loc { get; set; }
        [DataMember]
        public String to_loc { get; set; }
        [DataMember]
        public Decimal odometer_start { get; set; }
        [DataMember]
        public Decimal odometer_end { get; set; }
        [DataMember]
        public Decimal? miles { get; set; }
        [DataMember]
        public Int64? approve_and_post_user_id { get; set; }
        [DataMember]
        public DateTime? approve_and_post_date { get; set; }
        [DataMember]
        public Decimal amountrate { get; set; }
        [DataMember]
        public String purpose { get; set; }
        [DataMember]
        public String extacctitemid { get; set; }
        [DataMember]
        public DateTime? web_service_date { get; set; }
        [DataMember]
        public Int32? currency_id { get; set; }


    }
}