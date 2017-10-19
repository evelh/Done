using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("pro_project")]
    [Serializable]
    [DataContract]
    public partial class pro_project : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int32? type_id { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public String no { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public DateTime? start_date { get; set; }
        [DataMember]
        public DateTime? end_date { get; set; }
        [DataMember]
        public Int32? duration { get; set; }
        [DataMember]
        public Decimal actual_project_time { get; set; }
        [DataMember]
        public Decimal actual_project_billed_time { get; set; }
        [DataMember]
        public Decimal est_project_time { get; set; }
        [DataMember]
        public Decimal actual_revenue { get; set; }
        [DataMember]
        public Decimal labor_revenue { get; set; }
        [DataMember]
        public Decimal labor_budget { get; set; }
        [DataMember]
        public Decimal labor_margin { get; set; }
        [DataMember]
        public Decimal cost_revenue { get; set; }
        [DataMember]
        public Decimal cost_budget { get; set; }
        [DataMember]
        public Decimal cost_margin { get; set; }
        [DataMember]
        public Decimal? change_orders_revenue { get; set; }
        [DataMember]
        public Decimal? change_orders_budget { get; set; }
        [DataMember]
        public Decimal original_sgda { get; set; }
        [DataMember]
        public Decimal original_revenue { get; set; }
        [DataMember]
        public Decimal original_sales_cost { get; set; }
        [DataMember]
        public Int32 probability { get; set; }
        [DataMember]
        public Decimal project_costs { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public String status_detail { get; set; }
        [DataMember]
        public Int64 status_time { get; set; }
        [DataMember]
        public Int32? importance_id { get; set; }
        [DataMember]
        public Int64? template_id { get; set; }
        [DataMember]
        public Int64? owner_resource_id { get; set; }
        [DataMember]
        public Int64? sales_id { get; set; }
        [DataMember]
        public Int32 completed_percentage { get; set; }
        [DataMember]
        public Int64? completed_time { get; set; }
        [DataMember]
        public Decimal cash_collected { get; set; }
        [DataMember]
        public Int64? baseline_id { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public Int64? department_id { get; set; }
        [DataMember]
        public Int32? line_of_business_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Int64? edit_event_id { get; set; }
        [DataMember]
        public SByte exclude_holiday { get; set; }
        [DataMember]
        public SByte exclude_weekend { get; set; }
        [DataMember]
        public SByte warn_time_off { get; set; }
        [DataMember]
        public Int64 organization_location_id { get; set; }
        [DataMember]
        public Decimal resource_daily_hours { get; set; }
        [DataMember]
        public Int32? percent_complete { get; set; }
        [DataMember]
        public Int32 automatic_leveling_end_date_offset_days { get; set; }
        [DataMember]
        public SByte use_resource_daily_hours { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }


    }
}