using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_work_entry_report_log")]
    [Serializable]
    [DataContract]
    public partial class tst_work_entry_report_log
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64? work_entry_report_id { get; set; }
        [DataMember]
        public Int64 oper_user_id { get; set; }
        [DataMember]
        public Int32 oper_type_id { get; set; }
        [DataMember]
        public Int64 oper_time { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32 tier { get; set; }


    }
}
