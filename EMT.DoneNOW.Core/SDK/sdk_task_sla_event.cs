
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task_sla_event")]
    [Serializable]
    [DataContract]
    public partial class sdk_task_sla_event : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Decimal first_response_elapsed_hours { get; set; }
        [DataMember]
        public Int64? first_response_resource_id { get; set; }
        [DataMember]
        public Decimal resolution_plan_elapsed_hours { get; set; }
        [DataMember]
        public Int64? resolution_plan_resource_id { get; set; }
        [DataMember]
        public Decimal resolution_elapsed_hours { get; set; }
        [DataMember]
        public Int64? resolution_resource_id { get; set; }
        [DataMember]
        public SByte? has_met_first_response_target { get; set; }
        [DataMember]
        public SByte? has_met_resolution_plan_target { get; set; }
        [DataMember]
        public SByte? has_met_resolution_target { get; set; }
        [DataMember]
        public Decimal total_waiting_customer_hours { get; set; }


    }
}