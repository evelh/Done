
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_contact_action_tmpl")]
    [Serializable]
    [DataContract]
    public partial class crm_contact_action_tmpl : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public SByte send_email { get; set; }
        [DataMember]
        public Int32? note_action_type_id { get; set; }
        [DataMember]
        public String note_description { get; set; }
        [DataMember]
        public Int32? todo_action_type_id { get; set; }
        [DataMember]
        public String todo_description { get; set; }
        [DataMember]
        public Int64? todo_resource_id { get; set; }
        [DataMember]
        public Int64? todo_start_date { get; set; }
        [DataMember]
        public Int64? todo_end_date { get; set; }
        [DataMember]
        public String description { get; set; }
        
    }
}