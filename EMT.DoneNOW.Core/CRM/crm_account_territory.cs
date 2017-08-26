using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_account_territory")]
    [Serializable]
    [DataContract]
    public partial class crm_account_territory
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int32 territory_id { get; set; }


    }
}