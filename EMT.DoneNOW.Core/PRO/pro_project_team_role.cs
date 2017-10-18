
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("pro_project_team_role")]
    [Serializable]
    [DataContract]
    public partial class pro_project_team_role : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 project_team_id { get; set; }
        [DataMember]
        public Int64? role_id { get; set; }


    }
}
