using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_workflow")]
    [Serializable]
    [DataContract]
    public partial class sys_workflow : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 workflow_object_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public String event_json { get; set; }
        [DataMember]
        public String condition_json { get; set; }
        [DataMember]
        public String time_json { get; set; }
        [DataMember]
        public String update_json { get; set; }
        [DataMember]
        public String action_json { get; set; }
        [DataMember]
        public String todo_json { get; set; }
        [DataMember]
        public String email_send_from { get; set; }
        [DataMember]
        public String recipient_json { get; set; }
        [DataMember]
        public Int32? notify_tmpl_id { get; set; }
        [DataMember]
        public SByte? use_default_tmpl { get; set; }
        [DataMember]
        public String notify_subject { get; set; }
        [DataMember]
        public Int32? notify_recur_every_days { get; set; }
        [DataMember]
        public Int32? notify_recur_every_hours { get; set; }
        [DataMember]
        public Int32? notify_recur_every_minutes { get; set; }
        [DataMember]
        public Int32? notify_recur_max_times { get; set; }
        [DataMember]
        public String notify_recur_update_json { get; set; }
        [DataMember]
        public Int32? note_type_id { get; set; }
        [DataMember]
        public Int32? publish_type_id { get; set; }
        [DataMember]
        public SByte? append_to_resolution { get; set; }


    }
}
