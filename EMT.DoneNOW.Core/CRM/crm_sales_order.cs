using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_sales_order")]
    [Serializable]
    [DataContract]
    public partial class crm_sales_order : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 opportunity_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64 owner_resource_id { get; set; }
        [DataMember]
        public DateTime begin_date { get; set; }
        [DataMember]
        public DateTime? end_date { get; set; }
        [DataMember]
        public SByte bill_to_use_account_address { get; set; }
        [DataMember]
        public Int64? bill_to_location_id { get; set; }
        [DataMember]
        public SByte ship_to_use_account_address { get; set; }
        [DataMember]
        public SByte ship_to_use_bill_to_address { get; set; }
        [DataMember]
        public Int64? ship_to_location_id { get; set; }


    }
}