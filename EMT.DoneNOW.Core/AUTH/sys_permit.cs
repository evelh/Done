using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_permit")]
    [Serializable]
    [DataContract]
    public partial class sys_permit
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32? priority { get; set; }
        [DataMember]
        public String sn { get; set; }
        [DataMember]
        public String url { get; set; }
        [DataMember]
        public Int32? parent_id { get; set; }
        [DataMember]
        public Int32? sub_system { get; set; }


    }
}
