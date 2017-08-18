using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_notify_tmpl_email")]
    [Serializable]
    [DataContract]
    public partial class sys_notify_tmpl_email
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 notify_tmpl_id { get; set; }
        [DataMember]
        public Int32 send_from_type_id { get; set; }
        [DataMember]
        public String from_other_email { get; set; }
        [DataMember]
        public String from_other_email_name { get; set; }
        [DataMember]
        public String subject { get; set; }
        [DataMember]
        public String body_html { get; set; }
        [DataMember]
        public String body_text { get; set; }
        [DataMember]
        public SByte is_html_format { get; set; }


    }
}