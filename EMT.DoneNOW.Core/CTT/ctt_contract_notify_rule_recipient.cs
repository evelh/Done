
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_notify_rule_recipient")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_notify_rule_recipient : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }
        [DataMember]
        public Int64 contract_notify_rule_id { get; set; }
        [DataMember]
        public Int64 person_id { get; set; }


    }
}