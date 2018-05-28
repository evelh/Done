
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_form_tmpl_service_call")]
    [Serializable]
    [DataContract]
    public partial class sys_form_tmpl_service_call : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 form_tmpl_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public String start_time { get; set; }
        [DataMember]
        public String end_time { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }


    }
}