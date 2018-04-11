
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("sdk_dispatcher_view")]
    [Serializable]
    [DataContract]
    public partial class sdk_dispatcher_view : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32 mode_id { get; set; }
        [DataMember]
        public String workgroup_ids { get; set; }
        [DataMember]
        public String resource_ids { get; set; }
        [DataMember]
        public SByte show_unassigned { get; set; }
        [DataMember]
        public SByte show_canceled { get; set; }


    }
}