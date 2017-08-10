using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_system_setting")]
    [Serializable]
    [DataContract]
    public partial class sys_system_setting
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int32 module_id { get; set; }
        [DataMember]
        public Decimal? sort_order { get; set; }
        [DataMember]
        public String setting_name { get; set; }
        [DataMember]
        public String setting_value { get; set; }
        [DataMember]
        public Int32? col_length { get; set; }
        [DataMember]
        public Int32 data_type_id { get; set; }
        [DataMember]
        public String ref_sql { get; set; }
        [DataMember]
        public String ref_url { get; set; }
        [DataMember]
        public SByte is_visible { get; set; }
        [DataMember]
        public String remark { get; set; }


    }
}
