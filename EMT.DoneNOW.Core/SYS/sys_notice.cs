
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_notice")]
    [Serializable]
    [DataContract]
    public partial class sys_notice : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public Int64 begin_time { get; set; }
        [DataMember]
        public Int64 end_time { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String url { get; set; }
        [DataMember]
        public SByte send_type_id { get; set; }


    }
}