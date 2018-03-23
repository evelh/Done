using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_timeoff_policy_resource")]
    [Serializable]
    [DataContract]
    public partial class tst_timeoff_policy_resource : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 timeoff_policy_id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public DateTime effective_date { get; set; }


    }
}
