
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_project")]
    [Serializable]
    [DataContract]
    public partial class v_project
    {

        [DataMember]
        public Int64 project_id { get; set; }
        [DataMember]
        public Int32? classification_id { get; set; }
        [DataMember]
        public String classification { get; set; }
        [DataMember]
        public String classification_tooltip { get; set; }
        [DataMember]
        public String project_name { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public String account_name { get; set; }
        [DataMember]
        public Int64? parent_account_id { get; set; }
        [DataMember]
        public String parent_account_name { get; set; }
        [DataMember]
        public String account_manager { get; set; }
        [DataMember]
        public Int64? account_manager_id { get; set; }
        [DataMember]
        public Int32? market_segment_id { get; set; }
        [DataMember]
        public String market_segment_name { get; set; }
        [DataMember]
        public Int64? region_id { get; set; }
        [DataMember]
        public String region_name { get; set; }
        [DataMember]
        public Int32? territory_id { get; set; }
        [DataMember]
        public String territory_name { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public String contract_name { get; set; }
        [DataMember]
        public SByte? contract_status_Id { get; set; }
        [DataMember]
        public Int64? bill_account_id { get; set; }
        [DataMember]
        public String bill_account_name { get; set; }
        [DataMember]
        public Int32? bill_Post_type_id { get; set; }
        [DataMember]
        public String bill_Post_type_name { get; set; }
        [DataMember]
        public Int32? contact_cate_id { get; set; }
        [DataMember]
        public String contact_cate_name { get; set; }
        [DataMember]
        public Decimal? contract_estimate_cost { get; set; }
        [DataMember]
        public Decimal? contract_estimate_hours { get; set; }
        [DataMember]
        public Decimal? contract_estimate_revenue { get; set; }
        [DataMember]
        public SByte? contract_outof_compliance { get; set; }
        [DataMember]
        public DateTime? contract_start_date { get; set; }
        [DataMember]
        public DateTime? contract_end_date { get; set; }
        [DataMember]
        public Int32? contract_type_id { get; set; }
        [DataMember]
        public String contract_type_name { get; set; }
        [DataMember]
        public Decimal contract_current_balance { get; set; }
        [DataMember]
        public Decimal contract_total_balance { get; set; }
        [DataMember]
        public String project_type { get; set; }
        [DataMember]
        public Int32? type_id { get; set; }
        [DataMember]
        public String start_date { get; set; }
        [DataMember]
        public String end_date { get; set; }
        [DataMember]
        public Int32? duration { get; set; }
        [DataMember]
        public Int32? remain_days { get; set; }
        [DataMember]
        public Decimal? complete_percent { get; set; }
        [DataMember]
        public Decimal? complete_percent_hours { get; set; }
        [DataMember]
        public Decimal? estimated_hours { get; set; }
        [DataMember]
        public Decimal? worked_hours { get; set; }
        [DataMember]
        public Decimal remain_hours { get; set; }
        [DataMember]
        public String line_of_business { get; set; }
        [DataMember]
        public Int32? line_of_business_id { get; set; }
        [DataMember]
        public String status_name { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public String status_date { get; set; }
        [DataMember]
        public String department { get; set; }
        [DataMember]
        public Int64? department_id { get; set; }
        [DataMember]
        public String location { get; set; }
        [DataMember]
        public String leader { get; set; }
        [DataMember]
        public Int64? owner_resource_id { get; set; }
        [DataMember]
        public Decimal? original_revenue { get; set; }
        [DataMember]
        public String project_no { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public String status_time { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public Int64? opportunity_owner_id { get; set; }
        [DataMember]
        public String opportunity_owner { get; set; }
        [DataMember]
        public String status_detail { get; set; }


    }
}