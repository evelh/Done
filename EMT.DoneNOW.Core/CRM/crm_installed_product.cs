
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_installed_product")]
    [Serializable]
    [DataContract]
    public partial class crm_installed_product : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 product_id { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public DateTime? start_date { get; set; }
        [DataMember]
        public DateTime? through_date { get; set; }
        [DataMember]
        public Decimal? number_of_users { get; set; }
        [DataMember]
        public Decimal? hourly_cost { get; set; }
        [DataMember]
        public Decimal? daily_cost { get; set; }
        [DataMember]
        public Decimal? monthly_cost { get; set; }
        [DataMember]
        public Decimal? setup_fee { get; set; }
        [DataMember]
        public Decimal? peruse_cost { get; set; }
        [DataMember]
        public String serial_number { get; set; }
        [DataMember]
        public String reference_number { get; set; }
        [DataMember]
        public String accounting_link { get; set; }
        [DataMember]
        public String reference_name { get; set; }
        [DataMember]
        public String remark { get; set; }
        [DataMember]
        public Int64? quote_item_id { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64? service_id { get; set; }
        [DataMember]
        public Int64? service_bundle_id { get; set; }
        [DataMember]
        public Int32? udf_group_id { get; set; }
        [DataMember]
        public String location { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64? vendor_account_id { get; set; }
        [DataMember]
        public SByte? is_swapped_out { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public Int64? installed_resource_id { get; set; }
        [DataMember]
        public Int64? installed_contact_id { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }
        [DataMember]
        public Decimal? implementation_cost { get; set; }
        [DataMember]
        public Decimal? followup_cost { get; set; }
        [DataMember]
        public Int64? entrytimestamp { get; set; }
        [DataMember]
        public Int64? cost_product_id { get; set; }
        [DataMember]
        public Int64? inventory_transfer_id { get; set; }
        [DataMember]
        public Int64? extension_adapter_disovery_data_id { get; set; }
        [DataMember]
        public Int64? contract_cost_id { get; set; }
        [DataMember]
        public SByte reviewed_for_contract { get; set; }

        
    }
}