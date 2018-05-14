
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_contact_group_contact")]
    [Serializable]
    [DataContract]
    public partial class crm_contact_group_contact : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 contact_group_id { get; set; }
        [DataMember]
        public Int64 contact_id { get; set; }


    }
}