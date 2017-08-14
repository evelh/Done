using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_error_log")]
    [Serializable]
    [DataContract]
    public partial class sys_error_log
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public Int64? user_id { get; set; }
        [DataMember]
        public String request_url { get; set; }
        [DataMember]
        public String error_message { get; set; }
        [DataMember]
        public String stack_trace { get; set; }
        [DataMember]
        public DateTime? add_time { get; set; }


    }
}
