using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("com_import_log")]
    [Serializable]
    [DataContract]
    public partial class com_import_log
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public Int64 import_user_id { get; set; }
        [DataMember]
        public Int64 import_time { get; set; }
        [DataMember]
        public Int32 success_num { get; set; }
        [DataMember]
        public Int32 fail_num { get; set; }
        [DataMember]
        public String file_name { get; set; }


    }
}
