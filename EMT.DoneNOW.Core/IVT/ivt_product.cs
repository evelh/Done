using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_product")]
    [Serializable]
    [DataContract]
    public partial class ivt_product : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String sku { get; set; }
        [DataMember]
        public String url { get; set; }
        [DataMember]
        public Int32? installed_product_cate_id { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public Decimal? unit_cost { get; set; }
        [DataMember]
        public Decimal? unit_price { get; set; }
        [DataMember]
        public Decimal? msrp { get; set; }
        [DataMember]
        public String manu_name { get; set; }
        [DataMember]
        public String manu_product_no { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public Int32? period_type_id { get; set; }
        [DataMember]
        public SByte is_serialized { get; set; }
        [DataMember]
        public Int64 cost_code_id { get; set; }
        [DataMember]
        public String internal_id { get; set; }
        [DataMember]
        public SByte does_not_require_procurement { get; set; }
        [DataMember]
        public String link { get; set; }
        [DataMember]
        public String vendor_product_no { get; set; }
        [DataMember]
        public Int64? vendor_id { get; set; }
        [DataMember]
        public Int32? udf_group_id { get; set; }
        [DataMember]
        public SByte is_system { get; set; }


    }
}