using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_query_type")]
    [Serializable]
    [DataContract]
    public partial class d_query_type
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String user_col { get; set; }
        [DataMember]
        public String department_col { get; set; }
        [DataMember]
        public String orderby_col { get; set; }


    }
}
