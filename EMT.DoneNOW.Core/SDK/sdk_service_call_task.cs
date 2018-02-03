
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_service_call_task")]
    [Serializable]
    [DataContract]
    public partial class sdk_service_call_task : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64? service_call_id { get; set; }
        [DataMember]
        public Int64? edit_event_id { get; set; }


    }
}