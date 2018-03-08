using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_workflow_log")]
    [Serializable]
    [DataContract]
    public partial class sys_workflow_log
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 create_time { get; set; }
        [DataMember]
        public Int64 workflow_id { get; set; }
        [DataMember]
        public Int64 object_id { get; set; }
        [DataMember]
        public String exec_sql { get; set; }
        [DataMember]
        public String remark { get; set; }

    }
}
