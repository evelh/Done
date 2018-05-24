using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 form_type_id { get; set; }
        [DataMember]
        public String tmpl_name { get; set; }
        [DataMember]
        public String speed_code { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public String remark { get; set; }
        [DataMember]
        public Int32 range_type_id { get; set; }
        [DataMember]
        public Int32? range_department_id { get; set; }
        [DataMember]
        public String quick_email_object_ids { get; set; }
        [DataMember]
        public String other_emails { get; set; }
        [DataMember]
        public Int64? notify_tmpl_id { get; set; }
        [DataMember]
        public String subject { get; set; }
        [DataMember]
        public String additional_email_text { get; set; }
        [DataMember]
        public SByte from_sys_email { get; set; }


    }
}
