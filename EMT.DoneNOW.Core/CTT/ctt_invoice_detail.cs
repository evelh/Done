using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_invoice_detail")]
    [Serializable]
    [DataContract]
    public partial class ctt_invoice_detail
    {

        [Key]
        [DataMember]
        public Int64 invoice_id { get; set; }
        [DataMember]
        public Int32? emailed_resource_id { get; set; }
        [DataMember]
        public SByte is_emailed { get; set; }
        [DataMember]
        public String email_from_address { get; set; }
        [DataMember]
        public String email_to_address { get; set; }
        [DataMember]
        public String email_cc_address { get; set; }
        [DataMember]
        public String email_bcc_address { get; set; }
        [DataMember]
        public Int64? emailed_time { get; set; }
        [DataMember]
        public String bill_to_attention { get; set; }
        [DataMember]
        public String bill_to_address1 { get; set; }
        [DataMember]
        public String bill_to_address2 { get; set; }
        [DataMember]
        public String bill_to_city { get; set; }
        [DataMember]
        public String bill_to_country { get; set; }
        [DataMember]
        public String bill_to_state { get; set; }
        [DataMember]
        public String bill_to_zip { get; set; }
        [DataMember]
        public String service_provider_full_name { get; set; }
        [DataMember]
        public String service_provider_address1 { get; set; }
        [DataMember]
        public String service_provider_address2 { get; set; }
        [DataMember]
        public String service_provider_city { get; set; }
        [DataMember]
        public String service_provider_state { get; set; }
        [DataMember]
        public String service_provider_zip { get; set; }
        [DataMember]
        public String service_provider_phone { get; set; }
        [DataMember]
        public String service_provider_fax { get; set; }
        [DataMember]
        public String html_invoice_details { get; set; }
        [DataMember]
        public String additional_bill_to_address_information { get; set; }
        [DataMember]
        public String bill_to_address_format_string { get; set; }


    }
}