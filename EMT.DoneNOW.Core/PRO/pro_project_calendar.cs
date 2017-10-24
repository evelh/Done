
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("pro_project_calendar")]
    [Serializable]
    [DataContract]
    public partial class pro_project_calendar : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 project_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64 start_time { get; set; }
        [DataMember]
        public Int64 end_time { get; set; }
        [DataMember]
        public Int32? publish_type_id { get; set; }


    }
}