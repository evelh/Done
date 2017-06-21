using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_token")]
    [Serializable]
    [DataContract]
    public partial class sys_token
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 user_id { get; set; }
        [DataMember]
        public DateTime expire_time { get; set; }
        [DataMember]
        public Int32? product { get; set; }
        [DataMember]
        public Int32 port { get; set; }
        [DataMember]
        public String token { get; set; }
        [DataMember]
        public String refresh_token { get; set; }


    }
}
