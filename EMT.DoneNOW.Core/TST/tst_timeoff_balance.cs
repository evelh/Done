using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("tst_timeoff_balance")]
    [Serializable]
    [DataContract]
    public partial class tst_timeoff_balance
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 object_id { get; set; }
        [DataMember]
        public Int32 object_type_id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }
        [DataMember]
        public Int64 task_id { get; set; }
        [DataMember]
        public Decimal balance { get; set; }


    }
}
