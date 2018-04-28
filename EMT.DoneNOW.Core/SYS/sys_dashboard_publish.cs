using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_dashboard_publish")]
    [Serializable]
    [DataContract]
    public partial class sys_dashboard_publish : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 dashboard_id { get; set; }
        [DataMember]
        public String security_level_ids { get; set; }
        [DataMember]
        public String department_ids { get; set; }
        [DataMember]
        public String resource_ids { get; set; }


    }
}
