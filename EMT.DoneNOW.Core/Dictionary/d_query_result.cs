using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_query_result")]
    [Serializable]
    [DataContract]
    public partial class d_query_result
    {

        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 query_type_id { get; set; }
        [DataMember]
        public Decimal col_order { get; set; }
        [DataMember]
        public String col_name { get; set; }
        [DataMember]
        public String col_comment { get; set; }
        [DataMember]
        public SByte col_length { get; set; }
        [DataMember]
        public String sel_sql { get; set; }
        [DataMember]
        public Int32 display_type_id { get; set; }
        [DataMember]
        public SByte is_visible { get; set; }


    }
}
