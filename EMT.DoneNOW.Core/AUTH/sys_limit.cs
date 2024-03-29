﻿using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_limit")]
    [Serializable]
    [DataContract]
    public partial class sys_limit
    {

        [Key]
        [DataMember]
        public Int32 id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32 type_id { get; set; }
        [DataMember]
        public String module { get; set; }
        [DataMember]
        public Int32? cate_id { get; set; }
        [DataMember]
        public Int32? module_id { get; set; }


    }
}
