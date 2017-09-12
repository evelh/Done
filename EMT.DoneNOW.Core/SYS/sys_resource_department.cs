using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_department")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_department
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int64 department_id { get; set; }
        [DataMember]
        public Int64 role_id { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public SByte? is_lead { get; set; }
        [DataMember]
        public SByte is_active { get; set; }


    }
}