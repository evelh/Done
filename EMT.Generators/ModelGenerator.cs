
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
namespace EMT.DoneNOW.Core
{
	[Table("crm_contact")]
    [Serializable]
    public partial class crm_contact
    {

		[Key]
	    [Column("id")]
        public Int64 id{ get;set;}
	    [Column("external_id")]
        public String external_id{ get;set;}
	    [Column("cust_link")]
        public String cust_link{ get;set;}
	    [Column("client_id")]
        public Int64 client_id{ get;set;}
	    [Column("phone")]
        public String phone{ get;set;}
	    [Column("phone_ext")]
        public String phone_ext{ get;set;}
	    [Column("fax")]
        public String fax{ get;set;}
	    [Column("alternate_phone")]
        public String alternate_phone{ get;set;}
	    [Column("alternate_phone1")]
        public String alternate_phone1{ get;set;}
	    [Column("cell_phone")]
        public String cell_phone{ get;set;}
	    [Column("title")]
        public String title{ get;set;}
	    [Column("extra_notes")]
        public String extra_notes{ get;set;}
	    [Column("room_number")]
        public String room_number{ get;set;}
	    [Column("first_name")]
        public String first_name{ get;set;}
	    [Column("middle_initial")]
        public String middle_initial{ get;set;}
	    [Column("last_name")]
        public String last_name{ get;set;}
	    [Column("user_name")]
        public String user_name{ get;set;}
	    [Column("ca_password")]
        public String ca_password{ get;set;}
	    [Column("email_address")]
        public String email_address{ get;set;}
	    [Column("wants_email")]
        public SByte wants_email{ get;set;}
	    [Column("email_freq")]
        public Int32? email_freq{ get;set;}
	    [Column("active")]
        public Int32 active{ get;set;}
	    [Column("isWebUser")]
        public SByte isWebUser{ get;set;}
	    [Column("ca_security_group_id")]
        public Int32? ca_security_group_id{ get;set;}
	    [Column("object_id")]
        public Int64? object_id{ get;set;}
	    [Column("address")]
        public String address{ get;set;}
	    [Column("address1")]
        public String address1{ get;set;}
	    [Column("country")]
        public String country{ get;set;}
	    [Column("city")]
        public String city{ get;set;}
	    [Column("state")]
        public String state{ get;set;}
	    [Column("zip")]
        public String zip{ get;set;}
	    [Column("last_activity")]
        public Int64? last_activity{ get;set;}
	    [Column("date_stamp")]
        public Int64 date_stamp{ get;set;}
	    [Column("date_format")]
        public String date_format{ get;set;}
	    [Column("time_format")]
        public String time_format{ get;set;}
	    [Column("number_format")]
        public String number_format{ get;set;}
	    [Column("is_primary_outsource_contact")]
        public SByte is_primary_outsource_contact{ get;set;}
	    [Column("bulk_email_optout_time")]
        public DateTime? bulk_email_optout_time{ get;set;}
	    [Column("survey_optout_time")]
        public DateTime? survey_optout_time{ get;set;}
	    [Column("facebook_url")]
        public String facebook_url{ get;set;}
	    [Column("twitter_url")]
        public String twitter_url{ get;set;}
	    [Column("linkedin_url")]
        public String linkedin_url{ get;set;}
	    [Column("narrative_full_name")]
        public String narrative_full_name{ get;set;}
	    [Column("sorting_full_name")]
        public String sorting_full_name{ get;set;}
	    [Column("name_salutation_id")]
        public Int32? name_salutation_id{ get;set;}
	    [Column("name_suffix_id")]
        public Int32? name_suffix_id{ get;set;}
	    [Column("country_id")]
        public Int32? country_id{ get;set;}
	    [Column("additional_address_information")]
        public String additional_address_information{ get;set;}
	    [Column("phone_basic")]
        public String phone_basic{ get;set;}
	    [Column("alternate_phone_basic")]
        public String alternate_phone_basic{ get;set;}
	    [Column("alternate_phone1_basic")]
        public String alternate_phone1_basic{ get;set;}
	    [Column("cell_phone_basic")]
        public String cell_phone_basic{ get;set;}
	    [Column("create_time")]
        public Int64? create_time{ get;set;}
	    [Column("create_by_id")]
        public Int64? create_by_id{ get;set;}
	    [Column("update_time")]
        public Int64? update_time{ get;set;}
	    [Column("update_by_id")]
        public Int64? update_by_id{ get;set;}
	    [Column("delete_time")]
        public Int64? delete_time{ get;set;}
	    [Column("delete_by_id")]
        public Int64? delete_by_id{ get;set;}

       
    }
}
/*

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using EMT.DoneNOW.Core;
namespace EMT.DoneNOW.DAL
{
    public class crm_contact_dal : BaseDAL<crm_contact>
    {
    }
}

*/
