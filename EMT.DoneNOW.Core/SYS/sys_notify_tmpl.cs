using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_notify_tmpl")]
    [Serializable]
    [DataContract]
    public partial class sys_notify_tmpl : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public SByte is_wall_quick_note { get; set; }
        [DataMember]
        public SByte is_default { get; set; }


    }
}