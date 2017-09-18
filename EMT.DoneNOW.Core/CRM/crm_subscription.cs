using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_subscription")]
    [Serializable]
    [DataContract]
    public partial class crm_subscription : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 installed_product_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32 period_type_id { get; set; }
        [DataMember]
        public DateTime effective_date { get; set; }
        [DataMember]
        public DateTime expiration_date { get; set; }
        [DataMember]
        public Decimal period_price { get; set; }
        [DataMember]
        public Decimal total_price { get; set; }
        [DataMember]
        public Int64 cost_code_id { get; set; }
        [DataMember]
        public String purchase_order_no { get; set; }
        [DataMember]
        public Decimal? period_cost { get; set; }
        [DataMember]
        public Decimal? total_cost { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }


    }
}