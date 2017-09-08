using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_inventory_transfer")]
    [Serializable]
    [DataContract]
    public partial class ivt_inventory_transfer : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 product_id { get; set; }
        [DataMember]
        public Int64 transfer_from_warehouse_id { get; set; }
        [DataMember]
        public Int64? transfer_to_warehouse_id { get; set; }
        [DataMember]
        public Int64? transfer_to_project_id { get; set; }
        [DataMember]
        public Int64? transfer_to_ticket_id { get; set; }
        [DataMember]
        public Int32 transfer_quantity { get; set; }
        [DataMember]
        public String notes { get; set; }
        [DataMember]
        public Int64? transfer_to_account_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int64? transfer_to_contract_id { get; set; }
        [DataMember]
        public String inventory_transfer_reference_number { get; set; }
        [DataMember]
        public Int64? transfer_from_product_id { get; set; }
        [DataMember]
        public Int64? cost_product_id { get; set; }
        [DataMember]
        public Int64? previous_inventory_transfer_id { get; set; }


    }
}