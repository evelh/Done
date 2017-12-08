
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_work_entry")]
    [Serializable]
    [DataContract]
    public partial class sdk_work_entry : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64? service_id { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public Int64? entrytimestamp { get; set; }
        [DataMember]
        public DateTime? worked_date { get; set; }
        [DataMember]
        public Int64? start_time { get; set; }
        [DataMember]
        public Int64? end_time { get; set; }
        [DataMember]
        public Decimal? hours_worked { get; set; }
        [DataMember]
        public Decimal? hours_billed { get; set; }
        [DataMember]
        public Decimal offset_hours { get; set; }
        [DataMember]
        public Int64? approve_and_post_user_id { get; set; }
        [DataMember]
        public Int64? approve_and_post_date { get; set; }
        [DataMember]
        public DateTime? approveddate { get; set; }
        [DataMember]
        public Int32? approverid { get; set; }
        [DataMember]
        public DateTime? billeddate { get; set; }
        [DataMember]
        public Int32? billerid { get; set; }
        [DataMember]
        public String internal_notes { get; set; }
        [DataMember]
        public String summary_notes { get; set; }
        [DataMember]
        public SByte is_billable { get; set; }
        [DataMember]
        public SByte show_on_invoice { get; set; }
        [DataMember]
        public Decimal? cost_code_min_max_offset_hours { get; set; }
        [DataMember]
        public Int32? taskfire_worked_minutes { get; set; }
        [DataMember]
        public SByte? is_taskfire_internal_note_private { get; set; }
        [DataMember]
        public Decimal? rounded_hours_worked { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }
        [DataMember]
        public Int32? parent_note_id { get; set; }
        [DataMember]
        public Int32? parent_attachment_id { get; set; }
        [DataMember]
        public Int64? edit_event_id { get; set; }
        [DataMember]
        public Int32? billing_approved_by_resource_id { get; set; }
        [DataMember]
        public Int64? billing_approved_time { get; set; }
        [DataMember]
        public Int32? billing_approved_most_recent_level { get; set; }
        [DataMember]
        public Int32 paused_minutes { get; set; }
        [DataMember]
        public Decimal? hours_billed_deduction { get; set; }
        [DataMember]
        public Decimal? hours_rate_deduction { get; set; }
        [DataMember]
        public Int64? work_entry_record_id { get; set; }
        [DataMember]
        public Int64 batch_id { get; set; }


    }
}