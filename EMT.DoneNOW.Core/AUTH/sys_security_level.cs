using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_security_level")]
    [Serializable]
    [DataContract]
    public partial class sys_security_level : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String sort_order { get; set; }
        [DataMember]
        public Int32? is_active { get; set; }
        [DataMember]
        public SByte is_system { get; set; }
        [DataMember]
        public UInt64? systemrole { get; set; }
        [DataMember]
        public Int32? buttonbarid { get; set; }
        [DataMember]
        public String defaultdownlink { get; set; }
        [DataMember]
        public String icon { get; set; }
        [DataMember]
        public Int32? type_id { get; set; }
        [DataMember]
        public String sidelink { get; set; }
        [DataMember]
        public Int32? license_type_id { get; set; }


    }
}
