using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_quote_email_tmpl")]
    [Serializable]
    [DataContract]
    public partial class sys_quote_email_tmpl : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte status_id { get; set; }
        [DataMember]
        public String sender_first_name { get; set; }
        [DataMember]
        public String sender_last_name { get; set; }
        [DataMember]
        public String email_from_address { get; set; }
        [DataMember]
        public String email_cc_address { get; set; }
        [DataMember]
        public String email_bcc_address { get; set; }
        [DataMember]
        public SByte is_account_owner_bcc { get; set; }
        [DataMember]
        public String subject { get; set; }
        [DataMember]
        public SByte is_html_format { get; set; }
        [DataMember]
        public String html_body { get; set; }
        [DataMember]
        public String text_body { get; set; }
        [DataMember]
        public SByte is_system_default { get; set; }


    }
}