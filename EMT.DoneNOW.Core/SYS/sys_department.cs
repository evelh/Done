
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_department")]
    [Serializable]
    [DataContract]
    public partial class sys_department : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String no { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64? location_id { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public SByte? is_active { get; set; }
        [DataMember]
        public SByte is_show { get; set; }
        [DataMember]
        public SByte is_system { get; set; }
        [DataMember]
        public String other_email { get; set; }
        [DataMember]
        public String other_email4 { get; set; }
        [DataMember]
        public String other_email3 { get; set; }
        [DataMember]
        public String other_email2 { get; set; }


    }
}

