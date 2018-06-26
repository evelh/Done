using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("com_import_log_detail")]
    [Serializable]
    [DataContract]
    public partial class com_import_log_detail
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 log_id { get; set; }
        [DataMember]
        public Int32 rownum { get; set; }
        [DataMember]
        public Int64 is_sucess { get; set; }
        [DataMember]
        public String fail_desc { get; set; }


    }
}
