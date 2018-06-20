using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_dashboard")]
    [Serializable]
    [DataContract]
    public partial class sys_dashboard : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32 theme_id { get; set; }
        [DataMember]
        public SByte widget_auto_place { get; set; }
        [DataMember]
        public Int64? filter_id { get; set; }
        [DataMember]
        public Int64? filter_default_value { get; set; }
        [DataMember]
        public Int32? limit_type_id { get; set; }
        [DataMember]
        public String limit_value { get; set; }
        [DataMember]
        public SByte is_shared { get; set; }
        [DataMember]
        public SByte is_system { get; set; }


    }
}
