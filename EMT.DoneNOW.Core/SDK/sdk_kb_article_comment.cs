using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_kb_article_comment")]
    [Serializable]
    [DataContract]
    public partial class sdk_kb_article_comment : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 kb_article_id { get; set; }
        [DataMember]
        public String comment { get; set; }
        [DataMember]
        public String creator_name { get; set; }


    }
}