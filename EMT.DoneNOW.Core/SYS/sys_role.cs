using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_role")]
    [Serializable]
    [DataContract]
    public partial class sys_role : SoftDeleteCore
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
        public Decimal hourly_factor { get; set; }
        [DataMember]
        public Decimal hourly_rate { get; set; }
        [DataMember]
        public SByte is_excluded { get; set; }
        [DataMember]
        public Int32? tax_cate_id { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public SByte? is_system { get; set; }
        [DataMember]
        public Int32? role_type { get; set; }
        [DataMember]
        public Decimal? pay_factor { get; set; }


    }
}