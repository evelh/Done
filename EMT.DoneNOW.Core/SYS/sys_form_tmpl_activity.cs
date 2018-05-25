
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_activity")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_activity : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 form_tmpl_id { get; set; }
        [DataMember]
        public Int32 action_type_id { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32? task_status_id { get; set; }
        [DataMember]
        public SByte? apply_note_incidents { get; set; }
        [DataMember]
        public SByte? append_to_resolution { get; set; }
        [DataMember]
        public SByte? append_to_resolution_incidents { get; set; }
        [DataMember]
        public Int32? publish_type_id { get; set; }
        [DataMember]
        public SByte? announce { get; set; }


    }
}