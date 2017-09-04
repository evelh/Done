using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_rate")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_rate : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }
        [DataMember]
        public Int64 role_id { get; set; }
        [DataMember]
        public Decimal? rate { get; set; }
        [DataMember]
        public Decimal? block_hour_multiplier { get; set; }
        [DataMember]
        public Decimal? hourlyoffset { get; set; }
        [DataMember]
        public Decimal? rateoffset { get; set; }
        [DataMember]
        public Int32? deduction { get; set; }
        [DataMember]
        public Int32? modifytype { get; set; }


    }
}
