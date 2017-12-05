using System;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.DTO
{
    public class InventoryItemEditDto
    {
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64? warehouse_id { get; set; }
        [DataMember]
        public Int64 product_id { get; set; }
        [DataMember]
        public Int64? vendor_account_id { get; set; }
        [DataMember]
        public Int32 quantity { get; set; }
        [DataMember]
        public Int32 quantity_minimum { get; set; }
        [DataMember]
        public Int32 quantity_maximum { get; set; }
        [DataMember]
        public String reference_number { get; set; }
        [DataMember]
        public String bin { get; set; }
        [DataMember]
        public String location_name { get; set; }
        [DataMember]
        public String product_name { get; set; }
        [DataMember]
        public String on_order { get; set; }
        [DataMember]
        public String reserved_picked { get; set; }
        [DataMember]
        public String back_order { get; set; }
        [DataMember]
        public String picked { get; set; }

    }
}
