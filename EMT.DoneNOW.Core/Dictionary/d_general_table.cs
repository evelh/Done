using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_general_table")]
    [Serializable]
    [DataContract]
    public partial class d_general_table : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String remark { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32? panret_table_id { get; set; }
        [DataMember]
        public Int32 read_only { get; set; }


    }
}
