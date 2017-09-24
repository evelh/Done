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
        public Int32? duration { get; set; }
        [DataMember]
        public Int32? timeline { get; set; }
        [DataMember]
        public Int64? rate { get; set; }
        [DataMember]
        public Int64? ci { get; set; }
        [DataMember]
        public Int64? project { get; set; }
        [DataMember]
        public Int64? ticket { get; set; }
        [DataMember]
        public Int64? note { get; set; }
        [DataMember]
        public Int64? milestone { get; set; }
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
        public Decimal labor_hours_billed { get; set; }
        [DataMember]
        public Decimal labor_amount_billed { get; set; }
        [DataMember]
        public Decimal? initial_pay { get; set; }
        [DataMember]
        public Decimal? total_pay { get; set; }
        [DataMember]
        public Decimal? estimated_revenue { get; set; }
        [DataMember]
        public Decimal? estimated_revenue_balance { get; set; }


    }
}
