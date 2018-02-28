
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_sla")]
    [Serializable]
    [DataContract]
    public partial class d_sla : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public Int64? location_id { get; set; }
        [DataMember]
        public SByte set_ticket_due_date { get; set; }
        [DataMember]
        public Decimal first_response_goal_percentage { get; set; }
        [DataMember]
        public Decimal resolution_plan_goal_percentage { get; set; }
        [DataMember]
        public Decimal resolution_goal_percentage { get; set; }
        [DataMember]
        public Int32? time_zone_id { get; set; }
        [DataMember]
        public Int32? holiday_hours_type_id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 holiday_set_id { get; set; }


    }
}