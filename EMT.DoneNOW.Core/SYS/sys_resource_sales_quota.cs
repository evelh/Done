
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_sales_quota")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_sales_quota : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int32 year { get; set; }
        [DataMember]
        public SByte month { get; set; }
        [DataMember]
        public Decimal? amount { get; set; }
        [DataMember]
        public Decimal? opportunity_ext1 { get; set; }
        [DataMember]
        public Decimal? opportunity_ext2 { get; set; }
        [DataMember]
        public Decimal? opportunity_ext3 { get; set; }
        [DataMember]
        public Decimal? opportunity_ext4 { get; set; }
        [DataMember]
        public Decimal? opportunity_ext5 { get; set; }


    }
}