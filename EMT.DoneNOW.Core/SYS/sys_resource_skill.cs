using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_skill")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_skill
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int32? skill_cate_id { get; set; }
        [DataMember]
        public Int32? skill_class_id { get; set; }
        [DataMember]
        public Int32 skill_type_id { get; set; }
        [DataMember]
        public Int32? skill_level_id { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte? is_completed { get; set; }


    }
}
