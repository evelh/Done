
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_other")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_other : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public String impact_analysis { get; set; }
        [DataMember]
        public String implementation_plan { get; set; }
        [DataMember]
        public String roll_out_plan { get; set; }
        [DataMember]
        public String back_out_plan { get; set; }
        [DataMember]
        public String review_notes { get; set; }
        [DataMember]
        public Int64? change_board_id { get; set; }
        [DataMember]
        public Int32 approval_type_id { get; set; }


    }
}