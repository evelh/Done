
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_recurring_ticket")]
    [Serializable]
    [DataContract]
    public partial class sdk_recurring_ticket : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Int64 last_instance_due_datetime { get; set; }
        [DataMember]
        public DateTime recurring_start_date { get; set; }
        [DataMember]
        public DateTime? recurring_end_date { get; set; }
        [DataMember]
        public Int32? recurring_instances { get; set; }
        [DataMember]
        public Int32 recurring_frequency { get; set; }
        [DataMember]
        public String recurring_define { get; set; }
        [DataMember]
        public Int32 last_instance_no { get; set; }
        [DataMember]
        public SByte? is_active { get; set; }
        [DataMember]
        public SByte service_call_created { get; set; }
        [DataMember]
        public Int32? recurring_every_days { get; set; }
        [DataMember]
        public Int32? recurring_every_weeks { get; set; }
        [DataMember]
        public Int32? recurring_every_months { get; set; }
        [DataMember]
        public String recurring_days { get; set; }
        [DataMember]
        public String recurring_months { get; set; }
        [DataMember]
        public String recurring_ignore_days { get; set; }
        [DataMember]
        public String recurring_occurence { get; set; }


    }
}