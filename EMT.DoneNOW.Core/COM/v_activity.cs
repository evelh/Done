using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
    [Table("v_activity")]
    [Serializable]
    [DataContract]
    public partial class v_activity
    {

        [DataMember]
        public Int64 cate { get; set; }
        [DataMember]
        public Int64 lv { get; set; }
        [DataMember]
        public String act_cate { get; set; }
        [DataMember]
        public Int64 account_id { get; set; }
        [DataMember]
        public String pname { get; set; }
        [DataMember]
        public String act_name { get; set; }
        [DataMember]
        public String act_desc { get; set; }
        [DataMember]
        public String act_date { get; set; }
        [DataMember]
        public Int64 id { get; set; }
        [DataMember]
        public Int64 id_1lv { get; set; }
        [DataMember]
        public Int64 act_date_1lv { get; set; }
        [DataMember]
        public String id_2lv { get; set; }
        [DataMember]
        public String act_date_2lv { get; set; }
        [DataMember]
        public Int64? resource_id { get; set; }
        [DataMember]
        public String resource_name { get; set; }
        [DataMember]
        public String resource_email { get; set; }
        [DataMember]
        public String resource_avatar { get; set; }
        [DataMember]
        public Int64? update_user_id { get; set; }
        [DataMember]
        public String update_user_name { get; set; }
        [DataMember]
        public String update_user_email { get; set; }
        [DataMember]
        public Int64? contact_id { get; set; }
        [DataMember]
        public String contact_name { get; set; }
        [DataMember]
        public String contact_email { get; set; }
        [DataMember]
        public Int32? att_type_id { get; set; }
        [DataMember]
        public String att_href { get; set; }
        [DataMember]
        public String att_filename { get; set; }
        [DataMember]
        public Int64? update_time_int { get; set; }


    }
    
}
