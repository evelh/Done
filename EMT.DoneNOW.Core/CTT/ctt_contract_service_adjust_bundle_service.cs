using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ctt_contract_service_adjust_bundle_service")]
    [Serializable]
    [DataContract]
    public partial class ctt_contract_service_adjust_bundle_service
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 contract_service_adjust_id { get; set; }
        [DataMember]
        public Int64 service_id { get; set; }
        [DataMember]
        public Int64? vendor_account_id { get; set; }
        [DataMember]
        public Decimal prorated_cost_change { get; set; }


    }
}
