
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("com_activity")]
    [Serializable]
    [DataContract]
    public partial class com_activity : SoftDeleteCore
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 oid { get; set; }
        [DataMember]
        public Int32 cate_id { get; set; }
        [DataMember]
        public Int64? account_id { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public Int64 object_id { get; set; }
        [DataMember]
        public Int32 object_type_id { get; set; }
        [DataMember]
        public Int32 action_type_id { get; set; }
        [DataMember]
        public Int64 start_date { get; set; }
        [DataMember]
        public Int64 end_date { get; set; }
        [DataMember]
        public String description { get; set; }
        [DataMember]
        public Int64? contract_id { get; set; }
        [DataMember]
        public Int64? opportunity_id { get; set; }
        [DataMember]
        public Int64? ticket_id { get; set; }
        [DataMember]
        public Int32? status_id { get; set; }
        [DataMember]
        public Int64? complete_time { get; set; }
        [DataMember]
        public String complete_description { get; set; }
        [DataMember]
        public Int64? parent_id { get; set; }
        [DataMember]
        public Int64? proposal_id { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public Int32? priority { get; set; }
        [DataMember]
        public Int64? parent_attachment_id { get; set; }
        [DataMember]
        public Int64? sales_order_id { get; set; }
        [DataMember]
        public Int64? task_id { get; set; }


    }
}