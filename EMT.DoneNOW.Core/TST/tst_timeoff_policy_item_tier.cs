using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_timeoff_policy_item_tier")]
    [Serializable]
    [DataContract]
    public partial class tst_timeoff_policy_item_tier : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 timeoff_policy_item_id { get; set; }
        [DataMember]
        public Decimal? annual_hours { get; set; }
        [DataMember]
        public Decimal? cap_hours { get; set; }
        [DataMember]
        public Decimal? hours_accrued_per_period { get; set; }
        [DataMember]
        public Int32 eligible_starting_months { get; set; }


    }
}
