using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_invoice")]
    [Serializable]
    [DataContract]
    public partial class ctt_invoice : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 batch_id { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int64 owner_resource_id { get; set; }
        [DataMember]
        public String invoice_no { get; set; }
        [DataMember]
        public DateTime invoice_date { get; set; }
        [DataMember]
        public Decimal? total { get; set; }
        [DataMember]
        public Decimal? tax_value { get; set; }
        [DataMember]
        public String tax_description { get; set; }
        [DataMember]
        public String notes { get; set; }
        [DataMember]
        public DateTime? date_range_from { get; set; }
        [DataMember]
        public DateTime? date_range_to { get; set; }
        [DataMember]
        public Int32? payment_term_id { get; set; }
        [DataMember]
        public Int64 invoice_template_id { get; set; }
        [DataMember]
        public String page_header_html { get; set; }
        [DataMember]
        public String invoice_header_html { get; set; }
        [DataMember]
        public String invoice_body_html { get; set; }
        [DataMember]
        public String invoice_footer_html { get; set; }
        [DataMember]
        public String page_footer_html { get; set; }
        [DataMember]
        public String invoice_appendix_html { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public String tax_region_name { get; set; }
        [DataMember]
        public DateTime? paid_date { get; set; }
        [DataMember]
        public SByte is_voided { get; set; }
        [DataMember]
        public DateTime? voided_time { get; set; }
        [DataMember]
        public Int64? voided_resource_id { get; set; }
        [DataMember]
        public Int64? entrytimestamp { get; set; }
        [DataMember]
        public Int32? status { get; set; }
        [DataMember]
        public Decimal? federaltaxrate { get; set; }
        [DataMember]
        public Decimal? stateprovincialtaxrate { get; set; }
        [DataMember]
        public SByte? compprovincialtax { get; set; }
        [DataMember]
        public DateTime? invoice_processed_date { get; set; }
        [DataMember]
        public SByte invoice_processed_flag { get; set; }
        [DataMember]
        public String invoice_processing_log { get; set; }
        [DataMember]
        public DateTime? web_service_date { get; set; }
        [DataMember]
        public String displayrules { get; set; }
        [DataMember]
        public SByte is_preview { get; set; }


    }
}