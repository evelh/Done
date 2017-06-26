using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class FormTmplOpportunityDto
    {
        public Int32 form_type_id { get; set; }
        public String tmpl_name { get; set; }
        public String speed_code { get; set; }
        public SByte tmpl_is_active { get; set; }
        public String remark { get; set; }
        public Int32 range_type_id { get; set; }
        public Int32? range_department_id { get; set; }
        public String opportunity_no { get; set; }
        public Int64? resource_id { get; set; }
        public Int64? contact_id { get; set; }
        public Int64? account_id { get; set; }
        public String name { get; set; }
        public Int32? stage_id { get; set; }
        public Int32? source_id { get; set; }
        public Int32? status_id { get; set; }
        public Int32? competitor_id { get; set; }
        public Int32? probability { get; set; }
        public Int32? interest_degree_id { get; set; }
        public DateTime? projected_begin_date { get; set; }
        public Int32? projected_close_date_type_id { get; set; }
        public Int32? projected_close_date_type_value { get; set; }
        public Int64? primary_product_id { get; set; }
        public String promotion_name { get; set; }
        public String description { get; set; }
        public Int64? last_activity_time { get; set; }
        public String market { get; set; }
        public String barriers { get; set; }
        public String help_needed { get; set; }
        public String next_step { get; set; }
        public Int32? win_reason_type_id { get; set; }
        public Int32? loss_reason_type_id { get; set; }
        public String win_reason { get; set; }
        public String loss_reason { get; set; }
        public Int32? spread_revenue_recognition_value { get; set; }
        public String spread_revenue_recognition_unit { get; set; }
        public Int32? number_months_for_estimating_total_profit { get; set; }
        public Decimal? one_time_revenue { get; set; }
        public Decimal? one_time_cost { get; set; }
        public Decimal? monthly_revenue { get; set; }
        public Decimal? monthly_cost { get; set; }
        public Decimal? quarterly_revenue { get; set; }
        public Decimal? quarterly_cost { get; set; }
        public Decimal? semi_annual_revenue { get; set; }
        public Decimal? semi_annual_cost { get; set; }
        public Decimal? yearly_revenue { get; set; }
        public Decimal? yearly_cost { get; set; }
        public SByte? use_quote_revenue_and_cost { get; set; }
        public Decimal? ext1 { get; set; }
        public Decimal? ext2 { get; set; }
        public Decimal? ext3 { get; set; }
        public Decimal? ext4 { get; set; }
        public Decimal? ext5 { get; set; }
        public Int64? start_date { get; set; }
        public Int64? end_date { get; set; }
        public Int64? actual_closed_time { get; set; }
    }
}
