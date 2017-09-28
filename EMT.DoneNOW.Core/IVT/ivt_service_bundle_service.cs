using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("ivt_service_bundle_service")]
    [Serializable]
    [DataContract]
    public partial class ivt_service_bundle_service
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 service_bundle_id { get; set; }
        [DataMember]
        public Int64 service_id { get; set; }


    }
}