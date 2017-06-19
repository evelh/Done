using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_login_log")]
    [Serializable]
    [DataContract]
    public partial class sys_login_log
    {

        [Key]
        [DataMember]
        public String id { get; set; }
        [DataMember]
        public Int32 user_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String login_user_name { get; set; }
        [DataMember]
        public DateTime login_time { get; set; }
        [DataMember]
        public String ip { get; set; }
        [DataMember]
        public String agent { get; set; }
        [DataMember]
        public String token { get; set; }
        [DataMember]
        public String refresh_token { get; set; }


    }
}
