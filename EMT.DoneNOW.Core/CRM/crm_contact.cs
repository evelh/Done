using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("crm_contact")]
    [Serializable]
    [DataContract]
    public partial class crm_contact : SoftDeleteCore
    {
        [Key]
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public String external_id { get; set; }
        [DataMember]
        public String cust_link { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public Int64? location_id { get; set; }
        [DataMember]
        public String phone { get; set; }
        [DataMember]
        public String fax { get; set; }
        [DataMember]
        public String alternate_phone1 { get; set; }
        [DataMember]
        public String alternate_phone2 { get; set; }
        [DataMember]
        public String mobile_phone { get; set; }
        [DataMember]
        public Int32? suffix_id { get; set; }
        [DataMember]
        public String title { get; set; }
        [DataMember]
        public String extra_notes { get; set; }
        [DataMember]
        public String room_number { get; set; }
        [DataMember]
        public String first_name { get; set; }
        [DataMember]
        public String last_name { get; set; }
        [DataMember]
        public String name { get; set; }
        [DataMember]
        public String email { get; set; }
        [DataMember]
        public SByte wants_email { get; set; }
        [DataMember]
        public Int32? email_freq { get; set; }
        [DataMember]
        public Int32 is_active { get; set; }
        [DataMember]
        public SByte is_web_user { get; set; }
        [DataMember]
        public Int32? ca_security_group_id { get; set; }
        [DataMember]
        public Int64? last_activity_time { get; set; }
        [DataMember]
        public String date_format { get; set; }
        [DataMember]
        public String time_format { get; set; }
        [DataMember]
        public String number_format { get; set; }
        [DataMember]
        public SByte is_primary_contact { get; set; }
        [DataMember]
        public Int64? bulk_email_optout_time { get; set; }
        [DataMember]
        public Int64? survey_optout_time { get; set; }
        [DataMember]
        public String facebook_url { get; set; }
        [DataMember]
        public String twitter_url { get; set; }
        [DataMember]
        public String linkedin_url { get; set; }
        [DataMember]
        public String qq { get; set; }
        [DataMember]
        public String wechat { get; set; }
        [DataMember]
        public String weibo_url { get; set; }
        [DataMember]
        public String narrative_full_name { get; set; }
        [DataMember]
        public String sorting_full_name { get; set; }
        [DataMember]
        public Int32? name_salutation_id { get; set; }
        [DataMember]
        public Int32? name_suffix_id { get; set; }
        [DataMember]
        public String phone_basic { get; set; }
        [DataMember]
        public String alternate_phone1_basic { get; set; }
        [DataMember]
        public String alternate_phone2_basic { get; set; }
        [DataMember]
        public String cell_phone_basic { get; set; }


    }
}
