
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_timeoff_request")]
    [Serializable]
    [DataContract]
    public partial class tst_timeoff_request : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Decimal request_hours { get; set; }
        [DataMember]
        public String request_reason { get; set; }
        [DataMember]
        public Int64? approved_resource_id { get; set; }
        [DataMember]
        public String reject_reason { get; set; }
        [DataMember]
        public DateTime? request_date { get; set; }
        [DataMember]
        public Int64? batch_id { get; set; }


    }
}