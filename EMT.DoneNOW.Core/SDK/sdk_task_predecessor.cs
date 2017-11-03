
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_predecessor")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_predecessor : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64 predecessor_task_id { get; set; }
        [DataMember]
        public Int32 dependant_lag { get; set; }
        [DataMember]
        public Int32? dependant_type { get; set; }


    }
}