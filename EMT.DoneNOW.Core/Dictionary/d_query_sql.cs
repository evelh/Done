using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_query_sql")]
    [Serializable]
    [DataContract]
    public partial class d_query_sql
    {

        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 query_type_id { get; set; }
        [DataMember]
        public String sel_tables { get; set; }
        [DataMember]
        public String sel_sql { get; set; }


    }
}
