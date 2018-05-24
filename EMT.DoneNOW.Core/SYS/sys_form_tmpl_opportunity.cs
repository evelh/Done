using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_opportunity")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_opportunity : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 form_tmpl_id { get; set; }
        [DataMember]
        public String opportunity_no { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32? stage_id { get; set; }
        [DataMember]
        public Int32? source_id { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }
        [DataMember]
        public Int32? competitor_id { get; set; }
        [DataMember]
        public Int32? probability { get; set; }
        [DataMember]
        public Int32? interest_degree_id { get; set; }
        [DataMember]
        public DateTime? projected_begin_date { get; set; }
        [DataMember]
        public Int32? projected_close_date_type_id { get; set; }
        [DataMember]
        public Int32? projected_close_date_type_value { get; set; }
        [DataMember]
        public Int64? primary_product_id { get; set; }
        [DataMember]
        public String promotion_name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64? last_activity_time { get; set; }
        [DataMember]
        public String market { get; set; }
        [DataMember]
        public String barriers { get; set; }
        [DataMember]
        public String help_needed { get; set; }
        [DataMember]
        public String next_step { get; set; }
        [DataMember]
        public Int32? win_reason_type_id { get; set; }
        [DataMember]
        public Int32? loss_reason_type_id { get; set; }
        [DataMember]
        public String win_reason { get; set; }
        [DataMember]
        public String loss_reason { get; set; }
        [DataMember]
        public Int32? spread_revenue_recognition_value { get; set; }
        [DataMember]
        public String spread_revenue_recognition_unit { get; set; }
        [DataMember]
        public Int32? number_months_for_estimating_total_profit { get; set; }
        [DataMember]
        public Decimal? one_time_revenue { get; set; }
        [DataMember]
        public Decimal? one_time_cost { get; set; }
        [DataMember]
        public Decimal? monthly_revenue { get; set; }
        [DataMember]
        public Decimal? monthly_cost { get; set; }
        [DataMember]
        public Decimal? quarterly_revenue { get; set; }
        [DataMember]
        public Decimal? quarterly_cost { get; set; }
        [DataMember]
        public Decimal? semi_annual_revenue { get; set; }
        [DataMember]
        public Decimal? semi_annual_cost { get; set; }
        [DataMember]
        public Decimal? yearly_revenue { get; set; }
        [DataMember]
        public Decimal? yearly_cost { get; set; }
        [DataMember]
        public SByte? use_quote_revenue_and_cost { get; set; }
        [DataMember]
        public Decimal? ext1 { get; set; }
        [DataMember]
        public Decimal? ext2 { get; set; }
        [DataMember]
        public Decimal? ext3 { get; set; }
        [DataMember]
        public Decimal? ext4 { get; set; }
        [DataMember]
        public Decimal? ext5 { get; set; }
        [DataMember]
        public Int64? start_date { get; set; }
        [DataMember]
        public Int64? end_date { get; set; }
        [DataMember]
        public Int64? actual_closed_time { get; set; }


    }
}
