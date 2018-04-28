using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_dashboard_resource")]
    [Serializable]
    [DataContract]
    public partial class sys_dashboard_resource : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 dashboard_id { get; set; }
        [DataMember]
        public Decimal sort_order { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public SByte? is_visible { get; set; }


    }
}
