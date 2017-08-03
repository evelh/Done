using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_quote")]
    [Serializable]
    [DataContract]
    public partial class crm_quote : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int64 opportunity_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public DateTime effective_date { get; set; }
        [DataMember]
        public DateTime expiration_date { get; set; }
        [DataMember]
        public DateTime projected_close_date { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public Int32? tax_region_id { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public Int32? quote_tmpl_id { get; set; }
        [DataMember]
        public String external_quote_no { get; set; }
        [DataMember]
        public String quote_comment { get; set; }
        [DataMember]
        public Int32? payment_term_id { get; set; }
        [DataMember]
        public Int32? payment_type_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Int32? shipping_type_id { get; set; }
        [DataMember]
        public Int64? sold_to_location_id { get; set; }
        [DataMember]
        public Int64? bill_to_location_id { get; set; }
        [DataMember]
        public Int64? ship_to_location_id { get; set; }
        [DataMember]
        public Int64? group_by_id { get; set; }
        [DataMember]
        public SByte? is_primary_quote { get; set; }
        [DataMember]
        public SByte? equote_is_active { get; set; }
        [DataMember]
        public String credit_card_holder_name { get; set; }
        [DataMember]
        public String credit_card_number { get; set; }
        [DataMember]
        public DateTime? credit_card_expiration_date { get; set; }
        [DataMember]
        public SByte? calculate_tax_separately { get; set; }
        [DataMember]
        public SByte? group_by_product_category { get; set; }
        [DataMember]
        public SByte? show_each_tax_in_tax_group { get; set; }
        [DataMember]
        public SByte? show_tax_category { get; set; }


    }
}