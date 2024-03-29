﻿using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sys_query_type_user")]
    [Serializable]
    [DataContract]
    public partial class sys_query_type_user
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 query_type_id { get; set; }
        [DataMember]
        public String query_para_ids { get; set; }
        [DataMember]
        public String query_result_ids { get; set; }
        [DataMember]
        public Int64? user_id { get; set; }
        [DataMember]
        public Int64? query_para_group_id { get; set; }


    }
}
