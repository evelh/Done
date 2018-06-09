
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("d_change_board_person")]
    [Serializable]
    [DataContract]
    public partial class d_change_board_person : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 change_board_id { get; set; }
        [DataMember]
        public Int64 resource_id { get; set; }


    }
}