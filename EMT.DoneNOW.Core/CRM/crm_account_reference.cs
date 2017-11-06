using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_account_reference")]
    [Serializable]
    [DataContract]
    public partial class crm_account_reference : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int32? quote_tmpl_id { get; set; }
        [DataMember]
        public Int32? quote_email_message_tmpl_id { get; set; }
        [DataMember]
        public Int64? invoice_tmpl_id { get; set; }
        [DataMember]
        public Int32? invoice_email_message_tmpl_id { get; set; }
        [DataMember]
        public SByte? no_contract_bill_to_parent { get; set; }
        [DataMember]
        public Int32? invoice_address_type_id { get; set; }
        [DataMember]
        public String attention { get; set; }
        [DataMember]
        public Int32? country_id { get; set; }
        [DataMember]
        public Int32? province_id { get; set; }
        [DataMember]
        public Int32? city_id { get; set; }
        [DataMember]
        public Int32? district_id { get; set; }
        [DataMember]
        public Int32? town_id { get; set; }
        [DataMember]
        public String postal_code { get; set; }
        [DataMember]
        public String address { get; set; }
        [DataMember]
        public String additional_address { get; set; }
        [DataMember]
        public String email_to_contacts { get; set; }
        [DataMember]
        public String email_to_others { get; set; }
        [DataMember]
        public String email_bcc_resources { get; set; }
        [DataMember]
        public String email_bcc_account_manager { get; set; }
        [DataMember]
        public String email_notes { get; set; }
        [DataMember]
        public SByte? quickbooks_invoice_method_id { get; set; }
        [DataMember]
        public String bill_to_address_code { get; set; }
        [DataMember]
        public SByte? enable_email_invoice { get; set; }
        [DataMember]
        public Int64? billing_location_id { get; set; }

    }
}