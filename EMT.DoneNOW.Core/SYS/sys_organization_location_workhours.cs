
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_organization_location_workhours")]
    [Serializable]
    [DataContract]
    public partial class sys_organization_location_workhours : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64? sla_id { get; set; }
        [DataMember]
        public Int64? location_id { get; set; }
        [DataMember]
        public SByte weekday { get; set; }
        [DataMember]
        public String start_time { get; set; }
        [DataMember]
        public String end_time { get; set; }
        [DataMember]
        public String extended_start_time { get; set; }
        [DataMember]
        public String extended_end_time { get; set; }


    }
}