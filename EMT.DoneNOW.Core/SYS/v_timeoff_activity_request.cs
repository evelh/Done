using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_timeoff_activity_request")]
    [Serializable]
    [DataContract]
    public partial class v_timeoff_activity_request
    {

        [DataMember]
        public Int64 entity_id { get; set; }
        [DataMember]
        public Int64 entity_type { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64? tier_id { get; set; }
        [DataMember]
        public String activity_date { get; set; }
        [DataMember]
        public Decimal? hours { get; set; }
        [DataMember]
        public Int64 activity_type_id { get; set; }
        [DataMember]
        public String notes { get; set; }


    }
}
