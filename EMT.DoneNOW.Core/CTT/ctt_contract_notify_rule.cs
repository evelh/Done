
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_notify_rule")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_notify_rule : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Decimal threshold { get; set; }
        [DataMember]
        public Decimal? quantity { get; set; }
        [DataMember]
        public Decimal? rate { get; set; }
        [DataMember]
        public String additional_email_addresses { get; set; }
        [DataMember]
        public Int32 notify_tmpl_id { get; set; }


    }
}