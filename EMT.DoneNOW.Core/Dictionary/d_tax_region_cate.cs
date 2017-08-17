
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_tax_region_cate")]
    [Serializable]
    [DataContract]
    public partial class d_tax_region_cate
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int32 tax_region_id { get; set; }
        [DataMember]
        public Int32 tax_cate_id { get; set; }
        [DataMember]
        public Decimal total_effective_tax_rate { get; set; }


    }
}
