using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_widget_guage")]
    [Serializable]
    [DataContract]
    public partial class sys_widget_guage : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 widget_id { get; set; }
        [DataMember]
        public SByte sort_order { get; set; }
        [DataMember]
        public Int64? report_on_id { get; set; }
        [DataMember]
        public Int32? aggregation_type_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32? break_based_on { get; set; }
        [DataMember]
        public SByte? segments { get; set; }
        [DataMember]
        public String break_points { get; set; }
        [DataMember]
        public String filter_json { get; set; }


    }
}
