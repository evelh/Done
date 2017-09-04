using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_milestone")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_milestone : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public DateTime due_date { get; set; }
        [DataMember]
        public Decimal? hours { get; set; }
        [DataMember]
        public Decimal? dollars { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public String extacctitemid { get; set; }
        [DataMember]
        public SByte? initialpayment { get; set; }
        [DataMember]
        public Int32? type { get; set; }


    }
}
