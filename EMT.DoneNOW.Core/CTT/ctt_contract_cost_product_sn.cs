
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_cost_product_sn")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_cost_product_sn : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 contract_cost_product_id { get; set; }
        [DataMember]
        public String sn { get; set; }


    }
}