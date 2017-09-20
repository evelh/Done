using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_account_deduction")]
    [Serializable]
    [DataContract]
    public partial class crm_account_deduction : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32? type_id { get; set; }
        [DataMember]
        public Int64? contract_block_id { get; set; }
        [DataMember]
        public DateTime posted_date { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }
        [DataMember]
        public Decimal? extended_price { get; set; }
        [DataMember]
        public Decimal? quantity { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }
        [DataMember]
        public Decimal? rate { get; set; }
        [DataMember]
        public Decimal? block_hour_multiplier { get; set; }
        [DataMember]
        public Int64? bill_create_user_id { get; set; }
        [DataMember]
        public Int64? invoice_id { get; set; }
        [DataMember]
        public String adjust_reason { get; set; }
        [DataMember]
        public Int64? adjusted_account_deduction_id { get; set; }
        [DataMember]
        public Decimal? display_hours { get; set; }
        [DataMember]
        public Decimal? display_dollars { get; set; }
        [DataMember]
        public SByte? is_hidden { get; set; }
        [DataMember]
        public Int64? export_id { get; set; }
        [DataMember]
        public Int64? object_id { get; set; }
        [DataMember]
        public Decimal? tax_dollars { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public String tax_category_name { get; set; }
        [DataMember]
        public Decimal? effective_tax_rate { get; set; }
        [DataMember]
        public Int32? invoice_line_item_no { get; set; }
        [DataMember]
        public String tax_region_name { get; set; }
        [DataMember]
        public Int32? worksheetobjectid { get; set; }
        [DataMember]
        public SByte? billedposted { get; set; }
        [DataMember]
        public Int64? detailid { get; set; }
        [DataMember]
        public Decimal? otfactor { get; set; }
        [DataMember]
        public Int64? projectexpenseid { get; set; }
        [DataMember]
        public Int64? work_id { get; set; }
        [DataMember]
        public Int64? contract_service_period_id { get; set; }
        [DataMember]
        public Int64? contract_service_bundle_period_id { get; set; }
        [DataMember]
        public Int64? contract_service_adjustment_id { get; set; }
        [DataMember]
        public Int64? contract_service_bundle_adjustment_id { get; set; }
        [DataMember]
        public DateTime? web_service_date { get; set; }
        [DataMember]
        public Int64? contract_cost_id { get; set; }
        [DataMember]
        public Decimal? bill_factor { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }


    }
}