using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_order")]
    [Serializable]
    [DataContract]
    public partial class ivt_order : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 vendor_account_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int64? submit_time { get; set; }
        [DataMember]
        public Int64? cancel_time { get; set; }
        [DataMember]
        public Int64? email_time { get; set; }
        [DataMember]
        public Int64? submitted_resource_id { get; set; }
        [DataMember]
        public Int64? canceled_resource_id { get; set; }
        [DataMember]
        public Int64? emailed_resource_id { get; set; }
        [DataMember]
        public Int64 location_id { get; set; }
        [DataMember]
        public String note { get; set; }
        [DataMember]
        public String phone { get; set; }
        [DataMember]
        public String fax { get; set; }
        [DataMember]
        public String vendor_invoice_no { get; set; }
        [DataMember]
        public String external_purchase_order_no { get; set; }
        [DataMember]
        public Int64? purchase_account_id { get; set; }
        [DataMember]
        public Int32? shipping_type_id { get; set; }
        [DataMember]
        public DateTime? expected_ship_date { get; set; }
        [DataMember]
        public Decimal? freight_cost { get; set; }
        [DataMember]
        public Int32? payment_term_id { get; set; }
        [DataMember]
        public Int32 ship_to_type_id { get; set; }
        [DataMember]
        public Int32? tax_region_id { get; set; }
        [DataMember]
        public Int32? order_by_id { get; set; }
        [DataMember]
        public DateTime? order_create_date { get; set; }
        [DataMember]
        public DateTime? external_last_sync_time { get; set; }
        [DataMember]
        public SByte? display_tax_cate { get; set; }
        [DataMember]
        public SByte? display_tax_seperate_line { get; set; }
        [DataMember]
        public Int32? item_desc_display_type_id { get; set; }
        [DataMember]
        public Int64? purchase_order_no { get; set; }


    }
}
