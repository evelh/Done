
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_workgroup_resouce")]
    [Serializable]
    [DataContract]
    public partial class sys_workgroup_resouce
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 workgroup_id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public SByte is_leader { get; set; }


    }
}