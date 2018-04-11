using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_work_entry_report")]
    [Serializable]
    [DataContract]
    public partial class sdk_work_entry_report : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public DateTime? start_date { get; set; }
        [DataMember]
        public DateTime? end_date { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }
        [DataMember]
        public Int64? submit_user_id { get; set; }
        [DataMember]
        public Int64? submit_time { get; set; }
        [DataMember]
        public Int64? approve_user_id { get; set; }
        [DataMember]
        public DateTime? approve_time { get; set; }
        [DataMember]
        public String rejection_reason { get; set; }


    }
}
