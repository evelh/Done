using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_quote_item")]
    [Serializable]
    [DataContract]
    public partial class crm_quote_item : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public Int64? quote_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? period_type_id { get; set; }
        [DataMember]
        public Int64? project_id { get; set; }
        [DataMember]
        public Int32? tax_cate_id { get; set; }
        [DataMember]
        public Decimal? unit_price { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public Decimal? quantity { get; set; }
        [DataMember]
        public Decimal? unit_discount { get; set; }
        [DataMember]
        public UInt64? optional { get; set; }
        [DataMember]
        public Int32? sort_order { get; set; }
        [DataMember]
        public Decimal? discount_percent { get; set; }
        [DataMember]
        public Int32? line_discount_dallars { get; set; }
        [DataMember]
        public Int32? parent_id { get; set; }
        [DataMember]
        public Int64? object_id { get; set; }


    }
}