using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_account_classification")]
    [Serializable]
    [DataContract]
    public partial class d_account_classification : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? sort_order { get; set; }
        [DataMember]
        public SByte? status { get; set; }
        [DataMember]
        public String icon_path { get; set; }
        [DataMember]
        public String font_style { get; set; }


    }
}
