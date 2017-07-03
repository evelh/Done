using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_udf_group_field")]
    [Serializable]
    [DataContract]
    public partial class sys_udf_group_field : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int32 group_id { get; set; }
        [DataMember]
        public Int64 udf_field_id { get; set; }
        [DataMember]
        public SByte is_required { get; set; }
        [DataMember]
        public String sort_order { get; set; }


    }
}
