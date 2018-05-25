
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_quote")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_quote : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 form_tmpl_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? effective_date { get; set; }
        [DataMember]
        public Int32? expiration_date { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int32? tax_region_id { get; set; }
        [DataMember]
        public SByte? is_active { get; set; }
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
        public SByte? bill_to_as_sold_to { get; set; }
        [DataMember]
        public SByte? ship_to_as_sold_to { get; set; }


    }
}