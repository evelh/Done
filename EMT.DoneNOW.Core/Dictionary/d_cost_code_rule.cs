
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_cost_code_rule")]
    [Serializable]
    [DataContract]
    public partial class d_cost_code_rule : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 cost_code_id { get; set; }
        [DataMember]
        public Int64? department_id { get; set; }
        [DataMember]
        public Int32? overdraft_policy_id { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Decimal? max { get; set; }


    }
}