using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_timeoff_activity")]
    [Serializable]
    [DataContract]
    public partial class tst_timeoff_activity
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64 activity_time { get; set; }
        [DataMember]
        public Int64? timeoff_policy_item_tier_id { get; set; }
        [DataMember]
        public Decimal hours { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }


    }
}
