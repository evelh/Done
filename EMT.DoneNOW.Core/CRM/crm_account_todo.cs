using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_account_todo")]
    [Serializable]
    [DataContract]
    public partial class crm_account_todo : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64 user_id { get; set; }
        [DataMember]
        public Int64? proposal_id { get; set; }
        [DataMember]
        public Int32? classification_id { get; set; }
        [DataMember]
        public Int32 action_type_id { get; set; }
        [DataMember]
        public Int32? status { get; set; }
        [DataMember]
        public Int64 start_date { get; set; }
        [DataMember]
        public Int64? end_date { get; set; }
        [DataMember]
        public Int64? date_completed { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String detail { get; set; }
        [DataMember]
        public Int32 priority { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64? parent_crm_note_id { get; set; }
        [DataMember]
        public Int64? parent_attachment_id { get; set; }
        [DataMember]
        public Int64? sales_order_id { get; set; }


    }
}
