
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_outsource")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_outsource : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int64 outsourced_by_resource_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int32 rate_type_id { get; set; }
        [DataMember]
        public Decimal? rate { get; set; }
        [DataMember]
        public Decimal? authorized_hours { get; set; }
        [DataMember]
        public Decimal? authorized_cost { get; set; }
        [DataMember]
        public Int64? default_role_id { get; set; }
        [DataMember]
        public Int64? labor_cost_code_id { get; set; }
        [DataMember]
        public Int64? cost_cost_code_id { get; set; }
        [DataMember]
        public Decimal? flat_bill_amount { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String instructions { get; set; }
        [DataMember]
        public Int64 authorized_time { get; set; }
        [DataMember]
        public Int64? assign_time { get; set; }
        [DataMember]
        public Int64? accept_decline_time { get; set; }
        [DataMember]
        public Decimal? auto_decline_in_hours { get; set; }
        [DataMember]
        public Int64? auto_decline_if_not_accepted_by_time { get; set; }
        [DataMember]
        public String decline_reason { get; set; }
        [DataMember]
        public Int64? complete_time { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int32 last_modified_by_person_id { get; set; }
        [DataMember]
        public Int64? edit_event_id { get; set; }
        [DataMember]
        public Int32? global_task_id { get; set; }
        [DataMember]
        public Int32? subcontractor_type_id { get; set; }
        [DataMember]
        public Int32? outsource_network_id { get; set; }


    }
}