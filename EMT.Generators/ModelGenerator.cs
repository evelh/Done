
using System;
using System.Collections.Generic;
using System.Text;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.Serialization;

namespace EMT.DoneNOW.Core
{
	[Table("sys_resource")]
    [Serializable]
	[DataContract]
    public partial class sys_resource : SoftDeleteCore 
    {

	    [DataMember]
        public Int64 id{ get;set;}
	    [DataMember]
        public String user_name{ get;set;}
	    [DataMember]
        public SByte active{ get;set;}
	    [DataMember]
        public String email{ get;set;}
	    [DataMember]
        public Int32? default_service_rate{ get;set;}
	    [DataMember]
        public String office_phone{ get;set;}
	    [DataMember]
        public String office_ext{ get;set;}
	    [DataMember]
        public String home_phone{ get;set;}
	    [DataMember]
        public String mobile_phone{ get;set;}
	    [DataMember]
        public String address1{ get;set;}
	    [DataMember]
        public String address2{ get;set;}
	    [DataMember]
        public String city{ get;set;}
	    [DataMember]
        public String state_province{ get;set;}
	    [DataMember]
        public String postal_code{ get;set;}
	    [DataMember]
        public String title{ get;set;}
	    [DataMember]
        public String sex{ get;set;}
	    [DataMember]
        public String first_name{ get;set;}
	    [DataMember]
        public String last_name{ get;set;}
	    [DataMember]
        public String middle_name{ get;set;}
	    [DataMember]
        public Int32? parent_id{ get;set;}
	    [DataMember]
        public Int64? hire_date{ get;set;}
	    [DataMember]
        public Int32? location_id{ get;set;}
	    [DataMember]
        public Int32? security_role{ get;set;}
	    [DataMember]
        public Int32? status{ get;set;}
	    [DataMember]
        public Decimal? time_vacation{ get;set;}
	    [DataMember]
        public Decimal? time_personal{ get;set;}
	    [DataMember]
        public Decimal? time_sick{ get;set;}
	    [DataMember]
        public SByte? oTexempt{ get;set;}
	    [DataMember]
        public String initials{ get;set;}
	    [DataMember]
        public SByte? system_account{ get;set;}
	    [DataMember]
        public String external_id{ get;set;}
	    [DataMember]
        public Decimal? time_float{ get;set;}
	    [DataMember]
        public String travel_restrictions{ get;set;}
	    [DataMember]
        public SByte? can_edit_skills{ get;set;}
	    [DataMember]
        public String resource_type{ get;set;}
	    [DataMember]
        public Int64? outlook_synchronization_date{ get;set;}
	    [DataMember]
        public String email2{ get;set;}
	    [DataMember]
        public String email3{ get;set;}
	    [DataMember]
        public String email_type_code{ get;set;}
	    [DataMember]
        public String email_type_code2{ get;set;}
	    [DataMember]
        public String email_type_code3{ get;set;}
	    [DataMember]
        public String date_format{ get;set;}
	    [DataMember]
        public String time_format{ get;set;}
	    [DataMember]
        public String number_format{ get;set;}
	    [DataMember]
        public SByte is_LiveMobile_active{ get;set;}
	    [DataMember]
        public Int32 failed_login_count{ get;set;}
	    [DataMember]
        public SByte is_locked{ get;set;}
	    [DataMember]
        public Int64? first_login_time{ get;set;}
	    [DataMember]
        public String accounting_reference_id{ get;set;}
	    [DataMember]
        public String outsource_security_role_type_code{ get;set;}
	    [DataMember]
        public SByte can_manage_kb_articles{ get;set;}
	    [DataMember]
        public SByte is_token_authentication_required{ get;set;}
	    [DataMember]
        public SByte is_token_next_login_suspended{ get;set;}
	    [DataMember]
        public Int64? token_suspend_until_time{ get;set;}
	    [DataMember]
        public SByte can_edit_protected_data{ get;set;}
	    [DataMember]
        public SByte can_view_protected_data{ get;set;}
	    [DataMember]
        public SByte can_edit_unprotected_data{ get;set;}
	    [DataMember]
        public SByte can_view_unprotected_data{ get;set;}
	    [DataMember]
        public String encrypted_password{ get;set;}
	    [DataMember]
        public SByte allow_send_bulk_email{ get;set;}
	    [DataMember]
        public SByte viewed_bulk_email_video{ get;set;}
	    [DataMember]
        public String authanvil_username{ get;set;}
	    [DataMember]
        public String authanvil_alternate_server_url{ get;set;}
	    [DataMember]
        public Int32? authanvil_alternate_site_id{ get;set;}
	    [DataMember]
        public String last_conversation_status_text{ get;set;}
	    [DataMember]
        public DateTime? last_conversation_status_time{ get;set;}
	    [DataMember]
        public DateTime? last_conversation_status_expires_time{ get;set;}
	    [DataMember]
        public String quickbooks_vendor_number{ get;set;}
	    [DataMember]
        public SByte is_required_to_submit_timesheets{ get;set;}
	    [DataMember]
        public String narrative_full_name{ get;set;}
	    [DataMember]
        public String sorting_full_name{ get;set;}
	    [DataMember]
        public String password_reset_guid{ get;set;}
	    [DataMember]
        public DateTime? password_reset_guid_expiration_time{ get;set;}
	    [DataMember]
        public Int32? name_salutation_id{ get;set;}
	    [DataMember]
        public Int32? name_suffix_id{ get;set;}
	    [DataMember]
        public DateTime time_sheet_start_date{ get;set;}

       
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
    public class sys_resource_dal : BaseDAL<sys_resource>
    {
    }
}

*/
