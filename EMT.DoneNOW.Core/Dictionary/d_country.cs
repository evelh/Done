using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_country")]
    [Serializable]
    [DataContract]
    public partial class d_country
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String country_code { get; set; }
        [DataMember]
        public String country_name_iso_standard { get; set; }
        [DataMember]
        public String country_name_display { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public SByte is_default { get; set; }
        [DataMember]
        public SByte is_undefined_country { get; set; }
        [DataMember]
        public Int32 address_format_id { get; set; }
        [DataMember]
        public Int32? invoice_template_id { get; set; }


    }
}