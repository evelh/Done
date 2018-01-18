using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_timeoff_policy_item")]
    [Serializable]
    [DataContract]
    public partial class tst_timeoff_policy_item : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 timeoff_policy_id { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public Int32? accrual_period_type_id { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }


    }
}
