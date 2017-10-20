
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_task")]
    [Serializable]
    [DataContract]
    public partial class sdk_task : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public String no { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int32? priority_type_id { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int32? source_type_id { get; set; }
        [DataMember]
        public Int32? entries { get; set; }
        [DataMember]
        public DateTime? entrydate { get; set; }
        [DataMember]
        public Decimal? esttasktime { get; set; }
        [DataMember]
        public SByte scheduled { get; set; }
        [DataMember]
        public DateTime? scheduleddate { get; set; }
        [DataMember]
        public String scheduledtime { get; set; }
        [DataMember]
        public Int64? owner_resource_id { get; set; }
        [DataMember]
        public Decimal? total_worked_hours { get; set; }
        [DataMember]
        public Decimal? total_billed_hours { get; set; }
        [DataMember]
        public Decimal? total_billed_dollars { get; set; }
        [DataMember]
        public String reason { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int32 estimated_type_id { get; set; }
        [DataMember]
        public Int64? estimated_begin_time { get; set; }
        [DataMember]
        public DateTime? estimated_end_date { get; set; }
        [DataMember]
        public Int32? estimated_duration { get; set; }
        [DataMember]
        public Decimal estimated_hours { get; set; }
        [DataMember]
        public Decimal hours_per_resource { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public Int32? department_id { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }
        [DataMember]
        public UInt64? billable { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public DateTime? date_completed { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public Int32? issue_type_id { get; set; }
        [DataMember]
        public Int32? sub_issue_type_id { get; set; }
        [DataMember]
        public Int64? product_id { get; set; }
        [DataMember]
        public SByte? percentcomplete { get; set; }
        [DataMember]
        public String externalid { get; set; }
        [DataMember]
        public Decimal? change_orders_hours { get; set; }
        [DataMember]
        public Decimal? change_orders_dollars { get; set; }
        [DataMember]
        public SByte? is_cancelled { get; set; }
        [DataMember]
        public Int32? cobillable { get; set; }
        [DataMember]
        public Int32 priority { get; set; }
        [DataMember]
        public DateTime last_activity_date { get; set; }
        [DataMember]
        public Int32? contact_id { get; set; }
        [DataMember]
        public Int64? recurring_ticket_id { get; set; }
        [DataMember]
        public DateTime? first_activity_date { get; set; }
        [DataMember]
        public Int32? sla_id { get; set; }
        [DataMember]
        public UInt64? has_met_service_level_agreement { get; set; }
        [DataMember]
        public DateTime? first_response_target_time { get; set; }
        [DataMember]
        public DateTime? resolution_plan_target_time { get; set; }
        [DataMember]
        public DateTime? resolution_plan_actual_time { get; set; }
        [DataMember]
        public DateTime? resolution_target_time { get; set; }
        [DataMember]
        public DateTime? resolution_actual_time { get; set; }
        [DataMember]
        public DateTime? sla_start_time { get; set; }
        [DataMember]
        public String resolution { get; set; }
        [DataMember]
        public Int64? contract_block_id { get; set; }
        [DataMember]
        public Int32 taskfire_total_worked_minutes { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public Int32 last_modified_using_system_type_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Decimal resolution_elapsed_business_hours { get; set; }
        [DataMember]
        public Int64? edit_event_id { get; set; }
        [DataMember]
        public DateTime? last_workflow_activity_time { get; set; }
        [DataMember]
        public Int32 reopened_count { get; set; }
        [DataMember]
        public Int32 sort_order { get; set; }
        [DataMember]
        public DateTime? start_no_earlier_than_date { get; set; }
        [DataMember]
        public SByte is_visible_in_client_portal { get; set; }
        [DataMember]
        public SByte can_client_portal_user_complete_task { get; set; }
        [DataMember]
        public Int32? problem_ticket_id { get; set; }
        [DataMember]
        public Int32? ticket_type_id { get; set; }
        [DataMember]
        public SByte is_project_issue { get; set; }
        [DataMember]
        public Int64 issue_report_contact_id { get; set; }
        [DataMember]
        public Int32 automatic_leveling_start_date_offset_days { get; set; }
        [DataMember]
        public Int32 automatic_leveling_end_date_offset_days { get; set; }
        [DataMember]
        public Int64? template_id { get; set; }
        [DataMember]
        public Decimal projected_variance { get; set; }


    }
}