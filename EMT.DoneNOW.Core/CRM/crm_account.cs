using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_account")]
    [Serializable]
    [DataContract]
    public partial class crm_account : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }
        [DataMember]
        public Int32? territory_id { get; set; }
        [DataMember]
        public Int32? market_segment_id { get; set; }
        [DataMember]
        public Int32? competitor_id { get; set; }
        [DataMember]
        public String account_name { get; set; }
        [DataMember]
        public SByte? is_active { get; set; }
        [DataMember]
        public SByte? is_costed_client { get; set; }
        [DataMember]
        public SByte? is_taxable { get; set; }
        [DataMember]
        public SByte? is_block_account { get; set; }
        [DataMember]
        public Decimal? curr_block_balance { get; set; }
        [DataMember]
        public Decimal? mileage { get; set; }
        [DataMember]
        public String address1 { get; set; }
        [DataMember]
        public String address2 { get; set; }
        [DataMember]
        public Int32? district_id { get; set; }
        [DataMember]
        public String postal_code { get; set; }
        [DataMember]
        public String phone { get; set; }
        [DataMember]
        public String fax { get; set; }
        [DataMember]
        public String web_site { get; set; }
        [DataMember]
        public String alternate_phone1 { get; set; }
        [DataMember]
        public String alternate_phone2 { get; set; }
        [DataMember]
        public String stock_symbol { get; set; }
        [DataMember]
        public String stock_market { get; set; }
        [DataMember]
        public String sic_code { get; set; }
        [DataMember]
        public Decimal? asset_value { get; set; }
        [DataMember]
        public Int64? last_activity_time { get; set; }
        [DataMember]
        public Int32? account_type_id { get; set; }
        [DataMember]
        public Decimal? opportunity_value { get; set; }
        [DataMember]
        public Decimal? block_purchase_total { get; set; }
        [DataMember]
        public Decimal? block_deduction_total { get; set; }
        [DataMember]
        public Int32? account_classification_id { get; set; }
        [DataMember]
        public String extacct_customer_id { get; set; }
        [DataMember]
        public SByte? use_parent_account_contracts { get; set; }
        [DataMember]
        public String attention { get; set; }
        [DataMember]
        public Int64? survey_optout_time { get; set; }
        [DataMember]
        public String facebook_url { get; set; }
        [DataMember]
        public String twitter_url { get; set; }
        [DataMember]
        public String linkedin_url { get; set; }
        [DataMember]
        public String weibo_url { get; set; }
        [DataMember]
        public String wechat_mp_subscription { get; set; }
        [DataMember]
        public String wechat_mp_service { get; set; }
        [DataMember]
        public String phone_basic { get; set; }
        [DataMember]
        public Int32? country_id { get; set; }
        [DataMember]
        public String additional_address_information { get; set; }
        [DataMember]
        public Int32? tax_region_id { get; set; }
        [DataMember]
        public String tax_identification { get; set; }
        [DataMember]
        public String alternate_phone1_basic { get; set; }
        [DataMember]
        public String alternate_phone2_basic { get; set; }


    }

}
