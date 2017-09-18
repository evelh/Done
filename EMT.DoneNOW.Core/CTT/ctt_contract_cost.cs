using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_cost")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_cost : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_id { get; set; }
        [DataMember]
        public Int64? product_id { get; set; }
        [DataMember]
        public Int64 cost_code_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public DateTime date_purchased { get; set; }
        [DataMember]
        public SByte is_billable { get; set; }
        [DataMember]
        public Int64? service_id { get; set; }
        [DataMember]
        public SByte create_ci { get; set; }
        [DataMember]
        public Int32? cost_type_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public String internal_po_no { get; set; }
        [DataMember]
        public String invoice_no { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Decimal? quantity { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public Decimal? unit_price { get; set; }
        [DataMember]
        public SByte? bill_status { get; set; }
        [DataMember]
        public Int64? status_last_modified_user_id { get; set; }
        [DataMember]
        public Int64? status_last_modified_time { get; set; }
        [DataMember]
        public Int64? contract_block_id { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public Int64? ticket_id { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public Int64? quote_item_id { get; set; }
        [DataMember]
        public Decimal? extended_price { get; set; }
        [DataMember]
        public Int32? creatorobjectid { get; set; }
        [DataMember]
        public DateTime? dateadded { get; set; }
        [DataMember]
        public Decimal? estimatecost { get; set; }
        [DataMember]
        public Int32? paymenttype { get; set; }
        [DataMember]
        public Int32? parentobjectid { get; set; }
        [DataMember]
        public Decimal? ourcost { get; set; }
        [DataMember]
        public Int32? changeorder { get; set; }
        [DataMember]
        public String extacctitemid { get; set; }
        [DataMember]
        public Int32? inventory_transfer_id { get; set; }
        [DataMember]
        public DateTime? web_service_date { get; set; }
        [DataMember]
        public Decimal? change_order_hours { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }
        [DataMember]
        public Int32 sub_cate_id { get; set; }


    }
}