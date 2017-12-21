using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_warehouse")]
    [Serializable]
    [DataContract]
    public partial class ivt_warehouse : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }


    }
}