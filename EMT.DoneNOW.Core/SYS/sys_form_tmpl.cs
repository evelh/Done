using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int32 form_type_id { get; set; }
        [DataMember]
        public String tmpl_name { get; set; }
        [DataMember]
        public String speed_code { get; set; }
        [DataMember]
        public SByte tmpl_is_active { get; set; }
        [DataMember]
        public String remark { get; set; }
        [DataMember]
        public Int32 range_type_id { get; set; }
        [DataMember]
        public Int32? range_department_id { get; set; }


    }
}
