using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_subscription_period")]
    [Serializable]
    [DataContract]
    public partial class crm_subscription_period
    {

        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 subscription_id { get; set; }
        [DataMember]
        public DateTime period_date { get; set; }
        [DataMember]
        public Decimal period_price { get; set; }
        [DataMember]
        public DateTime? approve_and_post_date { get; set; }
        [DataMember]
        public Int64? approve_and_post_user_id { get; set; }


    }
}