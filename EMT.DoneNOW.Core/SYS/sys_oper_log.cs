using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_oper_log")]
    [Serializable]
    [DataContract]
    public partial class sys_oper_log
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String user_cate { get; set; }
        [DataMember]
        public Int32 user_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String phone { get; set; }
        [DataMember]
        public DateTime oper_time { get; set; }
        [DataMember]
        public Int32 oper_object_cate_id { get; set; }
        [DataMember]
        public Int32 oper_object_id { get; set; }
        [DataMember]
        public Int32 oper_type_id { get; set; }
        [DataMember]
        public String oper_description { get; set; }
        [DataMember]
        public String remark { get; set; }


    }
}
