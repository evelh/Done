
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_activity_contact")]
    [Serializable]
    [DataContract]
    public partial class v_activity_contact : v_activity
    {
        
        [DataMember]
        public Int64? activity_contact_id { get; set; }


    }
}
