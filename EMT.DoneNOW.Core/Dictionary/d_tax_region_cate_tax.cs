
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_tax_region_cate_tax")]
    [Serializable]
    [DataContract]
    public partial class d_tax_region_cate_tax : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 tax_region_cate_id { get; set; }
        [DataMember]
        public String tax_name { get; set; }
        [DataMember]
        public Decimal tax_rate { get; set; }
        [DataMember]
        public UInt64 is_compounded { get; set; }
        [DataMember]
        public Int32 sort_order { get; set; }


    }
}