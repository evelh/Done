using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("com_notify_email")]
    [Serializable]
    [DataContract]
    public partial class com_notify_email : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public Int32 event_id { get; set; }
        [DataMember]
        public String to_email { get; set; }
        [DataMember]
        public Int32 notify_tmpl_id { get; set; }
        [DataMember]
        public String from_email { get; set; }
        [DataMember]
        public String from_email_name { get; set; }
        [DataMember]
        public String subject { get; set; }
        [DataMember]
        public String body_html { get; set; }
        [DataMember]
        public String body_text { get; set; }
        [DataMember]
        public SByte? is_success { get; set; }
        [DataMember]
        public SByte is_html_format { get; set; }
        [DataMember]
        public String cc_email { get; set; }
        [DataMember]
        public String bcc_email { get; set; }


    }
}