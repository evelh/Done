
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_organization_location")]
    [Serializable]
    [DataContract]
    public partial class sys_organization_location : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32 country_id { get; set; }
        [DataMember]
        public Int32? province_id { get; set; }
        [DataMember]
        public Int32? city_id { get; set; }
        [DataMember]
        public Int32? district_id { get; set; }
        [DataMember]
        public Int32? town_id { get; set; }
        [DataMember]
        public String address { get; set; }
        [DataMember]
        public String additional_address { get; set; }
        [DataMember]
        public String postal_code { get; set; }
        [DataMember]
        public Int32? time_zone_id { get; set; }
        [DataMember]
        public Int32 holiday_set_id { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public String date_format { get; set; }
        [DataMember]
        public Int32? timezoneobjectid { get; set; }
        [DataMember]
        public Int32? parent_id { get; set; }
        [DataMember]
        public String time_format { get; set; }
        [DataMember]
        public Int32? localeid { get; set; }
        [DataMember]
        public String number_format { get; set; }
        [DataMember]
        public Int32? holiday_hours_type_id { get; set; }


    }
}
/*



*/
