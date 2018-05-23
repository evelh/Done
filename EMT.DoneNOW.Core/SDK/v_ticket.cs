
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_ticket")]
    [Serializable]
    [DataContract]
    public partial class v_ticket
    {

        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String classification_icon_path { get; set; }
        [DataMember]
        public String classification_name { get; set; }
        [DataMember]
        public Int32? classification_id { get; set; }
        [DataMember]
        public Int32? territory_id { get; set; }
        [DataMember]
        public Int32? account_type_id { get; set; }
        [DataMember]
        public Int64? account_manager_id { get; set; }
        [DataMember]
        public String no { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? issue_type_id { get; set; }
        [DataMember]
        public Int32? sub_issue_type_id { get; set; }
        [DataMember]
        public String account_name { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public String contract_name { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int32? contract_type_id { get; set; }
        [DataMember]
        public String queue_name { get; set; }
        [DataMember]
        public Int64? queue_id { get; set; }
        [DataMember]
        public String resouce_all { get; set; }
        [DataMember]
        public String resouce_plus { get; set; }
        [DataMember]
        public String role_name { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public String status_name { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public String priority_type_name { get; set; }
        [DataMember]
        public Int32? priority_type_id { get; set; }
        [DataMember]
        public String estimated_end_time { get; set; }
        [DataMember]
        public Decimal worked_hours { get; set; }
        [DataMember]
        public Decimal billed_hours { get; set; }
        [DataMember]
        public Int64? product_id { get; set; }
        [DataMember]
        public Int64? product_cate_id { get; set; }
        [DataMember]
        public String serial_Number { get; set; }
        [DataMember]
        public String reference_Number { get; set; }
        [DataMember]
        public String reference_name { get; set; }
        [DataMember]
        public Int32? source_type_id { get; set; }
        [DataMember]
        public Int32? ticket_type_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Int64? queue_leader_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64? parent_account_id { get; set; }
        [DataMember]
        public Int64? owner_resource_id { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public String problem_no { get; set; }
        [DataMember]
        public String date_completed { get; set; }
        [DataMember]
        public String resolution { get; set; }
        [DataMember]
        public Int32? approve_status_id { get; set; }
        [DataMember]
        public Int64? change_Board_id { get; set; }
        [DataMember]
        public Int32 recurring { get; set; }
        [DataMember]
        public Decimal estimated_hours { get; set; }
        [DataMember]
        public Decimal variance_Hours { get; set; }
        [DataMember]
        public Decimal? hours_to_be_Scheduled { get; set; }
        [DataMember]
        public Int64? recurring_ticket_id { get; set; }
        [DataMember]
        public String status_icon { get; set; }
        [DataMember]
        public String priority_type_icon { get; set; }
        [DataMember]
        public Int32 service_Call_Scheduled { get; set; }
        [DataMember]
        public Int64? installed_product_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int64? recurring_frequency { get; set; }
        [DataMember]
        public String queue_no { get; set; }
        [DataMember]
        public String phone { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public Int32? reopened_count { get; set; }
        [DataMember]
        public String last_activity_time { get; set; }
        [DataMember]
        public String last_workflow_activity_time { get; set; }
        [DataMember]
        public Int64? sla_id { get; set; }
        [DataMember]
        public String next_sla_time { get; set; }
        [DataMember]
        public String first_response_target_time { get; set; }
        [DataMember]
        public String resolution_plan_target_time { get; set; }
        [DataMember]
        public String resolution_target_time { get; set; }
        [DataMember]
        public String first_activity_time { get; set; }
        [DataMember]
        public String resolution_plan_actual_time { get; set; }
        [DataMember]
        public String resolution_actual_time { get; set; }
        [DataMember]
        public String sla_start_time { get; set; }
        [DataMember]
        public String begin_time { get; set; }
        [DataMember]
        public String external_ID { get; set; }
        [DataMember]
        public Int64? problem_ticket_id { get; set; }
        [DataMember]
        public Int32? age { get; set; }
        [DataMember]
        public Int32? due_days { get; set; }


    }
}