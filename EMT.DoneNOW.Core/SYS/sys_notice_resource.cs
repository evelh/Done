
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_notice_resource")]
    [Serializable]
    [DataContract]
    public partial class sys_notice_resource
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 notice_id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public SByte is_show { get; set; }
        [DataMember]
        public Int64? first_show_time { get; set; }
        [DataMember]
        public Int64? status_changed_time { get; set; }


    }
}