using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_approver")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_approver
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int64 approver_resource_id { get; set; }
        [DataMember]
        public Int32 approve_type_id { get; set; }
        [DataMember]
        public Int32 tier { get; set; }


    }
}
