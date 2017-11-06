
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_budget")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_budget : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64 contract_rate_id { get; set; }
        [DataMember]
        public Decimal estimated_hours { get; set; }


    }
}