using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_resource_additional_time")]
    [Serializable]
    [DataContract]
    public partial class sys_resource_additional_time
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Decimal? time_vacation { get; set; }
        [DataMember]
        public Decimal? time_personal { get; set; }
        [DataMember]
        public Decimal? time_sick { get; set; }
        [DataMember]
        public Decimal? time_float { get; set; }
        [DataMember]
        public Int32? period_year { get; set; }


    }
}
