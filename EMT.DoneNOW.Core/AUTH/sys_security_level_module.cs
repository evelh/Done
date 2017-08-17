using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_security_level_module")]
    [Serializable]
    [DataContract]
    public partial class sys_security_level_module
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int64 security_level_id { get; set; }
        [DataMember]
        public Int32 module_id { get; set; }
        [DataMember]
        public Int32 module_limit_id { get; set; }
        [DataMember]
        public Int32? module_limit_value { get; set; }
        [DataMember]
        public Int32? module_value { get; set; }


    }
}
