
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_work_record")]
    [Serializable]
    [DataContract]
    public partial class sdk_work_record : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int32? entry_type_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public DateTime? entrytimestamp { get; set; }
        [DataMember]
        public Int64? start_time { get; set; }
        [DataMember]
        public Int64? end_time { get; set; }
        [DataMember]
        public DateTime? dateentered { get; set; }


    }
}