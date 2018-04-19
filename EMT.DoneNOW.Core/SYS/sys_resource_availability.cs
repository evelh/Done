using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_availability")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_availability : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Decimal? sunday { get; set; }
        [DataMember]
        public Decimal? monday { get; set; }
        [DataMember]
        public Decimal? tuesday { get; set; }
        [DataMember]
        public Decimal? wednesday { get; set; }
        [DataMember]
        public Decimal? thursday { get; set; }
        [DataMember]
        public Decimal? friday { get; set; }
        [DataMember]
        public Decimal? saturday { get; set; }
        [DataMember]
        public Decimal? total { get; set; }
        [DataMember]
        public Decimal? goal { get; set; }
        [DataMember]
        public Int32? travel_restrictions_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }


    }
}
