
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_service_call")]
    [Serializable]
    [DataContract]
    public partial class sdk_service_call : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int64 start_time { get; set; }
        [DataMember]
        public Int64 end_time { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int32 status_id { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public SByte? recurs_in_outlook { get; set; }
        [DataMember]
        public String outlook_entry_id { get; set; }
        [DataMember]
        public Int64? canceled_time { get; set; }
        [DataMember]
        public Int64? canceled_user_id { get; set; }


    }
}