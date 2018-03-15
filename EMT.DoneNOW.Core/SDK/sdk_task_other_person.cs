
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_other_person")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_other_person : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int32 approve_status_id { get; set; }
        [DataMember]
        public Int64? oper_time { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }


    }
}