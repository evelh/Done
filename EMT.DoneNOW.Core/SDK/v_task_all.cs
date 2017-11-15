
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_task_all")]
    [Serializable]
    [DataContract]
    public partial class v_task_all
    {

        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String sid { get; set; }
        [DataMember]
        public Int64? alert { get; set; }
        [DataMember]
        public String milestone_issue_icon { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public Decimal? estimated_hours { get; set; }
        [DataMember]
        public Decimal? estimated_duration { get; set; }
        [DataMember]
        public String predecessors { get; set; }
        [DataMember]
        public String estimated_begin_time { get; set; }
        [DataMember]
        public String estimated_end_date { get; set; }
        [DataMember]
        public String work_type { get; set; }
        [DataMember]
        public String resource { get; set; }
        [DataMember]
        public String department { get; set; }
        [DataMember]
        public Decimal? hours_to_be_Scheduled { get; set; }
        [DataMember]
        public Decimal? worked_hours { get; set; }
        [DataMember]
        public Decimal? billable_hours { get; set; }
        [DataMember]
        public Decimal? non_Billable_hours { get; set; }
        [DataMember]
        public Decimal? billed_hours { get; set; }
        [DataMember]
        public Decimal? remain_hours { get; set; }
        [DataMember]
        public Decimal? projected_variance { get; set; }
        [DataMember]
        public Decimal? change_Order_Hours { get; set; }
        [DataMember]
        public Byte? budgeted_Hours { get; set; }
        [DataMember]
        public Decimal? variance_Hours { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Decimal? hours_per_resource { get; set; }
        [DataMember]
        public Byte? in_My_Work_List { get; set; }
        [DataMember]
        public String issue_report_contact { get; set; }
        [DataMember]
        public Byte[] number_of_milestone { get; set; }
        [DataMember]
        public Int64? number_of_successors { get; set; }
        [DataMember]
        public Decimal? complete_percent { get; set; }
        [DataMember]
        public Int32? priority { get; set; }
        [DataMember]
        public String service_Call_Scheduled { get; set; }
        [DataMember]
        public String status { get; set; }
        [DataMember]
        public String status_icon { get; set; }
        [DataMember]
        public String no { get; set; }
        [DataMember]
        public String sort_order { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public SByte? is_project_issue { get; set; }
        [DataMember]
        public Int64? baseline_project_id { get; set; }


    }
}