
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_quick_call")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_quick_call : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 form_tmpl_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? priority_type_id { get; set; }
        [DataMember]
        public Int32? issue_type_id { get; set; }
        [DataMember]
        public Int32? sub_issue_type_id { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public Int64? department_id { get; set; }
        [DataMember]
        public Int64? owner_resource_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public String second_resource_ids { get; set; }
        [DataMember]
        public String estimated_begin_time { get; set; }
        [DataMember]
        public String estimated_end_time { get; set; }


    }
}