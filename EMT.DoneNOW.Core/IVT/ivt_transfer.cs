using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_transfer")]
    [Serializable]
    [DataContract]
    public partial class ivt_transfer : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 product_id { get; set; }
        [DataMember]
        public Int64 from_warehouse_id { get; set; }
        [DataMember]
        public Int64? to_warehouse_id { get; set; }
        [DataMember]
        public Int64? to_project_id { get; set; }
        [DataMember]
        public Int64? to_task_id { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public String notes { get; set; }
        [DataMember]
        public Int64? to_account_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int64? to_contract_id { get; set; }
        [DataMember]
        public String reference_number { get; set; }
        [DataMember]
        public Int64? from_product_id { get; set; }
        [DataMember]
        public Int64? cost_product_id { get; set; }
        [DataMember]
        public Int64? previous_inventory_transfer_id { get; set; }


    }
}