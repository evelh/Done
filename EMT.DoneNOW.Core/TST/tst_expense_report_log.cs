
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_expense_report_log")]
    [Serializable]
    [DataContract]
    public partial class tst_expense_report_log
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64? expense_report_id { get; set; }
        [DataMember]
        public Int64 oper_user_id { get; set; }
        [DataMember]
        public Int32 oper_type_id { get; set; }
        [DataMember]
        public Int64 oper_time { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String rejection_expense_id_list { get; set; }


    }
}