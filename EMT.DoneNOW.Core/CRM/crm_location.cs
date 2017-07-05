using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_location")]
    [Serializable]
    [DataContract]
    public partial class crm_location : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public String address { get; set; }
        [DataMember]
        public Int32? town_id { get; set; }
        [DataMember]
        public Int32? district_id { get; set; }
        [DataMember]
        public Int32 city_id { get; set; }
        [DataMember]
        public Int32 provice_id { get; set; }
        [DataMember]
        public String postal_code { get; set; }
        [DataMember]
        public Int32? country_id { get; set; }
        [DataMember]
        public String additional_address { get; set; }
        [DataMember]
        public String location_label { get; set; }
        [DataMember]
        public SByte is_default { get; set; }


    }
}
