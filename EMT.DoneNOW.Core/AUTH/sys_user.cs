using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_user")]
    [Serializable]
    [DataContract]
    public partial class sys_user
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public String email { get; set; }
        [DataMember]
        public String mobile_phone { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String password { get; set; }
        [DataMember]
        public String salt { get; set; }
        [DataMember]
        public Int64? organization_id { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }


    }
}
