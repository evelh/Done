using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_general")]
    [Serializable]
    [DataContract]
    public partial class d_general : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int32 general_table_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String code { get; set; }
        [DataMember]
        public String remark { get; set; }
        [DataMember]
        public Int32? parent_id { get; set; }
        [DataMember]
        public SByte status_id { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public Decimal? sort_order { get; set; }
        [DataMember]
        public String ext1 { get; set; }
        [DataMember]
        public String ext2 { get; set; }
        [DataMember]
        public SByte is_system { get; set; }
        [DataMember]
        public SByte is_active { get; set; }


    }
}