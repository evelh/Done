
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_ticket")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_ticket : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 form_tmpl_id { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public Int64? installed_product_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public String additional_contact_ids { get; set; }
        [DataMember]
        public Int32? source_type_id { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64? department_id { get; set; }
        [DataMember]
        public Int64? owner_resource_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public String second_resource_ids { get; set; }
        [DataMember]
        public String estimated_end_time { get; set; }
        [DataMember]
        public String estimated_end_time_from_now { get; set; }
        [DataMember]
        public Int32? priority_type_id { get; set; }
        [DataMember]
        public Int32? ticket_type_id { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }
        [DataMember]
        public Decimal? estimated_hours { get; set; }
        [DataMember]
        public Int32? issue_type_id { get; set; }
        [DataMember]
        public Int32? sub_issue_type_id { get; set; }
        [DataMember]
        public Int64? sla_id { get; set; }
        [DataMember]
        public Int32? due_date { get; set; }
        [DataMember]
        public Decimal? due_time_hours { get; set; }
        [DataMember]
        public String due_time { get; set; }
        [DataMember]
        public String impact_analysis { get; set; }
        [DataMember]
        public String implementation_plan { get; set; }
        [DataMember]
        public String roll_out_plan { get; set; }
        [DataMember]
        public String back_out_plan { get; set; }
        [DataMember]
        public String review_notes { get; set; }


    }
}