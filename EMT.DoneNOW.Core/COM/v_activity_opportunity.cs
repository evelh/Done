using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_activity_opportunity")]
    [Serializable]
    [DataContract]
    public partial class v_activity_opportunity : v_activity
    {
        
        [DataMember]
        public Int64? opportunity_id { get; set; }


    }
}
