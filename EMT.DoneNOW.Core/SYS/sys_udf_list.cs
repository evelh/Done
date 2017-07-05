using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_udf_list")]
    [Serializable]
    [DataContract]
    public partial class sys_udf_list : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 udf_field_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public SByte status_id { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public Decimal? sort_order { get; set; }


    }
}
