using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_district")]
    [Serializable]
    [DataContract]
    public partial class d_district
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String code { get; set; }
        [DataMember]
        public String remark { get; set; }
        [DataMember]
        public Int32? parent_id { get; set; }
        [DataMember]
        public SByte status_id { get; set; }
        [DataMember]
        public String all_name { get; set; }


    }
}
