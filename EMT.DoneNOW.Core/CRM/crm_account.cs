using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
    [Table("crm_account")]
    [Serializable]
    public partial class crm_account
    {

        [Key]
        [Column("id")]
        public Int64 id { get; set; }
        [Column("external_id")]
        public String external_id { get; set; }
        [Column("parent_id")]
        public Int64? parent_id { get; set; }
        [Column("territory_id")]
        public Int32? territory_id { get; set; }
        [Column("market_segment_id")]
        public Int32? market_segment_id { get; set; }
        [Column("competition_id")]
        public Int32? competition_id { get; set; }
        [Column("account_name")]
        public String account_name { get; set; }
        [Column("active")]
        public SByte? active { get; set; }
        [Column("costed_client")]
        public SByte? costed_client { get; set; }
        [Column("taxable")]
        public SByte taxable { get; set; }
        [Column("block_account")]
        public SByte? block_account { get; set; }
        [Column("curr_block_balance")]
        public Decimal? curr_block_balance { get; set; }
        [Column("mileage")]
        public Decimal? mileage { get; set; }
        [Column("addr1")]
        public String addr1 { get; set; }
        [Column("addr2")]
        public String addr2 { get; set; }
        [Column("city")]
        public String city { get; set; }
        [Column("region")]
        public String region { get; set; }
        [Column("country")]
        public String country { get; set; }
        [Column("postal_code")]
        public String postal_code { get; set; }
        [Column("phone")]
        public String phone { get; set; }
        [Column("fax")]
        public String fax { get; set; }
        [Column("internet")]
        public String internet { get; set; }
        [Column("alternate_phone")]
        public String alternate_phone { get; set; }
        [Column("alternate_phone1")]
        public String alternate_phone1 { get; set; }
        [Column("stock_symbol")]
        public String stock_symbol { get; set; }
        [Column("stock_market")]
        public String stock_market { get; set; }
        [Column("sic_code")]
        public String sic_code { get; set; }
        [Column("asset_value")]
        public Decimal? asset_value { get; set; }
        [Column("last_activity")]
        public DateTime last_activity { get; set; }
        [Column("date_stamp")]
        public DateTime date_stamp { get; set; }
        [Column("cust_type")]
        public Int16? cust_type { get; set; }
        [Column("opportunity_value")]
        public Decimal? opportunity_value { get; set; }
        [Column("blockPurchase_total")]
        public Decimal? blockPurchase_total { get; set; }
        [Column("blockDeduction_total")]
        public Decimal? blockDeduction_total { get; set; }
        [Column("classification_id")]
        public Int32? classification_id { get; set; }
        [Column("extAcctCustomer_id")]
        public String extAcctCustomer_id { get; set; }
        [Column("use_parent_account_contracts")]
        public SByte use_parent_account_contracts { get; set; }
        [Column("attention")]
        public String attention { get; set; }
        [Column("survey_optout_time")]
        public DateTime? survey_optout_time { get; set; }
        [Column("facebook_url")]
        public String facebook_url { get; set; }
        [Column("twitter_url")]
        public String twitter_url { get; set; }
        [Column("linkedin_url")]
        public String linkedin_url { get; set; }
        [Column("phone_basic")]
        public String phone_basic { get; set; }
        [Column("country_id")]
        public Int32? country_id { get; set; }
        [Column("additional_address_information")]
        public String additional_address_information { get; set; }
        [Column("tax_region_id")]
        public Int32? tax_region_id { get; set; }
        [Column("tax_identification")]
        public String tax_identification { get; set; }
        [Column("alternate_phone_basic")]
        public String alternate_phone_basic { get; set; }
        [Column("alternate_phone1_basic")]
        public String alternate_phone1_basic { get; set; }
        [Column("delete_time")]
        public Int64? delete_time { get; set; }
        [Column("create_time")]
        public Int64? create_time { get; set; }
        [Column("create_by_id")]
        public Int64? create_by_id { get; set; }
        [Column("update_time")]
        public Int64? update_time { get; set; }
        [Column("update_by_id")]
        public Int64? update_by_id { get; set; }
        [Column("delete_by_id")]
        public Int64? delete_by_id { get; set; }


    }
}
