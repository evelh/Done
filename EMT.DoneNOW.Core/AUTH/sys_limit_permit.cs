using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_limit_permit")]
    [Serializable]
    [DataContract]
    public partial class sys_limit_permit
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int32 limit_id { get; set; }
        [DataMember]
        public Int32? permit_id { get; set; }


    }
}
