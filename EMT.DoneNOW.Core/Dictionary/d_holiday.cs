
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_holiday")]
    [Serializable]
    [DataContract]
    public partial class d_holiday
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int32 holiday_set_id { get; set; }
        [DataMember]
        public Int32 hd_type { get; set; }
        [DataMember]
        public DateTime hd { get; set; }
        [DataMember]
        public String description { get; set; }


    }
}