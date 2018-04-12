using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_timeoff_total")]
    [Serializable]
    [DataContract]
    public partial class v_timeoff_total
    {

        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int32? calendar_year { get; set; }
        [DataMember]
        public Decimal annual_hours { get; set; }
        [DataMember]
        public Decimal additional_time { get; set; }
        [DataMember]
        public Decimal earned_to_date { get; set; }
        [DataMember]
        public Decimal hours_rolled_over { get; set; }
        [DataMember]
        public Decimal used_time { get; set; }
        [DataMember]
        public Decimal used_time_before_and_including_today { get; set; }
        [DataMember]
        public Decimal waiting_approval_time { get; set; }
        [DataMember]
        public Decimal used_time_after_today { get; set; }
        [DataMember]
        public Decimal waiting_approval_time_after_today { get; set; }
        [DataMember]
        public Decimal balance { get; set; }
        [DataMember]
        public Decimal current_balance { get; set; }


    }
}
