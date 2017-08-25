
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_time_zone")]
    [Serializable]
    [DataContract]
    public partial class d_time_zone
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int32 bias { get; set; }
        [DataMember]
        public String standard_name { get; set; }
        [DataMember]
        public Int32 standard_month { get; set; }
        [DataMember]
        public Int32 standard_day { get; set; }
        [DataMember]
        public Int32 standard_day_of_week { get; set; }
        [DataMember]
        public Int32 standard_hour { get; set; }
        [DataMember]
        public Int32 standard_bias { get; set; }
        [DataMember]
        public String daylight_name { get; set; }
        [DataMember]
        public Int32 daylight_month { get; set; }
        [DataMember]
        public Int32 daylight_day { get; set; }
        [DataMember]
        public Int32 daylight_day_of_week { get; set; }
        [DataMember]
        public Int32 daylight_hour { get; set; }
        [DataMember]
        public Int32 daylight_bias { get; set; }
        [DataMember]
        public String generic_name { get; set; }
        [DataMember]
        public String generic_abbreviation { get; set; }
        [DataMember]
        public String standard_abbreviation { get; set; }
        [DataMember]
        public String daylight_abbreviation { get; set; }
        [DataMember]
        public String windows_time_zone_code { get; set; }


    }
}