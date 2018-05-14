
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_contact_group")]
    [Serializable]
    [DataContract]
    public partial class crm_contact_group : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public SByte is_active { get; set; }
        [DataMember]
        public Int64? last_action_time { get; set; }
        [DataMember]
        public Int64? last_action_resource_id { get; set; }


    }
}