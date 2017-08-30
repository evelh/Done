using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_territory")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_territory : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int32 territory_id { get; set; }


    }
}
