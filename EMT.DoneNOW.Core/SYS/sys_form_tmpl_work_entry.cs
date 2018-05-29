
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_work_entry")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_work_entry : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 form_tmpl_id { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public Decimal? hours_worked { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public SByte? is_billable { get; set; }
        [DataMember]
        public SByte? show_on_invoice { get; set; }
        [DataMember]
        public String summary_notes { get; set; }
        [DataMember]
        public String internal_notes { get; set; }
        [DataMember]
        public SByte? apply_note_incidents { get; set; }
        [DataMember]
        public SByte? append_to_resolution { get; set; }
        [DataMember]
        public SByte? append_to_resolution_incidents { get; set; }


    }
}