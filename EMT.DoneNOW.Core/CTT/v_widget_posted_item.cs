
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_widget_posted_item")]
    [Serializable]
    [DataContract]
    public partial class v_widget_posted_item
    {

        [DataMember]
        public Int64? id { get; set; }
        [DataMember]
        public String type_icon { get; set; }
        [DataMember]
        public String item_type_id { get; set; }
        [DataMember]
        public String item_type_name { get; set; }
        [DataMember]
        public String item_date { get; set; }
        [DataMember]
        public String item_name { get; set; }
        [DataMember]
        public Int64? bill_account_id { get; set; }
        [DataMember]
        public String bill_account_name { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public String account_name { get; set; }
        [DataMember]
        public Int64? parent_account_id { get; set; }
        [DataMember]
        public String parent_account_name { get; set; }
        [DataMember]
        public Int64? account_manager_id { get; set; }
        [DataMember]
        public String account_manager_name { get; set; }
        [DataMember]
        public Int64? region_id { get; set; }
        [DataMember]
        public String region_name { get; set; }
        [DataMember]
        public Int32? territory_id { get; set; }
        [DataMember]
        public String territory_name { get; set; }
        [DataMember]
        public Int32? classification_id { get; set; }
        [DataMember]
        public String classification_name { get; set; }
        [DataMember]
        public String classification_icon_path { get; set; }
        [DataMember]
        public String classification { get; set; }
        [DataMember]
        public Int64? department_id { get; set; }
        [DataMember]
        public String department_name { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public String contract_name { get; set; }
        [DataMember]
        public Int32? contract_type_id { get; set; }
        [DataMember]
        public String contract_type_name { get; set; }
        [DataMember]
        public Int32? contract_cate_id { get; set; }
        [DataMember]
        public String contract_cate_name { get; set; }
        [DataMember]
        public Int64? contract_block_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public String project_name { get; set; }
        [DataMember]
        public Int64? work_type { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public String role_name { get; set; }
        [DataMember]
        public Int64? cost_code_id { get; set; }
        [DataMember]
        public String cost_code_name { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public String resource_name { get; set; }
        [DataMember]
        public Decimal? rate { get; set; }
        [DataMember]
        public Decimal? hourly_rate { get; set; }
        [DataMember]
        public Decimal? quantity { get; set; }
        [DataMember]
        public Decimal? billable_hours { get; set; }
        [DataMember]
        public Decimal dollars { get; set; }
        [DataMember]
        public Int64? tax_category_id { get; set; }
        [DataMember]
        public String tax_category_name { get; set; }
        [DataMember]
        public Int32? tax_region_id { get; set; }
        [DataMember]
        public String bill_to_parent { get; set; }
        [DataMember]
        public String bill_to_sub { get; set; }
        [DataMember]
        public Int32? item_sub_type_id { get; set; }
        [DataMember]
        public String item_sub_type_name { get; set; }
        [DataMember]
        public Int64? invoice_id { get; set; }
        [DataMember]
        public Int32? invoice_line_item_no { get; set; }
        [DataMember]
        public String item_desc { get; set; }
        [DataMember]
        public String item_title { get; set; }
        [DataMember]
        public Int64? project_type_id { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64? is_billable { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }
        [DataMember]
        public Int64? item_id { get; set; }
        [DataMember]
        public Decimal? from_block { get; set; }
        [DataMember]
        public Decimal? no_from_block { get; set; }
        [DataMember]
        public Decimal? from_block_hours { get; set; }
        [DataMember]
        public Decimal? no_from_block_hours { get; set; }
        [DataMember]
        public String posted_date { get; set; }
        [DataMember]
        public String posted_user_id { get; set; }
        [DataMember]
        public Decimal dollars_minus_block { get; set; }
        [DataMember]
        public DateTime? estimated_arrival_date { get; set; }
        [DataMember]
        public DateTime? invoice_date { get; set; }
        [DataMember]
        public DateTime? invoice_paid_date { get; set; }
        [DataMember]
        public Int64? invoice_oid { get; set; }
        [DataMember]
        public String invoice_no { get; set; }
        [DataMember]
        public Int64? market_segment_id { get; set; }
        [DataMember]
        public String market_segment_name { get; set; }
        [DataMember]
        public Int64? service_id { get; set; }
        [DataMember]
        public String service_name { get; set; }
        [DataMember]
        public Int64? service_bundle_id { get; set; }
        [DataMember]
        public String service_bundle_name { get; set; }
        [DataMember]
        public Int32? procurement_status_id { get; set; }
        [DataMember]
        public String procurement_status_name { get; set; }
        [DataMember]
        public Int64? task_status_id { get; set; }
        [DataMember]
        public String task_status_name { get; set; }
        [DataMember]
        public Int64? show_on_invoice { get; set; }
        [DataMember]
        public String task_no { get; set; }
        [DataMember]
        public String ticket_no { get; set; }
        [DataMember]
        public String task_ticket_no { get; set; }
        [DataMember]
        public String invoice_internal_description { get; set; }
        [DataMember]
        public Decimal contract_current_balance { get; set; }
        [DataMember]
        public SByte? contract_status_id { get; set; }
        [DataMember]
        public String contract_status_name { get; set; }
        [DataMember]
        public Int32? bill_Post_type_id { get; set; }
        [DataMember]
        public String contract_end_date { get; set; }
        [DataMember]
        public Decimal? contract_estimate_cost { get; set; }
        [DataMember]
        public Decimal? contract_estimate_hours { get; set; }
        [DataMember]
        public Decimal? contract_estimate_revenue { get; set; }
        [DataMember]
        public String contract_begin_date { get; set; }
        [DataMember]
        public SByte? contract_outof_compliance { get; set; }
        [DataMember]
        public Decimal contract_total_balance { get; set; }
        [DataMember]
        public Int64? project_owner_resource_ID { get; set; }
        [DataMember]
        public String project_owner_resource_name { get; set; }
        [DataMember]
        public Int64? project_line_of_business_id { get; set; }
        [DataMember]
        public String project_line_of_business_name { get; set; }
        [DataMember]
        public Decimal cost { get; set; }
        [DataMember]
        public Decimal profit { get; set; }
        [DataMember]
        public Decimal profitability { get; set; }
        [DataMember]
        public Decimal? original_hours_billed { get; set; }
        [DataMember]
        public Decimal? original_extended_price { get; set; }


    }
}