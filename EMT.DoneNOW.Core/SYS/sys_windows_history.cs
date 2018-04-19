
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_windows_history")]
    [Serializable]
    [DataContract]
    public partial class sys_windows_history
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public String url { get; set; }
        [DataMember]
        public Int64 create_time { get; set; }
        [DataMember]
        public Int64 create_user_id { get; set; }


    }
}