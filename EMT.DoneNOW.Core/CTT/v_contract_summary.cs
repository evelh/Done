using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_contract_summary")]
    [Serializable]
    [DataContract]
    public partial class v_contract_summary
    {

        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int32 contract_type_id { get; set; }
        [DataMember]
        public String account_name { get; set; }
        [DataMember]
        public String account_manager_name { get; set; }
        [DataMember]
        public String contact_name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String sla { get; set; }
        [DataMember]
        public String opportunity_name { get; set; }
        [DataMember]
        public String is_sdt_default { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public String bill_post_type { get; set; }
        [DataMember]
        public String contract_type { get; set; }
        [DataMember]
        public String contract_cate { get; set; }
        [DataMember]
        public String contract_status { get; set; }
        [DataMember]
        public String external_no { get; set; }
        [DataMember]
        public DateTime start_date { get; set; }
        [DataMember]
        public DateTime end_date { get; set; }
        [DataMember]
        public String period_type { get; set; }
        [DataMember]
        public Int32? duration { get; set; }
        [DataMember]
        public Int32? timeline { get; set; }
        [DataMember]
        public Decimal current_period1 { get; set; }
        [DataMember]
        public Decimal current_period2 { get; set; }
        [DataMember]
        public Decimal previous_period1 { get; set; }
        [DataMember]
        public Decimal previous_period2 { get; set; }
        [DataMember]
        public Decimal previous_3_periods1 { get; set; }
        [DataMember]
        public Decimal previous_3_periods2 { get; set; }
        [DataMember]
        public Decimal contract_to_date1 { get; set; }
        [DataMember]
        public Decimal contract_to_date2 { get; set; }
        [DataMember]
        public Int64 rate { get; set; }
        [DataMember]
        public Int64 ci { get; set; }
        [DataMember]
        public Int64 project { get; set; }
        [DataMember]
        public Int64 ticket { get; set; }
        [DataMember]
        public Int64 note { get; set; }
        [DataMember]
        public Int64 milestone { get; set; }
        [DataMember]
        public Int64 active_blocks { get; set; }
        [DataMember]
        public Decimal total_Tickets_Purchase { get; set; }
        [DataMember]
        public Int64 ticket_used { get; set; }
        [DataMember]
        public Decimal ticked_expired { get; set; }
        [DataMember]
        public Decimal ticket_remaining { get; set; }
        [DataMember]
        public Decimal totla_current_tickets { get; set; }
        [DataMember]
        public Int64 current_ticket_used { get; set; }
        [DataMember]
        public Decimal name_exp_43 { get; set; }
        [DataMember]
        public Int64 current_ticket_remaining { get; set; }
        [DataMember]
        public Decimal open_Ticket { get; set; }
        [DataMember]
        public Int64 active_purchases { get; set; }
        [DataMember]
        public Decimal total_amount_purchase { get; set; }
        [DataMember]
        public Decimal total_amount_purchase_remain { get; set; }
        [DataMember]
        public Decimal total_block_hours { get; set; }
        [DataMember]
        public Decimal total_block_hours_remain { get; set; }
        [DataMember]
        public Decimal total_block_hours_remain_active { get; set; }
        [DataMember]
        public Decimal? billable_amount_need_Approve { get; set; }
        [DataMember]
        public Decimal? billable_Hours_need_Approve { get; set; }
        [DataMember]
        public Decimal? contract_charge_price_total { get; set; }
        [DataMember]
        public Decimal? contract_charge_cost_total { get; set; }
        [DataMember]
        public Decimal? pt_charge_price_total { get; set; }
        [DataMember]
        public Decimal? pt_charge_cost_total { get; set; }
        [DataMember]
        public Decimal? labor_cost { get; set; }
        [DataMember]
        public Decimal? hours_worked { get; set; }
        [DataMember]
        public Decimal? labor_hours_billed { get; set; }
        [DataMember]
        public Decimal? labor_amount_billed { get; set; }
        [DataMember]
        public Decimal? initial_pay { get; set; }
        [DataMember]
        public Decimal? total_pay { get; set; }
        [DataMember]
        public Decimal? estimated_revenue { get; set; }
        [DataMember]
        public Decimal? estimated_revenue_balance { get; set; }
        [DataMember]
        public Decimal? setup_fee { get; set; }
        [DataMember]
        public Int64? contract_periods { get; set; }
        [DataMember]
        public DateTime? first_billed_date { get; set; }
        [DataMember]
        public DateTime? second_billing_date { get; set; }
        [DataMember]
        public DateTime? final_billing_Date { get; set; }


    }
}
