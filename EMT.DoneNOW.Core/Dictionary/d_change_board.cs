
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_change_board")]
    [Serializable]
    [DataContract]
    public partial class d_change_board : SoftDeleteCore
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
        public SByte is_active { get; set; }
        [DataMember]
        public SByte include_ticket_contact { get; set; }
        [DataMember]
        public SByte include_primary_contact { get; set; }
        [DataMember]
        public SByte include_parent_account_primary_contact { get; set; }
        [DataMember]
        public SByte include_account_resource { get; set; }


    }
}