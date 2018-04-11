using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_appointment")]
    [Serializable]
    [DataContract]
    public partial class sdk_appointment : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int64 start_time { get; set; }
        [DataMember]
        public Int64 end_time { get; set; }
        [DataMember]
        public SByte? recurs_in_outlook { get; set; }
        [DataMember]
        public String outlook_entry_id { get; set; }
        [DataMember]
        public Int32? schedule_item_id { get; set; }


    }
}