
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_work_list_task")]
    [Serializable]
    [DataContract]
    public partial class sys_work_list_task
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 create_user_id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64 sort_order { get; set; }
        [DataMember]
        public Int64 create_time { get; set; }
        [DataMember]
        public Int64 update_time { get; set; }
    }
}