using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_module_limit")]
    [Serializable]
    [DataContract]
    public partial class sys_module_limit
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32? sort_order { get; set; }
        [DataMember]
        public Int32? status { get; set; }
        [DataMember]
        public Int32? type { get; set; }
        [DataMember]
        public String description { get; set; }


    }
}
