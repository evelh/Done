
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_resource")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_resource : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }
        [DataMember]
        public Int32? department_id { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }


    }
}