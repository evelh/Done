
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_sla_item")]
    [Serializable]
    [DataContract]
    public partial class d_sla_item : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 sla_id { get; set; }
        [DataMember]
        public Int32? priority_id { get; set; }
        [DataMember]
        public Int32? issue_type_id { get; set; }
        [DataMember]
        public Int32? sub_issue_type_id { get; set; }
        [DataMember]
        public Decimal first_response_target_hours { get; set; }
        [DataMember]
        public Decimal resolution_plan_target_hours { get; set; }
        [DataMember]
        public Decimal resolution_target_hours { get; set; }
        [DataMember]
        public Int32 sla_timeframe_id { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public Int32 first_response_target_type_id { get; set; }
        [DataMember]
        public Int32 resolution_plan_target_type_id { get; set; }
        [DataMember]
        public Int32 resolution_target_type_id { get; set; }
        [DataMember]
        public Int32? ticket_cate_id { get; set; }
        [DataMember]
        public Int32? ticket_type_id { get; set; }


    }
}