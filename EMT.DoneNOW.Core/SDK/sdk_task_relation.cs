
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_relation")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_relation : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64 parent_task_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int32 lag { get; set; }


    }
}