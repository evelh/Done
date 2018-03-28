using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_internal_cost")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_internal_cost
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public DateTime? start_date { get; set; }
        [DataMember]
        public DateTime? end_date { get; set; }
        [DataMember]
        public Decimal? hourly_rate { get; set; }


    }
}
