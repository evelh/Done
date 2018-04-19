
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_recent_search")]
    [Serializable]
    [DataContract]
    public partial class sys_recent_search
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String conditions { get; set; }
        [DataMember]
        public String url { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public Int64 create_user_id { get; set; }
        [DataMember]
        public Int64 update_time { get; set; }


    }
}
